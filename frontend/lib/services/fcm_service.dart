import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.messageId}');
}

/// Firebase Cloud Messaging service
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationService? _notificationService;
  StreamController<RemoteMessage>? _messageStreamController;
  String? _currentToken;
  bool _initialized = false;

  /// Stream of incoming messages when app is in foreground
  Stream<RemoteMessage> get onMessage =>
      _messageStreamController?.stream ?? const Stream.empty();

  /// Get current FCM token
  String? get currentToken => _currentToken;

  /// Initialize FCM service
  Future<void> initialize({NotificationService? notificationService}) async {
    if (_initialized) return;

    _notificationService = notificationService;
    _messageStreamController = StreamController<RemoteMessage>.broadcast();

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize local notifications for foreground display
    await _initializeLocalNotifications();

    // Request permission
    await _requestPermission();

    // Get initial token
    await _getToken();

    // Listen for token refresh
    _messaging.onTokenRefresh.listen(_onTokenRefresh);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app was in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    _initialized = true;
    debugPrint('FCM Service initialized');
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'kpi_probation_channel',
        'KPI Probation Notifications',
        description: 'Notifications for KPI Probation Tracking',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Request notification permission
  Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    final authorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    debugPrint('FCM Permission: ${settings.authorizationStatus}');
    return authorized;
  }

  /// Get FCM token
  Future<String?> _getToken() async {
    try {
      _currentToken = await _messaging.getToken();
      debugPrint('FCM Token: $_currentToken');

      if (_currentToken != null && _notificationService != null) {
        await _notificationService!.registerFcmToken(_currentToken!);
      }

      return _currentToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String newToken) async {
    debugPrint('FCM Token refreshed: $newToken');

    // Remove old token if exists
    if (_currentToken != null && _notificationService != null) {
      try {
        await _notificationService!.removeFcmToken(_currentToken!);
      } catch (e) {
        debugPrint('Error removing old FCM token: $e');
      }
    }

    _currentToken = newToken;

    // Register new token
    if (_notificationService != null) {
      try {
        await _notificationService!.registerFcmToken(newToken);
      } catch (e) {
        debugPrint('Error registering new FCM token: $e');
      }
    }
  }

  /// Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.messageId}');
    _messageStreamController?.add(message);

    // Show local notification
    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'การแจ้งเตือน',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Handle notification tap when app was in background
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tap: ${message.messageId}');
    // Navigate to appropriate screen based on notification type
    final data = message.data;
    final type = data['type'];

    // This would typically trigger navigation through a navigator key or callback
    debugPrint('Navigate for notification type: $type');
  }

  /// Handle local notification tap
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tap: ${response.payload}');
    // Handle navigation based on payload
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'kpi_probation_channel',
      'KPI Probation Notifications',
      channelDescription: 'Notifications for KPI Probation Tracking',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFD32F2F), // Red theme color
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Clear FCM token on logout
  Future<void> clearToken() async {
    if (_currentToken != null && _notificationService != null) {
      try {
        await _notificationService!.removeFcmToken(_currentToken!);
      } catch (e) {
        debugPrint('Error removing FCM token: $e');
      }
    }
    _currentToken = null;
  }

  /// Dispose resources
  void dispose() {
    _messageStreamController?.close();
    _initialized = false;
  }
}

/// Color class for notification styling
class Color {
  final int value;
  const Color(this.value);
}
