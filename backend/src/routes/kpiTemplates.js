const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { authorize, ROLES } = require('../middleware/authorize');
const {
  getTemplates,
  getTemplate,
  createTemplate,
  updateTemplate,
  deleteTemplate,
} = require('../controllers/kpiTemplateController');

// All routes require authentication
router.use(authenticate);

// Any authenticated user can read templates
router.get('/', getTemplates);
router.get('/:id', getTemplate);

// Only HR_ADMIN can create/update/delete
router.post('/', authorize(ROLES.HR_ADMIN), createTemplate);
router.put('/:id', authorize(ROLES.HR_ADMIN), updateTemplate);
router.delete('/:id', authorize(ROLES.HR_ADMIN), deleteTemplate);

module.exports = router;
