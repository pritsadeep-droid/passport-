import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding.freezed.dart';
part 'onboarding.g.dart';

enum QuestionType {
  @JsonValue('text_short')
  textShort,
  @JsonValue('text_long')
  textLong,
  @JsonValue('rating')
  rating,
  @JsonValue('single_choice')
  singleChoice,
  @JsonValue('file_upload')
  fileUpload,
}

enum MissionStatus {
  @JsonValue('locked')
  locked,
  @JsonValue('open')
  open,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('submitted')
  submitted,
  @JsonValue('passed')
  passed,
  @JsonValue('revision_required')
  revisionRequired,
  @JsonValue('failed')
  failed,
}

@freezed
class Question with _$Question {
  const factory Question({
    @JsonKey(name: '_id') required String id,
    required String text,
    @Default(QuestionType.textLong) QuestionType type,
    @Default([]) List<String> options,
    @Default(true) bool required,
    required String missionCode,
    @Default(0) int sortOrder,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String code,
    required String title,
    String? description,
    @Default(0) int openOffsetDays,
    @Default(7) int closeOffsetDays,
    @JsonKey(includeFromJson: false) MissionStatus? status, // Virtual status for UI
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}

@freezed
class OnboardingTemplate with _$OnboardingTemplate {
  const factory OnboardingTemplate({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? description,
    @Default([]) List<Mission> missions,
    @Default([]) List<Question> questions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OnboardingTemplate;

  factory OnboardingTemplate.fromJson(Map<String, dynamic> json) =>
      _$OnboardingTemplateFromJson(json);
}

@freezed
class Answer with _$Answer {
  const factory Answer({
    @JsonKey(name: '_id') String? id,
    required String questionId,
    String? text,
    @Default([]) List<String> attachments,
    DateTime? submittedAt,
  }) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) =>
      _$AnswerFromJson(json);
}

@freezed
class Review with _$Review {
  const factory Review({
    @JsonKey(name: '_id') String? id,
    required String missionCode,
    required String decision,
    double? score,
    String? comment,
    String? reviewedBy, // ID or Name if populated
    DateTime? reviewedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}

@freezed
class OnboardingInstance with _$OnboardingInstance {
  const factory OnboardingInstance({
    @JsonKey(name: '_id') required String id,
    required String employeeId,
    required OnboardingTemplate templateId, // Populated
    required DateTime startDate,
    required String status,
    @Default([]) List<Answer> answers,
    @Default([]) List<Review> reviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OnboardingInstance;

  factory OnboardingInstance.fromJson(Map<String, dynamic> json) =>
      _$OnboardingInstanceFromJson(json);
}

@freezed
class AssignOnboardingRequest with _$AssignOnboardingRequest {
  const factory AssignOnboardingRequest({
    required String employeeId,
    required String templateId,
    DateTime? startDate,
  }) = _AssignOnboardingRequest;

  factory AssignOnboardingRequest.toJson() =>
      const AssignOnboardingRequest(employeeId: '', templateId: ''); // Dummy factory to satisfy linter if strictly typed
  
  // Custom toJson since we don't deserialize requests usually
  factory AssignOnboardingRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignOnboardingRequestFromJson(json);
}

@freezed
class SubmitAnswerRequest with _$SubmitAnswerRequest {
  const factory SubmitAnswerRequest({
    required String questionId,
    String? text,
    List<String>? attachments,
  }) = _SubmitAnswerRequest;

  factory SubmitAnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitAnswerRequestFromJson(json);
}

@freezed
class ReviewMissionRequest with _$ReviewMissionRequest {
  const factory ReviewMissionRequest({
    required String onboardingId,
    required String missionCode,
    required String decision,
    double? score,
    String? comment,
  }) = _ReviewMissionRequest;

  factory ReviewMissionRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewMissionRequestFromJson(json);
}
