# Data Model: Employee KPI Probation Tracking System

**Branch**: `001-employee-kpi-probation` | **Date**: 2026-02-03

## Entity Relationship Diagram

```text
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│      User       │       │  ProbationRecord│       │   Notification  │
├─────────────────┤       ├─────────────────┤       ├─────────────────┤
│ _id             │──┐    │ _id             │       │ _id             │
│ employeeId      │  │    │ employeeId      │◄──────│ userId          │
│ email           │  │    │ supervisorId    │       │ type            │
│ name            │  └───►│ startDate       │       │ title           │
│ role            │       │ probationDays   │       │ message         │
│ department      │       │ status          │       │ read            │
│ supervisorId    │       │ kpis[]          │       │ createdAt       │
└─────────────────┘       │ milestones[]    │       └─────────────────┘
                          │ createdAt       │
                          │ updatedAt       │
                          └─────────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    ▼                           ▼
            ┌───────────────┐           ┌───────────────┐
            │      KPI      │           │   Milestone   │
            │  (embedded)   │           │  (embedded)   │
            ├───────────────┤           ├───────────────┤
            │ title         │           │ day           │
            │ description   │           │ dueDate       │
            │ criteria      │           │ status        │
            │ status        │           │ selfAssessment│
            └───────────────┘           │ supervisorAsmt│
                                        │ approvedAt    │
                                        │ approvedBy    │
                                        └───────────────┘
```

## Collections

### 1. Users

```typescript
interface User {
  _id: ObjectId;
  employeeId: string;           // รหัสพนักงาน (unique)
  email: string;                // อีเมล (unique)
  name: string;                 // ชื่อ-นามสกุล
  role: 'employee' | 'supervisor' | 'hr_admin';
  department: string;           // แผนก
  supervisorId?: ObjectId;      // หัวหน้างาน (ref: Users)
  isActive: boolean;
  fcmTokens: string[];          // Firebase Cloud Messaging tokens
  createdAt: Date;
  updatedAt: Date;
}

// Indexes
{ employeeId: 1 }              // unique
{ email: 1 }                   // unique
{ supervisorId: 1 }            // for listing team members
{ role: 1, isActive: 1 }       // for role-based queries
```

### 2. ProbationRecords

```typescript
interface ProbationRecord {
  _id: ObjectId;
  employeeId: ObjectId;         // ref: Users
  supervisorId: ObjectId;       // ref: Users (can change)
  startDate: Date;              // วันเริ่มงาน
  probationDays: 90 | 119;      // ระยะทดลองงาน
  endDate: Date;                // computed: startDate + probationDays
  status: ProbationStatus;
  kpis: KPI[];                  // embedded (3-5 items)
  milestones: Milestone[];      // embedded (3-4 items)
  finalDecision?: {
    decision: 'passed' | 'failed';
    decidedBy: ObjectId;        // ref: Users (HR)
    decidedAt: Date;
    reason?: string;
  };
  createdAt: Date;
  updatedAt: Date;
}

type ProbationStatus =
  | 'pending_kpi'       // รอหัวหน้ากำหนด KPI
  | 'in_progress'       // อยู่ระหว่างทดลองงาน
  | 'pending_decision'  // รอ HR ตัดสินใจ
  | 'passed'            // ผ่านทดลองงาน
  | 'failed'            // ไม่ผ่านทดลองงาน
  | 'resigned'          // ลาออก
  | 'terminated';       // ถูกยกเลิก

// Indexes
{ employeeId: 1 }                          // unique per employee
{ supervisorId: 1, status: 1 }             // supervisor dashboard
{ status: 1, 'milestones.dueDate': 1 }     // notification jobs
{ endDate: 1, status: 1 }                  // HR dashboard
```

### 3. KPI (Embedded in ProbationRecord)

```typescript
interface KPI {
  id: string;                   // UUID
  title: string;                // ชื่อเป้าหมาย
  description: string;          // รายละเอียด
  criteria: string;             // เกณฑ์วัดผล
  status: 'active' | 'completed' | 'cancelled';
  createdAt: Date;
  updatedAt: Date;
}

// Validation Rules
// - Minimum 3, Maximum 5 KPIs per record
// - title: required, max 200 chars
// - description: required, max 1000 chars
// - criteria: required, max 500 chars
```

### 4. Milestone (Embedded in ProbationRecord)

```typescript
interface Milestone {
  day: number;                  // 30, 60, 90, or 119
  dueDate: Date;                // computed: startDate + day
  status: MilestoneStatus;
  selfAssessment?: SelfAssessment;
  supervisorAssessment?: SupervisorAssessment;
  approvedAt?: Date;
  approvedBy?: ObjectId;        // ref: Users
  rejectionReason?: string;
}

type MilestoneStatus =
  | 'upcoming'          // ยังไม่ถึงกำหนด
  | 'pending_self'      // รอพนักงานประเมินตนเอง
  | 'pending_supervisor'// รอหัวหน้าประเมิน
  | 'pending_approval'  // รอหัวหน้ายอมรับ
  | 'passed'            // ผ่าน
  | 'failed'            // ไม่ผ่าน
  | 'overdue';          // เกินกำหนด
```

### 5. SelfAssessment (Embedded in Milestone)

```typescript
interface SelfAssessment {
  coreValue: AssessmentScore;
  jobPerformance: AssessmentScore;
  attendance: AssessmentScore;
  cultureFit: AssessmentScore;
  averageScore: number;         // computed average
  comments?: string;
  submittedAt: Date;
  isDraft: boolean;             // for auto-save
  lastSavedAt?: Date;
}

interface AssessmentScore {
  score: 1 | 2 | 3 | 4 | 5;     // 5-Point Scale
  comment?: string;             // optional comment per category
}

// Validation Rules
// - All 4 categories required
// - score: 1-5 integer
// - averageScore computed on save
// - Passing threshold: averageScore >= 3.0
```

### 6. SupervisorAssessment (Embedded in Milestone)

```typescript
interface SupervisorAssessment {
  coreValue: AssessmentScore;
  jobPerformance: AssessmentScore;
  attendance: AssessmentScore;
  cultureFit: AssessmentScore;
  averageScore: number;         // computed average
  kpiScores: KPIScore[];        // score per KPI
  overallComment: string;       // required
  recommendation: 'pass' | 'fail' | 'extend';
  submittedAt: Date;
}

interface KPIScore {
  kpiId: string;                // ref to KPI.id
  score: 1 | 2 | 3 | 4 | 5;
  comment?: string;
}

// Validation Rules
// - All fields required
// - recommendation must match averageScore >= 3.0 rule
// - overallComment: min 10 chars
```

### 7. Notifications

```typescript
interface Notification {
  _id: ObjectId;
  userId: ObjectId;             // ref: Users
  type: NotificationType;
  title: string;
  message: string;
  data?: {                      // contextual data
    probationRecordId?: ObjectId;
    milestoneDay?: number;
  };
  channels: {
    inApp: { sent: boolean; readAt?: Date };
    email: { sent: boolean; sentAt?: Date };
    push: { sent: boolean; sentAt?: Date };
  };
  createdAt: Date;
}

type NotificationType =
  | 'milestone_due'         // Milestone ใกล้ถึง
  | 'milestone_overdue'     // Milestone เกินกำหนด
  | 'assessment_reminder'   // เตือนกรอกแบบประเมิน
  | 'pending_approval'      // รอหัวหน้ายอมรับ
  | 'milestone_passed'      // ผ่าน Milestone
  | 'milestone_failed'      // ไม่ผ่าน Milestone
  | 'probation_passed'      // ผ่านทดลองงาน
  | 'probation_failed'      // ไม่ผ่านทดลองงาน
  | 'supervisor_changed';   // เปลี่ยนหัวหน้างาน

// Indexes
{ userId: 1, createdAt: -1 }           // user notification list
{ userId: 1, 'channels.inApp.readAt': 1 } // unread count
{ type: 1, createdAt: -1 }             // admin monitoring
```

### 8. AuditLog

```typescript
interface AuditLog {
  _id: ObjectId;
  action: string;               // e.g., 'milestone.approved', 'kpi.created'
  userId: ObjectId;             // who performed action
  targetType: 'user' | 'probation_record' | 'milestone';
  targetId: ObjectId;
  changes?: object;             // before/after values
  ip?: string;
  userAgent?: string;
  createdAt: Date;
}

// Indexes
{ targetType: 1, targetId: 1, createdAt: -1 }
{ userId: 1, createdAt: -1 }
{ createdAt: 1 }  // TTL index for cleanup (optional)
```

## State Transitions

### Probation Record Status

```text
                    ┌──────────────┐
                    │ pending_kpi  │ ← Created
                    └──────┬───────┘
                           │ KPIs assigned
                           ▼
                    ┌──────────────┐
              ┌─────│ in_progress  │─────┐
              │     └──────┬───────┘     │
              │            │             │
         resigned     All milestones   terminated
              │        passed           │
              ▼            │             ▼
       ┌──────────┐        ▼      ┌────────────┐
       │ resigned │  ┌────────────┐│ terminated │
       └──────────┘  │pending_    │└────────────┘
                     │decision    │
                     └─────┬──────┘
                           │
               ┌───────────┴───────────┐
               ▼                       ▼
        ┌──────────┐            ┌──────────┐
        │  passed  │            │  failed  │
        └──────────┘            └──────────┘
```

### Milestone Status

```text
      ┌───────────┐
      │ upcoming  │ ← Default
      └─────┬─────┘
            │ Due date reached
            ▼
    ┌───────────────┐
    │ pending_self  │
    └───────┬───────┘
            │ Self-assessment submitted
            ▼
┌───────────────────────┐
│ pending_supervisor    │
└───────────┬───────────┘
            │ Supervisor assessment submitted
            ▼
    ┌───────────────┐
    │pending_approval│
    └───────┬───────┘
            │
    ┌───────┴───────┐
    ▼               ▼
┌────────┐    ┌────────┐
│ passed │    │ failed │
└────────┘    └────────┘

Note: Any state can transition to 'overdue' if deadline passed without action
```

## Computed Fields

| Field | Location | Computation |
|-------|----------|-------------|
| endDate | ProbationRecord | startDate + probationDays |
| dueDate | Milestone | startDate + milestone.day |
| averageScore | SelfAssessment | (coreValue + jobPerformance + attendance + cultureFit) / 4 |
| averageScore | SupervisorAssessment | Same as above |
| daysRemaining | Milestone | dueDate - today |
| isPassing | Assessment | averageScore >= 3.0 |
