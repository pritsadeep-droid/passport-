/**
 * Standard success response
 * @param {Object} res - Express response object
 * @param {number} statusCode - HTTP status code
 * @param {string} message - Success message
 * @param {Object} data - Response data
 */
const successResponse = (res, statusCode = 200, message = 'Success', data = null) => {
  const response = {
    success: true,
    message,
  };

  if (data !== null) {
    response.data = data;
  }

  return res.status(statusCode).json(response);
};

/**
 * Standard error response
 * @param {Object} res - Express response object
 * @param {number} statusCode - HTTP status code
 * @param {string} message - Error message
 * @param {Object} details - Additional error details
 */
const errorResponse = (res, statusCode = 500, message = 'Error', details = null) => {
  const response = {
    success: false,
    message,
  };

  if (details !== null) {
    response.details = details;
  }

  return res.status(statusCode).json(response);
};

/**
 * Paginated response
 * @param {Object} res - Express response object
 * @param {Object} options - Pagination options
 */
const paginatedResponse = (res, options) => {
  const {
    data,
    page = 1,
    limit = 20,
    total,
    message = 'Success',
  } = options;

  const totalPages = Math.ceil(total / limit);
  const hasNextPage = page < totalPages;
  const hasPrevPage = page > 1;

  return res.status(200).json({
    success: true,
    message,
    data,
    pagination: {
      page,
      limit,
      total,
      totalPages,
      hasNextPage,
      hasPrevPage,
    },
  });
};

/**
 * Created response (201)
 */
const createdResponse = (res, message = 'Created successfully', data = null) => {
  return successResponse(res, 201, message, data);
};

/**
 * No content response (204)
 */
const noContentResponse = (res) => {
  return res.status(204).send();
};

/**
 * Bad request response (400)
 */
const badRequestResponse = (res, message = 'Bad request', details = null) => {
  return errorResponse(res, 400, message, details);
};

/**
 * Unauthorized response (401)
 */
const unauthorizedResponse = (res, message = 'Unauthorized') => {
  return errorResponse(res, 401, message);
};

/**
 * Forbidden response (403)
 */
const forbiddenResponse = (res, message = 'Forbidden') => {
  return errorResponse(res, 403, message);
};

/**
 * Not found response (404)
 */
const notFoundResponse = (res, message = 'Resource not found') => {
  return errorResponse(res, 404, message);
};

/**
 * Conflict response (409)
 */
const conflictResponse = (res, message = 'Conflict', details = null) => {
  return errorResponse(res, 409, message, details);
};

/**
 * Internal server error response (500)
 */
const serverErrorResponse = (res, message = 'Internal server error') => {
  return errorResponse(res, 500, message);
};

module.exports = {
  successResponse,
  errorResponse,
  paginatedResponse,
  createdResponse,
  noContentResponse,
  badRequestResponse,
  unauthorizedResponse,
  forbiddenResponse,
  notFoundResponse,
  conflictResponse,
  serverErrorResponse,
};
