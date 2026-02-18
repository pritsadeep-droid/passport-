import 'package:flutter/material.dart';
import '../models/probation_record.dart';
import '../models/user.dart';
import '../utils/theme.dart';

/// List item widget for displaying an employee with probation status
class EmployeeListItem extends StatelessWidget {
  final ProbationRecord record;
  final VoidCallback? onTap;
  final bool showSupervisor;
  final bool showDaysRemaining;

  const EmployeeListItem({
    super.key,
    required this.record,
    this.onTap,
    this.showSupervisor = false,
    this.showDaysRemaining = true,
  });

  @override
  Widget build(BuildContext context) {
    final employee = record.employee;
    final daysRemaining = record.calculatedDaysRemaining;
    final progressPercentage = record.calculatedProgressPercentage;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee info row
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      _getInitials(employee?.name ?? ''),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Name and department
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee?.name ?? 'Unknown',
                          style: AppTextStyles.subtitle1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          employee?.department ?? '',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),

                  // Status chip
                  _StatusChip(status: record.status),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressPercentage / 100,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(progressPercentage, record.status),
                  ),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Info row
              Row(
                children: [
                  // Days remaining
                  if (showDaysRemaining && record.status.isActive)
                    _InfoChip(
                      icon: Icons.schedule,
                      label: 'เหลือ $daysRemaining วัน',
                      color: _getDaysColor(daysRemaining),
                    ),

                  // KPI count
                  _InfoChip(
                    icon: Icons.flag_outlined,
                    label: 'KPI ${record.kpis.length}',
                    color: record.hasValidKpiCount
                        ? AppColors.textSecondary
                        : AppColors.warning,
                  ),

                  // Milestone progress
                  _InfoChip(
                    icon: Icons.check_circle_outline,
                    label: '${record.passedMilestonesCount}/${record.milestones.length}',
                    color: AppColors.textSecondary,
                  ),

                  const Spacer(),

                  // Arrow
                  if (onTap != null)
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textHint,
                    ),
                ],
              ),

              // Supervisor info (optional)
              if (showSupervisor && record.supervisor != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'หัวหน้า: ${record.supervisor?.name ?? ""}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getProgressColor(int percentage, ProbationStatus status) {
    if (status.isCompleted) {
      return status.isPassed ? AppColors.success : AppColors.error;
    }
    if (percentage >= 80) return AppColors.warning;
    if (percentage >= 50) return AppColors.info;
    return AppColors.primary;
  }

  Color _getDaysColor(int days) {
    if (days <= 7) return AppColors.error;
    if (days <= 14) return AppColors.warning;
    return AppColors.textSecondary;
  }
}

class _StatusChip extends StatelessWidget {
  final ProbationStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case ProbationStatus.pendingKpi:
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case ProbationStatus.inProgress:
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        break;
      case ProbationStatus.pendingDecision:
        backgroundColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        break;
      case ProbationStatus.passed:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case ProbationStatus.failed:
      case ProbationStatus.terminated:
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        break;
      case ProbationStatus.resigned:
        backgroundColor = AppColors.textSecondary.withOpacity(0.1);
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Compact version for search results
class EmployeeCompactItem extends StatelessWidget {
  final User employee;
  final VoidCallback? onTap;
  final Widget? trailing;

  const EmployeeCompactItem({
    super.key,
    required this.employee,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Text(
          _getInitials(employee.name),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(employee.name),
      subtitle: Text(
        '${employee.employeeId} • ${employee.department}',
        style: AppTextStyles.caption,
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

/// Empty state for employee list
class EmptyEmployeeList extends StatelessWidget {
  final String message;
  final String? subtitle;

  const EmptyEmployeeList({
    super.key,
    this.message = 'ไม่พบพนักงาน',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
