import 'package:flutter/material.dart';

/// Probation progress indicator widget
class ProbationProgressIndicator extends StatelessWidget {
  /// Progress value (0.0 to 1.0)
  final double progress;

  /// Label text
  final String? label;

  /// Show percentage
  final bool showPercentage;

  /// Height of the bar
  final double height;

  /// Color (defaults to theme primary)
  final Color? color;

  /// Background color
  final Color? backgroundColor;

  const ProbationProgressIndicator({
    super.key,
    required this.progress,
    this.label,
    this.showPercentage = true,
    this.height = 8,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ??
        (progress >= 1.0
            ? Colors.green
            : progress >= 0.7
                ? theme.colorScheme.primary
                : progress >= 0.5
                    ? Colors.orange
                    : theme.colorScheme.error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium,
                ),
              if (showPercentage)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: progressColor,
                  ),
                ),
            ],
          ),
        if (label != null || showPercentage) const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: height,
            backgroundColor:
                backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}

/// Step progress indicator for milestones
class StepProgressIndicator extends StatelessWidget {
  /// Total number of steps
  final int totalSteps;

  /// Number of completed steps
  final int completedSteps;

  /// Current active step (0-indexed)
  final int? currentStep;

  /// Step labels
  final List<String>? labels;

  /// On step tap callback
  final void Function(int)? onStepTap;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.completedSteps,
    this.currentStep,
    this.labels,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < completedSteps;
          return Expanded(
            child: Container(
              height: 3,
              color: isCompleted
                  ? Colors.green
                  : theme.colorScheme.surfaceContainerHighest,
            ),
          );
        } else {
          // Step circle
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < completedSteps;
          final isCurrent = stepIndex == currentStep;

          return GestureDetector(
            onTap: onStepTap != null ? () => onStepTap!(stepIndex) : null,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green
                    : isCurrent
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                border: isCurrent
                    ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      )
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          color: isCurrent
                              ? Colors.white
                              : theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
              ),
            ),
          );
        }
      }),
    );
  }
}

/// Milestone progress card
class MilestoneProgressCard extends StatelessWidget {
  /// Number of passed milestones
  final int passed;

  /// Number of failed milestones
  final int failed;

  /// Number of pending milestones
  final int pending;

  /// Total milestones
  final int total;

  /// On tap callback
  final VoidCallback? onTap;

  const MilestoneProgressCard({
    super.key,
    required this.passed,
    required this.failed,
    required this.pending,
    required this.total,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = passed + failed;
    final progress = total > 0 ? completed / total : 0.0;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ความคืบหน้า Milestone',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$completed/$total',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress bar with segments
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 12,
                  child: Row(
                    children: [
                      if (passed > 0)
                        Expanded(
                          flex: passed,
                          child: Container(color: Colors.green),
                        ),
                      if (failed > 0)
                        Expanded(
                          flex: failed,
                          child: Container(color: theme.colorScheme.error),
                        ),
                      if (pending > 0)
                        Expanded(
                          flex: pending,
                          child: Container(color: Colors.orange),
                        ),
                      if (total - completed - pending > 0)
                        Expanded(
                          flex: total - completed - pending,
                          child: Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(theme, 'ผ่าน', passed, Colors.green),
                  _buildLegendItem(theme, 'ไม่ผ่าน', failed, theme.colorScheme.error),
                  _buildLegendItem(theme, 'รอดำเนินการ', pending, Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($value)',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// Score progress indicator
class ScoreProgressIndicator extends StatelessWidget {
  /// Score value (0.0 to 5.0)
  final double score;

  /// Maximum score
  final double maxScore;

  /// Passing threshold
  final double passingThreshold;

  /// Size of the indicator
  final double size;

  /// Show label
  final bool showLabel;

  const ScoreProgressIndicator({
    super.key,
    required this.score,
    this.maxScore = 5.0,
    this.passingThreshold = 3.0,
    this.size = 80,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (score / maxScore).clamp(0.0, 1.0);
    final isPassing = score >= passingThreshold;

    final color = isPassing ? Colors.green : theme.colorScheme.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
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
                  strokeWidth: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score.toStringAsFixed(1),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    '/ $maxScore',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isPassing ? 'ผ่านเกณฑ์' : 'ไม่ผ่านเกณฑ์',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
