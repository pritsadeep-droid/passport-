/**
 * Excel Generation Service
 * Generates Excel reports for probation records
 */

const ExcelJS = require('exceljs');
const ProbationRecord = require('../models/ProbationRecord');
const { formatThaiDate, STATUS_LABELS, MILESTONE_STATUS_LABELS } = require('./reportService');

/**
 * Style configurations
 */
const HEADER_STYLE = {
  font: { bold: true, color: { argb: 'FFFFFFFF' } },
  fill: { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF8B0000' } }, // Dark red
  alignment: { horizontal: 'center', vertical: 'middle', wrapText: true },
  border: {
    top: { style: 'thin' },
    left: { style: 'thin' },
    bottom: { style: 'thin' },
    right: { style: 'thin' }
  }
};

const CELL_STYLE = {
  alignment: { vertical: 'middle', wrapText: true },
  border: {
    top: { style: 'thin' },
    left: { style: 'thin' },
    bottom: { style: 'thin' },
    right: { style: 'thin' }
  }
};

const STATUS_COLORS = {
  in_progress: 'FFFFF3CD', // Light yellow
  pending_decision: 'FFCCE5FF', // Light blue
  passed: 'FFD4EDDA', // Light green
  failed: 'FFF8D7DA', // Light red
  extended: 'FFFFE5D0', // Light orange
  terminated: 'FFE2E3E5' // Light gray
};

/**
 * Generate Excel report for a single employee's probation
 */
const generateEmployeeExcel = async (employeeId) => {
  const record = await ProbationRecord.findOne({ employee: employeeId })
    .populate('employee', 'name email employeeId department position')
    .populate('supervisor', 'name email employeeId')
    .lean();

  if (!record) {
    throw new Error('Probation record not found');
  }

  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'HR System';
  workbook.created = new Date();

  // Summary Sheet
  const summarySheet = workbook.addWorksheet('ข้อมูลทั่วไป');

  // Title
  summarySheet.mergeCells('A1:D1');
  const titleCell = summarySheet.getCell('A1');
  titleCell.value = `รายงานทดลองงาน - ${record.employee.name}`;
  titleCell.font = { size: 16, bold: true };
  titleCell.alignment = { horizontal: 'center' };

  // Employee info section
  const infoData = [
    ['ข้อมูลพนักงาน', ''],
    ['ชื่อ-นามสกุล', record.employee.name],
    ['รหัสพนักงาน', record.employee.employeeId],
    ['ตำแหน่ง', record.employee.position || '-'],
    ['แผนก', record.employee.department || '-'],
    ['อีเมล', record.employee.email],
    ['หัวหน้างาน', record.supervisor?.name || '-'],
    ['', ''],
    ['ข้อมูลทดลองงาน', ''],
    ['วันที่เริ่ม', formatThaiDate(record.startDate)],
    ['วันที่สิ้นสุด', formatThaiDate(record.endDate)],
    ['จำนวนวัน', `${record.probationDays} วัน`],
    ['สถานะ', STATUS_LABELS[record.status] || record.status]
  ];

  infoData.forEach((row, index) => {
    const rowNum = index + 3;
    summarySheet.getCell(`A${rowNum}`).value = row[0];
    summarySheet.getCell(`B${rowNum}`).value = row[1];

    if (row[0].includes('ข้อมูล')) {
      summarySheet.getCell(`A${rowNum}`).font = { bold: true };
    }
  });

  summarySheet.getColumn('A').width = 20;
  summarySheet.getColumn('B').width = 40;

  // KPIs Sheet
  if (record.kpis && record.kpis.length > 0) {
    const kpiSheet = workbook.addWorksheet('KPI');

    kpiSheet.columns = [
      { header: 'ลำดับ', key: 'index', width: 8 },
      { header: 'หัวข้อ KPI', key: 'title', width: 40 },
      { header: 'รายละเอียด', key: 'description', width: 50 },
      { header: 'น้ำหนัก (%)', key: 'weight', width: 12 }
    ];

    // Style header
    kpiSheet.getRow(1).eachCell((cell) => {
      Object.assign(cell, HEADER_STYLE);
    });

    record.kpis.forEach((kpi, index) => {
      const row = kpiSheet.addRow({
        index: index + 1,
        title: kpi.title,
        description: kpi.description || '-',
        weight: kpi.weight || '-'
      });
      row.eachCell((cell) => {
        Object.assign(cell, CELL_STYLE);
      });
    });
  }

  // Milestones Sheet
  if (record.milestones && record.milestones.length > 0) {
    const milestoneSheet = workbook.addWorksheet('Milestones');

    milestoneSheet.columns = [
      { header: 'วัน', key: 'day', width: 8 },
      { header: 'วันที่ครบกำหนด', key: 'dueDate', width: 18 },
      { header: 'สถานะ', key: 'status', width: 18 },
      { header: 'คะแนนตนเอง', key: 'selfScore', width: 14 },
      { header: 'คะแนนหัวหน้า', key: 'supervisorScore', width: 14 },
      { header: 'คะแนนรวม', key: 'totalScore', width: 12 },
      { header: 'ผลลัพธ์', key: 'result', width: 12 },
      { header: 'หมายเหตุ', key: 'comments', width: 30 }
    ];

    // Style header
    milestoneSheet.getRow(1).eachCell((cell) => {
      Object.assign(cell, HEADER_STYLE);
    });

    record.milestones.forEach((milestone) => {
      const row = milestoneSheet.addRow({
        day: milestone.day,
        dueDate: formatThaiDate(milestone.dueDate),
        status: MILESTONE_STATUS_LABELS[milestone.status] || milestone.status,
        selfScore: milestone.selfAssessment?.totalScore?.toFixed(2) || '-',
        supervisorScore: milestone.supervisorAssessment?.totalScore?.toFixed(2) || '-',
        totalScore: milestone.supervisorAssessment?.totalScore?.toFixed(2) || '-',
        result: milestone.status === 'passed' ? 'ผ่าน' :
                milestone.status === 'failed' ? 'ไม่ผ่าน' : '-',
        comments: milestone.supervisorAssessment?.feedback || '-'
      });
      row.eachCell((cell) => {
        Object.assign(cell, CELL_STYLE);
      });

      // Color code based on status
      if (milestone.status === 'passed') {
        row.eachCell((cell) => {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFD4EDDA' } };
        });
      } else if (milestone.status === 'failed') {
        row.eachCell((cell) => {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF8D7DA' } };
        });
      }
    });
  }

  // Generate buffer
  return workbook.xlsx.writeBuffer();
};

/**
 * Generate summary Excel report for all probation records
 */
const generateSummaryExcel = async (filters = {}) => {
  const query = {};

  if (filters.status) {
    query.status = filters.status;
  }
  if (filters.department) {
    query['employee.department'] = filters.department;
  }
  if (filters.startDate && filters.endDate) {
    query.startDate = {
      $gte: new Date(filters.startDate),
      $lte: new Date(filters.endDate)
    };
  }

  const records = await ProbationRecord.find(query)
    .populate('employee', 'name employeeId department position')
    .populate('supervisor', 'name')
    .sort({ startDate: -1 })
    .lean();

  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'HR System';
  workbook.created = new Date();

  // Summary Statistics Sheet
  const statsSheet = workbook.addWorksheet('สถิติ');

  statsSheet.mergeCells('A1:B1');
  statsSheet.getCell('A1').value = 'สรุปสถิติการทดลองงาน';
  statsSheet.getCell('A1').font = { size: 14, bold: true };

  const stats = [
    ['จำนวนพนักงานทั้งหมด', records.length],
    ['กำลังทดลองงาน', records.filter(r => r.status === 'in_progress').length],
    ['รอการตัดสิน', records.filter(r => r.status === 'pending_decision').length],
    ['ผ่านทดลองงาน', records.filter(r => r.status === 'passed').length],
    ['ไม่ผ่านทดลองงาน', records.filter(r => r.status === 'failed').length],
    ['ขยายเวลา', records.filter(r => r.status === 'extended').length]
  ];

  stats.forEach((row, index) => {
    statsSheet.getCell(`A${index + 3}`).value = row[0];
    statsSheet.getCell(`B${index + 3}`).value = row[1];
  });

  statsSheet.getColumn('A').width = 25;
  statsSheet.getColumn('B').width = 15;

  // Pass rate calculation
  const totalCompleted = records.filter(r => ['passed', 'failed'].includes(r.status)).length;
  const passedCount = records.filter(r => r.status === 'passed').length;
  const passRate = totalCompleted > 0 ? ((passedCount / totalCompleted) * 100).toFixed(1) : 0;

  statsSheet.getCell('A10').value = 'อัตราผ่านทดลองงาน';
  statsSheet.getCell('A10').font = { bold: true };
  statsSheet.getCell('B10').value = `${passRate}%`;

  // Department breakdown
  const departments = [...new Set(records.map(r => r.employee?.department).filter(Boolean))];
  if (departments.length > 0) {
    statsSheet.getCell('A12').value = 'แยกตามแผนก';
    statsSheet.getCell('A12').font = { bold: true };

    departments.forEach((dept, index) => {
      const deptRecords = records.filter(r => r.employee?.department === dept);
      statsSheet.getCell(`A${index + 13}`).value = dept;
      statsSheet.getCell(`B${index + 13}`).value = deptRecords.length;
    });
  }

  // All Records Sheet
  const recordsSheet = workbook.addWorksheet('รายละเอียดทั้งหมด');

  recordsSheet.columns = [
    { header: 'ลำดับ', key: 'index', width: 8 },
    { header: 'ชื่อ-นามสกุล', key: 'name', width: 25 },
    { header: 'รหัสพนักงาน', key: 'employeeId', width: 15 },
    { header: 'แผนก', key: 'department', width: 20 },
    { header: 'ตำแหน่ง', key: 'position', width: 20 },
    { header: 'หัวหน้างาน', key: 'supervisor', width: 20 },
    { header: 'วันที่เริ่ม', key: 'startDate', width: 15 },
    { header: 'วันที่สิ้นสุด', key: 'endDate', width: 15 },
    { header: 'จำนวนวัน', key: 'days', width: 12 },
    { header: 'สถานะ', key: 'status', width: 18 },
    { header: 'Milestone ผ่าน', key: 'passedMilestones', width: 15 },
    { header: 'Milestone ไม่ผ่าน', key: 'failedMilestones', width: 15 },
    { header: 'คะแนนเฉลี่ย', key: 'avgScore', width: 12 }
  ];

  // Style header
  recordsSheet.getRow(1).eachCell((cell) => {
    Object.assign(cell, HEADER_STYLE);
  });
  recordsSheet.getRow(1).height = 25;

  records.forEach((record, index) => {
    const passedMilestones = record.milestones?.filter(m => m.status === 'passed').length || 0;
    const failedMilestones = record.milestones?.filter(m => m.status === 'failed').length || 0;

    const scores = record.milestones
      ?.filter(m => m.supervisorAssessment?.totalScore)
      .map(m => m.supervisorAssessment.totalScore) || [];
    const avgScore = scores.length > 0
      ? (scores.reduce((a, b) => a + b, 0) / scores.length).toFixed(2)
      : '-';

    const row = recordsSheet.addRow({
      index: index + 1,
      name: record.employee?.name || '-',
      employeeId: record.employee?.employeeId || '-',
      department: record.employee?.department || '-',
      position: record.employee?.position || '-',
      supervisor: record.supervisor?.name || '-',
      startDate: formatThaiDate(record.startDate),
      endDate: formatThaiDate(record.endDate),
      days: record.probationDays,
      status: STATUS_LABELS[record.status] || record.status,
      passedMilestones,
      failedMilestones,
      avgScore
    });

    row.eachCell((cell) => {
      Object.assign(cell, CELL_STYLE);
    });

    // Color code by status
    const statusColor = STATUS_COLORS[record.status];
    if (statusColor) {
      row.eachCell((cell) => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: statusColor } };
      });
    }
  });

  // Auto filter
  recordsSheet.autoFilter = {
    from: 'A1',
    to: `M${records.length + 1}`
  };

  // Generate buffer
  return workbook.xlsx.writeBuffer();
};

/**
 * Generate department-wise Excel report
 */
const generateDepartmentReport = async () => {
  const records = await ProbationRecord.find()
    .populate('employee', 'name employeeId department position')
    .populate('supervisor', 'name')
    .lean();

  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'HR System';
  workbook.created = new Date();

  // Group by department
  const departments = {};
  records.forEach(record => {
    const dept = record.employee?.department || 'ไม่ระบุ';
    if (!departments[dept]) {
      departments[dept] = [];
    }
    departments[dept].push(record);
  });

  // Create sheet for each department
  Object.entries(departments).forEach(([dept, deptRecords]) => {
    // Sanitize sheet name (max 31 chars, no special chars)
    const sheetName = dept.substring(0, 31).replace(/[*?:/\\[\]]/g, '-');
    const sheet = workbook.addWorksheet(sheetName);

    sheet.columns = [
      { header: 'ลำดับ', key: 'index', width: 8 },
      { header: 'ชื่อ-นามสกุล', key: 'name', width: 25 },
      { header: 'รหัสพนักงาน', key: 'employeeId', width: 15 },
      { header: 'ตำแหน่ง', key: 'position', width: 20 },
      { header: 'หัวหน้างาน', key: 'supervisor', width: 20 },
      { header: 'ระยะเวลา', key: 'period', width: 25 },
      { header: 'สถานะ', key: 'status', width: 18 },
      { header: 'คะแนน', key: 'score', width: 12 }
    ];

    // Style header
    sheet.getRow(1).eachCell((cell) => {
      Object.assign(cell, HEADER_STYLE);
    });

    deptRecords.forEach((record, index) => {
      const scores = record.milestones
        ?.filter(m => m.supervisorAssessment?.totalScore)
        .map(m => m.supervisorAssessment.totalScore) || [];
      const avgScore = scores.length > 0
        ? (scores.reduce((a, b) => a + b, 0) / scores.length).toFixed(2)
        : '-';

      const row = sheet.addRow({
        index: index + 1,
        name: record.employee?.name || '-',
        employeeId: record.employee?.employeeId || '-',
        position: record.employee?.position || '-',
        supervisor: record.supervisor?.name || '-',
        period: `${formatThaiDate(record.startDate)} - ${formatThaiDate(record.endDate)}`,
        status: STATUS_LABELS[record.status] || record.status,
        score: avgScore
      });

      row.eachCell((cell) => {
        Object.assign(cell, CELL_STYLE);
      });

      const statusColor = STATUS_COLORS[record.status];
      if (statusColor) {
        row.eachCell((cell) => {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: statusColor } };
        });
      }
    });
  });

  return workbook.xlsx.writeBuffer();
};

module.exports = {
  generateEmployeeExcel,
  generateSummaryExcel,
  generateDepartmentReport
};
