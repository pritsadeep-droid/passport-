const KpiTemplate = require('../models/KpiTemplate');
const { asyncHandler } = require('../middleware/errorHandler');
const {
  successResponse,
  createdResponse,
  notFoundResponse,
  badRequestResponse,
} = require('../utils/response');

const getTemplates = asyncHandler(async (req, res) => {
  const { category } = req.query;

  const query = { isActive: true };

  if (category) {
    query.category = category;
  }

  const templates = await KpiTemplate.find(query)
    .sort({ createdAt: -1 });

  return successResponse(res, 200, 'Templates retrieved', templates);
});

const getTemplate = asyncHandler(async (req, res) => {
  const template = await KpiTemplate.findById(req.params.id);

  if (!template || !template.isActive) {
    return notFoundResponse(res, 'Template not found');
  }

  return successResponse(res, 200, 'Template retrieved', template);
});

const createTemplate = asyncHandler(async (req, res) => {
  const { title, description, criteria, category } = req.body;

  if (!title || !description || !criteria) {
    return badRequestResponse(res, 'กรุณากรอกข้อมูลให้ครบถ้วน');
  }

  const template = await KpiTemplate.create({
    title,
    description,
    criteria,
    category: category || null,
    createdBy: req.userId,
    updatedBy: req.userId,
  });

  return createdResponse(res, 'สร้างเทมเพลตสำเร็จ', template);
});

const updateTemplate = asyncHandler(async (req, res) => {
  const { title, description, criteria, category } = req.body;

  const template = await KpiTemplate.findById(req.params.id);

  if (!template || !template.isActive) {
    return notFoundResponse(res, 'Template not found');
  }

  if (title !== undefined) {template.title = title;}
  if (description !== undefined) {template.description = description;}
  if (criteria !== undefined) {template.criteria = criteria;}
  if (category !== undefined) {template.category = category || null;}
  template.updatedBy = req.userId;

  await template.save();

  return successResponse(res, 200, 'อัปเดตเทมเพลตสำเร็จ', template);
});

const deleteTemplate = asyncHandler(async (req, res) => {
  const template = await KpiTemplate.findById(req.params.id);

  if (!template || !template.isActive) {
    return notFoundResponse(res, 'Template not found');
  }

  template.isActive = false;
  template.updatedBy = req.userId;
  await template.save();

  return successResponse(res, 200, 'ลบเทมเพลตสำเร็จ');
});

module.exports = {
  getTemplates,
  getTemplate,
  createTemplate,
  updateTemplate,
  deleteTemplate,
};
