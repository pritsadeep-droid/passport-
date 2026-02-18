// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KpiImpl _$$KpiImplFromJson(Map<String, dynamic> json) => _$KpiImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      criteria: json['criteria'] as String,
      status: $enumDecodeNullable(_$KpiStatusEnumMap, json['status']) ??
          KpiStatus.active,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$KpiImplToJson(_$KpiImpl instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'criteria': instance.criteria,
      'status': _$KpiStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$KpiStatusEnumMap = {
  KpiStatus.active: 'active',
  KpiStatus.completed: 'completed',
  KpiStatus.cancelled: 'cancelled',
};

_$CreateKpiRequestImpl _$$CreateKpiRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateKpiRequestImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      criteria: json['criteria'] as String,
    );

Map<String, dynamic> _$$CreateKpiRequestImplToJson(
        _$CreateKpiRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'criteria': instance.criteria,
    };

_$UpdateKpiRequestImpl _$$UpdateKpiRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateKpiRequestImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      criteria: json['criteria'] as String?,
      status: $enumDecodeNullable(_$KpiStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$UpdateKpiRequestImplToJson(
        _$UpdateKpiRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'criteria': instance.criteria,
      'status': _$KpiStatusEnumMap[instance.status],
    };

_$KpiScoreImpl _$$KpiScoreImplFromJson(Map<String, dynamic> json) =>
    _$KpiScoreImpl(
      kpiId: json['kpiId'] as String,
      score: (json['score'] as num).toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$KpiScoreImplToJson(_$KpiScoreImpl instance) =>
    <String, dynamic>{
      'kpiId': instance.kpiId,
      'score': instance.score,
      'comment': instance.comment,
    };
