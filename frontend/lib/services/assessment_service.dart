import 'package:dio/dio.dart';
import '../models/probation_record.dart';
import 'api_client.dart';
import 'milestone_service.dart';

/// Current assessment data for employee
class CurrentAssessmentData {
  final CurrentRecordInfo? record;
  final Milestone? currentMilestone;
  final List<Kpi>? kpis;
  final String? message;

  const CurrentAssessmentData({
    this.record,
    this.currentMilestone,
    this.kpis,
    this.message,
  });

  factory CurrentAssessmentData.fromJson(Map<String, dynamic> json) =>
      CurrentAssessmentData(
        record: json['record'] != null
            ? CurrentRecordInfo.fromJson(json['record'] as Map<String, dynamic>)
            : null,
        currentMilestone: json['currentMilestone'] != null
            ? Milestone.fromJson(json['currentMilestone'] as Map<String, dynamic>)
            : null,
        kpis: json['kpis'] != null
            ? (json['kpis'] as List)
                .map((k) => Kpi.fromJson(k as Map<String, dynamic>))
                .toList()
            : null,
        message: json['message'] as String?,
      );
}

/// Current record info
class CurrentRecordInfo {
  final String id;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final UserInfo? supervisor;

  const CurrentRecordInfo({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.supervisor,
  });

  factory CurrentRecordInfo.fromJson(Map<String, dynamic> json) =>
      CurrentRecordInfo(
        id: json['id'] as String? ?? json['_id'] as String,
        status: json['status'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        supervisor: json['supervisor'] != null
            ? UserInfo.fromJson(json['supervisor'] as Map<String, dynamic>)
            : null,
      );
}

/// My milestones data
class MyMilestonesData {
  final MyRecordInfo? record;
  final List<Milestone> milestones;
  final List<Kpi>? kpis;

  const MyMilestonesData({
    this.record,
    required this.milestones,
    this.kpis,
  });

  factory MyMilestonesData.fromJson(Map<String, dynamic> json) =>
      MyMilestonesData(
        record: json['record'] != null
            ? MyRecordInfo.fromJson(json['record'] as Map<String, dynamic>)
            : null,
        milestones: (json['milestones'] as List?)
                ?.map((m) => Milestone.fromJson(m as Map<String, dynamic>))
                .toList() ??
            [],
        kpis: json['kpis'] != null
            ? (json['kpis'] as List)
                .map((k) => Kpi.fromJson(k as Map<String, dynamic>))
                .toList()
            : null,
      );
}

/// My record info
class MyRecordInfo {
  final String id;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int probationDays;
  final UserInfo? supervisor;

  const MyRecordInfo({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.probationDays,
    this.supervisor,
  });

  factory MyRecordInfo.fromJson(Map<String, dynamic> json) => MyRecordInfo(
        id: json['id'] as String? ?? json['_id'] as String,
        status: json['status'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        probationDays: json['probationDays'] as int,
        supervisor: json['supervisor'] != null
            ? UserInfo.fromJson(json['supervisor'] as Map<String, dynamic>)
            : null,
      );
}

/// Self assessment request data
class SelfAssessmentRequest {
  final AssessmentScore? coreValue;
  final AssessmentScore? jobPerformance;
  final AssessmentScore? attendance;
  final AssessmentScore? cultureFit;
  final String? comments;
  final bool isDraft;

  const SelfAssessmentRequest({
    this.coreValue,
    this.jobPerformance,
    this.attendance,
    this.cultureFit,
    this.comments,
    this.isDraft = false,
  });

  Map<String, dynamic> toJson() => {
        if (coreValue != null) 'coreValue': coreValue!.toJson(),
        if (jobPerformance != null) 'jobPerformance': jobPerformance!.toJson(),
        if (attendance != null) 'attendance': attendance!.toJson(),
        if (cultureFit != null) 'cultureFit': cultureFit!.toJson(),
        if (comments != null) 'comments': comments,
        'isDraft': isDraft,
      };
}

class AssessmentService {
  final ApiClient _apiClient;

  AssessmentService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get current milestone for employee to assess
  Future<CurrentAssessmentData> getCurrentAssessment() async {
    try {
      final response = await _apiClient.get('/assessment/current');
      if (response.data['data'] == null) {
        return const CurrentAssessmentData();
      }
      return CurrentAssessmentData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get all milestones for employee view
  Future<MyMilestonesData> getMyMilestones() async {
    try {
      final response = await _apiClient.get('/assessment/milestones');
      return MyMilestonesData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get self assessment for a milestone
  Future<SelfAssessment?> getSelfAssessment(
    String recordId,
    int day,
  ) async {
    try {
      final response = await _apiClient.get(
        '/assessment/$recordId/milestones/$day/self',
      );
      final data = response.data['data'];
      if (data == null) return null;
      return SelfAssessment.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Submit or update self assessment
  Future<ProbationRecord> submitSelfAssessment(
    String recordId,
    int day,
    SelfAssessmentRequest request,
  ) async {
    try {
      final response = await _apiClient.put(
        '/assessment/$recordId/milestones/$day/self',
        data: request.toJson(),
      );
      return ProbationRecord.fromJson(
        response.data['data']['record'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get supervisor assessment for a milestone
  Future<SupervisorAssessment?> getSupervisorAssessment(
    String recordId,
    int day,
  ) async {
    try {
      final response = await _apiClient.get(
        '/assessment/$recordId/milestones/$day/supervisor',
      );
      final data = response.data['data'];
      if (data == null) return null;
      return SupervisorAssessment.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
