const express = require('express');
const router = express.Router();

const probationController = require('../controllers/probationController');
const kpiController = require('../controllers/kpiController');
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');
const {
  validate,
  commonValidations,
  body,
  query,
} = require('../middleware/validate');

/**
 * @route   GET /api/v1/probation
 * @desc    Get probation records (filtered by role)
 * @access  Private
 */
router.get(
  '/',
  authenticate,
  validate([
    ...commonValidations.pagination(),
    query('status')
      .optional()
      .isIn([
        'pending_kpi',
        'in_progress',
        'pending_decision',
        'passed',
        'failed',
        'resigned',
        'terminated',
      ])
      .withMessage('Invalid status'),
    query('search').optional().trim(),
  ]),
  probationController.getProbationRecords
);

/**
 * @route   GET /api/v1/probation/me
 * @desc    Get my probation record (for employee)
 * @access  Private (Employee)
 */
router.get(
  '/me',
  authenticate,
  authorize(ROLES.EMPLOYEE),
  probationController.getMyProbationRecord
);

/**
 * @route   GET /api/v1/probation/employee/:employeeId
 * @desc    Get probation record by employee ID
 * @access  Private
 */
router.get(
  '/employee/:employeeId',
  authenticate,
  validate([commonValidations.objectId('employeeId', 'param')]),
  probationController.getProbationRecordByEmployeeId
);

/**
 * @route   GET /api/v1/probation/:id
 * @desc    Get single probation record
 * @access  Private
 */
router.get(
  '/:id',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  probationController.getProbationRecordById
);

/**
 * @route   POST /api/v1/probation
 * @desc    Create probation record for new employee
 * @access  Private (HR Admin)
 */
router.post(
  '/',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('employeeId', 'body'),
    commonValidations.objectId('supervisorId', 'body'),
    commonValidations.date('startDate'),
    body('probationDays')
      .optional()
      .isIn([90, 119])
      .withMessage('Probation days must be 90 or 119'),
  ]),
  probationController.createProbationRecord
);

/**
 * @route   PATCH /api/v1/probation/:id/status
 * @desc    Update probation record status
 * @access  Private (HR Admin)
 */
router.patch(
  '/:id/status',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    commonValidations.enum('status', [
      'pending_kpi',
      'in_progress',
      'pending_decision',
      'passed',
      'failed',
      'resigned',
      'terminated',
    ]),
    commonValidations.string('reason', { required: false, max: 2000 }),
  ]),
  probationController.updateProbationStatus
);

/**
 * @route   PATCH /api/v1/probation/:id/supervisor
 * @desc    Transfer supervisor
 * @access  Private (HR Admin)
 */
router.patch(
  '/:id/supervisor',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    commonValidations.objectId('newSupervisorId', 'body'),
    commonValidations.string('reason', { required: false, max: 1000 }),
  ]),
  probationController.transferSupervisor
);

/**
 * @route   PATCH /api/v1/probation/:id/extend
 * @desc    Extend probation period
 * @access  Private (HR Admin)
 */
router.patch(
  '/:id/extend',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    body('additionalDays')
      .isInt({ min: 1, max: 90 })
      .withMessage('Additional days must be between 1 and 90'),
    commonValidations.string('reason', { required: true, max: 1000 }),
  ]),
  probationController.extendProbation
);

// ==================== KPI Routes ====================

/**
 * @route   GET /api/v1/probation/:id/kpis
 * @desc    Get KPIs for a probation record
 * @access  Private
 */
router.get(
  '/:id/kpis',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  kpiController.getKpis
);

/**
 * @route   POST /api/v1/probation/:id/kpis
 * @desc    Create KPIs for a probation record (batch)
 * @access  Private (Supervisor, HR Admin)
 */
router.post(
  '/:id/kpis',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    commonValidations.array('kpis', { minLength: 3, maxLength: 5 }),
    body('kpis.*.title')
      .notEmpty()
      .withMessage('KPI title is required')
      .isLength({ max: 200 })
      .withMessage('KPI title must be at most 200 characters'),
    body('kpis.*.description')
      .notEmpty()
      .withMessage('KPI description is required')
      .isLength({ max: 1000 })
      .withMessage('KPI description must be at most 1000 characters'),
    body('kpis.*.criteria')
      .notEmpty()
      .withMessage('KPI criteria is required')
      .isLength({ max: 500 })
      .withMessage('KPI criteria must be at most 500 characters'),
  ]),
  kpiController.createKpis
);

/**
 * @route   POST /api/v1/probation/:id/kpis/add
 * @desc    Add single KPI to probation record
 * @access  Private (Supervisor, HR Admin)
 */
router.post(
  '/:id/kpis/add',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    commonValidations.string('title', { min: 1, max: 200 }),
    commonValidations.string('description', { min: 1, max: 1000 }),
    commonValidations.string('criteria', { min: 1, max: 500 }),
  ]),
  kpiController.addKpi
);

/**
 * @route   PATCH /api/v1/probation/:id/kpis/:kpiId
 * @desc    Update a KPI
 * @access  Private (Supervisor, HR Admin)
 */
router.patch(
  '/:id/kpis/:kpiId',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    body('kpiId').optional(),
    commonValidations.string('title', { required: false, max: 200 }),
    commonValidations.string('description', { required: false, max: 1000 }),
    commonValidations.string('criteria', { required: false, max: 500 }),
    body('status')
      .optional()
      .isIn(['active', 'completed', 'cancelled'])
      .withMessage('Invalid KPI status'),
  ]),
  kpiController.updateKpi
);

/**
 * @route   DELETE /api/v1/probation/:id/kpis/:kpiId
 * @desc    Delete a KPI
 * @access  Private (Supervisor, HR Admin)
 */
router.delete(
  '/:id/kpis/:kpiId',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([commonValidations.objectId('id', 'param')]),
  kpiController.deleteKpi
);

module.exports = router;
