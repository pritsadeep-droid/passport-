import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import '../services/dashboard_service.dart';
import 'auth_provider.dart';

/// Dashboard service provider
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardService(apiClient: apiClient);
});

/// State for supervisor dashboard
class SupervisorDashboardState {
  final SupervisorDashboardData? data;
  final bool isLoading;
  final String? error;

  const SupervisorDashboardState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  SupervisorDashboardState copyWith({
    SupervisorDashboardData? data,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return SupervisorDashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Supervisor dashboard notifier
class SupervisorDashboardNotifier extends StateNotifier<SupervisorDashboardState> {
  final DashboardService _dashboardService;

  SupervisorDashboardNotifier(this._dashboardService)
      : super(const SupervisorDashboardState());

  /// Load dashboard data
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await _dashboardService.getSupervisorDashboard();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadDashboard();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Supervisor dashboard provider
final supervisorDashboardProvider =
    StateNotifierProvider<SupervisorDashboardNotifier, SupervisorDashboardState>(
        (ref) {
  final dashboardService = ref.watch(dashboardServiceProvider);
  return SupervisorDashboardNotifier(dashboardService);
});

/// State for HR dashboard
class HrDashboardState {
  final HrDashboardData? data;
  final bool isLoading;
  final String? error;

  const HrDashboardState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  HrDashboardState copyWith({
    HrDashboardData? data,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return HrDashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// HR dashboard notifier
class HrDashboardNotifier extends StateNotifier<HrDashboardState> {
  final DashboardService _dashboardService;

  HrDashboardNotifier(this._dashboardService) : super(const HrDashboardState());

  /// Load dashboard data
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await _dashboardService.getHrDashboard();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadDashboard();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// HR dashboard provider
final hrDashboardProvider =
    StateNotifierProvider<HrDashboardNotifier, HrDashboardState>((ref) {
  final dashboardService = ref.watch(dashboardServiceProvider);
  return HrDashboardNotifier(dashboardService);
});

/// State for employee dashboard
class EmployeeDashboardState {
  final EmployeeDashboardData? data;
  final bool isLoading;
  final String? error;

  const EmployeeDashboardState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  EmployeeDashboardState copyWith({
    EmployeeDashboardData? data,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return EmployeeDashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Employee dashboard notifier
class EmployeeDashboardNotifier extends StateNotifier<EmployeeDashboardState> {
  final DashboardService _dashboardService;

  EmployeeDashboardNotifier(this._dashboardService)
      : super(const EmployeeDashboardState());

  /// Load dashboard data
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await _dashboardService.getEmployeeDashboard();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadDashboard();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Employee dashboard provider
final employeeDashboardProvider =
    StateNotifierProvider<EmployeeDashboardNotifier, EmployeeDashboardState>(
        (ref) {
  final dashboardService = ref.watch(dashboardServiceProvider);
  return EmployeeDashboardNotifier(dashboardService);
});
