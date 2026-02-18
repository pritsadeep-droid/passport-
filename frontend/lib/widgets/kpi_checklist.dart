import 'package:flutter/material.dart';

/// KPI item data
class KpiItem {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final double? progress;
  final String? status;

  KpiItem({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.progress,
    this.status,
  });

  factory KpiItem.fromJson(Map<String, dynamic> json) {
    return KpiItem(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      progress: (json['progress'] as num?)?.toDouble(),
      status: json['status'],
    );
  }
}

/// KPI Checklist widget
class KpiChecklist extends StatelessWidget {
  /// List of KPIs
  final List<KpiItem> kpis;

  /// Show progress bars
  final bool showProgress;

  /// On KPI tap callback
  final void Function(KpiItem)? onKpiTap;

  /// Allow checking/unchecking (for employee self-tracking)
  final bool interactive;

  /// On check changed callback
  final void Function(KpiItem, bool)? onCheckChanged;

  const KpiChecklist({
    super.key,
    required this.kpis,
    this.showProgress = false,
    this.onKpiTap,
    this.interactive = false,
    this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (kpis.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 48,
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'ยังไม่มี KPI',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'รอหัวหน้างานกำหนด KPI ให้คุณ',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return KpiChecklistItem(
          kpi: kpi,
          index: index + 1,
          showProgress: showProgress,
          onTap: onKpiTap != null ? () => onKpiTap!(kpi) : null,
          interactive: interactive,
          onCheckChanged: onCheckChanged != null
              ? (value) => onCheckChanged!(kpi, value)
              : null,
        );
      },
    );
  }
}

/// Individual KPI checklist item
class KpiChecklistItem extends StatelessWidget {
  /// KPI data
  final KpiItem kpi;

  /// Index number (1-based)
  final int index;

  /// Show progress bar
  final bool showProgress;

  /// On tap callback
  final VoidCallback? onTap;

  /// Allow interaction
  final bool interactive;

  /// On check changed callback
  final void Function(bool)? onCheckChanged;

  const KpiChecklistItem({
    super.key,
    required this.kpi,
    required this.index,
    this.showProgress = false,
    this.onTap,
    this.interactive = false,
    this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox or number
              if (interactive)
                Checkbox(
                  value: kpi.isCompleted,
                  onChanged: onCheckChanged != null
                      ? (value) => onCheckChanged!(value ?? false)
                      : null,
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: kpi.isCompleted
                        ? Colors.green
                        : theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: kpi.isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: Colors.white,
                          )
                        : Text(
                            '$index',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kpi.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration:
                            kpi.isCompleted ? TextDecoration.lineThrough : null,
                        color: kpi.isCompleted
                            ? theme.textTheme.bodySmall?.color
                            : null,
                      ),
                    ),
                    if (kpi.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        kpi.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (showProgress && kpi.progress != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: kpi.progress! / 100,
                                minHeight: 4,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  kpi.progress! >= 100
                                      ? Colors.green
                                      : theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${kpi.progress!.toInt()}%',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Status or chevron
              if (kpi.status != null)
                _buildStatusBadge(theme, kpi.status!)
              else if (onTap != null)
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

  Widget _buildStatusBadge(ThemeData theme, String status) {
    final color = _getStatusColor(theme, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(ThemeData theme, String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'เสร็จสิ้น';
      case 'in_progress':
        return 'กำลังดำเนินการ';
      case 'pending':
        return 'รอดำเนินการ';
      case 'overdue':
        return 'เกินกำหนด';
      default:
        return status;
    }
  }
}

/// KPI summary card
class KpiSummaryCard extends StatelessWidget {
  /// List of KPIs
  final List<KpiItem> kpis;

  /// Title
  final String title;

  /// On view all tap
  final VoidCallback? onViewAll;

  const KpiSummaryCard({
    super.key,
    required this.kpis,
    this.title = 'KPI ของคุณ',
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = kpis.where((k) => k.isCompleted).length;
    final total = kpis.length;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('ดูทั้งหมด'),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: total > 0 ? completed / total : 0,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        completed == total && total > 0
                            ? Colors.green
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$completed/$total',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // KPI list (max 3)
            ...kpis.take(3).map((kpi) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      kpi.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: kpi.isCompleted
                          ? Colors.green
                          : theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        kpi.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: kpi.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: kpi.isCompleted
                              ? theme.textTheme.bodySmall?.color
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),

            if (kpis.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${kpis.length - 3} รายการเพิ่มเติม',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
