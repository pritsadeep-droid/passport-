import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dashboard_service.dart';
import '../services/api_client.dart';

/// HR Dashboard state
class HRDashboardState {
  final HRDashboardData? data;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const HRDashboardState({
    this.data,
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  HRDashboardState copyWith({
    HRDashboardData? data,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return HRDashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// HR Dashboard notifier
class HRDashboardNotifier extends StateNotifier<HRDashboardState> {
  final DashboardService _dashboardService;

  HRDashboardNotifier(this._dashboardService) : super(const HRDashboardState());

  /// Load HR dashboard data
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true);

    try {
      final data = await _dashboardService.getHRDashboard();
      state = HRDashboardState(
        data: data,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboard();
  }
}

/// HR Dashboard provider
final hrDashboardProvider =
    StateNotifierProvider<HRDashboardNotifier, HRDashboardState>((ref) {
  final dashboardService = ref.watch(dashboardServiceProvider);
  return HRDashboardNotifier(dashboardService);
});

/// All employees state
class AllEmployeesState {
  final List<EmployeeWithProbation> employees;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int total;
  final bool hasMore;

  // Filters
  final String? statusFilter;
  final String? departmentFilter;
  final String? searchQuery;

  const AllEmployeesState({
    this.employees = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.hasMore = false,
    this.statusFilter,
    this.departmentFilter,
    this.searchQuery,
  });

  AllEmployeesState copyWith({
    List<EmployeeWithProbation>? employees,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? totalPages,
    int? total,
    bool? hasMore,
    String? statusFilter,
    String? departmentFilter,
    String? searchQuery,
  }) {
    return AllEmployeesState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      statusFilter: statusFilter ?? this.statusFilter,
      departmentFilter: departmentFilter ?? this.departmentFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Employee with probation data
class EmployeeWithProbation {
  final String id;
  final String name;
  final String email;
  final String? department;
  final String? position;
  final String? probationRecordId;
  final String? probationStatus;
  final int? daysRemaining;
  final int? progressPercentage;
  final bool hasOverdue;
  final bool isAtRisk;

  EmployeeWithProbation({
    required this.id,
    required this.name,
    required this.email,
    this.department,
    this.position,
    this.probationRecordId,
    this.probationStatus,
    this.daysRemaining,
    this.progressPercentage,
    this.hasOverdue = false,
    this.isAtRisk = false,
  });

  factory EmployeeWithProbation.fromJson(Map<String, dynamic> json) {
    final employee = json['employeeId'] ?? json;
    return EmployeeWithProbation(
      id: employee['_id'] ?? employee['id'] ?? '',
      name: employee['name'] ?? employee['email'] ?? '',
      email: employee['email'] ?? '',
      department: employee['department'],
      position: employee['position'],
      probationRecordId: json['_id']?.toString() ?? json['id']?.toString(),
      probationStatus: json['status'],
      daysRemaining: json['remainingDays'],
      progressPercentage: json['progressPercentage'],
      hasOverdue: json['hasOverdue'] ?? false,
      isAtRisk: json['isAtRisk'] ?? false,
    );
  }
}

/// All employees notifier
class AllEmployeesNotifier extends StateNotifier<AllEmployeesState> {
  final DashboardService _dashboardService;

  AllEmployeesNotifier(this._dashboardService) : super(const AllEmployeesState());

  /// Load employees
  Future<void> loadEmployees({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        currentPage: 1,
        employees: [],
      );
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final response = await _dashboardService.getAllProbationRecords(
        page: 1,
        status: state.statusFilter,
        department: state.departmentFilter,
        search: state.searchQuery,
      );

      state = AllEmployeesState(
        employees: response.records.map((r) => EmployeeWithProbation.fromJson(r)).toList(),
        currentPage: response.page,
        totalPages: response.totalPages,
        total: response.total,
        hasMore: response.page < response.totalPages,
        statusFilter: state.statusFilter,
        departmentFilter: state.departmentFilter,
        searchQuery: state.searchQuery,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more employees
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _dashboardService.getAllProbationRecords(
        page: state.currentPage + 1,
        status: state.statusFilter,
        department: state.departmentFilter,
        search: state.searchQuery,
      );

      state = state.copyWith(
        employees: [
          ...state.employees,
          ...response.records.map((r) => EmployeeWithProbation.fromJson(r)),
        ],
        currentPage: response.page,
        totalPages: response.totalPages,
        hasMore: response.page < response.totalPages,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Set status filter
  void setStatusFilter(String? status) {
    state = state.copyWith(statusFilter: status);
    loadEmployees(refresh: true);
  }

  /// Set department filter
  void setDepartmentFilter(String? department) {
    state = state.copyWith(departmentFilter: department);
    loadEmployees(refresh: true);
  }

  /// Set search query
  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
    loadEmployees(refresh: true);
  }

  /// Clear all filters
  void clearFilters() {
    state = AllEmployeesState();
    loadEmployees(refresh: true);
  }
}

/// All employees provider
final allEmployeesProvider =
    StateNotifierProvider<AllEmployeesNotifier, AllEmployeesState>((ref) {
  final dashboardService = ref.watch(dashboardServiceProvider);
  return AllEmployeesNotifier(dashboardService);
});

/// Bottlenecks state
class BottlenecksState {
  final List<BottleneckItem> bottlenecks;
  final bool isLoading;
  final String? error;

  const BottlenecksState({
    this.bottlenecks = const [],
    this.isLoading = false,
    this.error,
  });
}

/// Bottleneck item
class BottleneckItem {
  final String type;
  final String severity;
  final String recordId;
  final String employeeId;
  final String employeeName;
  final String? department;
  final String? supervisorName;
  final String message;
  final int? milestoneDay;
  final int? daysOverdue;
  final int? daysPending;

  BottleneckItem({
    required this.type,
    required this.severity,
    required this.recordId,
    required this.employeeId,
    required this.employeeName,
    this.department,
    this.supervisorName,
    required this.message,
    this.milestoneDay,
    this.daysOverdue,
    this.daysPending,
  });

  factory BottleneckItem.fromJson(Map<String, dynamic> json) {
    return BottleneckItem(
      type: json['type'] ?? '',
      severity: json['severity'] ?? 'warning',
      recordId: json['recordId']?.toString() ?? json['probationRecordId']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      employeeName: json['employeeName'] ?? json['employee']?['name'] ?? '',
      department: json['department'] ?? json['employee']?['department'],
      supervisorName: json['supervisorName'] ?? json['supervisor']?['name'],
      message: json['message'] ?? '',
      milestoneDay: json['milestoneDay'] ?? json['milestone']?['day'],
      daysOverdue: json['daysOverdue'] ?? json['milestone']?['daysOverdue'],
      daysPending: json['daysPending'] ?? json['daysSinceStart'],
    );
  }

  bool get isCritical => severity == 'critical';
}

/// Department stats
class DepartmentStats {
  final String department;
  final int total;
  final int pendingKpi;
  final int inProgress;
  final int hasOverdue;
  final int atRisk;

  DepartmentStats({
    required this.department,
    required this.total,
    required this.pendingKpi,
    required this.inProgress,
    required this.hasOverdue,
    required this.atRisk,
  });

  factory DepartmentStats.fromJson(Map<String, dynamic> json) {
    return DepartmentStats(
      department: json['department'] ?? 'Unknown',
      total: json['total'] ?? 0,
      pendingKpi: json['pending_kpi'] ?? 0,
      inProgress: json['in_progress'] ?? 0,
      hasOverdue: json['hasOverdue'] ?? 0,
      atRisk: json['atRisk'] ?? 0,
    );
  }
}
