const ProbationRecord = require('../models/ProbationRecord');
const kpiService = require('../services/kpiService');
const { asyncHandler, ApiError } = require('../middleware/errorHandler');
const {
  successResponse,
  notFoundResponse,
  createdResponse,
} = require('../utils/response');

/**
 * @desc    Get KPIs for a probation record
 * @route   GET /api/v1/probation/:id/kpis
 * @access  Private
 */
const getKpis = asyncHandler(async (req, res) => {
  const record = await ProbationRecord.findById(req.params.id)
    .populate('employeeId', 'employeeId email name')
    .populate('supervisorId', 'employeeId email name');

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check authorization
  const isEmployee = record.employeeId._id.toString() === req.userId.toString();
  const isSupervisor =
    record.supervisorId._id.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isEmployee && !isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'ไม่มีสิทธิ์เข้าถึงข้อมูลนี้');
  }

  return successResponse(res, 200, 'Success', {
    kpis: record.kpis,
    canEdit: isSupervisor || isHrAdmin,
    minKpis: kpiService.MIN_KPIS,
    maxKpis: kpiService.MAX_KPIS,
  });
});

/**
 * @desc    Create KPIs for a probation record (batch)
 * @route   POST /api/v1/probation/:id/kpis
 * @access  Private (Supervisor, HR Admin)
 */
const createKpis = asyncHandler(async (req, res) => {
  const { kpis } = req.body;

  if (!kpis || !Array.isArray(kpis)) {
    throw new ApiError(400, 'กรุณาระบุ KPIs เป็น array');
  }

  const record = await ProbationRecord.findById(req.params.id);

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check authorization - only supervisor of this employee or HR admin
  const isSupervisor =
    record.supervisorId.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'เฉพาะหัวหน้างานหรือ HR เท่านั้นที่สามารถกำหนด KPI ได้');
  }

  const updatedRecord = await kpiService.createKpis(
    req.params.id,
    kpis,
    req.userId,
    {
      ip: req.ip,
      userAgent: req.headers['user-agent'],
    }
  );

  await updatedRecord.populate('employeeId', 'employeeId email name department');
  await updatedRecord.populate('supervisorId', 'employeeId email name');

  return createdResponse(res, 'สร้าง KPI สำเร็จ', updatedRecord);
});

/**
 * @desc    Add single KPI to probation record
 * @route   POST /api/v1/probation/:id/kpis/add
 * @access  Private (Supervisor, HR Admin)
 */
const addKpi = asyncHandler(async (req, res) => {
  const { title, description, criteria } = req.body;

  const record = await ProbationRecord.findById(req.params.id);

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check authorization
  const isSupervisor =
    record.supervisorId.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'เฉพาะหัวหน้างานหรือ HR เท่านั้นที่สามารถเพิ่ม KPI ได้');
  }

  const updatedRecord = await kpiService.addKpi(
    req.params.id,
    { title, description, criteria },
    req.userId,
    {
      ip: req.ip,
      userAgent: req.headers['user-agent'],
    }
  );

  await updatedRecord.populate('employeeId', 'employeeId email name department');
  await updatedRecord.populate('supervisorId', 'employeeId email name');

  return createdResponse(res, 'เพิ่ม KPI สำเร็จ', updatedRecord);
});

/**
 * @desc    Update a KPI
 * @route   PATCH /api/v1/probation/:id/kpis/:kpiId
 * @access  Private (Supervisor, HR Admin)
 */
const updateKpi = asyncHandler(async (req, res) => {
  const { title, description, criteria, status } = req.body;
  const { id: probationId, kpiId } = req.params;

  const record = await ProbationRecord.findById(probationId);

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check authorization
  const isSupervisor =
    record.supervisorId.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'เฉพาะหัวหน้างานหรือ HR เท่านั้นที่สามารถแก้ไข KPI ได้');
  }

  const updatedRecord = await kpiService.updateKpi(
    probationId,
    kpiId,
    { title, description, criteria, status },
    req.userId,
    {
      ip: req.ip,
      userAgent: req.headers['user-agent'],
    }
  );

  await updatedRecord.populate('employeeId', 'employeeId email name department');
  await updatedRecord.populate('supervisorId', 'employeeId email name');

  return successResponse(res, 200, 'แก้ไข KPI สำเร็จ', updatedRecord);
});

/**
 * @desc    Delete a KPI
 * @route   DELETE /api/v1/probation/:id/kpis/:kpiId
 * @access  Private (Supervisor, HR Admin)
 */
const deleteKpi = asyncHandler(async (req, res) => {
  const { id: probationId, kpiId } = req.params;

  const record = await ProbationRecord.findById(probationId);

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check authorization
  const isSupervisor =
    record.supervisorId.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'เฉพาะหัวหน้างานหรือ HR เท่านั้นที่สามารถลบ KPI ได้');
  }

  const updatedRecord = await kpiService.deleteKpi(
    probationId,
    kpiId,
    req.userId,
    {
      ip: req.ip,
      userAgent: req.headers['user-agent'],
    }
  );

  await updatedRecord.populate('employeeId', 'employeeId email name department');
  await updatedRecord.populate('supervisorId', 'employeeId email name');

  return successResponse(res, 200, 'ลบ KPI สำเร็จ', updatedRecord);
});

module.exports = {
  getKpis,
  createKpis,
  addKpi,
  updateKpi,
  deleteKpi,
};
