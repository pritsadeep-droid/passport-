const {
  success,
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
} = require('../../../src/utils/response');

describe('Response Utilities', () => {
  let mockRes;

  beforeEach(() => {
    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };
  });

  describe('successResponse', () => {
    it('should return success response with default values', () => {
      successResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Success',
      });
    });

    it('should return success response with custom status code', () => {
      successResponse(mockRes, 201, 'Created');

      expect(mockRes.status).toHaveBeenCalledWith(201);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Created',
      });
    });

    it('should include data when provided', () => {
      const data = { id: 1, name: 'Test' };
      successResponse(mockRes, 200, 'Success', data);

      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Success',
        data: { id: 1, name: 'Test' },
      });
    });

    it('should not include data field when null', () => {
      successResponse(mockRes, 200, 'Success', null);

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.data).toBeUndefined();
    });
  });

  describe('success (helper function)', () => {
    it('should return success with data and default message', () => {
      const data = { id: 1 };
      success(mockRes, data);

      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Success',
        data: { id: 1 },
      });
    });

    it('should return success with custom message', () => {
      const data = { id: 1 };
      success(mockRes, data, 'Data retrieved');

      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Data retrieved',
        data: { id: 1 },
      });
    });

    it('should return success without data', () => {
      success(mockRes, null, 'Operation complete');

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.data).toBeUndefined();
      expect(jsonCall.message).toBe('Operation complete');
    });
  });

  describe('errorResponse', () => {
    it('should return error response with default values', () => {
      errorResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Error',
      });
    });

    it('should return error response with custom status and message', () => {
      errorResponse(mockRes, 400, 'Bad Request');

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Bad Request',
      });
    });

    it('should include details when provided', () => {
      const details = { field: 'email', error: 'Invalid format' };
      errorResponse(mockRes, 400, 'Validation Error', details);

      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Validation Error',
        details: { field: 'email', error: 'Invalid format' },
      });
    });

    it('should not include details field when null', () => {
      errorResponse(mockRes, 400, 'Error', null);

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.details).toBeUndefined();
    });
  });

  describe('paginatedResponse', () => {
    it('should return paginated response with all fields', () => {
      const options = {
        data: [{ id: 1 }, { id: 2 }],
        page: 2,
        limit: 10,
        total: 50,
        message: 'Data retrieved',
      };

      paginatedResponse(mockRes, options);

      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Data retrieved',
        data: [{ id: 1 }, { id: 2 }],
        pagination: {
          page: 2,
          limit: 10,
          total: 50,
          totalPages: 5,
          hasNextPage: true,
          hasPrevPage: true,
        },
      });
    });

    it('should calculate pagination correctly for first page', () => {
      const options = {
        data: [],
        page: 1,
        limit: 10,
        total: 25,
      };

      paginatedResponse(mockRes, options);

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.pagination.hasNextPage).toBe(true);
      expect(jsonCall.pagination.hasPrevPage).toBe(false);
      expect(jsonCall.pagination.totalPages).toBe(3);
    });

    it('should calculate pagination correctly for last page', () => {
      const options = {
        data: [],
        page: 3,
        limit: 10,
        total: 25,
      };

      paginatedResponse(mockRes, options);

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.pagination.hasNextPage).toBe(false);
      expect(jsonCall.pagination.hasPrevPage).toBe(true);
    });

    it('should handle single page results', () => {
      const options = {
        data: [],
        page: 1,
        limit: 10,
        total: 5,
      };

      paginatedResponse(mockRes, options);

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.pagination.totalPages).toBe(1);
      expect(jsonCall.pagination.hasNextPage).toBe(false);
      expect(jsonCall.pagination.hasPrevPage).toBe(false);
    });

    it('should use default values', () => {
      const options = {
        data: [],
        total: 100,
      };

      paginatedResponse(mockRes, options);

      const jsonCall = mockRes.json.mock.calls[0][0];
      expect(jsonCall.pagination.page).toBe(1);
      expect(jsonCall.pagination.limit).toBe(20);
      expect(jsonCall.message).toBe('Success');
    });
  });

  describe('createdResponse', () => {
    it('should return 201 status with default message', () => {
      createdResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(201);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Created successfully',
      });
    });

    it('should include data when provided', () => {
      const data = { id: 1, name: 'New Item' };
      createdResponse(mockRes, 'Item created', data);

      expect(mockRes.json).toHaveBeenCalledWith({
        success: true,
        message: 'Item created',
        data: { id: 1, name: 'New Item' },
      });
    });
  });

  describe('noContentResponse', () => {
    it('should return 204 status with no body', () => {
      noContentResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(204);
      expect(mockRes.send).toHaveBeenCalled();
      expect(mockRes.json).not.toHaveBeenCalled();
    });
  });

  describe('badRequestResponse', () => {
    it('should return 400 status with default message', () => {
      badRequestResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Bad request',
      });
    });

    it('should include custom message and details', () => {
      const details = { field: 'email' };
      badRequestResponse(mockRes, 'Invalid email format', details);

      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Invalid email format',
        details: { field: 'email' },
      });
    });
  });

  describe('unauthorizedResponse', () => {
    it('should return 401 status with default message', () => {
      unauthorizedResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Unauthorized',
      });
    });

    it('should include custom message', () => {
      unauthorizedResponse(mockRes, 'Invalid credentials');

      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Invalid credentials',
      });
    });
  });

  describe('forbiddenResponse', () => {
    it('should return 403 status with default message', () => {
      forbiddenResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(403);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Forbidden',
      });
    });

    it('should include custom message', () => {
      forbiddenResponse(mockRes, 'Access denied');

      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Access denied',
      });
    });
  });

  describe('notFoundResponse', () => {
    it('should return 404 status with default message', () => {
      notFoundResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(404);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Resource not found',
      });
    });

    it('should include custom message', () => {
      notFoundResponse(mockRes, 'User not found');

      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'User not found',
      });
    });
  });

  describe('conflictResponse', () => {
    it('should return 409 status with default message', () => {
      conflictResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(409);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Conflict',
      });
    });

    it('should include custom message and details', () => {
      const details = { field: 'email', existingValue: 'test@example.com' };
      conflictResponse(mockRes, 'Email already exists', details);

      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Email already exists',
        details: { field: 'email', existingValue: 'test@example.com' },
      });
    });
  });

  describe('serverErrorResponse', () => {
    it('should return 500 status with default message', () => {
      serverErrorResponse(mockRes);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Internal server error',
      });
    });

    it('should include custom message', () => {
      serverErrorResponse(mockRes, 'Database connection failed');

      expect(mockRes.json).toHaveBeenCalledWith({
        success: false,
        message: 'Database connection failed',
      });
    });
  });
});
