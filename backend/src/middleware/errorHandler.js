const logger = require('../utils/logger');

/**
 * Custom API Error class
 */
class ApiError extends Error {
  constructor(statusCode, message, details = null) {
    super(message);
    this.statusCode = statusCode;
    this.details = details;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

/**
 * Not found error handler
 * Catches requests to undefined routes
 */
const notFoundHandler = (req, res, next) => {
  const error = new ApiError(404, `Route not found: ${req.method} ${req.originalUrl}`);
  next(error);
};

/**
 * Global error handler middleware
 */
const errorHandler = (err, req, res, next) => {
  let statusCode = err.statusCode || 500;
  let message = err.message || 'Internal Server Error';
  let details = err.details || null;

  // Handle specific error types
  if (err.name === 'ValidationError') {
    // Mongoose validation error
    statusCode = 400;
    message = 'Validation Error';
    details = Object.values(err.errors).map((e) => ({
      field: e.path,
      message: e.message,
    }));
  } else if (err.name === 'CastError') {
    // Mongoose cast error (invalid ObjectId)
    statusCode = 400;
    message = `Invalid ${err.path}: ${err.value}`;
  } else if (err.code === 11000) {
    // MongoDB duplicate key error
    statusCode = 409;
    const field = Object.keys(err.keyPattern)[0];
    message = `Duplicate value for field: ${field}`;
    details = { field, value: err.keyValue[field] };
  } else if (err.name === 'JsonWebTokenError') {
    statusCode = 401;
    message = 'Invalid token';
  } else if (err.name === 'TokenExpiredError') {
    statusCode = 401;
    message = 'Token has expired';
  } else if (err.name === 'MulterError') {
    // File upload error
    statusCode = 400;
    message = err.message;
  }

  // Log error
  if (statusCode >= 500) {
    logger.error('Server Error:', {
      message: err.message,
      stack: err.stack,
      statusCode,
      path: req.path,
      method: req.method,
      userId: req.userId,
    });
  } else {
    logger.warn('Client Error:', {
      message: err.message,
      statusCode,
      path: req.path,
      method: req.method,
      userId: req.userId,
    });
  }

  // Send response
  const response = {
    success: false,
    message,
    ...(details && { details }),
    ...(process.env.NODE_ENV === 'development' && {
      stack: err.stack,
    }),
  };

  res.status(statusCode).json(response);
};

/**
 * Async handler wrapper to catch errors in async route handlers
 */
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

module.exports = {
  ApiError,
  notFoundHandler,
  errorHandler,
  asyncHandler,
};
