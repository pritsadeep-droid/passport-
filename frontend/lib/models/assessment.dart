import 'package:freezed_annotation/freezed_annotation.dart';
import 'kpi.dart';

part 'assessment.freezed.dart';
part 'assessment.g.dart';

/// Score for a single assessment category (1-5 scale)
@freezed
class AssessmentScore with _$AssessmentScore {
  const factory AssessmentScore({
    required int score,
    String? comment,
  }) = _AssessmentScore;

  factory AssessmentScore.fromJson(Map<String, dynamic> json) =>
      _$AssessmentScoreFromJson(json);
}

/// Self assessment submitted by employee
@freezed
class SelfAssessment with _$SelfAssessment {
  const factory SelfAssessment({
    required AssessmentScore coreValue,
    required AssessmentScore jobPerformance,
    required AssessmentScore attendance,
    required AssessmentScore cultureFit,
    double? averageScore,
    String? comments,
    DateTime? submittedAt,
    @Default(true) bool isDraft,
    DateTime? lastSavedAt,
  }) = _SelfAssessment;

  factory SelfAssessment.fromJson(Map<String, dynamic> json) =>
      _$SelfAssessmentFromJson(json);
}

enum Recommendation {
  @JsonValue('pass')
  pass,
  @JsonValue('fail')
  fail,
  @JsonValue('extend')
  extend,
}

/// Supervisor assessment
@freezed
class SupervisorAssessment with _$SupervisorAssessment {
  const factory SupervisorAssessment({
    required AssessmentScore coreValue,
    required AssessmentScore jobPerformance,
    required AssessmentScore attendance,
    required AssessmentScore cultureFit,
    double? averageScore,
    @Default([]) List<KpiScore> kpiScores,
    required String overallComment,
    required Recommendation recommendation,
    DateTime? submittedAt,
  }) = _SupervisorAssessment;

  factory SupervisorAssessment.fromJson(Map<String, dynamic> json) =>
      _$SupervisorAssessmentFromJson(json);
}

/// Request to submit self assessment
@freezed
class SubmitSelfAssessmentRequest with _$SubmitSelfAssessmentRequest {
  const factory SubmitSelfAssessmentRequest({
    required AssessmentScore coreValue,
    required AssessmentScore jobPerformance,
    required AssessmentScore attendance,
    required AssessmentScore cultureFit,
    String? comments,
    @Default(false) bool isDraft,
  }) = _SubmitSelfAssessmentRequest;

  factory SubmitSelfAssessmentRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitSelfAssessmentRequestFromJson(json);
}

/// Request to submit supervisor assessment
@freezed
class SubmitSupervisorAssessmentRequest
    with _$SubmitSupervisorAssessmentRequest {
  const factory SubmitSupervisorAssessmentRequest({
    required AssessmentScore coreValue,
    required AssessmentScore jobPerformance,
    required AssessmentScore attendance,
    required AssessmentScore cultureFit,
    required List<KpiScore> kpiScores,
    required String overallComment,
    required Recommendation recommendation,
  }) = _SubmitSupervisorAssessmentRequest;

  factory SubmitSupervisorAssessmentRequest.fromJson(
          Map<String, dynamic> json) =>
      _$SubmitSupervisorAssessmentRequestFromJson(json);
}

/// Assessment draft for local storage
@freezed
class AssessmentDraft with _$AssessmentDraft {
  const factory AssessmentDraft({
    required String probationRecordId,
    required int milestoneDay,
    AssessmentScore? coreValue,
    AssessmentScore? jobPerformance,
    AssessmentScore? attendance,
    AssessmentScore? cultureFit,
    String? comments,
    required DateTime lastSavedAt,
  }) = _AssessmentDraft;

  factory AssessmentDraft.fromJson(Map<String, dynamic> json) =>
      _$AssessmentDraftFromJson(json);
}

extension AssessmentScoreExtension on AssessmentScore {
  bool get isPassing => score >= 3;
}

extension SelfAssessmentExtension on SelfAssessment {
  bool get isPassing => (averageScore ?? 0) >= 3.0;

  double calculateAverageScore() {
    return (coreValue.score +
            jobPerformance.score +
            attendance.score +
            cultureFit.score) /
        4.0;
  }
}

extension SupervisorAssessmentExtension on SupervisorAssessment {
  bool get isPassing => (averageScore ?? 0) >= 3.0;

  double calculateAverageScore() {
    return (coreValue.score +
            jobPerformance.score +
            attendance.score +
            cultureFit.score) /
        4.0;
  }
}

extension RecommendationExtension on Recommendation {
  String get displayName {
    switch (this) {
      case Recommendation.pass:
        return 'ผ่าน';
      case Recommendation.fail:
        return 'ไม่ผ่าน';
      case Recommendation.extend:
        return 'ขยายเวลา';
    }
  }

  bool get isPass => this == Recommendation.pass;
  bool get isFail => this == Recommendation.fail;
  bool get isExtend => this == Recommendation.extend;
}

/// Score label helper
String getScoreLabel(int score) {
  switch (score) {
    case 1:
      return 'ต้องปรับปรุงมาก';
    case 2:
      return 'ต้องปรับปรุง';
    case 3:
      return 'พอใช้';
    case 4:
      return 'ดี';
    case 5:
      return 'ดีเยี่ยม';
    default:
      return '';
  }
}
