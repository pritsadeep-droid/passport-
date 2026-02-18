import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _apiClient;

  UserService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Create a new user (HR Admin only)
  Future<User> createUser(CreateUserRequest request) async {
    try {
      final response = await _apiClient.post(
        '/users',
        data: request.toJson(),
      );
      
      return User.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get team members (Supervisor/HR only)
  Future<PaginatedResponse<User>> getTeamMembers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.get(
        '/users/team',
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get all users (HR only)
  Future<PaginatedResponse<User>> getAllUsers({
    int page = 1,
    int limit = 20,
    String? role,
    String? department,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (role != null) queryParams['role'] = role;
      if (department != null) queryParams['department'] = department;
      if (search != null) queryParams['search'] = search;

      final response = await _apiClient.get(
        '/users/all',
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
  /// Get supervisors (for dropdown selection)
  Future<List<User>> getSupervisors() async {
    try {
      final response = await _apiClient.get(
        '/users/all',
        queryParameters: {
          'role': 'supervisor',
          'limit': 100, // Fetch enough for dropdown
        },
      );

      final paginated = PaginatedResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
      
      return paginated.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

class CreateUserRequest {
  final String employeeId;
  final String email;
  final String password;
  final String name;
  final UserRole role;
  final String department;
  final String position;
  final String? supervisorId;

  CreateUserRequest({
    required this.employeeId,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.department,
    required this.position,
    this.supervisorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'email': email,
      'password': password,
      'name': name,
      'role': _roleToString(role),
      'department': department,
      'position': position,
      'supervisorId': supervisorId,
    };
  }

  String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.employee:
        return 'employee';
      case UserRole.supervisor:
        return 'supervisor';
      case UserRole.hrAdmin:
        return 'hr_admin';
    }
  }
}
