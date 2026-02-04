const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');
const settingsController = require('../controllers/settingsController');

// GET /api/v1/settings — any authenticated user
router.get('/', authenticate, settingsController.getSettings);

// PUT /api/v1/settings/milestones — HR_ADMIN only
router.put(
  '/milestones',
  authenticate,
  authorize(ROLES.HR_ADMIN),
  settingsController.updateMilestoneSettings
);

module.exports = router;
