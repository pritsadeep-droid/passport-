const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
      index: true,
    },
    type: {
      type: String,
      enum: [
        'milestone_due',
        'milestone_overdue',
        'assessment_reminder',
        'pending_approval',
        'milestone_passed',
        'milestone_failed',
        'probation_passed',
        'probation_failed',
        'supervisor_changed',
      ],
      required: [true, 'Notification type is required'],
    },
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
      maxlength: 200,
    },
    message: {
      type: String,
      required: [true, 'Message is required'],
      trim: true,
      maxlength: 1000,
    },
    data: {
      probationRecordId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'ProbationRecord',
      },
      milestoneDay: {
        type: Number,
        enum: [30, 60, 90, 119],
      },
    },
    channels: {
      inApp: {
        sent: {
          type: Boolean,
          default: false,
        },
        readAt: {
          type: Date,
          default: null,
        },
      },
      email: {
        sent: {
          type: Boolean,
          default: false,
        },
        sentAt: {
          type: Date,
          default: null,
        },
      },
      push: {
        sent: {
          type: Boolean,
          default: false,
        },
        sentAt: {
          type: Date,
          default: null,
        },
      },
    },
  },
  {
    timestamps: true,
  }
);

// Indexes
notificationSchema.index({ userId: 1, createdAt: -1 });
notificationSchema.index({ userId: 1, 'channels.inApp.readAt': 1 });
notificationSchema.index({ type: 1, createdAt: -1 });

// Virtual for isRead
notificationSchema.virtual('isRead').get(function () {
  return this.channels?.inApp?.readAt != null;
});

// Ensure virtuals are included in JSON output
notificationSchema.set('toJSON', { virtuals: true });
notificationSchema.set('toObject', { virtuals: true });

// Static method to get unread count for a user
notificationSchema.statics.getUnreadCount = async function (userId) {
  return this.countDocuments({
    userId,
    'channels.inApp.readAt': null,
  });
};

// Static method to mark all as read for a user
notificationSchema.statics.markAllAsRead = async function (userId) {
  return this.updateMany(
    {
      userId,
      'channels.inApp.readAt': null,
    },
    {
      $set: {
        'channels.inApp.readAt': new Date(),
      },
    }
  );
};

// Instance method to mark as read
notificationSchema.methods.markAsRead = async function () {
  if (!this.channels.inApp.readAt) {
    this.channels.inApp.readAt = new Date();
    await this.save();
  }
  return this;
};

const Notification = mongoose.model('Notification', notificationSchema);

module.exports = Notification;
