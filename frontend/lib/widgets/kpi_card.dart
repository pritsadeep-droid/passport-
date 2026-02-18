import 'package:flutter/material.dart';
import '../models/kpi.dart';
import '../utils/theme.dart';

/// Card widget for displaying a single KPI
class KpiCard extends StatelessWidget {
  final Kpi kpi;
  final int index;
  final bool canEdit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const KpiCard({
    super.key,
    required this.kpi,
    required this.index,
    this.canEdit = false,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI number badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Title and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kpi.title,
                        style: AppTextStyles.subtitle1,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _StatusChip(status: kpi.status),
                    ],
                  ),
                ),

                // Actions
                if (showActions && canEdit)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('แก้ไข'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('ลบ', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),

            // Description
            _InfoRow(
              icon: Icons.description_outlined,
              label: 'รายละเอียด',
              value: kpi.description,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Criteria
            _InfoRow(
              icon: Icons.check_circle_outline,
              label: 'เกณฑ์วัดผล',
              value: kpi.criteria,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final KpiStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case KpiStatus.active:
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        break;
      case KpiStatus.completed:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case KpiStatus.cancelled:
        backgroundColor = AppColors.textSecondary.withOpacity(0.1);
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Compact KPI card for list views
class KpiCompactCard extends StatelessWidget {
  final Kpi kpi;
  final int index;
  final VoidCallback? onTap;

  const KpiCompactCard({
    super.key,
    required this.kpi,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          kpi.title,
          style: AppTextStyles.subtitle1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          kpi.criteria,
          style: AppTextStyles.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: _StatusChip(status: kpi.status),
      ),
    );
  }
}

/// Empty state for no KPIs
class EmptyKpiState extends StatelessWidget {
  final VoidCallback? onAdd;
  final bool canAdd;

  const EmptyKpiState({
    super.key,
    this.onAdd,
    this.canAdd = true,
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
              Icons.flag_outlined,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'ยังไม่มี KPI',
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              canAdd
                  ? 'กรุณาเพิ่ม KPI 3-5 ข้อสำหรับพนักงานใหม่'
                  : 'รอหัวหน้างานกำหนด KPI',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            if (canAdd && onAdd != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('เพิ่ม KPI'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// KPI count indicator
class KpiCountIndicator extends StatelessWidget {
  final int count;
  final int minCount;
  final int maxCount;

  const KpiCountIndicator({
    super.key,
    required this.count,
    this.minCount = 3,
    this.maxCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = count >= minCount && count <= maxCount;
    final color = isValid ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.info_outline,
            color: color,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'KPI: $count / $maxCount',
            style: AppTextStyles.body2.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!isValid && count < minCount) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              '(ต้องมีอย่างน้อย $minCount)',
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
