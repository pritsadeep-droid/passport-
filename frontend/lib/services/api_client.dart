import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_storage.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient._internal(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:3000/api/v1',
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  factory ApiClient(TokenStorage tokenStorage) {
    _instance ??= ApiClient._internal(tokenStorage);
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Add logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token if available
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry the original request
        try {
          final options = error.requestOptions;
          final token = await _tokenStorage.getAccessToken();
          options.headers['Authorization'] = 'Bearer $token';

          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(error);
        }
      } else {
        // Clear tokens and reject
        await _tokenStorage.clearTokens();
      }
    }
    handler.reject(error);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio(
        BaseOptions(baseUrl: _dio.options.baseUrl),
      ).post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      return false;
    }
  }

  // HTTP Methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Download file
  Future<Response> download(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.download(
      path,
      savePath,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Get options for downloading binary data
  Options downloadOptions() {
    return Options(
      responseType: ResponseType.bytes,
    );
  }
}

/// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final dynamic details;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.details,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : json['data'],
      details: json['details'],
    );
  }
}

/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginatedResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final pagination = json['pagination'] ?? {};
    final dataList = (json['data'] as List?)
            ?.map((e) => fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedResponse(
      data: dataList,
      page: pagination['page'] ?? 1,
      limit: pagination['limit'] ?? 20,
      total: pagination['total'] ?? 0,
      totalPages: pagination['totalPages'] ?? 0,
      hasNextPage: pagination['hasNextPage'] ?? false,
      hasPrevPage: pagination['hasPrevPage'] ?? false,
    );
  }
}

/// API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  ApiException({
    required this.message,
    this.statusCode,
    this.details,
  });

  factory ApiException.fromDioError(DioException error) {
    String message = 'เกิดข้อผิดพลาด';
    int? statusCode = error.response?.statusCode;
    dynamic details;

    if (error.response?.data != null) {
      final data = error.response!.data;
      if (data is Map) {
        message = data['message'] ?? message;
        details = data['details'];
      }
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'หมดเวลาการเชื่อมต่อ';
          break;
        case DioExceptionType.connectionError:
          message = 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้';
          break;
        case DioExceptionType.cancel:
          message = 'การร้องขอถูกยกเลิก';
          break;
        default:
          message = 'เกิดข้อผิดพลาดในการเชื่อมต่อ';
      }
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      details: details,
    );
  }

  @override
  String toString() => message;
}
