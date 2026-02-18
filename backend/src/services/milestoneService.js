const ProbationRecord = require('../models/ProbationRecord');
const AuditLog = require('../models/AuditLog');
const { ApiError } = require('../middleware/errorHandler');

/**
 * Valid milestone status transitions
 */
const VALID_TRANSITIONS = {
  upcoming: ['pending_self', 'overdue'],
  pending_self: ['pending_supervisor', 'overdue'],
  pending_supervisor: ['pending_approval', 'overdue'],
  pending_approval: ['passed', 'failed'],
  passed: [], // Terminal state
  failed: [], // Terminal state
  overdue: ['pending_self'], // Can restart from overdue
};

/**
 * Validate milestone status transition
 * @param {string} currentStatus - Current status
 * @param {string} newStatus - New status
 * @returns {boolean} Whether transition is valid
 */
const isValidTransition = (currentStatus, newStatus) => {
  const validNextStates = VALID_TRANSITIONS[currentStatus] || [];
  return validNextStates.includes(newStatus);
};

/**
 * Get milestone from probation record
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day (30, 60, 90, 119)
 * @returns {Promise<{record: Object, milestone: Object, index: number}>}
 */
const getMilestone = async (probationRecordId, day) => {
  const record = await ProbationRecord.findById(probationRecordId)
    .populate('employeeId', 'employeeId email name')
    .populate('supervisorId', 'employeeId email name');

  if (!record) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const milestoneIndex = record.milestones.findIndex((m) => m.day === day);

  if (milestoneIndex === -1) {
    throw new ApiError(404, `ไม่พบ Milestone วันที่ ${day}`);
  }

  return {
    record,
    milestone: record.milestones[milestoneIndex],
    index: milestoneIndex,
  };
};

/**
 * Update milestone status
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day
 * @param {string} newStatus - New status
 * @param {string} userId - User making the change
 * @param {Object} metadata - Additional metadata
 * @returns {Promise<Object>} Updated probation record
 */
const updateMilestoneStatus = async (
  probationRecordId,
  day,
  newStatus,
  userId,
  metadata = {}
) => {
  const { record, milestone, index } = await getMilestone(probationRecordId, day);

  const oldStatus = milestone.status;

  // Validate transition
  if (!isValidTransition(oldStatus, newStatus)) {
    throw new ApiError(
      400,
      `ไม่สามารถเปลี่ยนสถานะจาก ${oldStatus} เป็น ${newStatus} ได้`
    );
  }

  // Update milestone status
  record.milestones[index].status = newStatus;
  await record.save();

  // Log action
  await AuditLog.log({
    action: 'milestone.status_changed',
    userId,
    targetType: 'milestone',
    targetId: record._id,
    changes: {
      before: { day, status: oldStatus },
      after: { day, status: newStatus },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return record;
};

/**
 * Approve milestone
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day
 * @param {string} userId - Supervisor user ID
 * @param {Object} options - Additional options
 * @returns {Promise<Object>} Updated probation record
 */
const approveMilestone = async (
  probationRecordId,
  day,
  userId,
  options = {}
) => {
  const { comment, metadata = {} } = options;
  const { record, milestone, index } = await getMilestone(probationRecordId, day);

  // Check current status
  if (milestone.status !== 'pending_approval') {
    throw new ApiError(400, 'Milestone ไม่อยู่ในสถานะรอยอมรับ');
  }

  // Check if both assessments are complete
  if (!milestone.selfAssessment || !milestone.supervisorAssessment) {
    throw new ApiError(400, 'ยังไม่มีข้อมูลการประเมินครบถ้วน');
  }

  // Update milestone
  record.milestones[index].status = 'passed';
  record.milestones[index].approvedAt = new Date();
  record.milestones[index].approvedBy = userId;

  // Check if all milestones are passed and update probation status
  const allPassed = record.milestones.every(
    (m, i) => i === index || m.status === 'passed'
  );

  if (allPassed) {
    record.status = 'pending_decision';
  }

  await record.save();

  // Log action
  await AuditLog.log({
    action: 'milestone.approved',
    userId,
    targetType: 'milestone',
    targetId: record._id,
    changes: {
      after: { day, status: 'passed', comment },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return record;
};

/**
 * Reject milestone
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day
 * @param {string} userId - Supervisor user ID
 * @param {Object} options - Additional options
 * @returns {Promise<Object>} Updated probation record
 */
const rejectMilestone = async (
  probationRecordId,
  day,
  userId,
  options = {}
) => {
  const { reason, metadata = {} } = options;

  if (!reason || reason.trim().length < 10) {
    throw new ApiError(400, 'กรุณาระบุเหตุผลอย่างน้อย 10 ตัวอักษร');
  }

  const { record, milestone, index } = await getMilestone(probationRecordId, day);

  // Check current status
  if (milestone.status !== 'pending_approval') {
    throw new ApiError(400, 'Milestone ไม่อยู่ในสถานะรอยอมรับ');
  }

  // Update milestone
  record.milestones[index].status = 'failed';
  record.milestones[index].rejectionReason = reason.trim();
  record.milestones[index].approvedAt = new Date();
  record.milestones[index].approvedBy = userId;

  await record.save();

  // Log action
  await AuditLog.log({
    action: 'milestone.rejected',
    userId,
    targetType: 'milestone',
    targetId: record._id,
    changes: {
      after: { day, status: 'failed', reason },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return record;
};

/**
 * Check and update overdue milestones
 * @returns {Promise<number>} Number of milestones marked as overdue
 */
const checkOverdueMilestones = async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  // Find records with upcoming or pending milestones that are past due
  const records = await ProbationRecord.find({
    status: 'in_progress',
    'milestones.status': { $in: ['upcoming', 'pending_self', 'pending_supervisor'] },
  });

  let overdueCount = 0;

  for (const record of records) {
    let modified = false;

    for (let i = 0; i < record.milestones.length; i++) {
      const milestone = record.milestones[i];
      const dueDate = new Date(milestone.dueDate);
      dueDate.setHours(0, 0, 0, 0);

      // Check if overdue (more than 7 days past due)
      const daysPastDue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));

      if (
        daysPastDue > 7 &&
        ['upcoming', 'pending_self', 'pending_supervisor'].includes(milestone.status)
      ) {
        record.milestones[i].status = 'overdue';
        modified = true;
        overdueCount++;
      }
    }

    if (modified) {
      await record.save();
    }
  }

  return overdueCount;
};

/**
 * Activate milestone when due date approaches
 * @returns {Promise<number>} Number of milestones activated
 */
const activateDueMilestones = async () => {
  const today = new Date();
  const sevenDaysFromNow = new Date(today);
  sevenDaysFromNow.setDate(sevenDaysFromNow.getDate() + 7);

  // Find records with upcoming milestones within 7 days
  const records = await ProbationRecord.find({
    status: 'in_progress',
    'milestones.status': 'upcoming',
    'milestones.dueDate': { $lte: sevenDaysFromNow },
  });

  let activatedCount = 0;

  for (const record of records) {
    let modified = false;

    for (let i = 0; i < record.milestones.length; i++) {
      const milestone = record.milestones[i];

      if (
        milestone.status === 'upcoming' &&
        new Date(milestone.dueDate) <= sevenDaysFromNow
      ) {
        // Only activate if previous milestones are passed
        const previousMilestones = record.milestones.slice(0, i);
        const allPreviousPassed = previousMilestones.every(
          (m) => m.status === 'passed'
        );

        if (allPreviousPassed || i === 0) {
          record.milestones[i].status = 'pending_self';
          modified = true;
          activatedCount++;
        }
      }
    }

    if (modified) {
      await record.save();
    }
  }

  return activatedCount;
};

/**
 * Get milestones pending approval for a supervisor
 * @param {string} supervisorId - Supervisor user ID
 * @returns {Promise<Array>} Array of pending milestones
 */
const getPendingApprovals = async (supervisorId) => {
  const records = await ProbationRecord.find({
    supervisorId,
    status: 'in_progress',
    'milestones.status': 'pending_approval',
  })
    .populate('employeeId', 'employeeId email name department')
    .lean();

  const pendingApprovals = [];

  for (const record of records) {
    for (const milestone of record.milestones) {
      if (milestone.status === 'pending_approval') {
        pendingApprovals.push({
          probationRecordId: record._id,
          employee: record.employeeId,
          milestone: {
            day: milestone.day,
            dueDate: milestone.dueDate,
            status: milestone.status,
            selfAssessment: milestone.selfAssessment,
            supervisorAssessment: milestone.supervisorAssessment,
          },
        });
      }
    }
  }

  return pendingApprovals;
};

module.exports = {
  VALID_TRANSITIONS,
  isValidTransition,
  getMilestone,
  updateMilestoneStatus,
  approveMilestone,
  rejectMilestone,
  checkOverdueMilestones,
  activateDueMilestones,
  getPendingApprovals,
};
