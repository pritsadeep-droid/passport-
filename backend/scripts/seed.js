require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../src/models/User');
const ProbationRecord = require('../src/models/ProbationRecord');
const OnboardingTemplate = require('../src/models/OnboardingTemplate');
const OnboardingInstance = require('../src/models/OnboardingInstance');

const seedData = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    // Clear existing data
    await User.deleteMany({});
    await ProbationRecord.deleteMany({});
    await OnboardingInstance.deleteMany({});
    console.log('Cleared existing data');

    // Create HR Admin
    const hrAdmin = await User.create({
      email: 'hr@company.com',
      password: 'password123',
      name: 'สมศรี ฝ่ายบุคคล',
      employeeId: 'HR001',
      role: 'hr_admin',
      department: 'Human Resources',
      position: 'HR Manager',
      isActive: true
    });
    console.log('Created HR Admin:', hrAdmin.email);

    // Create Supervisors
    const supervisor1 = await User.create({
      email: 'supervisor@company.com',
      password: 'password123',
      name: 'สมชาย หัวหน้างาน',
      employeeId: 'SUP001',
      role: 'supervisor',
      department: 'Engineering',
      position: 'Engineering Manager',
      isActive: true
    });

    const supervisor2 = await User.create({
      email: 'supervisor2@company.com',
      password: 'password123',
      name: 'วิภา ผู้จัดการ',
      employeeId: 'SUP002',
      role: 'supervisor',
      department: 'Marketing',
      position: 'Marketing Manager',
      isActive: true
    });

    const supervisor3 = await User.create({
      email: 'supervisor3@company.com',
      password: 'password123',
      name: 'ประสิทธิ์ หัวหน้าทีม',
      employeeId: 'SUP003',
      role: 'supervisor',
      department: 'Sales',
      position: 'Sales Manager',
      isActive: true
    });
    console.log('Created 3 Supervisors');

    // Create Employees with different statuses
    const employees = [];
    const departments = ['Engineering', 'Marketing', 'Sales', 'Finance', 'Operations'];
    const positions = ['Developer', 'Designer', 'Analyst', 'Coordinator', 'Specialist'];
    const supervisors = [supervisor1, supervisor2, supervisor3];

    const employeeData = [
      { name: 'สมหญิง พนักงานใหม่', dept: 'Engineering', sup: supervisor1, status: 'in_progress', daysAgo: 15 },
      { name: 'วิชัย ทดลองงาน', dept: 'Engineering', sup: supervisor1, status: 'in_progress', daysAgo: 45 },
      { name: 'นภา มาใหม่', dept: 'Marketing', sup: supervisor2, status: 'in_progress', daysAgo: 20 },
      { name: 'ธนา รอประเมิน', dept: 'Marketing', sup: supervisor2, status: 'pending_decision', daysAgo: 85 },
      { name: 'กานดา ผ่านแล้ว', dept: 'Sales', sup: supervisor3, status: 'passed', daysAgo: 100 },
      { name: 'สุชาติ ไม่ผ่าน', dept: 'Sales', sup: supervisor3, status: 'failed', daysAgo: 95 },
      { name: 'มานี รอ KPI', dept: 'Finance', sup: supervisor1, status: 'pending_kpi', daysAgo: 5 },
      { name: 'ปิยะ เริ่มงาน', dept: 'Operations', sup: supervisor2, status: 'in_progress', daysAgo: 30 },
    ];

    for (let i = 0; i < employeeData.length; i++) {
      const empData = employeeData[i];
      const employee = await User.create({
        email: `employee${i + 1}@company.com`,
        password: 'password123',
        name: empData.name,
        employeeId: `EMP00${i + 1}`,
        role: 'employee',
        department: empData.dept,
        position: positions[i % positions.length],
        supervisorId: empData.sup._id,
        isActive: true
      });
      employees.push({ user: employee, ...empData });
    }
    console.log(`Created ${employees.length} Employees`);

    // Create Probation Records
    for (const emp of employees) {
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - emp.daysAgo);

      const milestoneStatuses = getMilestoneStatuses(emp.daysAgo, emp.status);

      await ProbationRecord.create({
        employeeId: emp.user._id,
        supervisorId: emp.sup._id,
        startDate: startDate,
        endDate: new Date(startDate.getTime() + 90 * 24 * 60 * 60 * 1000),
        probationDays: 90,
        status: emp.status,
        kpis: [
          { title: 'เรียนรู้กระบวนการทำงาน', description: 'ทำความเข้าใจและปฏิบัติตามขั้นตอนของบริษัท', criteria: 'ผ่านการทดสอบ onboarding', weight: 30, status: 'active' },
          { title: 'ผ่านการอบรม', description: 'เสร็จสิ้นการอบรมทั้งหมดที่กำหนด', criteria: 'ผ่านการทดสอบหลังอบรม', weight: 25, status: 'active' },
          { title: 'ส่งมอบโปรเจกต์แรก', description: 'ทำโปรเจกต์แรกที่ได้รับมอบหมายให้เสร็จ', criteria: 'หัวหน้าอนุมัติผลงาน', weight: 45, status: 'active' }
        ],
        milestones: [
          { day: 30, dueDate: new Date(startDate.getTime() + 30 * 24 * 60 * 60 * 1000), status: milestoneStatuses[0] },
          { day: 60, dueDate: new Date(startDate.getTime() + 60 * 24 * 60 * 60 * 1000), status: milestoneStatuses[1] },
          { day: 90, dueDate: new Date(startDate.getTime() + 90 * 24 * 60 * 60 * 1000), status: milestoneStatuses[2] }
        ]
      });
    }
    console.log('Created Probation Records');

    // Create onboarding instances for employees (if HAPINES template exists)
    const hapinesTemplate = await OnboardingTemplate.findOne({ isActive: true });
    if (hapinesTemplate) {
      for (const emp of employees) {
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - emp.daysAgo);

        await OnboardingInstance.create({
          employeeId: emp.user._id,
          templateId: hapinesTemplate._id,
          startDate: startDate,
          status: emp.status === 'passed' || emp.status === 'failed' ? 'completed' : 'in_progress',
        });
      }
      console.log('Created Onboarding Instances for all employees');
    } else {
      console.log('No active onboarding template found - run seedOnboarding.js first');
    }

    console.log('\n========================================');
    console.log('          TEST ACCOUNTS');
    console.log('========================================');
    console.log('');
    console.log('HR Admin:');
    console.log('  Email:    hr@company.com');
    console.log('  Password: password123');
    console.log('');
    console.log('Supervisors:');
    console.log('  Email:    supervisor@company.com');
    console.log('  Email:    supervisor2@company.com');
    console.log('  Email:    supervisor3@company.com');
    console.log('  Password: password123 (all)');
    console.log('');
    console.log('Employees:');
    for (let i = 0; i < employeeData.length; i++) {
      console.log(`  employee${i + 1}@company.com - ${employeeData[i].name} (${employeeData[i].status})`);
    }
    console.log('  Password: password123 (all)');
    console.log('');
    console.log('========================================\n');

    await mongoose.disconnect();
    console.log('Seed completed!');
    process.exit(0);
  } catch (error) {
    console.error('Seed failed:', error);
    process.exit(1);
  }
};

function getMilestoneStatuses(daysAgo, probationStatus) {
  if (probationStatus === 'pending_kpi') {
    return ['upcoming', 'upcoming', 'upcoming'];
  }
  if (probationStatus === 'passed' || probationStatus === 'failed') {
    return ['passed', 'passed', 'passed'];
  }
  if (daysAgo < 30) {
    return ['upcoming', 'upcoming', 'upcoming'];
  }
  if (daysAgo < 60) {
    return ['passed', 'upcoming', 'upcoming'];
  }
  if (daysAgo < 90) {
    return ['passed', 'passed', 'upcoming'];
  }
  return ['passed', 'passed', 'pending_assessment'];
}

seedData();
