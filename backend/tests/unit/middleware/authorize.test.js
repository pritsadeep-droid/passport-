const mongoose = require('mongoose');
const User = require('../../../src/models/User');
const {
  authorize,
  authorizeOwnerOrAdmin,
  authorizeSupervisor,
  authorizeEmployeeOrSupervisor,
  ROLES,
} = require('../../../src/middleware/authorize');

describe('Authorize Middleware', () => {
  let mockRes, mockNext;
  let hrAdmin, supervisor, employee;

  beforeEach(async () => {
    // Create test users
    hrAdmin = await User.create({
      employeeId: 'HR001',
      email: 'hr@example.com',
      password: 'password123',
      name: 'HR Admin',
      department: 'HR',
      role: 'hr_admin',
    });

    supervisor = await User.create({
      employeeId: 'SUP001',
      email: 'supervisor@example.com',
      password: 'password123',
      name: 'Supervisor',
      department: 'Engineering',
      role: 'supervisor',
    });

    employee = await User.create({
      employeeId: 'EMP001',
      email: 'employee@example.com',
      password: 'password123',
      name: 'Employee',
      department: 'Engineering',
      role: 'employee',
      supervisorId: supervisor._id,
    });

    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };

    mockNext = jest.fn();
  });

  describe('ROLES constant', () => {
    it('should export correct role constants', () => {
      expect(ROLES.EMPLOYEE).toBe('employee');
      expect(ROLES.SUPERVISOR).toBe('supervisor');
      expect(ROLES.HR_ADMIN).toBe('hr_admin');
    });
  });

  describe('authorize', () => {
    it('should return 401 if no user on request', () => {
      const mockReq = {};
      const middleware = authorize('employee');

      middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Authentication required.',
        })
      );
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 403 if user role not in allowed roles', () => {
      const mockReq = { user: { role: 'employee' } };
      const middleware = authorize('hr_admin', 'supervisor');

      middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(403);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'You do not have permission to perform this action.',
        })
      );
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next if user role is in allowed roles', () => {
      const mockReq = { user: { role: 'hr_admin' } };
      const middleware = authorize('hr_admin', 'supervisor');

      middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(mockRes.status).not.toHaveBeenCalled();
    });

    it('should work with single role', () => {
      const mockReq = { user: { role: 'employee' } };
      const middleware = authorize('employee');

      middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should work with multiple roles', () => {
      const mockReq = { user: { role: 'supervisor' } };
      const middleware = authorize('employee', 'supervisor', 'hr_admin');

      middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });
  });

  describe('authorizeOwnerOrAdmin', () => {
    it('should return 401 if no user on request', async () => {
      const mockReq = { params: { id: employee._id.toString() } };
      const getOwnerId = (req) => req.params.id;
      const middleware = authorizeOwnerOrAdmin(getOwnerId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should allow hr_admin to access any resource', async () => {
      const mockReq = {
        user: hrAdmin,
        params: { id: employee._id.toString() },
      };
      const getOwnerId = (req) => req.params.id;
      const middleware = authorizeOwnerOrAdmin(getOwnerId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should allow owner to access their own resource', async () => {
      const mockReq = {
        user: employee,
        params: { id: employee._id.toString() },
      };
      const getOwnerId = (req) => req.params.id;
      const middleware = authorizeOwnerOrAdmin(getOwnerId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should return 404 if getOwnerId returns null', async () => {
      const mockReq = {
        user: employee,
        params: {},
      };
      const getOwnerId = () => null;
      const middleware = authorizeOwnerOrAdmin(getOwnerId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(404);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Resource not found.',
        })
      );
    });

    it('should return 403 if non-owner tries to access resource', async () => {
      const mockReq = {
        user: employee,
        params: { id: supervisor._id.toString() },
      };
      const getOwnerId = (req) => req.params.id;
      const middleware = authorizeOwnerOrAdmin(getOwnerId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(403);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'You do not have permission to access this resource.',
        })
      );
    });
  });

  describe('authorizeSupervisor', () => {
    it('should return 401 if no user on request', async () => {
      const mockReq = { params: { employeeId: employee._id.toString() } };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
    });

    it('should allow hr_admin access', async () => {
      const mockReq = {
        user: hrAdmin,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should return 403 if user is not a supervisor', async () => {
      const mockReq = {
        user: employee,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(403);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Only supervisors can perform this action.',
        })
      );
    });

    it('should return 404 if getEmployeeId returns null', async () => {
      const mockReq = {
        user: supervisor,
        params: {},
      };
      const getEmployeeId = () => null;
      const middleware = authorizeSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(404);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Employee not found.',
        })
      );
    });

    it('should return 404 if employee not found in database', async () => {
      const nonExistentId = new mongoose.Types.ObjectId();
      const mockReq = {
        user: supervisor,
        params: { employeeId: nonExistentId.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(404);
    });

    it('should allow supervisor to access their employee', async () => {
      const mockReq = {
        user: supervisor,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should return 403 if supervisor is not the employee supervisor', async () => {
      const otherSupervisor = await User.create({
        employeeId: 'SUP002',
        email: 'supervisor2@example.com',
        password: 'password123',
        name: 'Other Supervisor',
        department: 'Sales',
        role: 'supervisor',
      });

      const mockReq = {
        user: otherSupervisor,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(403);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'You are not the supervisor of this employee.',
        })
      );
    });
  });

  describe('authorizeEmployeeOrSupervisor', () => {
    it('should return 401 if no user on request', async () => {
      const mockReq = { params: { employeeId: employee._id.toString() } };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeEmployeeOrSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
    });

    it('should allow hr_admin access', async () => {
      const mockReq = {
        user: hrAdmin,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeEmployeeOrSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should allow employee to access their own data', async () => {
      const mockReq = {
        user: employee,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeEmployeeOrSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should allow supervisor to access their employee data', async () => {
      const mockReq = {
        user: supervisor,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeEmployeeOrSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockNext).toHaveBeenCalled();
    });

    it('should return 404 if getEmployeeId returns null', async () => {
      const mockReq = {
        user: employee,
        params: {},
      };
      const getEmployeeId = () => null;
      const middleware = authorizeEmployeeOrSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(404);
    });

    it('should return 404 if employee not found in database', async () => {
      const nonExistentId = new mongoose.Types.ObjectId();
      const mockReq = {
        user: supervisor,
        params: { employeeId: nonExistentId.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeEmployeeOrSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(404);
    });

    it('should return 403 for unauthorized access', async () => {
      const otherEmployee = await User.create({
        employeeId: 'EMP002',
        email: 'other@example.com',
        password: 'password123',
        name: 'Other Employee',
        department: 'Sales',
        role: 'employee',
      });

      const mockReq = {
        user: otherEmployee,
        params: { employeeId: employee._id.toString() },
      };
      const getEmployeeId = (req) => req.params.employeeId;
      const middleware = authorizeEmployeeOrSupervisor(getEmployeeId);

      await middleware(mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(403);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'You do not have permission to access this resource.',
        })
      );
    });
  });
});
