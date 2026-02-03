import 'dart:async';
import 'package:flutter/material.dart';

/// Countdown widget for probation days remaining
class CountdownWidget extends StatefulWidget {
  /// End date of probation
  final DateTime endDate;

  /// Start date of probation
  final DateTime startDate;

  /// Total probation days
  final int totalDays;

  /// Show animated countdown
  final bool animated;

  /// Callback when countdown reaches zero
  final VoidCallback? onComplete;

  const CountdownWidget({
    super.key,
    required this.endDate,
    required this.startDate,
    required this.totalDays,
    this.animated = true,
    this.onComplete,
  });

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late int _daysRemaining;
  late int _daysElapsed;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _calculateDays();
    if (widget.animated) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateDays() {
    final now = DateTime.now();
    _daysRemaining = widget.endDate.difference(now).inDays;
    _daysElapsed = now.difference(widget.startDate).inDays;
    _progress = (_daysElapsed / widget.totalDays).clamp(0.0, 1.0);

    if (_daysRemaining <= 0) {
      _daysRemaining = 0;
      widget.onComplete?.call();
    }
  }

  void _startTimer() {
    // Update every minute for more precise countdown
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        _calculateDays();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUrgent = _daysRemaining <= 7;
    final isComplete = _daysRemaining <= 0;

    return Card(
      elevation: 0,
      color: isComplete
          ? Colors.green.shade50
          : isUrgent
              ? theme.colorScheme.errorContainer.withOpacity(0.5)
              : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ระยะเวลาทดลองงาน',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.totalDays} วัน',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Main countdown
            Row(
              children: [
                Expanded(
                  child: _buildCountdownNumber(
                    theme,
                    _daysRemaining.toString(),
                    'วันที่เหลือ',
                    isUrgent
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    isUrgent,
                  ),
                ),
                Container(
                  width: 1,
                  height: 70,
                  color: theme.dividerColor,
                ),
                Expanded(
                  child: _buildCountdownNumber(
                    theme,
                    _daysElapsed.toString(),
                    'วันที่ผ่านมา',
                    Colors.green,
                    false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isComplete
                      ? Colors.green
                      : isUrgent
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Dates and percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(widget.startDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDate(widget.endDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownNumber(
    ThemeData theme,
    String value,
    String label,
    Color color,
    bool pulse,
  ) {
    return Column(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          child: Text(value),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
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

/// Compact countdown badge
class CountdownBadge extends StatelessWidget {
  /// Days remaining
  final int daysRemaining;

  /// Show icon
  final bool showIcon;

  const CountdownBadge({
    super.key,
    required this.daysRemaining,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUrgent = daysRemaining <= 7;
    final isComplete = daysRemaining <= 0;

    final color = isComplete
        ? Colors.green
        : isUrgent
            ? theme.colorScheme.error
            : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              isComplete
                  ? Icons.check_circle
                  : isUrgent
                      ? Icons.warning_amber
                      : Icons.schedule,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            isComplete ? 'สิ้นสุดแล้ว' : 'เหลือ $daysRemaining วัน',
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular countdown indicator
class CircularCountdownIndicator extends StatelessWidget {
  /// Days remaining
  final int daysRemaining;

  /// Total days
  final int totalDays;

  /// Size of the indicator
  final double size;

  /// Stroke width
  final double strokeWidth;

  const CircularCountdownIndicator({
    super.key,
    required this.daysRemaining,
    required this.totalDays,
    this.size = 100,
    this.strokeWidth = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysElapsed = totalDays - daysRemaining;
    final progress = (daysElapsed / totalDays).clamp(0.0, 1.0);
    final isUrgent = daysRemaining <= 7;
    final isComplete = daysRemaining <= 0;

    final color = isComplete
        ? Colors.green
        : isUrgent
            ? theme.colorScheme.error
            : theme.colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$daysRemaining',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'วัน',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
