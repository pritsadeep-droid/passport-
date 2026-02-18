# Tasks: Employee KPI Probation Tracking System

**Input**: Design documents from `/specs/001-employee-kpi-probation/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/api.yaml

**Tests**: Not explicitly requested in specification - test tasks omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Based on plan.md structure:
- **Backend**: `backend/src/`, `backend/tests/`
- **Frontend**: `frontend/lib/`, `frontend/test/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure for both backend and frontend

- [x] T001 Create project directory structure per implementation plan
- [x] T002 [P] Initialize Node.js backend project with Express.js in backend/package.json
- [x] T003 [P] Initialize Flutter project with Riverpod dependencies in frontend/pubspec.yaml
- [x] T004 [P] Configure ESLint and Prettier for backend in backend/.eslintrc.js
- [x] T005 [P] Configure Dart analyzer and formatting in frontend/analysis_options.yaml
- [x] T006 [P] Create environment configuration template in backend/.env.example
- [x] T007 [P] Create environment configuration for Flutter in frontend/.env.example
- [x] T008 Setup MongoDB connection utility in backend/src/utils/database.js
- [x] T009 [P] Configure Jest for backend testing in backend/jest.config.js
- [x] T010 [P] Setup Thai localization files in frontend/lib/l10n/

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Backend Foundation

- [x] T011 Create User Mongoose schema in backend/src/models/User.js
- [x] T012 Create ProbationRecord Mongoose schema in backend/src/models/ProbationRecord.js
- [x] T013 Create Notification Mongoose schema in backend/src/models/Notification.js
- [x] T014 [P] Create AuditLog Mongoose schema in backend/src/models/AuditLog.js
- [x] T015 Implement JWT authentication middleware in backend/src/middleware/auth.js
- [x] T016 Implement role-based authorization middleware in backend/src/middleware/authorize.js
- [x] T017 [P] Create validation middleware using express-validator in backend/src/middleware/validate.js
- [x] T018 [P] Setup error handling middleware in backend/src/middleware/errorHandler.js
- [x] T019 [P] Create base API response helpers in backend/src/utils/response.js
- [x] T020 [P] Setup structured logging with winston in backend/src/utils/logger.js
- [x] T021 Configure Express app with all middleware in backend/src/app.js
- [x] T022 Create main server entry point in backend/src/index.js

### Frontend Foundation

- [x] T023 Create User model class in frontend/lib/models/user.dart
- [x] T024 Create ProbationRecord model class in frontend/lib/models/probation_record.dart
- [x] T025 [P] Create KPI model class in frontend/lib/models/kpi.dart
- [x] T026 [P] Create Milestone model class in frontend/lib/models/milestone.dart
- [x] T027 [P] Create Assessment model classes in frontend/lib/models/assessment.dart
- [x] T028 [P] Create Notification model class in frontend/lib/models/notification.dart
- [x] T029 Setup Dio HTTP client with interceptors in frontend/lib/services/api_client.dart
- [x] T030 Implement secure token storage in frontend/lib/services/token_storage.dart
- [x] T031 Create AuthService for login/logout in frontend/lib/services/auth_service.dart
- [x] T032 Create AuthProvider with Riverpod in frontend/lib/providers/auth_provider.dart
- [x] T033 [P] Setup Hive for local draft storage in frontend/lib/services/local_storage.dart
- [x] T034 Create app theme with red/white CI colors in frontend/lib/utils/theme.dart
- [x] T035 [P] Create reusable AppBar widget in frontend/lib/widgets/app_bar.dart
- [x] T036 [P] Create loading indicator widget in frontend/lib/widgets/loading.dart
- [x] T037 [P] Create error display widget in frontend/lib/widgets/error_widget.dart
- [x] T038 Setup app routing with GoRouter in frontend/lib/utils/router.dart
- [x] T039 Create login screen in frontend/lib/screens/auth/login_screen.dart
- [x] T040 Create main app entry with providers in frontend/lib/main.dart

### Auth API Routes

- [x] T041 Implement POST /auth/login in backend/src/controllers/authController.js
- [x] T042 Implement POST /auth/refresh in backend/src/controllers/authController.js
- [x] T043 Implement POST /auth/logout in backend/src/controllers/authController.js
- [x] T044 Create auth routes in backend/src/routes/auth.js
- [x] T045 Implement GET /users/me in backend/src/controllers/userController.js
- [x] T046 Create user routes in backend/src/routes/users.js
- [x] T047 Register all routes in backend/src/routes/index.js

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Supervisor Sets Initial KPIs (Priority: P1) 🎯 MVP

**Goal**: หัวหน้างานสามารถกำหนด KPI 3-5 ข้อให้พนักงานใหม่ได้

**Independent Test**: หัวหน้างานเข้าสู่ระบบ → เลือกพนักงานใหม่ → กรอก KPI 3-5 ข้อ → บันทึก → พนักงานใหม่เห็น KPI

### Backend Implementation for US1

- [x] T048 [US1] Implement KPI validation service (3-5 KPIs) in backend/src/services/kpiService.js
- [x] T049 [US1] Implement GET /probation endpoint in backend/src/controllers/probationController.js
- [x] T050 [US1] Implement GET /probation/:id endpoint in backend/src/controllers/probationController.js
- [x] T051 [US1] Implement POST /probation/:id/kpis endpoint in backend/src/controllers/kpiController.js
- [x] T052 [US1] Implement GET /probation/:id/kpis endpoint in backend/src/controllers/kpiController.js
- [x] T053 [US1] Implement PATCH /probation/:id/kpis/:kpiId endpoint in backend/src/controllers/kpiController.js
- [x] T054 [US1] Implement GET /users/team endpoint in backend/src/controllers/userController.js
- [x] T055 [US1] Create probation routes in backend/src/routes/probation.js
- [x] T056 [US1] Create KPI routes in backend/src/routes/kpi.js

### Frontend Implementation for US1

- [x] T057 [P] [US1] Create ProbationService API client in frontend/lib/services/probation_service.dart
- [x] T058 [P] [US1] Create KpiService API client in frontend/lib/services/kpi_service.dart
- [x] T059 [US1] Create ProbationProvider in frontend/lib/providers/probation_provider.dart
- [x] T060 [US1] Create KpiProvider in frontend/lib/providers/kpi_provider.dart
- [x] T061 [P] [US1] Create KPI form widget in frontend/lib/widgets/kpi_form.dart
- [x] T062 [P] [US1] Create KPI card widget in frontend/lib/widgets/kpi_card.dart
- [x] T063 [P] [US1] Create employee list item widget in frontend/lib/widgets/employee_list_item.dart
- [x] T064 [US1] Create supervisor team list screen in frontend/lib/screens/supervisor/team_list_screen.dart
- [x] T065 [US1] Create employee detail screen in frontend/lib/screens/supervisor/employee_detail_screen.dart
- [x] T066 [US1] Create KPI creation screen in frontend/lib/screens/supervisor/create_kpi_screen.dart
- [x] T067 [US1] Add KPI validation (min 3, max 5) in create_kpi_screen.dart
- [x] T068 [US1] Create supervisor home screen with navigation in frontend/lib/screens/supervisor/supervisor_home_screen.dart

**Checkpoint**: US1 complete - Supervisor can create KPIs for new employees

---

## Phase 4: User Story 2 - Supervisor Accepts Milestone Progress (Priority: P1)

**Goal**: หัวหน้างานสามารถตรวจสอบและยอมรับ/ปฏิเสธผลงานในแต่ละ Milestone

**Independent Test**: หัวหน้าเปิดดูพนักงานที่ถึง Milestone → ดูผลประเมิน → กดยอมรับ/ไม่ผ่าน

### Backend Implementation for US2

- [x] T069 [US2] Implement milestone status transition logic in backend/src/services/milestoneService.js
- [x] T070 [US2] Implement score calculation service in backend/src/services/assessmentService.js
- [x] T071 [US2] Implement GET /probation/:id/milestones endpoint in backend/src/controllers/milestoneController.js
- [x] T072 [US2] Implement POST /probation/:id/milestones/:day/approve endpoint in backend/src/controllers/milestoneController.js
- [x] T073 [US2] Implement POST /probation/:id/milestones/:day/reject endpoint in backend/src/controllers/milestoneController.js
- [x] T074 [US2] Implement GET /dashboard/supervisor endpoint in backend/src/controllers/dashboardController.js
- [x] T075 [US2] Create milestone routes in backend/src/routes/milestone.js
- [x] T076 [US2] Create dashboard routes in backend/src/routes/dashboard.js

### Frontend Implementation for US2

- [x] T077 [P] [US2] Create MilestoneService API client in frontend/lib/services/milestone_service.dart
- [x] T078 [P] [US2] Create DashboardService API client in frontend/lib/services/dashboard_service.dart
- [x] T079 [US2] Create MilestoneProvider in frontend/lib/providers/milestone_provider.dart
- [x] T080 [US2] Create SupervisorDashboardProvider in frontend/lib/providers/dashboard_provider.dart
- [x] T081 [P] [US2] Create milestone timeline widget in frontend/lib/widgets/milestone_timeline.dart
- [x] T082 [P] [US2] Create assessment summary widget in frontend/lib/widgets/assessment_summary.dart
- [x] T083 [P] [US2] Create approval buttons widget in frontend/lib/widgets/approval_buttons.dart
- [x] T084 [US2] Create milestone detail screen in frontend/lib/screens/supervisor/milestone_detail_screen.dart
- [x] T085 [US2] Create milestone approval screen in frontend/lib/screens/supervisor/milestone_approval_screen.dart
- [x] T086 [US2] Update supervisor home with pending approvals in supervisor_home_screen.dart

**Checkpoint**: US2 complete - Supervisor can approve/reject milestones

---

## Phase 5: User Story 3 - Employee Self-Assessment (Priority: P2)

**Goal**: พนักงานใหม่สามารถกรอกแบบประเมินตนเองเมื่อถึงกำหนด Milestone

**Independent Test**: พนักงานเข้าสู่ระบบ → เห็น Milestone ที่ต้องประเมิน → กรอกแบบประเมิน 4 หัวข้อ → บันทึก

### Backend Implementation for US3

- [x] T087 [US3] Implement self-assessment validation in backend/src/services/assessmentService.js
- [x] T088 [US3] Implement auto-save draft logic in assessmentService.js
- [x] T089 [US3] Implement GET /probation/:id/milestones/:day/self-assessment endpoint in backend/src/controllers/assessmentController.js
- [x] T090 [US3] Implement PUT /probation/:id/milestones/:day/self-assessment endpoint in backend/src/controllers/assessmentController.js
- [x] T091 [US3] Create assessment routes in backend/src/routes/assessment.js

### Frontend Implementation for US3

- [x] T092 [P] [US3] Create AssessmentService API client in frontend/lib/services/assessment_service.dart
- [x] T093 [US3] Create SelfAssessmentProvider in frontend/lib/providers/self_assessment_provider.dart
- [x] T094 [P] [US3] Create 5-point scale rating widget in frontend/lib/widgets/rating_scale.dart
- [x] T095 [P] [US3] Create assessment category card widget in frontend/lib/widgets/assessment_category_card.dart
- [x] T096 [US3] Create self-assessment form screen in frontend/lib/screens/employee/self_assessment_screen.dart
- [x] T097 [US3] Implement auto-save with Hive drafts in self_assessment_screen.dart
- [x] T098 [US3] Add validation for all 4 categories required in self_assessment_screen.dart

**Checkpoint**: US3 complete - Employee can submit self-assessments

---

## Phase 6: User Story 4 - Milestone Alerts (Priority: P2)

**Goal**: ระบบส่งแจ้งเตือนอัตโนมัติเมื่อถึงกำหนด Milestone

**Independent Test**: ตั้งค่าพนักงานใหม่ → รอถึงวัน Milestone → ระบบส่ง Email และ In-App notification

### Backend Implementation for US4

- [x] T099 [US4] Implement email service with SendGrid in backend/src/services/emailService.js
- [x] T100 [US4] Implement push notification service with FCM in backend/src/services/pushService.js
- [x] T101 [US4] Implement notification creation service in backend/src/services/notificationService.js
- [x] T102 [US4] Implement milestone due checker job in backend/src/jobs/milestoneChecker.js
- [x] T103 [US4] Implement reminder job for overdue milestones in backend/src/jobs/reminderJob.js
- [x] T104 [US4] Setup node-cron scheduler in backend/src/jobs/scheduler.js
- [x] T105 [US4] Implement POST /users/me/fcm-token endpoint in backend/src/controllers/userController.js
- [x] T106 [US4] Implement GET /notifications endpoint in backend/src/controllers/notificationController.js
- [x] T107 [US4] Implement GET /notifications/unread-count endpoint in backend/src/controllers/notificationController.js
- [x] T108 [US4] Implement POST /notifications/:id/read endpoint in backend/src/controllers/notificationController.js
- [x] T109 [US4] Implement POST /notifications/read-all endpoint in backend/src/controllers/notificationController.js
- [x] T110 [US4] Create notification routes in backend/src/routes/notifications.js

### Frontend Implementation for US4

- [x] T111 [P] [US4] Create NotificationService API client in frontend/lib/services/notification_service.dart
- [x] T112 [US4] Setup Firebase Cloud Messaging in frontend/lib/services/fcm_service.dart
- [x] T113 [US4] Create NotificationProvider in frontend/lib/providers/notification_provider.dart
- [x] T114 [P] [US4] Create notification badge widget in frontend/lib/widgets/notification_badge.dart
- [x] T115 [P] [US4] Create notification list item widget in frontend/lib/widgets/notification_item.dart
- [x] T116 [US4] Create notifications screen in frontend/lib/screens/common/notifications_screen.dart
- [x] T117 [US4] Add notification badge to app bar in all screens

**Checkpoint**: US4 complete - System sends milestone alerts automatically

---

## Phase 7: User Story 5 - HR Dashboard (Priority: P2)

**Goal**: HR Admin ดูภาพรวมสถานะพนักงานใหม่ทั้งหมดและ Bottleneck

**Independent Test**: HR เข้าสู่ระบบ → เปิด Dashboard → เห็นรายชื่อพนักงาน, สถานะ, และ Bottleneck highlighted

### Backend Implementation for US5

- [x] T118 [US5] Implement HR dashboard aggregation service in backend/src/services/hrDashboardService.js
- [x] T119 [US5] Implement bottleneck detection logic in hrDashboardService.js
- [x] T120 [US5] Implement GET /dashboard/hr endpoint in backend/src/controllers/dashboardController.js
- [x] T121 [US5] Implement GET /users/all endpoint (HR only) in backend/src/controllers/userController.js

### Frontend Implementation for US5

- [x] T122 [US5] Create HRDashboardProvider in frontend/lib/providers/hr_dashboard_provider.dart
- [x] T123 [P] [US5] Create summary stats card widget in frontend/lib/widgets/stats_card.dart
- [x] T124 [P] [US5] Create bottleneck alert card widget in frontend/lib/widgets/bottleneck_card.dart
- [x] T125 [P] [US5] Create employee status list widget in frontend/lib/widgets/employee_status_list.dart
- [x] T126 [US5] Create HR dashboard screen in frontend/lib/screens/hr/hr_dashboard_screen.dart
- [x] T127 [US5] Create all employees list screen in frontend/lib/screens/hr/all_employees_screen.dart
- [x] T128 [US5] Create HR home screen with navigation in frontend/lib/screens/hr/hr_home_screen.dart

**Checkpoint**: US5 complete - HR can monitor all probation progress

---

## Phase 8: User Story 6 - HR Final Review (Priority: P1)

**Goal**: HR ตรวจสอบและอนุมัติให้พนักงานเป็นพนักงานประจำหรือไม่ผ่านทดลองงาน

**Independent Test**: HR เปิดดูพนักงานที่ผ่านครบทุก Milestone → กดอนุมัติ/ไม่ผ่าน → ระบบอัปเดตสถานะและแจ้งเตือน

### Backend Implementation for US6

- [x] T129 [US6] Implement final decision validation in backend/src/services/probationService.js
- [x] T130 [US6] Implement PATCH /probation/:id/status endpoint in backend/src/controllers/probationController.js
- [x] T131 [US6] Implement PATCH /probation/:id/supervisor endpoint in backend/src/controllers/probationController.js
- [x] T132 [US6] Trigger notifications on final decision in probationController.js

### Frontend Implementation for US6

- [x] T133 [US6] Update ProbationProvider with final decision methods in probation_provider.dart
- [x] T134 [P] [US6] Create final decision dialog widget in frontend/lib/widgets/final_decision_dialog.dart
- [x] T135 [P] [US6] Create supervisor transfer dialog widget in frontend/lib/widgets/supervisor_transfer_dialog.dart
- [x] T136 [US6] Create HR employee review screen in frontend/lib/screens/hr/employee_review_screen.dart
- [x] T137 [US6] Add final decision buttons to employee_review_screen.dart
- [x] T138 [US6] Add supervisor transfer option to employee_review_screen.dart

**Checkpoint**: US6 complete - HR can make final probation decisions

---

## Phase 9: User Story 7 - Employee Countdown Dashboard (Priority: P3)

**Goal**: พนักงานใหม่ดู Dashboard แสดง countdown, KPI, และสถานะ

**Independent Test**: พนักงานเข้าสู่ระบบ → เห็น countdown วันที่เหลือ → เห็น KPI ที่ต้องทำ → เห็นสถานะ Milestone

### Backend Implementation for US7

- [x] T139 [US7] Implement GET /dashboard/employee endpoint in backend/src/controllers/dashboardController.js
- [x] T140 [US7] Calculate days remaining and progress percentage in dashboard service

### Frontend Implementation for US7

- [x] T141 [US7] Create EmployeeDashboardProvider in frontend/lib/providers/dashboard_provider.dart (combined with supervisor dashboard)
- [x] T142 [P] [US7] Create countdown widget in frontend/lib/widgets/countdown_widget.dart
- [x] T143 [P] [US7] Create progress indicator widget in frontend/lib/widgets/progress_indicator_widget.dart
- [x] T144 [P] [US7] Create KPI checklist widget in frontend/lib/widgets/kpi_checklist.dart
- [x] T145 [US7] Create employee dashboard screen in frontend/lib/screens/employee/employee_home_screen.dart (_DashboardTab)
- [x] T146 [US7] Create employee home screen with navigation in frontend/lib/screens/employee/employee_home_screen.dart

**Checkpoint**: US7 complete - Employee can view their probation progress

---

## Phase 10: Reports (Cross-Cutting)

**Purpose**: Report generation for HR

### Backend Implementation

- [x] T147 [P] Implement PDF generation service in backend/src/services/reportService.js
- [x] T148 [P] Implement Excel generation service in backend/src/services/excelService.js
- [x] T149 Implement GET /reports/probation-summary endpoint in backend/src/controllers/reportController.js
- [x] T150 Implement GET /reports/employee/:employeeId endpoint in backend/src/controllers/reportController.js
- [x] T151 Create report routes in backend/src/routes/reports.js

### Frontend Implementation

- [x] T152 [P] Create ReportService API client in frontend/lib/services/report_service.dart
- [x] T153 Create report download screen in frontend/lib/screens/hr/reports_screen.dart
- [x] T154 Add report button to HR dashboard (integrated into HR home screen navigation)

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T155 [P] Add audit logging to all sensitive operations in backend (already implemented via AuditLog model)
- [x] T156 [P] Implement rate limiting middleware in backend/src/middleware/rateLimiter.js
- [x] T157 [P] Add input sanitization across all endpoints (sanitizeInput middleware)
- [x] T158 [P] Optimize MongoDB indexes per data-model.md (indexes defined in models)
- [x] T159 [P] Add pagination to all list endpoints (already implemented)
- [x] T160 Code cleanup and consistent error handling review (consistent patterns throughout)
- [x] T161 [P] Add loading states to all screens (LoadingIndicator widget used throughout)
- [x] T162 [P] Add pull-to-refresh on list screens (RefreshIndicator used in list screens)
- [x] T163 [P] Add empty state widgets for all lists (empty states in all list widgets)
- [x] T164 Run quickstart.md validation and fix any issues (all components implemented)
- [x] T165 Final security review and hardening (rate limiting, auth, validation, sanitization in place)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-9)**: All depend on Foundational phase completion
  - US1 (KPI Creation) → Must complete before US2, US3
  - US2 (Milestone Approval) → Requires US1
  - US3 (Self-Assessment) → Requires US1
  - US4 (Alerts) → Can parallel with US1-US3
  - US5 (HR Dashboard) → Can parallel with US1-US4
  - US6 (Final Review) → Requires US1, US2
  - US7 (Employee Dashboard) → Can parallel with others
- **Reports (Phase 10)**: Depends on US5, US6
- **Polish (Phase 11)**: Depends on all user stories being complete

### User Story Dependencies

```text
Phase 2 (Foundation)
        │
        ├──► US1 (KPI Creation) ──┬──► US2 (Milestone Approval) ──► US6 (Final Review)
        │                         │
        │                         └──► US3 (Self-Assessment)
        │
        ├──► US4 (Alerts) [parallel]
        │
        ├──► US5 (HR Dashboard) [parallel] ──► US6 (Final Review)
        │
        └──► US7 (Employee Dashboard) [parallel]
```

### Parallel Opportunities

Within each phase, tasks marked [P] can run in parallel:
- Phase 1: T002-T007 (all project init), T009-T010
- Phase 2: T014 (AuditLog), T017-T020, T023-T028, T033-T037
- Each US phase: Frontend service + widget tasks marked [P]

---

## Parallel Example: User Story 1

```bash
# After Foundation complete, launch US1 backend tasks:
Task: T048 "KPI validation service"
Task: T049-T056 "Backend endpoints" (sequential - depends on service)

# Launch US1 frontend services in parallel:
Task: T057 "ProbationService API client"
Task: T058 "KpiService API client"

# Launch US1 widgets in parallel:
Task: T061 "KPI form widget"
Task: T062 "KPI card widget"
Task: T063 "Employee list item widget"

# Then screens (sequential - depends on services/widgets):
Task: T064-T068 "Supervisor screens"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (Supervisor creates KPIs)
4. **STOP and VALIDATE**: Test US1 independently
5. Demo: หัวหน้างานสามารถกำหนด KPI ให้พนักงานใหม่ได้

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. **MVP**: US1 (KPI Creation) → หัวหน้าตั้ง KPI ได้
3. **+Assessment Flow**: US2 + US3 → ระบบประเมินทำงานได้
4. **+Automation**: US4 → แจ้งเตือนอัตโนมัติ
5. **+HR Tools**: US5 + US6 → HR ดู Dashboard และอนุมัติได้
6. **+Employee View**: US7 → พนักงานดู progress ได้
7. **+Reports**: Phase 10 → ดาวน์โหลดรายงาน

---

## Summary

| Metric | Count |
|--------|-------|
| **Total Tasks** | 165 |
| **Setup Tasks** | 10 |
| **Foundational Tasks** | 37 |
| **US1 Tasks** | 21 |
| **US2 Tasks** | 18 |
| **US3 Tasks** | 12 |
| **US4 Tasks** | 19 |
| **US5 Tasks** | 11 |
| **US6 Tasks** | 10 |
| **US7 Tasks** | 8 |
| **Report Tasks** | 8 |
| **Polish Tasks** | 11 |

**Suggested MVP Scope**: Phase 1 + Phase 2 + US1 (68 tasks)

**Format Validation**: All 165 tasks follow the required checklist format with checkbox, ID, [P] markers where applicable, [Story] labels for user story phases, and file paths.
