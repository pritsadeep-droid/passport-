const express = require('express');
const router = express.Router();

const userController = require('../controllers/userController');
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');
const {
  validate,
  commonValidations,
  body,
  query,
} = require('../middleware/validate');

/**
 * @route   GET /api/v1/users/me
 * @desc    Get current user profile
 * @access  Private
 */
router.get('/me', authenticate, userController.getMe);

/**
 * @route   PATCH /api/v1/users/me
 * @desc    Update current user profile
 * @access  Private
 */
router.patch(
  '/me',
  authenticate,
  validate([
    commonValidations.string('name', { required: false, min: 2, max: 100 }),
    commonValidations.string('department', { required: false, min: 2, max: 100 }),
  ]),
  userController.updateMe
);

/**
 * @route   POST /api/v1/users/me/fcm-token
 * @desc    Register FCM token for push notifications
 * @access  Private
 */
router.post(
  '/me/fcm-token',
  authenticate,
  validate([
    body('fcmToken').notEmpty().withMessage('FCM token is required'),
  ]),
  userController.registerFcmToken
);

/**
 * @route   DELETE /api/v1/users/me/fcm-token
 * @desc    Remove FCM token
 * @access  Private
 */
router.delete(
  '/me/fcm-token',
  authenticate,
  validate([
    body('fcmToken').notEmpty().withMessage('FCM token is required'),
  ]),
  userController.removeFcmToken
);

/**
 * @route   GET /api/v1/users/team
 * @desc    Get team members (for supervisor)
 * @access  Private (Supervisor, HR Admin)
 */
router.get(
  '/team',
  authenticate,
  authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN),
  validate([...commonValidations.pagination()]),
  userController.getTeamMembers
);

/**
 * @route   GET /api/v1/users/supervisors
 * @desc    Get list of supervisors
 * @access  Private (HR Admin)
 */
router.get(
  '/supervisors',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  userController.getSupervisors
);

/**
 * @route   GET /api/v1/users/all
 * @desc    Get all users (for HR admin)
 * @access  Private (HR Admin)
 */
router.get(
  '/all',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  validate([
    ...commonValidations.pagination(),
    query('role')
      .optional()
      .isIn(['employee', 'supervisor', 'hr_admin'])
      .withMessage('Invalid role'),
    query('department').optional().trim(),
    query('isActive').optional().isBoolean().withMessage('isActive must be boolean'),
    query('search').optional().trim(),
  ]),
  userController.getAllUsers
);

/**
 * @route   GET /api/v1/users/:id
 * @desc    Get user by ID
 * @access  Private
 */
router.get(
  '/:id',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  userController.getUserById
);

/**
 * @route   POST /api/v1/users
 * @desc    Create new user
 * @access  Private (HR Admin)
 */
router.post(
  '/',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  validate([
    commonValidations.string('employeeId', { min: 1, max: 50 }),
    commonValidations.email(),
    commonValidations.password(),
    commonValidations.string('name', { min: 2, max: 100 }),
    commonValidations.enum('role', ['employee', 'supervisor', 'hr_admin']),
    commonValidations.string('department', { min: 2, max: 100 }),
    body('supervisorId').optional().isMongoId().withMessage('Invalid supervisor ID'),
  ]),
  userController.createUser
);

/**
 * @route   PATCH /api/v1/users/:id
 * @desc    Update user
 * @access  Private (HR Admin)
 */
router.patch(
  '/:id',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  validate([
    commonValidations.objectId('id', 'param'),
    commonValidations.string('name', { required: false, min: 2, max: 100 }),
    commonValidations.enum('role', ['employee', 'supervisor', 'hr_admin'], {
      required: false,
    }),
    commonValidations.string('department', { required: false, min: 2, max: 100 }),
    body('supervisorId')
      .optional()
      .custom((value) => value === null || /^[0-9a-fA-F]{24}$/.test(value))
      .withMessage('Invalid supervisor ID'),
    commonValidations.boolean('isActive', { required: false }),
  ]),
  userController.updateUser
);

module.exports = router;
