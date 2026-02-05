import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/probation_record.dart';
import '../services/probation_service.dart';
import 'auth_provider.dart';

/// Probation service provider
final probationServiceProvider = Provider<ProbationService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProbationService(apiClient: apiClient);
});

/// State for probation records list
class ProbationListState {
  final List<ProbationRecord> records;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;
  final ProbationStatus? statusFilter;
  final String? searchQuery;

  const ProbationListState({
    this.records = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
    this.statusFilter,
    this.searchQuery,
  });

  ProbationListState copyWith({
    List<ProbationRecord>? records,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
    ProbationStatus? statusFilter,
    String? searchQuery,
    bool clearError = false,
  }) {
    return ProbationListState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: clearError ? null : (error ?? this.error),
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Probation list notifier
class ProbationListNotifier extends StateNotifier<ProbationListState> {
  final ProbationService _probationService;
  static const int _pageSize = 20;

  ProbationListNotifier(this._probationService)
      : super(const ProbationListState());

  /// Load initial records
  Future<void> loadRecords({
    ProbationStatus? status,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = ProbationListState(
        statusFilter: status,
        searchQuery: search,
        isLoading: true,
      );
    } else {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        statusFilter: status,
        searchQuery: search,
      );
    }

    try {
      final response = await _probationService.getProbationRecords(
        page: 1,
        limit: _pageSize,
        status: status,
        search: search,
      );

      state = state.copyWith(
        records: response.data,
        isLoading: false,
        hasMore: response.hasNextPage,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more records (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _probationService.getProbationRecords(
        page: nextPage,
        limit: _pageSize,
        status: state.statusFilter,
        search: state.searchQuery,
      );

      state = state.copyWith(
        records: [...state.records, ...response.data],
        isLoading: false,
        hasMore: response.hasNextPage,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh records
  Future<void> refresh() async {
    await loadRecords(
      status: state.statusFilter,
      search: state.searchQuery,
      refresh: true,
    );
  }

  /// Update a record in the list
  void updateRecord(ProbationRecord updatedRecord) {
    final records = state.records.map((record) {
      return record.id == updatedRecord.id ? updatedRecord : record;
    }).toList();

    state = state.copyWith(records: records);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Probation list provider
final probationListProvider =
    StateNotifierProvider<ProbationListNotifier, ProbationListState>((ref) {
  final probationService = ref.watch(probationServiceProvider);
  return ProbationListNotifier(probationService);
});

/// State for single probation record
class ProbationDetailState {
  final ProbationRecord? record;
  final bool isLoading;
  final String? error;

  const ProbationDetailState({
    this.record,
    this.isLoading = false,
    this.error,
  });

  ProbationDetailState copyWith({
    ProbationRecord? record,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProbationDetailState(
      record: record ?? this.record,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Probation detail notifier
class ProbationDetailNotifier extends StateNotifier<ProbationDetailState> {
  final ProbationService _probationService;

  ProbationDetailNotifier(this._probationService)
      : super(const ProbationDetailState());

  /// Load probation record by ID
  Future<void> loadRecord(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final record = await _probationService.getProbationRecordById(id);
      state = state.copyWith(record: record, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load probation record by employee ID
  Future<void> loadRecordByEmployeeId(String employeeId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final record =
          await _probationService.getProbationRecordByEmployeeId(employeeId);
      state = state.copyWith(record: record, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'ไม่พบข้อมูลการทดลองงาน');
    }
  }

  /// Load my probation record (for employee)
  Future<void> loadMyRecord() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final record = await _probationService.getMyProbationRecord();
      state = state.copyWith(record: record, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update record in state
  void updateRecord(ProbationRecord record) {
    state = state.copyWith(record: record);
  }

  /// Clear state
  void clear() {
    state = const ProbationDetailState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Create probation record
  Future<ProbationRecord?> createProbationRecord({
    required String employeeId,
    required String supervisorId,
    required DateTime startDate,
    int probationDays = 90,
    String? templateId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final request = CreateProbationRequest(
        employeeId: employeeId,
        supervisorId: supervisorId,
        startDate: startDate,
        probationDays: probationDays,
        templateId: templateId,
      );

      final record = await _probationService.createProbationRecord(request);
      state = state.copyWith(record: record, isLoading: false);
      return record;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }
}

/// Probation detail provider (family for multiple records)
final probationDetailProvider = StateNotifierProvider.family<
    ProbationDetailNotifier, ProbationDetailState, String?>((ref, id) {
  final probationService = ref.watch(probationServiceProvider);
  return ProbationDetailNotifier(probationService);
});

/// My probation record provider (for employee)
final myProbationProvider =
    StateNotifierProvider<ProbationDetailNotifier, ProbationDetailState>((ref) {
  final probationService = ref.watch(probationServiceProvider);
  return ProbationDetailNotifier(probationService);
});

/// Probation record provider with ID - allows loadRecord() without parameters
class ProbationRecordNotifier extends StateNotifier<ProbationDetailState> {
  final ProbationService _probationService;
  final String recordId;

  ProbationRecordNotifier(this._probationService, this.recordId)
      : super(const ProbationDetailState());

  /// Load the probation record
  Future<void> loadRecord() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final record = await _probationService.getProbationRecordById(recordId);
      state = state.copyWith(record: record, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update record in state
  void updateRecord(ProbationRecord record) {
    state = state.copyWith(record: record);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Create probation record
  Future<ProbationRecord?> createProbationRecord({
    required String employeeId,
    required String supervisorId,
    required DateTime startDate,
    int probationDays = 90,
    String? templateId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final request = CreateProbationRequest(
        employeeId: employeeId,
        supervisorId: supervisorId,
        startDate: startDate,
        probationDays: probationDays,
        templateId: templateId,
      );

      final record = await _probationService.createProbationRecord(request);
      state = state.copyWith(record: record, isLoading: false);
      return record;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }
}

/// Probation record provider family (ID-based with parameterless loadRecord)
final probationRecordProvider = StateNotifierProvider.family<
    ProbationRecordNotifier, ProbationDetailState, String>((ref, id) {
  final probationService = ref.watch(probationServiceProvider);
  return ProbationRecordNotifier(probationService, id);
});

/// Team probation records provider (for supervisor)
final teamProbationProvider =
    StateNotifierProvider<ProbationListNotifier, ProbationListState>((ref) {
  final probationService = ref.watch(probationServiceProvider);
  return ProbationListNotifier(probationService);
});
