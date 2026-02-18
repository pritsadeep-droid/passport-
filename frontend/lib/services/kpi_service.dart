import 'package:dio/dio.dart';
import '../models/kpi.dart';
import '../models/probation_record.dart';
import 'api_client.dart';

class KpiService {
  final ApiClient _apiClient;

  KpiService({required ApiClient apiClient}) : _apiClient = apiClient;

  static const int minKpis = 3;
  static const int maxKpis = 5;

  /// Get KPIs for a probation record
  Future<KpiListResponse> getKpis(String probationRecordId) async {
    try {
      final response = await _apiClient.get(
        '/probation/$probationRecordId/kpis',
      );
      return KpiListResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Create KPIs for a probation record (batch)
  Future<ProbationRecord> createKpis(
    String probationRecordId,
    List<CreateKpiRequest> kpis,
  ) async {
    try {
      final response = await _apiClient.post(
        '/probation/$probationRecordId/kpis',
        data: {
          'kpis': kpis.map((k) => k.toJson()).toList(),
        },
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Add single KPI to probation record
  Future<ProbationRecord> addKpi(
    String probationRecordId,
    CreateKpiRequest kpi,
  ) async {
    try {
      final response = await _apiClient.post(
        '/probation/$probationRecordId/kpis/add',
        data: kpi.toJson(),
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Update a KPI
  Future<ProbationRecord> updateKpi(
    String probationRecordId,
    String kpiId,
    UpdateKpiRequest update,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/probation/$probationRecordId/kpis/$kpiId',
        data: update.toJson(),
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Delete a KPI
  Future<ProbationRecord> deleteKpi(
    String probationRecordId,
    String kpiId,
  ) async {
    try {
      final response = await _apiClient.delete(
        '/probation/$probationRecordId/kpis/$kpiId',
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Validate KPI count
  bool isValidKpiCount(int count) {
    return count >= minKpis && count <= maxKpis;
  }

  /// Get validation message for KPI count
  String? getKpiCountError(int count) {
    if (count < minKpis) {
      return 'ต้องมี KPI อย่างน้อย $minKpis ข้อ';
    }
    if (count > maxKpis) {
      return 'KPI ได้สูงสุด $maxKpis ข้อ';
    }
    return null;
  }
}

/// Response for KPI list
class KpiListResponse {
  final List<Kpi> kpis;
  final bool canEdit;
  final int minKpis;
  final int maxKpis;

  KpiListResponse({
    required this.kpis,
    required this.canEdit,
    required this.minKpis,
    required this.maxKpis,
  });

  factory KpiListResponse.fromJson(Map<String, dynamic> json) {
    return KpiListResponse(
      kpis: (json['kpis'] as List?)
              ?.map((e) => Kpi.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      canEdit: json['canEdit'] ?? false,
      minKpis: json['minKpis'] ?? 3,
      maxKpis: json['maxKpis'] ?? 5,
    );
  }
}
