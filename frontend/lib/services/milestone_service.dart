import 'package:dio/dio.dart';
import '../models/assessment.dart';
import '../models/milestone.dart';
import '../models/probation_record.dart';
import 'api_client.dart';

/// Self assessment data
class SelfAssessmentData {
  final AssessmentScore? coreValue;
  final AssessmentScore? jobPerformance;
  final AssessmentScore? attendance;
  final AssessmentScore? cultureFit;
  final String? comments;
  final bool isDraft;

  const SelfAssessmentData({
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

/// Supervisor assessment data
class SupervisorAssessmentData {
  final AssessmentScore coreValue;
  final AssessmentScore jobPerformance;
  final AssessmentScore attendance;
  final AssessmentScore cultureFit;
  final List<KpiScore>? kpiScores;
  final String overallComment;
  final String recommendation;

  const SupervisorAssessmentData({
    required this.coreValue,
    required this.jobPerformance,
    required this.attendance,
    required this.cultureFit,
    this.kpiScores,
    required this.overallComment,
    required this.recommendation,
  });

  Map<String, dynamic> toJson() => {
        'coreValue': coreValue.toJson(),
        'jobPerformance': jobPerformance.toJson(),
        'attendance': attendance.toJson(),
        'cultureFit': cultureFit.toJson(),
        if (kpiScores != null)
          'kpiScores': kpiScores!.map((k) => k.toJson()).toList(),
        'overallComment': overallComment,
        'recommendation': recommendation,
      };
}

/// Assessment score with comment
class AssessmentScore {
  final int score;
  final String? comment;

  const AssessmentScore({required this.score, this.comment});

  Map<String, dynamic> toJson() => {
        'score': score,
        if (comment != null) 'comment': comment,
      };

  factory AssessmentScore.fromJson(Map<String, dynamic> json) => AssessmentScore(
        score: json['score'] as int,
        comment: json['comment'] as String?,
      );
}

/// KPI score data
class KpiScore {
  final String kpiId;
  final int score;
  final String? comment;

  const KpiScore({
    required this.kpiId,
    required this.score,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
        'kpiId': kpiId,
        'score': score,
        if (comment != null) 'comment': comment,
      };
}

/// Milestone with permissions info
class MilestoneWithPermissions {
  final Milestone milestone;
  final bool canApprove;
  final bool canSubmitSelf;
  final bool canSubmitSupervisor;

  const MilestoneWithPermissions({
    required this.milestone,
    required this.canApprove,
    required this.canSubmitSelf,
    required this.canSubmitSupervisor,
  });

  factory MilestoneWithPermissions.fromJson(Map<String, dynamic> json) =>
      MilestoneWithPermissions(
        milestone: Milestone.fromJson(json['milestone'] as Map<String, dynamic>),
        canApprove: json['canApprove'] as bool? ?? false,
        canSubmitSelf: json['canSubmitSelf'] as bool? ?? false,
        canSubmitSupervisor: json['canSubmitSupervisor'] as bool? ?? false,
      );
}

/// Pending approval item
class PendingApproval {
  final String probationRecordId;
  final UserInfo employee;
  final MilestoneInfo milestone;

  const PendingApproval({
    required this.probationRecordId,
    required this.employee,
    required this.milestone,
  });

  factory PendingApproval.fromJson(Map<String, dynamic> json) => PendingApproval(
        probationRecordId: json['probationRecordId'] as String,
        employee: UserInfo.fromJson(json['employee'] as Map<String, dynamic>),
        milestone: MilestoneInfo.fromJson(json['milestone'] as Map<String, dynamic>),
      );
}

/// User info for display
class UserInfo {
  final String id;
  final String? employeeId;
  final String? email;
  final String? name;
  final String? department;

  const UserInfo({
    required this.id,
    this.employeeId,
    this.email,
    this.name,
    this.department,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: _extractId(json['_id'] ?? json['id']),
        employeeId: _extractStringField(json['employeeId']),
        email: _extractStringField(json['email']),
        name: _extractStringField(json['name']),
        department: _extractStringField(json['department']),
      );

  static String _extractId(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) {
      // MongoDB Extended JSON format: {"$oid": "..."}
      return value['\$oid']?.toString() ?? value['_id']?.toString() ?? value.toString();
    }
    return value.toString();
  }

  static String? _extractStringField(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
}

/// Milestone info for pending approval
class MilestoneInfo {
  final int day;
  final DateTime dueDate;
  final String status;

  const MilestoneInfo({
    required this.day,
    required this.dueDate,
    required this.status,
  });

  factory MilestoneInfo.fromJson(Map<String, dynamic> json) => MilestoneInfo(
        day: json['day'] as int,
        dueDate: DateTime.parse(json['dueDate'] as String),
        status: json['status'] as String,
      );
}

class MilestoneService {
  final ApiClient _apiClient;

  MilestoneService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get all milestones for a probation record
  Future<Map<String, dynamic>> getMilestones(String probationRecordId) async {
    try {
      final response = await _apiClient.get(
        '/milestones/probation/$probationRecordId/milestones',
      );

      final responseData = response.data['data'];
      if (responseData == null || responseData is! Map<String, dynamic>) {
        throw ApiException(message: 'Invalid response format', statusCode: 500);
      }
      final data = responseData;
      final milestonesRaw = data['milestones'];
      final milestones = (milestonesRaw is List)
          ? milestonesRaw
              .whereType<Map<String, dynamic>>()
              .map((m) => Milestone.fromJson(m))
              .toList()
          : <Milestone>[];

      return {
        'milestones': milestones,
        'canApprove': data['canApprove'] as bool? ?? false,
        'canSubmitSelf': data['canSubmitSelf'] as bool? ?? false,
        'canSubmitSupervisor': data['canSubmitSupervisor'] as bool? ?? false,
      };
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get single milestone
  Future<MilestoneWithPermissions> getMilestone(
    String probationRecordId,
    int day,
  ) async {
    try {
      final response = await _apiClient.get(
        '/milestones/probation/$probationRecordId/milestones/$day',
      );
      return MilestoneWithPermissions.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Submit self assessment
  Future<ProbationRecord> submitSelfAssessment(
    String probationRecordId,
    int day,
    SelfAssessmentData data,
  ) async {
    try {
      final response = await _apiClient.put(
        '/milestones/probation/$probationRecordId/milestones/$day/self-assessment',
        data: data.toJson(),
      );
      return ProbationRecord.fromJson(
        response.data['data']['record'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get self assessment
  Future<SelfAssessment?> getSelfAssessment(
    String probationRecordId,
    int day,
  ) async {
    try {
      final response = await _apiClient.get(
        '/milestones/probation/$probationRecordId/milestones/$day/self-assessment',
      );
      final data = response.data['data'];
      if (data == null) return null;
      return SelfAssessment.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Submit supervisor assessment
  Future<ProbationRecord> submitSupervisorAssessment(
    String probationRecordId,
    int day,
    SupervisorAssessmentData data,
  ) async {
    try {
      final response = await _apiClient.put(
        '/milestones/probation/$probationRecordId/milestones/$day/supervisor-assessment',
        data: data.toJson(),
      );
      return ProbationRecord.fromJson(
        response.data['data']['record'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get supervisor assessment
  Future<SupervisorAssessment?> getSupervisorAssessment(
    String probationRecordId,
    int day,
  ) async {
    try {
      final response = await _apiClient.get(
        '/milestones/probation/$probationRecordId/milestones/$day/supervisor-assessment',
      );
      final data = response.data['data'];
      if (data == null) return null;
      return SupervisorAssessment.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Approve milestone
  Future<ProbationRecord> approveMilestone(
    String probationRecordId,
    int day, {
    String? comment,
  }) async {
    try {
      final response = await _apiClient.post(
        '/milestones/probation/$probationRecordId/milestones/$day/approve',
        data: {
          if (comment != null) 'comment': comment,
        },
      );
      return ProbationRecord.fromJson(
        response.data['data']['record'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Reject milestone
  Future<ProbationRecord> rejectMilestone(
    String probationRecordId,
    int day, {
    required String reason,
  }) async {
    try {
      final response = await _apiClient.post(
        '/milestones/probation/$probationRecordId/milestones/$day/reject',
        data: {'reason': reason},
      );
      return ProbationRecord.fromJson(
        response.data['data']['record'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get pending approvals for supervisor
  Future<List<PendingApproval>> getPendingApprovals() async {
    try {
      final response = await _apiClient.get('/milestones/pending');
      final data = response.data['data'] as List;
      return data
          .map((item) => PendingApproval.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
