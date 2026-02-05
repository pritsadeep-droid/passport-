const mongoose = require('mongoose');
const User = require('../../../src/models/User');

describe('User Model', () => {
  describe('Schema Validation', () => {
    it('should create a valid user with all required fields', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      const user = await User.create(userData);

      expect(user._id).toBeDefined();
      expect(user.employeeId).toBe('EMP001');
      expect(user.email).toBe('test@example.com');
      expect(user.name).toBe('Test User');
      expect(user.department).toBe('Engineering');
      expect(user.role).toBe('employee'); // default role
      expect(user.isActive).toBe(true); // default
    });

    it('should fail without required employeeId', async () => {
      const userData = {
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      await expect(User.create(userData)).rejects.toThrow(/Employee ID is required/);
    });

    it('should fail without required email', async () => {
      const userData = {
        employeeId: 'EMP001',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      await expect(User.create(userData)).rejects.toThrow(/Email is required/);
    });

    it('should fail without required password', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        name: 'Test User',
        department: 'Engineering',
      };

      await expect(User.create(userData)).rejects.toThrow(/Password is required/);
    });

    it('should fail without required name', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        department: 'Engineering',
      };

      await expect(User.create(userData)).rejects.toThrow(/Name is required/);
    });

    it('should fail without required department', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      };

      await expect(User.create(userData)).rejects.toThrow(/Department is required/);
    });

    it('should fail with password less than 8 characters', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'short',
        name: 'Test User',
        department: 'Engineering',
      };

      await expect(User.create(userData)).rejects.toThrow();
    });

    it('should only allow valid roles', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
        role: 'invalid_role',
      };

      await expect(User.create(userData)).rejects.toThrow();
    });

    it('should accept valid roles: employee, supervisor, hr_admin', async () => {
      const roles = ['employee', 'supervisor', 'hr_admin'];

      for (let i = 0; i < roles.length; i++) {
        const userData = {
          employeeId: `EMP00${i + 1}`,
          email: `test${i}@example.com`,
          password: 'password123',
          name: `Test User ${i}`,
          department: 'Engineering',
          role: roles[i],
        };

        const user = await User.create(userData);
        expect(user.role).toBe(roles[i]);
      }
    });

    it('should convert email to lowercase', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'TEST@EXAMPLE.COM',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      const user = await User.create(userData);
      expect(user.email).toBe('test@example.com');
    });

    it('should trim whitespace from fields', async () => {
      const userData = {
        employeeId: '  EMP001  ',
        email: 'test@example.com',
        password: 'password123',
        name: '  Test User  ',
        department: '  Engineering  ',
      };

      const user = await User.create(userData);
      expect(user.employeeId).toBe('EMP001');
      expect(user.name).toBe('Test User');
      expect(user.department).toBe('Engineering');
    });

    it('should enforce unique employeeId', async () => {
      const userData1 = {
        employeeId: 'EMP001',
        email: 'test1@example.com',
        password: 'password123',
        name: 'Test User 1',
        department: 'Engineering',
      };

      const userData2 = {
        employeeId: 'EMP001',
        email: 'test2@example.com',
        password: 'password123',
        name: 'Test User 2',
        department: 'Engineering',
      };

      await User.create(userData1);
      await expect(User.create(userData2)).rejects.toThrow();
    });

    it('should enforce unique email', async () => {
      const userData1 = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User 1',
        department: 'Engineering',
      };

      const userData2 = {
        employeeId: 'EMP002',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User 2',
        department: 'Engineering',
      };

      await User.create(userData1);
      await expect(User.create(userData2)).rejects.toThrow();
    });
  });

  describe('Password Hashing', () => {
    it('should hash password before saving', async () => {
      const plainPassword = 'password123';
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: plainPassword,
        name: 'Test User',
        department: 'Engineering',
      };

      const user = await User.create(userData);
      const userWithPassword = await User.findById(user._id).select('+password');

      expect(userWithPassword.password).not.toBe(plainPassword);
      expect(userWithPassword.password.startsWith('$2')).toBe(true); // bcrypt hash
    });

    it('should not re-hash password if not modified', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      const user = await User.create(userData);
      const userWithPassword = await User.findById(user._id).select('+password');
      const originalHash = userWithPassword.password;

      userWithPassword.name = 'Updated Name';
      await userWithPassword.save();

      const updatedUser = await User.findById(user._id).select('+password');
      expect(updatedUser.password).toBe(originalHash);
    });
  });

  describe('comparePassword Method', () => {
    it('should return true for correct password', async () => {
      const plainPassword = 'password123';
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: plainPassword,
        name: 'Test User',
        department: 'Engineering',
      };

      await User.create(userData);
      const user = await User.findOne({ email: 'test@example.com' }).select('+password');

      const isMatch = await user.comparePassword(plainPassword);
      expect(isMatch).toBe(true);
    });

    it('should return false for incorrect password', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      await User.create(userData);
      const user = await User.findOne({ email: 'test@example.com' }).select('+password');

      const isMatch = await user.comparePassword('wrongpassword');
      expect(isMatch).toBe(false);
    });
  });

  describe('toJSON Method', () => {
    it('should remove sensitive fields from JSON output', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      const user = await User.create(userData);
      const userWithPassword = await User.findById(user._id).select('+password +refreshToken');
      const jsonUser = userWithPassword.toJSON();

      expect(jsonUser.password).toBeUndefined();
      expect(jsonUser.refreshToken).toBeUndefined();
      expect(jsonUser.__v).toBeUndefined();
      expect(jsonUser.email).toBe('test@example.com');
    });
  });

  describe('Supervisor Reference', () => {
    it('should accept valid supervisor reference', async () => {
      const supervisorData = {
        employeeId: 'SUP001',
        email: 'supervisor@example.com',
        password: 'password123',
        name: 'Supervisor',
        department: 'Engineering',
        role: 'supervisor',
      };

      const supervisor = await User.create(supervisorData);

      const employeeData = {
        employeeId: 'EMP001',
        email: 'employee@example.com',
        password: 'password123',
        name: 'Employee',
        department: 'Engineering',
        supervisorId: supervisor._id,
      };

      const employee = await User.create(employeeData);
      expect(employee.supervisorId.toString()).toBe(supervisor._id.toString());
    });

    it('should allow null supervisorId', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
        supervisorId: null,
      };

      const user = await User.create(userData);
      expect(user.supervisorId).toBeNull();
    });
  });

  describe('FCM Tokens', () => {
    it('should initialize fcmTokens as empty array', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      const user = await User.create(userData);
      expect(user.fcmTokens).toEqual([]);
    });

    it('should accept fcmTokens array', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
        fcmTokens: ['token1', 'token2'],
      };

      const user = await User.create(userData);
      expect(user.fcmTokens).toEqual(['token1', 'token2']);
    });
  });

  describe('Timestamps', () => {
    it('should have createdAt and updatedAt timestamps', async () => {
      const userData = {
        employeeId: 'EMP001',
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        department: 'Engineering',
      };

      const user = await User.create(userData);
      expect(user.createdAt).toBeDefined();
      expect(user.updatedAt).toBeDefined();
      expect(user.createdAt instanceof Date).toBe(true);
      expect(user.updatedAt instanceof Date).toBe(true);
    });
  });
});
