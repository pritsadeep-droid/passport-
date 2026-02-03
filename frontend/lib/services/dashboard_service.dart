import 'package:dio/dio.dart';
import 'api_client.dart';
import 'milestone_service.dart';

/// Supervisor dashboard data
class SupervisorDashboardData {
  final DashboardStats stats;
  final List<PendingApprovalItem> pendingApprovals;
  final List<UpcomingMilestoneItem> upcomingMilestones;
  final List<OverdueItem> overdueItems;
  final List<RecentRecordItem> recentRecords;

  const SupervisorDashboardData({
    required this.stats,
    required this.pendingApprovals,
    required this.upcomingMilestones,
    required this.overdueItems,
    required this.recentRecords,
  });

  factory SupervisorDashboardData.fromJson(Map<String, dynamic> json) =>
      SupervisorDashboardData(
        stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
        pendingApprovals: (json['pendingApprovals'] as List)
            .map((e) => PendingApprovalItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        upcomingMilestones: (json['upcomingMilestones'] as List)
            .map((e) => UpcomingMilestoneItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        overdueItems: (json['overdueItems'] as List)
            .map((e) => OverdueItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        recentRecords: (json['recentRecords'] as List)
            .map((e) => RecentRecordItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// HR dashboard data
class HrDashboardData {
  final DashboardStats stats;
  final List<BottleneckItem> bottlenecks;
  final List<PendingDecisionItem> pendingDecisions;
  final List<OverdueItem> overdueItems;
  final Map<String, DepartmentStats> byDepartment;
  final int passRate;

  const HrDashboardData({
    required this.stats,
    required this.bottlenecks,
    required this.pendingDecisions,
    required this.overdueItems,
    required this.byDepartment,
    required this.passRate,
  });

  factory HrDashboardData.fromJson(Map<String, dynamic> json) => HrDashboardData(
        stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
        bottlenecks: (json['bottlenecks'] as List)
            .map((e) => BottleneckItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        pendingDecisions: (json['pendingDecisions'] as List)
            .map((e) => PendingDecisionItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        overdueItems: (json['overdueItems'] as List)
            .map((e) => OverdueItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        byDepartment: (json['byDepartment'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            DepartmentStats.fromJson(value as Map<String, dynamic>),
          ),
        ),
        passRate: json['passRate'] as int,
      );
}

/// Employee dashboard data
class EmployeeDashboardData {
  final bool hasRecord;
  final EmployeeRecordInfo? record;
  final UserInfo? supervisor;
  final ProgressInfo? progress;
  final List<dynamic>? kpis;
  final List<dynamic>? milestones;
  final MilestoneStats? milestoneStats;
  final dynamic currentMilestone;
  final dynamic nextMilestone;
  final dynamic finalDecision;

  const EmployeeDashboardData({
    required this.hasRecord,
    this.record,
    this.supervisor,
    this.progress,
    this.kpis,
    this.milestones,
    this.milestoneStats,
    this.currentMilestone,
    this.nextMilestone,
    this.finalDecision,
  });

  factory EmployeeDashboardData.fromJson(Map<String, dynamic> json) =>
      EmployeeDashboardData(
        hasRecord: json['hasRecord'] as bool,
        record: json['record'] != null
            ? EmployeeRecordInfo.fromJson(json['record'] as Map<String, dynamic>)
            : null,
        supervisor: json['supervisor'] != null
            ? UserInfo.fromJson(json['supervisor'] as Map<String, dynamic>)
            : null,
        progress: json['progress'] != null
            ? ProgressInfo.fromJson(json['progress'] as Map<String, dynamic>)
            : null,
        kpis: json['kpis'] as List?,
        milestones: json['milestones'] as List?,
        milestoneStats: json['milestoneStats'] != null
            ? MilestoneStats.fromJson(json['milestoneStats'] as Map<String, dynamic>)
            : null,
        currentMilestone: json['currentMilestone'],
        nextMilestone: json['nextMilestone'],
        finalDecision: json['finalDecision'],
      );
}

/// Dashboard statistics
class DashboardStats {
  final int total;
  final int pendingKpi;
  final int inProgress;
  final int pendingDecision;
  final int passed;
  final int failed;
  final int resigned;

  const DashboardStats({
    required this.total,
    required this.pendingKpi,
    required this.inProgress,
    required this.pendingDecision,
    required this.passed,
    required this.failed,
    required this.resigned,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
        total: json['total'] as int,
        pendingKpi: json['pendingKpi'] as int,
        inProgress: json['inProgress'] as int,
        pendingDecision: json['pendingDecision'] as int,
        passed: json['passed'] as int,
        failed: json['failed'] as int,
        resigned: json['resigned'] as int,
      );
}

/// Pending approval item for dashboard
class PendingApprovalItem {
  final String probationRecordId;
  final UserInfo employee;
  final MilestoneSimple milestone;

  const PendingApprovalItem({
    required this.probationRecordId,
    required this.employee,
    required this.milestone,
  });

  factory PendingApprovalItem.fromJson(Map<String, dynamic> json) =>
      PendingApprovalItem(
        probationRecordId: json['probationRecordId'] as String,
        employee: UserInfo.fromJson(json['employee'] as Map<String, dynamic>),
        milestone:
            MilestoneSimple.fromJson(json['milestone'] as Map<String, dynamic>),
      );
}

/// Simple milestone info
class MilestoneSimple {
  final int day;
  final DateTime dueDate;
  final String status;

  const MilestoneSimple({
    required this.day,
    required this.dueDate,
    required this.status,
  });

  factory MilestoneSimple.fromJson(Map<String, dynamic> json) => MilestoneSimple(
        day: json['day'] as int,
        dueDate: DateTime.parse(json['dueDate'] as String),
        status: json['status'] as String,
      );
}

/// Upcoming milestone item
class UpcomingMilestoneItem {
  final String probationRecordId;
  final UserInfo employee;
  final UpcomingMilestoneInfo milestone;

  const UpcomingMilestoneItem({
    required this.probationRecordId,
    required this.employee,
    required this.milestone,
  });

  factory UpcomingMilestoneItem.fromJson(Map<String, dynamic> json) =>
      UpcomingMilestoneItem(
        probationRecordId: json['probationRecordId'] as String,
        employee: UserInfo.fromJson(json['employee'] as Map<String, dynamic>),
        milestone: UpcomingMilestoneInfo.fromJson(
            json['milestone'] as Map<String, dynamic>),
      );
}

/// Upcoming milestone info
class UpcomingMilestoneInfo {
  final int day;
  final DateTime dueDate;
  final int daysUntilDue;

  const UpcomingMilestoneInfo({
    required this.day,
    required this.dueDate,
    required this.daysUntilDue,
  });

  factory UpcomingMilestoneInfo.fromJson(Map<String, dynamic> json) =>
      UpcomingMilestoneInfo(
        day: json['day'] as int,
        dueDate: DateTime.parse(json['dueDate'] as String),
        daysUntilDue: json['daysUntilDue'] as int,
      );
}

/// Overdue item
class OverdueItem {
  final String probationRecordId;
  final UserInfo employee;
  final UserInfo? supervisor;
  final OverdueMilestoneInfo milestone;

  const OverdueItem({
    required this.probationRecordId,
    required this.employee,
    this.supervisor,
    required this.milestone,
  });

  factory OverdueItem.fromJson(Map<String, dynamic> json) => OverdueItem(
        probationRecordId: json['probationRecordId'] as String,
        employee: UserInfo.fromJson(json['employee'] as Map<String, dynamic>),
        supervisor: json['supervisor'] != null
            ? UserInfo.fromJson(json['supervisor'] as Map<String, dynamic>)
            : null,
        milestone: OverdueMilestoneInfo.fromJson(
            json['milestone'] as Map<String, dynamic>),
      );
}

/// Overdue milestone info
class OverdueMilestoneInfo {
  final int day;
  final DateTime dueDate;
  final int? daysOverdue;

  const OverdueMilestoneInfo({
    required this.day,
    required this.dueDate,
    this.daysOverdue,
  });

  factory OverdueMilestoneInfo.fromJson(Map<String, dynamic> json) =>
      OverdueMilestoneInfo(
        day: json['day'] as int,
        dueDate: DateTime.parse(json['dueDate'] as String),
        daysOverdue: json['daysOverdue'] as int?,
      );
}

/// Recent record item
class RecentRecordItem {
  final String id;
  final UserInfo employee;
  final String status;
  final int daysRemaining;
  final int progressPercentage;

  const RecentRecordItem({
    required this.id,
    required this.employee,
    required this.status,
    required this.daysRemaining,
    required this.progressPercentage,
  });

  factory RecentRecordItem.fromJson(Map<String, dynamic> json) =>
      RecentRecordItem(
        id: json['id'] as String,
        employee: UserInfo.fromJson(json['employee'] as Map<String, dynamic>),
        status: json['status'] as String,
        daysRemaining: json['daysRemaining'] as int,
        progressPercentage: json['progressPercentage'] as int,
      );
}

/// Bottleneck item for HR dashboard
class BottleneckItem {
  final String type;
  final String probationRecordId;
  final UserInfo employee;
  final UserInfo? supervisor;
  final dynamic milestone;
  final int? daysSinceStart;

  const BottleneckItem({
    required this.type,
    required this.probationRecordId,
    required this.employee,
    this.supervisor,
    this.milestone,
    this.daysSinceStart,
  });

  factory BottleneckItem.fromJson(Map<String, dynamic> json) => BottleneckItem(
        type: json['type'] as String,
        probationRecordId: json['probationRecordId'] as String,
        employee: UserInfo.fromJson(json['employee'] as Map<String, dynamic>),
        supervisor: json['supervisor'] != null
            ? UserInfo.fromJson(json['supervisor'] as Map<String, dynamic>)
            : null,
        milestone: json['milestone'],
        daysSinceStart: json['daysSinceStart'] as int?,
      );
}

/// Pending decision item
class PendingDecisionItem {
  final String id;
  final UserInfo employee;
  final UserInfo? supervisor;
  final int daysRemaining;

  const PendingDecisionItem({
    required this.id,
    required this.employee,
    this.supervisor,
    required this.daysRemaining,
  });

  factory PendingDecisionItem.fromJson(Map<String, dynamic> json) =>
      PendingDecisionItem(
        id: json['id'] as String,
        employee: UserInfo.fromJson(json['employee'] as Map<String, dynamic>),
        supervisor: json['supervisor'] != null
            ? UserInfo.fromJson(json['supervisor'] as Map<String, dynamic>)
            : null,
        daysRemaining: json['daysRemaining'] as int,
      );
}

/// Department statistics
class DepartmentStats {
  final int total;
  final int passed;
  final int failed;
  final int inProgress;

  const DepartmentStats({
    required this.total,
    required this.passed,
    required this.failed,
    required this.inProgress,
  });

  factory DepartmentStats.fromJson(Map<String, dynamic> json) => DepartmentStats(
        total: json['total'] as int,
        passed: json['passed'] as int,
        failed: json['failed'] as int,
        inProgress: json['inProgress'] as int,
      );
}

/// Employee record info
class EmployeeRecordInfo {
  final String id;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int probationDays;

  const EmployeeRecordInfo({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.probationDays,
  });

  factory EmployeeRecordInfo.fromJson(Map<String, dynamic> json) =>
      EmployeeRecordInfo(
        id: json['id'] as String,
        status: json['status'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        probationDays: json['probationDays'] as int,
      );
}

/// Progress info
class ProgressInfo {
  final int daysRemaining;
  final int daysElapsed;
  final int totalDays;
  final int progressPercentage;

  const ProgressInfo({
    required this.daysRemaining,
    required this.daysElapsed,
    required this.totalDays,
    required this.progressPercentage,
  });

  factory ProgressInfo.fromJson(Map<String, dynamic> json) => ProgressInfo(
        daysRemaining: json['daysRemaining'] as int,
        daysElapsed: json['daysElapsed'] as int,
        totalDays: json['totalDays'] as int,
        progressPercentage: json['progressPercentage'] as int,
      );
}

/// Milestone statistics
class MilestoneStats {
  final int total;
  final int passed;
  final int failed;
  final int pending;

  const MilestoneStats({
    required this.total,
    required this.passed,
    required this.failed,
    required this.pending,
  });

  factory MilestoneStats.fromJson(Map<String, dynamic> json) => MilestoneStats(
        total: json['total'] as int,
        passed: json['passed'] as int,
        failed: json['failed'] as int,
        pending: json['pending'] as int,
      );
}

class DashboardService {
  final ApiClient _apiClient;

  DashboardService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get supervisor dashboard data
  Future<SupervisorDashboardData> getSupervisorDashboard() async {
    try {
      final response = await _apiClient.get('/dashboard/supervisor');
      return SupervisorDashboardData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get HR dashboard data
  Future<HrDashboardData> getHrDashboard() async {
    try {
      final response = await _apiClient.get('/dashboard/hr');
      return HrDashboardData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get employee dashboard data
  Future<EmployeeDashboardData> getEmployeeDashboard() async {
    try {
      final response = await _apiClient.get('/dashboard/employee');
      return EmployeeDashboardData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
