import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding.dart';
import '../services/onboarding_service.dart';
import 'auth_provider.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OnboardingService(apiClient: apiClient);
});

// My Onboarding (for Employee)
final myOnboardingProvider = StateNotifierProvider<MyOnboardingNotifier, AsyncValue<OnboardingInstance?>>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  return MyOnboardingNotifier(service);
});

class MyOnboardingNotifier extends StateNotifier<AsyncValue<OnboardingInstance?>> {
  final OnboardingService _service;

  MyOnboardingNotifier(this._service) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final instance = await _service.getMyOnboarding();
      state = AsyncValue.data(instance);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submitAnswer(String questionId, String text, [List<String>? attachments]) async {
    try {
      final request = SubmitAnswerRequest(
        questionId: questionId,
        text: text,
        attachments: attachments,
      );
      final updatedInstance = await _service.submitAnswer(request);
      state = AsyncValue.data(updatedInstance);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeEvent(String instanceId, String eventCode, {String? notes}) async {
    try {
      final updatedInstance = await _service.completeEvent(instanceId, eventCode, notes: notes);
      state = AsyncValue.data(updatedInstance);
    } catch (e) {
      rethrow;
    }
  }
}

// Team Onboarding (for Supervisor/Admin)
final teamOnboardingProvider = FutureProvider<List<OnboardingInstance>>((ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return service.getTeamOnboarding();
});

// Single Onboarding Detail (for Review)
final onboardingDetailProvider = StateNotifierProvider.family<OnboardingDetailNotifier, AsyncValue<OnboardingInstance?>, String>((ref, id) {
  final service = ref.watch(onboardingServiceProvider);
  return OnboardingDetailNotifier(service, id);
});

class OnboardingDetailNotifier extends StateNotifier<AsyncValue<OnboardingInstance?>> {
  final OnboardingService _service;
  final String _id;

  OnboardingDetailNotifier(this._service, this._id) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final instance = await _service.getOnboardingById(_id);
      state = AsyncValue.data(instance);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> reviewMission(String missionCode, String decision, double? score, String? comment) async {
    try {
      final request = ReviewMissionRequest(
        onboardingId: _id,
        missionCode: missionCode,
        decision: decision,
        score: score,
        comment: comment,
      );
      final updatedInstance = await _service.reviewMission(request);
      state = AsyncValue.data(updatedInstance);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeEvent(String eventCode, {String? notes}) async {
    try {
      final updatedInstance = await _service.completeEvent(_id, eventCode, notes: notes);
      state = AsyncValue.data(updatedInstance);
    } catch (e) {
      rethrow;
    }
  }
}

// Templates (for Admin)
final onboardingTemplatesProvider = FutureProvider<List<OnboardingTemplate>>((ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return service.getTemplates();
});

// Assign Onboarding
class AssignOnboardingNotifier extends StateNotifier<AsyncValue<OnboardingInstance?>> {
  final OnboardingService _service;

  AssignOnboardingNotifier(this._service) : super(const AsyncValue.data(null));

  Future<bool> assign(String employeeId, String templateId, DateTime? startDate) async {
    state = const AsyncValue.loading();
    try {
      final request = AssignOnboardingRequest(
        employeeId: employeeId,
        templateId: templateId,
        startDate: startDate,
      );
      final instance = await _service.assignOnboarding(request);
      state = AsyncValue.data(instance);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final assignOnboardingProvider = StateNotifierProvider<AssignOnboardingNotifier, AsyncValue<OnboardingInstance?>>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  return AssignOnboardingNotifier(service);
});
