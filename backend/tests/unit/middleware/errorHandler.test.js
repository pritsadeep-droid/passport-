const mongoose = require('mongoose');
const {
  ApiError,
  notFoundHandler,
  errorHandler,
  asyncHandler,
} = require('../../../src/middleware/errorHandler');

// Mock logger to prevent console output during tests
jest.mock('../../../src/utils/logger', () => ({
  error: jest.fn(),
  warn: jest.fn(),
  info: jest.fn(),
}));

describe('Error Handler Middleware', () => {
  let mockReq, mockRes, mockNext;

  beforeEach(() => {
    mockReq = {
      method: 'GET',
      originalUrl: '/api/v1/test',
      path: '/api/v1/test',
      userId: 'user123',
    };

    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };

    mockNext = jest.fn();

    // Reset environment
    process.env.NODE_ENV = 'production';
  });

  describe('ApiError class', () => {
    it('should create error with statusCode and message', () => {
      const error = new ApiError(400, 'Bad Request');

      expect(error.statusCode).toBe(400);
      expect(error.message).toBe('Bad Request');
      expect(error.isOperational).toBe(true);
      expect(error instanceof Error).toBe(true);
    });

    it('should create error with details', () => {
      const details = { field: 'email', issue: 'invalid format' };
      const error = new ApiError(400, 'Validation Error', details);

      expect(error.details).toEqual(details);
    });

    it('should have stack trace', () => {
      const error = new ApiError(500, 'Server Error');

      expect(error.stack).toBeDefined();
    });

    it('should default details to null', () => {
      const error = new ApiError(400, 'Error');

      expect(error.details).toBeNull();
    });
  });

  describe('notFoundHandler', () => {
    it('should create 404 error and call next', () => {
      notFoundHandler(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      const error = mockNext.mock.calls[0][0];
      expect(error).toBeInstanceOf(ApiError);
      expect(error.statusCode).toBe(404);
      expect(error.message).toBe('Route not found: GET /api/v1/test');
    });

    it('should include method and URL in error message', () => {
      mockReq.method = 'POST';
      mockReq.originalUrl = '/api/v1/users';

      notFoundHandler(mockReq, mockRes, mockNext);

      const error = mockNext.mock.calls[0][0];
      expect(error.message).toBe('Route not found: POST /api/v1/users');
    });
  });

  describe('errorHandler', () => {
    it('should handle ApiError', () => {
      const error = new ApiError(400, 'Bad Request');

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Bad Request',
        })
      );
    });

    it('should handle ApiError with details', () => {
      const details = { field: 'email' };
      const error = new ApiError(400, 'Validation Error', details);

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Validation Error',
          details: { field: 'email' },
        })
      );
    });

    it('should handle Mongoose ValidationError', () => {
      const error = new mongoose.Error.ValidationError();
      error.errors = {
        email: {
          path: 'email',
          message: 'Email is required',
        },
        name: {
          path: 'name',
          message: 'Name is required',
        },
      };

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Validation Error',
          details: [
            { field: 'email', message: 'Email is required' },
            { field: 'name', message: 'Name is required' },
          ],
        })
      );
    });

    it('should handle Mongoose CastError', () => {
      const error = new mongoose.Error.CastError('ObjectId', 'invalid-id', 'userId');

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Invalid userId: invalid-id',
        })
      );
    });

    it('should handle MongoDB duplicate key error', () => {
      const error = new Error('Duplicate key');
      error.code = 11000;
      error.keyPattern = { email: 1 };
      error.keyValue = { email: 'test@example.com' };

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(409);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Duplicate value for field: email',
          details: { field: 'email', value: 'test@example.com' },
        })
      );
    });

    it('should handle JsonWebTokenError', () => {
      const error = new Error('jwt malformed');
      error.name = 'JsonWebTokenError';

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Invalid token',
        })
      );
    });

    it('should handle TokenExpiredError', () => {
      const error = new Error('jwt expired');
      error.name = 'TokenExpiredError';

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Token has expired',
        })
      );
    });

    it('should handle MulterError', () => {
      const error = new Error('File too large');
      error.name = 'MulterError';

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'File too large',
        })
      );
    });

    it('should default to 500 for unknown errors', () => {
      const error = new Error('Unknown error');

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Unknown error',
        })
      );
    });

    it('should include stack trace in development mode', () => {
      process.env.NODE_ENV = 'development';
      const error = new Error('Dev error');

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          stack: expect.any(String),
        })
      );
    });

    it('should not include stack trace in production mode', () => {
      process.env.NODE_ENV = 'production';
      const error = new Error('Prod error');

      errorHandler(error, mockReq, mockRes, mockNext);

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.stack).toBeUndefined();
    });
  });

  describe('asyncHandler', () => {
    it('should call the wrapped function', async () => {
      const mockFn = jest.fn().mockResolvedValue('result');
      const handler = asyncHandler(mockFn);

      await handler(mockReq, mockRes, mockNext);

      expect(mockFn).toHaveBeenCalledWith(mockReq, mockRes, mockNext);
    });

    it('should pass errors to next', async () => {
      const error = new Error('Async error');
      const mockFn = jest.fn().mockRejectedValue(error);
      const handler = asyncHandler(mockFn);

      await handler(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalledWith(error);
    });

    it('should not call next for successful operations', async () => {
      const mockFn = jest.fn().mockResolvedValue('success');
      const handler = asyncHandler(mockFn);

      await handler(mockReq, mockRes, mockNext);

      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should work with synchronous functions', async () => {
      const mockFn = jest.fn().mockReturnValue('sync result');
      const handler = asyncHandler(mockFn);

      await handler(mockReq, mockRes, mockNext);

      expect(mockFn).toHaveBeenCalled();
    });

    it('should catch errors from rejected promises', async () => {
      const error = new Error('Async rejection');
      const mockFn = jest.fn().mockImplementation(() => Promise.reject(error));
      const handler = asyncHandler(mockFn);

      await handler(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalledWith(error);
    });
  });
});
