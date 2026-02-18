const ProbationRecord = require('../models/ProbationRecord');
const milestoneService = require('../services/milestoneService');
const assessmentService = require('../services/assessmentService');
const { asyncHandler, ApiError } = require('../middleware/errorHandler');
const {
  successResponse,
  notFoundResponse,
} = require('../utils/response');

/**
 * @desc    Get milestones for a probation record
 * @route   GET /api/v1/probation/:id/milestones
 * @access  Private
 */
const getMilestones = asyncHandler(async (req, res) => {
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
    milestones: record.milestones,
    canApprove: isSupervisor || isHrAdmin,
    canSubmitSelf: isEmployee,
    canSubmitSupervisor: isSupervisor || isHrAdmin,
  });
});

/**
 * @desc    Get single milestone
 * @route   GET /api/v1/probation/:id/milestones/:day
 * @access  Private
 */
const getMilestone = asyncHandler(async (req, res) => {
  const day = parseInt(req.params.day);
  const { record, milestone } = await milestoneService.getMilestone(
    req.params.id,
    day
  );

  // Check authorization
  const isEmployee = record.employeeId._id.toString() === req.userId.toString();
  const isSupervisor =
    record.supervisorId._id.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isEmployee && !isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'ไม่มีสิทธิ์เข้าถึงข้อมูลนี้');
  }

  return successResponse(res, 200, 'Success', {
    milestone,
    employee: record.employeeId,
    supervisor: record.supervisorId,
    kpis: record.kpis,
    canApprove: (isSupervisor || isHrAdmin) && milestone.status === 'pending_approval',
    canSubmitSelf: isEmployee && ['pending_self', 'overdue'].includes(milestone.status),
    canSubmitSupervisor:
      (isSupervisor || isHrAdmin) && milestone.status === 'pending_supervisor',
  });
});

/**
 * @desc    Submit self assessment
 * @route   PUT /api/v1/probation/:id/milestones/:day/self-assessment
 * @access  Private (Employee)
 */
const submitSelfAssessment = asyncHandler(async (req, res) => {
  const day = parseInt(req.params.day);
  const { coreValue, jobPerformance, attendance, cultureFit, comments, isDraft } =
    req.body;

  const record = await assessmentService.submitSelfAssessment(
    req.params.id,
    day,
    { coreValue, jobPerformance, attendance, cultureFit, comments, isDraft },
    req.userId,
    { ip: req.ip, userAgent: req.headers['user-agent'] }
  );

  await record.populate('employeeId', 'employeeId email name');
  await record.populate('supervisorId', 'employeeId email name');

  const milestone = record.milestones.find((m) => m.day === day);

  return successResponse(
    res,
    200,
    isDraft ? 'บันทึกแบบร่างสำเร็จ' : 'ส่งการประเมินตนเองสำเร็จ',
    { milestone, record }
  );
});

/**
 * @desc    Get self assessment
 * @route   GET /api/v1/probation/:id/milestones/:day/self-assessment
 * @access  Private
 */
const getSelfAssessment = asyncHandler(async (req, res) => {
  const day = parseInt(req.params.day);
  const assessment = await assessmentService.getSelfAssessment(req.params.id, day);

  return successResponse(res, 200, 'Success', assessment);
});

/**
 * @desc    Submit supervisor assessment
 * @route   PUT /api/v1/probation/:id/milestones/:day/supervisor-assessment
 * @access  Private (Supervisor, HR Admin)
 */
const submitSupervisorAssessment = asyncHandler(async (req, res) => {
  const day = parseInt(req.params.day);
  const {
    coreValue,
    jobPerformance,
    attendance,
    cultureFit,
    kpiScores,
    overallComment,
    recommendation,
  } = req.body;

  const record = await assessmentService.submitSupervisorAssessment(
    req.params.id,
    day,
    {
      coreValue,
      jobPerformance,
      attendance,
      cultureFit,
      kpiScores,
      overallComment,
      recommendation,
    },
    req.userId,
    { ip: req.ip, userAgent: req.headers['user-agent'] }
  );

  await record.populate('employeeId', 'employeeId email name');
  await record.populate('supervisorId', 'employeeId email name');

  const milestone = record.milestones.find((m) => m.day === day);

  return successResponse(res, 200, 'ส่งการประเมินสำเร็จ', { milestone, record });
});

/**
 * @desc    Get supervisor assessment
 * @route   GET /api/v1/probation/:id/milestones/:day/supervisor-assessment
 * @access  Private
 */
const getSupervisorAssessment = asyncHandler(async (req, res) => {
  const day = parseInt(req.params.day);
  const assessment = await assessmentService.getSupervisorAssessment(
    req.params.id,
    day
  );

  return successResponse(res, 200, 'Success', assessment);
});

/**
 * @desc    Approve milestone
 * @route   POST /api/v1/probation/:id/milestones/:day/approve
 * @access  Private (Supervisor, HR Admin)
 */
const approveMilestone = asyncHandler(async (req, res) => {
  const day = parseInt(req.params.day);
  const { comment } = req.body;

  // Verify authorization
  const record = await ProbationRecord.findById(req.params.id);
  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const isSupervisor =
    record.supervisorId.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'ไม่มีสิทธิ์อนุมัติ Milestone นี้');
  }

  const updatedRecord = await milestoneService.approveMilestone(
    req.params.id,
    day,
    req.userId,
    { comment, metadata: { ip: req.ip, userAgent: req.headers['user-agent'] } }
  );

  await updatedRecord.populate('employeeId', 'employeeId email name');
  await updatedRecord.populate('supervisorId', 'employeeId email name');

  const milestone = updatedRecord.milestones.find((m) => m.day === day);

  return successResponse(res, 200, 'อนุมัติ Milestone สำเร็จ', {
    milestone,
    record: updatedRecord,
  });
});

/**
 * @desc    Reject milestone
 * @route   POST /api/v1/probation/:id/milestones/:day/reject
 * @access  Private (Supervisor, HR Admin)
 */
const rejectMilestone = asyncHandler(async (req, res) => {
  const day = parseInt(req.params.day);
  const { reason } = req.body;

  // Verify authorization
  const record = await ProbationRecord.findById(req.params.id);
  if (!record) {
    return notFoundResponse(res, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const isSupervisor =
    record.supervisorId.toString() === req.userId.toString();
  const isHrAdmin = req.user.role === 'hr_admin';

  if (!isSupervisor && !isHrAdmin) {
    throw new ApiError(403, 'ไม่มีสิทธิ์ปฏิเสธ Milestone นี้');
  }

  const updatedRecord = await milestoneService.rejectMilestone(
    req.params.id,
    day,
    req.userId,
    { reason, metadata: { ip: req.ip, userAgent: req.headers['user-agent'] } }
  );

  await updatedRecord.populate('employeeId', 'employeeId email name');
  await updatedRecord.populate('supervisorId', 'employeeId email name');

  const milestone = updatedRecord.milestones.find((m) => m.day === day);

  return successResponse(res, 200, 'ไม่อนุมัติ Milestone', {
    milestone,
    record: updatedRecord,
  });
});

/**
 * @desc    Get pending approvals for supervisor
 * @route   GET /api/v1/milestones/pending
 * @access  Private (Supervisor, HR Admin)
 */
const getPendingApprovals = asyncHandler(async (req, res) => {
  const pendingApprovals = await milestoneService.getPendingApprovals(req.userId);

  return successResponse(res, 200, 'Success', pendingApprovals);
});

module.exports = {
  getMilestones,
  getMilestone,
  submitSelfAssessment,
  getSelfAssessment,
  submitSupervisorAssessment,
  getSupervisorAssessment,
  approveMilestone,
  rejectMilestone,
  getPendingApprovals,
};
