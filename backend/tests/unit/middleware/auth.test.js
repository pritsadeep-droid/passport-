const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const User = require('../../../src/models/User');
const {
  authenticate,
  optionalAuth,
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
} = require('../../../src/middleware/auth');

// Set test environment variables
process.env.JWT_SECRET = 'test-jwt-secret';
process.env.JWT_REFRESH_SECRET = 'test-jwt-refresh-secret';
process.env.JWT_EXPIRES_IN = '15m';
process.env.JWT_REFRESH_EXPIRES_IN = '7d';

describe('Auth Middleware', () => {
  let mockReq, mockRes, mockNext;
  let testUser;

  beforeEach(async () => {
    // Create test user
    testUser = await User.create({
      employeeId: 'EMP001',
      email: 'test@example.com',
      password: 'password123',
      name: 'Test User',
      department: 'Engineering',
    });

    mockReq = {
      headers: {},
    };

    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };

    mockNext = jest.fn();
  });

  describe('generateAccessToken', () => {
    it('should generate a valid JWT access token', () => {
      const userId = new mongoose.Types.ObjectId();
      const token = generateAccessToken(userId);

      expect(token).toBeDefined();
      expect(typeof token).toBe('string');

      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      expect(decoded.userId.toString()).toBe(userId.toString());
    });

    it('should set expiration time', () => {
      const userId = new mongoose.Types.ObjectId();
      const token = generateAccessToken(userId);

      const decoded = jwt.decode(token);
      expect(decoded.exp).toBeDefined();
      expect(decoded.iat).toBeDefined();
    });
  });

  describe('generateRefreshToken', () => {
    it('should generate a valid JWT refresh token', () => {
      const userId = new mongoose.Types.ObjectId();
      const token = generateRefreshToken(userId);

      expect(token).toBeDefined();
      expect(typeof token).toBe('string');

      const decoded = jwt.verify(token, process.env.JWT_REFRESH_SECRET);
      expect(decoded.userId.toString()).toBe(userId.toString());
    });

    it('should use different secret than access token', () => {
      const userId = new mongoose.Types.ObjectId();
      const accessToken = generateAccessToken(userId);
      const refreshToken = generateRefreshToken(userId);

      // Refresh token should not verify with access token secret
      expect(() => jwt.verify(refreshToken, process.env.JWT_SECRET)).toThrow();
    });
  });

  describe('verifyRefreshToken', () => {
    it('should verify valid refresh token', () => {
      const userId = new mongoose.Types.ObjectId();
      const token = generateRefreshToken(userId);

      const decoded = verifyRefreshToken(token);
      expect(decoded.userId.toString()).toBe(userId.toString());
    });

    it('should throw error for invalid token', () => {
      expect(() => verifyRefreshToken('invalid-token')).toThrow();
    });

    it('should throw error for expired token', () => {
      const userId = new mongoose.Types.ObjectId();
      const token = jwt.sign({ userId }, process.env.JWT_REFRESH_SECRET, {
        expiresIn: '-1s',
      });

      expect(() => verifyRefreshToken(token)).toThrow();
    });
  });

  describe('authenticate middleware', () => {
    it('should return 401 if no authorization header', async () => {
      await authenticate(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Access denied. No token provided.',
        })
      );
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 401 if authorization header does not start with Bearer', async () => {
      mockReq.headers.authorization = 'Basic token123';

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Access denied. No token provided.',
        })
      );
    });

    it('should return 401 if token is empty after Bearer', async () => {
      mockReq.headers.authorization = 'Bearer ';

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
    });

    it('should return 401 for invalid token', async () => {
      mockReq.headers.authorization = 'Bearer invalid-token';

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Invalid token.',
        })
      );
    });

    it('should return 401 for expired token', async () => {
      const expiredToken = jwt.sign(
        { userId: testUser._id },
        process.env.JWT_SECRET,
        { expiresIn: '-1s' }
      );
      mockReq.headers.authorization = `Bearer ${expiredToken}`;

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Token has expired.',
        })
      );
    });

    it('should return 401 if user not found', async () => {
      const nonExistentUserId = new mongoose.Types.ObjectId();
      const token = generateAccessToken(nonExistentUserId);
      mockReq.headers.authorization = `Bearer ${token}`;

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'User not found.',
        })
      );
    });

    it('should return 401 if user is deactivated', async () => {
      await User.findByIdAndUpdate(testUser._id, { isActive: false });
      const token = generateAccessToken(testUser._id);
      mockReq.headers.authorization = `Bearer ${token}`;

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'User account is deactivated.',
        })
      );
    });

    it('should attach user to request and call next for valid token', async () => {
      const token = generateAccessToken(testUser._id);
      mockReq.headers.authorization = `Bearer ${token}`;

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(mockReq.user).toBeDefined();
      expect(mockReq.user._id.toString()).toBe(testUser._id.toString());
      expect(mockReq.userId.toString()).toBe(testUser._id.toString());
    });

    it('should not include password in attached user', async () => {
      const token = generateAccessToken(testUser._id);
      mockReq.headers.authorization = `Bearer ${token}`;

      await authenticate(mockReq, mockRes, mockNext);

      expect(mockReq.user.password).toBeUndefined();
    });
  });

  describe('optionalAuth middleware', () => {
    it('should call next without user if no authorization header', async () => {
      await optionalAuth(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(mockReq.user).toBeUndefined();
    });

    it('should call next without user if header does not start with Bearer', async () => {
      mockReq.headers.authorization = 'Basic token123';

      await optionalAuth(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(mockReq.user).toBeUndefined();
    });

    it('should call next without user for invalid token', async () => {
      mockReq.headers.authorization = 'Bearer invalid-token';

      await optionalAuth(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(mockReq.user).toBeUndefined();
    });

    it('should attach user for valid token', async () => {
      const token = generateAccessToken(testUser._id);
      mockReq.headers.authorization = `Bearer ${token}`;

      await optionalAuth(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(mockReq.user).toBeDefined();
      expect(mockReq.user._id.toString()).toBe(testUser._id.toString());
    });

    it('should call next without user if user is deactivated', async () => {
      await User.findByIdAndUpdate(testUser._id, { isActive: false });
      const token = generateAccessToken(testUser._id);
      mockReq.headers.authorization = `Bearer ${token}`;

      await optionalAuth(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(mockReq.user).toBeUndefined();
    });
  });
});
