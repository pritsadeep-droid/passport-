const express = require('express');
const router = express.Router();

const notificationController = require('../controllers/notificationController');
const { authenticate } = require('../middleware/auth');
const { validate, commonValidations, query } = require('../middleware/validate');

/**
 * @route   GET /api/v1/notifications
 * @desc    Get notifications for current user
 * @access  Private
 */
router.get(
  '/',
  authenticate,
  validate([
    ...commonValidations.pagination(),
    query('unreadOnly').optional().isBoolean(),
  ]),
  notificationController.getNotifications
);

/**
 * @route   GET /api/v1/notifications/unread-count
 * @desc    Get unread notification count
 * @access  Private
 */
router.get(
  '/unread-count',
  authenticate,
  notificationController.getUnreadCount
);

/**
 * @route   POST /api/v1/notifications/read-all
 * @desc    Mark all notifications as read
 * @access  Private
 */
router.post(
  '/read-all',
  authenticate,
  notificationController.markAllAsRead
);

/**
 * @route   POST /api/v1/notifications/:id/read
 * @desc    Mark notification as read
 * @access  Private
 */
router.post(
  '/:id/read',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  notificationController.markAsRead
);

/**
 * @route   DELETE /api/v1/notifications/:id
 * @desc    Delete a notification
 * @access  Private
 */
router.delete(
  '/:id',
  authenticate,
  validate([commonValidations.objectId('id', 'param')]),
  notificationController.deleteNotification
);

module.exports = router;
