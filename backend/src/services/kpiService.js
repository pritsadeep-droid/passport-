const { v4: uuidv4 } = require('uuid');
const ProbationRecord = require('../models/ProbationRecord');
const AuditLog = require('../models/AuditLog');
const { ApiError } = require('../middleware/errorHandler');

const MIN_KPIS = 3;
const MAX_KPIS = 5;

/**
 * Validate KPI count
 * @param {number} count - Number of KPIs
 * @throws {ApiError} If count is invalid
 */
const validateKpiCount = (count) => {
  if (count < MIN_KPIS) {
    throw new ApiError(400, `ต้องมี KPI อย่างน้อย ${MIN_KPIS} ข้อ`);
  }
  if (count > MAX_KPIS) {
    throw new ApiError(400, `KPI ได้สูงสุด ${MAX_KPIS} ข้อ`);
  }
};

/**
 * Validate KPI data
 * @param {Object} kpiData - KPI data to validate
 * @throws {ApiError} If data is invalid
 */
const validateKpiData = (kpiData) => {
  const { title, description, criteria } = kpiData;

  if (!title || title.trim().length === 0) {
    throw new ApiError(400, 'ชื่อ KPI จำเป็นต้องกรอก');
  }
  if (title.length > 200) {
    throw new ApiError(400, 'ชื่อ KPI ต้องไม่เกิน 200 ตัวอักษร');
  }

  if (!description || description.trim().length === 0) {
    throw new ApiError(400, 'รายละเอียด KPI จำเป็นต้องกรอก');
  }
  if (description.length > 1000) {
    throw new ApiError(400, 'รายละเอียด KPI ต้องไม่เกิน 1000 ตัวอักษร');
  }

  if (!criteria || criteria.trim().length === 0) {
    throw new ApiError(400, 'เกณฑ์วัดผล KPI จำเป็นต้องกรอก');
  }
  if (criteria.length > 500) {
    throw new ApiError(400, 'เกณฑ์วัดผล KPI ต้องไม่เกิน 500 ตัวอักษร');
  }
};

/**
 * Create KPIs for a probation record
 * @param {string} probationRecordId - Probation record ID
 * @param {Array} kpisData - Array of KPI data
 * @param {string} userId - User creating the KPIs
 * @param {Object} metadata - Request metadata (ip, userAgent)
 * @returns {Promise<Object>} Updated probation record
 */
const createKpis = async (probationRecordId, kpisData, userId, metadata = {}) => {
  // Validate KPI count
  validateKpiCount(kpisData.length);

  // Validate each KPI
  kpisData.forEach(validateKpiData);

  const probationRecord = await ProbationRecord.findById(probationRecordId);

  if (!probationRecord) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check if KPIs already exist
  if (probationRecord.kpis.length > 0) {
    throw new ApiError(400, 'มี KPI อยู่แล้ว กรุณาใช้ฟังก์ชันแก้ไขแทน');
  }

  // Check status
  if (probationRecord.status !== 'pending_kpi') {
    throw new ApiError(400, 'ไม่สามารถเพิ่ม KPI ได้ในสถานะปัจจุบัน');
  }

  // Create KPIs
  const kpis = kpisData.map((kpi) => ({
    id: uuidv4(),
    title: kpi.title.trim(),
    description: kpi.description.trim(),
    criteria: kpi.criteria.trim(),
    status: 'active',
    createdAt: new Date(),
    updatedAt: new Date(),
  }));

  // Update probation record
  probationRecord.kpis = kpis;
  probationRecord.status = 'in_progress';
  await probationRecord.save();

  // Log action
  await AuditLog.log({
    action: 'kpi.created',
    userId,
    targetType: 'probation_record',
    targetId: probationRecord._id,
    changes: {
      after: { kpis: kpis.map((k) => ({ id: k.id, title: k.title })) },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return probationRecord;
};

/**
 * Add a single KPI to existing record
 * @param {string} probationRecordId - Probation record ID
 * @param {Object} kpiData - KPI data
 * @param {string} userId - User adding the KPI
 * @param {Object} metadata - Request metadata
 * @returns {Promise<Object>} Updated probation record
 */
const addKpi = async (probationRecordId, kpiData, userId, metadata = {}) => {
  validateKpiData(kpiData);

  const probationRecord = await ProbationRecord.findById(probationRecordId);

  if (!probationRecord) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  // Check max KPIs
  if (probationRecord.kpis.length >= MAX_KPIS) {
    throw new ApiError(400, `KPI ได้สูงสุด ${MAX_KPIS} ข้อ`);
  }

  // Check status
  if (!['pending_kpi', 'in_progress'].includes(probationRecord.status)) {
    throw new ApiError(400, 'ไม่สามารถเพิ่ม KPI ได้ในสถานะปัจจุบัน');
  }

  const newKpi = {
    id: uuidv4(),
    title: kpiData.title.trim(),
    description: kpiData.description.trim(),
    criteria: kpiData.criteria.trim(),
    status: 'active',
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  probationRecord.kpis.push(newKpi);

  // Update status if moving from pending_kpi
  if (
    probationRecord.status === 'pending_kpi' &&
    probationRecord.kpis.length >= MIN_KPIS
  ) {
    probationRecord.status = 'in_progress';
  }

  await probationRecord.save();

  // Log action
  await AuditLog.log({
    action: 'kpi.added',
    userId,
    targetType: 'probation_record',
    targetId: probationRecord._id,
    changes: {
      after: { kpi: { id: newKpi.id, title: newKpi.title } },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return probationRecord;
};

/**
 * Update a KPI
 * @param {string} probationRecordId - Probation record ID
 * @param {string} kpiId - KPI ID
 * @param {Object} updateData - Update data
 * @param {string} userId - User updating the KPI
 * @param {Object} metadata - Request metadata
 * @returns {Promise<Object>} Updated probation record
 */
const updateKpi = async (
  probationRecordId,
  kpiId,
  updateData,
  userId,
  metadata = {}
) => {
  const probationRecord = await ProbationRecord.findById(probationRecordId);

  if (!probationRecord) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const kpiIndex = probationRecord.kpis.findIndex((k) => k.id === kpiId);

  if (kpiIndex === -1) {
    throw new ApiError(404, 'ไม่พบ KPI');
  }

  // Check status - can only update in certain statuses
  if (!['pending_kpi', 'in_progress'].includes(probationRecord.status)) {
    throw new ApiError(400, 'ไม่สามารถแก้ไข KPI ได้ในสถานะปัจจุบัน');
  }

  const kpi = probationRecord.kpis[kpiIndex];
  const oldValues = {
    title: kpi.title,
    description: kpi.description,
    criteria: kpi.criteria,
    status: kpi.status,
  };

  // Update fields
  if (updateData.title !== undefined) {
    if (updateData.title.length > 200) {
      throw new ApiError(400, 'ชื่อ KPI ต้องไม่เกิน 200 ตัวอักษร');
    }
    kpi.title = updateData.title.trim();
  }
  if (updateData.description !== undefined) {
    if (updateData.description.length > 1000) {
      throw new ApiError(400, 'รายละเอียด KPI ต้องไม่เกิน 1000 ตัวอักษร');
    }
    kpi.description = updateData.description.trim();
  }
  if (updateData.criteria !== undefined) {
    if (updateData.criteria.length > 500) {
      throw new ApiError(400, 'เกณฑ์วัดผล KPI ต้องไม่เกิน 500 ตัวอักษร');
    }
    kpi.criteria = updateData.criteria.trim();
  }
  if (updateData.status !== undefined) {
    if (!['active', 'completed', 'cancelled'].includes(updateData.status)) {
      throw new ApiError(400, 'สถานะ KPI ไม่ถูกต้อง');
    }
    kpi.status = updateData.status;
  }

  kpi.updatedAt = new Date();
  probationRecord.kpis[kpiIndex] = kpi;
  await probationRecord.save();

  // Log action
  await AuditLog.log({
    action: 'kpi.updated',
    userId,
    targetType: 'kpi',
    targetId: probationRecord._id,
    changes: {
      before: oldValues,
      after: {
        title: kpi.title,
        description: kpi.description,
        criteria: kpi.criteria,
        status: kpi.status,
      },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return probationRecord;
};

/**
 * Delete a KPI
 * @param {string} probationRecordId - Probation record ID
 * @param {string} kpiId - KPI ID
 * @param {string} userId - User deleting the KPI
 * @param {Object} metadata - Request metadata
 * @returns {Promise<Object>} Updated probation record
 */
const deleteKpi = async (probationRecordId, kpiId, userId, metadata = {}) => {
  const probationRecord = await ProbationRecord.findById(probationRecordId);

  if (!probationRecord) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  const kpiIndex = probationRecord.kpis.findIndex((k) => k.id === kpiId);

  if (kpiIndex === -1) {
    throw new ApiError(404, 'ไม่พบ KPI');
  }

  // Check status
  if (!['pending_kpi', 'in_progress'].includes(probationRecord.status)) {
    throw new ApiError(400, 'ไม่สามารถลบ KPI ได้ในสถานะปัจจุบัน');
  }

  // Check minimum KPIs if in_progress
  if (
    probationRecord.status === 'in_progress' &&
    probationRecord.kpis.length <= MIN_KPIS
  ) {
    throw new ApiError(400, `ต้องมี KPI อย่างน้อย ${MIN_KPIS} ข้อ`);
  }

  const deletedKpi = probationRecord.kpis[kpiIndex];
  probationRecord.kpis.splice(kpiIndex, 1);

  // Update status if needed
  if (
    probationRecord.status === 'in_progress' &&
    probationRecord.kpis.length < MIN_KPIS
  ) {
    probationRecord.status = 'pending_kpi';
  }

  await probationRecord.save();

  // Log action
  await AuditLog.log({
    action: 'kpi.deleted',
    userId,
    targetType: 'kpi',
    targetId: probationRecord._id,
    changes: {
      before: { kpi: { id: deletedKpi.id, title: deletedKpi.title } },
    },
    ip: metadata.ip,
    userAgent: metadata.userAgent,
  });

  return probationRecord;
};

/**
 * Get KPIs for a probation record
 * @param {string} probationRecordId - Probation record ID
 * @returns {Promise<Array>} Array of KPIs
 */
const getKpis = async (probationRecordId) => {
  const probationRecord = await ProbationRecord.findById(probationRecordId);

  if (!probationRecord) {
    throw new ApiError(404, 'ไม่พบข้อมูลการทดลองงาน');
  }

  return probationRecord.kpis;
};

module.exports = {
  MIN_KPIS,
  MAX_KPIS,
  validateKpiCount,
  validateKpiData,
  createKpis,
  addKpi,
  updateKpi,
  deleteKpi,
  getKpis,
};
