require('dotenv').config();
const mongoose = require('mongoose');
const OnboardingTemplate = require('../src/models/OnboardingTemplate');

const seedOnboarding = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    // Remove existing HAPINES template
    await OnboardingTemplate.deleteMany({ name: 'HAPINES Culture Passport' });
    console.log('Cleared existing HAPINES template');

    const template = await OnboardingTemplate.create({
      name: 'HAPINES Culture Passport',
      description: 'โปรแกรม Culture Passport สำหรับพนักงานใหม่ เรียนรู้วัฒนธรรมองค์กรผ่าน 7 ภารกิจ HAPINES',
      isActive: true,
      durationDays: 119,
      missions: [
        {
          code: 'H',
          title: 'High Energy Workstyle',
          description: 'พลังบวก - ค้นหาและเรียนรู้จากคนที่มีพลังบวกในการทำงาน',
          openOffsetDays: 0,
          closeOffsetDays: 14,
        },
        {
          code: 'A',
          title: 'Aim with Clarity',
          description: 'เป้าหมายชัด - เรียนรู้การตั้งเป้าหมายและติดตามผลอย่างชัดเจน',
          openOffsetDays: 7,
          closeOffsetDays: 21,
        },
        {
          code: 'P',
          title: 'Progress Always',
          description: 'พัฒนาตัวเอง - เรียนรู้การพัฒนาตนเองอย่างต่อเนื่อง',
          openOffsetDays: 14,
          closeOffsetDays: 28,
        },
        {
          code: 'I',
          title: 'Impact for Customers',
          description: 'สร้างคุณค่า - เรียนรู้การสร้าง Impact ให้กับลูกค้า',
          openOffsetDays: 28,
          closeOffsetDays: 28,
        },
        {
          code: 'N',
          title: 'Now, Not Never',
          description: 'ลงมือทันที - เรียนรู้การลงมือทำทันทีไม่ผัดวันประกันพรุ่ง',
          openOffsetDays: 42,
          closeOffsetDays: 28,
        },
        {
          code: 'E',
          title: 'Effective Communication',
          description: 'สื่อสารมีประสิทธิภาพ - เรียนรู้ทักษะการสื่อสารที่มีประสิทธิภาพ',
          openOffsetDays: 56,
          closeOffsetDays: 28,
        },
        {
          code: 'S',
          title: 'Strong Together',
          description: 'ช่วยเหลือทีม - เรียนรู้การทำงานเป็นทีมและช่วยเหลือกัน',
          openOffsetDays: 70,
          closeOffsetDays: 30,
        },
      ],
      questions: [
        // Mission H
        {
          text: 'ใครที่คุณพบว่ามี High Energy มากที่สุด? ทำไมคุณถึงเลือกเขา/เธอ?',
          type: 'text_long',
          required: true,
          missionCode: 'H',
          sortOrder: 1,
        },
        {
          text: 'คุณเรียนรู้อะไรจากเขา/เธอ? มีพฤติกรรมไหนที่คุณอยากนำมาปรับใช้?',
          type: 'text_long',
          required: true,
          missionCode: 'H',
          sortOrder: 2,
        },
        {
          text: 'คุณจะนำพลังบวกมาใช้ในการทำงานได้อย่างไร? ยกตัวอย่างสถานการณ์',
          type: 'text_long',
          required: true,
          missionCode: 'H',
          sortOrder: 3,
        },
        // Mission A
        {
          text: 'ใครมี Aim with Clarity มากที่สุด? เขา/เธอตั้งเป้าอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'A',
          sortOrder: 1,
        },
        {
          text: 'คุณเห็นเขา/เธอติดตามความคืบหน้าและวัดผลอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'A',
          sortOrder: 2,
        },
        {
          text: 'คุณจะนำสิ่งที่เรียนรู้ไปใช้ในการตั้งเป้าหมายของตัวเองอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'A',
          sortOrder: 3,
        },
        // Mission P
        {
          text: 'ใครมี Progress Always มากที่สุด? เขา/เธอพัฒนาตัวเองอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'P',
          sortOrder: 1,
        },
        {
          text: 'คุณเห็นเขา/เธอรับ Feedback และนำไปปรับปรุงอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'P',
          sortOrder: 2,
        },
        {
          text: 'คุณจะพัฒนาตัวเองในด้านไหนบ้างในเดือนแรก?',
          type: 'text_long',
          required: true,
          missionCode: 'P',
          sortOrder: 3,
        },
        // Mission I
        {
          text: 'ใครมี Impact for Customers มากที่สุด? เขา/เธอทำอะไร?',
          type: 'text_long',
          required: true,
          missionCode: 'I',
          sortOrder: 1,
        },
        {
          text: 'คุณเห็นเขา/เธอเข้าใจความต้องการของลูกค้าและแก้ปัญหาอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'I',
          sortOrder: 2,
        },
        {
          text: 'ในงานของคุณ คุณจะสร้าง Impact ให้กับลูกค้าได้อย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'I',
          sortOrder: 3,
        },
        // Mission N
        {
          text: 'ใครมี Now, Not Never มากที่สุด? เขา/เธอแสดงออกอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'N',
          sortOrder: 1,
        },
        {
          text: 'คุณเห็นเขา/เธอจัดการกับความผิดพลาดและเรียนรู้จากมันอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'N',
          sortOrder: 2,
        },
        {
          text: 'มีงานอะไรที่คุณกำลังผัดรอทำอยู่? คุณจะเริ่มได้อย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'N',
          sortOrder: 3,
        },
        // Mission E
        {
          text: 'ใครมี Effective Communication มากที่สุด? เขา/เธอสื่อสารอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'E',
          sortOrder: 1,
        },
        {
          text: 'คุณเห็นเขา/เธอรับมือกับความเข้าใจผิดและสร้างความชัดเจนอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'E',
          sortOrder: 2,
        },
        {
          text: 'คุณจะพัฒนาทักษะการสื่อสารของคุณอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'E',
          sortOrder: 3,
        },
        // Mission S
        {
          text: 'ใครมี Strong Together มากที่สุด? เขา/เธอช่วยเหลืออย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'S',
          sortOrder: 1,
        },
        {
          text: 'คุณเห็นเขา/เธอสร้างความร่วมมือและความไว้วางใจในทีมอย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'S',
          sortOrder: 2,
        },
        {
          text: 'คุณจะมีส่วนร่วมในการสร้างทีมที่แข็งแกร่งได้อย่างไร?',
          type: 'text_long',
          required: true,
          missionCode: 'S',
          sortOrder: 3,
        },
      ],
      events: [
        {
          code: 'HR_ORIENT',
          title: 'HR Orientation Session',
          titleTh: 'ปฐมนิเทศ HR',
          description: 'แนะนำนโยบาย สวัสดิการ และข้อมูลสำคัญของบริษัท',
          type: 'orientation',
          day: 1,
          duration: 'ครึ่งวัน',
          isLinkedToMilestone: false,
          sortOrder: 1,
        },
        {
          code: 'PASSPORT',
          title: 'Culture Passport Distribution',
          titleTh: 'แจก Culture Passport',
          description: 'รับ Culture Passport และเรียนรู้วิธีการทำภารกิจ',
          type: 'orientation',
          day: 1,
          duration: '30 นาที',
          isLinkedToMilestone: false,
          sortOrder: 2,
        },
        {
          code: 'IT_ORIENT',
          title: 'IT Orientation',
          titleTh: 'ปฐมนิเทศ IT',
          description: 'ตั้งค่าอุปกรณ์ ระบบงาน และ Account ต่างๆ',
          type: 'orientation',
          day: 1,
          duration: '1 ชั่วโมง',
          isLinkedToMilestone: false,
          sortOrder: 3,
        },
        {
          code: 'DEPT_ORIENT',
          title: 'Department Orientation',
          titleTh: 'ปฐมนิเทศแผนก',
          description: 'แนะนำทีมงาน กระบวนการทำงาน และเป้าหมายของแผนก',
          type: 'orientation',
          day: 1,
          duration: 'ครึ่งวัน',
          isLinkedToMilestone: false,
          sortOrder: 4,
        },
        {
          code: 'BRAND_WS',
          title: 'Branding Workshop',
          titleTh: 'Workshop แบรนด์',
          description: 'เรียนรู้ Brand Identity, Vision, Mission ของบริษัท',
          type: 'workshop',
          day: 10,
          duration: '2 ชั่วโมง',
          isLinkedToMilestone: false,
          sortOrder: 5,
        },
        {
          code: 'CEO_ORIENT',
          title: 'CEO Orientation & HR Feedback',
          titleTh: 'CEO Orientation',
          description: 'พบ CEO พร้อมรับ Feedback จาก HR',
          type: 'orientation',
          day: 15,
          duration: '1 ชั่วโมง',
          isLinkedToMilestone: false,
          sortOrder: 6,
        },
        {
          code: 'EVAL_30',
          title: '1-Month Performance Evaluation',
          titleTh: 'ประเมินผล 1 เดือน',
          description: 'ประเมินผลการปฏิบัติงานรอบ 1 เดือน',
          type: 'evaluation',
          day: 30,
          duration: '1 ชั่วโมง',
          isLinkedToMilestone: true,
          milestoneDay: 30,
          sortOrder: 7,
        },
        {
          code: 'TIME_MGMT',
          title: 'Time Management Training',
          titleTh: 'อบรม Time Management',
          description: 'อบรมทักษะการบริหารเวลาอย่างมีประสิทธิภาพ',
          type: 'training',
          day: 45,
          duration: '3 ชั่วโมง',
          isLinkedToMilestone: false,
          sortOrder: 8,
        },
        {
          code: 'EVAL_60',
          title: '2-Month Performance Evaluation',
          titleTh: 'ประเมินผล 2 เดือน',
          description: 'ประเมินผลการปฏิบัติงานรอบ 2 เดือน',
          type: 'evaluation',
          day: 60,
          duration: '1 ชั่วโมง',
          isLinkedToMilestone: true,
          milestoneDay: 60,
          sortOrder: 9,
        },
        {
          code: 'EVAL_75',
          title: '4-Month Performance Evaluation',
          titleTh: 'ประเมินผล 4 เดือน',
          description: 'ประเมินผลการปฏิบัติงานรอบ 4 เดือน',
          type: 'evaluation',
          day: 75,
          duration: '1 ชั่วโมง',
          isLinkedToMilestone: false,
          sortOrder: 10,
        },
        {
          code: 'EVAL_90',
          title: '3-Month Performance Evaluation',
          titleTh: 'ประเมินผล 3 เดือน',
          description: 'ประเมินผลการปฏิบัติงานรอบ 3 เดือน',
          type: 'evaluation',
          day: 90,
          duration: '1 ชั่วโมง',
          isLinkedToMilestone: true,
          milestoneDay: 90,
          sortOrder: 11,
        },
        {
          code: 'CONGRATS',
          title: 'Congratulations Event',
          titleTh: 'งานแสดงความยินดี',
          description: 'แสดงความยินดีกับการผ่านทดลองงานสำเร็จ',
          type: 'celebration',
          day: 119,
          duration: '1 ชั่วโมง',
          isLinkedToMilestone: false,
          sortOrder: 12,
        },
      ],
    });

    console.log(`Created HAPINES Culture Passport template: ${template._id}`);
    console.log(`  - ${template.missions.length} missions`);
    console.log(`  - ${template.questions.length} questions`);
    console.log(`  - ${template.events.length} events`);

    await mongoose.disconnect();
    console.log('\nSeed completed!');
    process.exit(0);
  } catch (error) {
    console.error('Seed failed:', error);
    process.exit(1);
  }
};

seedOnboarding();
