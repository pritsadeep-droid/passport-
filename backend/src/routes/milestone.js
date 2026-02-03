const express = require('express');
const router = express.Router();

const milestoneController = require('../controllers/milestoneController');
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');
const {
  validate,
  commonValidations,
  body,
} = require('../middleware/validate');

/**
 * @route   GET /api/v1/milestones/pending
 * @desc    Get pending approvals for supervisor
 * @access  Private (Supervisor, HR Admin)
 */
router.get(
  '/pending',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  milestoneController.getPendingApprovals
);

/**
 * @route   GET /api/v1/probation/:id/milestones
 * @desc    Get all milestones for a probation record
 * @access  Private
 */
router.get(
  '/probation/:id/milestones',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  milestoneController.getMilestones
);

/**
 * @route   GET /api/v1/probation/:id/milestones/:day
 * @desc    Get single milestone
 * @access  Private
 */
router.get(
  '/probation/:id/milestones/:day',
  authenticate,
  validate([
    commonValidations.objectId('id', 'param'),
    body('day').optional(), // day comes from params, not body
  ]),
  milestoneController.getMilestone
);

/**
 * @route   PUT /api/v1/probation/:id/milestones/:day/self-assessment
 * @desc    Submit self assessment
 * @access  Private (Employee)
 */
router.put(
  '/probation/:id/milestones/:day/self-assessment',
  authenticate,
  authorize(ROLES.EMPLOYEE),
  validate([
    commonValidations.objectId('id', 'param'),
    body('coreValue.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Score must be between 1-5'),
    body('coreValue.comment').optional().trim(),
    body('jobPerformance.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Score must be between 1-5'),
    body('jobPerformance.comment').optional().trim(),
    body('attendance.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Score must be between 1-5'),
    body('attendance.comment').optional().trim(),
    body('cultureFit.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Score must be between 1-5'),
    body('cultureFit.comment').optional().trim(),
    body('comments').optional().trim(),
    body('isDraft').optional().isBoolean(),
  ]),
  milestoneController.submitSelfAssessment
);

/**
 * @route   GET /api/v1/probation/:id/milestones/:day/self-assessment
 * @desc    Get self assessment
 * @access  Private
 */
router.get(
  '/probation/:id/milestones/:day/self-assessment',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  milestoneController.getSelfAssessment
);

/**
 * @route   PUT /api/v1/probation/:id/milestones/:day/supervisor-assessment
 * @desc    Submit supervisor assessment
 * @access  Private (Supervisor, HR Admin)
 */
router.put(
  '/probation/:id/milestones/:day/supervisor-assessment',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    body('coreValue.score')
      .isInt({ min: 1, max: 5 })
      .withMessage('Core value score is required (1-5)'),
    body('coreValue.comment').optional().trim(),
    body('jobPerformance.score')
      .isInt({ min: 1, max: 5 })
      .withMessage('Job performance score is required (1-5)'),
    body('jobPerformance.comment').optional().trim(),
    body('attendance.score')
      .isInt({ min: 1, max: 5 })
      .withMessage('Attendance score is required (1-5)'),
    body('attendance.comment').optional().trim(),
    body('cultureFit.score')
      .isInt({ min: 1, max: 5 })
      .withMessage('Culture fit score is required (1-5)'),
    body('cultureFit.comment').optional().trim(),
    body('kpiScores').optional().isArray(),
    body('kpiScores.*.kpiId').optional().isMongoId(),
    body('kpiScores.*.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('KPI score must be between 1-5'),
    body('kpiScores.*.comment').optional().trim(),
    body('overallComment')
      .notEmpty()
      .withMessage('Overall comment is required')
      .isLength({ min: 10 })
      .withMessage('Overall comment must be at least 10 characters'),
    body('recommendation')
      .isIn(['pass', 'fail', 'extend'])
      .withMessage('Recommendation must be pass, fail, or extend'),
  ]),
  milestoneController.submitSupervisorAssessment
);

/**
 * @route   GET /api/v1/probation/:id/milestones/:day/supervisor-assessment
 * @desc    Get supervisor assessment
 * @access  Private
 */
router.get(
  '/probation/:id/milestones/:day/supervisor-assessment',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  milestoneController.getSupervisorAssessment
);

/**
 * @route   POST /api/v1/probation/:id/milestones/:day/approve
 * @desc    Approve milestone
 * @access  Private (Supervisor, HR Admin)
 */
router.post(
  '/probation/:id/milestones/:day/approve',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    body('comment').optional().trim(),
  ]),
  milestoneController.approveMilestone
);

/**
 * @route   POST /api/v1/probation/:id/milestones/:day/reject
 * @desc    Reject milestone
 * @access  Private (Supervisor, HR Admin)
 */
router.post(
  '/probation/:id/milestones/:day/reject',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    body('reason')
      .notEmpty()
      .withMessage('Rejection reason is required')
      .isLength({ min: 10 })
      .withMessage('Rejection reason must be at least 10 characters'),
  ]),
  milestoneController.rejectMilestone
);

module.exports = router;
