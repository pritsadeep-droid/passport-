const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema({
  text: {
    type: String,
    required: true,
    trim: true,
  },
  type: {
    type: String,
    enum: ['text_short', 'text_long', 'rating', 'single_choice', 'file_upload'],
    default: 'text_long',
  },
  options: [String], // for choice types
  required: {
    type: Boolean,
    default: true,
  },
  missionCode: {
    type: String,
    required: true,
  },
  sortOrder: {
    type: Number,
    default: 0,
  },
});

const missionSchema = new mongoose.Schema({
  code: {
    type: String, // H, A, P, I, N, E, S
    required: true,
  },
  title: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    trim: true,
  },
  openOffsetDays: {
    type: Number,
    default: 0, // Days after start date
  },
  closeOffsetDays: {
    type: Number,
    default: 7, // Duration window
  },
});

const onboardingTemplateSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      unique: true,
    },
    description: {
      type: String,
      trim: true,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    missions: [missionSchema],
    questions: [questionSchema],
  },
  {
    timestamps: true,
  }
);

const OnboardingTemplate = mongoose.model('OnboardingTemplate', onboardingTemplateSchema);

module.exports = OnboardingTemplate;
