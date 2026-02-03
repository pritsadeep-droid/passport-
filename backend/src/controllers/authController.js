const User = require('../models/User');
const AuditLog = require('../models/AuditLog');
const {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
} = require('../middleware/auth');
const { asyncHandler } = require('../middleware/errorHandler');
const {
  successResponse,
  errorResponse,
  unauthorizedResponse,
} = require('../utils/response');
const logger = require('../utils/logger');

/**
 * @desc    Login user
 * @route   POST /api/v1/auth/login
 * @access  Public
 */
const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  // Find user by email and include password for comparison
  const user = await User.findOne({ email }).select('+password');

  if (!user) {
    return unauthorizedResponse(res, 'อีเมลหรือรหัสผ่านไม่ถูกต้อง');
  }

  if (!user.isActive) {
    return unauthorizedResponse(res, 'บัญชีผู้ใช้ถูกระงับ');
  }

  // Check password
  const isPasswordValid = await user.comparePassword(password);

  if (!isPasswordValid) {
    return unauthorizedResponse(res, 'อีเมลหรือรหัสผ่านไม่ถูกต้อง');
  }

  // Generate tokens
  const accessToken = generateAccessToken(user._id);
  const refreshToken = generateRefreshToken(user._id);

  // Save refresh token to user
  user.refreshToken = refreshToken;
  await user.save();

  // Log successful login
  await AuditLog.log({
    action: 'auth.login',
    userId: user._id,
    targetType: 'user',
    targetId: user._id,
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  logger.info(`User logged in: ${user.email}`);

  return successResponse(res, 200, 'เข้าสู่ระบบสำเร็จ', {
    accessToken,
    refreshToken,
    user: user.toJSON(),
  });
});

/**
 * @desc    Refresh access token
 * @route   POST /api/v1/auth/refresh
 * @access  Public
 */
const refresh = asyncHandler(async (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return errorResponse(res, 400, 'Refresh token is required');
  }

  try {
    // Verify refresh token
    const decoded = verifyRefreshToken(refreshToken);

    // Find user
    const user = await User.findById(decoded.userId).select('+refreshToken');

    if (!user) {
      return unauthorizedResponse(res, 'User not found');
    }

    if (!user.isActive) {
      return unauthorizedResponse(res, 'User account is deactivated');
    }

    // Verify stored refresh token matches
    if (user.refreshToken !== refreshToken) {
      return unauthorizedResponse(res, 'Invalid refresh token');
    }

    // Generate new tokens
    const newAccessToken = generateAccessToken(user._id);
    const newRefreshToken = generateRefreshToken(user._id);

    // Update stored refresh token
    user.refreshToken = newRefreshToken;
    await user.save();

    return successResponse(res, 200, 'Token refreshed', {
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    });
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return unauthorizedResponse(res, 'Refresh token has expired');
    }
    return unauthorizedResponse(res, 'Invalid refresh token');
  }
});

/**
 * @desc    Logout user
 * @route   POST /api/v1/auth/logout
 * @access  Private
 */
const logout = asyncHandler(async (req, res) => {
  // Clear refresh token from user
  const user = await User.findById(req.userId);

  if (user) {
    user.refreshToken = null;
    await user.save();

    // Log logout
    await AuditLog.log({
      action: 'auth.logout',
      userId: user._id,
      targetType: 'user',
      targetId: user._id,
      ip: req.ip,
      userAgent: req.headers['user-agent'],
    });

    logger.info(`User logged out: ${user.email}`);
  }

  return successResponse(res, 200, 'ออกจากระบบสำเร็จ');
});

/**
 * @desc    Change password
 * @route   POST /api/v1/auth/change-password
 * @access  Private
 */
const changePassword = asyncHandler(async (req, res) => {
  const { currentPassword, newPassword } = req.body;

  // Get user with password
  const user = await User.findById(req.userId).select('+password');

  if (!user) {
    return errorResponse(res, 404, 'User not found');
  }

  // Verify current password
  const isPasswordValid = await user.comparePassword(currentPassword);

  if (!isPasswordValid) {
    return errorResponse(res, 400, 'รหัสผ่านปัจจุบันไม่ถูกต้อง');
  }

  // Update password
  user.password = newPassword;
  user.refreshToken = null; // Invalidate all sessions
  await user.save();

  // Log password change
  await AuditLog.log({
    action: 'auth.password_changed',
    userId: user._id,
    targetType: 'user',
    targetId: user._id,
    ip: req.ip,
    userAgent: req.headers['user-agent'],
  });

  logger.info(`Password changed for user: ${user.email}`);

  return successResponse(res, 200, 'เปลี่ยนรหัสผ่านสำเร็จ กรุณาเข้าสู่ระบบใหม่');
});

module.exports = {
  login,
  refresh,
  logout,
  changePassword,
};
