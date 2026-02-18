import 'package:flutter/material.dart';
import '../models/milestone.dart';
import '../utils/theme.dart';

/// Widget to display milestone timeline
class MilestoneTimeline extends StatelessWidget {
  final List<Milestone> milestones;
  final Function(Milestone)? onMilestoneTap;

  const MilestoneTimeline({
    super.key,
    required this.milestones,
    this.onMilestoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(milestones.length, (index) {
        final milestone = milestones[index];
        final isLast = index == milestones.length - 1;

        return _MilestoneTimelineItem(
          milestone: milestone,
          isLast: isLast,
          onTap: onMilestoneTap != null ? () => onMilestoneTap!(milestone) : null,
        );
      }),
    );
  }
}

class _MilestoneTimelineItem extends StatelessWidget {
  final Milestone milestone;
  final bool isLast;
  final VoidCallback? onTap;

  const _MilestoneTimelineItem({
    required this.milestone,
    required this.isLast,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (milestone.status) {
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

  IconData _getStatusIcon() {
    switch (milestone.status) {
      case MilestoneStatus.passed:
        return Icons.check_circle;
      case MilestoneStatus.failed:
        return Icons.cancel;
      case MilestoneStatus.pendingApproval:
        return Icons.pending_actions;
      case MilestoneStatus.pendingSupervisor:
        return Icons.rate_review;
      case MilestoneStatus.pendingSelf:
        return Icons.edit_note;
      case MilestoneStatus.overdue:
        return Icons.warning;
      case MilestoneStatus.upcoming:
      default:
        return Icons.schedule;
    }
  }

  String _getStatusText() {
    switch (milestone.status) {
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

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final daysUntilDue = milestone.dueDate.difference(DateTime.now()).inDays;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor, width: 2),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: statusColor,
                  size: 20,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'วันที่ ${milestone.day}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
                          _getStatusText(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(milestone.dueDate),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (milestone.status == MilestoneStatus.upcoming ||
                          milestone.status == MilestoneStatus.pendingSelf)
                        Text(
                          daysUntilDue > 0
                              ? '(อีก $daysUntilDue วัน)'
                              : daysUntilDue == 0
                                  ? '(วันนี้)'
                                  : '(เกินมา ${-daysUntilDue} วัน)',
                          style: TextStyle(
                            color: daysUntilDue < 0 ? Colors.red : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  // Show scores if available
                  if (milestone.selfAssessment?.averageScore != null ||
                      milestone.supervisorAssessment?.averageScore != null) ...[
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (milestone.selfAssessment?.averageScore != null) ...[
                          _ScoreBadge(
                            label: 'ประเมินตนเอง',
                            score: milestone.selfAssessment!.averageScore!,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (milestone.supervisorAssessment?.averageScore != null)
                          _ScoreBadge(
                            label: 'หัวหน้าประเมิน',
                            score: milestone.supervisorAssessment!.averageScore!,
                          ),
                      ],
                    ),
                  ],
                  // Show tap hint if clickable
                  if (onTap != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'แตะเพื่อดูรายละเอียด',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
}

class _ScoreBadge extends StatelessWidget {
  final String label;
  final double score;

  const _ScoreBadge({
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final isPassing = score >= 3.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPassing ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isPassing ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact version of milestone timeline for dashboard
class MilestoneTimelineCompact extends StatelessWidget {
  final List<Milestone> milestones;

  const MilestoneTimelineCompact({
    super.key,
    required this.milestones,
  });

  Color _getStatusColor(MilestoneStatus status) {
    switch (status) {
      case MilestoneStatus.passed:
        return Colors.green;
      case MilestoneStatus.failed:
        return Colors.red;
      case MilestoneStatus.pendingApproval:
        return Colors.orange;
      case MilestoneStatus.pendingSupervisor:
      case MilestoneStatus.pendingSelf:
        return AppColors.primary;
      case MilestoneStatus.overdue:
        return Colors.red.shade700;
      case MilestoneStatus.upcoming:
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(milestones.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          final prevMilestone = milestones[index ~/ 2];
          return Expanded(
            child: Container(
              height: 3,
              color: prevMilestone.status == MilestoneStatus.passed
                  ? Colors.green
                  : Colors.grey.shade300,
            ),
          );
        }

        final milestone = milestones[index ~/ 2];
        final statusColor = _getStatusColor(milestone.status);

        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: statusColor, width: 2),
          ),
          child: Center(
            child: Text(
              '${milestone.day}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        );
      }),
    );
  }
}
