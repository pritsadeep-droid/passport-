const mongoose = require('mongoose');

const kpiTemplateSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
      maxlength: [200, 'Title must not exceed 200 characters'],
    },
    description: {
      type: String,
      required: [true, 'Description is required'],
      trim: true,
      maxlength: [1000, 'Description must not exceed 1000 characters'],
    },
    criteria: {
      type: String,
      required: [true, 'Criteria is required'],
      trim: true,
      maxlength: [500, 'Criteria must not exceed 500 characters'],
    },
    category: {
      type: String,
      trim: true,
      maxlength: [100, 'Category must not exceed 100 characters'],
      default: null,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },
    updatedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

kpiTemplateSchema.index({ isActive: 1 });
kpiTemplateSchema.index({ category: 1, isActive: 1 });

const KpiTemplate = mongoose.model('KpiTemplate', kpiTemplateSchema);

module.exports = KpiTemplate;
