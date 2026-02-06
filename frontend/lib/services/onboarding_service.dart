import 'package:dio/dio.dart';
import '../models/onboarding.dart';
import 'api_client.dart';

class OnboardingService {
  final ApiClient _apiClient;

  OnboardingService({required ApiClient apiClient}) : _apiClient = apiClient;

  // Templates
  Future<List<OnboardingTemplate>> getTemplates() async {
    try {
      final response = await _apiClient.get('/onboarding/templates');
      final data = response.data['data'];
      if (data == null || data is! List) {
        return <OnboardingTemplate>[];
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => OnboardingTemplate.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Instances
  Future<OnboardingInstance> assignOnboarding(AssignOnboardingRequest request) async {
    try {
      final response = await _apiClient.post(
        '/onboarding/assign',
        data: request.toJson(),
      );
      return OnboardingInstance.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<OnboardingInstance> getMyOnboarding() async {
    try {
      final response = await _apiClient.get('/onboarding/me');
      return OnboardingInstance.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<OnboardingInstance>> getTeamOnboarding() async {
    try {
      final response = await _apiClient.get('/onboarding/team');
      final data = response.data['data'];
      if (data == null || data is! List) {
        return <OnboardingInstance>[];
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => OnboardingInstance.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<OnboardingInstance> getOnboardingById(String id) async {
    try {
      final response = await _apiClient.get('/onboarding/$id');
      return OnboardingInstance.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Actions
  Future<OnboardingInstance> submitAnswer(SubmitAnswerRequest request) async {
    try {
      final response = await _apiClient.post(
        '/onboarding/submit',
        data: request.toJson(),
      );
      return OnboardingInstance.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<OnboardingInstance> reviewMission(ReviewMissionRequest request) async {
    try {
      final response = await _apiClient.post(
        '/onboarding/review',
        data: request.toJson(),
      );
      return OnboardingInstance.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<OnboardingInstance> completeEvent(String instanceId, String eventCode, {String? notes}) async {
    try {
      final response = await _apiClient.post(
        '/onboarding/$instanceId/complete-event',
        data: {
          'eventCode': eventCode,
          if (notes != null) 'notes': notes,
        },
      );
      return OnboardingInstance.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> getJourneyProgress(String instanceId) async {
    try {
      final response = await _apiClient.get('/onboarding/$instanceId/journey');
      final data = response.data['data'];
      if (data == null || data is! Map<String, dynamic>) {
        return <String, dynamic>{};
      }
      return data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Template Management (HR Admin)
  Future<OnboardingTemplate> createTemplate(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/onboarding/templates', data: data);
      return OnboardingTemplate.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<OnboardingTemplate> updateTemplate(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/onboarding/templates/$id', data: data);
      return OnboardingTemplate.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
