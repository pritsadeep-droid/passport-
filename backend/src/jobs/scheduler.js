const cron = require('node-cron');
const milestoneChecker = require('./milestoneChecker');
const reminderJob = require('./reminderJob');
const notificationService = require('../services/notificationService');
const logger = require('../utils/logger');

/**
 * Job Scheduler
 * Sets up scheduled jobs using node-cron
 */

// Store active jobs for management
const activeJobs = new Map();

/**
 * Schedule a job
 * @param {string} name - Job name
 * @param {string} schedule - Cron schedule expression
 * @param {Function} task - Task to execute
 * @param {Object} options - Additional options
 */
const scheduleJob = (name, schedule, task, options = {}) => {
  // Validate cron expression
  if (!cron.validate(schedule)) {
    logger.error(`Invalid cron expression for job ${name}: ${schedule}`);
    return null;
  }

  const job = cron.schedule(
    schedule,
    async () => {
      const startTime = Date.now();
      logger.info(`Starting job: ${name}`);

      try {
        const result = await task();
        const duration = Date.now() - startTime;

        logger.info(`Completed job: ${name}`, {
          duration: `${duration}ms`,
          result,
        });
      } catch (error) {
        logger.error(`Failed job: ${name}`, {
          error: error.message,
          stack: error.stack,
        });
      }
    },
    {
      scheduled: false,
      timezone: options.timezone || 'Asia/Bangkok',
    }
  );

  activeJobs.set(name, {
    job,
    schedule,
    lastRun: null,
    options,
  });

  logger.info(`Scheduled job: ${name} with schedule: ${schedule}`);

  return job;
};

/**
 * Initialize all scheduled jobs
 */
const initializeScheduler = () => {
  logger.info('Initializing job scheduler');

  // Skip in test environment
  if (process.env.NODE_ENV === 'test') {
    logger.info('Skipping scheduler in test environment');
    return;
  }

  // ============================================
  // Milestone Checker Jobs
  // ============================================

  // Run milestone activation every hour at :00
  scheduleJob(
    'milestone-activation',
    '0 * * * *', // Every hour
    milestoneChecker.activateDueMilestones
  );

  // Check upcoming milestones daily at 8 AM
  scheduleJob(
    'upcoming-milestones',
    '0 8 * * *', // 8:00 AM daily
    () => milestoneChecker.checkUpcomingMilestones(3)
  );

  // Check overdue milestones daily at 9 AM
  scheduleJob(
    'overdue-milestones',
    '0 9 * * *', // 9:00 AM daily
    milestoneChecker.checkOverdueMilestones
  );

  // ============================================
  // Reminder Jobs
  // ============================================

  // Send overdue reminders twice daily (9 AM and 3 PM)
  scheduleJob(
    'overdue-reminders-morning',
    '0 9 * * *', // 9:00 AM daily
    reminderJob.sendOverdueReminders
  );

  scheduleJob(
    'overdue-reminders-afternoon',
    '0 15 * * *', // 3:00 PM daily
    reminderJob.sendOverdueReminders
  );

  // Send pending approval reminders daily at 10 AM
  scheduleJob(
    'pending-approval-reminders',
    '0 10 * * *', // 10:00 AM daily
    reminderJob.sendPendingApprovalReminders
  );

  // Send pending KPI reminders daily at 10 AM
  scheduleJob(
    'pending-kpi-reminders',
    '0 10 * * *', // 10:00 AM daily
    reminderJob.sendPendingKpiReminders
  );

  // ============================================
  // Cleanup Jobs
  // ============================================

  // Delete old read notifications weekly on Sunday at 2 AM
  scheduleJob(
    'cleanup-old-notifications',
    '0 2 * * 0', // 2:00 AM every Sunday
    () => notificationService.deleteOldNotifications(90)
  );

  // Start all jobs
  startAllJobs();

  logger.info('Job scheduler initialized', {
    jobCount: activeJobs.size,
    jobs: Array.from(activeJobs.keys()),
  });
};

/**
 * Start all scheduled jobs
 */
const startAllJobs = () => {
  for (const [name, { job }] of activeJobs) {
    job.start();
    logger.info(`Started job: ${name}`);
  }
};

/**
 * Stop all scheduled jobs
 */
const stopAllJobs = () => {
  for (const [name, { job }] of activeJobs) {
    job.stop();
    logger.info(`Stopped job: ${name}`);
  }
};

/**
 * Get job status
 */
const getJobStatus = (name) => {
  const jobInfo = activeJobs.get(name);
  if (!jobInfo) {return null;}

  return {
    name,
    schedule: jobInfo.schedule,
    lastRun: jobInfo.lastRun,
    running: jobInfo.job.running,
  };
};

/**
 * Get all jobs status
 */
const getAllJobsStatus = () => {
  const status = [];
  for (const [name] of activeJobs) {
    status.push(getJobStatus(name));
  }
  return status;
};

/**
 * Run a job manually
 */
const runJobManually = async (name) => {
  const jobInfo = activeJobs.get(name);
  if (!jobInfo) {
    throw new Error(`Job not found: ${name}`);
  }

  logger.info(`Manually triggering job: ${name}`);

  // Map job names to their functions
  const jobFunctions = {
    'milestone-activation': milestoneChecker.activateDueMilestones,
    'upcoming-milestones': () => milestoneChecker.checkUpcomingMilestones(3),
    'overdue-milestones': milestoneChecker.checkOverdueMilestones,
    'overdue-reminders-morning': reminderJob.sendOverdueReminders,
    'overdue-reminders-afternoon': reminderJob.sendOverdueReminders,
    'pending-approval-reminders': reminderJob.sendPendingApprovalReminders,
    'pending-kpi-reminders': reminderJob.sendPendingKpiReminders,
    'cleanup-old-notifications': () => notificationService.deleteOldNotifications(90),
  };

  const fn = jobFunctions[name];
  if (!fn) {
    throw new Error(`No function mapped for job: ${name}`);
  }

  return await fn();
};

/**
 * Shutdown scheduler gracefully
 */
const shutdown = () => {
  logger.info('Shutting down job scheduler');
  stopAllJobs();
  activeJobs.clear();
};

module.exports = {
  initializeScheduler,
  scheduleJob,
  startAllJobs,
  stopAllJobs,
  getJobStatus,
  getAllJobsStatus,
  runJobManually,
  shutdown,
};
