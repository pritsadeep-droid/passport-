const assessmentService = require('../services/assessmentService');
const { success } = require('../utils/response');
const { ApiError } = require('../middleware/errorHandler');

/**
 * Get self assessment for a milestone
 * GET /api/v1/assessment/:recordId/milestones/:day/self
 */
const getSelfAssessment = async (req, res, next) => {
  try {
    const { recordId, day } = req.params;
    const dayNum = parseInt(day, 10);

    const assessment = await assessmentService.getSelfAssessment(recordId, dayNum);

    return success(res, assessment, 'ดึงข้อมูลการประเมินตนเองสำเร็จ');
  } catch (error) {
    next(error);
  }
};

/**
 * Submit or update self assessment
 * PUT /api/v1/assessment/:recordId/milestones/:day/self
 */
const submitSelfAssessment = async (req, res, next) => {
  try {
    const { recordId, day } = req.params;
    const dayNum = parseInt(day, 10);
    const userId = req.user.id;

    const metadata = {
      ip: req.ip,
      userAgent: req.get('User-Agent'),
    };

    const record = await assessmentService.submitSelfAssessment(
      recordId,
      dayNum,
      req.body,
      userId,
      metadata
    );

    const milestone = record.milestones.find((m) => m.day === dayNum);
    const isDraft = req.body.isDraft || false;

    return success(
      res,
      {
        record: record.toObject(),
        milestone,
        assessment: milestone.selfAssessment,
      },
      isDraft ? 'บันทึกแบบร่างสำเร็จ' : 'ส่งการประเมินตนเองสำเร็จ'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get supervisor assessment for a milestone
 * GET /api/v1/assessment/:recordId/milestones/:day/supervisor
 */
const getSupervisorAssessment = async (req, res, next) => {
  try {
    const { recordId, day } = req.params;
    const dayNum = parseInt(day, 10);

    const assessment = await assessmentService.getSupervisorAssessment(
      recordId,
      dayNum
    );

    return success(res, assessment, 'ดึงข้อมูลการประเมินสำเร็จ');
  } catch (error) {
    next(error);
  }
};

/**
 * Submit supervisor assessment
 * PUT /api/v1/assessment/:recordId/milestones/:day/supervisor
 */
const submitSupervisorAssessment = async (req, res, next) => {
  try {
    const { recordId, day } = req.params;
    const dayNum = parseInt(day, 10);
    const userId = req.user.id;

    const metadata = {
      ip: req.ip,
      userAgent: req.get('User-Agent'),
    };

    const record = await assessmentService.submitSupervisorAssessment(
      recordId,
      dayNum,
      req.body,
      userId,
      metadata
    );

    const milestone = record.milestones.find((m) => m.day === dayNum);

    return success(
      res,
      {
        record: record.toObject(),
        milestone,
        assessment: milestone.supervisorAssessment,
      },
      'ส่งการประเมินสำเร็จ'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get current milestone for employee to assess
 * GET /api/v1/assessment/current
 */
const getCurrentAssessment = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const ProbationRecord = require('../models/ProbationRecord');

    const record = await ProbationRecord.findOne({
      employeeId: userId,
      status: { $in: ['in_progress', 'pending_decision'] },
    }).populate('supervisorId', 'name email');

    if (!record) {
      return success(res, null, 'ไม่พบข้อมูลการทดลองงาน');
    }

    // Find current milestone that needs self-assessment
    const pendingMilestone = record.milestones.find(
      (m) => m.status === 'pending_self' || m.status === 'overdue'
    );

    if (!pendingMilestone) {
      return success(
        res,
        {
          record: {
            id: record._id,
            status: record.status,
            startDate: record.startDate,
            endDate: record.endDate,
          },
          currentMilestone: null,
          message: 'ไม่มี Milestone ที่ต้องประเมินในขณะนี้',
        },
        'ดึงข้อมูลสำเร็จ'
      );
    }

    return success(
      res,
      {
        record: {
          id: record._id,
          status: record.status,
          startDate: record.startDate,
          endDate: record.endDate,
          supervisor: record.supervisorId,
        },
        currentMilestone: pendingMilestone,
        kpis: record.kpis,
      },
      'ดึงข้อมูลสำเร็จ'
    );
  } catch (error) {
    next(error);
  }
};

/**
 * Get all milestones for employee view
 * GET /api/v1/assessment/milestones
 */
const getMyMilestones = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const ProbationRecord = require('../models/ProbationRecord');

    const record = await ProbationRecord.findOne({
      employeeId: userId,
    })
      .populate('supervisorId', 'name email')
      .sort({ createdAt: -1 });

    if (!record) {
      return success(res, { milestones: [] }, 'ไม่พบข้อมูลการทดลองงาน');
    }

    return success(
      res,
      {
        record: {
          id: record._id,
          status: record.status,
          startDate: record.startDate,
          endDate: record.endDate,
          probationDays: record.probationDays,
          supervisor: record.supervisorId,
        },
        milestones: record.milestones,
        kpis: record.kpis,
      },
      'ดึงข้อมูลสำเร็จ'
    );
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getSelfAssessment,
  submitSelfAssessment,
  getSupervisorAssessment,
  submitSupervisorAssessment,
  getCurrentAssessment,
  getMyMilestones,
};
