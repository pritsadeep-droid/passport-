const { errorResponse } = require('../utils/response');

/**
 * Role-based authorization middleware
 * @param {...string} allowedRoles - Roles that are allowed to access the route
 */
const authorize = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return errorResponse(res, 401, 'Authentication required.');
    }

    if (!allowedRoles.includes(req.user.role)) {
      return errorResponse(
        res,
        403,
        'You do not have permission to perform this action.'
      );
    }

    next();
  };
};

/**
 * Check if user is the owner of the resource or has admin role
 * @param {Function} getOwnerId - Function to extract owner ID from request
 */
const authorizeOwnerOrAdmin = (getOwnerId) => {
  return async (req, res, next) => {
    if (!req.user) {
      return errorResponse(res, 401, 'Authentication required.');
    }

    // HR admins can access everything
    if (req.user.role === 'hr_admin') {
      return next();
    }

    try {
      const ownerId = await getOwnerId(req);

      if (!ownerId) {
        return errorResponse(res, 404, 'Resource not found.');
      }

      // Check if user is the owner
      if (req.user._id.toString() === ownerId.toString()) {
        return next();
      }

      return errorResponse(
        res,
        403,
        'You do not have permission to access this resource.'
      );
    } catch (error) {
      return errorResponse(res, 500, 'Authorization error.');
    }
  };
};

/**
 * Check if user is the supervisor of the employee
 * @param {Function} getEmployeeId - Function to extract employee ID from request
 */
const authorizeSupervisor = (getEmployeeId) => {
  return async (req, res, next) => {
    if (!req.user) {
      return errorResponse(res, 401, 'Authentication required.');
    }

    // HR admins can access everything
    if (req.user.role === 'hr_admin') {
      return next();
    }

    // Only supervisors can use this middleware
    if (req.user.role !== 'supervisor') {
      return errorResponse(
        res,
        403,
        'Only supervisors can perform this action.'
      );
    }

    try {
      const User = require('../models/User');
      const employeeId = await getEmployeeId(req);

      if (!employeeId) {
        return errorResponse(res, 404, 'Employee not found.');
      }

      const employee = await User.findById(employeeId);

      if (!employee) {
        return errorResponse(res, 404, 'Employee not found.');
      }

      // Check if user is the supervisor
      if (
        employee.supervisorId &&
        employee.supervisorId.toString() === req.user._id.toString()
      ) {
        return next();
      }

      return errorResponse(
        res,
        403,
        'You are not the supervisor of this employee.'
      );
    } catch (error) {
      return errorResponse(res, 500, 'Authorization error.');
    }
  };
};

/**
 * Check if user is the employee themselves or their supervisor
 */
const authorizeEmployeeOrSupervisor = (getEmployeeId) => {
  return async (req, res, next) => {
    if (!req.user) {
      return errorResponse(res, 401, 'Authentication required.');
    }

    // HR admins can access everything
    if (req.user.role === 'hr_admin') {
      return next();
    }

    try {
      const User = require('../models/User');
      const employeeId = await getEmployeeId(req);

      if (!employeeId) {
        return errorResponse(res, 404, 'Employee not found.');
      }

      // Check if user is the employee themselves
      if (req.user._id.toString() === employeeId.toString()) {
        return next();
      }

      // Check if user is the supervisor
      const employee = await User.findById(employeeId);

      if (!employee) {
        return errorResponse(res, 404, 'Employee not found.');
      }

      if (
        employee.supervisorId &&
        employee.supervisorId.toString() === req.user._id.toString()
      ) {
        return next();
      }

      return errorResponse(
        res,
        403,
        'You do not have permission to access this resource.'
      );
    } catch (error) {
      return errorResponse(res, 500, 'Authorization error.');
    }
  };
};

// Role constants
const ROLES = {
  EMPLOYEE: 'employee',
  SUPERVISOR: 'supervisor',
  HR_ADMIN: 'hr_admin',
};

module.exports = {
  authorize,
  authorizeOwnerOrAdmin,
  authorizeSupervisor,
  authorizeEmployeeOrSupervisor,
  ROLES,
};
