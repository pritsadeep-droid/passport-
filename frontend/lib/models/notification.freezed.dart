// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationChannel _$NotificationChannelFromJson(Map<String, dynamic> json) {
  return _NotificationChannel.fromJson(json);
}

/// @nodoc
mixin _$NotificationChannel {
  bool get sent => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  DateTime? get sentAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationChannelCopyWith<NotificationChannel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationChannelCopyWith<$Res> {
  factory $NotificationChannelCopyWith(
          NotificationChannel value, $Res Function(NotificationChannel) then) =
      _$NotificationChannelCopyWithImpl<$Res, NotificationChannel>;
  @useResult
  $Res call({bool sent, DateTime? readAt, DateTime? sentAt});
}

/// @nodoc
class _$NotificationChannelCopyWithImpl<$Res, $Val extends NotificationChannel>
    implements $NotificationChannelCopyWith<$Res> {
  _$NotificationChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sent = null,
    Object? readAt = freezed,
    Object? sentAt = freezed,
  }) {
    return _then(_value.copyWith(
      sent: null == sent
          ? _value.sent
          : sent // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationChannelImplCopyWith<$Res>
    implements $NotificationChannelCopyWith<$Res> {
  factory _$$NotificationChannelImplCopyWith(_$NotificationChannelImpl value,
          $Res Function(_$NotificationChannelImpl) then) =
      __$$NotificationChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool sent, DateTime? readAt, DateTime? sentAt});
}

/// @nodoc
class __$$NotificationChannelImplCopyWithImpl<$Res>
    extends _$NotificationChannelCopyWithImpl<$Res, _$NotificationChannelImpl>
    implements _$$NotificationChannelImplCopyWith<$Res> {
  __$$NotificationChannelImplCopyWithImpl(_$NotificationChannelImpl _value,
      $Res Function(_$NotificationChannelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sent = null,
    Object? readAt = freezed,
    Object? sentAt = freezed,
  }) {
    return _then(_$NotificationChannelImpl(
      sent: null == sent
          ? _value.sent
          : sent // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationChannelImpl implements _NotificationChannel {
  const _$NotificationChannelImpl(
      {this.sent = false, this.readAt, this.sentAt});

  factory _$NotificationChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationChannelImplFromJson(json);

  @override
  @JsonKey()
  final bool sent;
  @override
  final DateTime? readAt;
  @override
  final DateTime? sentAt;

  @override
  String toString() {
    return 'NotificationChannel(sent: $sent, readAt: $readAt, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationChannelImpl &&
            (identical(other.sent, sent) || other.sent == sent) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sent, readAt, sentAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationChannelImplCopyWith<_$NotificationChannelImpl> get copyWith =>
      __$$NotificationChannelImplCopyWithImpl<_$NotificationChannelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationChannelImplToJson(
      this,
    );
  }
}

abstract class _NotificationChannel implements NotificationChannel {
  const factory _NotificationChannel(
      {final bool sent,
      final DateTime? readAt,
      final DateTime? sentAt}) = _$NotificationChannelImpl;

  factory _NotificationChannel.fromJson(Map<String, dynamic> json) =
      _$NotificationChannelImpl.fromJson;

  @override
  bool get sent;
  @override
  DateTime? get readAt;
  @override
  DateTime? get sentAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationChannelImplCopyWith<_$NotificationChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationChannels _$NotificationChannelsFromJson(Map<String, dynamic> json) {
  return _NotificationChannels.fromJson(json);
}

/// @nodoc
mixin _$NotificationChannels {
  NotificationChannel get inApp => throw _privateConstructorUsedError;
  NotificationChannel get email => throw _privateConstructorUsedError;
  NotificationChannel get push => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationChannelsCopyWith<NotificationChannels> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationChannelsCopyWith<$Res> {
  factory $NotificationChannelsCopyWith(NotificationChannels value,
          $Res Function(NotificationChannels) then) =
      _$NotificationChannelsCopyWithImpl<$Res, NotificationChannels>;
  @useResult
  $Res call(
      {NotificationChannel inApp,
      NotificationChannel email,
      NotificationChannel push});

  $NotificationChannelCopyWith<$Res> get inApp;
  $NotificationChannelCopyWith<$Res> get email;
  $NotificationChannelCopyWith<$Res> get push;
}

/// @nodoc
class _$NotificationChannelsCopyWithImpl<$Res,
        $Val extends NotificationChannels>
    implements $NotificationChannelsCopyWith<$Res> {
  _$NotificationChannelsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inApp = null,
    Object? email = null,
    Object? push = null,
  }) {
    return _then(_value.copyWith(
      inApp: null == inApp
          ? _value.inApp
          : inApp // ignore: cast_nullable_to_non_nullable
              as NotificationChannel,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as NotificationChannel,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as NotificationChannel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationChannelCopyWith<$Res> get inApp {
    return $NotificationChannelCopyWith<$Res>(_value.inApp, (value) {
      return _then(_value.copyWith(inApp: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationChannelCopyWith<$Res> get email {
    return $NotificationChannelCopyWith<$Res>(_value.email, (value) {
      return _then(_value.copyWith(email: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationChannelCopyWith<$Res> get push {
    return $NotificationChannelCopyWith<$Res>(_value.push, (value) {
      return _then(_value.copyWith(push: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationChannelsImplCopyWith<$Res>
    implements $NotificationChannelsCopyWith<$Res> {
  factory _$$NotificationChannelsImplCopyWith(_$NotificationChannelsImpl value,
          $Res Function(_$NotificationChannelsImpl) then) =
      __$$NotificationChannelsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NotificationChannel inApp,
      NotificationChannel email,
      NotificationChannel push});

  @override
  $NotificationChannelCopyWith<$Res> get inApp;
  @override
  $NotificationChannelCopyWith<$Res> get email;
  @override
  $NotificationChannelCopyWith<$Res> get push;
}

/// @nodoc
class __$$NotificationChannelsImplCopyWithImpl<$Res>
    extends _$NotificationChannelsCopyWithImpl<$Res, _$NotificationChannelsImpl>
    implements _$$NotificationChannelsImplCopyWith<$Res> {
  __$$NotificationChannelsImplCopyWithImpl(_$NotificationChannelsImpl _value,
      $Res Function(_$NotificationChannelsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inApp = null,
    Object? email = null,
    Object? push = null,
  }) {
    return _then(_$NotificationChannelsImpl(
      inApp: null == inApp
          ? _value.inApp
          : inApp // ignore: cast_nullable_to_non_nullable
              as NotificationChannel,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as NotificationChannel,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as NotificationChannel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationChannelsImpl implements _NotificationChannels {
  const _$NotificationChannelsImpl(
      {this.inApp = const NotificationChannel(),
      this.email = const NotificationChannel(),
      this.push = const NotificationChannel()});

  factory _$NotificationChannelsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationChannelsImplFromJson(json);

  @override
  @JsonKey()
  final NotificationChannel inApp;
  @override
  @JsonKey()
  final NotificationChannel email;
  @override
  @JsonKey()
  final NotificationChannel push;

  @override
  String toString() {
    return 'NotificationChannels(inApp: $inApp, email: $email, push: $push)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationChannelsImpl &&
            (identical(other.inApp, inApp) || other.inApp == inApp) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.push, push) || other.push == push));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, inApp, email, push);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationChannelsImplCopyWith<_$NotificationChannelsImpl>
      get copyWith =>
          __$$NotificationChannelsImplCopyWithImpl<_$NotificationChannelsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationChannelsImplToJson(
      this,
    );
  }
}

abstract class _NotificationChannels implements NotificationChannels {
  const factory _NotificationChannels(
      {final NotificationChannel inApp,
      final NotificationChannel email,
      final NotificationChannel push}) = _$NotificationChannelsImpl;

  factory _NotificationChannels.fromJson(Map<String, dynamic> json) =
      _$NotificationChannelsImpl.fromJson;

  @override
  NotificationChannel get inApp;
  @override
  NotificationChannel get email;
  @override
  NotificationChannel get push;
  @override
  @JsonKey(ignore: true)
  _$$NotificationChannelsImplCopyWith<_$NotificationChannelsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) {
  return _NotificationData.fromJson(json);
}

/// @nodoc
mixin _$NotificationData {
  String? get probationRecordId => throw _privateConstructorUsedError;
  int? get milestoneDay => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationDataCopyWith<NotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationDataCopyWith<$Res> {
  factory $NotificationDataCopyWith(
          NotificationData value, $Res Function(NotificationData) then) =
      _$NotificationDataCopyWithImpl<$Res, NotificationData>;
  @useResult
  $Res call({String? probationRecordId, int? milestoneDay});
}

/// @nodoc
class _$NotificationDataCopyWithImpl<$Res, $Val extends NotificationData>
    implements $NotificationDataCopyWith<$Res> {
  _$NotificationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? probationRecordId = freezed,
    Object? milestoneDay = freezed,
  }) {
    return _then(_value.copyWith(
      probationRecordId: freezed == probationRecordId
          ? _value.probationRecordId
          : probationRecordId // ignore: cast_nullable_to_non_nullable
              as String?,
      milestoneDay: freezed == milestoneDay
          ? _value.milestoneDay
          : milestoneDay // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationDataImplCopyWith<$Res>
    implements $NotificationDataCopyWith<$Res> {
  factory _$$NotificationDataImplCopyWith(_$NotificationDataImpl value,
          $Res Function(_$NotificationDataImpl) then) =
      __$$NotificationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? probationRecordId, int? milestoneDay});
}

/// @nodoc
class __$$NotificationDataImplCopyWithImpl<$Res>
    extends _$NotificationDataCopyWithImpl<$Res, _$NotificationDataImpl>
    implements _$$NotificationDataImplCopyWith<$Res> {
  __$$NotificationDataImplCopyWithImpl(_$NotificationDataImpl _value,
      $Res Function(_$NotificationDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? probationRecordId = freezed,
    Object? milestoneDay = freezed,
  }) {
    return _then(_$NotificationDataImpl(
      probationRecordId: freezed == probationRecordId
          ? _value.probationRecordId
          : probationRecordId // ignore: cast_nullable_to_non_nullable
              as String?,
      milestoneDay: freezed == milestoneDay
          ? _value.milestoneDay
          : milestoneDay // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationDataImpl implements _NotificationData {
  const _$NotificationDataImpl({this.probationRecordId, this.milestoneDay});

  factory _$NotificationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationDataImplFromJson(json);

  @override
  final String? probationRecordId;
  @override
  final int? milestoneDay;

  @override
  String toString() {
    return 'NotificationData(probationRecordId: $probationRecordId, milestoneDay: $milestoneDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationDataImpl &&
            (identical(other.probationRecordId, probationRecordId) ||
                other.probationRecordId == probationRecordId) &&
            (identical(other.milestoneDay, milestoneDay) ||
                other.milestoneDay == milestoneDay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, probationRecordId, milestoneDay);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationDataImplCopyWith<_$NotificationDataImpl> get copyWith =>
      __$$NotificationDataImplCopyWithImpl<_$NotificationDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationDataImplToJson(
      this,
    );
  }
}

abstract class _NotificationData implements NotificationData {
  const factory _NotificationData(
      {final String? probationRecordId,
      final int? milestoneDay}) = _$NotificationDataImpl;

  factory _NotificationData.fromJson(Map<String, dynamic> json) =
      _$NotificationDataImpl.fromJson;

  @override
  String? get probationRecordId;
  @override
  int? get milestoneDay;
  @override
  @JsonKey(ignore: true)
  _$$NotificationDataImplCopyWith<_$NotificationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) {
  return _AppNotification.fromJson(json);
}

/// @nodoc
mixin _$AppNotification {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  NotificationData? get data => throw _privateConstructorUsedError;
  NotificationChannels get channels => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Virtual field
  bool get isRead => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppNotificationCopyWith<AppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationCopyWith<$Res> {
  factory $AppNotificationCopyWith(
          AppNotification value, $Res Function(AppNotification) then) =
      _$AppNotificationCopyWithImpl<$Res, AppNotification>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      NotificationType type,
      String title,
      String message,
      NotificationData? data,
      NotificationChannels channels,
      DateTime? createdAt,
      bool isRead});

  $NotificationDataCopyWith<$Res>? get data;
  $NotificationChannelsCopyWith<$Res> get channels;
}

/// @nodoc
class _$AppNotificationCopyWithImpl<$Res, $Val extends AppNotification>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? data = freezed,
    Object? channels = null,
    Object? createdAt = freezed,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NotificationData?,
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as NotificationChannels,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $NotificationDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationChannelsCopyWith<$Res> get channels {
    return $NotificationChannelsCopyWith<$Res>(_value.channels, (value) {
      return _then(_value.copyWith(channels: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppNotificationImplCopyWith<$Res>
    implements $AppNotificationCopyWith<$Res> {
  factory _$$AppNotificationImplCopyWith(_$AppNotificationImpl value,
          $Res Function(_$AppNotificationImpl) then) =
      __$$AppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      NotificationType type,
      String title,
      String message,
      NotificationData? data,
      NotificationChannels channels,
      DateTime? createdAt,
      bool isRead});

  @override
  $NotificationDataCopyWith<$Res>? get data;
  @override
  $NotificationChannelsCopyWith<$Res> get channels;
}

/// @nodoc
class __$$AppNotificationImplCopyWithImpl<$Res>
    extends _$AppNotificationCopyWithImpl<$Res, _$AppNotificationImpl>
    implements _$$AppNotificationImplCopyWith<$Res> {
  __$$AppNotificationImplCopyWithImpl(
      _$AppNotificationImpl _value, $Res Function(_$AppNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? data = freezed,
    Object? channels = null,
    Object? createdAt = freezed,
    Object? isRead = null,
  }) {
    return _then(_$AppNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NotificationData?,
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as NotificationChannels,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppNotificationImpl implements _AppNotification {
  const _$AppNotificationImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.userId,
      required this.type,
      required this.title,
      required this.message,
      this.data,
      this.channels = const NotificationChannels(),
      this.createdAt,
      this.isRead = false});

  factory _$AppNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppNotificationImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final NotificationType type;
  @override
  final String title;
  @override
  final String message;
  @override
  final NotificationData? data;
  @override
  @JsonKey()
  final NotificationChannels channels;
  @override
  final DateTime? createdAt;
// Virtual field
  @override
  @JsonKey()
  final bool isRead;

  @override
  String toString() {
    return 'AppNotification(id: $id, userId: $userId, type: $type, title: $title, message: $message, data: $data, channels: $channels, createdAt: $createdAt, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.channels, channels) ||
                other.channels == channels) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, type, title, message,
      data, channels, createdAt, isRead);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      __$$AppNotificationImplCopyWithImpl<_$AppNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationImplToJson(
      this,
    );
  }
}

abstract class _AppNotification implements AppNotification {
  const factory _AppNotification(
      {@JsonKey(name: '_id') required final String id,
      required final String userId,
      required final NotificationType type,
      required final String title,
      required final String message,
      final NotificationData? data,
      final NotificationChannels channels,
      final DateTime? createdAt,
      final bool isRead}) = _$AppNotificationImpl;

  factory _AppNotification.fromJson(Map<String, dynamic> json) =
      _$AppNotificationImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  NotificationType get type;
  @override
  String get title;
  @override
  String get message;
  @override
  NotificationData? get data;
  @override
  NotificationChannels get channels;
  @override
  DateTime? get createdAt;
  @override // Virtual field
  bool get isRead;
  @override
  @JsonKey(ignore: true)
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationListResponse _$NotificationListResponseFromJson(
    Map<String, dynamic> json) {
  return _NotificationListResponse.fromJson(json);
}

/// @nodoc
mixin _$NotificationListResponse {
  List<AppNotification> get notifications => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationListResponseCopyWith<NotificationListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationListResponseCopyWith<$Res> {
  factory $NotificationListResponseCopyWith(NotificationListResponse value,
          $Res Function(NotificationListResponse) then) =
      _$NotificationListResponseCopyWithImpl<$Res, NotificationListResponse>;
  @useResult
  $Res call(
      {List<AppNotification> notifications,
      int unreadCount,
      int total,
      int page,
      int limit});
}

/// @nodoc
class _$NotificationListResponseCopyWithImpl<$Res,
        $Val extends NotificationListResponse>
    implements $NotificationListResponseCopyWith<$Res> {
  _$NotificationListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? unreadCount = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<AppNotification>,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationListResponseImplCopyWith<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  factory _$$NotificationListResponseImplCopyWith(
          _$NotificationListResponseImpl value,
          $Res Function(_$NotificationListResponseImpl) then) =
      __$$NotificationListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AppNotification> notifications,
      int unreadCount,
      int total,
      int page,
      int limit});
}

/// @nodoc
class __$$NotificationListResponseImplCopyWithImpl<$Res>
    extends _$NotificationListResponseCopyWithImpl<$Res,
        _$NotificationListResponseImpl>
    implements _$$NotificationListResponseImplCopyWith<$Res> {
  __$$NotificationListResponseImplCopyWithImpl(
      _$NotificationListResponseImpl _value,
      $Res Function(_$NotificationListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? unreadCount = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_$NotificationListResponseImpl(
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<AppNotification>,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationListResponseImpl implements _NotificationListResponse {
  const _$NotificationListResponseImpl(
      {required final List<AppNotification> notifications,
      required this.unreadCount,
      required this.total,
      required this.page,
      required this.limit})
      : _notifications = notifications;

  factory _$NotificationListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationListResponseImplFromJson(json);

  final List<AppNotification> _notifications;
  @override
  List<AppNotification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  final int unreadCount;
  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;

  @override
  String toString() {
    return 'NotificationListResponse(notifications: $notifications, unreadCount: $unreadCount, total: $total, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationListResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_notifications),
      unreadCount,
      total,
      page,
      limit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationListResponseImplCopyWith<_$NotificationListResponseImpl>
      get copyWith => __$$NotificationListResponseImplCopyWithImpl<
          _$NotificationListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationListResponseImplToJson(
      this,
    );
  }
}

abstract class _NotificationListResponse implements NotificationListResponse {
  const factory _NotificationListResponse(
      {required final List<AppNotification> notifications,
      required final int unreadCount,
      required final int total,
      required final int page,
      required final int limit}) = _$NotificationListResponseImpl;

  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) =
      _$NotificationListResponseImpl.fromJson;

  @override
  List<AppNotification> get notifications;
  @override
  int get unreadCount;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  @JsonKey(ignore: true)
  _$$NotificationListResponseImplCopyWith<_$NotificationListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
