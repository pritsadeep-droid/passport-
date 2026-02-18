/**
 * Rate Limiting Middleware
 * Protects API endpoints from abuse
 */

const rateLimit = require('express-rate-limit');
const logger = require('../utils/logger');

/**
 * Default rate limiter for general API endpoints
 * 100 requests per 15 minutes per IP
 */
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 300,
  message: {
    success: false,
    error: {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests, please try again later',
      messageTh: 'มีการเรียกใช้งานมากเกินไป กรุณาลองใหม่อีกครั้งภายหลัง'
    }
  },
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res, next, options) => {
    logger.warn('Rate limit exceeded', {
      ip: req.ip,
      path: req.path,
      method: req.method,
      userAgent: req.get('User-Agent')
    });
    res.status(429).json(options.message);
  }
});

/**
 * Strict rate limiter for auth endpoints
 * 5 requests per 15 minutes per IP (for login, password reset, etc.)
 */
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5,
  message: {
    success: false,
    error: {
      code: 'AUTH_RATE_LIMIT_EXCEEDED',
      message: 'Too many authentication attempts, please try again later',
      messageTh: 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่อีกครั้งภายหลัง'
    }
  },
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Don't count successful logins
  handler: (req, res, next, options) => {
    logger.warn('Auth rate limit exceeded', {
      ip: req.ip,
      path: req.path,
      email: req.body?.email || 'unknown'
    });
    res.status(429).json(options.message);
  }
});

/**
 * Relaxed rate limiter for read-heavy endpoints
 * 200 requests per 15 minutes per IP
 */
const readLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 200,
  message: {
    success: false,
    error: {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests, please try again later',
      messageTh: 'มีการเรียกใช้งานมากเกินไป กรุณาลองใหม่อีกครั้งภายหลัง'
    }
  },
  standardHeaders: true,
  legacyHeaders: false
});

/**
 * Report generation rate limiter
 * 10 requests per hour per IP (reports are expensive)
 */
const reportLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 10,
  message: {
    success: false,
    error: {
      code: 'REPORT_RATE_LIMIT_EXCEEDED',
      message: 'Too many report requests, please try again later',
      messageTh: 'มีการสร้างรายงานมากเกินไป กรุณาลองใหม่อีกครั้งภายหลัง'
    }
  },
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res, next, options) => {
    logger.warn('Report rate limit exceeded', {
      ip: req.ip,
      userId: req.user?._id
    });
    res.status(429).json(options.message);
  }
});

/**
 * Create custom rate limiter with specific configuration
 */
const createRateLimiter = (options) => {
  const defaultOptions = {
    windowMs: 15 * 60 * 1000,
    max: 100,
    standardHeaders: true,
    legacyHeaders: false,
    message: {
      success: false,
      error: {
        code: 'RATE_LIMIT_EXCEEDED',
        message: 'Too many requests, please try again later'
      }
    }
  };

  return rateLimit({ ...defaultOptions, ...options });
};

module.exports = {
  apiLimiter,
  authLimiter,
  readLimiter,
  reportLimiter,
  createRateLimiter
};
