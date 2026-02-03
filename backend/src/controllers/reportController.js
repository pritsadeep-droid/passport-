/**
 * Report Controller
 * Handles report generation endpoints
 */

const { generateEmployeeReport, generateSummaryReport } = require('../services/reportService');
const { generateEmployeeExcel, generateSummaryExcel, generateDepartmentReport } = require('../services/excelService');
const { success, error } = require('../utils/response');
const logger = require('../utils/logger');

/**
 * @desc    Get probation summary report
 * @route   GET /api/v1/reports/probation-summary
 * @access  Private (HR Admin only)
 */
const getProbationSummary = async (req, res) => {
  try {
    const { format = 'pdf', status, department, startDate, endDate } = req.query;

    const filters = {};
    if (status) filters.status = status;
    if (department) filters.department = department;
    if (startDate) filters.startDate = startDate;
    if (endDate) filters.endDate = endDate;

    let buffer;
    let contentType;
    let filename;

    const timestamp = new Date().toISOString().split('T')[0];

    if (format === 'excel' || format === 'xlsx') {
      buffer = await generateSummaryExcel(filters);
      contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      filename = `probation-summary-${timestamp}.xlsx`;
    } else {
      buffer = await generateSummaryReport(filters);
      contentType = 'application/pdf';
      filename = `probation-summary-${timestamp}.pdf`;
    }

    res.setHeader('Content-Type', contentType);
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    res.setHeader('Content-Length', buffer.length);

    logger.info('Summary report generated', {
      userId: req.user._id,
      format,
      filters,
      filename
    });

    return res.send(buffer);
  } catch (err) {
    logger.error('Failed to generate summary report:', err);
    return error(res, 'Failed to generate report', 500);
  }
};

/**
 * @desc    Get individual employee probation report
 * @route   GET /api/v1/reports/employee/:employeeId
 * @access  Private (HR Admin, Supervisor of employee)
 */
const getEmployeeReport = async (req, res) => {
  try {
    const { employeeId } = req.params;
    const { format = 'pdf' } = req.query;

    let buffer;
    let contentType;
    let filename;

    const timestamp = new Date().toISOString().split('T')[0];

    if (format === 'excel' || format === 'xlsx') {
      buffer = await generateEmployeeExcel(employeeId);
      contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      filename = `employee-report-${employeeId}-${timestamp}.xlsx`;
    } else {
      buffer = await generateEmployeeReport(employeeId);
      contentType = 'application/pdf';
      filename = `employee-report-${employeeId}-${timestamp}.pdf`;
    }

    res.setHeader('Content-Type', contentType);
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    res.setHeader('Content-Length', buffer.length);

    logger.info('Employee report generated', {
      userId: req.user._id,
      employeeId,
      format,
      filename
    });

    return res.send(buffer);
  } catch (err) {
    logger.error('Failed to generate employee report:', err);

    if (err.message === 'Probation record not found') {
      return error(res, 'Probation record not found', 404);
    }

    return error(res, 'Failed to generate report', 500);
  }
};

/**
 * @desc    Get department-wise report
 * @route   GET /api/v1/reports/departments
 * @access  Private (HR Admin only)
 */
const getDepartmentReport = async (req, res) => {
  try {
    const buffer = await generateDepartmentReport();

    const timestamp = new Date().toISOString().split('T')[0];
    const filename = `department-report-${timestamp}.xlsx`;

    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    res.setHeader('Content-Length', buffer.length);

    logger.info('Department report generated', {
      userId: req.user._id,
      filename
    });

    return res.send(buffer);
  } catch (err) {
    logger.error('Failed to generate department report:', err);
    return error(res, 'Failed to generate report', 500);
  }
};

/**
 * @desc    Get available report types
 * @route   GET /api/v1/reports/types
 * @access  Private (HR Admin only)
 */
const getReportTypes = async (req, res) => {
  try {
    const reportTypes = [
      {
        id: 'probation-summary',
        name: 'รายงานสรุปการทดลองงาน',
        nameEn: 'Probation Summary Report',
        description: 'สรุปภาพรวมพนักงานทดลองงานทั้งหมด',
        formats: ['pdf', 'xlsx'],
        filters: ['status', 'department', 'startDate', 'endDate']
      },
      {
        id: 'employee',
        name: 'รายงานพนักงานรายบุคคล',
        nameEn: 'Individual Employee Report',
        description: 'รายงานการทดลองงานของพนักงานรายบุคคล',
        formats: ['pdf', 'xlsx'],
        filters: []
      },
      {
        id: 'departments',
        name: 'รายงานแยกตามแผนก',
        nameEn: 'Department Report',
        description: 'รายงานสรุปแยกตามแผนก',
        formats: ['xlsx'],
        filters: []
      }
    ];

    return success(res, reportTypes);
  } catch (err) {
    logger.error('Failed to get report types:', err);
    return error(res, 'Failed to get report types', 500);
  }
};

/**
 * @desc    Get report statistics (for dashboard)
 * @route   GET /api/v1/reports/stats
 * @access  Private (HR Admin only)
 */
const getReportStats = async (req, res) => {
  try {
    const ProbationRecord = require('../models/ProbationRecord');

    const [
      totalRecords,
      statusCounts,
      departmentStats
    ] = await Promise.all([
      ProbationRecord.countDocuments(),
      ProbationRecord.aggregate([
        { $group: { _id: '$status', count: { $sum: 1 } } }
      ]),
      ProbationRecord.aggregate([
        {
          $lookup: {
            from: 'users',
            localField: 'employee',
            foreignField: '_id',
            as: 'employeeData'
          }
        },
        { $unwind: '$employeeData' },
        {
          $group: {
            _id: '$employeeData.department',
            count: { $sum: 1 },
            passed: {
              $sum: { $cond: [{ $eq: ['$status', 'passed'] }, 1, 0] }
            },
            failed: {
              $sum: { $cond: [{ $eq: ['$status', 'failed'] }, 1, 0] }
            },
            inProgress: {
              $sum: { $cond: [{ $eq: ['$status', 'in_progress'] }, 1, 0] }
            }
          }
        },
        { $sort: { count: -1 } }
      ])
    ]);

    // Calculate pass rate
    const completed = statusCounts.filter(s => ['passed', 'failed'].includes(s._id));
    const passedCount = completed.find(s => s._id === 'passed')?.count || 0;
    const totalCompleted = completed.reduce((sum, s) => sum + s.count, 0);
    const passRate = totalCompleted > 0 ? (passedCount / totalCompleted * 100).toFixed(1) : 0;

    const stats = {
      total: totalRecords,
      byStatus: statusCounts.reduce((acc, s) => {
        acc[s._id] = s.count;
        return acc;
      }, {}),
      byDepartment: departmentStats,
      passRate: parseFloat(passRate)
    };

    return success(res, stats);
  } catch (err) {
    logger.error('Failed to get report stats:', err);
    return error(res, 'Failed to get report stats', 500);
  }
};

module.exports = {
  getProbationSummary,
  getEmployeeReport,
  getDepartmentReport,
  getReportTypes,
  getReportStats
};
