const ProbationRecord = require('../models/ProbationRecord');
const notificationService = require('./notificationService');
const logger = require('../utils/logger');

/**
 * Probation Service
 * Handles probation business logic and final decision validation
 */

/**
 * Valid status transitions
 */
const STATUS_TRANSITIONS = {
  pending_kpi: ['in_progress', 'resigned', 'terminated'],
  in_progress: ['pending_decision', 'resigned', 'terminated'],
  pending_decision: ['passed', 'failed', 'extended', 'resigned', 'terminated'],
  extended: ['passed', 'failed', 'resigned', 'terminated'],
};

/**
 * Final decision types
 */
const FINAL_DECISIONS = ['passed', 'failed'];

/**
 * Validate status transition
 * @param {string} currentStatus - Current status
 * @param {string} newStatus - New status to transition to
 * @returns {boolean}
 */
const isValidTransition = (currentStatus, newStatus) => {
  const validNext = STATUS_TRANSITIONS[currentStatus];
  if (!validNext) {return false;}
  return validNext.includes(newStatus);
};

/**
 * Validate final decision
 * Checks if all milestones are completed before making final decision
 * @param {Object} record - Probation record
 * @param {string} decision - 'passed' or 'failed'
 * @returns {{ valid: boolean, reason?: string }}
 */
const validateFinalDecision = (record, decision) => {
  // Check if status allows final decision
  if (!['pending_decision', 'extended'].includes(record.status)) {
    return {
      valid: false,
      reason: `ไม่สามารถตัดสินใจได้เมื่อสถานะเป็น ${record.status}`,
    };
  }

  // For 'passed' decision, check all milestones
  if (decision === 'passed') {
    // Count milestone results
    const passedMilestones = record.milestones.filter(
      (m) => m.status === 'passed'
    ).length;
    const failedMilestones = record.milestones.filter(
      (m) => m.status === 'failed'
    ).length;
    const totalMilestones = record.milestones.length;
    const completedMilestones = passedMilestones + failedMilestones;

    // All milestones must be completed
    if (completedMilestones < totalMilestones) {
      return {
        valid: false,
        reason: `ยังมี Milestone ที่ยังไม่เสร็จ (${completedMilestones}/${totalMilestones})`,
      };
    }

    // Check if more than half passed
    if (passedMilestones < failedMilestones) {
      return {
        valid: false,
        reason: `Milestone ที่ผ่านน้อยกว่าที่ไม่ผ่าน (ผ่าน: ${passedMilestones}, ไม่ผ่าน: ${failedMilestones})`,
      };
    }
  }

  return { valid: true };
};

/**
 * Make final decision
 * @param {string} recordId - Probation record ID
 * @param {string} decision - 'passed' or 'failed'
 * @param {string} decidedBy - User ID who made the decision
 * @param {string} reason - Optional reason
 * @returns {Promise<Object>} Updated record
 */
const makeFinalDecision = async (recordId, decision, decidedBy, reason = null) => {
  const record = await ProbationRecord.findById(recordId)
    .populate('employeeId', 'name email fcmToken')
    .populate('supervisorId', 'name email fcmToken');

  if (!record) {
    throw new Error('ไม่พบข้อมูลการทดลองงาน');
  }

  // Validate decision
  if (!FINAL_DECISIONS.includes(decision)) {
    throw new Error('การตัดสินใจต้องเป็น passed หรือ failed เท่านั้น');
  }

  const validation = validateFinalDecision(record, decision);
  if (!validation.valid) {
    throw new Error(validation.reason);
  }

  // Update record
  record.status = decision;
  record.finalDecision = {
    decision,
    decidedBy,
    decidedAt: new Date(),
    reason,
  };

  await record.save();

  // Send notifications
  await sendFinalDecisionNotifications(record, decision, reason);

  logger.info('Final decision made', {
    recordId,
    decision,
    decidedBy,
  });

  return record;
};

/**
 * Send notifications for final decision
 */
const sendFinalDecisionNotifications = async (record, decision, reason) => {
  const employee = record.employeeId;
  const supervisor = record.supervisorId;

  if (!employee) {return;}

  const isPassed = decision === 'passed';
  const title = isPassed
    ? 'ยินดีด้วย! คุณผ่านการทดลองงาน'
    : 'ผลการทดลองงาน';
  const message = isPassed
    ? 'คุณผ่านการทดลองงานเรียบร้อยแล้ว ยินดีต้อนรับเป็นพนักงานประจำ'
    : reason || 'การทดลองงานของคุณไม่ผ่านเกณฑ์';

  // Notify employee
  try {
    await notificationService.createNotification({
      userId: employee._id,
      type: 'probation_completed',
      title,
      message,
      data: {
        probationRecordId: record._id,
        decision,
      },
      sendPush: true,
      sendEmail: true,
    });
  } catch (error) {
    logger.error('Failed to send employee notification', { error: error.message });
  }

  // Notify supervisor
  if (supervisor) {
    try {
      await notificationService.createNotification({
        userId: supervisor._id,
        type: 'probation_completed',
        title: `ผลการทดลองงาน: ${employee.name || employee.email}`,
        message: isPassed
          ? `${employee.name || employee.email} ผ่านการทดลองงาน`
          : `${employee.name || employee.email} ไม่ผ่านการทดลองงาน`,
        data: {
          probationRecordId: record._id,
          employeeId: employee._id,
          decision,
        },
        sendPush: true,
      });
    } catch (error) {
      logger.error('Failed to send supervisor notification', { error: error.message });
    }
  }
};

/**
 * Extend probation period
 * @param {string} recordId - Probation record ID
 * @param {number} additionalDays - Days to extend
 * @param {string} extendedBy - User ID
 * @param {string} reason - Reason for extension
 */
const extendProbation = async (recordId, additionalDays, extendedBy, reason) => {
  const record = await ProbationRecord.findById(recordId)
    .populate('employeeId', 'name email fcmToken')
    .populate('supervisorId', 'name email fcmToken');

  if (!record) {
    throw new Error('ไม่พบข้อมูลการทดลองงาน');
  }

  if (!['in_progress', 'pending_decision'].includes(record.status)) {
    throw new Error('ไม่สามารถขยายเวลาทดลองงานได้ในสถานะปัจจุบัน');
  }

  // Validate extension days
  if (additionalDays < 1 || additionalDays > 90) {
    throw new Error('สามารถขยายเวลาได้ 1-90 วัน');
  }

  // Update end date
  const oldEndDate = new Date(record.endDate);
  const newEndDate = new Date(oldEndDate);
  newEndDate.setDate(newEndDate.getDate() + additionalDays);

  record.endDate = newEndDate;
  record.probationDays = record.probationDays + additionalDays;
  record.status = 'extended';

  // Record extension
  if (!record.extensions) {
    record.extensions = [];
  }
  record.extensions.push({
    extendedBy,
    extendedAt: new Date(),
    additionalDays,
    reason,
    oldEndDate,
    newEndDate,
  });

  await record.save();

  // Notify employee
  const employee = record.employeeId;
  if (employee) {
    try {
      await notificationService.createNotification({
        userId: employee._id,
        type: 'probation_extended',
        title: 'ขยายเวลาทดลองงาน',
        message: `การทดลองงานของคุณได้รับการขยายเวลาเพิ่ม ${additionalDays} วัน`,
        data: {
          probationRecordId: record._id,
          additionalDays,
          newEndDate: newEndDate.toISOString(),
        },
        sendPush: true,
        sendEmail: true,
      });
    } catch (error) {
      logger.error('Failed to send extension notification', { error: error.message });
    }
  }

  logger.info('Probation extended', {
    recordId,
    additionalDays,
    newEndDate,
    extendedBy,
  });

  return record;
};

/**
 * Get probation summary for an employee
 */
const getProbationSummary = async (recordId) => {
  const record = await ProbationRecord.findById(recordId)
    .populate('employeeId', 'name email department position')
    .populate('supervisorId', 'name email')
    .populate('finalDecision.decidedBy', 'name email')
    .lean();

  if (!record) {
    return null;
  }

  const now = new Date();
  const startDate = new Date(record.startDate);
  const endDate = new Date(record.endDate);

  // Calculate progress
  const totalDays = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
  const elapsedDays = Math.ceil((now - startDate) / (1000 * 60 * 60 * 24));
  const remainingDays = Math.max(0, Math.ceil((endDate - now) / (1000 * 60 * 60 * 24)));
  const progressPercentage = Math.min(100, Math.max(0, Math.round((elapsedDays / totalDays) * 100)));

  // Milestone summary
  const milestoneStats = {
    total: record.milestones.length,
    passed: record.milestones.filter((m) => m.status === 'passed').length,
    failed: record.milestones.filter((m) => m.status === 'failed').length,
    pending: record.milestones.filter((m) =>
      ['pending_self', 'pending_supervisor', 'pending_approval'].includes(m.status)
    ).length,
    overdue: record.milestones.filter((m) => m.status === 'overdue').length,
  };

  // Calculate average score
  let totalScore = 0;
  let scoreCount = 0;
  for (const milestone of record.milestones) {
    if (milestone.supervisorAssessment?.averageScore) {
      totalScore += milestone.supervisorAssessment.averageScore;
      scoreCount++;
    }
  }
  const averageScore = scoreCount > 0 ? (totalScore / scoreCount).toFixed(2) : null;

  return {
    ...record,
    progress: {
      totalDays,
      elapsedDays,
      remainingDays,
      progressPercentage,
    },
    milestoneStats,
    averageScore,
    isAtRisk:
      milestoneStats.overdue > 0 ||
      (remainingDays <= 7 && milestoneStats.pending > 0),
    isComplete: ['passed', 'failed'].includes(record.status),
  };
};

module.exports = {
  STATUS_TRANSITIONS,
  FINAL_DECISIONS,
  isValidTransition,
  validateFinalDecision,
  makeFinalDecision,
  extendProbation,
  getProbationSummary,
};
