const { validationResult, body, param, query } = require('express-validator');
const { errorResponse } = require('../utils/response');

/**
 * Sanitize string to prevent XSS
 * Escapes HTML special characters
 */
const escapeHtml = (str) => {
  if (typeof str !== 'string') return str;
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/\//g, '&#x2F;');
};

/**
 * Recursively sanitize object values
 */
const sanitizeObject = (obj) => {
  if (obj === null || obj === undefined) return obj;
  if (typeof obj === 'string') return escapeHtml(obj);
  if (Array.isArray(obj)) return obj.map(sanitizeObject);
  if (typeof obj === 'object') {
    const sanitized = {};
    for (const [key, value] of Object.entries(obj)) {
      sanitized[key] = sanitizeObject(value);
    }
    return sanitized;
  }
  return obj;
};

/**
 * Middleware to sanitize request body
 */
const sanitizeInput = (req, res, next) => {
  if (req.body) {
    req.body = sanitizeObject(req.body);
  }
  next();
};

/**
 * Middleware to handle validation results
 */
const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    const formattedErrors = errors.array().map((error) => ({
      field: error.path,
      message: error.msg,
      value: error.value,
    }));

    return errorResponse(res, 400, 'Validation failed', {
      errors: formattedErrors,
    });
  }

  next();
};

/**
 * Create a validation chain and automatically add error handling
 * @param {Array} validations - Array of express-validator validations
 */
const validate = (validations) => {
  return [...validations, handleValidationErrors];
};

// Common validation rules
const commonValidations = {
  // MongoDB ObjectId validation
  objectId: (field, location = 'param') => {
    const validator = location === 'param' ? param(field) : body(field);
    return validator
      .notEmpty()
      .withMessage(`${field} is required`)
      .isMongoId()
      .withMessage(`${field} must be a valid ID`);
  },

  // Email validation
  email: (field = 'email') =>
    body(field)
      .trim()
      .notEmpty()
      .withMessage('Email is required')
      .isEmail()
      .withMessage('Please provide a valid email')
      .normalizeEmail(),

  // Password validation
  password: (field = 'password') =>
    body(field)
      .notEmpty()
      .withMessage('Password is required')
      .isLength({ min: 8 })
      .withMessage('Password must be at least 8 characters long'),

  // String validation with length
  string: (field, options = {}) => {
    const { required = true, min = 1, max = 255 } = options;
    let validator = body(field).trim();

    if (required) {
      validator = validator.notEmpty().withMessage(`${field} is required`);
    } else {
      validator = validator.optional();
    }

    return validator
      .isLength({ min, max })
      .withMessage(`${field} must be between ${min} and ${max} characters`);
  },

  // Number validation
  number: (field, options = {}) => {
    const { required = true, min, max, isInt = false } = options;
    let validator = body(field);

    if (required) {
      validator = validator.notEmpty().withMessage(`${field} is required`);
    } else {
      validator = validator.optional();
    }

    if (isInt) {
      validator = validator.isInt().withMessage(`${field} must be an integer`);
    } else {
      validator = validator
        .isNumeric()
        .withMessage(`${field} must be a number`);
    }

    if (min !== undefined) {
      validator = validator
        .custom((value) => value >= min)
        .withMessage(`${field} must be at least ${min}`);
    }

    if (max !== undefined) {
      validator = validator
        .custom((value) => value <= max)
        .withMessage(`${field} must be at most ${max}`);
    }

    return validator;
  },

  // Date validation
  date: (field, options = {}) => {
    const { required = true } = options;
    let validator = body(field);

    if (required) {
      validator = validator.notEmpty().withMessage(`${field} is required`);
    } else {
      validator = validator.optional();
    }

    return validator.isISO8601().withMessage(`${field} must be a valid date`);
  },

  // Enum validation
  enum: (field, allowedValues, options = {}) => {
    const { required = true } = options;
    let validator = body(field);

    if (required) {
      validator = validator.notEmpty().withMessage(`${field} is required`);
    } else {
      validator = validator.optional();
    }

    return validator
      .isIn(allowedValues)
      .withMessage(`${field} must be one of: ${allowedValues.join(', ')}`);
  },

  // Array validation
  array: (field, options = {}) => {
    const { required = true, minLength, maxLength } = options;
    let validator = body(field);

    if (required) {
      validator = validator.notEmpty().withMessage(`${field} is required`);
    } else {
      validator = validator.optional();
    }

    validator = validator.isArray().withMessage(`${field} must be an array`);

    if (minLength !== undefined) {
      validator = validator
        .custom((value) => value.length >= minLength)
        .withMessage(`${field} must have at least ${minLength} items`);
    }

    if (maxLength !== undefined) {
      validator = validator
        .custom((value) => value.length <= maxLength)
        .withMessage(`${field} must have at most ${maxLength} items`);
    }

    return validator;
  },

  // Boolean validation
  boolean: (field, options = {}) => {
    const { required = true } = options;
    let validator = body(field);

    if (required) {
      validator = validator.notEmpty().withMessage(`${field} is required`);
    } else {
      validator = validator.optional();
    }

    return validator
      .isBoolean()
      .withMessage(`${field} must be a boolean value`);
  },

  // Pagination query params
  pagination: () => [
    query('page')
      .optional()
      .isInt({ min: 1 })
      .withMessage('Page must be a positive integer')
      .toInt(),
    query('limit')
      .optional()
      .isInt({ min: 1, max: 100 })
      .withMessage('Limit must be between 1 and 100')
      .toInt(),
  ],

  // Score validation (1-5)
  score: (field) =>
    body(field)
      .notEmpty()
      .withMessage(`${field} is required`)
      .isInt({ min: 1, max: 5 })
      .withMessage(`${field} must be an integer between 1 and 5`),
};

module.exports = {
  validate,
  handleValidationErrors,
  commonValidations,
  sanitizeInput,
  escapeHtml,
  body,
  param,
  query,
};
