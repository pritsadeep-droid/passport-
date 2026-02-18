import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi.freezed.dart';
part 'kpi.g.dart';

enum KpiStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class Kpi with _$Kpi {
  const factory Kpi({
    required String id,
    required String title,
    required String description,
    required String criteria,
    @Default(KpiStatus.active) KpiStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Kpi;

  factory Kpi.fromJson(Map<String, dynamic> json) => _$KpiFromJson(json);
}

@freezed
class CreateKpiRequest with _$CreateKpiRequest {
  const factory CreateKpiRequest({
    required String title,
    required String description,
    required String criteria,
  }) = _CreateKpiRequest;

  factory CreateKpiRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateKpiRequestFromJson(json);
}

@freezed
class UpdateKpiRequest with _$UpdateKpiRequest {
  const factory UpdateKpiRequest({
    String? title,
    String? description,
    String? criteria,
    KpiStatus? status,
  }) = _UpdateKpiRequest;

  factory UpdateKpiRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateKpiRequestFromJson(json);
}

@freezed
class KpiScore with _$KpiScore {
  const factory KpiScore({
    required String kpiId,
    required int score,
    String? comment,
  }) = _KpiScore;

  factory KpiScore.fromJson(Map<String, dynamic> json) =>
      _$KpiScoreFromJson(json);
}

extension KpiStatusExtension on KpiStatus {
  String get displayName {
    switch (this) {
      case KpiStatus.active:
        return 'กำลังดำเนินการ';
      case KpiStatus.completed:
        return 'เสร็จสิ้น';
      case KpiStatus.cancelled:
        return 'ยกเลิก';
    }
  }

  bool get isActive => this == KpiStatus.active;
  bool get isCompleted => this == KpiStatus.completed;
  bool get isCancelled => this == KpiStatus.cancelled;
}
