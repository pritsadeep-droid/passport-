import 'package:freezed_annotation/freezed_annotation.dart';
import 'assessment.dart';

part 'milestone.freezed.dart';
part 'milestone.g.dart';

enum MilestoneStatus {
  @JsonValue('upcoming')
  upcoming,
  @JsonValue('pending_self')
  pendingSelf,
  @JsonValue('pending_supervisor')
  pendingSupervisor,
  @JsonValue('pending_approval')
  pendingApproval,
  @JsonValue('passed')
  passed,
  @JsonValue('failed')
  failed,
  @JsonValue('overdue')
  overdue,
}

@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required int day,
    required DateTime dueDate,
    @Default(MilestoneStatus.upcoming) MilestoneStatus status,
    SelfAssessment? selfAssessment,
    SupervisorAssessment? supervisorAssessment,
    DateTime? approvedAt,
    String? approvedBy,
    String? rejectionReason,
  }) = _Milestone;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
}

@freezed
class ApproveMilestoneRequest with _$ApproveMilestoneRequest {
  const factory ApproveMilestoneRequest({
    String? comment,
  }) = _ApproveMilestoneRequest;

  factory ApproveMilestoneRequest.fromJson(Map<String, dynamic> json) =>
      _$ApproveMilestoneRequestFromJson(json);
}

@freezed
class RejectMilestoneRequest with _$RejectMilestoneRequest {
  const factory RejectMilestoneRequest({
    required String reason,
  }) = _RejectMilestoneRequest;

  factory RejectMilestoneRequest.fromJson(Map<String, dynamic> json) =>
      _$RejectMilestoneRequestFromJson(json);
}

extension MilestoneExtension on Milestone {
  /// Get days remaining until due date
  int get daysRemaining {
    final now = DateTime.now();
    final diff = dueDate.difference(now);
    return diff.inDays;
  }

  /// Check if milestone is overdue
  bool get isOverdue {
    return DateTime.now().isAfter(dueDate) && status != MilestoneStatus.passed;
  }

  /// Check if self assessment is needed
  bool get needsSelfAssessment {
    return status == MilestoneStatus.pendingSelf ||
        (status == MilestoneStatus.upcoming && daysRemaining <= 7);
  }

  /// Check if supervisor assessment is needed
  bool get needsSupervisorAssessment {
    return status == MilestoneStatus.pendingSupervisor;
  }

  /// Check if approval is needed
  bool get needsApproval {
    return status == MilestoneStatus.pendingApproval;
  }

  /// Get display label for milestone day
  String get displayLabel {
    switch (day) {
      case 30:
        return '30 วัน';
      case 60:
        return '60 วัน';
      case 90:
        return '90 วัน';
      case 119:
        return '119 วัน';
      default:
        return '$day วัน';
    }
  }
}

extension MilestoneStatusExtension on MilestoneStatus {
  String get displayName {
    switch (this) {
      case MilestoneStatus.upcoming:
        return 'ยังไม่ถึงกำหนด';
      case MilestoneStatus.pendingSelf:
        return 'รอประเมินตนเอง';
      case MilestoneStatus.pendingSupervisor:
        return 'รอหัวหน้าประเมิน';
      case MilestoneStatus.pendingApproval:
        return 'รอยอมรับ';
      case MilestoneStatus.passed:
        return 'ผ่าน';
      case MilestoneStatus.failed:
        return 'ไม่ผ่าน';
      case MilestoneStatus.overdue:
        return 'เกินกำหนด';
    }
  }

  bool get isUpcoming => this == MilestoneStatus.upcoming;
  bool get isPendingSelf => this == MilestoneStatus.pendingSelf;
  bool get isPendingSupervisor => this == MilestoneStatus.pendingSupervisor;
  bool get isPendingApproval => this == MilestoneStatus.pendingApproval;
  bool get isPassed => this == MilestoneStatus.passed;
  bool get isFailed => this == MilestoneStatus.failed;
  bool get isOverdue => this == MilestoneStatus.overdue;

  bool get isCompleted => isPassed || isFailed;
  bool get isPending => isPendingSelf || isPendingSupervisor || isPendingApproval;
}
