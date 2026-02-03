const ProbationRecord = require('../models/ProbationRecord');
const User = require('../models/User');
const AuditLog = require('../models/AuditLog');
const { asyncHandler, ApiError } = require('../middleware/errorHandler');
const {
  successResponse,
  notFoundResponse,
  paginatedResponse,
  createdResponse,
} = require('../utils/response');

/**
 * @desc    Get probation records (filtered by role)
 * @route   GET /api/v1/probation
 * @access  Private
 */
const getProbationRecords = asyncHandler(async (req, res) => {
  const {
    page = 1,
    limit = 20,
    status,
    search,
  } = req.query;
  const skip = (page - 1) * limit;

  const query = {};

  // Filter based on user role
  if (req.user.role === 'employee') {
    // Employees can only see their own record
    query.employeeId = req.userId;
  } else if (req.user.role === 'supervisor') {
    // Supervisors see their team members
    query.supervisorId = req.userId;
  }
  // HR admin sees all

  // Status filter
  if (status) {
    query.status = status;
  }

  // Build the query with population
  let recordsQuery = ProbationRecord.find(query)
    .populate('employeeId', 'employeeId email name department')
    .populate('supervisorId', 'employeeId email name')
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(parseInt(limit));

  // Search filter (by employee name or ID)
  if (search) {
    // First find matching users
    const matchingUsers = await User.find({
      $or: [
        { name: { $regex: search, $options: 'i' } },
        { employeeId: { $regex: search, $options: 'i' } },
        { email: { $regex: search, $options: 'i' } },
      ],
    }).select('_id');

    const userIds = matchingUsers.map((u) => u._id);
    query.employeeId = { $in: userIds };
  }

  const [records, total] = await Promise.all([
    recordsQuery,
    ProbationRecord.countDocuments(query),
  ]);

  return paginatedResponse(res, {
    data: records,
    page: parseInt(page),
    limit: parseInt(limit),
    total,
    message: 'Probation records retrieved',
  });
});

/**
 * @desc    Get single probation record by ID
 * @route   GET /api/v1/probation/:id
 * @access  Private
 */
const getProbationRecordById = asyncHandler(async (req, res) => {
  const record = await ProbationRecord.findById(req.params.id)
    .populate('employeeId', 'employeeId email name department')
    .populate('supervisorId', 'employeeId email name')
    .populate('finalDecision.decidedBy', 'name email');

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

  return successResponse(res, 200, 'Success', record);
});

/**
 * @desc    Get probation record by employee ID
 * @route   GET /api/v1/probation/employee/:employeeId
 * @access  Private
 */
const getProbationRecordByEmployeeId = asyncHandler(async (req, res) => {
  const record = await ProbationRecord.findOne({
    employeeId: req.params.employeeId,
  })
    .populate('employeeId', 'employeeId email name department')
    .populate('supervisorId', 'employeeId email name')
    .populate('finalDecision.decidedBy', 'name email');

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check authorization
  const isEmployee =
    record.employeeId._id.toString() === req.userId.toString();
  const isSupervisor =
    record.supervisorId._id.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isEmployee && !isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'ไม่มีสิทธิ์เข้าถึงข้อมูลนี้');
  }

  return successResponse(res, 200, 'Success', record);
});

/**
 * @desc    Create probation record for new employee
 * @route   POST /api/v1/probation
 * @access  Private (HR Admin)
 */
const createProbationRecord = asyncHandler(async (req, res) => {
  const { employeeId, supervisorId, startDate, probationDays = 90 } = req.body;

  // Validate employee exists
  const employee = await User.findById(employeeId);
  if (!employee) {
    throw new ApiError(404, 'ไม่พบข้อมูลพนักงาน');
  }

  // Check employee role
  if (employee.role !== 'employee') {
    throw new ApiError(400, 'สามารถสร้างข้อมูลทดลองงานได้เฉพาะพนักงานใหม่เท่านั้น');
  }

  // Check if employee already has a probation record
  const existingRecord = await ProbationRecord.findOne({ employeeId });
  if (existingRecord) {
    throw new ApiError(409, 'พนักงานนี้มีข้อมูลทดลองงานอยู่แล้ว');
  }

  // Validate supervisor exists
  const supervisor = await User.findById(supervisorId);
  if (!supervisor) {
    throw new ApiError(404, 'ไม่พบข้อมูลหัวหน้างาน');
  }

  // Check supervisor role
  if (!['supervisor', 'hr_admin'].includes(supervisor.role)) {
    throw new ApiError(400, 'หัวหน้างานต้องมี role เป็น supervisor หรือ hr_admin');
  }

  // Update employee's supervisor
  employee.supervisorId = supervisorId;
  await employee.save();

  // Create probation record
  const record = await ProbationRecord.create({
    employeeId,
    supervisorId,
    startDate: new Date(startDate),
    probationDays,
  });

  // Log action
  await AuditLog.log({
    action: 'probation.created',
    userId: req.userId,
    targetType: 'probation_record',
    targetId: record._id,
    changes: {
      after: {
        employeeId,
        supervisorId,
        startDate,
        probationDays,
      },
    },
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  // Populate and return
  await record.populate('employeeId', 'employeeId email name department');
  await record.populate('supervisorId', 'employeeId email name');

  return createdResponse(res, 'สร้างข้อมูลทดลองงานสำเร็จ', record);
});

/**
 * @desc    Update probation record status
 * @route   PATCH /api/v1/probation/:id/status
 * @access  Private (HR Admin)
 */
const updateProbationStatus = asyncHandler(async (req, res) => {
  const { status, reason } = req.body;

  const record = await ProbationRecord.findById(req.params.id);

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const oldStatus = record.status;

  // Validate status transition
  const validTransitions = {
    pending_kpi: ['in_progress', 'resigned', 'terminated'],
    in_progress: ['pending_decision', 'resigned', 'terminated'],
    pending_decision: ['passed', 'failed', 'resigned', 'terminated'],
  };

  if (
    !validTransitions[record.status] ||
    !validTransitions[record.status].includes(status)
  ) {
    throw new ApiError(
      400,
      `ไม่สามารถเปลี่ยนสถานะจาก ${record.status} เป็น ${status} ได้`
    );
  }

  // If final decision, record it
  if (['passed', 'failed'].includes(status)) {
    record.finalDecision = {
      decision: status,
      decidedBy: req.userId,
      decidedAt: new Date(),
      reason: reason || null,
    };
  }

  record.status = status;
  await record.save();

  // Log action
  await AuditLog.log({
    action: 'probation.status_changed',
    userId: req.userId,
    targetType: 'probation_record',
    targetId: record._id,
    changes: {
      before: { status: oldStatus },
      after: { status, reason },
    },
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  await record.populate('employeeId', 'employeeId email name department');
  await record.populate('supervisorId', 'employeeId email name');

  return successResponse(res, 200, 'อัปเดตสถานะสำเร็จ', record);
});

/**
 * @desc    Transfer supervisor
 * @route   PATCH /api/v1/probation/:id/supervisor
 * @access  Private (HR Admin)
 */
const transferSupervisor = asyncHandler(async (req, res) => {
  const { newSupervisorId, reason } = req.body;

  const record = await ProbationRecord.findById(req.params.id);

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Validate new supervisor
  const newSupervisor = await User.findById(newSupervisorId);
  if (!newSupervisor) {
    throw new ApiError(404, 'ไม่พบข้อมูลหัวหน้างานใหม่');
  }

  if (!['supervisor', 'hr_admin'].includes(newSupervisor.role)) {
    throw new ApiError(400, 'หัวหน้างานต้องมี role เป็น supervisor หรือ hr_admin');
  }

  const oldSupervisorId = record.supervisorId;
  record.supervisorId = newSupervisorId;
  await record.save();

  // Update employee's supervisor
  await User.findByIdAndUpdate(record.employeeId, {
    supervisorId: newSupervisorId,
  });

  // Log action
  await AuditLog.log({
    action: 'probation.supervisor_changed',
    userId: req.userId,
    targetType: 'probation_record',
    targetId: record._id,
    changes: {
      before: { supervisorId: oldSupervisorId },
      after: { supervisorId: newSupervisorId, reason },
    },
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  await record.populate('employeeId', 'employeeId email name department');
  await record.populate('supervisorId', 'employeeId email name');

  return successResponse(res, 200, 'เปลี่ยนหัวหน้างานสำเร็จ', record);
});

/**
 * @desc    Get my probation record (for employee)
 * @route   GET /api/v1/probation/me
 * @access  Private (Employee)
 */
const getMyProbationRecord = asyncHandler(async (req, res) => {
  const record = await ProbationRecord.findOne({ employeeId: req.userId })
    .populate('employeeId', 'employeeId email name department')
    .populate('supervisorId', 'employeeId email name')
    .populate('finalDecision.decidedBy', 'name email');

  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  return successResponse(res, 200, 'Success', record);
});

module.exports = {
  getProbationRecords,
  getProbationRecordById,
  getProbationRecordByEmployeeId,
  createProbationRecord,
  updateProbationStatus,
  transferSupervisor,
  getMyProbationRecord,
};
