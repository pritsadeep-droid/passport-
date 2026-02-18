const express = require('express');
const router = express.Router();

const dashboardController = require('../controllers/dashboardController');
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');

/**
 * @route   GET /api/v1/dashboard/supervisor
 * @desc    Get supervisor dashboard data
 * @access  Private (Supervisor)
 */
router.get(
  '/supervisor',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  dashboardController.getSupervisorDashboard
);

/**
 * @route   GET /api/v1/dashboard/hr
 * @desc    Get HR dashboard data
 * @access  Private (HR Admin)
 */
router.get(
  '/hr',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  dashboardController.getHrDashboard
);

/**
 * @route   GET /api/v1/dashboard/employee
 * @desc    Get employee dashboard data
 * @access  Private (Employee)
 */
router.get(
  '/employee',
  authenticate,
  authorize(ROLES.EMPLOYEE),
  dashboardController.getEmployeeDashboard
);

module.exports = router;
