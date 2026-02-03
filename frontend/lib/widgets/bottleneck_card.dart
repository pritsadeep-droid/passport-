import 'package:flutter/material.dart';
import '../providers/hr_dashboard_provider.dart';

/// Bottleneck alert card widget
class BottleneckCard extends StatelessWidget {
  /// The bottleneck data
  final BottleneckItem bottleneck;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Callback when action button is pressed
  final VoidCallback? onAction;

  const BottleneckCard({
    super.key,
    required this.bottleneck,
    this.onTap,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCritical = bottleneck.isCritical;

    final bgColor = isCritical
        ? theme.colorScheme.errorContainer
        : Colors.orange.shade50;
    final borderColor = isCritical
        ? theme.colorScheme.error
        : Colors.orange;
    final iconColor = isCritical
        ? theme.colorScheme.error
        : Colors.orange.shade700;

    return Card(
      elevation: 0,
      color: bgColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: borderColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(),
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isCritical)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'เร่งด่วน',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            bottleneck.employeeName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bottleneck.message,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (bottleneck.department != null) ...[
                          Icon(
                            Icons.business,
                            size: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bottleneck.department!,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (bottleneck.supervisorName != null) ...[
                          Icon(
                            Icons.person_outline,
                            size: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              bottleneck.supervisorName!,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Action button
              if (onAction != null)
                IconButton(
                  onPressed: onAction,
                  icon: const Icon(Icons.arrow_forward),
                  iconSize: 20,
                  color: iconColor,
                  tooltip: 'ดูรายละเอียด',
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (bottleneck.type) {
      case 'kpi_not_assigned':
        return Icons.assignment_late;
      case 'milestone_overdue':
        return Icons.warning_amber;
      case 'pending_approval':
        return Icons.pending_actions;
      case 'ending_soon_incomplete':
        return Icons.schedule;
      default:
        return Icons.error_outline;
    }
  }
}

/// Bottleneck list widget
class BottleneckList extends StatelessWidget {
  /// List of bottlenecks
  final List<BottleneckItem> bottlenecks;

  /// Callback when item is tapped
  final void Function(BottleneckItem)? onItemTap;

  /// Show "see all" button
  final bool showSeeAll;

  /// Callback for "see all"
  final VoidCallback? onSeeAll;

  /// Maximum items to show
  final int maxItems;

  const BottleneckList({
    super.key,
    required this.bottlenecks,
    this.onItemTap,
    this.showSeeAll = true,
    this.onSeeAll,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayItems = bottlenecks.take(maxItems).toList();
    final hasMore = bottlenecks.length > maxItems;

    if (bottlenecks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ไม่มีปัญหาที่ต้องดำเนินการ',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'กระบวนการทดลองงานทั้งหมดดำเนินไปด้วยดี',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final bottleneck = displayItems[index];
            return BottleneckCard(
              bottleneck: bottleneck,
              onTap: onItemTap != null ? () => onItemTap!(bottleneck) : null,
            );
          },
        ),
        if (hasMore && showSeeAll) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: onSeeAll,
            child: Text('ดูทั้งหมด (${bottlenecks.length})'),
          ),
        ],
      ],
    );
  }
}

/// Bottleneck summary chip
class BottleneckSummaryChip extends StatelessWidget {
  /// Number of critical bottlenecks
  final int criticalCount;

  /// Number of warning bottlenecks
  final int warningCount;

  /// Callback when tapped
  final VoidCallback? onTap;

  const BottleneckSummaryChip({
    super.key,
    required this.criticalCount,
    required this.warningCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = criticalCount + warningCount;

    if (total == 0) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: criticalCount > 0
              ? theme.colorScheme.errorContainer
              : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber,
              size: 16,
              color: criticalCount > 0
                  ? theme.colorScheme.error
                  : Colors.orange.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              '$total ปัญหา',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: criticalCount > 0
                    ? theme.colorScheme.error
                    : Colors.orange.shade700,
              ),
            ),
            if (criticalCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '($criticalCount เร่งด่วน)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
