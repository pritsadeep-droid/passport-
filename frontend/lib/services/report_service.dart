import 'dart:typed_data';
import 'api_client.dart';

/// Report type definition
class ReportType {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final List<String> formats;
  final List<String> filters;

  ReportType({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.formats,
    required this.filters,
  });

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['nameEn'] ?? '',
      description: json['description'] ?? '',
      formats: List<String>.from(json['formats'] ?? []),
      filters: List<String>.from(json['filters'] ?? []),
    );
  }
}

/// Report statistics
class ReportStats {
  final int total;
  final Map<String, int> byStatus;
  final List<DepartmentStat> byDepartment;
  final double passRate;

  ReportStats({
    required this.total,
    required this.byStatus,
    required this.byDepartment,
    required this.passRate,
  });

  factory ReportStats.fromJson(Map<String, dynamic> json) {
    final byStatus = <String, int>{};
    if (json['byStatus'] != null) {
      (json['byStatus'] as Map<String, dynamic>).forEach((key, value) {
        byStatus[key] = (value as num).toInt();
      });
    }

    final byDepartment = <DepartmentStat>[];
    if (json['byDepartment'] != null) {
      for (final dept in json['byDepartment']) {
        byDepartment.add(DepartmentStat.fromJson(dept));
      }
    }

    return ReportStats(
      total: (json['total'] as num?)?.toInt() ?? 0,
      byStatus: byStatus,
      byDepartment: byDepartment,
      passRate: (json['passRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  int get inProgress => byStatus['in_progress'] ?? 0;
  int get passed => byStatus['passed'] ?? 0;
  int get failed => byStatus['failed'] ?? 0;
  int get pendingDecision => byStatus['pending_decision'] ?? 0;
}

/// Department statistics
class DepartmentStat {
  final String department;
  final int count;
  final int passed;
  final int failed;
  final int inProgress;

  DepartmentStat({
    required this.department,
    required this.count,
    required this.passed,
    required this.failed,
    required this.inProgress,
  });

  factory DepartmentStat.fromJson(Map<String, dynamic> json) {
    return DepartmentStat(
      department: json['_id'] ?? 'ไม่ระบุ',
      count: (json['count'] as num?)?.toInt() ?? 0,
      passed: (json['passed'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      inProgress: (json['inProgress'] as num?)?.toInt() ?? 0,
    );
  }

  double get passRate {
    final total = passed + failed;
    return total > 0 ? (passed / total * 100) : 0.0;
  }
}

/// Report filter options
class ReportFilters {
  final String? status;
  final String? department;
  final DateTime? startDate;
  final DateTime? endDate;
  final String format;

  ReportFilters({
    this.status,
    this.department,
    this.startDate,
    this.endDate,
    this.format = 'pdf',
  });

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (status != null) params['status'] = status!;
    if (department != null) params['department'] = department!;
    if (startDate != null) params['startDate'] = startDate!.toIso8601String().split('T')[0];
    if (endDate != null) params['endDate'] = endDate!.toIso8601String().split('T')[0];
    params['format'] = format;
    return params;
  }
}

/// Report service for API calls
class ReportService {
  final ApiClient _apiClient;

  ReportService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get available report types
  Future<List<ReportType>> getReportTypes() async {
    final response = await _apiClient.get('/reports/types');
    final data = response.data['data'] as List;
    return data.map((json) => ReportType.fromJson(json)).toList();
  }

  /// Get report statistics
  Future<ReportStats> getReportStats() async {
    final response = await _apiClient.get('/reports/stats');
    return ReportStats.fromJson(response.data['data']);
  }

  /// Download probation summary report
  Future<Uint8List> downloadSummaryReport(ReportFilters filters) async {
    final response = await _apiClient.get(
      '/reports/probation-summary',
      queryParameters: filters.toQueryParams(),
      options: _apiClient.downloadOptions(),
    );
    return response.data as Uint8List;
  }

  /// Download employee report
  Future<Uint8List> downloadEmployeeReport(String employeeId, {String format = 'pdf'}) async {
    final response = await _apiClient.get(
      '/reports/employee/$employeeId',
      queryParameters: {'format': format},
      options: _apiClient.downloadOptions(),
    );
    return response.data as Uint8List;
  }

  /// Download department report
  Future<Uint8List> downloadDepartmentReport() async {
    final response = await _apiClient.get(
      '/reports/departments',
      options: _apiClient.downloadOptions(),
    );
    return response.data as Uint8List;
  }
}
