import 'package:flutter/material.dart';
import '../providers/hr_dashboard_provider.dart';

/// Employee status list widget
class EmployeeStatusList extends StatelessWidget {
  /// List of employees with probation data
  final List<EmployeeWithProbation> employees;

  /// Callback when item is tapped
  final void Function(EmployeeWithProbation)? onItemTap;

  /// Show loading indicator
  final bool isLoading;

  /// Show empty state
  final bool showEmpty;

  const EmployeeStatusList({
    super.key,
    required this.employees,
    this.onItemTap,
    this.isLoading = false,
    this.showEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (employees.isEmpty && showEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline,
                size: 48,
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              Text(
                'ไม่มีพนักงาน',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return EmployeeStatusItem(
          employee: employee,
          onTap: onItemTap != null ? () => onItemTap!(employee) : null,
        );
      },
    );
  }
}

/// Individual employee status item
class EmployeeStatusItem extends StatelessWidget {
  /// Employee data
  final EmployeeWithProbation employee;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Show progress indicator
  final bool showProgress;

  const EmployeeStatusItem({
    super.key,
    required this.employee,
    this.onTap,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(theme);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: employee.isAtRisk
          ? theme.colorScheme.errorContainer.withOpacity(0.3)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: employee.isAtRisk
              ? theme.colorScheme.error.withOpacity(0.3)
              : theme.dividerColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(theme),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(theme, statusColor),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (employee.department != null) ...[
                          Icon(
                            Icons.business,
                            size: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              employee.department!,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (showProgress && employee.progressPercentage != null) ...[
                      const SizedBox(height: 8),
                      _buildProgressBar(theme),
                    ],
                  ],
                ),
              ),
              // Indicators
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (employee.hasOverdue)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.warning_amber,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  if (employee.daysRemaining != null && employee.daysRemaining! <= 7)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${employee.daysRemaining} วัน',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: theme.textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final initials = employee.name.isNotEmpty
        ? employee.name[0].toUpperCase()
        : employee.email[0].toUpperCase();

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    final progress = (employee.progressPercentage ?? 0) / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ความคืบหน้า',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            Text(
              '${employee.progressPercentage}%',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0
                  ? Colors.green
                  : theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ThemeData theme) {
    switch (employee.probationStatus) {
      case 'pending_kpi':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'passed':
        return Colors.green;
      case 'failed':
        return theme.colorScheme.error;
      case 'extended':
        return Colors.purple;
      default:
        return theme.colorScheme.outline;
    }
  }

  String _getStatusText() {
    switch (employee.probationStatus) {
      case 'pending_kpi':
        return 'รอกำหนด KPI';
      case 'in_progress':
        return 'กำลังทดลองงาน';
      case 'passed':
        return 'ผ่านทดลองงาน';
      case 'failed':
        return 'ไม่ผ่าน';
      case 'extended':
        return 'ขยายเวลา';
      default:
        return 'ไม่ทราบ';
    }
  }
}

/// Employee status filter chips
class EmployeeStatusFilterChips extends StatelessWidget {
  /// Current selected status
  final String? selectedStatus;

  /// Callback when status is selected
  final void Function(String?) onStatusSelected;

  const EmployeeStatusFilterChips({
    super.key,
    this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      ('all', 'ทั้งหมด'),
      ('pending_kpi', 'รอ KPI'),
      ('in_progress', 'กำลังทดลอง'),
      ('passed', 'ผ่าน'),
      ('failed', 'ไม่ผ่าน'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          final isSelected =
              (selectedStatus == null && status.$1 == 'all') ||
              selectedStatus == status.$1;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(status.$2),
              selected: isSelected,
              onSelected: (_) {
                onStatusSelected(status.$1 == 'all' ? null : status.$1);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Department stats list
class DepartmentStatsList extends StatelessWidget {
  /// Department statistics
  final List<DepartmentStats> departments;

  /// Callback when department is tapped
  final void Function(String)? onDepartmentTap;

  const DepartmentStatsList({
    super.key,
    required this.departments,
    this.onDepartmentTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: departments.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final dept = departments[index];
        return ListTile(
          onTap: onDepartmentTap != null
              ? () => onDepartmentTap!(dept.department)
              : null,
          title: Text(
            dept.department,
            style: theme.textTheme.titleSmall,
          ),
          subtitle: Text(
            '${dept.total} คน (${dept.inProgress} กำลังทดลอง)',
            style: theme.textTheme.bodySmall,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dept.hasOverdue > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${dept.hasOverdue} overdue',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        );
      },
    );
  }
}
