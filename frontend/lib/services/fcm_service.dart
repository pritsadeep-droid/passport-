import 'dart:async';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

/// Firebase Cloud Messaging service (stub implementation)
/// Firebase packages are currently disabled due to compatibility issues.
/// This stub maintains the interface for when Firebase is re-enabled.
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  NotificationService? _notificationService;
  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  String? _currentToken;
  bool _initialized = false;

  /// Stream of incoming messages when app is in foreground
  Stream<Map<String, dynamic>> get onMessage => _messageStreamController.stream;

  /// Get current FCM token
  String? get currentToken => _currentToken;

  /// Initialize FCM service (stub - does nothing without Firebase)
  Future<void> initialize({NotificationService? notificationService}) async {
    if (_initialized) return;

    _notificationService = notificationService;
    _initialized = true;
    debugPrint('FCM Service initialized (stub - Firebase disabled)');
  }

  /// Subscribe to topic (stub)
  Future<void> subscribeToTopic(String topic) async {
    debugPrint('FCM subscribe to topic (stub): $topic');
  }

  /// Unsubscribe from topic (stub)
  Future<void> unsubscribeFromTopic(String topic) async {
    debugPrint('FCM unsubscribe from topic (stub): $topic');
  }

  /// Clear FCM token on logout (stub)
  Future<void> clearToken() async {
    _currentToken = null;
  }

  /// Dispose resources
  void dispose() {
    _messageStreamController.close();
    _initialized = false;
  }
}
