const nodemailer = require('nodemailer');
const logger = require('../utils/logger');

/**
 * Email Service
 * Uses SendGrid or SMTP for sending emails
 */

// Create transporter based on environment
const createTransporter = () => {
  if (process.env.SENDGRID_API_KEY) {
    // Use SendGrid
    return nodemailer.createTransport({
      host: 'smtp.sendgrid.net',
      port: 587,
      secure: false,
      auth: {
        user: 'apikey',
        pass: process.env.SENDGRID_API_KEY,
      },
    });
  }

  // Use SMTP (for development or alternative providers)
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'smtp.mailtrap.io',
    port: parseInt(process.env.SMTP_PORT || '587', 10),
    secure: process.env.SMTP_SECURE === 'true',
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS,
    },
  });
};

let transporter = null;

const getTransporter = () => {
  if (!transporter) {
    transporter = createTransporter();
  }
  return transporter;
};

/**
 * Email templates
 */
const templates = {
  milestoneReminder: (data) => ({
    subject: `[KPI Probation] Milestone Day ${data.day} กำลังจะถึงกำหนด`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <div style="background-color: #C8102E; padding: 20px; text-align: center;">
          <h1 style="color: white; margin: 0;">KPI Probation Tracking</h1>
        </div>
        <div style="padding: 20px; background-color: #f9f9f9;">
          <h2>สวัสดีคุณ ${data.employeeName},</h2>
          <p>Milestone วันที่ <strong>${data.day}</strong> ของคุณกำลังจะถึงกำหนด</p>
          <div style="background-color: white; padding: 15px; border-radius: 8px; margin: 15px 0;">
            <p><strong>กำหนดส่ง:</strong> ${data.dueDate}</p>
            <p><strong>เหลือเวลา:</strong> ${data.daysRemaining} วัน</p>
          </div>
          <p>กรุณาเข้าสู่ระบบเพื่อกรอกแบบประเมินตนเอง</p>
          <a href="${process.env.APP_URL || 'http://localhost:3000'}"
             style="display: inline-block; background-color: #C8102E; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; margin-top: 10px;">
            เข้าสู่ระบบ
          </a>
        </div>
        <div style="padding: 15px; text-align: center; color: #666; font-size: 12px;">
          <p>อีเมลนี้ส่งโดยอัตโนมัติจากระบบ KPI Probation Tracking</p>
        </div>
      </div>
    `,
    text: `สวัสดีคุณ ${data.employeeName},\n\nMilestone วันที่ ${data.day} ของคุณกำลังจะถึงกำหนด\nกำหนดส่ง: ${data.dueDate}\nเหลือเวลา: ${data.daysRemaining} วัน\n\nกรุณาเข้าสู่ระบบเพื่อกรอกแบบประเมินตนเอง`,
  }),

  milestoneOverdue: (data) => ({
    subject: `[KPI Probation] Milestone Day ${data.day} เกินกำหนด`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <div style="background-color: #C8102E; padding: 20px; text-align: center;">
          <h1 style="color: white; margin: 0;">KPI Probation Tracking</h1>
        </div>
        <div style="padding: 20px; background-color: #fff3f3;">
          <h2 style="color: #C8102E;">⚠️ Milestone เกินกำหนด</h2>
          <p>สวัสดีคุณ ${data.employeeName},</p>
          <p>Milestone วันที่ <strong>${data.day}</strong> ของคุณเกินกำหนดแล้ว</p>
          <div style="background-color: white; padding: 15px; border-radius: 8px; margin: 15px 0; border-left: 4px solid #C8102E;">
            <p><strong>กำหนดส่ง:</strong> ${data.dueDate}</p>
            <p><strong>เกินมา:</strong> ${data.daysOverdue} วัน</p>
          </div>
          <p>กรุณาเข้าสู่ระบบเพื่อดำเนินการโดยเร็ว</p>
          <a href="${process.env.APP_URL || 'http://localhost:3000'}"
             style="display: inline-block; background-color: #C8102E; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; margin-top: 10px;">
            เข้าสู่ระบบทันที
          </a>
        </div>
        <div style="padding: 15px; text-align: center; color: #666; font-size: 12px;">
          <p>อีเมลนี้ส่งโดยอัตโนมัติจากระบบ KPI Probation Tracking</p>
        </div>
      </div>
    `,
    text: `⚠️ Milestone เกินกำหนด\n\nสวัสดีคุณ ${data.employeeName},\n\nMilestone วันที่ ${data.day} ของคุณเกินกำหนดแล้ว\nกำหนดส่ง: ${data.dueDate}\nเกินมา: ${data.daysOverdue} วัน\n\nกรุณาเข้าสู่ระบบเพื่อดำเนินการโดยเร็ว`,
  }),

  supervisorApprovalNeeded: (data) => ({
    subject: `[KPI Probation] มี Milestone รออนุมัติ - ${data.employeeName}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <div style="background-color: #C8102E; padding: 20px; text-align: center;">
          <h1 style="color: white; margin: 0;">KPI Probation Tracking</h1>
        </div>
        <div style="padding: 20px; background-color: #f9f9f9;">
          <h2>สวัสดีคุณ ${data.supervisorName},</h2>
          <p>มี Milestone รอการพิจารณาอนุมัติจากคุณ</p>
          <div style="background-color: white; padding: 15px; border-radius: 8px; margin: 15px 0;">
            <p><strong>พนักงาน:</strong> ${data.employeeName}</p>
            <p><strong>Milestone:</strong> Day ${data.day}</p>
            <p><strong>สถานะ:</strong> รออนุมัติ</p>
          </div>
          <p>กรุณาเข้าสู่ระบบเพื่อพิจารณา</p>
          <a href="${process.env.APP_URL || 'http://localhost:3000'}"
             style="display: inline-block; background-color: #C8102E; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; margin-top: 10px;">
            พิจารณาอนุมัติ
          </a>
        </div>
        <div style="padding: 15px; text-align: center; color: #666; font-size: 12px;">
          <p>อีเมลนี้ส่งโดยอัตโนมัติจากระบบ KPI Probation Tracking</p>
        </div>
      </div>
    `,
    text: `สวัสดีคุณ ${data.supervisorName},\n\nมี Milestone รอการพิจารณาอนุมัติจากคุณ\nพนักงาน: ${data.employeeName}\nMilestone: Day ${data.day}\n\nกรุณาเข้าสู่ระบบเพื่อพิจารณา`,
  }),

  probationResult: (data) => ({
    subject: `[KPI Probation] ผลการทดลองงาน - ${data.result === 'passed' ? 'ผ่าน' : 'ไม่ผ่าน'}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <div style="background-color: #C8102E; padding: 20px; text-align: center;">
          <h1 style="color: white; margin: 0;">KPI Probation Tracking</h1>
        </div>
        <div style="padding: 20px; background-color: ${data.result === 'passed' ? '#f0fff4' : '#fff3f3'};">
          <h2 style="color: ${data.result === 'passed' ? '#22c55e' : '#C8102E'};">
            ${data.result === 'passed' ? '🎉 ยินดีด้วย!' : 'ผลการทดลองงาน'}
          </h2>
          <p>สวัสดีคุณ ${data.employeeName},</p>
          <p>ผลการทดลองงานของคุณ: <strong>${data.result === 'passed' ? 'ผ่าน' : 'ไม่ผ่าน'}</strong></p>
          ${data.reason ? `<p>หมายเหตุ: ${data.reason}</p>` : ''}
          <a href="${process.env.APP_URL || 'http://localhost:3000'}"
             style="display: inline-block; background-color: #C8102E; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; margin-top: 10px;">
            ดูรายละเอียด
          </a>
        </div>
        <div style="padding: 15px; text-align: center; color: #666; font-size: 12px;">
          <p>อีเมลนี้ส่งโดยอัตโนมัติจากระบบ KPI Probation Tracking</p>
        </div>
      </div>
    `,
    text: `สวัสดีคุณ ${data.employeeName},\n\nผลการทดลองงานของคุณ: ${data.result === 'passed' ? 'ผ่าน' : 'ไม่ผ่าน'}\n${data.reason ? `หมายเหตุ: ${data.reason}` : ''}`,
  }),
};

/**
 * Send email
 * @param {Object} options - Email options
 * @param {string} options.to - Recipient email
 * @param {string} options.template - Template name
 * @param {Object} options.data - Template data
 * @returns {Promise<Object>} Send result
 */
const sendEmail = async ({ to, template, data }) => {
  try {
    const templateFn = templates[template];
    if (!templateFn) {
      throw new Error(`Email template '${template}' not found`);
    }

    const { subject, html, text } = templateFn(data);

    const mailOptions = {
      from: process.env.EMAIL_FROM || 'KPI Probation <noreply@kpi-probation.com>',
      to,
      subject,
      html,
      text,
    };

    // Skip sending in test environment
    if (process.env.NODE_ENV === 'test') {
      logger.info('Email skipped in test environment', { to, subject });
      return { success: true, skipped: true };
    }

    // Skip if no email configuration
    if (!process.env.SENDGRID_API_KEY && !process.env.SMTP_HOST) {
      logger.warn('Email not configured, skipping', { to, subject });
      return { success: true, skipped: true };
    }

    const result = await getTransporter().sendMail(mailOptions);

    logger.info('Email sent successfully', {
      to,
      subject,
      messageId: result.messageId,
    });

    return { success: true, messageId: result.messageId };
  } catch (error) {
    logger.error('Failed to send email', {
      to,
      template,
      error: error.message,
    });

    // Don't throw - email failures shouldn't break the main flow
    return { success: false, error: error.message };
  }
};

/**
 * Send milestone reminder email
 */
const sendMilestoneReminder = async (employee, milestone, daysRemaining) => {
  return sendEmail({
    to: employee.email,
    template: 'milestoneReminder',
    data: {
      employeeName: employee.name || employee.email,
      day: milestone.day,
      dueDate: new Date(milestone.dueDate).toLocaleDateString('th-TH'),
      daysRemaining,
    },
  });
};

/**
 * Send milestone overdue email
 */
const sendMilestoneOverdue = async (employee, milestone, daysOverdue) => {
  return sendEmail({
    to: employee.email,
    template: 'milestoneOverdue',
    data: {
      employeeName: employee.name || employee.email,
      day: milestone.day,
      dueDate: new Date(milestone.dueDate).toLocaleDateString('th-TH'),
      daysOverdue,
    },
  });
};

/**
 * Send approval needed email to supervisor
 */
const sendApprovalNeeded = async (supervisor, employee, milestone) => {
  return sendEmail({
    to: supervisor.email,
    template: 'supervisorApprovalNeeded',
    data: {
      supervisorName: supervisor.name || supervisor.email,
      employeeName: employee.name || employee.email,
      day: milestone.day,
    },
  });
};

/**
 * Send probation result email
 */
const sendProbationResult = async (employee, result, reason) => {
  return sendEmail({
    to: employee.email,
    template: 'probationResult',
    data: {
      employeeName: employee.name || employee.email,
      result,
      reason,
    },
  });
};

module.exports = {
  sendEmail,
  sendMilestoneReminder,
  sendMilestoneOverdue,
  sendApprovalNeeded,
  sendProbationResult,
};
