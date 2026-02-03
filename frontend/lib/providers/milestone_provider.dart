import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/probation_record.dart';
import '../services/api_client.dart';
import '../services/milestone_service.dart';
import 'auth_provider.dart';

/// Milestone service provider
final milestoneServiceProvider = Provider<MilestoneService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MilestoneService(apiClient: apiClient);
});

/// State for pending approvals
class PendingApprovalsState {
  final List<PendingApproval> approvals;
  final bool isLoading;
  final String? error;

  const PendingApprovalsState({
    this.approvals = const [],
    this.isLoading = false,
    this.error,
  });

  PendingApprovalsState copyWith({
    List<PendingApproval>? approvals,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return PendingApprovalsState(
      approvals: approvals ?? this.approvals,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Pending approvals notifier
class PendingApprovalsNotifier extends StateNotifier<PendingApprovalsState> {
  final MilestoneService _milestoneService;

  PendingApprovalsNotifier(this._milestoneService)
      : super(const PendingApprovalsState());

  /// Load pending approvals
  Future<void> loadPendingApprovals() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final approvals = await _milestoneService.getPendingApprovals();
      state = state.copyWith(approvals: approvals, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadPendingApprovals();
  }

  /// Remove an approval from the list (after approve/reject)
  void removeApproval(String probationRecordId, int day) {
    final updatedApprovals = state.approvals
        .where((a) =>
            !(a.probationRecordId == probationRecordId && a.milestone.day == day))
        .toList();
    state = state.copyWith(approvals: updatedApprovals);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Pending approvals provider
final pendingApprovalsProvider =
    StateNotifierProvider<PendingApprovalsNotifier, PendingApprovalsState>(
        (ref) {
  final milestoneService = ref.watch(milestoneServiceProvider);
  return PendingApprovalsNotifier(milestoneService);
});

/// State for milestone detail
class MilestoneDetailState {
  final MilestoneWithPermissions? milestoneData;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;

  const MilestoneDetailState({
    this.milestoneData,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.successMessage,
  });

  MilestoneDetailState copyWith({
    MilestoneWithPermissions? milestoneData,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return MilestoneDetailState(
      milestoneData: milestoneData ?? this.milestoneData,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

/// Milestone detail notifier
class MilestoneDetailNotifier extends StateNotifier<MilestoneDetailState> {
  final MilestoneService _milestoneService;
  final String probationRecordId;
  final int day;

  MilestoneDetailNotifier(
    this._milestoneService, {
    required this.probationRecordId,
    required this.day,
  }) : super(const MilestoneDetailState());

  /// Load milestone detail
  Future<void> loadMilestone() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final milestoneData = await _milestoneService.getMilestone(
        probationRecordId,
        day,
      );
      state = state.copyWith(milestoneData: milestoneData, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Submit self assessment
  Future<ProbationRecord?> submitSelfAssessment(SelfAssessmentData data) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final record = await _milestoneService.submitSelfAssessment(
        probationRecordId,
        day,
        data,
      );

      final message = data.isDraft
          ? 'บันทึกแบบร่างสำเร็จ'
          : 'ส่งการประเมินตนเองสำเร็จ';

      state = state.copyWith(
        isSubmitting: false,
        successMessage: message,
      );

      // Reload milestone to get updated state
      await loadMilestone();

      return record;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  /// Submit supervisor assessment
  Future<ProbationRecord?> submitSupervisorAssessment(
      SupervisorAssessmentData data) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final record = await _milestoneService.submitSupervisorAssessment(
        probationRecordId,
        day,
        data,
      );
      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'ส่งการประเมินสำเร็จ',
      );

      // Reload milestone to get updated state
      await loadMilestone();

      return record;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  /// Approve milestone
  Future<ProbationRecord?> approveMilestone({String? comment}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final record = await _milestoneService.approveMilestone(
        probationRecordId,
        day,
        comment: comment,
      );
      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'อนุมัติ Milestone สำเร็จ',
      );

      // Reload milestone to get updated state
      await loadMilestone();

      return record;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  /// Reject milestone
  Future<ProbationRecord?> rejectMilestone({required String reason}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final record = await _milestoneService.rejectMilestone(
        probationRecordId,
        day,
        reason: reason,
      );
      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'ไม่อนุมัติ Milestone',
      );

      // Reload milestone to get updated state
      await loadMilestone();

      return record;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear success message
  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }
}

/// Milestone detail provider (family with probationRecordId and day)
final milestoneDetailProvider = StateNotifierProvider.family<
    MilestoneDetailNotifier, MilestoneDetailState, MilestoneDetailParams>(
  (ref, params) {
    final milestoneService = ref.watch(milestoneServiceProvider);
    return MilestoneDetailNotifier(
      milestoneService,
      probationRecordId: params.probationRecordId,
      day: params.day,
    );
  },
);

/// Parameters for milestone detail provider
class MilestoneDetailParams {
  final String probationRecordId;
  final int day;

  const MilestoneDetailParams({
    required this.probationRecordId,
    required this.day,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneDetailParams &&
          runtimeType == other.runtimeType &&
          probationRecordId == other.probationRecordId &&
          day == other.day;

  @override
  int get hashCode => probationRecordId.hashCode ^ day.hashCode;
}

/// State for milestones list
class MilestonesListState {
  final List<Milestone> milestones;
  final bool canApprove;
  final bool canSubmitSelf;
  final bool canSubmitSupervisor;
  final bool isLoading;
  final String? error;

  const MilestonesListState({
    this.milestones = const [],
    this.canApprove = false,
    this.canSubmitSelf = false,
    this.canSubmitSupervisor = false,
    this.isLoading = false,
    this.error,
  });

  MilestonesListState copyWith({
    List<Milestone>? milestones,
    bool? canApprove,
    bool? canSubmitSelf,
    bool? canSubmitSupervisor,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MilestonesListState(
      milestones: milestones ?? this.milestones,
      canApprove: canApprove ?? this.canApprove,
      canSubmitSelf: canSubmitSelf ?? this.canSubmitSelf,
      canSubmitSupervisor: canSubmitSupervisor ?? this.canSubmitSupervisor,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Milestones list notifier
class MilestonesListNotifier extends StateNotifier<MilestonesListState> {
  final MilestoneService _milestoneService;
  final String probationRecordId;

  MilestonesListNotifier(this._milestoneService, {required this.probationRecordId})
      : super(const MilestonesListState());

  /// Load milestones
  Future<void> loadMilestones() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await _milestoneService.getMilestones(probationRecordId);
      state = state.copyWith(
        milestones: data['milestones'] as List<Milestone>,
        canApprove: data['canApprove'] as bool,
        canSubmitSelf: data['canSubmitSelf'] as bool,
        canSubmitSupervisor: data['canSubmitSupervisor'] as bool,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadMilestones();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Milestones list provider (family with probationRecordId)
final milestonesListProvider = StateNotifierProvider.family<
    MilestonesListNotifier, MilestonesListState, String>(
  (ref, probationRecordId) {
    final milestoneService = ref.watch(milestoneServiceProvider);
    return MilestonesListNotifier(
      milestoneService,
      probationRecordId: probationRecordId,
    );
  },
);
