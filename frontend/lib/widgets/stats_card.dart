import 'package:flutter/material.dart';

/// Summary statistics card widget
class StatsCard extends StatelessWidget {
  /// Title of the stat
  final String title;

  /// Value to display
  final String value;

  /// Optional subtitle
  final String? subtitle;

  /// Icon to display
  final IconData icon;

  /// Card color
  final Color? color;

  /// Text color
  final Color? textColor;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Show trend indicator
  final double? trend;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.textColor,
    this.onTap,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.primaryContainer;
    final foregroundColor = textColor ?? theme.colorScheme.onPrimaryContainer;

    return Card(
      elevation: 0,
      color: cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: foregroundColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: foregroundColor,
                    ),
                  ),
                  if (trend != null) _buildTrend(theme),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foregroundColor.withOpacity(0.8),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foregroundColor.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrend(ThemeData theme) {
    final isPositive = trend! >= 0;
    final trendColor = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: trendColor,
          ),
          const SizedBox(width: 2),
          Text(
            '${trend!.abs().toStringAsFixed(0)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats grid for displaying multiple stats
class StatsGrid extends StatelessWidget {
  /// List of stats to display
  final List<StatData> stats;

  /// Number of columns (default 2)
  final int crossAxisCount;

  /// Spacing between cards
  final double spacing;

  const StatsGrid({
    super.key,
    required this.stats,
    this.crossAxisCount = 2,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return StatsCard(
          title: stat.title,
          value: stat.value,
          subtitle: stat.subtitle,
          icon: stat.icon,
          color: stat.color,
          textColor: stat.textColor,
          onTap: stat.onTap,
          trend: stat.trend,
        );
      },
    );
  }
}

/// Data class for stats
class StatData {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? trend;

  const StatData({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.textColor,
    this.onTap,
    this.trend,
  });
}

/// Compact inline stat for horizontal lists
class InlineStat extends StatelessWidget {
  /// Label text
  final String label;

  /// Value text
  final String value;

  /// Optional icon
  final IconData? icon;

  /// Icon/value color
  final Color? color;

  const InlineStat({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayColor = color ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: displayColor,
          ),
          const SizedBox(height: 4),
        ],
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: displayColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

/// Pass rate indicator
class PassRateIndicator extends StatelessWidget {
  /// Pass rate percentage (0-100)
  final int passRate;

  /// Size of the indicator
  final double size;

  const PassRateIndicator({
    super.key,
    required this.passRate,
    this.size = 90,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rateColor = passRate >= 80
        ? Colors.green
        : passRate >= 60
            ? Colors.orange
            : theme.colorScheme.error;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: passRate / 100,
            strokeWidth: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(rateColor),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$passRate%',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: rateColor,
                ),
              ),
              Text(
                'ผ่าน',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
