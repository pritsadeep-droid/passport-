const OnboardingInstance = require('../models/OnboardingInstance');
const OnboardingTemplate = require('../models/OnboardingTemplate');
const User = require('../models/User');
const { AppError } = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');

// Helper checking if mission is open
const isMissionOpen = (template, missionCode, startDate) => {
    const mission = template.missions.find((m) => m.code === missionCode);
    if (!mission) return false;

    const now = new Date();
    const start = new Date(startDate);

    const openDate = new Date(start);
    openDate.setDate(openDate.getDate() + mission.openOffsetDays);

    const closeDate = new Date(openDate);
    closeDate.setDate(closeDate.getDate() + mission.closeOffsetDays);

    return now >= openDate && now <= closeDate;
};

exports.createTemplate = catchAsync(async (req, res, next) => {
    const template = await OnboardingTemplate.create(req.body);
    res.status(201).json({
        status: 'success',
        data: template,
    });
});

exports.getTemplates = catchAsync(async (req, res, next) => {
    const templates = await OnboardingTemplate.find();
    res.status(200).json({
        status: 'success',
        results: templates.length,
        data: templates,
    });
});

exports.assignOnboarding = catchAsync(async (req, res, next) => {
    const { employeeId, templateId, startDate } = req.body;

    // Check if already exists
    const existing = await OnboardingInstance.findOne({ employeeId, status: { $ne: 'archived' } });
    if (existing) {
        return next(new AppError('Employee already has an active onboarding process', 400));
    }

    const instance = await OnboardingInstance.create({
        employeeId,
        templateId,
        startDate: startDate || new Date(),
    });

    res.status(201).json({
        status: 'success',
        data: instance,
    });
});

exports.getMyOnboarding = catchAsync(async (req, res, next) => {
    const instance = await OnboardingInstance.findOne({
        employeeId: req.user.id,
        status: { $ne: 'archived' }
    })
        .populate('templateId')
        .populate('reviews.reviewedBy', 'name');

    if (!instance) {
        return next(new AppError('No active onboarding found', 404));
    }

    res.status(200).json({
        status: 'success',
        data: instance,
    });
});

exports.getTeamOnboarding = catchAsync(async (req, res, next) => {
    // Find employees supervised by current user
    const employees = await User.find({ supervisorId: req.user.id });
    const employeeIds = employees.map(e => e._id);

    const instances = await OnboardingInstance.find({
        employeeId: { $in: employeeIds },
        status: { $ne: 'archived' }
    })
        .populate('employeeId', 'name email department position')
        .populate('templateId', 'name');

    res.status(200).json({
        status: 'success',
        results: instances.length,
        data: instances,
    });
});

exports.getOnboardingById = catchAsync(async (req, res, next) => {
    // Check permission (Own, Supervisor, or Admin)
    const instance = await OnboardingInstance.findById(req.params.id)
        .populate('templateId')
        .populate('employeeId', 'name email department position supervisorId');

    if (!instance) {
        return next(new AppError('Onboarding not found', 404));
    }

    // Auth check
    const isOwner = instance.employeeId._id.toString() === req.user.id;
    const isSupervisor = instance.employeeId.supervisorId?.toString() === req.user.id;
    const isAdmin = req.user.role === 'hr_admin';

    if (!isOwner && !isSupervisor && !isAdmin) {
        return next(new AppError('You do not have permission to view this', 403));
    }

    res.status(200).json({
        status: 'success',
        data: instance,
    });
});

exports.submitAnswer = catchAsync(async (req, res, next) => {
    const { questionId, text, attachments } = req.body;

    const instance = await OnboardingInstance.findOne({
        employeeId: req.user.id,
        status: 'in_progress'
    });

    if (!instance) {
        return next(new AppError('No active onboarding found', 404));
    }

    // Optional: Check if mission is open (logic omitted for MVP simplicity, can be added later)

    // Update or push answer
    const existingIndex = instance.answers.findIndex(a => a.questionId.toString() === questionId);

    if (existingIndex > -1) {
        instance.answers[existingIndex].text = text;
        instance.answers[existingIndex].attachments = attachments || [];
        instance.answers[existingIndex].submittedAt = new Date();
    } else {
        instance.answers.push({
            questionId,
            text,
            attachments,
            submittedAt: new Date(),
        });
    }

    await instance.save();

    res.status(200).json({
        status: 'success',
        data: instance,
    });
});

exports.reviewMission = catchAsync(async (req, res, next) => {
    const { onboardingId, missionCode, score, decision, comment } = req.body;

    const instance = await OnboardingInstance.findById(onboardingId).populate('employeeId');

    if (!instance) {
        return next(new AppError('Onboarding instance not found', 404));
    }

    // Check if supervisor
    if (instance.employeeId.supervisorId.toString() !== req.user.id && req.user.role !== 'hr_admin') {
        return next(new AppError('Not authorized to review this employee', 403));
    }

    // Update or push review
    const existingIndex = instance.reviews.findIndex(r => r.missionCode === missionCode);

    if (existingIndex > -1) {
        instance.reviews[existingIndex].score = score;
        instance.reviews[existingIndex].decision = decision;
        instance.reviews[existingIndex].comment = comment;
        instance.reviews[existingIndex].reviewedBy = req.user.id;
        instance.reviews[existingIndex].reviewedAt = new Date();
    } else {
        instance.reviews.push({
            missionCode,
            score,
            decision,
            comment,
            reviewedBy: req.user.id,
            reviewedAt: new Date(),
        });
    }

    await instance.save();

    res.status(200).json({
        status: 'success',
        data: instance,
    });
});
