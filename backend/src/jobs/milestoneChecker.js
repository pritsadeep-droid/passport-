const ProbationRecord = require('../models/ProbationRecord');
const notificationService = require('../services/notificationService');
const logger = require('../utils/logger');

/**
 * Milestone Checker Job
 * Runs daily to check for upcoming and overdue milestones
 */

/**
 * Check for milestones due soon and send reminders
 * @param {number} daysBeforeDue - Days before due date to send reminder
 */
const checkUpcomingMilestones = async (daysBeforeDue = 3) => {
  try {
    logger.info('Starting upcoming milestones check', { daysBeforeDue });

    const now = new Date();
    const reminderDate = new Date();
    reminderDate.setDate(now.getDate() + daysBeforeDue);

    // Set to end of day
    reminderDate.setHours(23, 59, 59, 999);

    // Find active probation records with upcoming milestones
    const records = await ProbationRecord.find({
      status: 'in_progress',
      'milestones.status': 'upcoming',
      'milestones.dueDate': {
        $lte: reminderDate,
        $gte: now,
      },
    }).populate('employeeId', 'name email fcmToken');

    let remindersSent = 0;

    for (const record of records) {
      const employee = record.employeeId;
      if (!employee) {continue;}

      for (const milestone of record.milestones) {
        if (milestone.status !== 'upcoming') {continue;}

        const dueDate = new Date(milestone.dueDate);
        const daysRemaining = Math.ceil((dueDate - now) / (1000 * 60 * 60 * 24));

        // Only send reminder if within the reminder window
        if (daysRemaining <= daysBeforeDue && daysRemaining >= 0) {
          // Check if we already sent a reminder today
          const lastReminder = milestone.lastReminderSent;
          const today = new Date().toDateString();

          if (lastReminder && new Date(lastReminder).toDateString() === today) {
            continue; // Already sent reminder today
          }

          try {
            await notificationService.sendMilestoneReminder(
              employee,
              milestone,
              daysRemaining
            );

            // Update last reminder sent
            milestone.lastReminderSent = new Date();
            await record.save();

            remindersSent++;

            logger.info('Sent milestone reminder', {
              employeeId: employee._id,
              milestoneDay: milestone.day,
              daysRemaining,
            });
          } catch (error) {
            logger.error('Failed to send milestone reminder', {
              error: error.message,
              employeeId: employee._id,
              milestoneDay: milestone.day,
            });
          }
        }
      }
    }

    logger.info('Completed upcoming milestones check', { remindersSent });

    return { remindersSent };
  } catch (error) {
    logger.error('Failed to check upcoming milestones', {
      error: error.message,
    });
    throw error;
  }
};

/**
 * Check for overdue milestones and send notifications
 */
const checkOverdueMilestones = async () => {
  try {
    logger.info('Starting overdue milestones check');

    const now = new Date();

    // Find active probation records with overdue milestones
    const records = await ProbationRecord.find({
      status: 'in_progress',
      'milestones.status': { $in: ['pending_self', 'pending_supervisor'] },
      'milestones.dueDate': { $lt: now },
    })
      .populate('employeeId', 'name email fcmToken')
      .populate('supervisorId', 'name email fcmToken');

    let overdueCount = 0;
    let notificationsSent = 0;

    for (const record of records) {
      const employee = record.employeeId;
      const supervisor = record.supervisorId;

      if (!employee) {continue;}

      for (const milestone of record.milestones) {
        const dueDate = new Date(milestone.dueDate);

        if (dueDate >= now) {continue;}
        if (!['pending_self', 'pending_supervisor'].includes(milestone.status)) {continue;}

        const daysOverdue = Math.ceil((now - dueDate) / (1000 * 60 * 60 * 24));

        // Update status to overdue if not already
        if (milestone.status !== 'overdue') {
          const wasStatus = milestone.status;
          milestone.status = 'overdue';
          await record.save();

          overdueCount++;

          // Send overdue notification to employee
          try {
            await notificationService.sendMilestoneOverdue(
              employee,
              milestone,
              daysOverdue
            );
            notificationsSent++;
          } catch (error) {
            logger.error('Failed to send overdue notification', {
              error: error.message,
              employeeId: employee._id,
            });
          }

          // If it was pending_supervisor, also notify supervisor
          if (wasStatus === 'pending_supervisor' && supervisor) {
            // Could add supervisor notification here
          }

          logger.info('Marked milestone as overdue', {
            recordId: record._id,
            milestoneDay: milestone.day,
            daysOverdue,
          });
        }
      }
    }

    logger.info('Completed overdue milestones check', {
      overdueCount,
      notificationsSent,
    });

    return { overdueCount, notificationsSent };
  } catch (error) {
    logger.error('Failed to check overdue milestones', {
      error: error.message,
    });
    throw error;
  }
};

/**
 * Activate milestones that are due today
 * Changes status from 'upcoming' to 'pending_self'
 */
const activateDueMilestones = async () => {
  try {
    logger.info('Starting milestone activation');

    const now = new Date();
    const startOfDay = new Date(now);
    startOfDay.setHours(0, 0, 0, 0);

    // Find records with milestones that are due today or earlier
    const records = await ProbationRecord.find({
      status: 'in_progress',
      'milestones.status': 'upcoming',
      'milestones.dueDate': { $lte: now },
    }).populate('employeeId', 'name email fcmToken');

    let activatedCount = 0;

    for (const record of records) {
      const employee = record.employeeId;

      for (const milestone of record.milestones) {
        if (milestone.status !== 'upcoming') {continue;}

        const dueDate = new Date(milestone.dueDate);
        if (dueDate > now) {continue;}

        // Activate the milestone
        milestone.status = 'pending_self';
        activatedCount++;

        logger.info('Activated milestone', {
          recordId: record._id,
          milestoneDay: milestone.day,
        });
      }

      if (activatedCount > 0) {
        await record.save();

        // Send notification about activated milestone
        if (employee) {
          const activatedMilestone = record.milestones.find(
            (m) => m.status === 'pending_self'
          );
          if (activatedMilestone) {
            try {
              await notificationService.sendMilestoneReminder(
                employee,
                activatedMilestone,
                0
              );
            } catch (error) {
              logger.error('Failed to send activation notification', {
                error: error.message,
              });
            }
          }
        }
      }
    }

    logger.info('Completed milestone activation', { activatedCount });

    return { activatedCount };
  } catch (error) {
    logger.error('Failed to activate milestones', {
      error: error.message,
    });
    throw error;
  }
};

/**
 * Run all milestone checks
 */
const runAllChecks = async () => {
  logger.info('Running all milestone checks');

  const results = {
    activation: await activateDueMilestones(),
    upcoming: await checkUpcomingMilestones(),
    overdue: await checkOverdueMilestones(),
  };

  logger.info('All milestone checks completed', results);

  return results;
};

module.exports = {
  checkUpcomingMilestones,
  checkOverdueMilestones,
  activateDueMilestones,
  runAllChecks,
};
