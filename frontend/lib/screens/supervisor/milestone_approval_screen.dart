import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/probation_record.dart';
import '../../providers/milestone_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/approval_buttons.dart';
import '../../widgets/assessment_summary.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class MilestoneApprovalScreen extends ConsumerStatefulWidget {
  final String probationRecordId;
  final int day;

  const MilestoneApprovalScreen({
    super.key,
    required this.probationRecordId,
    required this.day,
  });

  @override
  ConsumerState<MilestoneApprovalScreen> createState() =>
      _MilestoneApprovalScreenState();
}

class _MilestoneApprovalScreenState
    extends ConsumerState<MilestoneApprovalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMilestone();
    });
  }

  void _loadMilestone() {
    final params = MilestoneDetailParams(
      probationRecordId: widget.probationRecordId,
      day: widget.day,
    );
    ref.read(milestoneDetailProvider(params).notifier).loadMilestone();
  }

  void _showApproveDialog() {
    showDialog(
      context: context,
      builder: (context) => ApproveMilestoneDialog(
        onApprove: (comment) async {
          Navigator.of(context).pop();
          await _handleApprove(comment);
        },
      ),
    );
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (context) => RejectMilestoneDialog(
        onReject: (reason) async {
          Navigator.of(context).pop();
          await _handleReject(reason);
        },
      ),
    );
  }

  Future<void> _handleApprove(String? comment) async {
    final params = MilestoneDetailParams(
      probationRecordId: widget.probationRecordId,
      day: widget.day,
    );

    final result = await ref
        .read(milestoneDetailProvider(params).notifier)
        .approveMilestone(comment: comment);

    if (result != null && mounted) {
      // Refresh pending approvals list
      ref.read(pendingApprovalsProvider.notifier).refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('อนุมัติ Milestone สำเร็จ'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop();
    }
  }

  Future<void> _handleReject(String reason) async {
    final params = MilestoneDetailParams(
      probationRecordId: widget.probationRecordId,
      day: widget.day,
    );

    final result = await ref
        .read(milestoneDetailProvider(params).notifier)
        .rejectMilestone(reason: reason);

    if (result != null && mounted) {
      // Refresh pending approvals list
      ref.read(pendingApprovalsProvider.notifier).refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่อนุมัติ Milestone'),
          backgroundColor: Colors.orange,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = MilestoneDetailParams(
      probationRecordId: widget.probationRecordId,
      day: widget.day,
    );
    final state = ref.watch(milestoneDetailProvider(params));

    // Show error snackbar
    ref.listen(milestoneDetailProvider(params), (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(milestoneDetailProvider(params).notifier).clearError();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: 'พิจารณาอนุมัติ',
        showBackButton: true,
      ),
      body: _buildBody(state),
      bottomNavigationBar: state.milestoneData?.canApprove == true
          ? _buildBottomBar(state)
          : null,
    );
  }

  Widget _buildBody(MilestoneDetailState state) {
    if (state.isLoading && state.milestoneData == null) {
      return const LoadingWidget(message: 'กำลังโหลดข้อมูล...');
    }

    if (state.error != null && state.milestoneData == null) {
      return CustomErrorWidget(
        message: state.error!,
        onRetry: _loadMilestone,
      );
    }

    if (state.milestoneData == null) {
      return const CustomErrorWidget(
        message: 'ไม่พบข้อมูล Milestone',
      );
    }

    final milestone = state.milestoneData!.milestone;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Milestone info card
          _buildMilestoneInfoCard(milestone),
          const SizedBox(height: 20),

          // Assessment summary header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'สรุปผลการประเมิน',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              if (milestone.selfAssessment?.averageScore != null &&
                  milestone.supervisorAssessment?.averageScore != null)
                _buildOverallScore(
                  milestone.selfAssessment!.averageScore!,
                  milestone.supervisorAssessment!.averageScore!,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Assessment details
          AssessmentSummary(
            selfAssessment: milestone.selfAssessment,
            supervisorAssessment: milestone.supervisorAssessment,
          ),
          const SizedBox(height: 16),

          // Comparison
          if (milestone.selfAssessment != null &&
              milestone.supervisorAssessment != null) ...[
            AssessmentComparison(
              selfAssessment: milestone.selfAssessment,
              supervisorAssessment: milestone.supervisorAssessment,
            ),
            const SizedBox(height: 16),
          ],

          // Supervisor recommendation
          if (milestone.supervisorAssessment?.recommendation != null)
            _buildRecommendationCard(
              milestone.supervisorAssessment!.recommendation!,
            ),

          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildMilestoneInfoCard(Milestone milestone) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${milestone.day}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Milestone วันที่ ${milestone.day}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'รออนุมัติ',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScore(double selfScore, double supervisorScore) {
    final avgScore = (selfScore + supervisorScore) / 2;
    final isPassing = avgScore >= 3.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPassing
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'คะแนนเฉลี่ย',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            avgScore.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPassing ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String recommendation) {
    String text;
    Color color;
    IconData icon;

    switch (recommendation) {
      case 'pass':
        text = 'หัวหน้าแนะนำ: ผ่านการประเมิน';
        color = Colors.green;
        icon = Icons.thumb_up;
        break;
      case 'fail':
        text = 'หัวหน้าแนะนำ: ไม่ผ่านการประเมิน';
        color = Colors.red;
        icon = Icons.thumb_down;
        break;
      case 'extend':
        text = 'หัวหน้าแนะนำ: ขยายระยะเวลาทดลองงาน';
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      default:
        text = 'ไม่มีข้อเสนอแนะ';
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Card(
      color: color.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(MilestoneDetailState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ApprovalButtons(
          canApprove: state.milestoneData?.canApprove ?? false,
          isLoading: state.isSubmitting,
          onApprove: _showApproveDialog,
          onReject: _showRejectDialog,
        ),
      ),
    );
  }
}
