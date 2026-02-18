import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationType {
  @JsonValue('milestone_due')
  milestoneDue,
  @JsonValue('milestone_overdue')
  milestoneOverdue,
  @JsonValue('assessment_reminder')
  assessmentReminder,
  @JsonValue('pending_approval')
  pendingApproval,
  @JsonValue('milestone_passed')
  milestonePassed,
  @JsonValue('milestone_failed')
  milestoneFailed,
  @JsonValue('probation_passed')
  probationPassed,
  @JsonValue('probation_failed')
  probationFailed,
  @JsonValue('supervisor_changed')
  supervisorChanged,
}

@freezed
class NotificationChannel with _$NotificationChannel {
  const factory NotificationChannel({
    @Default(false) bool sent,
    DateTime? readAt,
    DateTime? sentAt,
  }) = _NotificationChannel;

  factory NotificationChannel.fromJson(Map<String, dynamic> json) =>
      _$NotificationChannelFromJson(json);
}

@freezed
class NotificationChannels with _$NotificationChannels {
  const factory NotificationChannels({
    @Default(NotificationChannel()) NotificationChannel inApp,
    @Default(NotificationChannel()) NotificationChannel email,
    @Default(NotificationChannel()) NotificationChannel push,
  }) = _NotificationChannels;

  factory NotificationChannels.fromJson(Map<String, dynamic> json) =>
      _$NotificationChannelsFromJson(json);
}

@freezed
class NotificationData with _$NotificationData {
  const factory NotificationData({
    String? probationRecordId,
    int? milestoneDay,
  }) = _NotificationData;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
}

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    NotificationData? data,
    @Default(NotificationChannels()) NotificationChannels channels,
    DateTime? createdAt,
    // Virtual field
    @Default(false) bool isRead,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

@freezed
class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required List<AppNotification> notifications,
    required int unreadCount,
    required int total,
    required int page,
    required int limit,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

extension AppNotificationExtension on AppNotification {
  bool get isUnread => channels.inApp.readAt == null;

  /// Get relative time string
  String get timeAgo {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inDays > 7) {
      return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} วันที่แล้ว';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} ชั่วโมงที่แล้ว';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} นาทีที่แล้ว';
    } else {
      return 'เมื่อสักครู่';
    }
  }
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.milestoneDue:
        return 'ใกล้ถึงกำหนด Milestone';
      case NotificationType.milestoneOverdue:
        return 'เกินกำหนด Milestone';
      case NotificationType.assessmentReminder:
        return 'เตือนกรอกแบบประเมิน';
      case NotificationType.pendingApproval:
        return 'รอการยอมรับ';
      case NotificationType.milestonePassed:
        return 'ผ่าน Milestone';
      case NotificationType.milestoneFailed:
        return 'ไม่ผ่าน Milestone';
      case NotificationType.probationPassed:
        return 'ผ่านทดลองงาน';
      case NotificationType.probationFailed:
        return 'ไม่ผ่านทดลองงาน';
      case NotificationType.supervisorChanged:
        return 'เปลี่ยนหัวหน้างาน';
    }
  }

  /// Get icon name for notification type
  String get iconName {
    switch (this) {
      case NotificationType.milestoneDue:
        return 'calendar_today';
      case NotificationType.milestoneOverdue:
        return 'warning';
      case NotificationType.assessmentReminder:
        return 'assignment';
      case NotificationType.pendingApproval:
        return 'pending_actions';
      case NotificationType.milestonePassed:
        return 'check_circle';
      case NotificationType.milestoneFailed:
        return 'cancel';
      case NotificationType.probationPassed:
        return 'celebration';
      case NotificationType.probationFailed:
        return 'sentiment_dissatisfied';
      case NotificationType.supervisorChanged:
        return 'swap_horiz';
    }
  }

  bool get isUrgent {
    return this == NotificationType.milestoneOverdue ||
        this == NotificationType.milestoneFailed ||
        this == NotificationType.probationFailed;
  }

  bool get isPositive {
    return this == NotificationType.milestonePassed ||
        this == NotificationType.probationPassed;
  }
}
