import 'package:dio/dio.dart';
import '../models/probation_record.dart';
import 'api_client.dart';

class ProbationService {
  final ApiClient _apiClient;

  ProbationService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get probation records (filtered by role)
  Future<PaginatedResponse<ProbationRecord>> getProbationRecords({
    int page = 1,
    int limit = 20,
    ProbationStatus? status,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) {
        queryParams['status'] = status.name;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.get(
        '/probation',
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => ProbationRecord.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get probation record by ID
  Future<ProbationRecord> getProbationRecordById(String id) async {
    try {
      final response = await _apiClient.get('/probation/$id');
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get probation record by employee ID
  Future<ProbationRecord> getProbationRecordByEmployeeId(
      String employeeId) async {
    try {
      final response = await _apiClient.get('/probation/employee/$employeeId');
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get my probation record (for employee)
  Future<ProbationRecord> getMyProbationRecord() async {
    try {
      final response = await _apiClient.get('/probation/me');
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Create probation record (HR Admin only)
  Future<ProbationRecord> createProbationRecord(
      CreateProbationRequest request) async {
    try {
      final response = await _apiClient.post(
        '/probation',
        data: request.toJson(),
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Update probation status (HR Admin only)
  Future<ProbationRecord> updateProbationStatus(
    String id,
    UpdateProbationStatusRequest request,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/probation/$id/status',
        data: request.toJson(),
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Make final decision (HR Admin only)
  Future<ProbationRecord> makeFinalDecision(
    String id,
    FinalDecisionRequest request,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/probation/$id/status',
        data: {
          'status': request.decision.name,
          'reason': request.reason,
        },
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Transfer supervisor (HR Admin only)
  Future<ProbationRecord> transferSupervisor(
    String id,
    TransferSupervisorRequest request,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/probation/$id/supervisor',
        data: request.toJson(),
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Extend probation period (HR Admin only)
  Future<ProbationRecord> extendProbation(
    String id,
    ExtendProbationRequest request,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/probation/$id/extend',
        data: request.toJson(),
      );
      return ProbationRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
