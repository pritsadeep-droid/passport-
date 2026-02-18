const mongoose = require('mongoose');

const auditLogSchema = new mongoose.Schema(
  {
    action: {
      type: String,
      required: [true, 'Action is required'],
      trim: true,
      index: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
      index: true,
    },
    targetType: {
      type: String,
      enum: ['user', 'probation_record', 'milestone', 'kpi', 'notification'],
      required: [true, 'Target type is required'],
    },
    targetId: {
      type: mongoose.Schema.Types.ObjectId,
      required: [true, 'Target ID is required'],
    },
    changes: {
      before: {
        type: mongoose.Schema.Types.Mixed,
      },
      after: {
        type: mongoose.Schema.Types.Mixed,
      },
    },
    metadata: {
      ip: {
        type: String,
        trim: true,
      },
      userAgent: {
        type: String,
        trim: true,
      },
    },
  },
  {
    timestamps: true,
  }
);

// Indexes
auditLogSchema.index({ targetType: 1, targetId: 1, createdAt: -1 });
auditLogSchema.index({ userId: 1, createdAt: -1 });
auditLogSchema.index({ createdAt: 1 }); // For potential TTL cleanup

// Static method to create audit log entry
auditLogSchema.statics.log = async function ({
  action,
  userId,
  targetType,
  targetId,
  changes,
  ip,
  userAgent,
}) {
  return this.create({
    action,
    userId,
    targetType,
    targetId,
    changes,
    metadata: {
      ip,
      userAgent,
    },
  });
};

// Static method to get logs for a specific target
auditLogSchema.statics.getTargetLogs = async function (
  targetType,
  targetId,
  options = {}
) {
  const { limit = 50, skip = 0 } = options;

  return this.find({ targetType, targetId })
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limit)
    .populate('userId', 'name email role')
    .lean();
};

// Static method to get logs by user
auditLogSchema.statics.getUserLogs = async function (userId, options = {}) {
  const { limit = 50, skip = 0 } = options;

  return this.find({ userId })
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limit)
    .lean();
};

const AuditLog = mongoose.model('AuditLog', auditLogSchema);

module.exports = AuditLog;
