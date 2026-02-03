import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthService({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data['data'];
      final authResponse = AuthResponse(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
        user: User.fromJson(data['user']),
      );

      // Save tokens
      await _tokenStorage.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      return authResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Refresh access token
  Future<String> refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        throw ApiException(message: 'ไม่พบ Refresh Token');
      }

      final response = await _apiClient.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'];
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      return newAccessToken;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Ignore logout API errors
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/users/me');
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _tokenStorage.hasTokens();
  }

  /// Register FCM token for push notifications
  Future<void> registerFcmToken(String fcmToken) async {
    try {
      await _apiClient.post(
        '/users/me/fcm-token',
        data: {'fcmToken': fcmToken},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Remove FCM token (on logout)
  Future<void> removeFcmToken(String fcmToken) async {
    try {
      await _apiClient.delete(
        '/users/me/fcm-token',
        data: {'fcmToken': fcmToken},
      );
    } catch (e) {
      // Ignore errors
    }
  }
}
