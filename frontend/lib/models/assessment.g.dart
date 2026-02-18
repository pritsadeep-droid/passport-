// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssessmentScoreImpl _$$AssessmentScoreImplFromJson(
        Map<String, dynamic> json) =>
    _$AssessmentScoreImpl(
      score: (json['score'] as num).toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$AssessmentScoreImplToJson(
        _$AssessmentScoreImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'comment': instance.comment,
    };

_$SelfAssessmentImpl _$$SelfAssessmentImplFromJson(Map<String, dynamic> json) =>
    _$SelfAssessmentImpl(
      coreValue:
          AssessmentScore.fromJson(json['coreValue'] as Map<String, dynamic>),
      jobPerformance: AssessmentScore.fromJson(
          json['jobPerformance'] as Map<String, dynamic>),
      attendance:
          AssessmentScore.fromJson(json['attendance'] as Map<String, dynamic>),
      cultureFit:
          AssessmentScore.fromJson(json['cultureFit'] as Map<String, dynamic>),
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      comments: json['comments'] as String?,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      isDraft: json['isDraft'] as bool? ?? true,
      lastSavedAt: json['lastSavedAt'] == null
          ? null
          : DateTime.parse(json['lastSavedAt'] as String),
    );

Map<String, dynamic> _$$SelfAssessmentImplToJson(
        _$SelfAssessmentImpl instance) =>
    <String, dynamic>{
      'coreValue': instance.coreValue,
      'jobPerformance': instance.jobPerformance,
      'attendance': instance.attendance,
      'cultureFit': instance.cultureFit,
      'averageScore': instance.averageScore,
      'comments': instance.comments,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'isDraft': instance.isDraft,
      'lastSavedAt': instance.lastSavedAt?.toIso8601String(),
    };

_$SupervisorAssessmentImpl _$$SupervisorAssessmentImplFromJson(
        Map<String, dynamic> json) =>
    _$SupervisorAssessmentImpl(
      coreValue:
          AssessmentScore.fromJson(json['coreValue'] as Map<String, dynamic>),
      jobPerformance: AssessmentScore.fromJson(
          json['jobPerformance'] as Map<String, dynamic>),
      attendance:
          AssessmentScore.fromJson(json['attendance'] as Map<String, dynamic>),
      cultureFit:
          AssessmentScore.fromJson(json['cultureFit'] as Map<String, dynamic>),
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      kpiScores: (json['kpiScores'] as List<dynamic>?)
              ?.map((e) => KpiScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      overallComment: json['overallComment'] as String,
      recommendation:
          $enumDecode(_$RecommendationEnumMap, json['recommendation']),
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
    );

Map<String, dynamic> _$$SupervisorAssessmentImplToJson(
        _$SupervisorAssessmentImpl instance) =>
    <String, dynamic>{
      'coreValue': instance.coreValue,
      'jobPerformance': instance.jobPerformance,
      'attendance': instance.attendance,
      'cultureFit': instance.cultureFit,
      'averageScore': instance.averageScore,
      'kpiScores': instance.kpiScores,
      'overallComment': instance.overallComment,
      'recommendation': _$RecommendationEnumMap[instance.recommendation]!,
      'submittedAt': instance.submittedAt?.toIso8601String(),
    };

const _$RecommendationEnumMap = {
  Recommendation.pass: 'pass',
  Recommendation.fail: 'fail',
  Recommendation.extend: 'extend',
};

_$SubmitSelfAssessmentRequestImpl _$$SubmitSelfAssessmentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SubmitSelfAssessmentRequestImpl(
      coreValue:
          AssessmentScore.fromJson(json['coreValue'] as Map<String, dynamic>),
      jobPerformance: AssessmentScore.fromJson(
          json['jobPerformance'] as Map<String, dynamic>),
      attendance:
          AssessmentScore.fromJson(json['attendance'] as Map<String, dynamic>),
      cultureFit:
          AssessmentScore.fromJson(json['cultureFit'] as Map<String, dynamic>),
      comments: json['comments'] as String?,
      isDraft: json['isDraft'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubmitSelfAssessmentRequestImplToJson(
        _$SubmitSelfAssessmentRequestImpl instance) =>
    <String, dynamic>{
      'coreValue': instance.coreValue,
      'jobPerformance': instance.jobPerformance,
      'attendance': instance.attendance,
      'cultureFit': instance.cultureFit,
      'comments': instance.comments,
      'isDraft': instance.isDraft,
    };

_$SubmitSupervisorAssessmentRequestImpl
    _$$SubmitSupervisorAssessmentRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$SubmitSupervisorAssessmentRequestImpl(
          coreValue: AssessmentScore.fromJson(
              json['coreValue'] as Map<String, dynamic>),
          jobPerformance: AssessmentScore.fromJson(
              json['jobPerformance'] as Map<String, dynamic>),
          attendance: AssessmentScore.fromJson(
              json['attendance'] as Map<String, dynamic>),
          cultureFit: AssessmentScore.fromJson(
              json['cultureFit'] as Map<String, dynamic>),
          kpiScores: (json['kpiScores'] as List<dynamic>)
              .map((e) => KpiScore.fromJson(e as Map<String, dynamic>))
              .toList(),
          overallComment: json['overallComment'] as String,
          recommendation:
              $enumDecode(_$RecommendationEnumMap, json['recommendation']),
        );

Map<String, dynamic> _$$SubmitSupervisorAssessmentRequestImplToJson(
        _$SubmitSupervisorAssessmentRequestImpl instance) =>
    <String, dynamic>{
      'coreValue': instance.coreValue,
      'jobPerformance': instance.jobPerformance,
      'attendance': instance.attendance,
      'cultureFit': instance.cultureFit,
      'kpiScores': instance.kpiScores,
      'overallComment': instance.overallComment,
      'recommendation': _$RecommendationEnumMap[instance.recommendation]!,
    };

_$AssessmentDraftImpl _$$AssessmentDraftImplFromJson(
        Map<String, dynamic> json) =>
    _$AssessmentDraftImpl(
      probationRecordId: json['probationRecordId'] as String,
      milestoneDay: (json['milestoneDay'] as num).toInt(),
      coreValue: json['coreValue'] == null
          ? null
          : AssessmentScore.fromJson(json['coreValue'] as Map<String, dynamic>),
      jobPerformance: json['jobPerformance'] == null
          ? null
          : AssessmentScore.fromJson(
              json['jobPerformance'] as Map<String, dynamic>),
      attendance: json['attendance'] == null
          ? null
          : AssessmentScore.fromJson(
              json['attendance'] as Map<String, dynamic>),
      cultureFit: json['cultureFit'] == null
          ? null
          : AssessmentScore.fromJson(
              json['cultureFit'] as Map<String, dynamic>),
      comments: json['comments'] as String?,
      lastSavedAt: DateTime.parse(json['lastSavedAt'] as String),
    );

Map<String, dynamic> _$$AssessmentDraftImplToJson(
        _$AssessmentDraftImpl instance) =>
    <String, dynamic>{
      'probationRecordId': instance.probationRecordId,
      'milestoneDay': instance.milestoneDay,
      'coreValue': instance.coreValue,
      'jobPerformance': instance.jobPerformance,
      'attendance': instance.attendance,
      'cultureFit': instance.cultureFit,
      'comments': instance.comments,
      'lastSavedAt': instance.lastSavedAt.toIso8601String(),
    };
