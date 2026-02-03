# Research: Employee KPI Probation Tracking System

**Branch**: `001-employee-kpi-probation` | **Date**: 2026-02-03

## Research Topics

### 1. Flutter State Management for HR Applications

**Decision**: Riverpod 2.x

**Rationale**:
- Compile-time safety with code generation
- Better testability compared to Provider
- Built-in support for async operations (API calls)
- No BuildContext dependency for accessing state
- Works well with offline-first patterns (auto-save)

**Alternatives Considered**:
- Provider: Simpler but less type-safe, harder to test
- BLoC: More boilerplate, overkill for this scale
- GetX: Less community adoption, testing concerns

---

### 2. MongoDB Schema Design for Assessment Data

**Decision**: Embedded documents for assessments within Employee document

**Rationale**:
- Assessments are always accessed with employee context
- Reduces query complexity (single document fetch)
- Natural fit for milestone-based tracking
- Good performance for dashboard aggregations

**Alternatives Considered**:
- Separate collections with references: More normalized but requires joins
- Hybrid approach: Embed recent, reference historical (unnecessary complexity for scale)

**Schema Pattern**:
```javascript
// Employee document with embedded milestones
{
  _id: ObjectId,
  employeeId: String,
  supervisorId: ObjectId,
  startDate: Date,
  probationDays: Number, // 90 or 119
  milestones: [
    {
      day: Number, // 30, 60, 90, 119
      status: String, // pending, awaiting_approval, passed, failed
      selfAssessment: { /* embedded */ },
      supervisorAssessment: { /* embedded */ },
      approvedAt: Date
    }
  ]
}
```

---

### 3. Notification System Architecture

**Decision**: Background job scheduler (node-cron) + Email service (Nodemailer/SendGrid) + Firebase Cloud Messaging (FCM)

**Rationale**:
- node-cron: Simple, reliable for scheduled milestone checks
- SendGrid: Reliable email delivery with analytics
- FCM: Cross-platform push notifications (iOS, Android, Web)
- In-app notifications stored in MongoDB for persistence

**Alternatives Considered**:
- AWS SES + SNS: More complex setup, AWS lock-in
- Agenda.js: More features than needed, adds Redis dependency
- OneSignal: Good but adds another vendor

**Implementation Pattern**:
```text
Daily Job (node-cron) → Check milestone dates →
  → Queue notifications →
    → Send Email (SendGrid)
    → Send Push (FCM)
    → Store In-App (MongoDB)
```

---

### 4. Authentication & Authorization

**Decision**: JWT-based authentication with role-based access control (RBAC)

**Rationale**:
- Assumption: Integrate with existing org authentication
- JWT works well with mobile apps (stateless)
- RBAC sufficient for 3 roles: Employee, Supervisor, HR Admin
- Can integrate with SSO later if needed

**Role Permissions**:
| Action | Employee | Supervisor | HR Admin |
|--------|----------|------------|----------|
| View own dashboard | ✓ | ✓ | ✓ |
| Submit self-assessment | ✓ | - | - |
| Create/Edit KPI | - | ✓ | ✓ |
| Approve milestone | - | ✓ | ✓ |
| View all employees | - | Own team | ✓ |
| Final probation decision | - | - | ✓ |
| Download reports | - | Own team | ✓ |

---

### 5. Offline Support & Auto-Save

**Decision**: Local SQLite/Hive for draft storage + Sync on reconnect

**Rationale**:
- Form data saved locally every 30 seconds
- Sync when online (optimistic UI)
- Conflict resolution: Server wins (last-write-wins for simplicity)
- Critical for mobile users in areas with poor connectivity

**Implementation**:
- Use Hive (Flutter): Fast, no native dependencies
- Store draft assessments locally
- Background sync service
- Visual indicator for sync status

---

### 6. Report Generation

**Decision**: Server-side PDF generation with puppeteer/pdfkit

**Rationale**:
- Consistent formatting across platforms
- Can include charts and Thai fonts
- Generate on-demand or scheduled
- Store generated reports temporarily (24h) for download

**Alternatives Considered**:
- Client-side PDF: Inconsistent across platforms, large bundle size
- Excel export: Added for tabular data alongside PDF

---

### 7. Thai Language & Localization

**Decision**: Flutter intl package with ARB files

**Rationale**:
- Official Flutter localization approach
- Supports Thai date formatting
- Easy to add more languages later
- Compile-time validation of translations

**Key Considerations**:
- Thai Buddhist calendar year display (optional toggle)
- Thai numeral support (optional)
- RTL not needed (Thai is LTR)

---

## Technology Stack Summary

| Layer | Technology | Version |
|-------|------------|---------|
| Frontend Framework | Flutter | 3.x |
| State Management | Riverpod | 2.x |
| Local Storage | Hive | 2.x |
| Backend Runtime | Node.js | 20.x LTS |
| Backend Framework | Express.js | 4.x |
| Database | MongoDB | 7.x |
| ODM | Mongoose | 8.x |
| Email Service | SendGrid | - |
| Push Notifications | Firebase Cloud Messaging | - |
| Job Scheduler | node-cron | 3.x |
| Testing (Frontend) | flutter_test, mockito | - |
| Testing (Backend) | Jest, Supertest | - |

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Notification delivery failure | Users miss milestone deadlines | Retry mechanism, fallback channels, delivery tracking |
| Data loss during offline | Lost assessment data | Auto-save every 30s, sync status indicator |
| Concurrent edit conflicts | Data inconsistency | Last-write-wins, audit log for disputes |
| Performance at scale | Slow dashboard | MongoDB indexes, pagination, caching |
