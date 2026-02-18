// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AssessmentScore _$AssessmentScoreFromJson(Map<String, dynamic> json) {
  return _AssessmentScore.fromJson(json);
}

/// @nodoc
mixin _$AssessmentScore {
  int get score => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssessmentScoreCopyWith<AssessmentScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssessmentScoreCopyWith<$Res> {
  factory $AssessmentScoreCopyWith(
          AssessmentScore value, $Res Function(AssessmentScore) then) =
      _$AssessmentScoreCopyWithImpl<$Res, AssessmentScore>;
  @useResult
  $Res call({int score, String? comment});
}

/// @nodoc
class _$AssessmentScoreCopyWithImpl<$Res, $Val extends AssessmentScore>
    implements $AssessmentScoreCopyWith<$Res> {
  _$AssessmentScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$AssessmentScoreImplCopyWith<$Res>
    implements $AssessmentScoreCopyWith<$Res> {
  factory _$$AssessmentScoreImplCopyWith(_$AssessmentScoreImpl value,
          $Res Function(_$AssessmentScoreImpl) then) =
      __$$AssessmentScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int score, String? comment});
}

/// @nodoc
class __$$AssessmentScoreImplCopyWithImpl<$Res>
    extends _$AssessmentScoreCopyWithImpl<$Res, _$AssessmentScoreImpl>
    implements _$$AssessmentScoreImplCopyWith<$Res> {
  __$$AssessmentScoreImplCopyWithImpl(
      _$AssessmentScoreImpl _value, $Res Function(_$AssessmentScoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? comment = freezed,
  }) {
    return _then(_$AssessmentScoreImpl(
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
class _$AssessmentScoreImpl implements _AssessmentScore {
  const _$AssessmentScoreImpl({required this.score, this.comment});

  factory _$AssessmentScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssessmentScoreImplFromJson(json);

  @override
  final int score;
  @override
  final String? comment;

  @override
  String toString() {
    return 'AssessmentScore(score: $score, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentScoreImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, score, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentScoreImplCopyWith<_$AssessmentScoreImpl> get copyWith =>
      __$$AssessmentScoreImplCopyWithImpl<_$AssessmentScoreImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssessmentScoreImplToJson(
      this,
    );
  }
}

abstract class _AssessmentScore implements AssessmentScore {
  const factory _AssessmentScore(
      {required final int score,
      final String? comment}) = _$AssessmentScoreImpl;

  factory _AssessmentScore.fromJson(Map<String, dynamic> json) =
      _$AssessmentScoreImpl.fromJson;

  @override
  int get score;
  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$AssessmentScoreImplCopyWith<_$AssessmentScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SelfAssessment _$SelfAssessmentFromJson(Map<String, dynamic> json) {
  return _SelfAssessment.fromJson(json);
}

/// @nodoc
mixin _$SelfAssessment {
  AssessmentScore get coreValue => throw _privateConstructorUsedError;
  AssessmentScore get jobPerformance => throw _privateConstructorUsedError;
  AssessmentScore get attendance => throw _privateConstructorUsedError;
  AssessmentScore get cultureFit => throw _privateConstructorUsedError;
  double? get averageScore => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  bool get isDraft => throw _privateConstructorUsedError;
  DateTime? get lastSavedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SelfAssessmentCopyWith<SelfAssessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelfAssessmentCopyWith<$Res> {
  factory $SelfAssessmentCopyWith(
          SelfAssessment value, $Res Function(SelfAssessment) then) =
      _$SelfAssessmentCopyWithImpl<$Res, SelfAssessment>;
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      double? averageScore,
      String? comments,
      DateTime? submittedAt,
      bool isDraft,
      DateTime? lastSavedAt});

  $AssessmentScoreCopyWith<$Res> get coreValue;
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  $AssessmentScoreCopyWith<$Res> get attendance;
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class _$SelfAssessmentCopyWithImpl<$Res, $Val extends SelfAssessment>
    implements $SelfAssessmentCopyWith<$Res> {
  _$SelfAssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? averageScore = freezed,
    Object? comments = freezed,
    Object? submittedAt = freezed,
    Object? isDraft = null,
    Object? lastSavedAt = freezed,
  }) {
    return _then(_value.copyWith(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      averageScore: freezed == averageScore
          ? _value.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDraft: null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSavedAt: freezed == lastSavedAt
          ? _value.lastSavedAt
          : lastSavedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get coreValue {
    return $AssessmentScoreCopyWith<$Res>(_value.coreValue, (value) {
      return _then(_value.copyWith(coreValue: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get jobPerformance {
    return $AssessmentScoreCopyWith<$Res>(_value.jobPerformance, (value) {
      return _then(_value.copyWith(jobPerformance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get attendance {
    return $AssessmentScoreCopyWith<$Res>(_value.attendance, (value) {
      return _then(_value.copyWith(attendance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get cultureFit {
    return $AssessmentScoreCopyWith<$Res>(_value.cultureFit, (value) {
      return _then(_value.copyWith(cultureFit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SelfAssessmentImplCopyWith<$Res>
    implements $SelfAssessmentCopyWith<$Res> {
  factory _$$SelfAssessmentImplCopyWith(_$SelfAssessmentImpl value,
          $Res Function(_$SelfAssessmentImpl) then) =
      __$$SelfAssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      double? averageScore,
      String? comments,
      DateTime? submittedAt,
      bool isDraft,
      DateTime? lastSavedAt});

  @override
  $AssessmentScoreCopyWith<$Res> get coreValue;
  @override
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  @override
  $AssessmentScoreCopyWith<$Res> get attendance;
  @override
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class __$$SelfAssessmentImplCopyWithImpl<$Res>
    extends _$SelfAssessmentCopyWithImpl<$Res, _$SelfAssessmentImpl>
    implements _$$SelfAssessmentImplCopyWith<$Res> {
  __$$SelfAssessmentImplCopyWithImpl(
      _$SelfAssessmentImpl _value, $Res Function(_$SelfAssessmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? averageScore = freezed,
    Object? comments = freezed,
    Object? submittedAt = freezed,
    Object? isDraft = null,
    Object? lastSavedAt = freezed,
  }) {
    return _then(_$SelfAssessmentImpl(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      averageScore: freezed == averageScore
          ? _value.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDraft: null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSavedAt: freezed == lastSavedAt
          ? _value.lastSavedAt
          : lastSavedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelfAssessmentImpl implements _SelfAssessment {
  const _$SelfAssessmentImpl(
      {required this.coreValue,
      required this.jobPerformance,
      required this.attendance,
      required this.cultureFit,
      this.averageScore,
      this.comments,
      this.submittedAt,
      this.isDraft = true,
      this.lastSavedAt});

  factory _$SelfAssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelfAssessmentImplFromJson(json);

  @override
  final AssessmentScore coreValue;
  @override
  final AssessmentScore jobPerformance;
  @override
  final AssessmentScore attendance;
  @override
  final AssessmentScore cultureFit;
  @override
  final double? averageScore;
  @override
  final String? comments;
  @override
  final DateTime? submittedAt;
  @override
  @JsonKey()
  final bool isDraft;
  @override
  final DateTime? lastSavedAt;

  @override
  String toString() {
    return 'SelfAssessment(coreValue: $coreValue, jobPerformance: $jobPerformance, attendance: $attendance, cultureFit: $cultureFit, averageScore: $averageScore, comments: $comments, submittedAt: $submittedAt, isDraft: $isDraft, lastSavedAt: $lastSavedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelfAssessmentImpl &&
            (identical(other.coreValue, coreValue) ||
                other.coreValue == coreValue) &&
            (identical(other.jobPerformance, jobPerformance) ||
                other.jobPerformance == jobPerformance) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance) &&
            (identical(other.cultureFit, cultureFit) ||
                other.cultureFit == cultureFit) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.isDraft, isDraft) || other.isDraft == isDraft) &&
            (identical(other.lastSavedAt, lastSavedAt) ||
                other.lastSavedAt == lastSavedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      coreValue,
      jobPerformance,
      attendance,
      cultureFit,
      averageScore,
      comments,
      submittedAt,
      isDraft,
      lastSavedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelfAssessmentImplCopyWith<_$SelfAssessmentImpl> get copyWith =>
      __$$SelfAssessmentImplCopyWithImpl<_$SelfAssessmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelfAssessmentImplToJson(
      this,
    );
  }
}

abstract class _SelfAssessment implements SelfAssessment {
  const factory _SelfAssessment(
      {required final AssessmentScore coreValue,
      required final AssessmentScore jobPerformance,
      required final AssessmentScore attendance,
      required final AssessmentScore cultureFit,
      final double? averageScore,
      final String? comments,
      final DateTime? submittedAt,
      final bool isDraft,
      final DateTime? lastSavedAt}) = _$SelfAssessmentImpl;

  factory _SelfAssessment.fromJson(Map<String, dynamic> json) =
      _$SelfAssessmentImpl.fromJson;

  @override
  AssessmentScore get coreValue;
  @override
  AssessmentScore get jobPerformance;
  @override
  AssessmentScore get attendance;
  @override
  AssessmentScore get cultureFit;
  @override
  double? get averageScore;
  @override
  String? get comments;
  @override
  DateTime? get submittedAt;
  @override
  bool get isDraft;
  @override
  DateTime? get lastSavedAt;
  @override
  @JsonKey(ignore: true)
  _$$SelfAssessmentImplCopyWith<_$SelfAssessmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SupervisorAssessment _$SupervisorAssessmentFromJson(Map<String, dynamic> json) {
  return _SupervisorAssessment.fromJson(json);
}

/// @nodoc
mixin _$SupervisorAssessment {
  AssessmentScore get coreValue => throw _privateConstructorUsedError;
  AssessmentScore get jobPerformance => throw _privateConstructorUsedError;
  AssessmentScore get attendance => throw _privateConstructorUsedError;
  AssessmentScore get cultureFit => throw _privateConstructorUsedError;
  double? get averageScore => throw _privateConstructorUsedError;
  List<KpiScore> get kpiScores => throw _privateConstructorUsedError;
  String get overallComment => throw _privateConstructorUsedError;
  Recommendation get recommendation => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupervisorAssessmentCopyWith<SupervisorAssessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupervisorAssessmentCopyWith<$Res> {
  factory $SupervisorAssessmentCopyWith(SupervisorAssessment value,
          $Res Function(SupervisorAssessment) then) =
      _$SupervisorAssessmentCopyWithImpl<$Res, SupervisorAssessment>;
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      double? averageScore,
      List<KpiScore> kpiScores,
      String overallComment,
      Recommendation recommendation,
      DateTime? submittedAt});

  $AssessmentScoreCopyWith<$Res> get coreValue;
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  $AssessmentScoreCopyWith<$Res> get attendance;
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class _$SupervisorAssessmentCopyWithImpl<$Res,
        $Val extends SupervisorAssessment>
    implements $SupervisorAssessmentCopyWith<$Res> {
  _$SupervisorAssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? averageScore = freezed,
    Object? kpiScores = null,
    Object? overallComment = null,
    Object? recommendation = null,
    Object? submittedAt = freezed,
  }) {
    return _then(_value.copyWith(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      averageScore: freezed == averageScore
          ? _value.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double?,
      kpiScores: null == kpiScores
          ? _value.kpiScores
          : kpiScores // ignore: cast_nullable_to_non_nullable
              as List<KpiScore>,
      overallComment: null == overallComment
          ? _value.overallComment
          : overallComment // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as Recommendation,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get coreValue {
    return $AssessmentScoreCopyWith<$Res>(_value.coreValue, (value) {
      return _then(_value.copyWith(coreValue: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get jobPerformance {
    return $AssessmentScoreCopyWith<$Res>(_value.jobPerformance, (value) {
      return _then(_value.copyWith(jobPerformance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get attendance {
    return $AssessmentScoreCopyWith<$Res>(_value.attendance, (value) {
      return _then(_value.copyWith(attendance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get cultureFit {
    return $AssessmentScoreCopyWith<$Res>(_value.cultureFit, (value) {
      return _then(_value.copyWith(cultureFit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SupervisorAssessmentImplCopyWith<$Res>
    implements $SupervisorAssessmentCopyWith<$Res> {
  factory _$$SupervisorAssessmentImplCopyWith(_$SupervisorAssessmentImpl value,
          $Res Function(_$SupervisorAssessmentImpl) then) =
      __$$SupervisorAssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      double? averageScore,
      List<KpiScore> kpiScores,
      String overallComment,
      Recommendation recommendation,
      DateTime? submittedAt});

  @override
  $AssessmentScoreCopyWith<$Res> get coreValue;
  @override
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  @override
  $AssessmentScoreCopyWith<$Res> get attendance;
  @override
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class __$$SupervisorAssessmentImplCopyWithImpl<$Res>
    extends _$SupervisorAssessmentCopyWithImpl<$Res, _$SupervisorAssessmentImpl>
    implements _$$SupervisorAssessmentImplCopyWith<$Res> {
  __$$SupervisorAssessmentImplCopyWithImpl(_$SupervisorAssessmentImpl _value,
      $Res Function(_$SupervisorAssessmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? averageScore = freezed,
    Object? kpiScores = null,
    Object? overallComment = null,
    Object? recommendation = null,
    Object? submittedAt = freezed,
  }) {
    return _then(_$SupervisorAssessmentImpl(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      averageScore: freezed == averageScore
          ? _value.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double?,
      kpiScores: null == kpiScores
          ? _value._kpiScores
          : kpiScores // ignore: cast_nullable_to_non_nullable
              as List<KpiScore>,
      overallComment: null == overallComment
          ? _value.overallComment
          : overallComment // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as Recommendation,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupervisorAssessmentImpl implements _SupervisorAssessment {
  const _$SupervisorAssessmentImpl(
      {required this.coreValue,
      required this.jobPerformance,
      required this.attendance,
      required this.cultureFit,
      this.averageScore,
      final List<KpiScore> kpiScores = const [],
      required this.overallComment,
      required this.recommendation,
      this.submittedAt})
      : _kpiScores = kpiScores;

  factory _$SupervisorAssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupervisorAssessmentImplFromJson(json);

  @override
  final AssessmentScore coreValue;
  @override
  final AssessmentScore jobPerformance;
  @override
  final AssessmentScore attendance;
  @override
  final AssessmentScore cultureFit;
  @override
  final double? averageScore;
  final List<KpiScore> _kpiScores;
  @override
  @JsonKey()
  List<KpiScore> get kpiScores {
    if (_kpiScores is EqualUnmodifiableListView) return _kpiScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kpiScores);
  }

  @override
  final String overallComment;
  @override
  final Recommendation recommendation;
  @override
  final DateTime? submittedAt;

  @override
  String toString() {
    return 'SupervisorAssessment(coreValue: $coreValue, jobPerformance: $jobPerformance, attendance: $attendance, cultureFit: $cultureFit, averageScore: $averageScore, kpiScores: $kpiScores, overallComment: $overallComment, recommendation: $recommendation, submittedAt: $submittedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupervisorAssessmentImpl &&
            (identical(other.coreValue, coreValue) ||
                other.coreValue == coreValue) &&
            (identical(other.jobPerformance, jobPerformance) ||
                other.jobPerformance == jobPerformance) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance) &&
            (identical(other.cultureFit, cultureFit) ||
                other.cultureFit == cultureFit) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            const DeepCollectionEquality()
                .equals(other._kpiScores, _kpiScores) &&
            (identical(other.overallComment, overallComment) ||
                other.overallComment == overallComment) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      coreValue,
      jobPerformance,
      attendance,
      cultureFit,
      averageScore,
      const DeepCollectionEquality().hash(_kpiScores),
      overallComment,
      recommendation,
      submittedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupervisorAssessmentImplCopyWith<_$SupervisorAssessmentImpl>
      get copyWith =>
          __$$SupervisorAssessmentImplCopyWithImpl<_$SupervisorAssessmentImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupervisorAssessmentImplToJson(
      this,
    );
  }
}

abstract class _SupervisorAssessment implements SupervisorAssessment {
  const factory _SupervisorAssessment(
      {required final AssessmentScore coreValue,
      required final AssessmentScore jobPerformance,
      required final AssessmentScore attendance,
      required final AssessmentScore cultureFit,
      final double? averageScore,
      final List<KpiScore> kpiScores,
      required final String overallComment,
      required final Recommendation recommendation,
      final DateTime? submittedAt}) = _$SupervisorAssessmentImpl;

  factory _SupervisorAssessment.fromJson(Map<String, dynamic> json) =
      _$SupervisorAssessmentImpl.fromJson;

  @override
  AssessmentScore get coreValue;
  @override
  AssessmentScore get jobPerformance;
  @override
  AssessmentScore get attendance;
  @override
  AssessmentScore get cultureFit;
  @override
  double? get averageScore;
  @override
  List<KpiScore> get kpiScores;
  @override
  String get overallComment;
  @override
  Recommendation get recommendation;
  @override
  DateTime? get submittedAt;
  @override
  @JsonKey(ignore: true)
  _$$SupervisorAssessmentImplCopyWith<_$SupervisorAssessmentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SubmitSelfAssessmentRequest _$SubmitSelfAssessmentRequestFromJson(
    Map<String, dynamic> json) {
  return _SubmitSelfAssessmentRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitSelfAssessmentRequest {
  AssessmentScore get coreValue => throw _privateConstructorUsedError;
  AssessmentScore get jobPerformance => throw _privateConstructorUsedError;
  AssessmentScore get attendance => throw _privateConstructorUsedError;
  AssessmentScore get cultureFit => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  bool get isDraft => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubmitSelfAssessmentRequestCopyWith<SubmitSelfAssessmentRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitSelfAssessmentRequestCopyWith<$Res> {
  factory $SubmitSelfAssessmentRequestCopyWith(
          SubmitSelfAssessmentRequest value,
          $Res Function(SubmitSelfAssessmentRequest) then) =
      _$SubmitSelfAssessmentRequestCopyWithImpl<$Res,
          SubmitSelfAssessmentRequest>;
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      String? comments,
      bool isDraft});

  $AssessmentScoreCopyWith<$Res> get coreValue;
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  $AssessmentScoreCopyWith<$Res> get attendance;
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class _$SubmitSelfAssessmentRequestCopyWithImpl<$Res,
        $Val extends SubmitSelfAssessmentRequest>
    implements $SubmitSelfAssessmentRequestCopyWith<$Res> {
  _$SubmitSelfAssessmentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? comments = freezed,
    Object? isDraft = null,
  }) {
    return _then(_value.copyWith(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      isDraft: null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get coreValue {
    return $AssessmentScoreCopyWith<$Res>(_value.coreValue, (value) {
      return _then(_value.copyWith(coreValue: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get jobPerformance {
    return $AssessmentScoreCopyWith<$Res>(_value.jobPerformance, (value) {
      return _then(_value.copyWith(jobPerformance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get attendance {
    return $AssessmentScoreCopyWith<$Res>(_value.attendance, (value) {
      return _then(_value.copyWith(attendance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get cultureFit {
    return $AssessmentScoreCopyWith<$Res>(_value.cultureFit, (value) {
      return _then(_value.copyWith(cultureFit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubmitSelfAssessmentRequestImplCopyWith<$Res>
    implements $SubmitSelfAssessmentRequestCopyWith<$Res> {
  factory _$$SubmitSelfAssessmentRequestImplCopyWith(
          _$SubmitSelfAssessmentRequestImpl value,
          $Res Function(_$SubmitSelfAssessmentRequestImpl) then) =
      __$$SubmitSelfAssessmentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      String? comments,
      bool isDraft});

  @override
  $AssessmentScoreCopyWith<$Res> get coreValue;
  @override
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  @override
  $AssessmentScoreCopyWith<$Res> get attendance;
  @override
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class __$$SubmitSelfAssessmentRequestImplCopyWithImpl<$Res>
    extends _$SubmitSelfAssessmentRequestCopyWithImpl<$Res,
        _$SubmitSelfAssessmentRequestImpl>
    implements _$$SubmitSelfAssessmentRequestImplCopyWith<$Res> {
  __$$SubmitSelfAssessmentRequestImplCopyWithImpl(
      _$SubmitSelfAssessmentRequestImpl _value,
      $Res Function(_$SubmitSelfAssessmentRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? comments = freezed,
    Object? isDraft = null,
  }) {
    return _then(_$SubmitSelfAssessmentRequestImpl(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      isDraft: null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitSelfAssessmentRequestImpl
    implements _SubmitSelfAssessmentRequest {
  const _$SubmitSelfAssessmentRequestImpl(
      {required this.coreValue,
      required this.jobPerformance,
      required this.attendance,
      required this.cultureFit,
      this.comments,
      this.isDraft = false});

  factory _$SubmitSelfAssessmentRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SubmitSelfAssessmentRequestImplFromJson(json);

  @override
  final AssessmentScore coreValue;
  @override
  final AssessmentScore jobPerformance;
  @override
  final AssessmentScore attendance;
  @override
  final AssessmentScore cultureFit;
  @override
  final String? comments;
  @override
  @JsonKey()
  final bool isDraft;

  @override
  String toString() {
    return 'SubmitSelfAssessmentRequest(coreValue: $coreValue, jobPerformance: $jobPerformance, attendance: $attendance, cultureFit: $cultureFit, comments: $comments, isDraft: $isDraft)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitSelfAssessmentRequestImpl &&
            (identical(other.coreValue, coreValue) ||
                other.coreValue == coreValue) &&
            (identical(other.jobPerformance, jobPerformance) ||
                other.jobPerformance == jobPerformance) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance) &&
            (identical(other.cultureFit, cultureFit) ||
                other.cultureFit == cultureFit) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.isDraft, isDraft) || other.isDraft == isDraft));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, coreValue, jobPerformance,
      attendance, cultureFit, comments, isDraft);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitSelfAssessmentRequestImplCopyWith<_$SubmitSelfAssessmentRequestImpl>
      get copyWith => __$$SubmitSelfAssessmentRequestImplCopyWithImpl<
          _$SubmitSelfAssessmentRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitSelfAssessmentRequestImplToJson(
      this,
    );
  }
}

abstract class _SubmitSelfAssessmentRequest
    implements SubmitSelfAssessmentRequest {
  const factory _SubmitSelfAssessmentRequest(
      {required final AssessmentScore coreValue,
      required final AssessmentScore jobPerformance,
      required final AssessmentScore attendance,
      required final AssessmentScore cultureFit,
      final String? comments,
      final bool isDraft}) = _$SubmitSelfAssessmentRequestImpl;

  factory _SubmitSelfAssessmentRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitSelfAssessmentRequestImpl.fromJson;

  @override
  AssessmentScore get coreValue;
  @override
  AssessmentScore get jobPerformance;
  @override
  AssessmentScore get attendance;
  @override
  AssessmentScore get cultureFit;
  @override
  String? get comments;
  @override
  bool get isDraft;
  @override
  @JsonKey(ignore: true)
  _$$SubmitSelfAssessmentRequestImplCopyWith<_$SubmitSelfAssessmentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SubmitSupervisorAssessmentRequest _$SubmitSupervisorAssessmentRequestFromJson(
    Map<String, dynamic> json) {
  return _SubmitSupervisorAssessmentRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitSupervisorAssessmentRequest {
  AssessmentScore get coreValue => throw _privateConstructorUsedError;
  AssessmentScore get jobPerformance => throw _privateConstructorUsedError;
  AssessmentScore get attendance => throw _privateConstructorUsedError;
  AssessmentScore get cultureFit => throw _privateConstructorUsedError;
  List<KpiScore> get kpiScores => throw _privateConstructorUsedError;
  String get overallComment => throw _privateConstructorUsedError;
  Recommendation get recommendation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubmitSupervisorAssessmentRequestCopyWith<SubmitSupervisorAssessmentRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitSupervisorAssessmentRequestCopyWith<$Res> {
  factory $SubmitSupervisorAssessmentRequestCopyWith(
          SubmitSupervisorAssessmentRequest value,
          $Res Function(SubmitSupervisorAssessmentRequest) then) =
      _$SubmitSupervisorAssessmentRequestCopyWithImpl<$Res,
          SubmitSupervisorAssessmentRequest>;
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      List<KpiScore> kpiScores,
      String overallComment,
      Recommendation recommendation});

  $AssessmentScoreCopyWith<$Res> get coreValue;
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  $AssessmentScoreCopyWith<$Res> get attendance;
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class _$SubmitSupervisorAssessmentRequestCopyWithImpl<$Res,
        $Val extends SubmitSupervisorAssessmentRequest>
    implements $SubmitSupervisorAssessmentRequestCopyWith<$Res> {
  _$SubmitSupervisorAssessmentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? kpiScores = null,
    Object? overallComment = null,
    Object? recommendation = null,
  }) {
    return _then(_value.copyWith(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      kpiScores: null == kpiScores
          ? _value.kpiScores
          : kpiScores // ignore: cast_nullable_to_non_nullable
              as List<KpiScore>,
      overallComment: null == overallComment
          ? _value.overallComment
          : overallComment // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as Recommendation,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get coreValue {
    return $AssessmentScoreCopyWith<$Res>(_value.coreValue, (value) {
      return _then(_value.copyWith(coreValue: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get jobPerformance {
    return $AssessmentScoreCopyWith<$Res>(_value.jobPerformance, (value) {
      return _then(_value.copyWith(jobPerformance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get attendance {
    return $AssessmentScoreCopyWith<$Res>(_value.attendance, (value) {
      return _then(_value.copyWith(attendance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res> get cultureFit {
    return $AssessmentScoreCopyWith<$Res>(_value.cultureFit, (value) {
      return _then(_value.copyWith(cultureFit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubmitSupervisorAssessmentRequestImplCopyWith<$Res>
    implements $SubmitSupervisorAssessmentRequestCopyWith<$Res> {
  factory _$$SubmitSupervisorAssessmentRequestImplCopyWith(
          _$SubmitSupervisorAssessmentRequestImpl value,
          $Res Function(_$SubmitSupervisorAssessmentRequestImpl) then) =
      __$$SubmitSupervisorAssessmentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AssessmentScore coreValue,
      AssessmentScore jobPerformance,
      AssessmentScore attendance,
      AssessmentScore cultureFit,
      List<KpiScore> kpiScores,
      String overallComment,
      Recommendation recommendation});

  @override
  $AssessmentScoreCopyWith<$Res> get coreValue;
  @override
  $AssessmentScoreCopyWith<$Res> get jobPerformance;
  @override
  $AssessmentScoreCopyWith<$Res> get attendance;
  @override
  $AssessmentScoreCopyWith<$Res> get cultureFit;
}

/// @nodoc
class __$$SubmitSupervisorAssessmentRequestImplCopyWithImpl<$Res>
    extends _$SubmitSupervisorAssessmentRequestCopyWithImpl<$Res,
        _$SubmitSupervisorAssessmentRequestImpl>
    implements _$$SubmitSupervisorAssessmentRequestImplCopyWith<$Res> {
  __$$SubmitSupervisorAssessmentRequestImplCopyWithImpl(
      _$SubmitSupervisorAssessmentRequestImpl _value,
      $Res Function(_$SubmitSupervisorAssessmentRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreValue = null,
    Object? jobPerformance = null,
    Object? attendance = null,
    Object? cultureFit = null,
    Object? kpiScores = null,
    Object? overallComment = null,
    Object? recommendation = null,
  }) {
    return _then(_$SubmitSupervisorAssessmentRequestImpl(
      coreValue: null == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      jobPerformance: null == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      cultureFit: null == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore,
      kpiScores: null == kpiScores
          ? _value._kpiScores
          : kpiScores // ignore: cast_nullable_to_non_nullable
              as List<KpiScore>,
      overallComment: null == overallComment
          ? _value.overallComment
          : overallComment // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: null == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as Recommendation,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitSupervisorAssessmentRequestImpl
    implements _SubmitSupervisorAssessmentRequest {
  const _$SubmitSupervisorAssessmentRequestImpl(
      {required this.coreValue,
      required this.jobPerformance,
      required this.attendance,
      required this.cultureFit,
      required final List<KpiScore> kpiScores,
      required this.overallComment,
      required this.recommendation})
      : _kpiScores = kpiScores;

  factory _$SubmitSupervisorAssessmentRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SubmitSupervisorAssessmentRequestImplFromJson(json);

  @override
  final AssessmentScore coreValue;
  @override
  final AssessmentScore jobPerformance;
  @override
  final AssessmentScore attendance;
  @override
  final AssessmentScore cultureFit;
  final List<KpiScore> _kpiScores;
  @override
  List<KpiScore> get kpiScores {
    if (_kpiScores is EqualUnmodifiableListView) return _kpiScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kpiScores);
  }

  @override
  final String overallComment;
  @override
  final Recommendation recommendation;

  @override
  String toString() {
    return 'SubmitSupervisorAssessmentRequest(coreValue: $coreValue, jobPerformance: $jobPerformance, attendance: $attendance, cultureFit: $cultureFit, kpiScores: $kpiScores, overallComment: $overallComment, recommendation: $recommendation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitSupervisorAssessmentRequestImpl &&
            (identical(other.coreValue, coreValue) ||
                other.coreValue == coreValue) &&
            (identical(other.jobPerformance, jobPerformance) ||
                other.jobPerformance == jobPerformance) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance) &&
            (identical(other.cultureFit, cultureFit) ||
                other.cultureFit == cultureFit) &&
            const DeepCollectionEquality()
                .equals(other._kpiScores, _kpiScores) &&
            (identical(other.overallComment, overallComment) ||
                other.overallComment == overallComment) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      coreValue,
      jobPerformance,
      attendance,
      cultureFit,
      const DeepCollectionEquality().hash(_kpiScores),
      overallComment,
      recommendation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitSupervisorAssessmentRequestImplCopyWith<
          _$SubmitSupervisorAssessmentRequestImpl>
      get copyWith => __$$SubmitSupervisorAssessmentRequestImplCopyWithImpl<
          _$SubmitSupervisorAssessmentRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitSupervisorAssessmentRequestImplToJson(
      this,
    );
  }
}

abstract class _SubmitSupervisorAssessmentRequest
    implements SubmitSupervisorAssessmentRequest {
  const factory _SubmitSupervisorAssessmentRequest(
          {required final AssessmentScore coreValue,
          required final AssessmentScore jobPerformance,
          required final AssessmentScore attendance,
          required final AssessmentScore cultureFit,
          required final List<KpiScore> kpiScores,
          required final String overallComment,
          required final Recommendation recommendation}) =
      _$SubmitSupervisorAssessmentRequestImpl;

  factory _SubmitSupervisorAssessmentRequest.fromJson(
          Map<String, dynamic> json) =
      _$SubmitSupervisorAssessmentRequestImpl.fromJson;

  @override
  AssessmentScore get coreValue;
  @override
  AssessmentScore get jobPerformance;
  @override
  AssessmentScore get attendance;
  @override
  AssessmentScore get cultureFit;
  @override
  List<KpiScore> get kpiScores;
  @override
  String get overallComment;
  @override
  Recommendation get recommendation;
  @override
  @JsonKey(ignore: true)
  _$$SubmitSupervisorAssessmentRequestImplCopyWith<
          _$SubmitSupervisorAssessmentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AssessmentDraft _$AssessmentDraftFromJson(Map<String, dynamic> json) {
  return _AssessmentDraft.fromJson(json);
}

/// @nodoc
mixin _$AssessmentDraft {
  String get probationRecordId => throw _privateConstructorUsedError;
  int get milestoneDay => throw _privateConstructorUsedError;
  AssessmentScore? get coreValue => throw _privateConstructorUsedError;
  AssessmentScore? get jobPerformance => throw _privateConstructorUsedError;
  AssessmentScore? get attendance => throw _privateConstructorUsedError;
  AssessmentScore? get cultureFit => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  DateTime get lastSavedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssessmentDraftCopyWith<AssessmentDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssessmentDraftCopyWith<$Res> {
  factory $AssessmentDraftCopyWith(
          AssessmentDraft value, $Res Function(AssessmentDraft) then) =
      _$AssessmentDraftCopyWithImpl<$Res, AssessmentDraft>;
  @useResult
  $Res call(
      {String probationRecordId,
      int milestoneDay,
      AssessmentScore? coreValue,
      AssessmentScore? jobPerformance,
      AssessmentScore? attendance,
      AssessmentScore? cultureFit,
      String? comments,
      DateTime lastSavedAt});

  $AssessmentScoreCopyWith<$Res>? get coreValue;
  $AssessmentScoreCopyWith<$Res>? get jobPerformance;
  $AssessmentScoreCopyWith<$Res>? get attendance;
  $AssessmentScoreCopyWith<$Res>? get cultureFit;
}

/// @nodoc
class _$AssessmentDraftCopyWithImpl<$Res, $Val extends AssessmentDraft>
    implements $AssessmentDraftCopyWith<$Res> {
  _$AssessmentDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? probationRecordId = null,
    Object? milestoneDay = null,
    Object? coreValue = freezed,
    Object? jobPerformance = freezed,
    Object? attendance = freezed,
    Object? cultureFit = freezed,
    Object? comments = freezed,
    Object? lastSavedAt = null,
  }) {
    return _then(_value.copyWith(
      probationRecordId: null == probationRecordId
          ? _value.probationRecordId
          : probationRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneDay: null == milestoneDay
          ? _value.milestoneDay
          : milestoneDay // ignore: cast_nullable_to_non_nullable
              as int,
      coreValue: freezed == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      jobPerformance: freezed == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      attendance: freezed == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      cultureFit: freezed == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSavedAt: null == lastSavedAt
          ? _value.lastSavedAt
          : lastSavedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res>? get coreValue {
    if (_value.coreValue == null) {
      return null;
    }

    return $AssessmentScoreCopyWith<$Res>(_value.coreValue!, (value) {
      return _then(_value.copyWith(coreValue: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res>? get jobPerformance {
    if (_value.jobPerformance == null) {
      return null;
    }

    return $AssessmentScoreCopyWith<$Res>(_value.jobPerformance!, (value) {
      return _then(_value.copyWith(jobPerformance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res>? get attendance {
    if (_value.attendance == null) {
      return null;
    }

    return $AssessmentScoreCopyWith<$Res>(_value.attendance!, (value) {
      return _then(_value.copyWith(attendance: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AssessmentScoreCopyWith<$Res>? get cultureFit {
    if (_value.cultureFit == null) {
      return null;
    }

    return $AssessmentScoreCopyWith<$Res>(_value.cultureFit!, (value) {
      return _then(_value.copyWith(cultureFit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AssessmentDraftImplCopyWith<$Res>
    implements $AssessmentDraftCopyWith<$Res> {
  factory _$$AssessmentDraftImplCopyWith(_$AssessmentDraftImpl value,
          $Res Function(_$AssessmentDraftImpl) then) =
      __$$AssessmentDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String probationRecordId,
      int milestoneDay,
      AssessmentScore? coreValue,
      AssessmentScore? jobPerformance,
      AssessmentScore? attendance,
      AssessmentScore? cultureFit,
      String? comments,
      DateTime lastSavedAt});

  @override
  $AssessmentScoreCopyWith<$Res>? get coreValue;
  @override
  $AssessmentScoreCopyWith<$Res>? get jobPerformance;
  @override
  $AssessmentScoreCopyWith<$Res>? get attendance;
  @override
  $AssessmentScoreCopyWith<$Res>? get cultureFit;
}

/// @nodoc
class __$$AssessmentDraftImplCopyWithImpl<$Res>
    extends _$AssessmentDraftCopyWithImpl<$Res, _$AssessmentDraftImpl>
    implements _$$AssessmentDraftImplCopyWith<$Res> {
  __$$AssessmentDraftImplCopyWithImpl(
      _$AssessmentDraftImpl _value, $Res Function(_$AssessmentDraftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? probationRecordId = null,
    Object? milestoneDay = null,
    Object? coreValue = freezed,
    Object? jobPerformance = freezed,
    Object? attendance = freezed,
    Object? cultureFit = freezed,
    Object? comments = freezed,
    Object? lastSavedAt = null,
  }) {
    return _then(_$AssessmentDraftImpl(
      probationRecordId: null == probationRecordId
          ? _value.probationRecordId
          : probationRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneDay: null == milestoneDay
          ? _value.milestoneDay
          : milestoneDay // ignore: cast_nullable_to_non_nullable
              as int,
      coreValue: freezed == coreValue
          ? _value.coreValue
          : coreValue // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      jobPerformance: freezed == jobPerformance
          ? _value.jobPerformance
          : jobPerformance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      attendance: freezed == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      cultureFit: freezed == cultureFit
          ? _value.cultureFit
          : cultureFit // ignore: cast_nullable_to_non_nullable
              as AssessmentScore?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSavedAt: null == lastSavedAt
          ? _value.lastSavedAt
          : lastSavedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssessmentDraftImpl implements _AssessmentDraft {
  const _$AssessmentDraftImpl(
      {required this.probationRecordId,
      required this.milestoneDay,
      this.coreValue,
      this.jobPerformance,
      this.attendance,
      this.cultureFit,
      this.comments,
      required this.lastSavedAt});

  factory _$AssessmentDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssessmentDraftImplFromJson(json);

  @override
  final String probationRecordId;
  @override
  final int milestoneDay;
  @override
  final AssessmentScore? coreValue;
  @override
  final AssessmentScore? jobPerformance;
  @override
  final AssessmentScore? attendance;
  @override
  final AssessmentScore? cultureFit;
  @override
  final String? comments;
  @override
  final DateTime lastSavedAt;

  @override
  String toString() {
    return 'AssessmentDraft(probationRecordId: $probationRecordId, milestoneDay: $milestoneDay, coreValue: $coreValue, jobPerformance: $jobPerformance, attendance: $attendance, cultureFit: $cultureFit, comments: $comments, lastSavedAt: $lastSavedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentDraftImpl &&
            (identical(other.probationRecordId, probationRecordId) ||
                other.probationRecordId == probationRecordId) &&
            (identical(other.milestoneDay, milestoneDay) ||
                other.milestoneDay == milestoneDay) &&
            (identical(other.coreValue, coreValue) ||
                other.coreValue == coreValue) &&
            (identical(other.jobPerformance, jobPerformance) ||
                other.jobPerformance == jobPerformance) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance) &&
            (identical(other.cultureFit, cultureFit) ||
                other.cultureFit == cultureFit) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.lastSavedAt, lastSavedAt) ||
                other.lastSavedAt == lastSavedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, probationRecordId, milestoneDay,
      coreValue, jobPerformance, attendance, cultureFit, comments, lastSavedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentDraftImplCopyWith<_$AssessmentDraftImpl> get copyWith =>
      __$$AssessmentDraftImplCopyWithImpl<_$AssessmentDraftImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssessmentDraftImplToJson(
      this,
    );
  }
}

abstract class _AssessmentDraft implements AssessmentDraft {
  const factory _AssessmentDraft(
      {required final String probationRecordId,
      required final int milestoneDay,
      final AssessmentScore? coreValue,
      final AssessmentScore? jobPerformance,
      final AssessmentScore? attendance,
      final AssessmentScore? cultureFit,
      final String? comments,
      required final DateTime lastSavedAt}) = _$AssessmentDraftImpl;

  factory _AssessmentDraft.fromJson(Map<String, dynamic> json) =
      _$AssessmentDraftImpl.fromJson;

  @override
  String get probationRecordId;
  @override
  int get milestoneDay;
  @override
  AssessmentScore? get coreValue;
  @override
  AssessmentScore? get jobPerformance;
  @override
  AssessmentScore? get attendance;
  @override
  AssessmentScore? get cultureFit;
  @override
  String? get comments;
  @override
  DateTime get lastSavedAt;
  @override
  @JsonKey(ignore: true)
  _$$AssessmentDraftImplCopyWith<_$AssessmentDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
