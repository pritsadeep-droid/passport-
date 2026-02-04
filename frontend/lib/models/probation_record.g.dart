// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'probation_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinalDecisionInfoImpl _$$FinalDecisionInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$FinalDecisionInfoImpl(
      decision: $enumDecode(_$FinalDecisionEnumMap, json['decision']),
      decidedBy: json['decidedBy'] as String?,
      decidedAt: json['decidedAt'] == null
          ? null
          : DateTime.parse(json['decidedAt'] as String),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$FinalDecisionInfoImplToJson(
        _$FinalDecisionInfoImpl instance) =>
    <String, dynamic>{
      'decision': _$FinalDecisionEnumMap[instance.decision]!,
      'decidedBy': instance.decidedBy,
      'decidedAt': instance.decidedAt?.toIso8601String(),
      'reason': instance.reason,
    };

const _$FinalDecisionEnumMap = {
  FinalDecision.passed: 'passed',
  FinalDecision.failed: 'failed',
};

_$ProbationRecordImpl _$$ProbationRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$ProbationRecordImpl(
      id: json['_id'] as String,
      employeeId: json['employeeId'] as String,
      supervisorId: json['supervisorId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      probationDays: (json['probationDays'] as num).toInt(),
      endDate: DateTime.parse(json['endDate'] as String),
      status: $enumDecodeNullable(_$ProbationStatusEnumMap, json['status']) ??
          ProbationStatus.pendingKpi,
      kpis: (json['kpis'] as List<dynamic>?)
              ?.map((e) => Kpi.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => Milestone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      finalDecision: json['finalDecision'] == null
          ? null
          : FinalDecisionInfo.fromJson(
              json['finalDecision'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      daysRemaining: (json['daysRemaining'] as num?)?.toInt(),
      progressPercentage: (json['progressPercentage'] as num?)?.toInt(),
      employee: json['employee'] == null
          ? null
          : User.fromJson(json['employee'] as Map<String, dynamic>),
      supervisor: json['supervisor'] == null
          ? null
          : User.fromJson(json['supervisor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProbationRecordImplToJson(
        _$ProbationRecordImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'employeeId': instance.employeeId,
      'supervisorId': instance.supervisorId,
      'startDate': instance.startDate.toIso8601String(),
      'probationDays': instance.probationDays,
      'endDate': instance.endDate.toIso8601String(),
      'status': _$ProbationStatusEnumMap[instance.status]!,
      'kpis': instance.kpis,
      'milestones': instance.milestones,
      'finalDecision': instance.finalDecision,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'daysRemaining': instance.daysRemaining,
      'progressPercentage': instance.progressPercentage,
      'employee': instance.employee,
      'supervisor': instance.supervisor,
    };

const _$ProbationStatusEnumMap = {
  ProbationStatus.pendingKpi: 'pending_kpi',
  ProbationStatus.inProgress: 'in_progress',
  ProbationStatus.pendingDecision: 'pending_decision',
  ProbationStatus.passed: 'passed',
  ProbationStatus.failed: 'failed',
  ProbationStatus.resigned: 'resigned',
  ProbationStatus.terminated: 'terminated',
};

_$CreateProbationRequestImpl _$$CreateProbationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateProbationRequestImpl(
      employeeId: json['employeeId'] as String,
      supervisorId: json['supervisorId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      probationDays: (json['probationDays'] as num?)?.toInt() ?? 90,
    );

Map<String, dynamic> _$$CreateProbationRequestImplToJson(
        _$CreateProbationRequestImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'supervisorId': instance.supervisorId,
      'startDate': instance.startDate.toIso8601String(),
      'probationDays': instance.probationDays,
    };

_$UpdateProbationStatusRequestImpl _$$UpdateProbationStatusRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProbationStatusRequestImpl(
      status: $enumDecode(_$ProbationStatusEnumMap, json['status']),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$UpdateProbationStatusRequestImplToJson(
        _$UpdateProbationStatusRequestImpl instance) =>
    <String, dynamic>{
      'status': _$ProbationStatusEnumMap[instance.status]!,
      'reason': instance.reason,
    };

_$FinalDecisionRequestImpl _$$FinalDecisionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$FinalDecisionRequestImpl(
      decision: $enumDecode(_$FinalDecisionEnumMap, json['decision']),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$FinalDecisionRequestImplToJson(
        _$FinalDecisionRequestImpl instance) =>
    <String, dynamic>{
      'decision': _$FinalDecisionEnumMap[instance.decision]!,
      'reason': instance.reason,
    };

_$TransferSupervisorRequestImpl _$$TransferSupervisorRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferSupervisorRequestImpl(
      newSupervisorId: json['newSupervisorId'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$TransferSupervisorRequestImplToJson(
        _$TransferSupervisorRequestImpl instance) =>
    <String, dynamic>{
      'newSupervisorId': instance.newSupervisorId,
      'reason': instance.reason,
    };
