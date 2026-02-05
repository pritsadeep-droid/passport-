import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import 'auth_provider.dart';

/// Notification service provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationService(apiClient);
});

/// Unread count state
class UnreadCountState {
  final int count;
  final bool isLoading;
  final String? error;

  const UnreadCountState({
    this.count = 0,
    this.isLoading = false,
    this.error,
  });

  UnreadCountState copyWith({
    int? count,
    bool? isLoading,
    String? error,
  }) {
    return UnreadCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Unread count notifier
class UnreadCountNotifier extends StateNotifier<UnreadCountState> {
  final NotificationService _service;
  Timer? _refreshTimer;

  UnreadCountNotifier(this._service) : super(const UnreadCountState()) {
    _startPeriodicRefresh();
  }

  /// Start periodic refresh of unread count
  void _startPeriodicRefresh() {
    // Refresh every 30 seconds
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => refresh(),
    );
  }

  /// Fetch unread count
  Future<void> refresh() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final count = await _service.getUnreadCount();
      state = UnreadCountState(count: count);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Increment count (when new notification received)
  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  /// Decrement count (when notification read)
  void decrement() {
    if (state.count > 0) {
      state = state.copyWith(count: state.count - 1);
    }
  }

  /// Clear count (when all marked as read)
  void clear() {
    state = state.copyWith(count: 0);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}

/// Unread count provider
final unreadCountProvider =
    StateNotifierProvider<UnreadCountNotifier, UnreadCountState>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return UnreadCountNotifier(service);
});

/// Notifications list state
class NotificationsListState {
  final List<NotificationData> notifications;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const NotificationsListState({
    this.notifications = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  NotificationsListState copyWith({
    List<NotificationData>? notifications,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return NotificationsListState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Notifications list notifier
class NotificationsListNotifier extends StateNotifier<NotificationsListState> {
  final NotificationService _service;
  final UnreadCountNotifier _unreadCountNotifier;
  bool _unreadOnly = false;

  NotificationsListNotifier(this._service, this._unreadCountNotifier)
      : super(const NotificationsListState());

  /// Set unread only filter
  void setUnreadOnly(bool value) {
    if (_unreadOnly != value) {
      _unreadOnly = value;
      refresh();
    }
  }

  /// Fetch notifications (first page)
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _service.getNotifications(
        page: 1,
        unreadOnly: _unreadOnly,
      );

      state = NotificationsListState(
        notifications: response.notifications,
        currentPage: response.page,
        totalPages: response.totalPages,
        hasMore: response.page < response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more notifications
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _service.getNotifications(
        page: state.currentPage + 1,
        unreadOnly: _unreadOnly,
      );

      state = state.copyWith(
        notifications: [...state.notifications, ...response.notifications],
        currentPage: response.page,
        totalPages: response.totalPages,
        hasMore: response.page < response.totalPages,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);

      // Update local state
      final updatedList = state.notifications.map((n) {
        if (n.id == notificationId && !n.isRead) {
          _unreadCountNotifier.decrement();
          return NotificationData(
            id: n.id,
            type: n.type,
            title: n.title,
            message: n.message,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();

      state = state.copyWith(notifications: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _service.markAllAsRead();

      // Update local state
      final updatedList = state.notifications.map((n) {
        return NotificationData(
          id: n.id,
          type: n.type,
          title: n.title,
          message: n.message,
          data: n.data,
          isRead: true,
          createdAt: n.createdAt,
        );
      }).toList();

      state = state.copyWith(notifications: updatedList);
      _unreadCountNotifier.clear();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _service.deleteNotification(notificationId);

      // Update local state
      final notification = state.notifications.firstWhere(
        (n) => n.id == notificationId,
        orElse: () => state.notifications.first,
      );

      if (!notification.isRead) {
        _unreadCountNotifier.decrement();
      }

      final updatedList =
          state.notifications.where((n) => n.id != notificationId).toList();

      state = state.copyWith(notifications: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Add notification (from FCM)
  void addNotification(NotificationData notification) {
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
    );
    if (!notification.isRead) {
      _unreadCountNotifier.increment();
    }
  }
}

/// Notifications list provider
final notificationsListProvider =
    StateNotifierProvider<NotificationsListNotifier, NotificationsListState>(
        (ref) {
  final service = ref.watch(notificationServiceProvider);
  final unreadCountNotifier = ref.watch(unreadCountProvider.notifier);
  return NotificationsListNotifier(service, unreadCountNotifier);
});

/// Unread only filter provider
final unreadOnlyFilterProvider = StateProvider<bool>((ref) => false);
