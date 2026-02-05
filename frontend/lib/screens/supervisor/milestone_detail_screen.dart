import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/milestone.dart';
import '../../models/probation_record.dart';
import '../../providers/milestone_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/assessment_summary.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class MilestoneDetailScreen extends ConsumerStatefulWidget {
  final String probationRecordId;
  final int day;

  const MilestoneDetailScreen({
    super.key,
    required this.probationRecordId,
    required this.day,
  });

  @override
  ConsumerState<MilestoneDetailScreen> createState() =>
      _MilestoneDetailScreenState();
}

class _MilestoneDetailScreenState extends ConsumerState<MilestoneDetailScreen> {
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

  String _getStatusText(MilestoneStatus status) {
    switch (status) {
      case MilestoneStatus.passed:
        return 'ผ่าน';
      case MilestoneStatus.failed:
        return 'ไม่ผ่าน';
      case MilestoneStatus.pendingApproval:
        return 'รออนุมัติ';
      case MilestoneStatus.pendingSupervisor:
        return 'รอหัวหน้าประเมิน';
      case MilestoneStatus.pendingSelf:
        return 'รอประเมินตนเอง';
      case MilestoneStatus.overdue:
        return 'เกินกำหนด';
      case MilestoneStatus.upcoming:
      default:
        return 'ยังไม่ถึงกำหนด';
    }
  }

  Color _getStatusColor(MilestoneStatus status) {
    switch (status) {
      case MilestoneStatus.passed:
        return Colors.green;
      case MilestoneStatus.failed:
        return Colors.red;
      case MilestoneStatus.pendingApproval:
        return Colors.orange;
      case MilestoneStatus.pendingSupervisor:
        return Colors.blue;
      case MilestoneStatus.pendingSelf:
        return AppColors.primary;
      case MilestoneStatus.overdue:
        return Colors.red.shade700;
      case MilestoneStatus.upcoming:
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    return '${date.day} ${months[date.month]} ${date.year + 543}';
  }

  @override
  Widget build(BuildContext context) {
    final params = MilestoneDetailParams(
      probationRecordId: widget.probationRecordId,
      day: widget.day,
    );
    final state = ref.watch(milestoneDetailProvider(params));

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Milestone Day ${widget.day}',
        logoIcon: Icons.flag,
        showBackButton: true,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(MilestoneDetailState state) {
    if (state.isLoading && state.milestoneData == null) {
      return LoadingWidget(message: 'กำลังโหลดข้อมูล...');
    }

    if (state.error != null && state.milestoneData == null) {
      return CustomErrorWidget(
        message: state.error!,
        onRetry: _loadMilestone,
      );
    }

    if (state.milestoneData == null) {
      return CustomErrorWidget(
        message: 'ไม่พบข้อมูล Milestone',
      );
    }

    final milestone = state.milestoneData!.milestone;
    final statusColor = _getStatusColor(milestone.status);

    return RefreshIndicator(
      onRefresh: () async => _loadMilestone(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            _buildStatusCard(milestone, statusColor),
            const SizedBox(height: 16),

            // Assessment summary
            if (milestone.selfAssessment != null ||
                milestone.supervisorAssessment != null) ...[
              const Text(
                'ผลการประเมิน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              AssessmentSummary(
                selfAssessment: milestone.selfAssessment,
                supervisorAssessment: milestone.supervisorAssessment,
              ),
              const SizedBox(height: 16),

              // Comparison if both assessments exist
              if (milestone.selfAssessment != null &&
                  milestone.supervisorAssessment != null) ...[
                const Text(
                  'เปรียบเทียบคะแนน',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                AssessmentComparison(
                  selfAssessment: milestone.selfAssessment,
                  supervisorAssessment: milestone.supervisorAssessment,
                ),
                const SizedBox(height: 16),
              ],
            ],

            // Action buttons based on permissions
            if (state.milestoneData!.canApprove &&
                milestone.status == MilestoneStatus.pendingApproval) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      '/supervisor/milestone-approval/${widget.probationRecordId}/${widget.day}',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.rate_review),
                  label: const Text('พิจารณาอนุมัติ'),
                ),
              ),
            ],

            // Show rejection reason if rejected
            if (milestone.status == MilestoneStatus.failed &&
                milestone.rejectionReason != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'เหตุผลที่ไม่อนุมัติ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(milestone.rejectionReason!),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(Milestone milestone, Color statusColor) {
    final daysUntilDue = milestone.dueDate.difference(DateTime.now()).inDays;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${milestone.day}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
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
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(milestone.status),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.calendar_today,
                    label: 'กำหนดส่ง',
                    value: _formatDate(milestone.dueDate),
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.schedule,
                    label: 'เหลือเวลา',
                    value: daysUntilDue > 0
                        ? '$daysUntilDue วัน'
                        : daysUntilDue == 0
                            ? 'วันนี้'
                            : 'เกิน ${-daysUntilDue} วัน',
                    valueColor: daysUntilDue < 0 ? Colors.red : null,
                  ),
                ),
              ],
            ),
            if (milestone.approvedAt != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.check_circle,
                      label: 'อนุมัติเมื่อ',
                      value: _formatDate(milestone.approvedAt!),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
