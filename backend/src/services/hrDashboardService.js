const ProbationRecord = require('../models/ProbationRecord');
const User = require('../models/User');
const logger = require('../utils/logger');

/**
 * HR Dashboard Service
 * Provides aggregated data and bottleneck detection for HR
 */

/**
 * Get HR dashboard summary statistics
 */
const getDashboardSummary = async () => {
  try {
    const now = new Date();

    // Get all probation records with employee info
    const records = await ProbationRecord.find()
      .populate('employeeId', 'name email department position')
      .populate('supervisorId', 'name email')
      .lean();

    // Calculate summary statistics
    const summary = {
      total: records.length,
      byStatus: {
        pending_kpi: 0,
        in_progress: 0,
        passed: 0,
        failed: 0,
        extended: 0,
      },
      recentlyStarted: 0, // Started in last 7 days
      endingSoon: 0, // Ending in next 14 days
      overdue: 0, // Has overdue milestones
      needsAttention: 0, // Bottlenecks
    };

    const sevenDaysAgo = new Date(now);
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const fourteenDaysFromNow = new Date(now);
    fourteenDaysFromNow.setDate(fourteenDaysFromNow.getDate() + 14);

    for (const record of records) {
      // Count by status
      if (summary.byStatus.hasOwnProperty(record.status)) {
        summary.byStatus[record.status]++;
      }

      // Recently started
      if (new Date(record.startDate) >= sevenDaysAgo) {
        summary.recentlyStarted++;
      }

      // Ending soon (for active records)
      if (record.status === 'in_progress') {
        const endDate = new Date(record.endDate);
        if (endDate <= fourteenDaysFromNow) {
          summary.endingSoon++;
        }
      }

      // Has overdue milestones
      if (record.milestones && record.milestones.some((m) => m.status === 'overdue')) {
        summary.overdue++;
      }
    }

    // Needs attention = pending_kpi + overdue
    summary.needsAttention = summary.byStatus.pending_kpi + summary.overdue;

    return summary;
  } catch (error) {
    logger.error('Error getting dashboard summary', { error: error.message });
    throw error;
  }
};

/**
 * Detect bottlenecks in probation process
 * Bottleneck conditions:
 * 1. KPI not assigned after 5+ days of start
 * 2. Milestone overdue for 3+ days
 * 3. Pending approval for 3+ days
 * 4. Probation ending in 7 days without all milestones completed
 */
const detectBottlenecks = async () => {
  try {
    const now = new Date();
    const bottlenecks = [];

    // Find all in-progress and pending_kpi records
    const records = await ProbationRecord.find({
      status: { $in: ['pending_kpi', 'in_progress'] },
    })
      .populate('employeeId', 'name email department position')
      .populate('supervisorId', 'name email')
      .lean();

    for (const record of records) {
      const employee = record.employeeId;
      if (!employee) continue;

      // 1. KPI not assigned after 5+ days
      if (record.status === 'pending_kpi') {
        const daysSinceStart = Math.ceil(
          (now - new Date(record.startDate)) / (1000 * 60 * 60 * 24)
        );

        if (daysSinceStart >= 5) {
          bottlenecks.push({
            type: 'kpi_not_assigned',
            severity: daysSinceStart >= 10 ? 'critical' : 'warning',
            recordId: record._id,
            employeeId: employee._id,
            employeeName: employee.name || employee.email,
            department: employee.department,
            supervisorId: record.supervisorId?._id,
            supervisorName: record.supervisorId?.name || record.supervisorId?.email,
            message: `KPI ยังไม่ถูกกำหนดเป็นเวลา ${daysSinceStart} วัน`,
            daysPending: daysSinceStart,
            createdAt: now,
          });
        }
      }

      // 2. Milestone overdue for 3+ days
      if (record.milestones) {
        for (const milestone of record.milestones) {
          if (milestone.status === 'overdue') {
            const dueDate = new Date(milestone.dueDate);
            const daysOverdue = Math.ceil((now - dueDate) / (1000 * 60 * 60 * 24));

            if (daysOverdue >= 3) {
              bottlenecks.push({
                type: 'milestone_overdue',
                severity: daysOverdue >= 7 ? 'critical' : 'warning',
                recordId: record._id,
                employeeId: employee._id,
                employeeName: employee.name || employee.email,
                department: employee.department,
                supervisorId: record.supervisorId?._id,
                supervisorName: record.supervisorId?.name || record.supervisorId?.email,
                milestoneDay: milestone.day,
                message: `Milestone Day ${milestone.day} เกินกำหนด ${daysOverdue} วัน`,
                daysOverdue,
                createdAt: now,
              });
            }
          }

          // 3. Pending approval for 3+ days
          if (milestone.status === 'pending_approval') {
            const submittedAt = milestone.supervisorAssessment?.submittedAt;
            if (submittedAt) {
              const daysPending = Math.ceil(
                (now - new Date(submittedAt)) / (1000 * 60 * 60 * 24)
              );

              if (daysPending >= 3) {
                bottlenecks.push({
                  type: 'pending_approval',
                  severity: daysPending >= 5 ? 'critical' : 'warning',
                  recordId: record._id,
                  employeeId: employee._id,
                  employeeName: employee.name || employee.email,
                  department: employee.department,
                  supervisorId: record.supervisorId?._id,
                  supervisorName: record.supervisorId?.name || record.supervisorId?.email,
                  milestoneDay: milestone.day,
                  message: `Milestone Day ${milestone.day} รอการอนุมัติมา ${daysPending} วัน`,
                  daysPending,
                  createdAt: now,
                });
              }
            }
          }
        }
      }

      // 4. Probation ending soon without all milestones completed
      if (record.status === 'in_progress') {
        const endDate = new Date(record.endDate);
        const daysUntilEnd = Math.ceil((endDate - now) / (1000 * 60 * 60 * 24));

        if (daysUntilEnd <= 7 && daysUntilEnd >= 0) {
          const incompleteMilestones = record.milestones?.filter(
            (m) => !['passed', 'failed'].includes(m.status)
          );

          if (incompleteMilestones && incompleteMilestones.length > 0) {
            bottlenecks.push({
              type: 'ending_soon_incomplete',
              severity: daysUntilEnd <= 3 ? 'critical' : 'warning',
              recordId: record._id,
              employeeId: employee._id,
              employeeName: employee.name || employee.email,
              department: employee.department,
              supervisorId: record.supervisorId?._id,
              supervisorName: record.supervisorId?.name || record.supervisorId?.email,
              message: `ทดลองงานจะสิ้นสุดใน ${daysUntilEnd} วัน แต่ยังมี ${incompleteMilestones.length} Milestone ที่ยังไม่เสร็จ`,
              daysUntilEnd,
              incompleteMilestones: incompleteMilestones.map((m) => m.day),
              createdAt: now,
            });
          }
        }
      }
    }

    // Sort by severity (critical first), then by date
    bottlenecks.sort((a, b) => {
      if (a.severity === 'critical' && b.severity !== 'critical') return -1;
      if (a.severity !== 'critical' && b.severity === 'critical') return 1;
      return 0;
    });

    return bottlenecks;
  } catch (error) {
    logger.error('Error detecting bottlenecks', { error: error.message });
    throw error;
  }
};

/**
 * Get all probation records with filtering and pagination
 */
const getAllRecords = async (options = {}) => {
  try {
    const {
      page = 1,
      limit = 20,
      status,
      department,
      supervisorId,
      search,
      sortBy = 'startDate',
      sortOrder = 'desc',
    } = options;

    // Build filter
    const filter = {};

    if (status) {
      filter.status = status;
    }

    if (supervisorId) {
      filter.supervisorId = supervisorId;
    }

    // Build query
    let query = ProbationRecord.find(filter)
      .populate('employeeId', 'name email department position avatar')
      .populate('supervisorId', 'name email');

    // Apply department filter (from populated employeeId)
    // This requires post-filtering or aggregation

    // Apply sorting
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'asc' ? 1 : -1;
    query = query.sort(sortOptions);

    // Apply pagination
    const skip = (page - 1) * limit;
    query = query.skip(skip).limit(limit);

    const records = await query.lean();
    const total = await ProbationRecord.countDocuments(filter);

    // Calculate additional fields for each record
    const now = new Date();
    const enrichedRecords = records.map((record) => {
      const startDate = new Date(record.startDate);
      const endDate = new Date(record.endDate);
      const totalDays = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
      const elapsedDays = Math.ceil((now - startDate) / (1000 * 60 * 60 * 24));
      const remainingDays = Math.max(0, Math.ceil((endDate - now) / (1000 * 60 * 60 * 24)));
      const progressPercentage = Math.min(100, Math.round((elapsedDays / totalDays) * 100));

      // Calculate milestone progress
      const completedMilestones = record.milestones?.filter((m) =>
        ['passed', 'failed'].includes(m.status)
      ).length || 0;
      const totalMilestones = record.milestones?.length || 0;

      // Check for issues
      const hasOverdue = record.milestones?.some((m) => m.status === 'overdue') || false;
      const hasPendingApproval =
        record.milestones?.some((m) => m.status === 'pending_approval') || false;

      return {
        ...record,
        totalDays,
        elapsedDays,
        remainingDays,
        progressPercentage,
        completedMilestones,
        totalMilestones,
        hasOverdue,
        hasPendingApproval,
        isAtRisk: hasOverdue || (remainingDays <= 7 && completedMilestones < totalMilestones),
      };
    });

    // Post-filter by department if specified
    let filteredRecords = enrichedRecords;
    if (department) {
      filteredRecords = enrichedRecords.filter(
        (r) => r.employeeId?.department === department
      );
    }

    // Post-filter by search term
    if (search) {
      const searchLower = search.toLowerCase();
      filteredRecords = filteredRecords.filter((r) => {
        const name = r.employeeId?.name?.toLowerCase() || '';
        const email = r.employeeId?.email?.toLowerCase() || '';
        return name.includes(searchLower) || email.includes(searchLower);
      });
    }

    return {
      records: filteredRecords,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  } catch (error) {
    logger.error('Error getting all records', { error: error.message });
    throw error;
  }
};

/**
 * Get department statistics
 */
const getDepartmentStats = async () => {
  try {
    const records = await ProbationRecord.find({
      status: { $in: ['pending_kpi', 'in_progress'] },
    })
      .populate('employeeId', 'department')
      .lean();

    const departmentStats = {};

    for (const record of records) {
      const department = record.employeeId?.department || 'ไม่ระบุ';

      if (!departmentStats[department]) {
        departmentStats[department] = {
          total: 0,
          pending_kpi: 0,
          in_progress: 0,
          hasOverdue: 0,
          atRisk: 0,
        };
      }

      departmentStats[department].total++;

      if (record.status === 'pending_kpi') {
        departmentStats[department].pending_kpi++;
      } else {
        departmentStats[department].in_progress++;
      }

      if (record.milestones?.some((m) => m.status === 'overdue')) {
        departmentStats[department].hasOverdue++;
      }

      // Check if at risk
      const now = new Date();
      const endDate = new Date(record.endDate);
      const remainingDays = Math.ceil((endDate - now) / (1000 * 60 * 60 * 24));
      const completedMilestones =
        record.milestones?.filter((m) => ['passed', 'failed'].includes(m.status)).length || 0;
      const totalMilestones = record.milestones?.length || 0;

      if (remainingDays <= 14 && completedMilestones < totalMilestones) {
        departmentStats[department].atRisk++;
      }
    }

    // Convert to array and sort by total
    const result = Object.entries(departmentStats)
      .map(([department, stats]) => ({
        department,
        ...stats,
      }))
      .sort((a, b) => b.total - a.total);

    return result;
  } catch (error) {
    logger.error('Error getting department stats', { error: error.message });
    throw error;
  }
};

/**
 * Get supervisor workload
 */
const getSupervisorWorkload = async () => {
  try {
    const records = await ProbationRecord.find({
      status: { $in: ['pending_kpi', 'in_progress'] },
    })
      .populate('supervisorId', 'name email department')
      .lean();

    const supervisorStats = {};

    for (const record of records) {
      const supervisor = record.supervisorId;
      if (!supervisor) continue;

      const supervisorId = supervisor._id.toString();

      if (!supervisorStats[supervisorId]) {
        supervisorStats[supervisorId] = {
          supervisorId: supervisor._id,
          name: supervisor.name || supervisor.email,
          department: supervisor.department,
          total: 0,
          pending_kpi: 0,
          in_progress: 0,
          pendingApproval: 0,
          overdue: 0,
        };
      }

      supervisorStats[supervisorId].total++;

      if (record.status === 'pending_kpi') {
        supervisorStats[supervisorId].pending_kpi++;
      } else {
        supervisorStats[supervisorId].in_progress++;
      }

      // Count pending approvals
      const pendingApprovalCount =
        record.milestones?.filter((m) => m.status === 'pending_approval').length || 0;
      supervisorStats[supervisorId].pendingApproval += pendingApprovalCount;

      // Count overdue
      const overdueCount = record.milestones?.filter((m) => m.status === 'overdue').length || 0;
      supervisorStats[supervisorId].overdue += overdueCount;
    }

    // Convert to array and sort by total
    const result = Object.values(supervisorStats).sort((a, b) => b.total - a.total);

    return result;
  } catch (error) {
    logger.error('Error getting supervisor workload', { error: error.message });
    throw error;
  }
};

/**
 * Get probation timeline summary
 */
const getTimelineSummary = async (days = 30) => {
  try {
    const now = new Date();
    const startDate = new Date(now);
    startDate.setDate(startDate.getDate() - days);

    // Get records that were active in this period
    const records = await ProbationRecord.find({
      $or: [
        { startDate: { $gte: startDate } },
        { status: 'in_progress' },
        { updatedAt: { $gte: startDate } },
      ],
    }).lean();

    // Group by week
    const weeklyStats = {};
    for (let i = 0; i < days; i += 7) {
      const weekStart = new Date(now);
      weekStart.setDate(weekStart.getDate() - i - 7);
      const weekEnd = new Date(now);
      weekEnd.setDate(weekEnd.getDate() - i);

      const weekKey = weekStart.toISOString().split('T')[0];

      weeklyStats[weekKey] = {
        weekStart: weekStart.toISOString(),
        weekEnd: weekEnd.toISOString(),
        started: 0,
        passed: 0,
        failed: 0,
        milestonesPassed: 0,
        milestonesFailed: 0,
      };
    }

    for (const record of records) {
      const recordStart = new Date(record.startDate);

      // Count new starts
      for (const [weekKey, weekStats] of Object.entries(weeklyStats)) {
        const weekStart = new Date(weekStats.weekStart);
        const weekEnd = new Date(weekStats.weekEnd);

        if (recordStart >= weekStart && recordStart < weekEnd) {
          weekStats.started++;
        }

        // Count final outcomes
        if (record.status === 'passed' && record.updatedAt) {
          const passedAt = new Date(record.updatedAt);
          if (passedAt >= weekStart && passedAt < weekEnd) {
            weekStats.passed++;
          }
        }

        if (record.status === 'failed' && record.updatedAt) {
          const failedAt = new Date(record.updatedAt);
          if (failedAt >= weekStart && failedAt < weekEnd) {
            weekStats.failed++;
          }
        }
      }
    }

    return Object.values(weeklyStats).reverse();
  } catch (error) {
    logger.error('Error getting timeline summary', { error: error.message });
    throw error;
  }
};

module.exports = {
  getDashboardSummary,
  detectBottlenecks,
  getAllRecords,
  getDepartmentStats,
  getSupervisorWorkload,
  getTimelineSummary,
};
