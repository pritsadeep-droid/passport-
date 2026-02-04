// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Milestone _$MilestoneFromJson(Map<String, dynamic> json) {
  return _Milestone.fromJson(json);
}

/// @nodoc
mixin _$Milestone {
  int get day => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  MilestoneStatus get status => throw _privateConstructorUsedError;
  SelfAssessment? get selfAssessment => throw _privateConstructorUsedError;
  SupervisorAssessment? get supervisorAssessment =>
      throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MilestoneCopyWith<Milestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MilestoneCopyWith<$Res> {
  factory $MilestoneCopyWith(Milestone value, $Res Function(Milestone) then) =
      _$MilestoneCopyWithImpl<$Res, Milestone>;
  @useResult
  $Res call(
      {int day,
      DateTime dueDate,
      MilestoneStatus status,
      SelfAssessment? selfAssessment,
      SupervisorAssessment? supervisorAssessment,
      DateTime? approvedAt,
      String? approvedBy,
      String? rejectionReason});

  $SelfAssessmentCopyWith<$Res>? get selfAssessment;
  $SupervisorAssessmentCopyWith<$Res>? get supervisorAssessment;
}

/// @nodoc
class _$MilestoneCopyWithImpl<$Res, $Val extends Milestone>
    implements $MilestoneCopyWith<$Res> {
  _$MilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? dueDate = null,
    Object? status = null,
    Object? selfAssessment = freezed,
    Object? supervisorAssessment = freezed,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(_value.copyWith(
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MilestoneStatus,
      selfAssessment: freezed == selfAssessment
          ? _value.selfAssessment
          : selfAssessment // ignore: cast_nullable_to_non_nullable
              as SelfAssessment?,
      supervisorAssessment: freezed == supervisorAssessment
          ? _value.supervisorAssessment
          : supervisorAssessment // ignore: cast_nullable_to_non_nullable
              as SupervisorAssessment?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SelfAssessmentCopyWith<$Res>? get selfAssessment {
    if (_value.selfAssessment == null) {
      return null;
    }

    return $SelfAssessmentCopyWith<$Res>(_value.selfAssessment!, (value) {
      return _then(_value.copyWith(selfAssessment: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SupervisorAssessmentCopyWith<$Res>? get supervisorAssessment {
    if (_value.supervisorAssessment == null) {
      return null;
    }

    return $SupervisorAssessmentCopyWith<$Res>(_value.supervisorAssessment!,
        (value) {
      return _then(_value.copyWith(supervisorAssessment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MilestoneImplCopyWith<$Res>
    implements $MilestoneCopyWith<$Res> {
  factory _$$MilestoneImplCopyWith(
          _$MilestoneImpl value, $Res Function(_$MilestoneImpl) then) =
      __$$MilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int day,
      DateTime dueDate,
      MilestoneStatus status,
      SelfAssessment? selfAssessment,
      SupervisorAssessment? supervisorAssessment,
      DateTime? approvedAt,
      String? approvedBy,
      String? rejectionReason});

  @override
  $SelfAssessmentCopyWith<$Res>? get selfAssessment;
  @override
  $SupervisorAssessmentCopyWith<$Res>? get supervisorAssessment;
}

/// @nodoc
class __$$MilestoneImplCopyWithImpl<$Res>
    extends _$MilestoneCopyWithImpl<$Res, _$MilestoneImpl>
    implements _$$MilestoneImplCopyWith<$Res> {
  __$$MilestoneImplCopyWithImpl(
      _$MilestoneImpl _value, $Res Function(_$MilestoneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? dueDate = null,
    Object? status = null,
    Object? selfAssessment = freezed,
    Object? supervisorAssessment = freezed,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(_$MilestoneImpl(
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MilestoneStatus,
      selfAssessment: freezed == selfAssessment
          ? _value.selfAssessment
          : selfAssessment // ignore: cast_nullable_to_non_nullable
              as SelfAssessment?,
      supervisorAssessment: freezed == supervisorAssessment
          ? _value.supervisorAssessment
          : supervisorAssessment // ignore: cast_nullable_to_non_nullable
              as SupervisorAssessment?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MilestoneImpl implements _Milestone {
  const _$MilestoneImpl(
      {required this.day,
      required this.dueDate,
      this.status = MilestoneStatus.upcoming,
      this.selfAssessment,
      this.supervisorAssessment,
      this.approvedAt,
      this.approvedBy,
      this.rejectionReason});

  factory _$MilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$MilestoneImplFromJson(json);

  @override
  final int day;
  @override
  final DateTime dueDate;
  @override
  @JsonKey()
  final MilestoneStatus status;
  @override
  final SelfAssessment? selfAssessment;
  @override
  final SupervisorAssessment? supervisorAssessment;
  @override
  final DateTime? approvedAt;
  @override
  final String? approvedBy;
  @override
  final String? rejectionReason;

  @override
  String toString() {
    return 'Milestone(day: $day, dueDate: $dueDate, status: $status, selfAssessment: $selfAssessment, supervisorAssessment: $supervisorAssessment, approvedAt: $approvedAt, approvedBy: $approvedBy, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MilestoneImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.selfAssessment, selfAssessment) ||
                other.selfAssessment == selfAssessment) &&
            (identical(other.supervisorAssessment, supervisorAssessment) ||
                other.supervisorAssessment == supervisorAssessment) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      day,
      dueDate,
      status,
      selfAssessment,
      supervisorAssessment,
      approvedAt,
      approvedBy,
      rejectionReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MilestoneImplCopyWith<_$MilestoneImpl> get copyWith =>
      __$$MilestoneImplCopyWithImpl<_$MilestoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MilestoneImplToJson(
      this,
    );
  }
}

abstract class _Milestone implements Milestone {
  const factory _Milestone(
      {required final int day,
      required final DateTime dueDate,
      final MilestoneStatus status,
      final SelfAssessment? selfAssessment,
      final SupervisorAssessment? supervisorAssessment,
      final DateTime? approvedAt,
      final String? approvedBy,
      final String? rejectionReason}) = _$MilestoneImpl;

  factory _Milestone.fromJson(Map<String, dynamic> json) =
      _$MilestoneImpl.fromJson;

  @override
  int get day;
  @override
  DateTime get dueDate;
  @override
  MilestoneStatus get status;
  @override
  SelfAssessment? get selfAssessment;
  @override
  SupervisorAssessment? get supervisorAssessment;
  @override
  DateTime? get approvedAt;
  @override
  String? get approvedBy;
  @override
  String? get rejectionReason;
  @override
  @JsonKey(ignore: true)
  _$$MilestoneImplCopyWith<_$MilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApproveMilestoneRequest _$ApproveMilestoneRequestFromJson(
    Map<String, dynamic> json) {
  return _ApproveMilestoneRequest.fromJson(json);
}

/// @nodoc
mixin _$ApproveMilestoneRequest {
  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApproveMilestoneRequestCopyWith<ApproveMilestoneRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApproveMilestoneRequestCopyWith<$Res> {
  factory $ApproveMilestoneRequestCopyWith(ApproveMilestoneRequest value,
          $Res Function(ApproveMilestoneRequest) then) =
      _$ApproveMilestoneRequestCopyWithImpl<$Res, ApproveMilestoneRequest>;
  @useResult
  $Res call({String? comment});
}

/// @nodoc
class _$ApproveMilestoneRequestCopyWithImpl<$Res,
        $Val extends ApproveMilestoneRequest>
    implements $ApproveMilestoneRequestCopyWith<$Res> {
  _$ApproveMilestoneRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApproveMilestoneRequestImplCopyWith<$Res>
    implements $ApproveMilestoneRequestCopyWith<$Res> {
  factory _$$ApproveMilestoneRequestImplCopyWith(
          _$ApproveMilestoneRequestImpl value,
          $Res Function(_$ApproveMilestoneRequestImpl) then) =
      __$$ApproveMilestoneRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? comment});
}

/// @nodoc
class __$$ApproveMilestoneRequestImplCopyWithImpl<$Res>
    extends _$ApproveMilestoneRequestCopyWithImpl<$Res,
        _$ApproveMilestoneRequestImpl>
    implements _$$ApproveMilestoneRequestImplCopyWith<$Res> {
  __$$ApproveMilestoneRequestImplCopyWithImpl(
      _$ApproveMilestoneRequestImpl _value,
      $Res Function(_$ApproveMilestoneRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = freezed,
  }) {
    return _then(_$ApproveMilestoneRequestImpl(
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApproveMilestoneRequestImpl implements _ApproveMilestoneRequest {
  const _$ApproveMilestoneRequestImpl({this.comment});

  factory _$ApproveMilestoneRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApproveMilestoneRequestImplFromJson(json);

  @override
  final String? comment;

  @override
  String toString() {
    return 'ApproveMilestoneRequest(comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApproveMilestoneRequestImpl &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApproveMilestoneRequestImplCopyWith<_$ApproveMilestoneRequestImpl>
      get copyWith => __$$ApproveMilestoneRequestImplCopyWithImpl<
          _$ApproveMilestoneRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApproveMilestoneRequestImplToJson(
      this,
    );
  }
}

abstract class _ApproveMilestoneRequest implements ApproveMilestoneRequest {
  const factory _ApproveMilestoneRequest({final String? comment}) =
      _$ApproveMilestoneRequestImpl;

  factory _ApproveMilestoneRequest.fromJson(Map<String, dynamic> json) =
      _$ApproveMilestoneRequestImpl.fromJson;

  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$ApproveMilestoneRequestImplCopyWith<_$ApproveMilestoneRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RejectMilestoneRequest _$RejectMilestoneRequestFromJson(
    Map<String, dynamic> json) {
  return _RejectMilestoneRequest.fromJson(json);
}

/// @nodoc
mixin _$RejectMilestoneRequest {
  String get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RejectMilestoneRequestCopyWith<RejectMilestoneRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectMilestoneRequestCopyWith<$Res> {
  factory $RejectMilestoneRequestCopyWith(RejectMilestoneRequest value,
          $Res Function(RejectMilestoneRequest) then) =
      _$RejectMilestoneRequestCopyWithImpl<$Res, RejectMilestoneRequest>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class _$RejectMilestoneRequestCopyWithImpl<$Res,
        $Val extends RejectMilestoneRequest>
    implements $RejectMilestoneRequestCopyWith<$Res> {
  _$RejectMilestoneRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectMilestoneRequestImplCopyWith<$Res>
    implements $RejectMilestoneRequestCopyWith<$Res> {
  factory _$$RejectMilestoneRequestImplCopyWith(
          _$RejectMilestoneRequestImpl value,
          $Res Function(_$RejectMilestoneRequestImpl) then) =
      __$$RejectMilestoneRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$RejectMilestoneRequestImplCopyWithImpl<$Res>
    extends _$RejectMilestoneRequestCopyWithImpl<$Res,
        _$RejectMilestoneRequestImpl>
    implements _$$RejectMilestoneRequestImplCopyWith<$Res> {
  __$$RejectMilestoneRequestImplCopyWithImpl(
      _$RejectMilestoneRequestImpl _value,
      $Res Function(_$RejectMilestoneRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$RejectMilestoneRequestImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectMilestoneRequestImpl implements _RejectMilestoneRequest {
  const _$RejectMilestoneRequestImpl({required this.reason});

  factory _$RejectMilestoneRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RejectMilestoneRequestImplFromJson(json);

  @override
  final String reason;

  @override
  String toString() {
    return 'RejectMilestoneRequest(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectMilestoneRequestImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectMilestoneRequestImplCopyWith<_$RejectMilestoneRequestImpl>
      get copyWith => __$$RejectMilestoneRequestImplCopyWithImpl<
          _$RejectMilestoneRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectMilestoneRequestImplToJson(
      this,
    );
  }
}

abstract class _RejectMilestoneRequest implements RejectMilestoneRequest {
  const factory _RejectMilestoneRequest({required final String reason}) =
      _$RejectMilestoneRequestImpl;

  factory _RejectMilestoneRequest.fromJson(Map<String, dynamic> json) =
      _$RejectMilestoneRequestImpl.fromJson;

  @override
  String get reason;
  @override
  @JsonKey(ignore: true)
  _$$RejectMilestoneRequestImplCopyWith<_$RejectMilestoneRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
