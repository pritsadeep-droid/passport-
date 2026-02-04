// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationChannelImpl _$$NotificationChannelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationChannelImpl(
      sent: json['sent'] as bool? ?? false,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$$NotificationChannelImplToJson(
        _$NotificationChannelImpl instance) =>
    <String, dynamic>{
      'sent': instance.sent,
      'readAt': instance.readAt?.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
    };

_$NotificationChannelsImpl _$$NotificationChannelsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationChannelsImpl(
      inApp: json['inApp'] == null
          ? const NotificationChannel()
          : NotificationChannel.fromJson(json['inApp'] as Map<String, dynamic>),
      email: json['email'] == null
          ? const NotificationChannel()
          : NotificationChannel.fromJson(json['email'] as Map<String, dynamic>),
      push: json['push'] == null
          ? const NotificationChannel()
          : NotificationChannel.fromJson(json['push'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NotificationChannelsImplToJson(
        _$NotificationChannelsImpl instance) =>
    <String, dynamic>{
      'inApp': instance.inApp,
      'email': instance.email,
      'push': instance.push,
    };

_$NotificationDataImpl _$$NotificationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationDataImpl(
      probationRecordId: json['probationRecordId'] as String?,
      milestoneDay: (json['milestoneDay'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$NotificationDataImplToJson(
        _$NotificationDataImpl instance) =>
    <String, dynamic>{
      'probationRecordId': instance.probationRecordId,
      'milestoneDay': instance.milestoneDay,
    };

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
      channels: json['channels'] == null
          ? const NotificationChannels()
          : NotificationChannels.fromJson(
              json['channels'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'data': instance.data,
      'channels': instance.channels,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isRead': instance.isRead,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.milestoneDue: 'milestone_due',
  NotificationType.milestoneOverdue: 'milestone_overdue',
  NotificationType.assessmentReminder: 'assessment_reminder',
  NotificationType.pendingApproval: 'pending_approval',
  NotificationType.milestonePassed: 'milestone_passed',
  NotificationType.milestoneFailed: 'milestone_failed',
  NotificationType.probationPassed: 'probation_passed',
  NotificationType.probationFailed: 'probation_failed',
  NotificationType.supervisorChanged: 'supervisor_changed',
};

_$NotificationListResponseImpl _$$NotificationListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationListResponseImpl(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: (json['unreadCount'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$$NotificationListResponseImplToJson(
        _$NotificationListResponseImpl instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'unreadCount': instance.unreadCount,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
