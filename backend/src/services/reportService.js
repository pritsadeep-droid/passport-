/**
 * Report Generation Service
 * Generates PDF reports for probation records
 */

const PDFDocument = require('pdfkit');
const ProbationRecord = require('../models/ProbationRecord');

/**
 * Thai month names
 */
const THAI_MONTHS = [
  '', 'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
];

/**
 * Format date to Thai format
 */
const formatThaiDate = (date) => {
  if (!date) {return '-';}
  const d = new Date(date);
  const day = d.getDate();
  const month = THAI_MONTHS[d.getMonth() + 1];
  const year = d.getFullYear() + 543; // Buddhist Era
  return `${day} ${month} ${year}`;
};

/**
 * Status translations
 */
const STATUS_LABELS = {
  in_progress: 'กำลังทดลองงาน',
  pending_decision: 'รอการตัดสิน',
  passed: 'ผ่านทดลองงาน',
  failed: 'ไม่ผ่านทดลองงาน',
  extended: 'ขยายเวลาทดลองงาน',
  terminated: 'ยุติทดลองงาน'
};

const MILESTONE_STATUS_LABELS = {
  upcoming: 'รอดำเนินการ',
  pending_self: 'รอประเมินตนเอง',
  pending_supervisor: 'รอหัวหน้าประเมิน',
  pending_approval: 'รอการอนุมัติ',
  passed: 'ผ่าน',
  failed: 'ไม่ผ่าน'
};

/**
 * Generate PDF report for a single employee's probation
 */
const generateEmployeeReport = async (employeeId) => {
  // Find the probation record
  const record = await ProbationRecord.findOne({ employee: employeeId })
    .populate('employee', 'name email employeeId department position')
    .populate('supervisor', 'name email employeeId')
    .lean();

  if (!record) {
    throw new Error('Probation record not found');
  }

  // Create PDF document
  const doc = new PDFDocument({
    size: 'A4',
    margins: { top: 50, bottom: 50, left: 50, right: 50 },
    info: {
      Title: `รายงานทดลองงาน - ${record.employee.name}`,
      Author: 'HR System',
      Subject: 'Probation Report'
    }
  });

  const buffers = [];
  doc.on('data', buffers.push.bind(buffers));

  // Register Thai font (using built-in Helvetica for now, would need Thai font in production)
  // doc.registerFont('Thai', 'path/to/thai-font.ttf');

  // Title
  doc.fontSize(20)
    .text('รายงานผลการทดลองงาน', { align: 'center' })
    .moveDown();

  doc.fontSize(14)
    .text('Employee Probation Report', { align: 'center' })
    .moveDown(2);

  // Employee Information Section
  doc.fontSize(14)
    .text('ข้อมูลพนักงาน', { underline: true })
    .moveDown(0.5);

  doc.fontSize(11);
  const employeeInfo = [
    ['ชื่อ-นามสกุล:', record.employee.name],
    ['รหัสพนักงาน:', record.employee.employeeId],
    ['ตำแหน่ง:', record.employee.position || '-'],
    ['แผนก:', record.employee.department || '-'],
    ['อีเมล:', record.employee.email],
    ['หัวหน้างาน:', record.supervisor?.name || '-']
  ];

  employeeInfo.forEach(([label, value]) => {
    doc.text(`${label} ${value}`);
  });
  doc.moveDown();

  // Probation Period Section
  doc.fontSize(14)
    .text('ระยะเวลาทดลองงาน', { underline: true })
    .moveDown(0.5);

  doc.fontSize(11);
  const probationInfo = [
    ['วันที่เริ่มทดลองงาน:', formatThaiDate(record.startDate)],
    ['วันที่สิ้นสุด:', formatThaiDate(record.endDate)],
    ['จำนวนวัน:', `${record.probationDays} วัน`],
    ['สถานะ:', STATUS_LABELS[record.status] || record.status]
  ];

  probationInfo.forEach(([label, value]) => {
    doc.text(`${label} ${value}`);
  });
  doc.moveDown();

  // KPIs Section
  if (record.kpis && record.kpis.length > 0) {
    doc.fontSize(14)
      .text('KPI ที่กำหนด', { underline: true })
      .moveDown(0.5);

    doc.fontSize(11);
    record.kpis.forEach((kpi, index) => {
      doc.text(`${index + 1}. ${kpi.title}`, { continued: false });
      if (kpi.description) {
        doc.text(`   ${kpi.description}`, { indent: 20 });
      }
    });
    doc.moveDown();
  }

  // Milestones Section
  if (record.milestones && record.milestones.length > 0) {
    doc.fontSize(14)
      .text('Milestones', { underline: true })
      .moveDown(0.5);

    doc.fontSize(11);

    // Table header
    const tableTop = doc.y;
    const col1 = 50;
    const col2 = 120;
    const col3 = 200;
    const col4 = 350;
    const col5 = 450;

    doc.text('วัน', col1, tableTop);
    doc.text('สถานะ', col2, tableTop);
    doc.text('วันที่ครบกำหนด', col3, tableTop);
    doc.text('คะแนนรวม', col4, tableTop);
    doc.text('ผลลัพธ์', col5, tableTop);

    doc.moveTo(col1, doc.y + 5).lineTo(530, doc.y + 5).stroke();
    doc.moveDown(0.5);

    record.milestones.forEach((milestone) => {
      const y = doc.y;
      doc.text(`Day ${milestone.day}`, col1, y);
      doc.text(MILESTONE_STATUS_LABELS[milestone.status] || milestone.status, col2, y);
      doc.text(formatThaiDate(milestone.dueDate), col3, y);

      if (milestone.supervisorAssessment?.totalScore !== undefined) {
        doc.text(milestone.supervisorAssessment.totalScore.toFixed(2), col4, y);
      } else {
        doc.text('-', col4, y);
      }

      const result = milestone.status === 'passed' ? 'ผ่าน' :
                     milestone.status === 'failed' ? 'ไม่ผ่าน' : '-';
      doc.text(result, col5, y);
      doc.moveDown();
    });
    doc.moveDown();
  }

  // Final Decision Section
  if (record.status !== 'in_progress') {
    doc.fontSize(14)
      .text('ผลการตัดสิน', { underline: true })
      .moveDown(0.5);

    doc.fontSize(11);
    doc.text(`ผลการทดลองงาน: ${STATUS_LABELS[record.status] || record.status}`);

    if (record.finalDecision) {
      doc.text(`ตัดสินใจโดย: ${record.finalDecision.decidedBy || '-'}`);
      doc.text(`วันที่ตัดสิน: ${formatThaiDate(record.finalDecision.decidedAt)}`);
      if (record.finalDecision.reason) {
        doc.text(`หมายเหตุ: ${record.finalDecision.reason}`);
      }
    }
    doc.moveDown();
  }

  // Footer
  doc.fontSize(9)
    .text(
      `สร้างเมื่อ: ${formatThaiDate(new Date())}`,
      50,
      doc.page.height - 50,
      { align: 'center' }
    );

  // Finalize document
  doc.end();

  return new Promise((resolve, reject) => {
    doc.on('end', () => {
      resolve(Buffer.concat(buffers));
    });
    doc.on('error', reject);
  });
};

/**
 * Generate summary PDF report for all probation records
 */
const generateSummaryReport = async (filters = {}) => {
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

  // Create PDF document
  const doc = new PDFDocument({
    size: 'A4',
    layout: 'landscape',
    margins: { top: 40, bottom: 40, left: 40, right: 40 },
    info: {
      Title: 'รายงานสรุปการทดลองงาน',
      Author: 'HR System',
      Subject: 'Probation Summary Report'
    }
  });

  const buffers = [];
  doc.on('data', buffers.push.bind(buffers));

  // Title
  doc.fontSize(18)
    .text('รายงานสรุปการทดลองงาน', { align: 'center' })
    .moveDown();

  doc.fontSize(12)
    .text(`Probation Summary Report`, { align: 'center' })
    .moveDown(0.5);

  doc.fontSize(10)
    .text(`วันที่ออกรายงาน: ${formatThaiDate(new Date())}`, { align: 'center' })
    .moveDown();

  // Statistics summary
  const stats = {
    total: records.length,
    inProgress: records.filter(r => r.status === 'in_progress').length,
    passed: records.filter(r => r.status === 'passed').length,
    failed: records.filter(r => r.status === 'failed').length,
    pendingDecision: records.filter(r => r.status === 'pending_decision').length
  };

  doc.fontSize(11)
    .text(`จำนวนทั้งหมด: ${stats.total} คน | กำลังทดลองงาน: ${stats.inProgress} | ผ่าน: ${stats.passed} | ไม่ผ่าน: ${stats.failed} | รอตัดสิน: ${stats.pendingDecision}`)
    .moveDown();

  // Table
  if (records.length > 0) {
    const tableTop = doc.y;
    const colWidths = [30, 120, 80, 80, 80, 80, 100, 80, 70];
    let xPos = 40;
    const headers = ['#', 'ชื่อ-นามสกุล', 'รหัสพนักงาน', 'แผนก', 'ตำแหน่ง', 'หัวหน้างาน', 'ระยะเวลา', 'สถานะ', 'คะแนน'];

    // Header row
    doc.fontSize(9);
    headers.forEach((header, i) => {
      doc.text(header, xPos, tableTop, { width: colWidths[i], align: 'left' });
      xPos += colWidths[i];
    });

    doc.moveTo(40, doc.y + 3).lineTo(760, doc.y + 3).stroke();
    doc.moveDown(0.5);

    // Data rows
    records.forEach((record, index) => {
      if (doc.y > doc.page.height - 60) {
        doc.addPage();
      }

      xPos = 40;
      const y = doc.y;
      const rowData = [
        `${index + 1}`,
        record.employee?.name || '-',
        record.employee?.employeeId || '-',
        record.employee?.department || '-',
        record.employee?.position || '-',
        record.supervisor?.name || '-',
        `${formatThaiDate(record.startDate).substring(0, 10)} - ${formatThaiDate(record.endDate).substring(0, 10)}`,
        STATUS_LABELS[record.status] || record.status,
        record.milestones?.length > 0
          ? (record.milestones.reduce((sum, m) => sum + (m.supervisorAssessment?.totalScore || 0), 0) / record.milestones.filter(m => m.supervisorAssessment?.totalScore).length || 0).toFixed(1)
          : '-'
      ];

      rowData.forEach((data, i) => {
        doc.text(data, xPos, y, { width: colWidths[i], align: 'left' });
        xPos += colWidths[i];
      });
      doc.moveDown();
    });
  } else {
    doc.text('ไม่พบข้อมูล', { align: 'center' });
  }

  // Footer
  doc.fontSize(8)
    .text(
      'Generated by HR System',
      40,
      doc.page.height - 30,
      { align: 'center', width: 720 }
    );

  doc.end();

  return new Promise((resolve, reject) => {
    doc.on('end', () => {
      resolve(Buffer.concat(buffers));
    });
    doc.on('error', reject);
  });
};

module.exports = {
  generateEmployeeReport,
  generateSummaryReport,
  formatThaiDate,
  STATUS_LABELS,
  MILESTONE_STATUS_LABELS
};
