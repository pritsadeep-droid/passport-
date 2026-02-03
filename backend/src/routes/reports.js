/**
 * Report Routes
 * Handles report generation endpoints
 */

const express = require('express');
const router = express.Router();
const {
  getProbationSummary,
  getEmployeeReport,
  getDepartmentReport,
  getReportTypes,
  getReportStats
} = require('../controllers/reportController');
const { authenticate } = require('../middleware/auth');
const { authorize } = require('../middleware/authorize');
const { reportLimiter } = require('../middleware/rateLimiter');

// All routes require authentication
router.use(authenticate);

/**
 * @route   GET /api/v1/reports/types
 * @desc    Get available report types
 * @access  Private (HR Admin)
 */
router.get(
  '/types',
  authorize('hr_admin'),
  getReportTypes
);

/**
 * @route   GET /api/v1/reports/stats
 * @desc    Get report statistics for dashboard
 * @access  Private (HR Admin)
 */
router.get(
  '/stats',
  authorize('hr_admin'),
  getReportStats
);

/**
 * @route   GET /api/v1/reports/probation-summary
 * @desc    Get probation summary report (PDF or Excel)
 * @access  Private (HR Admin)
 * @query   format - 'pdf' or 'xlsx' (default: pdf)
 * @query   status - Filter by status
 * @query   department - Filter by department
 * @query   startDate - Filter by start date (from)
 * @query   endDate - Filter by start date (to)
 */
router.get(
  '/probation-summary',
  authorize('hr_admin'),
  reportLimiter,
  getProbationSummary
);

/**
 * @route   GET /api/v1/reports/departments
 * @desc    Get department-wise report (Excel only)
 * @access  Private (HR Admin)
 */
router.get(
  '/departments',
  authorize('hr_admin'),
  getDepartmentReport
);

/**
 * @route   GET /api/v1/reports/employee/:employeeId
 * @desc    Get individual employee probation report
 * @access  Private (HR Admin, Supervisor of employee)
 * @query   format - 'pdf' or 'xlsx' (default: pdf)
 */
router.get(
  '/employee/:employeeId',
  authorize('hr_admin', 'supervisor'),
  getEmployeeReport
);

module.exports = router;
