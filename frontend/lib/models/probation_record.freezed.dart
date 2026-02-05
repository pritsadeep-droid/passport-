// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'probation_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinalDecisionInfo _$FinalDecisionInfoFromJson(Map<String, dynamic> json) {
  return _FinalDecisionInfo.fromJson(json);
}

/// @nodoc
mixin _$FinalDecisionInfo {
  FinalDecision get decision => throw _privateConstructorUsedError;
  String? get decidedBy => throw _privateConstructorUsedError;
  DateTime? get decidedAt => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinalDecisionInfoCopyWith<FinalDecisionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinalDecisionInfoCopyWith<$Res> {
  factory $FinalDecisionInfoCopyWith(
          FinalDecisionInfo value, $Res Function(FinalDecisionInfo) then) =
      _$FinalDecisionInfoCopyWithImpl<$Res, FinalDecisionInfo>;
  @useResult
  $Res call(
      {FinalDecision decision,
      String? decidedBy,
      DateTime? decidedAt,
      String? reason});
}

/// @nodoc
class _$FinalDecisionInfoCopyWithImpl<$Res, $Val extends FinalDecisionInfo>
    implements $FinalDecisionInfoCopyWith<$Res> {
  _$FinalDecisionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decision = null,
    Object? decidedBy = freezed,
    Object? decidedAt = freezed,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as FinalDecision,
      decidedBy: freezed == decidedBy
          ? _value.decidedBy
          : decidedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      decidedAt: freezed == decidedAt
          ? _value.decidedAt
          : decidedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinalDecisionInfoImplCopyWith<$Res>
    implements $FinalDecisionInfoCopyWith<$Res> {
  factory _$$FinalDecisionInfoImplCopyWith(_$FinalDecisionInfoImpl value,
          $Res Function(_$FinalDecisionInfoImpl) then) =
      __$$FinalDecisionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FinalDecision decision,
      String? decidedBy,
      DateTime? decidedAt,
      String? reason});
}

/// @nodoc
class __$$FinalDecisionInfoImplCopyWithImpl<$Res>
    extends _$FinalDecisionInfoCopyWithImpl<$Res, _$FinalDecisionInfoImpl>
    implements _$$FinalDecisionInfoImplCopyWith<$Res> {
  __$$FinalDecisionInfoImplCopyWithImpl(_$FinalDecisionInfoImpl _value,
      $Res Function(_$FinalDecisionInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decision = null,
    Object? decidedBy = freezed,
    Object? decidedAt = freezed,
    Object? reason = freezed,
  }) {
    return _then(_$FinalDecisionInfoImpl(
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as FinalDecision,
      decidedBy: freezed == decidedBy
          ? _value.decidedBy
          : decidedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      decidedAt: freezed == decidedAt
          ? _value.decidedAt
          : decidedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinalDecisionInfoImpl implements _FinalDecisionInfo {
  const _$FinalDecisionInfoImpl(
      {required this.decision, this.decidedBy, this.decidedAt, this.reason});

  factory _$FinalDecisionInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinalDecisionInfoImplFromJson(json);

  @override
  final FinalDecision decision;
  @override
  final String? decidedBy;
  @override
  final DateTime? decidedAt;
  @override
  final String? reason;

  @override
  String toString() {
    return 'FinalDecisionInfo(decision: $decision, decidedBy: $decidedBy, decidedAt: $decidedAt, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinalDecisionInfoImpl &&
            (identical(other.decision, decision) ||
                other.decision == decision) &&
            (identical(other.decidedBy, decidedBy) ||
                other.decidedBy == decidedBy) &&
            (identical(other.decidedAt, decidedAt) ||
                other.decidedAt == decidedAt) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, decision, decidedBy, decidedAt, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinalDecisionInfoImplCopyWith<_$FinalDecisionInfoImpl> get copyWith =>
      __$$FinalDecisionInfoImplCopyWithImpl<_$FinalDecisionInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinalDecisionInfoImplToJson(
      this,
    );
  }
}

abstract class _FinalDecisionInfo implements FinalDecisionInfo {
  const factory _FinalDecisionInfo(
      {required final FinalDecision decision,
      final String? decidedBy,
      final DateTime? decidedAt,
      final String? reason}) = _$FinalDecisionInfoImpl;

  factory _FinalDecisionInfo.fromJson(Map<String, dynamic> json) =
      _$FinalDecisionInfoImpl.fromJson;

  @override
  FinalDecision get decision;
  @override
  String? get decidedBy;
  @override
  DateTime? get decidedAt;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$FinalDecisionInfoImplCopyWith<_$FinalDecisionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProbationRecord _$ProbationRecordFromJson(Map<String, dynamic> json) {
  return _ProbationRecord.fromJson(json);
}

/// @nodoc
mixin _$ProbationRecord {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @StringOrUserIdConverter()
  String get employeeId => throw _privateConstructorUsedError;
  @StringOrUserIdConverter()
  String get supervisorId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  int get probationDays => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  ProbationStatus get status => throw _privateConstructorUsedError;
  List<Kpi> get kpis => throw _privateConstructorUsedError;
  List<Milestone> get milestones => throw _privateConstructorUsedError;
  FinalDecisionInfo? get finalDecision => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Virtual fields
  int? get daysRemaining => throw _privateConstructorUsedError;
  int? get progressPercentage =>
      throw _privateConstructorUsedError; // Populated fields - read from employeeId/supervisorId if they contain objects
  @JsonKey(readValue: _readEmployeeFromJson)
  @PopulatedUserConverter()
  User? get employee => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readSupervisorFromJson)
  @PopulatedUserConverter()
  User? get supervisor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProbationRecordCopyWith<ProbationRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProbationRecordCopyWith<$Res> {
  factory $ProbationRecordCopyWith(
          ProbationRecord value, $Res Function(ProbationRecord) then) =
      _$ProbationRecordCopyWithImpl<$Res, ProbationRecord>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      @StringOrUserIdConverter() String employeeId,
      @StringOrUserIdConverter() String supervisorId,
      DateTime startDate,
      int probationDays,
      DateTime endDate,
      ProbationStatus status,
      List<Kpi> kpis,
      List<Milestone> milestones,
      FinalDecisionInfo? finalDecision,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? daysRemaining,
      int? progressPercentage,
      @JsonKey(readValue: _readEmployeeFromJson)
      @PopulatedUserConverter()
      User? employee,
      @JsonKey(readValue: _readSupervisorFromJson)
      @PopulatedUserConverter()
      User? supervisor});

  $FinalDecisionInfoCopyWith<$Res>? get finalDecision;
  $UserCopyWith<$Res>? get employee;
  $UserCopyWith<$Res>? get supervisor;
}

/// @nodoc
class _$ProbationRecordCopyWithImpl<$Res, $Val extends ProbationRecord>
    implements $ProbationRecordCopyWith<$Res> {
  _$ProbationRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? supervisorId = null,
    Object? startDate = null,
    Object? probationDays = null,
    Object? endDate = null,
    Object? status = null,
    Object? kpis = null,
    Object? milestones = null,
    Object? finalDecision = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? daysRemaining = freezed,
    Object? progressPercentage = freezed,
    Object? employee = freezed,
    Object? supervisor = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      supervisorId: null == supervisorId
          ? _value.supervisorId
          : supervisorId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      probationDays: null == probationDays
          ? _value.probationDays
          : probationDays // ignore: cast_nullable_to_non_nullable
              as int,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProbationStatus,
      kpis: null == kpis
          ? _value.kpis
          : kpis // ignore: cast_nullable_to_non_nullable
              as List<Kpi>,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<Milestone>,
      finalDecision: freezed == finalDecision
          ? _value.finalDecision
          : finalDecision // ignore: cast_nullable_to_non_nullable
              as FinalDecisionInfo?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysRemaining: freezed == daysRemaining
          ? _value.daysRemaining
          : daysRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      progressPercentage: freezed == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as int?,
      employee: freezed == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as User?,
      supervisor: freezed == supervisor
          ? _value.supervisor
          : supervisor // ignore: cast_nullable_to_non_nullable
              as User?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FinalDecisionInfoCopyWith<$Res>? get finalDecision {
    if (_value.finalDecision == null) {
      return null;
    }

    return $FinalDecisionInfoCopyWith<$Res>(_value.finalDecision!, (value) {
      return _then(_value.copyWith(finalDecision: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get employee {
    if (_value.employee == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.employee!, (value) {
      return _then(_value.copyWith(employee: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get supervisor {
    if (_value.supervisor == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.supervisor!, (value) {
      return _then(_value.copyWith(supervisor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProbationRecordImplCopyWith<$Res>
    implements $ProbationRecordCopyWith<$Res> {
  factory _$$ProbationRecordImplCopyWith(_$ProbationRecordImpl value,
          $Res Function(_$ProbationRecordImpl) then) =
      __$$ProbationRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      @StringOrUserIdConverter() String employeeId,
      @StringOrUserIdConverter() String supervisorId,
      DateTime startDate,
      int probationDays,
      DateTime endDate,
      ProbationStatus status,
      List<Kpi> kpis,
      List<Milestone> milestones,
      FinalDecisionInfo? finalDecision,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? daysRemaining,
      int? progressPercentage,
      @JsonKey(readValue: _readEmployeeFromJson)
      @PopulatedUserConverter()
      User? employee,
      @JsonKey(readValue: _readSupervisorFromJson)
      @PopulatedUserConverter()
      User? supervisor});

  @override
  $FinalDecisionInfoCopyWith<$Res>? get finalDecision;
  @override
  $UserCopyWith<$Res>? get employee;
  @override
  $UserCopyWith<$Res>? get supervisor;
}

/// @nodoc
class __$$ProbationRecordImplCopyWithImpl<$Res>
    extends _$ProbationRecordCopyWithImpl<$Res, _$ProbationRecordImpl>
    implements _$$ProbationRecordImplCopyWith<$Res> {
  __$$ProbationRecordImplCopyWithImpl(
      _$ProbationRecordImpl _value, $Res Function(_$ProbationRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? supervisorId = null,
    Object? startDate = null,
    Object? probationDays = null,
    Object? endDate = null,
    Object? status = null,
    Object? kpis = null,
    Object? milestones = null,
    Object? finalDecision = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? daysRemaining = freezed,
    Object? progressPercentage = freezed,
    Object? employee = freezed,
    Object? supervisor = freezed,
  }) {
    return _then(_$ProbationRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      supervisorId: null == supervisorId
          ? _value.supervisorId
          : supervisorId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      probationDays: null == probationDays
          ? _value.probationDays
          : probationDays // ignore: cast_nullable_to_non_nullable
              as int,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProbationStatus,
      kpis: null == kpis
          ? _value._kpis
          : kpis // ignore: cast_nullable_to_non_nullable
              as List<Kpi>,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<Milestone>,
      finalDecision: freezed == finalDecision
          ? _value.finalDecision
          : finalDecision // ignore: cast_nullable_to_non_nullable
              as FinalDecisionInfo?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysRemaining: freezed == daysRemaining
          ? _value.daysRemaining
          : daysRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      progressPercentage: freezed == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as int?,
      employee: freezed == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as User?,
      supervisor: freezed == supervisor
          ? _value.supervisor
          : supervisor // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProbationRecordImpl implements _ProbationRecord {
  const _$ProbationRecordImpl(
      {@JsonKey(name: '_id') required this.id,
      @StringOrUserIdConverter() required this.employeeId,
      @StringOrUserIdConverter() required this.supervisorId,
      required this.startDate,
      required this.probationDays,
      required this.endDate,
      this.status = ProbationStatus.pendingKpi,
      final List<Kpi> kpis = const [],
      final List<Milestone> milestones = const [],
      this.finalDecision,
      this.createdAt,
      this.updatedAt,
      this.daysRemaining,
      this.progressPercentage,
      @JsonKey(readValue: _readEmployeeFromJson)
      @PopulatedUserConverter()
      this.employee,
      @JsonKey(readValue: _readSupervisorFromJson)
      @PopulatedUserConverter()
      this.supervisor})
      : _kpis = kpis,
        _milestones = milestones;

  factory _$ProbationRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProbationRecordImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @StringOrUserIdConverter()
  final String employeeId;
  @override
  @StringOrUserIdConverter()
  final String supervisorId;
  @override
  final DateTime startDate;
  @override
  final int probationDays;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final ProbationStatus status;
  final List<Kpi> _kpis;
  @override
  @JsonKey()
  List<Kpi> get kpis {
    if (_kpis is EqualUnmodifiableListView) return _kpis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kpis);
  }

  final List<Milestone> _milestones;
  @override
  @JsonKey()
  List<Milestone> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  @override
  final FinalDecisionInfo? finalDecision;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Virtual fields
  @override
  final int? daysRemaining;
  @override
  final int? progressPercentage;
// Populated fields - read from employeeId/supervisorId if they contain objects
  @override
  @JsonKey(readValue: _readEmployeeFromJson)
  @PopulatedUserConverter()
  final User? employee;
  @override
  @JsonKey(readValue: _readSupervisorFromJson)
  @PopulatedUserConverter()
  final User? supervisor;

  @override
  String toString() {
    return 'ProbationRecord(id: $id, employeeId: $employeeId, supervisorId: $supervisorId, startDate: $startDate, probationDays: $probationDays, endDate: $endDate, status: $status, kpis: $kpis, milestones: $milestones, finalDecision: $finalDecision, createdAt: $createdAt, updatedAt: $updatedAt, daysRemaining: $daysRemaining, progressPercentage: $progressPercentage, employee: $employee, supervisor: $supervisor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProbationRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.supervisorId, supervisorId) ||
                other.supervisorId == supervisorId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.probationDays, probationDays) ||
                other.probationDays == probationDays) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._kpis, _kpis) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            (identical(other.finalDecision, finalDecision) ||
                other.finalDecision == finalDecision) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.daysRemaining, daysRemaining) ||
                other.daysRemaining == daysRemaining) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.employee, employee) ||
                other.employee == employee) &&
            (identical(other.supervisor, supervisor) ||
                other.supervisor == supervisor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      supervisorId,
      startDate,
      probationDays,
      endDate,
      status,
      const DeepCollectionEquality().hash(_kpis),
      const DeepCollectionEquality().hash(_milestones),
      finalDecision,
      createdAt,
      updatedAt,
      daysRemaining,
      progressPercentage,
      employee,
      supervisor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProbationRecordImplCopyWith<_$ProbationRecordImpl> get copyWith =>
      __$$ProbationRecordImplCopyWithImpl<_$ProbationRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProbationRecordImplToJson(
      this,
    );
  }
}

abstract class _ProbationRecord implements ProbationRecord {
  const factory _ProbationRecord(
      {@JsonKey(name: '_id') required final String id,
      @StringOrUserIdConverter() required final String employeeId,
      @StringOrUserIdConverter() required final String supervisorId,
      required final DateTime startDate,
      required final int probationDays,
      required final DateTime endDate,
      final ProbationStatus status,
      final List<Kpi> kpis,
      final List<Milestone> milestones,
      final FinalDecisionInfo? finalDecision,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final int? daysRemaining,
      final int? progressPercentage,
      @JsonKey(readValue: _readEmployeeFromJson)
      @PopulatedUserConverter()
      final User? employee,
      @JsonKey(readValue: _readSupervisorFromJson)
      @PopulatedUserConverter()
      final User? supervisor}) = _$ProbationRecordImpl;

  factory _ProbationRecord.fromJson(Map<String, dynamic> json) =
      _$ProbationRecordImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @StringOrUserIdConverter()
  String get employeeId;
  @override
  @StringOrUserIdConverter()
  String get supervisorId;
  @override
  DateTime get startDate;
  @override
  int get probationDays;
  @override
  DateTime get endDate;
  @override
  ProbationStatus get status;
  @override
  List<Kpi> get kpis;
  @override
  List<Milestone> get milestones;
  @override
  FinalDecisionInfo? get finalDecision;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override // Virtual fields
  int? get daysRemaining;
  @override
  int? get progressPercentage;
  @override // Populated fields - read from employeeId/supervisorId if they contain objects
  @JsonKey(readValue: _readEmployeeFromJson)
  @PopulatedUserConverter()
  User? get employee;
  @override
  @JsonKey(readValue: _readSupervisorFromJson)
  @PopulatedUserConverter()
  User? get supervisor;
  @override
  @JsonKey(ignore: true)
  _$$ProbationRecordImplCopyWith<_$ProbationRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateProbationRequest _$CreateProbationRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateProbationRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateProbationRequest {
  String get employeeId => throw _privateConstructorUsedError;
  String get supervisorId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  int get probationDays => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateProbationRequestCopyWith<CreateProbationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProbationRequestCopyWith<$Res> {
  factory $CreateProbationRequestCopyWith(CreateProbationRequest value,
          $Res Function(CreateProbationRequest) then) =
      _$CreateProbationRequestCopyWithImpl<$Res, CreateProbationRequest>;
  @useResult
  $Res call(
      {String employeeId,
      String supervisorId,
      DateTime startDate,
      int probationDays});
}

/// @nodoc
class _$CreateProbationRequestCopyWithImpl<$Res,
        $Val extends CreateProbationRequest>
    implements $CreateProbationRequestCopyWith<$Res> {
  _$CreateProbationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? supervisorId = null,
    Object? startDate = null,
    Object? probationDays = null,
  }) {
    return _then(_value.copyWith(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      supervisorId: null == supervisorId
          ? _value.supervisorId
          : supervisorId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      probationDays: null == probationDays
          ? _value.probationDays
          : probationDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateProbationRequestImplCopyWith<$Res>
    implements $CreateProbationRequestCopyWith<$Res> {
  factory _$$CreateProbationRequestImplCopyWith(
          _$CreateProbationRequestImpl value,
          $Res Function(_$CreateProbationRequestImpl) then) =
      __$$CreateProbationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String employeeId,
      String supervisorId,
      DateTime startDate,
      int probationDays});
}

/// @nodoc
class __$$CreateProbationRequestImplCopyWithImpl<$Res>
    extends _$CreateProbationRequestCopyWithImpl<$Res,
        _$CreateProbationRequestImpl>
    implements _$$CreateProbationRequestImplCopyWith<$Res> {
  __$$CreateProbationRequestImplCopyWithImpl(
      _$CreateProbationRequestImpl _value,
      $Res Function(_$CreateProbationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? supervisorId = null,
    Object? startDate = null,
    Object? probationDays = null,
  }) {
    return _then(_$CreateProbationRequestImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      supervisorId: null == supervisorId
          ? _value.supervisorId
          : supervisorId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      probationDays: null == probationDays
          ? _value.probationDays
          : probationDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateProbationRequestImpl implements _CreateProbationRequest {
  const _$CreateProbationRequestImpl(
      {required this.employeeId,
      required this.supervisorId,
      required this.startDate,
      this.probationDays = 90});

  factory _$CreateProbationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateProbationRequestImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String supervisorId;
  @override
  final DateTime startDate;
  @override
  @JsonKey()
  final int probationDays;

  @override
  String toString() {
    return 'CreateProbationRequest(employeeId: $employeeId, supervisorId: $supervisorId, startDate: $startDate, probationDays: $probationDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateProbationRequestImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.supervisorId, supervisorId) ||
                other.supervisorId == supervisorId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.probationDays, probationDays) ||
                other.probationDays == probationDays));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, employeeId, supervisorId, startDate, probationDays);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateProbationRequestImplCopyWith<_$CreateProbationRequestImpl>
      get copyWith => __$$CreateProbationRequestImplCopyWithImpl<
          _$CreateProbationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateProbationRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateProbationRequest implements CreateProbationRequest {
  const factory _CreateProbationRequest(
      {required final String employeeId,
      required final String supervisorId,
      required final DateTime startDate,
      final int probationDays}) = _$CreateProbationRequestImpl;

  factory _CreateProbationRequest.fromJson(Map<String, dynamic> json) =
      _$CreateProbationRequestImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get supervisorId;
  @override
  DateTime get startDate;
  @override
  int get probationDays;
  @override
  @JsonKey(ignore: true)
  _$$CreateProbationRequestImplCopyWith<_$CreateProbationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateProbationStatusRequest _$UpdateProbationStatusRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateProbationStatusRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateProbationStatusRequest {
  ProbationStatus get status => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateProbationStatusRequestCopyWith<UpdateProbationStatusRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProbationStatusRequestCopyWith<$Res> {
  factory $UpdateProbationStatusRequestCopyWith(
          UpdateProbationStatusRequest value,
          $Res Function(UpdateProbationStatusRequest) then) =
      _$UpdateProbationStatusRequestCopyWithImpl<$Res,
          UpdateProbationStatusRequest>;
  @useResult
  $Res call({ProbationStatus status, String? reason});
}

/// @nodoc
class _$UpdateProbationStatusRequestCopyWithImpl<$Res,
        $Val extends UpdateProbationStatusRequest>
    implements $UpdateProbationStatusRequestCopyWith<$Res> {
  _$UpdateProbationStatusRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProbationStatus,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateProbationStatusRequestImplCopyWith<$Res>
    implements $UpdateProbationStatusRequestCopyWith<$Res> {
  factory _$$UpdateProbationStatusRequestImplCopyWith(
          _$UpdateProbationStatusRequestImpl value,
          $Res Function(_$UpdateProbationStatusRequestImpl) then) =
      __$$UpdateProbationStatusRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProbationStatus status, String? reason});
}

/// @nodoc
class __$$UpdateProbationStatusRequestImplCopyWithImpl<$Res>
    extends _$UpdateProbationStatusRequestCopyWithImpl<$Res,
        _$UpdateProbationStatusRequestImpl>
    implements _$$UpdateProbationStatusRequestImplCopyWith<$Res> {
  __$$UpdateProbationStatusRequestImplCopyWithImpl(
      _$UpdateProbationStatusRequestImpl _value,
      $Res Function(_$UpdateProbationStatusRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? reason = freezed,
  }) {
    return _then(_$UpdateProbationStatusRequestImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProbationStatus,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateProbationStatusRequestImpl
    implements _UpdateProbationStatusRequest {
  const _$UpdateProbationStatusRequestImpl({required this.status, this.reason});

  factory _$UpdateProbationStatusRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateProbationStatusRequestImplFromJson(json);

  @override
  final ProbationStatus status;
  @override
  final String? reason;

  @override
  String toString() {
    return 'UpdateProbationStatusRequest(status: $status, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProbationStatusRequestImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProbationStatusRequestImplCopyWith<
          _$UpdateProbationStatusRequestImpl>
      get copyWith => __$$UpdateProbationStatusRequestImplCopyWithImpl<
          _$UpdateProbationStatusRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProbationStatusRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateProbationStatusRequest
    implements UpdateProbationStatusRequest {
  const factory _UpdateProbationStatusRequest(
      {required final ProbationStatus status,
      final String? reason}) = _$UpdateProbationStatusRequestImpl;

  factory _UpdateProbationStatusRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateProbationStatusRequestImpl.fromJson;

  @override
  ProbationStatus get status;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$UpdateProbationStatusRequestImplCopyWith<
          _$UpdateProbationStatusRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FinalDecisionRequest _$FinalDecisionRequestFromJson(Map<String, dynamic> json) {
  return _FinalDecisionRequest.fromJson(json);
}

/// @nodoc
mixin _$FinalDecisionRequest {
  FinalDecision get decision => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinalDecisionRequestCopyWith<FinalDecisionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinalDecisionRequestCopyWith<$Res> {
  factory $FinalDecisionRequestCopyWith(FinalDecisionRequest value,
          $Res Function(FinalDecisionRequest) then) =
      _$FinalDecisionRequestCopyWithImpl<$Res, FinalDecisionRequest>;
  @useResult
  $Res call({FinalDecision decision, String? reason});
}

/// @nodoc
class _$FinalDecisionRequestCopyWithImpl<$Res,
        $Val extends FinalDecisionRequest>
    implements $FinalDecisionRequestCopyWith<$Res> {
  _$FinalDecisionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decision = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as FinalDecision,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinalDecisionRequestImplCopyWith<$Res>
    implements $FinalDecisionRequestCopyWith<$Res> {
  factory _$$FinalDecisionRequestImplCopyWith(_$FinalDecisionRequestImpl value,
          $Res Function(_$FinalDecisionRequestImpl) then) =
      __$$FinalDecisionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FinalDecision decision, String? reason});
}

/// @nodoc
class __$$FinalDecisionRequestImplCopyWithImpl<$Res>
    extends _$FinalDecisionRequestCopyWithImpl<$Res, _$FinalDecisionRequestImpl>
    implements _$$FinalDecisionRequestImplCopyWith<$Res> {
  __$$FinalDecisionRequestImplCopyWithImpl(_$FinalDecisionRequestImpl _value,
      $Res Function(_$FinalDecisionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decision = null,
    Object? reason = freezed,
  }) {
    return _then(_$FinalDecisionRequestImpl(
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as FinalDecision,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinalDecisionRequestImpl implements _FinalDecisionRequest {
  const _$FinalDecisionRequestImpl({required this.decision, this.reason});

  factory _$FinalDecisionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinalDecisionRequestImplFromJson(json);

  @override
  final FinalDecision decision;
  @override
  final String? reason;

  @override
  String toString() {
    return 'FinalDecisionRequest(decision: $decision, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinalDecisionRequestImpl &&
            (identical(other.decision, decision) ||
                other.decision == decision) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, decision, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinalDecisionRequestImplCopyWith<_$FinalDecisionRequestImpl>
      get copyWith =>
          __$$FinalDecisionRequestImplCopyWithImpl<_$FinalDecisionRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinalDecisionRequestImplToJson(
      this,
    );
  }
}

abstract class _FinalDecisionRequest implements FinalDecisionRequest {
  const factory _FinalDecisionRequest(
      {required final FinalDecision decision,
      final String? reason}) = _$FinalDecisionRequestImpl;

  factory _FinalDecisionRequest.fromJson(Map<String, dynamic> json) =
      _$FinalDecisionRequestImpl.fromJson;

  @override
  FinalDecision get decision;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$FinalDecisionRequestImplCopyWith<_$FinalDecisionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TransferSupervisorRequest _$TransferSupervisorRequestFromJson(
    Map<String, dynamic> json) {
  return _TransferSupervisorRequest.fromJson(json);
}

/// @nodoc
mixin _$TransferSupervisorRequest {
  String get newSupervisorId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferSupervisorRequestCopyWith<TransferSupervisorRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferSupervisorRequestCopyWith<$Res> {
  factory $TransferSupervisorRequestCopyWith(TransferSupervisorRequest value,
          $Res Function(TransferSupervisorRequest) then) =
      _$TransferSupervisorRequestCopyWithImpl<$Res, TransferSupervisorRequest>;
  @useResult
  $Res call({String newSupervisorId, String? reason});
}

/// @nodoc
class _$TransferSupervisorRequestCopyWithImpl<$Res,
        $Val extends TransferSupervisorRequest>
    implements $TransferSupervisorRequestCopyWith<$Res> {
  _$TransferSupervisorRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newSupervisorId = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      newSupervisorId: null == newSupervisorId
          ? _value.newSupervisorId
          : newSupervisorId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferSupervisorRequestImplCopyWith<$Res>
    implements $TransferSupervisorRequestCopyWith<$Res> {
  factory _$$TransferSupervisorRequestImplCopyWith(
          _$TransferSupervisorRequestImpl value,
          $Res Function(_$TransferSupervisorRequestImpl) then) =
      __$$TransferSupervisorRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newSupervisorId, String? reason});
}

/// @nodoc
class __$$TransferSupervisorRequestImplCopyWithImpl<$Res>
    extends _$TransferSupervisorRequestCopyWithImpl<$Res,
        _$TransferSupervisorRequestImpl>
    implements _$$TransferSupervisorRequestImplCopyWith<$Res> {
  __$$TransferSupervisorRequestImplCopyWithImpl(
      _$TransferSupervisorRequestImpl _value,
      $Res Function(_$TransferSupervisorRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newSupervisorId = null,
    Object? reason = freezed,
  }) {
    return _then(_$TransferSupervisorRequestImpl(
      newSupervisorId: null == newSupervisorId
          ? _value.newSupervisorId
          : newSupervisorId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferSupervisorRequestImpl implements _TransferSupervisorRequest {
  const _$TransferSupervisorRequestImpl(
      {required this.newSupervisorId, this.reason});

  factory _$TransferSupervisorRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferSupervisorRequestImplFromJson(json);

  @override
  final String newSupervisorId;
  @override
  final String? reason;

  @override
  String toString() {
    return 'TransferSupervisorRequest(newSupervisorId: $newSupervisorId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferSupervisorRequestImpl &&
            (identical(other.newSupervisorId, newSupervisorId) ||
                other.newSupervisorId == newSupervisorId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, newSupervisorId, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferSupervisorRequestImplCopyWith<_$TransferSupervisorRequestImpl>
      get copyWith => __$$TransferSupervisorRequestImplCopyWithImpl<
          _$TransferSupervisorRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferSupervisorRequestImplToJson(
      this,
    );
  }
}

abstract class _TransferSupervisorRequest implements TransferSupervisorRequest {
  const factory _TransferSupervisorRequest(
      {required final String newSupervisorId,
      final String? reason}) = _$TransferSupervisorRequestImpl;

  factory _TransferSupervisorRequest.fromJson(Map<String, dynamic> json) =
      _$TransferSupervisorRequestImpl.fromJson;

  @override
  String get newSupervisorId;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$TransferSupervisorRequestImplCopyWith<_$TransferSupervisorRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
