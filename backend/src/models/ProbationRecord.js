const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

// Assessment Score Schema (embedded)
const assessmentScoreSchema = new mongoose.Schema(
  {
    score: {
      type: Number,
      required: true,
      min: 1,
      max: 5,
      validate: {
        validator: Number.isInteger,
        message: 'Score must be an integer between 1 and 5',
      },
    },
    comment: {
      type: String,
      trim: true,
      maxlength: 500,
    },
  },
  { _id: false }
);

// Self Assessment Schema (embedded)
const selfAssessmentSchema = new mongoose.Schema(
  {
    coreValue: {
      type: assessmentScoreSchema,
      required: true,
    },
    jobPerformance: {
      type: assessmentScoreSchema,
      required: true,
    },
    attendance: {
      type: assessmentScoreSchema,
      required: true,
    },
    cultureFit: {
      type: assessmentScoreSchema,
      required: true,
    },
    averageScore: {
      type: Number,
      min: 1,
      max: 5,
    },
    comments: {
      type: String,
      trim: true,
      maxlength: 2000,
    },
    submittedAt: {
      type: Date,
    },
    isDraft: {
      type: Boolean,
      default: true,
    },
    lastSavedAt: {
      type: Date,
    },
  },
  { _id: false }
);

// Calculate average score before saving
selfAssessmentSchema.pre('save', function (next) {
  if (
    this.coreValue?.score &&
    this.jobPerformance?.score &&
    this.attendance?.score &&
    this.cultureFit?.score
  ) {
    this.averageScore =
      (this.coreValue.score +
        this.jobPerformance.score +
        this.attendance.score +
        this.cultureFit.score) /
      4;
  }
  next();
});

// KPI Score Schema (embedded in supervisor assessment)
const kpiScoreSchema = new mongoose.Schema(
  {
    kpiId: {
      type: String,
      required: true,
    },
    score: {
      type: Number,
      required: true,
      min: 1,
      max: 5,
      validate: {
        validator: Number.isInteger,
        message: 'Score must be an integer between 1 and 5',
      },
    },
    comment: {
      type: String,
      trim: true,
      maxlength: 500,
    },
  },
  { _id: false }
);

// Supervisor Assessment Schema (embedded)
const supervisorAssessmentSchema = new mongoose.Schema(
  {
    coreValue: {
      type: assessmentScoreSchema,
      required: true,
    },
    jobPerformance: {
      type: assessmentScoreSchema,
      required: true,
    },
    attendance: {
      type: assessmentScoreSchema,
      required: true,
    },
    cultureFit: {
      type: assessmentScoreSchema,
      required: true,
    },
    averageScore: {
      type: Number,
      min: 1,
      max: 5,
    },
    kpiScores: {
      type: [kpiScoreSchema],
      default: [],
    },
    overallComment: {
      type: String,
      required: true,
      trim: true,
      minlength: 10,
      maxlength: 2000,
    },
    recommendation: {
      type: String,
      enum: ['pass', 'fail', 'extend'],
      required: true,
    },
    submittedAt: {
      type: Date,
    },
  },
  { _id: false }
);

// Calculate average score before saving
supervisorAssessmentSchema.pre('save', function (next) {
  if (
    this.coreValue?.score &&
    this.jobPerformance?.score &&
    this.attendance?.score &&
    this.cultureFit?.score
  ) {
    this.averageScore =
      (this.coreValue.score +
        this.jobPerformance.score +
        this.attendance.score +
        this.cultureFit.score) /
      4;
  }
  next();
});

// Milestone Schema (embedded)
const milestoneSchema = new mongoose.Schema(
  {
    day: {
      type: Number,
      required: true,
    },
    dueDate: {
      type: Date,
      required: true,
    },
    status: {
      type: String,
      enum: [
        'upcoming',
        'pending_self',
        'pending_supervisor',
        'pending_approval',
        'passed',
        'failed',
        'overdue',
      ],
      default: 'upcoming',
    },
    selfAssessment: {
      type: selfAssessmentSchema,
    },
    supervisorAssessment: {
      type: supervisorAssessmentSchema,
    },
    approvedAt: {
      type: Date,
    },
    approvedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
    rejectionReason: {
      type: String,
      trim: true,
      maxlength: 1000,
    },
  },
  { _id: false }
);

// KPI Schema (embedded)
const kpiSchema = new mongoose.Schema(
  {
    id: {
      type: String,
      default: () => uuidv4(),
    },
    title: {
      type: String,
      required: [true, 'KPI title is required'],
      trim: true,
      maxlength: 200,
    },
    description: {
      type: String,
      required: [true, 'KPI description is required'],
      trim: true,
      maxlength: 1000,
    },
    criteria: {
      type: String,
      required: [true, 'KPI criteria is required'],
      trim: true,
      maxlength: 500,
    },
    status: {
      type: String,
      enum: ['active', 'completed', 'cancelled'],
      default: 'active',
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
      default: Date.now,
    },
  },
  { _id: false }
);

// Probation Record Schema
const probationRecordSchema = new mongoose.Schema(
  {
    employeeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Employee ID is required'],
      unique: true,
      index: true,
    },
    supervisorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Supervisor ID is required'],
    },
    startDate: {
      type: Date,
      required: [true, 'Start date is required'],
    },
    probationDays: {
      type: Number,
      required: true,
      default: 90,
    },
    endDate: {
      type: Date,
      required: true,
    },
    status: {
      type: String,
      enum: [
        'pending_kpi',
        'in_progress',
        'pending_decision',
        'passed',
        'failed',
        'resigned',
        'terminated',
      ],
      default: 'pending_kpi',
    },
    kpis: {
      type: [kpiSchema],
      validate: [
        {
          validator: function (v) {
            // Allow empty KPIs in pending_kpi status
            if (this.status === 'pending_kpi') return true;
            return v.length >= 3;
          },
          message: 'Minimum 3 KPIs required',
        },
        {
          validator: function (v) {
            return v.length <= 5;
          },
          message: 'Maximum 5 KPIs allowed',
        },
      ],
    },
    milestones: {
      type: [milestoneSchema],
      default: [],
    },
    finalDecision: {
      decision: {
        type: String,
        enum: ['passed', 'failed'],
      },
      decidedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
      decidedAt: {
        type: Date,
      },
      reason: {
        type: String,
        trim: true,
        maxlength: 2000,
      },
    },
  },
  {
    timestamps: true,
  }
);

// Indexes
probationRecordSchema.index({ supervisorId: 1, status: 1 });
probationRecordSchema.index({ status: 1, 'milestones.dueDate': 1 });
probationRecordSchema.index({ endDate: 1, status: 1 });

// Calculate endDate before saving
probationRecordSchema.pre('save', function (next) {
  if (this.isModified('startDate') || this.isModified('probationDays')) {
    const endDate = new Date(this.startDate);
    endDate.setDate(endDate.getDate() + this.probationDays);
    this.endDate = endDate;
  }
  next();
});

// Initialize milestones when probation record is created
probationRecordSchema.pre('save', async function (next) {
  if (this.isNew && this.milestones.length === 0) {
    // Default fallback values
    const defaultMilestoneDays = {
      '90': [30, 60, 90],
      '119': [30, 60, 90, 119],
    };

    let milestoneDays;
    try {
      const Settings = mongoose.model('Settings');
      const settings = await Settings.getSettings();
      const key = String(this.probationDays);
      milestoneDays = settings.milestoneDays.get(key);
    } catch (err) {
      // Settings model not available or fetch failed — use fallback
    }

    if (!milestoneDays || milestoneDays.length === 0) {
      const key = String(this.probationDays);
      milestoneDays = defaultMilestoneDays[key] || [30, 60, 90];
    }

    this.milestones = milestoneDays.map((day) => {
      const dueDate = new Date(this.startDate);
      dueDate.setDate(dueDate.getDate() + day);
      return {
        day,
        dueDate,
        status: 'upcoming',
      };
    });
  }
  next();
});

// Virtual for days remaining
probationRecordSchema.virtual('daysRemaining').get(function () {
  const today = new Date();
  const diffTime = this.endDate - today;
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  return Math.max(0, diffDays);
});

// Virtual for progress percentage
probationRecordSchema.virtual('progressPercentage').get(function () {
  const today = new Date();
  const totalDays =
    (this.endDate - this.startDate) / (1000 * 60 * 60 * 24);
  const elapsedDays =
    (today - this.startDate) / (1000 * 60 * 60 * 24);
  const percentage = Math.min(100, Math.max(0, (elapsedDays / totalDays) * 100));
  return Math.round(percentage);
});

// Ensure virtuals are included in JSON output
probationRecordSchema.set('toJSON', { virtuals: true });
probationRecordSchema.set('toObject', { virtuals: true });

const ProbationRecord = mongoose.model('ProbationRecord', probationRecordSchema);

module.exports = ProbationRecord;
