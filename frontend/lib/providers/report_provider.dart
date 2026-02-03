import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/report_service.dart';
import 'auth_provider.dart';

/// Report service provider
final reportServiceProvider = Provider<ReportService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportService(apiClient: apiClient);
});

/// Report types state
class ReportTypesState {
  final List<ReportType> types;
  final bool isLoading;
  final String? error;

  const ReportTypesState({
    this.types = const [],
    this.isLoading = false,
    this.error,
  });

  ReportTypesState copyWith({
    List<ReportType>? types,
    bool? isLoading,
    String? error,
  }) {
    return ReportTypesState(
      types: types ?? this.types,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Report types notifier
class ReportTypesNotifier extends StateNotifier<ReportTypesState> {
  final ReportService _reportService;

  ReportTypesNotifier(this._reportService) : super(const ReportTypesState());

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final types = await _reportService.getReportTypes();
      state = state.copyWith(
        types: types,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Report types provider
final reportTypesProvider =
    StateNotifierProvider<ReportTypesNotifier, ReportTypesState>((ref) {
  final service = ref.watch(reportServiceProvider);
  return ReportTypesNotifier(service);
});

/// Report stats state
class ReportStatsState {
  final ReportStats? stats;
  final bool isLoading;
  final String? error;

  const ReportStatsState({
    this.stats,
    this.isLoading = false,
    this.error,
  });

  ReportStatsState copyWith({
    ReportStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return ReportStatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Report stats notifier
class ReportStatsNotifier extends StateNotifier<ReportStatsState> {
  final ReportService _reportService;

  ReportStatsNotifier(this._reportService) : super(const ReportStatsState());

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final stats = await _reportService.getReportStats();
      state = state.copyWith(
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    await load();
  }
}

/// Report stats provider
final reportStatsProvider =
    StateNotifierProvider<ReportStatsNotifier, ReportStatsState>((ref) {
  final service = ref.watch(reportServiceProvider);
  return ReportStatsNotifier(service);
});

/// Report download state
class ReportDownloadState {
  final bool isDownloading;
  final String? currentReport;
  final Uint8List? data;
  final String? error;
  final double progress;

  const ReportDownloadState({
    this.isDownloading = false,
    this.currentReport,
    this.data,
    this.error,
    this.progress = 0.0,
  });

  ReportDownloadState copyWith({
    bool? isDownloading,
    String? currentReport,
    Uint8List? data,
    String? error,
    double? progress,
  }) {
    return ReportDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      currentReport: currentReport ?? this.currentReport,
      data: data ?? this.data,
      error: error,
      progress: progress ?? this.progress,
    );
  }
}

/// Report download notifier
class ReportDownloadNotifier extends StateNotifier<ReportDownloadState> {
  final ReportService _reportService;

  ReportDownloadNotifier(this._reportService)
      : super(const ReportDownloadState());

  Future<Uint8List?> downloadSummaryReport(ReportFilters filters) async {
    if (state.isDownloading) return null;

    state = state.copyWith(
      isDownloading: true,
      currentReport: 'probation-summary',
      error: null,
      progress: 0.0,
    );

    try {
      final data = await _reportService.downloadSummaryReport(filters);
      state = state.copyWith(
        isDownloading: false,
        data: data,
        progress: 1.0,
      );
      return data;
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<Uint8List?> downloadEmployeeReport(String employeeId,
      {String format = 'pdf'}) async {
    if (state.isDownloading) return null;

    state = state.copyWith(
      isDownloading: true,
      currentReport: 'employee-$employeeId',
      error: null,
      progress: 0.0,
    );

    try {
      final data = await _reportService.downloadEmployeeReport(
        employeeId,
        format: format,
      );
      state = state.copyWith(
        isDownloading: false,
        data: data,
        progress: 1.0,
      );
      return data;
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<Uint8List?> downloadDepartmentReport() async {
    if (state.isDownloading) return null;

    state = state.copyWith(
      isDownloading: true,
      currentReport: 'departments',
      error: null,
      progress: 0.0,
    );

    try {
      final data = await _reportService.downloadDepartmentReport();
      state = state.copyWith(
        isDownloading: false,
        data: data,
        progress: 1.0,
      );
      return data;
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  void clearData() {
    state = const ReportDownloadState();
  }
}

/// Report download provider
final reportDownloadProvider =
    StateNotifierProvider<ReportDownloadNotifier, ReportDownloadState>((ref) {
  final service = ref.watch(reportServiceProvider);
  return ReportDownloadNotifier(service);
});
