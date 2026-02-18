const Settings = require('../models/Settings');
const { asyncHandler } = require('../middleware/errorHandler');
const { successResponse, errorResponse } = require('../utils/response');

/**
 * Get current settings
 * GET /api/v1/settings
 */
const getSettings = asyncHandler(async (req, res) => {
  const settings = await Settings.getSettings();

  // Convert milestoneDays Map to plain object for JSON response
  const data = {
    defaultProbationDays: settings.defaultProbationDays,
    probationDayOptions: settings.probationDayOptions,
    milestoneDays: Object.fromEntries(settings.milestoneDays),
    updatedAt: settings.updatedAt,
    updatedBy: settings.updatedBy,
  };

  return successResponse(res, 200, 'Settings retrieved successfully', data);
});

/**
 * Update milestone settings
 * PUT /api/v1/settings/milestones
 */
const updateMilestoneSettings = asyncHandler(async (req, res) => {
  const { defaultProbationDays, probationDayOptions, milestoneDays } = req.body;

  const settings = await Settings.getSettings();

  if (probationDayOptions !== undefined) {
    if (!Array.isArray(probationDayOptions) || probationDayOptions.length === 0) {
      return errorResponse(res, 400, 'probationDayOptions must be a non-empty array of numbers');
    }
    for (const opt of probationDayOptions) {
      if (typeof opt !== 'number' || opt <= 0) {
        return errorResponse(res, 400, 'Each probation day option must be a positive number');
      }
    }
    settings.probationDayOptions = probationDayOptions;
  }

  if (defaultProbationDays !== undefined) {
    if (!settings.probationDayOptions.includes(defaultProbationDays)) {
      return errorResponse(
        res,
        400,
        'defaultProbationDays must be one of the probationDayOptions'
      );
    }
    settings.defaultProbationDays = defaultProbationDays;
  }

  if (milestoneDays !== undefined) {
    if (typeof milestoneDays !== 'object' || milestoneDays === null) {
      return errorResponse(res, 400, 'milestoneDays must be an object');
    }
    // Validate each key is a probation day option, each value is a non-empty array of positive numbers
    for (const [key, days] of Object.entries(milestoneDays)) {
      if (!settings.probationDayOptions.includes(Number(key))) {
        return errorResponse(
          res,
          400,
          `milestoneDays key "${key}" is not in probationDayOptions`
        );
      }
      if (!Array.isArray(days) || days.length === 0) {
        return errorResponse(
          res,
          400,
          `milestoneDays["${key}"] must be a non-empty array of numbers`
        );
      }
      for (const d of days) {
        if (typeof d !== 'number' || d <= 0) {
          return errorResponse(
            res,
            400,
            `Each milestone day in "${key}" must be a positive number`
          );
        }
      }
    }
    settings.milestoneDays = new Map(Object.entries(milestoneDays));
  }

  settings.updatedBy = req.userId;
  await settings.save();

  const data = {
    defaultProbationDays: settings.defaultProbationDays,
    probationDayOptions: settings.probationDayOptions,
    milestoneDays: Object.fromEntries(settings.milestoneDays),
    updatedAt: settings.updatedAt,
    updatedBy: settings.updatedBy,
  };

  return successResponse(res, 200, 'Milestone settings updated successfully', data);
});

module.exports = {
  getSettings,
  updateMilestoneSettings,
};
