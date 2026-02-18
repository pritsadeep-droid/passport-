import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/kpi_template.dart';
import '../services/kpi_template_service.dart';
import 'auth_provider.dart';

final kpiTemplateServiceProvider = Provider<KpiTemplateService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return KpiTemplateService(apiClient: apiClient);
});

final kpiTemplateListProvider =
    StateNotifierProvider<KpiTemplateListNotifier, AsyncValue<List<KpiTemplate>>>((ref) {
  final service = ref.watch(kpiTemplateServiceProvider);
  return KpiTemplateListNotifier(service);
});

class KpiTemplateListNotifier extends StateNotifier<AsyncValue<List<KpiTemplate>>> {
  final KpiTemplateService _service;

  KpiTemplateListNotifier(this._service) : super(const AsyncValue.data([]));

  Future<void> load({String? category}) async {
    state = const AsyncValue.loading();
    try {
      final templates = await _service.getTemplates(category: category);
      state = AsyncValue.data(templates);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> create(Map<String, dynamic> data) async {
    try {
      final template = await _service.createTemplate(data);
      final current = state.valueOrNull ?? [];
      state = AsyncValue.data([template, ...current]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(String id, Map<String, dynamic> data) async {
    try {
      final updated = await _service.updateTemplate(id, data);
      final current = state.valueOrNull ?? [];
      state = AsyncValue.data(
        current.map((t) => t.id == id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _service.deleteTemplate(id);
      final current = state.valueOrNull ?? [];
      state = AsyncValue.data(
        current.where((t) => t.id != id).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
