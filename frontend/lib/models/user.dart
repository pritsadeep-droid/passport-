import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  @JsonValue('employee')
  employee,
  @JsonValue('supervisor')
  supervisor,
  @JsonValue('hr_admin')
  hrAdmin,
}

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    required String employeeId,
    required String email,
    required String name,
    required UserRole role,
    required String department,
    String? position,
    String? supervisorId,
    @Default(true) bool isActive,
    @Default([]) List<String> fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.employee:
        return 'พนักงานใหม่';
      case UserRole.supervisor:
        return 'หัวหน้างาน';
      case UserRole.hrAdmin:
        return 'ผู้ดูแล HR';
    }
  }

  bool get isEmployee => this == UserRole.employee;
  bool get isSupervisor => this == UserRole.supervisor;
  bool get isHrAdmin => this == UserRole.hrAdmin;
}
