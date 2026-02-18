// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MilestoneImpl _$$MilestoneImplFromJson(Map<String, dynamic> json) =>
    _$MilestoneImpl(
      day: (json['day'] as num).toInt(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: $enumDecodeNullable(_$MilestoneStatusEnumMap, json['status']) ??
          MilestoneStatus.upcoming,
      selfAssessment: json['selfAssessment'] == null
          ? null
          : SelfAssessment.fromJson(
              json['selfAssessment'] as Map<String, dynamic>),
      supervisorAssessment: json['supervisorAssessment'] == null
          ? null
          : SupervisorAssessment.fromJson(
              json['supervisorAssessment'] as Map<String, dynamic>),
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      approvedBy: json['approvedBy'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$$MilestoneImplToJson(_$MilestoneImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': _$MilestoneStatusEnumMap[instance.status]!,
      'selfAssessment': instance.selfAssessment,
      'supervisorAssessment': instance.supervisorAssessment,
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'approvedBy': instance.approvedBy,
      'rejectionReason': instance.rejectionReason,
    };

const _$MilestoneStatusEnumMap = {
  MilestoneStatus.upcoming: 'upcoming',
  MilestoneStatus.pendingSelf: 'pending_self',
  MilestoneStatus.pendingSupervisor: 'pending_supervisor',
  MilestoneStatus.pendingApproval: 'pending_approval',
  MilestoneStatus.passed: 'passed',
  MilestoneStatus.failed: 'failed',
  MilestoneStatus.overdue: 'overdue',
};

_$ApproveMilestoneRequestImpl _$$ApproveMilestoneRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ApproveMilestoneRequestImpl(
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$ApproveMilestoneRequestImplToJson(
        _$ApproveMilestoneRequestImpl instance) =>
    <String, dynamic>{
      'comment': instance.comment,
    };

_$RejectMilestoneRequestImpl _$$RejectMilestoneRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RejectMilestoneRequestImpl(
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$RejectMilestoneRequestImplToJson(
        _$RejectMilestoneRequestImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
    };
