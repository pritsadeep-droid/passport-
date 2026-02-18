# Quickstart Guide: Employee KPI Probation Tracking System

**Branch**: `001-employee-kpi-probation` | **Date**: 2026-02-03

## Prerequisites

### Development Environment

- **Node.js**: v20.x LTS
- **Flutter**: v3.x
- **MongoDB**: v7.x (local or Atlas)
- **Git**: v2.x

### Accounts Required

- MongoDB Atlas account (for cloud deployment) or local MongoDB
- SendGrid account (for email notifications)
- Firebase project (for push notifications)

## Project Setup

### 1. Clone and Initialize

```bash
# Clone repository
git clone <repository-url>
cd passport

# Checkout feature branch
git checkout 001-employee-kpi-probation
```

### 2. Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Edit .env with your configuration
# Required variables:
# - MONGODB_URI=mongodb://localhost:27017/kpi_probation
# - JWT_SECRET=your-secret-key
# - SENDGRID_API_KEY=your-sendgrid-key
# - FIREBASE_PROJECT_ID=your-project-id

# Start development server
npm run dev
```

### 3. Frontend Setup

```bash
# Navigate to frontend
cd frontend

# Get Flutter dependencies
flutter pub get

# Copy environment configuration
cp .env.example .env

# Edit .env with your configuration
# Required variables:
# - API_BASE_URL=http://localhost:3000/api/v1

# Run on web
flutter run -d chrome

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android
```

### 4. Database Setup

```bash
# Start MongoDB locally (if not using Atlas)
mongod --dbpath /path/to/data

# Seed initial data (optional)
cd backend
npm run seed
```

## Environment Variables

### Backend (.env)

```env
# Server
PORT=3000
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/kpi_probation

# Authentication
JWT_SECRET=your-jwt-secret-key-min-32-chars
JWT_EXPIRES_IN=7d
JWT_REFRESH_EXPIRES_IN=30d

# Email (SendGrid)
SENDGRID_API_KEY=SG.xxxxx
SENDGRID_FROM_EMAIL=noreply@company.com
SENDGRID_FROM_NAME=KPI Probation System

# Firebase (Push Notifications)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk@your-project.iam.gserviceaccount.com

# Notification Settings
REMINDER_DAYS_BEFORE=3
ESCALATION_DAYS_AFTER=3
```

### Frontend (.env)

```env
API_BASE_URL=http://localhost:3000/api/v1
```

## Running Tests

### Backend Tests

```bash
cd backend

# Unit tests
npm test

# Integration tests
npm run test:integration

# Test coverage
npm run test:coverage
```

### Frontend Tests

```bash
cd frontend

# Unit tests
flutter test

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/

# Test coverage
flutter test --coverage
```

## Development Workflow

### 1. Creating a New Feature

```bash
# Create feature branch from main
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: your feature description"

# Push and create PR
git push origin feature/your-feature-name
```

### 2. API Development Workflow

1. Update OpenAPI spec in `specs/001-employee-kpi-probation/contracts/api.yaml`
2. Implement route in `backend/src/routes/`
3. Implement controller in `backend/src/controllers/`
4. Add service logic in `backend/src/services/`
5. Write tests in `backend/tests/`

### 3. Frontend Development Workflow

1. Create/update models in `frontend/lib/models/`
2. Update API service in `frontend/lib/services/`
3. Create/update providers in `frontend/lib/providers/`
4. Build screens in `frontend/lib/screens/`
5. Write tests in `frontend/test/`

## Common Commands

### Backend

```bash
# Start development server with hot reload
npm run dev

# Start production server
npm start

# Run database migrations
npm run migrate

# Seed database
npm run seed

# Lint code
npm run lint

# Format code
npm run format
```

### Frontend

```bash
# Run on specific device
flutter run -d <device_id>

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Build web
flutter build web

# Analyze code
flutter analyze

# Format code
dart format .

# Generate localization files
flutter gen-l10n
```

## API Quick Reference

### Authentication

```bash
# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}'

# Response: { "accessToken": "...", "refreshToken": "...", "user": {...} }
```

### Common Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/dashboard/hr` | HR Dashboard |
| GET | `/api/v1/dashboard/supervisor` | Supervisor Dashboard |
| GET | `/api/v1/dashboard/employee` | Employee Dashboard |
| GET | `/api/v1/probation` | List probation records |
| POST | `/api/v1/probation/{id}/kpis` | Create KPIs |
| PUT | `/api/v1/probation/{id}/milestones/{day}/self-assessment` | Submit self-assessment |
| POST | `/api/v1/probation/{id}/milestones/{day}/approve` | Approve milestone |

## Troubleshooting

### MongoDB Connection Issues

```bash
# Check if MongoDB is running
mongosh --eval "db.adminCommand('ping')"

# Check connection string format
# Local: mongodb://localhost:27017/kpi_probation
# Atlas: mongodb+srv://user:pass@cluster.mongodb.net/kpi_probation
```

### Flutter Build Issues

```bash
# Clean build cache
flutter clean
flutter pub get

# Update Flutter
flutter upgrade

# Check Flutter doctor
flutter doctor -v
```

### Backend Not Starting

```bash
# Check port availability
lsof -i :3000

# Check environment variables
node -e "console.log(process.env.MONGODB_URI)"

# Run with debug logging
DEBUG=* npm run dev
```

## Project Structure Quick Reference

```text
passport/
├── backend/
│   ├── src/
│   │   ├── models/        # Mongoose schemas
│   │   ├── services/      # Business logic
│   │   ├── controllers/   # Route handlers
│   │   ├── routes/        # API routes
│   │   ├── middleware/    # Auth, validation
│   │   └── jobs/          # Scheduled tasks
│   └── tests/
│
├── frontend/
│   ├── lib/
│   │   ├── models/        # Dart data classes
│   │   ├── services/      # API clients
│   │   ├── providers/     # State management
│   │   ├── screens/       # UI pages
│   │   └── widgets/       # Reusable components
│   └── test/
│
└── specs/001-employee-kpi-probation/
    ├── spec.md            # Feature specification
    ├── plan.md            # Implementation plan
    ├── research.md        # Technical research
    ├── data-model.md      # Database schema
    ├── quickstart.md      # This file
    └── contracts/
        └── api.yaml       # OpenAPI specification
```

## Next Steps

1. Review the [spec.md](./spec.md) for feature requirements
2. Review the [data-model.md](./data-model.md) for database schema
3. Review the [api.yaml](./contracts/api.yaml) for API contracts
4. Check [tasks.md](./tasks.md) for implementation tasks (after `/speckit.tasks`)
