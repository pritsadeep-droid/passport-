const mongoose = require('mongoose');

const settingsSchema = new mongoose.Schema(
  {
    defaultProbationDays: {
      type: Number,
      default: 90,
    },
    probationDayOptions: {
      type: [Number],
      default: [90, 119],
    },
    milestoneDays: {
      type: Map,
      of: [Number],
      default: {
        '90': [30, 60, 90],
        '119': [30, 60, 90, 119],
      },
    },
    updatedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
  },
  {
    timestamps: true,
  }
);

/**
 * Get the singleton settings document.
 * Creates one with defaults if none exists.
 */
settingsSchema.statics.getSettings = async function () {
  let settings = await this.findOne();
  if (!settings) {
    settings = await this.create({});
  }
  return settings;
};

const Settings = mongoose.model('Settings', settingsSchema);

module.exports = Settings;
