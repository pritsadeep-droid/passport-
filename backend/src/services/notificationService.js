const Notification = require('../models/Notification');
const User = require('../models/User');
const emailService = require('./emailService');
const pushService = require('./pushService');
const logger = require('../utils/logger');

/**
 * Notification Types
 */
const NOTIFICATION_TYPES = {
  MILESTONE_REMINDER: 'milestone_reminder',
  MILESTONE_OVERDUE: 'milestone_overdue',
  MILESTONE_APPROVED: 'milestone_approved',
  MILESTONE_REJECTED: 'milestone_rejected',
  ASSESSMENT_SUBMITTED: 'assessment_submitted',
  APPROVAL_NEEDED: 'approval_needed',
  KPI_ASSIGNED: 'kpi_assigned',
  PROBATION_PASSED: 'probation_passed',
  PROBATION_FAILED: 'probation_failed',
  SUPERVISOR_CHANGED: 'supervisor_changed',
};

/**
 * Create and send notification
 * @param {Object} options - Notification options
 * @param {string} options.userId - Recipient user ID
 * @param {string} options.type - Notification type
 * @param {string} options.title - Notification title
 * @param {string} options.message - Notification message
 * @param {Object} options.data - Additional data
 * @param {boolean} options.sendEmail - Whether to send email
 * @param {boolean} options.sendPush - Whether to send push notification
 * @returns {Promise<Object>} Created notification
 */
const createNotification = async ({
  userId,
  type,
  title,
  message,
  data = {},
  sendEmail = true,
  sendPush = true,
}) => {
  try {
    // Create in-app notification
    const notification = await Notification.create({
      userId,
      type,
      title,
      message,
      data,
      read: false,
    });

    logger.info('Notification created', {
      notificationId: notification._id,
      userId,
      type,
    });

    // Get user for email and push
    const user = await User.findById(userId);

    if (!user) {
      logger.warn('User not found for notification', { userId });
      return notification;
    }

    // Send email notification
    if (sendEmail && user.email) {
      const emailTemplate = getEmailTemplateForType(type);
      if (emailTemplate) {
        emailService.sendEmail({
          to: user.email,
          template: emailTemplate,
          data: {
            ...data,
            employeeName: user.name || user.email,
          },
        });
      }
    }

    // Send push notification
    if (sendPush && user.fcmToken) {
      pushService.sendToDevice(
        user.fcmToken,
        { title, body: message },
        {
          type,
          notificationId: notification._id.toString(),
          ...stringifyData(data),
        }
      );
    }

    return notification;
  } catch (error) {
    logger.error('Failed to create notification', {
      error: error.message,
      userId,
      type,
    });
    throw error;
  }
};

/**
 * Get email template for notification type
 * @param {string} type - Notification type
 * @returns {string|null} Email template name
 */
const getEmailTemplateForType = (type) => {
  const templateMap = {
    [NOTIFICATION_TYPES.MILESTONE_REMINDER]: 'milestoneReminder',
    [NOTIFICATION_TYPES.MILESTONE_OVERDUE]: 'milestoneOverdue',
    [NOTIFICATION_TYPES.APPROVAL_NEEDED]: 'supervisorApprovalNeeded',
    [NOTIFICATION_TYPES.PROBATION_PASSED]: 'probationResult',
    [NOTIFICATION_TYPES.PROBATION_FAILED]: 'probationResult',
  };
  return templateMap[type] || null;
};

/**
 * Convert data object values to strings for FCM
 */
const stringifyData = (data) => {
  const result = {};
  for (const [key, value] of Object.entries(data)) {
    result[key] = typeof value === 'object' ? JSON.stringify(value) : String(value);
  }
  return result;
};

/**
 * Send milestone reminder notification
 */
const sendMilestoneReminder = async (employee, milestone, daysRemaining) => {
  return createNotification({
    userId: employee._id,
    type: NOTIFICATION_TYPES.MILESTONE_REMINDER,
    title: `Milestone Day ${milestone.day} กำลังจะถึงกำหนด`,
    message: `เหลืออีก ${daysRemaining} วัน กรุณากรอกแบบประเมินตนเอง`,
    data: {
      milestoneDay: milestone.day,
      dueDate: milestone.dueDate,
      daysRemaining,
    },
  });
};

/**
 * Send milestone overdue notification
 */
const sendMilestoneOverdue = async (employee, milestone, daysOverdue) => {
  return createNotification({
    userId: employee._id,
    type: NOTIFICATION_TYPES.MILESTONE_OVERDUE,
    title: `⚠️ Milestone Day ${milestone.day} เกินกำหนด`,
    message: `เกินกำหนดมา ${daysOverdue} วันแล้ว กรุณาดำเนินการโดยเร็ว`,
    data: {
      milestoneDay: milestone.day,
      dueDate: milestone.dueDate,
      daysOverdue,
    },
  });
};

/**
 * Send approval needed notification to supervisor
 */
const sendApprovalNeeded = async (supervisor, employee, milestone, probationRecordId) => {
  return createNotification({
    userId: supervisor._id,
    type: NOTIFICATION_TYPES.APPROVAL_NEEDED,
    title: 'มี Milestone รออนุมัติ',
    message: `${employee.name || employee.email} ส่ง Milestone Day ${milestone.day} รอพิจารณา`,
    data: {
      employeeId: employee._id,
      employeeName: employee.name || employee.email,
      milestoneDay: milestone.day,
      probationRecordId,
    },
  });
};

/**
 * Send milestone approved notification
 */
const sendMilestoneApproved = async (employee, milestone) => {
  return createNotification({
    userId: employee._id,
    type: NOTIFICATION_TYPES.MILESTONE_APPROVED,
    title: `✓ Milestone Day ${milestone.day} ผ่านการอนุมัติ`,
    message: 'ยินดีด้วย! Milestone ของคุณได้รับการอนุมัติแล้ว',
    data: {
      milestoneDay: milestone.day,
    },
    sendEmail: false, // In-app only for this type
  });
};

/**
 * Send milestone rejected notification
 */
const sendMilestoneRejected = async (employee, milestone, reason) => {
  return createNotification({
    userId: employee._id,
    type: NOTIFICATION_TYPES.MILESTONE_REJECTED,
    title: `✗ Milestone Day ${milestone.day} ไม่ผ่านการอนุมัติ`,
    message: reason || 'กรุณาติดต่อหัวหน้างานเพื่อทราบรายละเอียด',
    data: {
      milestoneDay: milestone.day,
      reason,
    },
    sendEmail: false,
  });
};

/**
 * Send KPI assigned notification
 */
const sendKpiAssigned = async (employee, kpiCount) => {
  return createNotification({
    userId: employee._id,
    type: NOTIFICATION_TYPES.KPI_ASSIGNED,
    title: 'ได้รับการกำหนด KPI',
    message: `หัวหน้างานได้กำหนด KPI ${kpiCount} ข้อสำหรับการทดลองงานของคุณ`,
    data: {
      kpiCount,
    },
    sendEmail: false,
  });
};

/**
 * Send probation result notification
 */
const sendProbationResult = async (employee, passed, reason) => {
  const type = passed
    ? NOTIFICATION_TYPES.PROBATION_PASSED
    : NOTIFICATION_TYPES.PROBATION_FAILED;

  return createNotification({
    userId: employee._id,
    type,
    title: passed ? '🎉 ผ่านทดลองงาน' : 'ผลการทดลองงาน',
    message: passed
      ? 'ยินดีด้วย! คุณผ่านการทดลองงานแล้ว'
      : reason || 'กรุณาติดต่อ HR เพื่อทราบรายละเอียด',
    data: {
      result: passed ? 'passed' : 'failed',
      reason,
    },
  });
};

/**
 * Send supervisor changed notification
 */
const sendSupervisorChanged = async (employee, newSupervisor, reason) => {
  return createNotification({
    userId: employee._id,
    type: NOTIFICATION_TYPES.SUPERVISOR_CHANGED,
    title: 'เปลี่ยนหัวหน้างาน',
    message: `หัวหน้างานของคุณถูกเปลี่ยนเป็น ${newSupervisor.name || newSupervisor.email}`,
    data: {
      newSupervisorId: newSupervisor._id,
      newSupervisorName: newSupervisor.name || newSupervisor.email,
      reason,
    },
    sendEmail: false,
  });
};

/**
 * Get notifications for user
 */
const getNotifications = async (userId, { page = 1, limit = 20, unreadOnly = false }) => {
  const query = { userId };
  if (unreadOnly) {
    query.read = false;
  }

  const skip = (page - 1) * limit;

  const [notifications, total] = await Promise.all([
    Notification.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .lean(),
    Notification.countDocuments(query),
  ]);

  return {
    notifications,
    pagination: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
      hasMore: skip + notifications.length < total,
    },
  };
};

/**
 * Get unread count for user
 */
const getUnreadCount = async (userId) => {
  return Notification.countDocuments({ userId, read: false });
};

/**
 * Mark notification as read
 */
const markAsRead = async (notificationId, userId) => {
  const notification = await Notification.findOneAndUpdate(
    { _id: notificationId, userId },
    { read: true, readAt: new Date() },
    { new: true }
  );

  return notification;
};

/**
 * Mark all notifications as read
 */
const markAllAsRead = async (userId) => {
  const result = await Notification.updateMany(
    { userId, read: false },
    { read: true, readAt: new Date() }
  );

  return result.modifiedCount;
};

/**
 * Delete old notifications (cleanup job)
 */
const deleteOldNotifications = async (daysOld = 90) => {
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - daysOld);

  const result = await Notification.deleteMany({
    createdAt: { $lt: cutoffDate },
    read: true,
  });

  logger.info('Deleted old notifications', { count: result.deletedCount });

  return result.deletedCount;
};

module.exports = {
  NOTIFICATION_TYPES,
  createNotification,
  sendMilestoneReminder,
  sendMilestoneOverdue,
  sendApprovalNeeded,
  sendMilestoneApproved,
  sendMilestoneRejected,
  sendKpiAssigned,
  sendProbationResult,
  sendSupervisorChanged,
  getNotifications,
  getUnreadCount,
  markAsRead,
  markAllAsRead,
  deleteOldNotifications,
};
