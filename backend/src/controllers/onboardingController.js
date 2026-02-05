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
        return next(new AppError(400, 'Employee already has an active onboarding process'));
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
        return next(new AppError(404, 'No active onboarding found'));
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
        return next(new AppError(404, 'Onboarding not found'));
    }

    // Auth check
    const isOwner = instance.employeeId._id.toString() === req.user.id;
    const isSupervisor = instance.employeeId.supervisorId?.toString() === req.user.id;
    const isAdmin = req.user.role === 'hr_admin';

    if (!isOwner && !isSupervisor && !isAdmin) {
        return next(new AppError(403, 'You do not have permission to view this'));
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
        return next(new AppError(404, 'No active onboarding found'));
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
        return next(new AppError(404, 'Onboarding instance not found'));
    }

    // Check if supervisor
    if (instance.employeeId.supervisorId.toString() !== req.user.id && req.user.role !== 'hr_admin') {
        return next(new AppError(403, 'Not authorized to review this employee'));
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

exports.completeEvent = catchAsync(async (req, res, next) => {
    const { eventCode, notes } = req.body;
    const instanceId = req.params.id;

    const instance = await OnboardingInstance.findById(instanceId)
        .populate('employeeId', 'supervisorId')
        .populate('templateId');

    if (!instance) {
        return next(new AppError(404, 'Onboarding instance not found'));
    }

    // Auth: only supervisor or HR admin
    const isSupervisor = instance.employeeId.supervisorId?.toString() === req.user.id;
    const isAdmin = req.user.role === 'hr_admin';
    if (!isSupervisor && !isAdmin) {
        return next(new AppError(403, 'Not authorized to complete events'));
    }

    // Validate event code exists in template
    const event = instance.templateId.events.find(e => e.code === eventCode);
    if (!event) {
        return next(new AppError(400, 'Invalid event code'));
    }

    // Check if already completed
    const alreadyCompleted = instance.eventCompletions.find(ec => ec.eventCode === eventCode);
    if (alreadyCompleted) {
        return next(new AppError(400, 'Event already completed'));
    }

    instance.eventCompletions.push({
        eventCode,
        completedAt: new Date(),
        completedBy: req.user.id,
        notes,
    });

    await instance.save();

    res.status(200).json({
        status: 'success',
        data: instance,
    });
});

exports.getJourney = catchAsync(async (req, res, next) => {
    const instanceId = req.params.id;

    const instance = await OnboardingInstance.findById(instanceId)
        .populate('templateId')
        .populate('employeeId', 'name email department position supervisorId')
        .populate('eventCompletions.completedBy', 'name')
        .populate('reviews.reviewedBy', 'name');

    if (!instance) {
        return next(new AppError(404, 'Onboarding instance not found'));
    }

    // Auth check
    const isOwner = instance.employeeId._id.toString() === req.user.id;
    const isSupervisor = instance.employeeId.supervisorId?.toString() === req.user.id;
    const isAdmin = req.user.role === 'hr_admin';

    if (!isOwner && !isSupervisor && !isAdmin) {
        return next(new AppError(403, 'You do not have permission to view this'));
    }

    // Build combined journey timeline
    const template = instance.templateId;
    const startDate = instance.startDate;
    const now = new Date();

    // Map events
    const eventItems = (template.events || []).map(event => {
        const completion = instance.eventCompletions.find(ec => ec.eventCode === event.code);
        const eventDate = new Date(startDate);
        eventDate.setDate(eventDate.getDate() + event.day);

        return {
            type: 'event',
            code: event.code,
            title: event.title,
            titleTh: event.titleTh,
            description: event.description,
            eventType: event.type,
            day: event.day,
            date: eventDate,
            duration: event.duration,
            isLinkedToMilestone: event.isLinkedToMilestone,
            milestoneDay: event.milestoneDay,
            completed: !!completion,
            completedAt: completion?.completedAt,
            completedBy: completion?.completedBy,
            notes: completion?.notes,
            sortOrder: event.sortOrder,
        };
    });

    // Map missions
    const missionItems = template.missions.map(mission => {
        const review = instance.reviews.find(r => r.missionCode === mission.code);
        const openDate = new Date(startDate);
        openDate.setDate(openDate.getDate() + mission.openOffsetDays);

        let status = 'locked';
        if (review) {
            status = review.decision; // pass, fail, revision_required
        } else if (now >= openDate) {
            // Check if any answers submitted for this mission
            const missionQuestions = template.questions.filter(q => q.missionCode === mission.code);
            const answeredQuestions = missionQuestions.filter(q =>
                instance.answers.some(a => a.questionId.toString() === q._id.toString())
            );
            status = answeredQuestions.length > 0 ? 'in_progress' : 'open';
        }

        return {
            type: 'mission',
            code: mission.code,
            title: mission.title,
            description: mission.description,
            day: mission.openOffsetDays,
            date: openDate,
            status,
            review: review || null,
        };
    });

    // Combine and sort by day
    const timeline = [...eventItems, ...missionItems].sort((a, b) => {
        if (a.day !== b.day) return a.day - b.day;
        // Events before missions on same day
        if (a.type === 'event' && b.type === 'mission') return -1;
        if (a.type === 'mission' && b.type === 'event') return 1;
        return (a.sortOrder || 0) - (b.sortOrder || 0);
    });

    res.status(200).json({
        status: 'success',
        data: {
            instance,
            timeline,
        },
    });
});

exports.updateTemplate = catchAsync(async (req, res, next) => {
    const template = await OnboardingTemplate.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true, runValidators: true }
    );

    if (!template) {
        return next(new AppError(404, 'Template not found'));
    }

    res.status(200).json({
        status: 'success',
        data: template,
    });
});
