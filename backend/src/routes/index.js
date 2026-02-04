const express = require('express');
const router = express.Router();

// Import route modules
const authRoutes = require('./auth');
const userRoutes = require('./users');
const probationRoutes = require('./probation');
const milestoneRoutes = require('./milestone');
const dashboardRoutes = require('./dashboard');
const assessmentRoutes = require('./assessment');
const notificationRoutes = require('./notifications');
const reportRoutes = require('./reports');
const onboardingRoutes = require('./onboarding');
const settingsRoutes = require('./settings');
const kpiTemplateRoutes = require('./kpiTemplates');

// Register routes
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/probation', probationRoutes);
router.use('/milestones', milestoneRoutes);
router.use('/dashboard', dashboardRoutes);
router.use('/assessment', assessmentRoutes);
router.use('/notifications', notificationRoutes);
router.use('/reports', reportRoutes);
router.use('/onboarding', onboardingRoutes);
router.use('/settings', settingsRoutes);
router.use('/kpi-templates', kpiTemplateRoutes);

// API info route
router.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'KPI Probation Tracking API',
    version: '1.0.0',
    documentation: '/api/v1/docs',
    endpoints: {
      auth: '/api/v1/auth',
      users: '/api/v1/users',
      probation: '/api/v1/probation',
      notifications: '/api/v1/notifications',
      dashboard: '/api/v1/dashboard',
      reports: '/api/v1/reports',
    },
  });
});

module.exports = router;
