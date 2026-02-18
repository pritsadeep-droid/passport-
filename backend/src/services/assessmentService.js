const ProbationRecord = require('../models/ProbationRecord');
const AuditLog = require('../models/AuditLog');
const { ApiError } = require('../middleware/errorHandler');

const PASSING_SCORE = 3.0;
const MIN_SCORE = 1;
const MAX_SCORE = 5;

/**
 * Calculate average score from assessment scores
 * @param {Object} scores - Assessment scores object
 * @returns {number} Average score
 */
const calculateAverageScore = (scores) => {
  const { coreValue, jobPerformance, attendance, cultureFit } = scores;

  const values = [
    coreValue?.score,
    jobPerformance?.score,
    attendance?.score,
    cultureFit?.score,
  ].filter((v) => v !== null && v !== undefined);

  if (values.length === 0) {return 0;}

  const sum = values.reduce((acc, val) => acc + val, 0);
  return Math.round((sum / values.length) * 100) / 100;
};

/**
 * Check if score is passing
 * @param {number} score - Average score
 * @returns {boolean} Whether score is passing
 */
const isPassing = (score) => {
  return score >= PASSING_SCORE;
};

/**
 * Validate score value
 * @param {number} score - Score to validate
 * @returns {boolean} Whether score is valid
 */
const isValidScore = (score) => {
  return (
    Number.isInteger(score) && score >= MIN_SCORE && score <= MAX_SCORE
  );
};

/**
 * Validate assessment scores object
 * @param {Object} scores - Assessment scores
 * @throws {ApiError} If scores are invalid
 */
const validateAssessmentScores = (scores) => {
  const requiredFields = ['coreValue', 'jobPerformance', 'attendance', 'cultureFit'];

  for (const field of requiredFields) {
    if (!scores[field] || scores[field].score === null || scores[field].score === undefined) {
      throw new ApiError(400, `กรุณากรอกคะแนน ${field}`);
    }

    if (!isValidScore(scores[field].score)) {
      throw new ApiError(400, `คะแนน ${field} ต้องเป็นตัวเลข 1-5`);
    }
  }
};

/**
 * Submit self assessment
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day
 * @param {Object} assessmentData - Assessment data
 * @param {string} userId - Employee user ID
 * @param {Object} metadata - Request metadata
 * @returns {Promise<Object>} Updated probation record
 */
const submitSelfAssessment = async (
  probationRecordId,
  day,
  assessmentData,
  userId,
  metadata = {}
) => {
  const record = await ProbationRecord.findById(probationRecordId);

  if (!record) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Verify employee is submitting their own assessment
  if (record.employeeId.toString() !== userId.toString()) {
    throw new ApiError(403, 'ไม่มีสิทธิ์ส่งการประเมินนี้');
  }

  const milestoneIndex = record.milestones.findIndex((m) => m.day === day);

  if (milestoneIndex === -1) {
    throw new ApiError(404, `ไม่พบ Milestone วันที่ ${day}`);
  }

  const milestone = record.milestones[milestoneIndex];

  // Check if milestone is in correct status
  if (!['pending_self', 'overdue'].includes(milestone.status)) {
    throw new ApiError(400, 'ไม่สามารถส่งการประเมินตนเองได้ในสถานะปัจจุบัน');
  }

  const { coreValue, jobPerformance, attendance, cultureFit, comments, isDraft } =
    assessmentData;

  // If not draft, validate all fields
  if (!isDraft) {
    validateAssessmentScores({ coreValue, jobPerformance, attendance, cultureFit });
  }

  // Calculate average score
  const averageScore = calculateAverageScore({
    coreValue,
    jobPerformance,
    attendance,
    cultureFit,
  });

  // Update self assessment
  record.milestones[milestoneIndex].selfAssessment = {
    coreValue,
    jobPerformance,
    attendance,
    cultureFit,
    averageScore,
    comments: comments?.trim() || null,
    isDraft: isDraft || false,
    submittedAt: isDraft ? null : new Date(),
    lastSavedAt: new Date(),
  };

  // Update milestone status if not draft
  if (!isDraft) {
    record.milestones[milestoneIndex].status = 'pending_supervisor';
  }

  await record.save();

  // Log action
  await AuditLog.log({
    action: isDraft ? 'assessment.self.draft_saved' : 'assessment.self.submitted',
    userId,
    targetType: 'milestone',
    targetId: record._id,
    changes: {
      after: { day, averageScore, isDraft },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return record;
};

/**
 * Submit supervisor assessment
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day
 * @param {Object} assessmentData - Assessment data
 * @param {string} userId - Supervisor user ID
 * @param {Object} metadata - Request metadata
 * @returns {Promise<Object>} Updated probation record
 */
const submitSupervisorAssessment = async (
  probationRecordId,
  day,
  assessmentData,
  userId,
  metadata = {}
) => {
  const record = await ProbationRecord.findById(probationRecordId);

  if (!record) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Verify supervisor is authorized
  if (record.supervisorId.toString() !== userId.toString()) {
    throw new ApiError(403, 'ไม่มีสิทธิ์ส่งการประเมินนี้');
  }

  const milestoneIndex = record.milestones.findIndex((m) => m.day === day);

  if (milestoneIndex === -1) {
    throw new ApiError(404, `ไม่พบ Milestone วันที่ ${day}`);
  }

  const milestone = record.milestones[milestoneIndex];

  // Check if milestone is in correct status
  if (milestone.status !== 'pending_supervisor') {
    throw new ApiError(400, 'ไม่สามารถส่งการประเมินได้ในสถานะปัจจุบัน');
  }

  const {
    coreValue,
    jobPerformance,
    attendance,
    cultureFit,
    kpiScores,
    overallComment,
    recommendation,
  } = assessmentData;

  // Validate scores
  validateAssessmentScores({ coreValue, jobPerformance, attendance, cultureFit });

  // Validate overall comment
  if (!overallComment || overallComment.trim().length < 10) {
    throw new ApiError(400, 'กรุณากรอกความเห็นอย่างน้อย 10 ตัวอักษร');
  }

  // Validate recommendation
  if (!['pass', 'fail', 'extend'].includes(recommendation)) {
    throw new ApiError(400, 'กรุณาเลือกข้อเสนอแนะ');
  }

  // Validate KPI scores if provided
  if (kpiScores && kpiScores.length > 0) {
    for (const kpiScore of kpiScores) {
      if (!isValidScore(kpiScore.score)) {
        throw new ApiError(400, 'คะแนน KPI ต้องเป็นตัวเลข 1-5');
      }
    }
  }

  // Calculate average score
  const averageScore = calculateAverageScore({
    coreValue,
    jobPerformance,
    attendance,
    cultureFit,
  });

  // Update supervisor assessment
  record.milestones[milestoneIndex].supervisorAssessment = {
    coreValue,
    jobPerformance,
    attendance,
    cultureFit,
    averageScore,
    kpiScores: kpiScores || [],
    overallComment: overallComment.trim(),
    recommendation,
    submittedAt: new Date(),
  };

  // Update milestone status
  record.milestones[milestoneIndex].status = 'pending_approval';

  await record.save();

  // Log action
  await AuditLog.log({
    action: 'assessment.supervisor.submitted',
    userId,
    targetType: 'milestone',
    targetId: record._id,
    changes: {
      after: { day, averageScore, recommendation },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return record;
};

/**
 * Get self assessment for a milestone
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day
 * @returns {Promise<Object>} Self assessment data
 */
const getSelfAssessment = async (probationRecordId, day) => {
  const record = await ProbationRecord.findById(probationRecordId);

  if (!record) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const milestone = record.milestones.find((m) => m.day === day);

  if (!milestone) {
    throw new ApiError(404, `ไม่พบ Milestone วันที่ ${day}`);
  }

  return milestone.selfAssessment || null;
};

/**
 * Get supervisor assessment for a milestone
 * @param {string} probationRecordId - Probation record ID
 * @param {number} day - Milestone day
 * @returns {Promise<Object>} Supervisor assessment data
 */
const getSupervisorAssessment = async (probationRecordId, day) => {
  const record = await ProbationRecord.findById(probationRecordId);

  if (!record) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const milestone = record.milestones.find((m) => m.day === day);

  if (!milestone) {
    throw new ApiError(404, `ไม่พบ Milestone วันที่ ${day}`);
  }

  return milestone.supervisorAssessment || null;
};

/**
 * Get score label in Thai
 * @param {number} score - Score value (1-5)
 * @returns {string} Score label
 */
const getScoreLabel = (score) => {
  const labels = {
    1: 'ต้องปรับปรุงมาก',
    2: 'ต้องปรับปรุง',
    3: 'พอใช้',
    4: 'ดี',
    5: 'ดีเยี่ยม',
  };
  return labels[score] || '';
};

module.exports = {
  PASSING_SCORE,
  MIN_SCORE,
  MAX_SCORE,
  calculateAverageScore,
  isPassing,
  isValidScore,
  validateAssessmentScores,
  submitSelfAssessment,
  submitSupervisorAssessment,
  getSelfAssessment,
  getSupervisorAssessment,
  getScoreLabel,
};
