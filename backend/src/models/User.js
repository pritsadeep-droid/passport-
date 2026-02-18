const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema(
  {
    employeeId: {
      type: String,
      required: [true, 'Employee ID is required'],
      unique: true,
      trim: true,
      index: true,
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
      trim: true,
      index: true,
    },
    password: {
      type: String,
      required: [true, 'Password is required'],
      minlength: 8,
      select: false,
    },
    name: {
      type: String,
      required: [true, 'Name is required'],
      trim: true,
    },
    role: {
      type: String,
      enum: ['employee', 'supervisor', 'hr_admin'],
      default: 'employee',
    },
    department: {
      type: String,
      required: [true, 'Department is required'],
      trim: true,
    },
    supervisorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    fcmTokens: {
      type: [String],
      default: [],
    },
    refreshToken: {
      type: String,
      select: false,
    },
  },
  {
    timestamps: true,
  }
);

// Indexes
userSchema.index({ supervisorId: 1 });
userSchema.index({ role: 1, isActive: 1 });

// Hash password before saving
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) {
    return next();
  }
  const salt = await bcrypt.genSalt(12);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// Compare password method
userSchema.methods.comparePassword = async function (candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

// Transform output (remove sensitive fields)
userSchema.methods.toJSON = function () {
  const obj = this.toObject();
  delete obj.password;
  delete obj.refreshToken;
  delete obj.__v;
  return obj;
};

// Cascade delete - clean up related records when user is deleted
userSchema.pre('deleteOne', { document: true, query: false }, async function () {
  const userId = this._id;

  // Lazy load models to avoid circular dependency
  const ProbationRecord = mongoose.model('ProbationRecord');
  const OnboardingInstance = mongoose.model('OnboardingInstance');
  const Notification = mongoose.model('Notification');

  // Delete probation records where user is the employee
  await ProbationRecord.deleteMany({ employeeId: userId });

  // Delete onboarding instances where user is the employee
  await OnboardingInstance.deleteMany({ employeeId: userId });

  // Delete notifications for this user
  await Notification.deleteMany({ userId: userId });

  // Update probation records where user was supervisor (set to null)
  await ProbationRecord.updateMany(
    { supervisorId: userId },
    { $set: { supervisorId: null } }
  );

  // Update users who had this user as supervisor
  await mongoose.model('User').updateMany(
    { supervisorId: userId },
    { $set: { supervisorId: null } }
  );
});

// Also handle findOneAndDelete
userSchema.pre('findOneAndDelete', async function () {
  const doc = await this.model.findOne(this.getFilter());
  if (doc) {
    const userId = doc._id;

    const ProbationRecord = mongoose.model('ProbationRecord');
    const OnboardingInstance = mongoose.model('OnboardingInstance');
    const Notification = mongoose.model('Notification');

    await ProbationRecord.deleteMany({ employeeId: userId });
    await OnboardingInstance.deleteMany({ employeeId: userId });
    await Notification.deleteMany({ userId: userId });
    await ProbationRecord.updateMany(
      { supervisorId: userId },
      { $set: { supervisorId: null } }
    );
    await mongoose.model('User').updateMany(
      { supervisorId: userId },
      { $set: { supervisorId: null } }
    );
  }
});

const User = mongoose.model('User', userSchema);

module.exports = User;
