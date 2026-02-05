import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/kpi.dart';
import '../services/kpi_service.dart';
import 'auth_provider.dart';
import 'probation_provider.dart';

/// KPI service provider
final kpiServiceProvider = Provider<KpiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return KpiService(apiClient: apiClient);
});

/// State for KPI management
class KpiState {
  final List<Kpi> kpis;
  final bool isLoading;
  final bool isSaving;
  final bool canEdit;
  final String? error;
  final String? successMessage;

  const KpiState({
    this.kpis = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.canEdit = false,
    this.error,
    this.successMessage,
  });

  KpiState copyWith({
    List<Kpi>? kpis,
    bool? isLoading,
    bool? isSaving,
    bool? canEdit,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return KpiState(
      kpis: kpis ?? this.kpis,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      canEdit: canEdit ?? this.canEdit,
      error: clearError ? null : (error ?? this.error),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  int get kpiCount => kpis.length;
  bool get canAddMore => kpiCount < KpiService.maxKpis;
  bool get hasMinimumKpis => kpiCount >= KpiService.minKpis;
  bool get isValidCount =>
      kpiCount >= KpiService.minKpis && kpiCount <= KpiService.maxKpis;

  String? get validationError {
    if (kpiCount < KpiService.minKpis) {
      return 'ต้องมี KPI อย่างน้อย ${KpiService.minKpis} ข้อ';
    }
    if (kpiCount > KpiService.maxKpis) {
      return 'KPI ได้สูงสุด ${KpiService.maxKpis} ข้อ';
    }
    return null;
  }
}

/// KPI notifier for managing KPIs
class KpiNotifier extends StateNotifier<KpiState> {
  final KpiService _kpiService;
  final ProbationListNotifier? _probationListNotifier;
  String? _probationRecordId;

  KpiNotifier(
    this._kpiService, {
    ProbationListNotifier? probationListNotifier,
  })  : _probationListNotifier = probationListNotifier,
        super(const KpiState());

  /// Load KPIs for a probation record
  Future<void> loadKpis(String probationRecordId) async {
    _probationRecordId = probationRecordId;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _kpiService.getKpis(probationRecordId);
      state = state.copyWith(
        kpis: response.kpis,
        canEdit: response.canEdit,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Create KPIs (batch)
  Future<bool> createKpis(List<CreateKpiRequest> kpis) async {
    if (_probationRecordId == null) return false;

    // Validate count
    final countError = _kpiService.getKpiCountError(kpis.length);
    if (countError != null) {
      state = state.copyWith(error: countError);
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final record = await _kpiService.createKpis(_probationRecordId!, kpis);

      state = state.copyWith(
        kpis: record.kpis,
        isSaving: false,
        successMessage: 'สร้าง KPI สำเร็จ',
      );

      // Update probation list if available
      _probationListNotifier?.updateRecord(record);

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Add single KPI
  Future<bool> addKpi(CreateKpiRequest kpi) async {
    if (_probationRecordId == null) return false;

    if (!state.canAddMore) {
      state = state.copyWith(
        error: 'KPI ได้สูงสุด ${KpiService.maxKpis} ข้อ',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final record = await _kpiService.addKpi(_probationRecordId!, kpi);

      state = state.copyWith(
        kpis: record.kpis,
        isSaving: false,
        successMessage: 'เพิ่ม KPI สำเร็จ',
      );

      _probationListNotifier?.updateRecord(record);

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update a KPI
  Future<bool> updateKpi(String kpiId, UpdateKpiRequest update) async {
    if (_probationRecordId == null) return false;

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final record = await _kpiService.updateKpi(
        _probationRecordId!,
        kpiId,
        update,
      );

      state = state.copyWith(
        kpis: record.kpis,
        isSaving: false,
        successMessage: 'แก้ไข KPI สำเร็จ',
      );

      _probationListNotifier?.updateRecord(record);

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Delete a KPI
  Future<bool> deleteKpi(String kpiId) async {
    if (_probationRecordId == null) return false;

    // Check if can delete (minimum count)
    if (state.kpiCount <= KpiService.minKpis) {
      state = state.copyWith(
        error: 'ต้องมี KPI อย่างน้อย ${KpiService.minKpis} ข้อ',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final record = await _kpiService.deleteKpi(_probationRecordId!, kpiId);

      state = state.copyWith(
        kpis: record.kpis,
        isSaving: false,
        successMessage: 'ลบ KPI สำเร็จ',
      );

      _probationListNotifier?.updateRecord(record);

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Add KPI to local state (before saving)
  void addLocalKpi(Kpi kpi) {
    if (!state.canAddMore) return;
    state = state.copyWith(kpis: [...state.kpis, kpi]);
  }

  /// Remove KPI from local state (before saving)
  void removeLocalKpi(String kpiId) {
    final kpis = state.kpis.where((k) => k.id != kpiId).toList();
    state = state.copyWith(kpis: kpis);
  }

  /// Update KPI in local state (before saving)
  void updateLocalKpi(Kpi kpi) {
    final kpis = state.kpis.map((k) => k.id == kpi.id ? kpi : k).toList();
    state = state.copyWith(kpis: kpis);
  }

  /// Clear local KPIs
  void clearLocalKpis() {
    state = state.copyWith(kpis: []);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear success message
  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }

  /// Clear all messages
  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

/// KPI provider (family for different probation records)
final kpiProvider =
    StateNotifierProvider.family<KpiNotifier, KpiState, String?>((ref, probationRecordId) {
  final kpiService = ref.watch(kpiServiceProvider);
  final probationListNotifier = ref.watch(probationListProvider.notifier);

  return KpiNotifier(
    kpiService,
    probationListNotifier: probationListNotifier,
  );
});

/// KPI form provider (for creating new KPIs)
final kpiFormProvider =
    StateNotifierProvider.family<KpiNotifier, KpiState, String?>((ref, probationRecordId) {
  final kpiService = ref.watch(kpiServiceProvider);
  final probationListNotifier = ref.watch(probationListProvider.notifier);

  return KpiNotifier(
    kpiService,
    probationListNotifier: probationListNotifier,
  );
});
