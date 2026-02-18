const notificationService = require('../services/notificationService');
const { success } = require('../utils/response');
const { ApiError } = require('../middleware/errorHandler');

/**
 * Get notifications for current user
 * GET /api/v1/notifications
 */
const getNotifications = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { page = 1, limit = 20, unreadOnly } = req.query;

    const result = await notificationService.getNotifications(userId, {
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
      unreadOnly: unreadOnly === 'true',
    });

    return success(res, result, 'ดึงการแจ้งเตือนสำเร็จ');
  } catch (error) {
    next(error);
  }
};

/**
 * Get unread count for current user
 * GET /api/v1/notifications/unread-count
 */
const getUnreadCount = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const count = await notificationService.getUnreadCount(userId);

    return success(res, { count }, 'ดึงจำนวนการแจ้งเตือนสำเร็จ');
  } catch (error) {
    next(error);
  }
};

/**
 * Mark notification as read
 * POST /api/v1/notifications/:id/read
 */
const markAsRead = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { id } = req.params;

    const notification = await notificationService.markAsRead(id, userId);

    if (!notification) {
      throw new ApiError(404, 'ไม่พบการแจ้งเตือน');
    }

    return success(res, notification, 'อ่านการแจ้งเตือนแล้ว');
  } catch (error) {
    next(error);
  }
};

/**
 * Mark all notifications as read
 * POST /api/v1/notifications/read-all
 */
const markAllAsRead = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const count = await notificationService.markAllAsRead(userId);

    return success(res, { count }, `อ่านการแจ้งเตือน ${count} รายการแล้ว`);
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a notification
 * DELETE /api/v1/notifications/:id
 */
const deleteNotification = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { id } = req.params;

    const Notification = require('../models/Notification');
    const notification = await Notification.findOneAndDelete({
      _id: id,
      userId,
    });

    if (!notification) {
      throw new ApiError(404, 'ไม่พบการแจ้งเตือน');
    }

    return success(res, null, 'ลบการแจ้งเตือนสำเร็จ');
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getNotifications,
  getUnreadCount,
  markAsRead,
  markAllAsRead,
  deleteNotification,
};
