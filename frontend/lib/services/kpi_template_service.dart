import 'package:dio/dio.dart';
import '../models/kpi_template.dart';
import 'api_client.dart';

class KpiTemplateService {
  final ApiClient _apiClient;

  KpiTemplateService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<KpiTemplate>> getTemplates({String? category}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final response = await _apiClient.get(
        '/kpi-templates',
        queryParameters: queryParams,
      );

      final dataList = response.data['data'] as List<dynamic>? ?? [];
      return dataList
          .map((e) => KpiTemplate.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<KpiTemplate> createTemplate(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        '/kpi-templates',
        data: data,
      );

      return KpiTemplate.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<KpiTemplate> updateTemplate(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.put(
        '/kpi-templates/$id',
        data: data,
      );

      return KpiTemplate.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await _apiClient.delete('/kpi-templates/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
