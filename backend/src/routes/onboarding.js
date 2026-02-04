const express = require('express');
const {
    createTemplate,
    getTemplates,
    assignOnboarding,
    getMyOnboarding,
    getTeamOnboarding,
    submitAnswer,
    reviewMission,
    getOnboardingById,
} = require('../controllers/onboardingController');
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');

const router = express.Router();

// Protect all routes
router.use(authenticate);

// Template management (Admin only)
router.post('/templates', authorize(ROLES.HR_ADMIN), createTemplate);
router.get('/templates', getTemplates); // All authenticated users can view available templates? Or just Admin/HR? Let's allow all for now or restrict.

// Onboarding management
router.post('/assign', authorize(ROLES.HR_ADMIN), assignOnboarding);
router.get('/me', getMyOnboarding);
router.get('/team', authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN), getTeamOnboarding);
router.get('/:id', getOnboardingById);

// Interaction
router.post('/submit', submitAnswer); // User submitting their own
router.post('/review', authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN), reviewMission);

module.exports = router;
