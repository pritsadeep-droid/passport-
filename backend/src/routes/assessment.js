const express = require('express');
const router = express.Router();

const assessmentController = require('../controllers/assessmentController');
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');
const {
  validate,
  commonValidations,
  body,
} = require('../middleware/validate');

/**
 * @route   GET /api/v1/assessment/current
 * @desc    Get current milestone for employee to assess
 * @access  Private (Employee)
 */
router.get(
  '/current',
  authenticate,
  authorize(ROLES.EMPLOYEE),
  assessmentController.getCurrentAssessment
);

/**
 * @route   GET /api/v1/assessment/milestones
 * @desc    Get all milestones for employee view
 * @access  Private (Employee)
 */
router.get(
  '/milestones',
  authenticate,
  authorize(ROLES.EMPLOYEE),
  assessmentController.getMyMilestones
);

/**
 * @route   GET /api/v1/assessment/:recordId/milestones/:day/self
 * @desc    Get self assessment for a milestone
 * @access  Private
 */
router.get(
  '/:recordId/milestones/:day/self',
  authenticate,
  validate([commonValidations.objectId('recordId', 'param')]),
  assessmentController.getSelfAssessment
);

/**
 * @route   PUT /api/v1/assessment/:recordId/milestones/:day/self
 * @desc    Submit or update self assessment
 * @access  Private (Employee)
 */
router.put(
  '/:recordId/milestones/:day/self',
  authenticate,
  authorize(ROLES.EMPLOYEE),
  validate([
    commonValidations.objectId('recordId', 'param'),
    body('coreValue.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Core value score must be between 1-5'),
    body('coreValue.comment').optional().trim(),
    body('jobPerformance.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Job performance score must be between 1-5'),
    body('jobPerformance.comment').optional().trim(),
    body('attendance.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Attendance score must be between 1-5'),
    body('attendance.comment').optional().trim(),
    body('cultureFit.score')
      .optional()
      .isInt({ min: 1, max: 5 })
      .withMessage('Culture fit score must be between 1-5'),
    body('cultureFit.comment').optional().trim(),
    body('comments').optional().trim().isLength({ max: 2000 }),
    body('isDraft').optional().isBoolean(),
  ]),
  assessmentController.submitSelfAssessment
);

/**
 * @route   GET /api/v1/assessment/:recordId/milestones/:day/supervisor
 * @desc    Get supervisor assessment for a milestone
 * @access  Private
 */
router.get(
  '/:recordId/milestones/:day/supervisor',
  authenticate,
  validate([commonValidations.objectId('recordId', 'param')]),
  assessmentController.getSupervisorAssessment
);

/**
 * @route   PUT /api/v1/assessment/:recordId/milestones/:day/supervisor
 * @desc    Submit supervisor assessment
 * @access  Private (Supervisor, HR Admin)
 */
router.put(
  '/:recordId/milestones/:day/supervisor',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('recordId', 'param'),
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
      .isLength({ min: 10, max: 2000 })
      .withMessage('Overall comment must be between 10-2000 characters'),
    body('recommendation')
      .isIn(['pass', 'fail', 'extend'])
      .withMessage('Recommendation must be pass, fail, or extend'),
  ]),
  assessmentController.submitSupervisorAssessment
);

module.exports = router;
