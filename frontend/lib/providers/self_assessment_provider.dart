import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assessment.dart' hide AssessmentScore;
import '../models/probation_record.dart';
import '../services/api_client.dart';
import '../services/assessment_service.dart';
import '../services/milestone_service.dart';
import 'auth_provider.dart';

/// Assessment service provider
final assessmentServiceProvider = Provider<AssessmentService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AssessmentService(apiClient: apiClient);
});

/// State for current assessment (employee view)
class CurrentAssessmentState {
  final CurrentAssessmentData? data;
  final bool isLoading;
  final String? error;

  const CurrentAssessmentState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  CurrentAssessmentState copyWith({
    CurrentAssessmentData? data,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CurrentAssessmentState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get hasCurrentMilestone => data?.currentMilestone != null;
}

/// Current assessment notifier
class CurrentAssessmentNotifier extends StateNotifier<CurrentAssessmentState> {
  final AssessmentService _assessmentService;

  CurrentAssessmentNotifier(this._assessmentService)
      : super(const CurrentAssessmentState());

  /// Load current assessment
  Future<void> loadCurrentAssessment() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await _assessmentService.getCurrentAssessment();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadCurrentAssessment();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Current assessment provider
final currentAssessmentProvider =
    StateNotifierProvider<CurrentAssessmentNotifier, CurrentAssessmentState>(
        (ref) {
  final assessmentService = ref.watch(assessmentServiceProvider);
  return CurrentAssessmentNotifier(assessmentService);
});

/// State for my milestones (employee view)
class MyMilestonesState {
  final MyMilestonesData? data;
  final bool isLoading;
  final String? error;

  const MyMilestonesState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  MyMilestonesState copyWith({
    MyMilestonesData? data,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MyMilestonesState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// My milestones notifier
class MyMilestonesNotifier extends StateNotifier<MyMilestonesState> {
  final AssessmentService _assessmentService;

  MyMilestonesNotifier(this._assessmentService)
      : super(const MyMilestonesState());

  /// Load my milestones
  Future<void> loadMyMilestones() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await _assessmentService.getMyMilestones();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadMyMilestones();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// My milestones provider
final myMilestonesProvider =
    StateNotifierProvider<MyMilestonesNotifier, MyMilestonesState>((ref) {
  final assessmentService = ref.watch(assessmentServiceProvider);
  return MyMilestonesNotifier(assessmentService);
});

/// State for self assessment form
class SelfAssessmentFormState {
  final AssessmentScore? coreValue;
  final AssessmentScore? jobPerformance;
  final AssessmentScore? attendance;
  final AssessmentScore? cultureFit;
  final String? comments;
  final bool isDraft;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;
  final SelfAssessment? existingAssessment;

  const SelfAssessmentFormState({
    this.coreValue,
    this.jobPerformance,
    this.attendance,
    this.cultureFit,
    this.comments,
    this.isDraft = false,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.successMessage,
    this.existingAssessment,
  });

  SelfAssessmentFormState copyWith({
    AssessmentScore? coreValue,
    AssessmentScore? jobPerformance,
    AssessmentScore? attendance,
    AssessmentScore? cultureFit,
    String? comments,
    bool? isDraft,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? successMessage,
    SelfAssessment? existingAssessment,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearCoreValue = false,
    bool clearJobPerformance = false,
    bool clearAttendance = false,
    bool clearCultureFit = false,
    bool clearComments = false,
  }) {
    return SelfAssessmentFormState(
      coreValue: clearCoreValue ? null : (coreValue ?? this.coreValue),
      jobPerformance:
          clearJobPerformance ? null : (jobPerformance ?? this.jobPerformance),
      attendance: clearAttendance ? null : (attendance ?? this.attendance),
      cultureFit: clearCultureFit ? null : (cultureFit ?? this.cultureFit),
      comments: clearComments ? null : (comments ?? this.comments),
      isDraft: isDraft ?? this.isDraft,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      existingAssessment: existingAssessment ?? this.existingAssessment,
    );
  }

  bool get isValid =>
      coreValue?.score != null &&
      jobPerformance?.score != null &&
      attendance?.score != null &&
      cultureFit?.score != null;

  double? get averageScore {
    if (!isValid) return null;
    final sum = (coreValue?.score ?? 0) +
        (jobPerformance?.score ?? 0) +
        (attendance?.score ?? 0) +
        (cultureFit?.score ?? 0);
    return sum / 4;
  }
}

/// Self assessment form notifier
class SelfAssessmentFormNotifier extends StateNotifier<SelfAssessmentFormState> {
  final AssessmentService _assessmentService;
  final String recordId;
  final int day;

  SelfAssessmentFormNotifier(
    this._assessmentService, {
    required this.recordId,
    required this.day,
  }) : super(const SelfAssessmentFormState());

  /// Load existing assessment
  Future<void> loadExistingAssessment() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final assessment = await _assessmentService.getSelfAssessment(
        recordId,
        day,
      );

      if (assessment != null) {
        // Convert freezed AssessmentScore to service AssessmentScore
        AssessmentScore? convertScore(dynamic score) {
          if (score == null) return null;
          return AssessmentScore(
            score: score.score as int,
            comment: score.comment as String?,
          );
        }

        state = state.copyWith(
          existingAssessment: assessment,
          coreValue: convertScore(assessment.coreValue),
          jobPerformance: convertScore(assessment.jobPerformance),
          attendance: convertScore(assessment.attendance),
          cultureFit: convertScore(assessment.cultureFit),
          comments: assessment.comments,
          isDraft: assessment.isDraft ?? false,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update core value score
  void updateCoreValue(int score, {String? comment}) {
    state = state.copyWith(
      coreValue: AssessmentScore(score: score, comment: comment),
    );
  }

  /// Update job performance score
  void updateJobPerformance(int score, {String? comment}) {
    state = state.copyWith(
      jobPerformance: AssessmentScore(score: score, comment: comment),
    );
  }

  /// Update attendance score
  void updateAttendance(int score, {String? comment}) {
    state = state.copyWith(
      attendance: AssessmentScore(score: score, comment: comment),
    );
  }

  /// Update culture fit score
  void updateCultureFit(int score, {String? comment}) {
    state = state.copyWith(
      cultureFit: AssessmentScore(score: score, comment: comment),
    );
  }

  /// Update comments
  void updateComments(String? comments) {
    state = state.copyWith(comments: comments, clearComments: comments == null);
  }

  /// Save as draft
  Future<bool> saveDraft() async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final request = SelfAssessmentRequest(
        coreValue: state.coreValue,
        jobPerformance: state.jobPerformance,
        attendance: state.attendance,
        cultureFit: state.cultureFit,
        comments: state.comments,
        isDraft: true,
      );

      await _assessmentService.submitSelfAssessment(recordId, day, request);

      state = state.copyWith(
        isSubmitting: false,
        isDraft: true,
        successMessage: 'บันทึกแบบร่างสำเร็จ',
      );

      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }

  /// Submit assessment
  Future<bool> submitAssessment() async {
    if (!state.isValid) {
      state = state.copyWith(error: 'กรุณากรอกคะแนนให้ครบทุกหัวข้อ');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final request = SelfAssessmentRequest(
        coreValue: state.coreValue,
        jobPerformance: state.jobPerformance,
        attendance: state.attendance,
        cultureFit: state.cultureFit,
        comments: state.comments,
        isDraft: false,
      );

      await _assessmentService.submitSelfAssessment(recordId, day, request);

      state = state.copyWith(
        isSubmitting: false,
        isDraft: false,
        successMessage: 'ส่งการประเมินตนเองสำเร็จ',
      );

      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear success
  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }

  /// Reset form
  void reset() {
    state = const SelfAssessmentFormState();
  }
}

/// Self assessment form provider parameters
class SelfAssessmentFormParams {
  final String recordId;
  final int day;

  const SelfAssessmentFormParams({
    required this.recordId,
    required this.day,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelfAssessmentFormParams &&
          runtimeType == other.runtimeType &&
          recordId == other.recordId &&
          day == other.day;

  @override
  int get hashCode => recordId.hashCode ^ day.hashCode;
}

/// Self assessment form provider
final selfAssessmentFormProvider = StateNotifierProvider.family<
    SelfAssessmentFormNotifier, SelfAssessmentFormState, SelfAssessmentFormParams>(
  (ref, params) {
    final assessmentService = ref.watch(assessmentServiceProvider);
    return SelfAssessmentFormNotifier(
      assessmentService,
      recordId: params.recordId,
      day: params.day,
    );
  },
);
