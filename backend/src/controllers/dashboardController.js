const ProbationRecord = require('../models/ProbationRecord');
const User = require('../models/User');
const milestoneService = require('../services/milestoneService');
const { asyncHandler } = require('../middleware/errorHandler');
const { successResponse } = require('../utils/response');

/**
 * @desc    Get supervisor dashboard data
 * @route   GET /api/v1/dashboard/supervisor
 * @access  Private (Supervisor)
 */
const getSupervisorDashboard = asyncHandler(async (req, res) => {
  const supervisorId = req.userId;

  // Get all probation records for this supervisor
  const records = await ProbationRecord.find({ supervisorId })
    .populate('employeeId', 'employeeId email name department')
    .lean();

  // Calculate statistics
  const stats = {
    total: records.length,
    pendingKpi: 0,
    inProgress: 0,
    pendingDecision: 0,
    passed: 0,
    failed: 0,
    resigned: 0,
  };

  const upcomingMilestones = [];
  const pendingApprovals = [];
  const overdueItems = [];

  const today = new Date();

  for (const record of records) {
    // Count by status
    switch (record.status) {
      case 'pending_kpi':
        stats.pendingKpi++;
        break;
      case 'in_progress':
        stats.inProgress++;
        break;
      case 'pending_decision':
        stats.pendingDecision++;
        break;
      case 'passed':
        stats.passed++;
        break;
      case 'failed':
        stats.failed++;
        break;
      case 'resigned':
      case 'terminated':
        stats.resigned++;
        break;
    }

    // Process milestones
    for (const milestone of record.milestones) {
      const dueDate = new Date(milestone.dueDate);
      const daysUntilDue = Math.ceil((dueDate - today) / (1000 * 60 * 60 * 24));

      // Pending approvals
      if (milestone.status === 'pending_approval') {
        pendingApprovals.push({
          probationRecordId: record._id,
          employee: record.employeeId,
          milestone: {
            day: milestone.day,
            dueDate: milestone.dueDate,
            status: milestone.status,
          },
        });
      }

      // Upcoming milestones (within 7 days)
      if (
        milestone.status === 'upcoming' &&
        daysUntilDue <= 7 &&
        daysUntilDue > 0
      ) {
        upcomingMilestones.push({
          probationRecordId: record._id,
          employee: record.employeeId,
          milestone: {
            day: milestone.day,
            dueDate: milestone.dueDate,
            daysUntilDue,
          },
        });
      }

      // Overdue items
      if (milestone.status === 'overdue') {
        overdueItems.push({
          probationRecordId: record._id,
          employee: record.employeeId,
          milestone: {
            day: milestone.day,
            dueDate: milestone.dueDate,
            daysOverdue: Math.abs(daysUntilDue),
          },
        });
      }
    }
  }

  // Sort by urgency
  upcomingMilestones.sort((a, b) => a.milestone.daysUntilDue - b.milestone.daysUntilDue);
  overdueItems.sort((a, b) => b.milestone.daysOverdue - a.milestone.daysOverdue);

  return successResponse(res, 200, 'Success', {
    stats,
    pendingApprovals,
    upcomingMilestones: upcomingMilestones.slice(0, 5),
    overdueItems: overdueItems.slice(0, 5),
    recentRecords: records
      .filter((r) => r.status === 'in_progress')
      .slice(0, 5)
      .map((r) => ({
        id: r._id,
        employee: r.employeeId,
        status: r.status,
        daysRemaining: Math.ceil(
          (new Date(r.endDate) - today) / (1000 * 60 * 60 * 24)
        ),
        progressPercentage: Math.min(
          100,
          Math.max(
            0,
            Math.round(
              ((today - new Date(r.startDate)) /
                (new Date(r.endDate) - new Date(r.startDate))) *
                100
            )
          )
        ),
      })),
  });
});

/**
 * @desc    Get HR dashboard data
 * @route   GET /api/v1/dashboard/hr
 * @access  Private (HR Admin)
 */
const getHrDashboard = asyncHandler(async (req, res) => {
  const today = new Date();

  // Get all probation records
  const records = await ProbationRecord.find({})
    .populate('employeeId', 'employeeId email name department')
    .populate('supervisorId', 'employeeId email name')
    .lean();

  // Calculate statistics
  const stats = {
    total: records.length,
    pendingKpi: 0,
    inProgress: 0,
    pendingDecision: 0,
    passed: 0,
    failed: 0,
    resigned: 0,
  };

  const bottlenecks = [];
  const pendingDecisions = [];
  const overdueItems = [];
  const byDepartment = {};

  for (const record of records) {
    // Count by status
    switch (record.status) {
      case 'pending_kpi':
        stats.pendingKpi++;
        break;
      case 'in_progress':
        stats.inProgress++;
        break;
      case 'pending_decision':
        stats.pendingDecision++;
        pendingDecisions.push({
          id: record._id,
          employee: record.employeeId,
          supervisor: record.supervisorId,
          daysRemaining: Math.ceil(
            (new Date(record.endDate) - today) / (1000 * 60 * 60 * 24)
          ),
        });
        break;
      case 'passed':
        stats.passed++;
        break;
      case 'failed':
        stats.failed++;
        break;
      case 'resigned':
      case 'terminated':
        stats.resigned++;
        break;
    }

    // Count by department
    const dept = record.employeeId?.department || 'Unknown';
    if (!byDepartment[dept]) {
      byDepartment[dept] = { total: 0, passed: 0, failed: 0, inProgress: 0 };
    }
    byDepartment[dept].total++;
    if (record.status === 'passed') byDepartment[dept].passed++;
    if (record.status === 'failed') byDepartment[dept].failed++;
    if (['pending_kpi', 'in_progress', 'pending_decision'].includes(record.status)) {
      byDepartment[dept].inProgress++;
    }

    // Find bottlenecks
    for (const milestone of record.milestones) {
      const dueDate = new Date(milestone.dueDate);
      const daysOverdue = Math.ceil((today - dueDate) / (1000 * 60 * 60 * 24));

      // Overdue milestones
      if (
        daysOverdue > 3 &&
        ['pending_self', 'pending_supervisor', 'pending_approval'].includes(
          milestone.status
        )
      ) {
        bottlenecks.push({
          type: 'milestone_overdue',
          probationRecordId: record._id,
          employee: record.employeeId,
          supervisor: record.supervisorId,
          milestone: {
            day: milestone.day,
            status: milestone.status,
            daysOverdue,
          },
        });
      }

      if (milestone.status === 'overdue') {
        overdueItems.push({
          probationRecordId: record._id,
          employee: record.employeeId,
          supervisor: record.supervisorId,
          milestone: {
            day: milestone.day,
            dueDate: milestone.dueDate,
          },
        });
      }
    }

    // Pending KPI for too long (more than 7 days)
    if (record.status === 'pending_kpi') {
      const daysSinceStart = Math.ceil(
        (today - new Date(record.startDate)) / (1000 * 60 * 60 * 24)
      );
      if (daysSinceStart > 7) {
        bottlenecks.push({
          type: 'pending_kpi_too_long',
          probationRecordId: record._id,
          employee: record.employeeId,
          supervisor: record.supervisorId,
          daysSinceStart,
        });
      }
    }
  }

  // Sort bottlenecks by severity
  bottlenecks.sort((a, b) => {
    if (a.type === 'milestone_overdue' && b.type === 'milestone_overdue') {
      return b.milestone.daysOverdue - a.milestone.daysOverdue;
    }
    return 0;
  });

  return successResponse(res, 200, 'Success', {
    stats,
    bottlenecks: bottlenecks.slice(0, 10),
    pendingDecisions: pendingDecisions.slice(0, 10),
    overdueItems: overdueItems.slice(0, 5),
    byDepartment,
    passRate:
      stats.passed + stats.failed > 0
        ? Math.round((stats.passed / (stats.passed + stats.failed)) * 100)
        : 0,
  });
});

/**
 * @desc    Get employee dashboard data
 * @route   GET /api/v1/dashboard/employee
 * @access  Private (Employee)
 */
const getEmployeeDashboard = asyncHandler(async (req, res) => {
  const record = await ProbationRecord.findOne({ employeeId: req.userId })
    .populate('employeeId', 'employeeId email name department')
    .populate('supervisorId', 'employeeId email name')
    .lean();

  if (!record) {
    return successResponse(res, 200, 'No probation record found', {
      hasRecord: false,
    });
  }

  const today = new Date();
  const daysRemaining = Math.max(
    0,
    Math.ceil((new Date(record.endDate) - today) / (1000 * 60 * 60 * 24))
  );
  const totalDays = Math.ceil(
    (new Date(record.endDate) - new Date(record.startDate)) /
      (1000 * 60 * 60 * 24)
  );
  const daysElapsed = totalDays - daysRemaining;
  const progressPercentage = Math.min(
    100,
    Math.max(0, Math.round((daysElapsed / totalDays) * 100))
  );

  // Find current/next milestone
  let currentMilestone = null;
  let nextMilestone = null;

  for (const milestone of record.milestones) {
    if (['pending_self', 'pending_supervisor', 'pending_approval'].includes(milestone.status)) {
      currentMilestone = {
        ...milestone,
        daysUntilDue: Math.ceil(
          (new Date(milestone.dueDate) - today) / (1000 * 60 * 60 * 24)
        ),
      };
      break;
    }
    if (milestone.status === 'upcoming' && !nextMilestone) {
      nextMilestone = {
        ...milestone,
        daysUntilDue: Math.ceil(
          (new Date(milestone.dueDate) - today) / (1000 * 60 * 60 * 24)
        ),
      };
    }
  }

  // Count milestone progress
  const milestoneStats = {
    total: record.milestones.length,
    passed: record.milestones.filter((m) => m.status === 'passed').length,
    failed: record.milestones.filter((m) => m.status === 'failed').length,
    pending: record.milestones.filter((m) =>
      ['pending_self', 'pending_supervisor', 'pending_approval'].includes(m.status)
    ).length,
  };

  return successResponse(res, 200, 'Success', {
    hasRecord: true,
    record: {
      id: record._id,
      status: record.status,
      startDate: record.startDate,
      endDate: record.endDate,
      probationDays: record.probationDays,
    },
    supervisor: record.supervisorId,
    progress: {
      daysRemaining,
      daysElapsed,
      totalDays,
      progressPercentage,
    },
    kpis: record.kpis,
    milestones: record.milestones,
    milestoneStats,
    currentMilestone,
    nextMilestone,
    finalDecision: record.finalDecision,
  });
});

module.exports = {
  getSupervisorDashboard,
  getHrDashboard,
  getEmployeeDashboard,
};
