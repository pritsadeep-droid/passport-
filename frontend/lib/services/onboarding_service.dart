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
      final data = response.data['data'] as List;
      return data
          .map((e) => OnboardingTemplate.fromJson(e as Map<String, dynamic>))
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
      final data = response.data['data'] as List;
      return data
          .map((e) => OnboardingInstance.fromJson(e as Map<String, dynamic>))
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
}
