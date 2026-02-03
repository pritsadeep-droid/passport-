const ProbationRecord = require('../models/ProbationRecord');
const User = require('../models/User');
const notificationService = require('../services/notificationService');
const logger = require('../utils/logger');

/**
 * Reminder Job
 * Sends follow-up reminders for overdue items and pending actions
 */

/**
 * Send reminders for overdue milestones (escalating frequency)
 * Day 1: First reminder
 * Day 3: Second reminder
 * Day 7+: Daily reminders
 */
const sendOverdueReminders = async () => {
  try {
    logger.info('Starting overdue reminders job');

    const now = new Date();
    const records = await ProbationRecord.find({
      status: 'in_progress',
      'milestones.status': 'overdue',
    })
      .populate('employeeId', 'name email fcmToken')
      .populate('supervisorId', 'name email fcmToken');

    let remindersSent = 0;

    for (const record of records) {
      const employee = record.employeeId;
      const supervisor = record.supervisorId;

      if (!employee) continue;

      for (const milestone of record.milestones) {
        if (milestone.status !== 'overdue') continue;

        const dueDate = new Date(milestone.dueDate);
        const daysOverdue = Math.ceil((now - dueDate) / (1000 * 60 * 60 * 24));

        // Determine if we should send a reminder based on escalation rules
        const shouldRemind = shouldSendReminder(daysOverdue, milestone.lastReminderSent);

        if (shouldRemind) {
          try {
            // Send to employee
            await notificationService.sendMilestoneOverdue(
              employee,
              milestone,
              daysOverdue
            );

            // Also notify supervisor after 3 days overdue
            if (daysOverdue >= 3 && supervisor) {
              await notificationService.createNotification({
                userId: supervisor._id,
                type: 'milestone_overdue',
                title: `พนักงาน ${employee.name || employee.email} มี Milestone เกินกำหนด`,
                message: `Milestone Day ${milestone.day} เกินกำหนดมา ${daysOverdue} วันแล้ว`,
                data: {
                  employeeId: employee._id,
                  milestoneDay: milestone.day,
                  daysOverdue,
                },
                sendEmail: daysOverdue >= 7, // Email supervisor after 7 days
              });
            }

            // Update last reminder sent
            milestone.lastReminderSent = new Date();
            await record.save();

            remindersSent++;

            logger.info('Sent overdue reminder', {
              employeeId: employee._id,
              milestoneDay: milestone.day,
              daysOverdue,
            });
          } catch (error) {
            logger.error('Failed to send overdue reminder', {
              error: error.message,
              employeeId: employee._id,
            });
          }
        }
      }
    }

    logger.info('Completed overdue reminders job', { remindersSent });

    return { remindersSent };
  } catch (error) {
    logger.error('Failed to send overdue reminders', {
      error: error.message,
    });
    throw error;
  }
};

/**
 * Determine if we should send a reminder based on escalation rules
 */
const shouldSendReminder = (daysOverdue, lastReminderSent) => {
  const now = new Date();

  // If no reminder sent yet, send one
  if (!lastReminderSent) return true;

  const lastReminder = new Date(lastReminderSent);
  const hoursSinceLastReminder = (now - lastReminder) / (1000 * 60 * 60);

  // Day 1-2: One reminder per day
  if (daysOverdue <= 2) {
    return hoursSinceLastReminder >= 24;
  }

  // Day 3-6: Reminder every 2 days
  if (daysOverdue <= 6) {
    return hoursSinceLastReminder >= 48;
  }

  // Day 7+: Daily reminders (but not more than once every 12 hours)
  return hoursSinceLastReminder >= 12;
};

/**
 * Send reminders for pending approvals to supervisors
 */
const sendPendingApprovalReminders = async () => {
  try {
    logger.info('Starting pending approval reminders job');

    const now = new Date();
    const records = await ProbationRecord.find({
      status: 'in_progress',
      'milestones.status': 'pending_approval',
    })
      .populate('employeeId', 'name email')
      .populate('supervisorId', 'name email fcmToken');

    let remindersSent = 0;

    for (const record of records) {
      const employee = record.employeeId;
      const supervisor = record.supervisorId;

      if (!supervisor) continue;

      for (const milestone of record.milestones) {
        if (milestone.status !== 'pending_approval') continue;

        // Check when supervisor assessment was submitted
        const submittedAt = milestone.supervisorAssessment?.submittedAt;
        if (!submittedAt) continue;

        const daysPending = Math.ceil((now - new Date(submittedAt)) / (1000 * 60 * 60 * 24));

        // Send reminder if pending for more than 1 day
        if (daysPending >= 1) {
          const lastReminder = milestone.approvalReminderSent;

          // Don't send more than once per day
          if (lastReminder) {
            const hoursSinceLastReminder = (now - new Date(lastReminder)) / (1000 * 60 * 60);
            if (hoursSinceLastReminder < 24) continue;
          }

          try {
            await notificationService.createNotification({
              userId: supervisor._id,
              type: 'approval_reminder',
              title: 'มี Milestone รออนุมัติ',
              message: `Milestone Day ${milestone.day} ของ ${employee?.name || 'พนักงาน'} รอการอนุมัติมา ${daysPending} วันแล้ว`,
              data: {
                employeeId: employee?._id,
                milestoneDay: milestone.day,
                daysPending,
                probationRecordId: record._id,
              },
              sendEmail: daysPending >= 3, // Email after 3 days
            });

            milestone.approvalReminderSent = new Date();
            await record.save();

            remindersSent++;

            logger.info('Sent approval reminder', {
              supervisorId: supervisor._id,
              milestoneDay: milestone.day,
              daysPending,
            });
          } catch (error) {
            logger.error('Failed to send approval reminder', {
              error: error.message,
            });
          }
        }
      }
    }

    logger.info('Completed pending approval reminders job', { remindersSent });

    return { remindersSent };
  } catch (error) {
    logger.error('Failed to send pending approval reminders', {
      error: error.message,
    });
    throw error;
  }
};

/**
 * Send reminders for pending KPI setup
 */
const sendPendingKpiReminders = async () => {
  try {
    logger.info('Starting pending KPI reminders job');

    const now = new Date();
    const records = await ProbationRecord.find({
      status: 'pending_kpi',
    })
      .populate('employeeId', 'name email')
      .populate('supervisorId', 'name email fcmToken');

    let remindersSent = 0;

    for (const record of records) {
      const supervisor = record.supervisorId;
      const employee = record.employeeId;

      if (!supervisor) continue;

      const daysSinceStart = Math.ceil(
        (now - new Date(record.startDate)) / (1000 * 60 * 60 * 24)
      );

      // Remind if more than 3 days since start without KPI
      if (daysSinceStart >= 3) {
        const lastReminder = record.kpiReminderSent;

        // Don't send more than once every 2 days
        if (lastReminder) {
          const hoursSinceLastReminder = (now - new Date(lastReminder)) / (1000 * 60 * 60);
          if (hoursSinceLastReminder < 48) continue;
        }

        try {
          await notificationService.createNotification({
            userId: supervisor._id,
            type: 'kpi_reminder',
            title: 'กรุณากำหนด KPI',
            message: `${employee?.name || 'พนักงานใหม่'} รอการกำหนด KPI มา ${daysSinceStart} วันแล้ว`,
            data: {
              employeeId: employee?._id,
              probationRecordId: record._id,
              daysSinceStart,
            },
            sendEmail: daysSinceStart >= 7,
          });

          record.kpiReminderSent = new Date();
          await record.save();

          remindersSent++;

          logger.info('Sent KPI reminder', {
            supervisorId: supervisor._id,
            daysSinceStart,
          });
        } catch (error) {
          logger.error('Failed to send KPI reminder', {
            error: error.message,
          });
        }
      }
    }

    logger.info('Completed pending KPI reminders job', { remindersSent });

    return { remindersSent };
  } catch (error) {
    logger.error('Failed to send pending KPI reminders', {
      error: error.message,
    });
    throw error;
  }
};

/**
 * Run all reminder jobs
 */
const runAllReminders = async () => {
  logger.info('Running all reminder jobs');

  const results = {
    overdue: await sendOverdueReminders(),
    pendingApproval: await sendPendingApprovalReminders(),
    pendingKpi: await sendPendingKpiReminders(),
  };

  logger.info('All reminder jobs completed', results);

  return results;
};

module.exports = {
  sendOverdueReminders,
  sendPendingApprovalReminders,
  sendPendingKpiReminders,
  runAllReminders,
};
