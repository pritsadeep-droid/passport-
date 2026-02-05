const mongoose = require('mongoose');

const answerSchema = new mongoose.Schema({
    questionId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
    },
    text: {
        type: String,
        trim: true,
    },
    attachments: [String], // URLs
    submittedAt: {
        type: Date,
        default: Date.now,
    },
});

const reviewSchema = new mongoose.Schema({
    missionCode: {
        type: String,
        required: true,
    },
    decision: {
        type: String,
        enum: ['pass', 'fail', 'revision_required'],
        required: true,
    },
    score: {
        type: Number, // 1-5 or 0-100
    },
    comment: {
        type: String,
        trim: true,
    },
    reviewedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
    },
    reviewedAt: {
        type: Date,
        default: Date.now,
    },
});

const eventCompletionSchema = new mongoose.Schema({
    eventCode: {
        type: String,
        required: true,
    },
    completedAt: {
        type: Date,
        default: Date.now,
    },
    completedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
    },
    notes: {
        type: String,
        trim: true,
    },
});

const onboardingInstanceSchema = new mongoose.Schema(
    {
        employeeId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true,
            index: true,
        },
        templateId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'OnboardingTemplate',
            required: true,
        },
        startDate: {
            type: Date,
            required: true,
        },
        status: {
            type: String,
            enum: ['in_progress', 'completed', 'archived'],
            default: 'in_progress',
        },
        // Track submitted answers
        answers: [answerSchema],
        // Track manager reviews
        reviews: [reviewSchema],
        // Track journey event completions
        eventCompletions: [eventCompletionSchema],
    },
    {
        timestamps: true,
    }
);

// Indexes
onboardingInstanceSchema.index({ employeeId: 1, status: 1 });

const OnboardingInstance = mongoose.model('OnboardingInstance', onboardingInstanceSchema);

module.exports = OnboardingInstance;
