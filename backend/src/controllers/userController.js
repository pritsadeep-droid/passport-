const User = require('../models/User');
const AuditLog = require('../models/AuditLog');
const { asyncHandler } = require('../middleware/errorHandler');
const {
  successResponse,
  errorResponse,
  notFoundResponse,
  paginatedResponse,
} = require('../utils/response');

/**
 * @desc    Get current user profile
 * @route   GET /api/v1/users/me
 * @access  Private
 */
const getMe = asyncHandler(async (req, res) => {
  const user = await User.findById(req.userId).populate('supervisorId', 'name email');

  if (!user) {
    return notFoundResponse(res, 'User not found');
  }

  return successResponse(res, 200, 'Success', user);
});

/**
 * @desc    Update current user profile
 * @route   PATCH /api/v1/users/me
 * @access  Private
 */
const updateMe = asyncHandler(async (req, res) => {
  const allowedFields = ['name', 'department'];
  const updates = {};

  // Only allow certain fields to be updated
  for (const field of allowedFields) {
    if (req.body[field] !== undefined) {
      updates[field] = req.body[field];
    }
  }

  const user = await User.findByIdAndUpdate(
    req.userId,
    { $set: updates },
    { new: true, runValidators: true }
  );

  if (!user) {
    return notFoundResponse(res, 'User not found');
  }

  // Log profile update
  await AuditLog.log({
    action: 'user.profile_updated',
    userId: req.userId,
    targetType: 'user',
    targetId: user._id,
    changes: { after: updates },
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  return successResponse(res, 200, 'Profile updated', user);
});

/**
 * @desc    Register FCM token for push notifications
 * @route   POST /api/v1/users/me/fcm-token
 * @access  Private
 */
const registerFcmToken = asyncHandler(async (req, res) => {
  const { fcmToken } = req.body;

  if (!fcmToken) {
    return errorResponse(res, 400, 'FCM token is required');
  }

  const user = await User.findById(req.userId);

  if (!user) {
    return notFoundResponse(res, 'User not found');
  }

  // Add token if not already present
  if (!user.fcmTokens.includes(fcmToken)) {
    user.fcmTokens.push(fcmToken);
    // Keep only last 5 tokens
    if (user.fcmTokens.length > 5) {
      user.fcmTokens = user.fcmTokens.slice(-5);
    }
    await user.save();
  }

  return successResponse(res, 200, 'FCM token registered');
});

/**
 * @desc    Remove FCM token
 * @route   DELETE /api/v1/users/me/fcm-token
 * @access  Private
 */
const removeFcmToken = asyncHandler(async (req, res) => {
  const { fcmToken } = req.body;

  if (!fcmToken) {
    return errorResponse(res, 400, 'FCM token is required');
  }

  const user = await User.findById(req.userId);

  if (!user) {
    return notFoundResponse(res, 'User not found');
  }

  user.fcmTokens = user.fcmTokens.filter((token) => token !== fcmToken);
  await user.save();

  return successResponse(res, 200, 'FCM token removed');
});

/**
 * @desc    Get team members (for supervisor)
 * @route   GET /api/v1/users/team
 * @access  Private (Supervisor)
 */
const getTeamMembers = asyncHandler(async (req, res) => {
  const { page = 1, limit = 20 } = req.query;
  const skip = (page - 1) * limit;

  const query = {
    supervisorId: req.userId,
    isActive: true,
    role: 'employee',
  };

  const [users, total] = await Promise.all([
    User.find(query)
      .select('employeeId email name department createdAt')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit)),
    User.countDocuments(query),
  ]);

  return paginatedResponse(res, {
    data: users,
    page: parseInt(page),
    limit: parseInt(limit),
    total,
    message: 'Team members retrieved',
  });
});

/**
 * @desc    Get all users (for HR admin)
 * @route   GET /api/v1/users/all
 * @access  Private (HR Admin)
 */
const getAllUsers = asyncHandler(async (req, res) => {
  const {
    page = 1,
    limit = 20,
    role,
    department,
    isActive,
    search,
  } = req.query;
  const skip = (page - 1) * limit;

  const query = {};

  if (role) {
    query.role = role;
  }

  if (department) {
    query.department = department;
  }

  if (isActive !== undefined) {
    query.isActive = isActive === 'true';
  }

  if (search) {
    query.$or = [
      { name: { $regex: search, $options: 'i' } },
      { email: { $regex: search, $options: 'i' } },
      { employeeId: { $regex: search, $options: 'i' } },
    ];
  }

  const [users, total] = await Promise.all([
    User.find(query)
      .select('-fcmTokens')
      .populate('supervisorId', 'name email')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit)),
    User.countDocuments(query),
  ]);

  return paginatedResponse(res, {
    data: users,
    page: parseInt(page),
    limit: parseInt(limit),
    total,
    message: 'Users retrieved',
  });
});

/**
 * @desc    Get user by ID
 * @route   GET /api/v1/users/:id
 * @access  Private (HR Admin or Supervisor of user)
 */
const getUserById = asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id)
    .select('-fcmTokens')
    .populate('supervisorId', 'name email');

  if (!user) {
    return notFoundResponse(res, 'User not found');
  }

  // Check authorization
  const isHrAdmin = req.user.role === 'hr_admin';
  const isSupervisor =
    user.supervisorId &&
    user.supervisorId._id.toString() === req.userId.toString();
  const isSelf = user._id.toString() === req.userId.toString();

  if (!isHrAdmin && !isSupervisor && !isSelf) {
    return errorResponse(res, 403, 'Not authorized to view this user');
  }

  return successResponse(res, 200, 'Success', user);
});

/**
 * @desc    Create new user (HR Admin only)
 * @route   POST /api/v1/users
 * @access  Private (HR Admin)
 */
const createUser = asyncHandler(async (req, res) => {
  const { employeeId, email, password, name, role, department, supervisorId } =
    req.body;

  // Check if user already exists
  const existingUser = await User.findOne({
    $or: [{ email }, { employeeId }],
  });

  if (existingUser) {
    const field =
      existingUser.email === email ? 'อีเมล' : 'รหัสพนักงาน';
    return errorResponse(res, 409, `${field}นี้มีอยู่ในระบบแล้ว`);
  }

  // Validate supervisor if provided
  if (supervisorId) {
    const supervisor = await User.findById(supervisorId);
    if (!supervisor) {
      return errorResponse(res, 400, 'หัวหน้างานไม่พบในระบบ');
    }
    if (supervisor.role !== 'supervisor' && supervisor.role !== 'hr_admin') {
      return errorResponse(res, 400, 'หัวหน้างานต้องมี role เป็น supervisor หรือ hr_admin');
    }
  }

  const user = await User.create({
    employeeId,
    email,
    password,
    name,
    role,
    department,
    supervisorId,
  });

  // Log user creation
  await AuditLog.log({
    action: 'user.created',
    userId: req.userId,
    targetType: 'user',
    targetId: user._id,
    changes: { after: { employeeId, email, name, role, department } },
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  return successResponse(res, 201, 'สร้างผู้ใช้สำเร็จ', user);
});

/**
 * @desc    Update user (HR Admin only)
 * @route   PATCH /api/v1/users/:id
 * @access  Private (HR Admin)
 */
const updateUser = asyncHandler(async (req, res) => {
  const { name, role, department, supervisorId, isActive } = req.body;

  const user = await User.findById(req.params.id);

  if (!user) {
    return notFoundResponse(res, 'User not found');
  }

  // Store old values for audit log
  const oldValues = {
    name: user.name,
    role: user.role,
    department: user.department,
    supervisorId: user.supervisorId,
    isActive: user.isActive,
  };

  // Validate supervisorId if provided
  if (supervisorId !== undefined && supervisorId !== null) {
    const supervisor = await User.findById(supervisorId);
    if (!supervisor) {
      return errorResponse(res, 400, 'ไม่พบหัวหน้างานที่ระบุ');
    }
    if (!['supervisor', 'hr_admin'].includes(supervisor.role)) {
      return errorResponse(res, 400, 'ผู้ใช้ที่เลือกไม่ใช่หัวหน้างานหรือ HR Admin');
    }
    if (!supervisor.isActive) {
      return errorResponse(res, 400, 'หัวหน้างานที่เลือกถูกระงับการใช้งาน');
    }
  }

  // Update fields
  if (name !== undefined) {user.name = name;}
  if (role !== undefined) {user.role = role;}
  if (department !== undefined) {user.department = department;}
  if (supervisorId !== undefined) {user.supervisorId = supervisorId;}
  if (isActive !== undefined) {user.isActive = isActive;}

  await user.save();

  // Log update
  await AuditLog.log({
    action: 'user.updated',
    userId: req.userId,
    targetType: 'user',
    targetId: user._id,
    changes: {
      before: oldValues,
      after: { name, role, department, supervisorId, isActive },
    },
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  return successResponse(res, 200, 'อัปเดตผู้ใช้สำเร็จ', user);
});

/**
 * @desc    Get list of supervisors
 * @route   GET /api/v1/users/supervisors
 * @access  Private (HR Admin)
 */
const getSupervisors = asyncHandler(async (req, res) => {
  const supervisors = await User.find({
    role: { $in: ['supervisor', 'hr_admin'] },
    isActive: true,
  })
    .select('employeeId email name department')
    .sort({ name: 1 });

  return successResponse(res, 200, 'Supervisors retrieved', supervisors);
});

module.exports = {
  getMe,
  updateMe,
  registerFcmToken,
  removeFcmToken,
  getTeamMembers,
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  getSupervisors,
};
