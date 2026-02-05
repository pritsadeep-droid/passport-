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
    completeEvent,
    getJourney,
    updateTemplate,
} = require('../controllers/onboardingController');
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');

const router = express.Router();

// Protect all routes
router.use(authenticate);

// Template management (Admin only)
router.post('/templates', authorize(ROLES.HR_ADMIN), createTemplate);
router.get('/templates', getTemplates);
router.put('/templates/:id', authorize(ROLES.HR_ADMIN), updateTemplate);

// Onboarding management
router.post('/assign', authorize(ROLES.HR_ADMIN), assignOnboarding);
router.get('/me', getMyOnboarding);
router.get('/team', authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN), getTeamOnboarding);
router.get('/:id', getOnboardingById);
router.get('/:id/journey', getJourney);

// Interaction
router.post('/submit', submitAnswer);
router.post('/:id/complete-event', authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN), completeEvent);
router.post('/review', authorize(ROLES.SUPERVISOR, ROLES.HR_ADMIN), reviewMission);

module.exports = router;
