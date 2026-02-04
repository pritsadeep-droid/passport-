import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';
import 'auth_provider.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SettingsService(apiClient: apiClient);
});

final milestoneSettingsProvider =
    StateNotifierProvider<MilestoneSettingsNotifier, AsyncValue<MilestoneSettingsData?>>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return MilestoneSettingsNotifier(settingsService);
});

class MilestoneSettingsNotifier extends StateNotifier<AsyncValue<MilestoneSettingsData?>> {
  final SettingsService _settingsService;

  MilestoneSettingsNotifier(this._settingsService) : super(const AsyncValue.data(null));

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _settingsService.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateSettings(MilestoneSettingsData data) async {
    try {
      final updated = await _settingsService.updateMilestoneSettings(data);
      state = AsyncValue.data(updated);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
