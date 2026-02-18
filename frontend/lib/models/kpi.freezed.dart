// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kpi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Kpi _$KpiFromJson(Map<String, dynamic> json) {
  return _Kpi.fromJson(json);
}

/// @nodoc
mixin _$Kpi {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get criteria => throw _privateConstructorUsedError;
  KpiStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KpiCopyWith<Kpi> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KpiCopyWith<$Res> {
  factory $KpiCopyWith(Kpi value, $Res Function(Kpi) then) =
      _$KpiCopyWithImpl<$Res, Kpi>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String criteria,
      KpiStatus status,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$KpiCopyWithImpl<$Res, $Val extends Kpi> implements $KpiCopyWith<$Res> {
  _$KpiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as KpiStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KpiImplCopyWith<$Res> implements $KpiCopyWith<$Res> {
  factory _$$KpiImplCopyWith(_$KpiImpl value, $Res Function(_$KpiImpl) then) =
      __$$KpiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String criteria,
      KpiStatus status,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$KpiImplCopyWithImpl<$Res> extends _$KpiCopyWithImpl<$Res, _$KpiImpl>
    implements _$$KpiImplCopyWith<$Res> {
  __$$KpiImplCopyWithImpl(_$KpiImpl _value, $Res Function(_$KpiImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$KpiImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as KpiStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KpiImpl implements _Kpi {
  const _$KpiImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.criteria,
      this.status = KpiStatus.active,
      this.createdAt,
      this.updatedAt});

  factory _$KpiImpl.fromJson(Map<String, dynamic> json) =>
      _$$KpiImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String criteria;
  @override
  @JsonKey()
  final KpiStatus status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Kpi(id: $id, title: $title, description: $description, criteria: $criteria, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KpiImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, criteria,
      status, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KpiImplCopyWith<_$KpiImpl> get copyWith =>
      __$$KpiImplCopyWithImpl<_$KpiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KpiImplToJson(
      this,
    );
  }
}

abstract class _Kpi implements Kpi {
  const factory _Kpi(
      {required final String id,
      required final String title,
      required final String description,
      required final String criteria,
      final KpiStatus status,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$KpiImpl;

  factory _Kpi.fromJson(Map<String, dynamic> json) = _$KpiImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get criteria;
  @override
  KpiStatus get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$KpiImplCopyWith<_$KpiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateKpiRequest _$CreateKpiRequestFromJson(Map<String, dynamic> json) {
  return _CreateKpiRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateKpiRequest {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get criteria => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateKpiRequestCopyWith<CreateKpiRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateKpiRequestCopyWith<$Res> {
  factory $CreateKpiRequestCopyWith(
          CreateKpiRequest value, $Res Function(CreateKpiRequest) then) =
      _$CreateKpiRequestCopyWithImpl<$Res, CreateKpiRequest>;
  @useResult
  $Res call({String title, String description, String criteria});
}

/// @nodoc
class _$CreateKpiRequestCopyWithImpl<$Res, $Val extends CreateKpiRequest>
    implements $CreateKpiRequestCopyWith<$Res> {
  _$CreateKpiRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateKpiRequestImplCopyWith<$Res>
    implements $CreateKpiRequestCopyWith<$Res> {
  factory _$$CreateKpiRequestImplCopyWith(_$CreateKpiRequestImpl value,
          $Res Function(_$CreateKpiRequestImpl) then) =
      __$$CreateKpiRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description, String criteria});
}

/// @nodoc
class __$$CreateKpiRequestImplCopyWithImpl<$Res>
    extends _$CreateKpiRequestCopyWithImpl<$Res, _$CreateKpiRequestImpl>
    implements _$$CreateKpiRequestImplCopyWith<$Res> {
  __$$CreateKpiRequestImplCopyWithImpl(_$CreateKpiRequestImpl _value,
      $Res Function(_$CreateKpiRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
  }) {
    return _then(_$CreateKpiRequestImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateKpiRequestImpl implements _CreateKpiRequest {
  const _$CreateKpiRequestImpl(
      {required this.title, required this.description, required this.criteria});

  factory _$CreateKpiRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateKpiRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final String criteria;

  @override
  String toString() {
    return 'CreateKpiRequest(title: $title, description: $description, criteria: $criteria)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateKpiRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, criteria);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateKpiRequestImplCopyWith<_$CreateKpiRequestImpl> get copyWith =>
      __$$CreateKpiRequestImplCopyWithImpl<_$CreateKpiRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateKpiRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateKpiRequest implements CreateKpiRequest {
  const factory _CreateKpiRequest(
      {required final String title,
      required final String description,
      required final String criteria}) = _$CreateKpiRequestImpl;

  factory _CreateKpiRequest.fromJson(Map<String, dynamic> json) =
      _$CreateKpiRequestImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  String get criteria;
  @override
  @JsonKey(ignore: true)
  _$$CreateKpiRequestImplCopyWith<_$CreateKpiRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateKpiRequest _$UpdateKpiRequestFromJson(Map<String, dynamic> json) {
  return _UpdateKpiRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateKpiRequest {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get criteria => throw _privateConstructorUsedError;
  KpiStatus? get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateKpiRequestCopyWith<UpdateKpiRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateKpiRequestCopyWith<$Res> {
  factory $UpdateKpiRequestCopyWith(
          UpdateKpiRequest value, $Res Function(UpdateKpiRequest) then) =
      _$UpdateKpiRequestCopyWithImpl<$Res, UpdateKpiRequest>;
  @useResult
  $Res call(
      {String? title,
      String? description,
      String? criteria,
      KpiStatus? status});
}

/// @nodoc
class _$UpdateKpiRequestCopyWithImpl<$Res, $Val extends UpdateKpiRequest>
    implements $UpdateKpiRequestCopyWith<$Res> {
  _$UpdateKpiRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? criteria = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as KpiStatus?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateKpiRequestImplCopyWith<$Res>
    implements $UpdateKpiRequestCopyWith<$Res> {
  factory _$$UpdateKpiRequestImplCopyWith(_$UpdateKpiRequestImpl value,
          $Res Function(_$UpdateKpiRequestImpl) then) =
      __$$UpdateKpiRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? description,
      String? criteria,
      KpiStatus? status});
}

/// @nodoc
class __$$UpdateKpiRequestImplCopyWithImpl<$Res>
    extends _$UpdateKpiRequestCopyWithImpl<$Res, _$UpdateKpiRequestImpl>
    implements _$$UpdateKpiRequestImplCopyWith<$Res> {
  __$$UpdateKpiRequestImplCopyWithImpl(_$UpdateKpiRequestImpl _value,
      $Res Function(_$UpdateKpiRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? criteria = freezed,
    Object? status = freezed,
  }) {
    return _then(_$UpdateKpiRequestImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as KpiStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateKpiRequestImpl implements _UpdateKpiRequest {
  const _$UpdateKpiRequestImpl(
      {this.title, this.description, this.criteria, this.status});

  factory _$UpdateKpiRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateKpiRequestImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? criteria;
  @override
  final KpiStatus? status;

  @override
  String toString() {
    return 'UpdateKpiRequest(title: $title, description: $description, criteria: $criteria, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateKpiRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, description, criteria, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateKpiRequestImplCopyWith<_$UpdateKpiRequestImpl> get copyWith =>
      __$$UpdateKpiRequestImplCopyWithImpl<_$UpdateKpiRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateKpiRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateKpiRequest implements UpdateKpiRequest {
  const factory _UpdateKpiRequest(
      {final String? title,
      final String? description,
      final String? criteria,
      final KpiStatus? status}) = _$UpdateKpiRequestImpl;

  factory _UpdateKpiRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateKpiRequestImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get criteria;
  @override
  KpiStatus? get status;
  @override
  @JsonKey(ignore: true)
  _$$UpdateKpiRequestImplCopyWith<_$UpdateKpiRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KpiScore _$KpiScoreFromJson(Map<String, dynamic> json) {
  return _KpiScore.fromJson(json);
}

/// @nodoc
mixin _$KpiScore {
  String get kpiId => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KpiScoreCopyWith<KpiScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KpiScoreCopyWith<$Res> {
  factory $KpiScoreCopyWith(KpiScore value, $Res Function(KpiScore) then) =
      _$KpiScoreCopyWithImpl<$Res, KpiScore>;
  @useResult
  $Res call({String kpiId, int score, String? comment});
}

/// @nodoc
class _$KpiScoreCopyWithImpl<$Res, $Val extends KpiScore>
    implements $KpiScoreCopyWith<$Res> {
  _$KpiScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kpiId = null,
    Object? score = null,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      kpiId: null == kpiId
          ? _value.kpiId
          : kpiId // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KpiScoreImplCopyWith<$Res>
    implements $KpiScoreCopyWith<$Res> {
  factory _$$KpiScoreImplCopyWith(
          _$KpiScoreImpl value, $Res Function(_$KpiScoreImpl) then) =
      __$$KpiScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String kpiId, int score, String? comment});
}

/// @nodoc
class __$$KpiScoreImplCopyWithImpl<$Res>
    extends _$KpiScoreCopyWithImpl<$Res, _$KpiScoreImpl>
    implements _$$KpiScoreImplCopyWith<$Res> {
  __$$KpiScoreImplCopyWithImpl(
      _$KpiScoreImpl _value, $Res Function(_$KpiScoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kpiId = null,
    Object? score = null,
    Object? comment = freezed,
  }) {
    return _then(_$KpiScoreImpl(
      kpiId: null == kpiId
          ? _value.kpiId
          : kpiId // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KpiScoreImpl implements _KpiScore {
  const _$KpiScoreImpl(
      {required this.kpiId, required this.score, this.comment});

  factory _$KpiScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$KpiScoreImplFromJson(json);

  @override
  final String kpiId;
  @override
  final int score;
  @override
  final String? comment;

  @override
  String toString() {
    return 'KpiScore(kpiId: $kpiId, score: $score, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KpiScoreImpl &&
            (identical(other.kpiId, kpiId) || other.kpiId == kpiId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, kpiId, score, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KpiScoreImplCopyWith<_$KpiScoreImpl> get copyWith =>
      __$$KpiScoreImplCopyWithImpl<_$KpiScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KpiScoreImplToJson(
      this,
    );
  }
}

abstract class _KpiScore implements KpiScore {
  const factory _KpiScore(
      {required final String kpiId,
      required final int score,
      final String? comment}) = _$KpiScoreImpl;

  factory _KpiScore.fromJson(Map<String, dynamic> json) =
      _$KpiScoreImpl.fromJson;

  @override
  String get kpiId;
  @override
  int get score;
  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$KpiScoreImplCopyWith<_$KpiScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
