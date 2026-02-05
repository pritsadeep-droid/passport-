import 'package:freezed_annotation/freezed_annotation.dart';
import 'kpi.dart';
import 'milestone.dart';
import 'user.dart';

part 'probation_record.freezed.dart';
part 'probation_record.g.dart';

/// Converter that handles both String ID and populated User object
class StringOrUserIdConverter implements JsonConverter<String, dynamic> {
  const StringOrUserIdConverter();

  @override
  String fromJson(dynamic json) {
    if (json is String) {
      return json;
    } else if (json is Map<String, dynamic>) {
      return json['_id'] as String? ?? '';
    }
    return '';
  }

  @override
  dynamic toJson(String object) => object;
}

/// Converter that extracts User from populated employeeId/supervisorId field
class PopulatedUserConverter implements JsonConverter<User?, dynamic> {
  const PopulatedUserConverter();

  @override
  User? fromJson(dynamic json) {
    if (json is Map<String, dynamic> && json.containsKey('_id')) {
      return User.fromJson(json);
    }
    return null;
  }

  @override
  dynamic toJson(User? object) => object?.toJson();
}

/// Helper to read employee User from employeeId field
dynamic _readEmployeeFromJson(Map json, String key) {
  // First check if employee field exists directly
  if (json.containsKey('employee') && json['employee'] != null) {
    return json['employee'];
  }
  // Otherwise try to extract from employeeId if it's an object
  final employeeId = json['employeeId'];
  if (employeeId is Map<String, dynamic>) {
    return employeeId;
  }
  return null;
}

/// Helper to read supervisor User from supervisorId field
dynamic _readSupervisorFromJson(Map json, String key) {
  // First check if supervisor field exists directly
  if (json.containsKey('supervisor') && json['supervisor'] != null) {
    return json['supervisor'];
  }
  // Otherwise try to extract from supervisorId if it's an object
  final supervisorId = json['supervisorId'];
  if (supervisorId is Map<String, dynamic>) {
    return supervisorId;
  }
  return null;
}

enum ProbationStatus {
  @JsonValue('pending_kpi')
  pendingKpi,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('pending_decision')
  pendingDecision,
  @JsonValue('passed')
  passed,
  @JsonValue('failed')
  failed,
  @JsonValue('resigned')
  resigned,
  @JsonValue('terminated')
  terminated,
}

enum FinalDecision {
  @JsonValue('passed')
  passed,
  @JsonValue('failed')
  failed,
}

@freezed
class FinalDecisionInfo with _$FinalDecisionInfo {
  const factory FinalDecisionInfo({
    required FinalDecision decision,
    String? decidedBy,
    DateTime? decidedAt,
    String? reason,
  }) = _FinalDecisionInfo;

  factory FinalDecisionInfo.fromJson(Map<String, dynamic> json) =>
      _$FinalDecisionInfoFromJson(json);
}

@freezed
class ProbationRecord with _$ProbationRecord {
  const factory ProbationRecord({
    @JsonKey(name: '_id') required String id,
    @StringOrUserIdConverter() required String employeeId,
    @StringOrUserIdConverter() required String supervisorId,
    required DateTime startDate,
    required int probationDays,
    required DateTime endDate,
    @Default(ProbationStatus.pendingKpi) ProbationStatus status,
    @Default([]) List<Kpi> kpis,
    @Default([]) List<Milestone> milestones,
    FinalDecisionInfo? finalDecision,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Virtual fields
    int? daysRemaining,
    int? progressPercentage,
    // Populated fields - read from employeeId/supervisorId if they contain objects
    @JsonKey(readValue: _readEmployeeFromJson) @PopulatedUserConverter() User? employee,
    @JsonKey(readValue: _readSupervisorFromJson) @PopulatedUserConverter() User? supervisor,
  }) = _ProbationRecord;

  factory ProbationRecord.fromJson(Map<String, dynamic> json) =>
      _$ProbationRecordFromJson(json);
}

@freezed
class CreateProbationRequest with _$CreateProbationRequest {
  const factory CreateProbationRequest({
    required String employeeId,
    required String supervisorId,
    required DateTime startDate,
    @Default(90) int probationDays,
  }) = _CreateProbationRequest;

  factory CreateProbationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProbationRequestFromJson(json);
}

@freezed
class UpdateProbationStatusRequest with _$UpdateProbationStatusRequest {
  const factory UpdateProbationStatusRequest({
    required ProbationStatus status,
    String? reason,
  }) = _UpdateProbationStatusRequest;

  factory UpdateProbationStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProbationStatusRequestFromJson(json);
}

@freezed
class FinalDecisionRequest with _$FinalDecisionRequest {
  const factory FinalDecisionRequest({
    required FinalDecision decision,
    String? reason,
  }) = _FinalDecisionRequest;

  factory FinalDecisionRequest.fromJson(Map<String, dynamic> json) =>
      _$FinalDecisionRequestFromJson(json);
}

@freezed
class TransferSupervisorRequest with _$TransferSupervisorRequest {
  const factory TransferSupervisorRequest({
    required String newSupervisorId,
    String? reason,
  }) = _TransferSupervisorRequest;

  factory TransferSupervisorRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferSupervisorRequestFromJson(json);
}

extension ProbationRecordExtension on ProbationRecord {
  /// Calculate days remaining until probation ends
  int get calculatedDaysRemaining {
    if (daysRemaining != null) return daysRemaining!;
    final now = DateTime.now();
    final diff = endDate.difference(now);
    return diff.inDays > 0 ? diff.inDays : 0;
  }

  /// Calculate progress percentage
  int get calculatedProgressPercentage {
    if (progressPercentage != null) return progressPercentage!;
    final now = DateTime.now();
    final totalDays = endDate.difference(startDate).inDays;
    final elapsedDays = now.difference(startDate).inDays;
    final percentage = (elapsedDays / totalDays * 100).round();
    return percentage.clamp(0, 100);
  }

  /// Get current/active milestone
  Milestone? get currentMilestone {
    return milestones.cast<Milestone?>().firstWhere(
          (m) => m != null && !m.status.isCompleted,
          orElse: () => null,
        );
  }

  /// Get next upcoming milestone
  Milestone? get nextMilestone {
    return milestones.cast<Milestone?>().firstWhere(
          (m) => m != null && m.status.isUpcoming,
          orElse: () => null,
        );
  }

  /// Check if all milestones are passed
  bool get allMilestonesPassed {
    return milestones.isNotEmpty &&
        milestones.every((m) => m.status.isPassed);
  }

  /// Check if any milestone failed
  bool get anyMilestoneFailed {
    return milestones.any((m) => m.status.isFailed);
  }

  /// Count passed milestones
  int get passedMilestonesCount {
    return milestones.where((m) => m.status.isPassed).length;
  }

  /// Check if KPIs are set
  bool get hasKpis => kpis.isNotEmpty;

  /// Check if KPIs are valid (3-5)
  bool get hasValidKpiCount => kpis.length >= 3 && kpis.length <= 5;
}

extension ProbationStatusExtension on ProbationStatus {
  String get displayName {
    switch (this) {
      case ProbationStatus.pendingKpi:
        return 'รอกำหนด KPI';
      case ProbationStatus.inProgress:
        return 'กำลังดำเนินการ';
      case ProbationStatus.pendingDecision:
        return 'รอตัดสินใจ';
      case ProbationStatus.passed:
        return 'ผ่านทดลองงาน';
      case ProbationStatus.failed:
        return 'ไม่ผ่านทดลองงาน';
      case ProbationStatus.resigned:
        return 'ลาออก';
      case ProbationStatus.terminated:
        return 'ถูกยกเลิก';
    }
  }

  bool get isPendingKpi => this == ProbationStatus.pendingKpi;
  bool get isInProgress => this == ProbationStatus.inProgress;
  bool get isPendingDecision => this == ProbationStatus.pendingDecision;
  bool get isPassed => this == ProbationStatus.passed;
  bool get isFailed => this == ProbationStatus.failed;
  bool get isResigned => this == ProbationStatus.resigned;
  bool get isTerminated => this == ProbationStatus.terminated;

  bool get isActive => isInProgress || isPendingKpi || isPendingDecision;
  bool get isCompleted => isPassed || isFailed || isResigned || isTerminated;
}

extension FinalDecisionExtension on FinalDecision {
  String get displayName {
    switch (this) {
      case FinalDecision.passed:
        return 'ผ่านทดลองงาน';
      case FinalDecision.failed:
        return 'ไม่ผ่านทดลองงาน';
    }
  }
}
