import 'package:dio/dio.dart';
import 'api_client.dart';

/// Notification data model
class NotificationData {
  final String id;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationData({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Get notification icon based on type
  String get iconName {
    switch (type) {
      case 'milestone_reminder':
        return 'calendar_today';
      case 'milestone_overdue':
        return 'warning';
      case 'milestone_approved':
        return 'check_circle';
      case 'milestone_rejected':
        return 'cancel';
      case 'assessment_submitted':
        return 'assignment_turned_in';
      case 'supervisor_assessment':
        return 'rate_review';
      case 'kpi_assigned':
        return 'assignment';
      case 'probation_completed':
        return 'celebration';
      case 'approval_reminder':
        return 'pending_actions';
      case 'kpi_reminder':
        return 'assignment_late';
      default:
        return 'notifications';
    }
  }

  /// Check if notification is actionable
  bool get isActionable {
    return [
      'milestone_reminder',
      'milestone_overdue',
      'assessment_submitted',
      'supervisor_assessment',
      'kpi_assigned',
      'approval_reminder',
      'kpi_reminder',
    ].contains(type);
  }
}

/// Paginated notification response
class NotificationsResponse {
  final List<NotificationData> notifications;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  NotificationsResponse({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return NotificationsResponse(
      notifications: (data['notifications'] as List? ?? [])
          .map((n) => NotificationData.fromJson(n))
          .toList(),
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 20,
      totalPages: data['totalPages'] ?? 1,
    );
  }
}

/// Notification service for API calls
class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  /// Get notifications for current user
  Future<NotificationsResponse> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/notifications',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (unreadOnly) 'unreadOnly': 'true',
        },
      );

      return NotificationsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get('/notifications/unread-count');
      final data = response.data['data'] ?? response.data;
      return data['count'] ?? 0;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.post('/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Mark all notifications as read
  Future<int> markAllAsRead() async {
    try {
      final response = await _apiClient.post('/notifications/read-all');
      final data = response.data['data'] ?? response.data;
      return data['count'] ?? 0;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiClient.delete('/notifications/$notificationId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Register FCM token for push notifications
  Future<void> registerFcmToken(String token) async {
    try {
      await _apiClient.post('/users/fcm-token', data: {'token': token});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Remove FCM token
  Future<void> removeFcmToken(String token) async {
    try {
      await _apiClient.delete('/users/fcm-token', data: {'token': token});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final message = e.response?.data?['message'] ?? e.message ?? 'เกิดข้อผิดพลาด';
    return Exception(message);
  }
}
