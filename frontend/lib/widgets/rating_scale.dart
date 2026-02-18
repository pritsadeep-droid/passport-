import 'package:flutter/material.dart';

/// 5-Point scale rating widget
class RatingScale extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;
  final bool enabled;
  final bool showLabels;
  final bool compact;

  const RatingScale({
    super.key,
    this.value,
    required this.onChanged,
    this.enabled = true,
    this.showLabels = true,
    this.compact = false,
  });

  static const List<String> labels = [
    'ต้องปรับปรุงมาก',
    'ต้องปรับปรุง',
    'พอใช้',
    'ดี',
    'ดีเยี่ยม',
  ];

  Color _getColor(int score) {
    switch (score) {
      case 1:
        return Colors.red.shade700;
      case 2:
        return Colors.orange.shade700;
      case 3:
        return Colors.amber.shade600;
      case 4:
        return Colors.lightGreen.shade600;
      case 5:
        return Colors.green.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactScale();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final score = index + 1;
            final isSelected = value == score;

            return Expanded(
              child: GestureDetector(
                onTap: enabled ? () => onChanged(score) : null,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getColor(score)
                        : enabled
                            ? Colors.grey.shade100
                            : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? _getColor(score)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        score.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : _getColor(score),
                        ),
                      ),
                      if (showLabels) ...[
                        const SizedBox(height: 4),
                        Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCompactScale() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final score = index + 1;
        final isSelected = value == score;

        return GestureDetector(
          onTap: enabled ? () => onChanged(score) : null,
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isSelected ? _getColor(score) : Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? _getColor(score) : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                score.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : _getColor(score),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Star-based rating widget (alternative)
class StarRating extends StatelessWidget {
  final int? value;
  final ValueChanged<int>? onChanged;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRating({
    super.key,
    this.value,
    this.onChanged,
    this.maxRating = 5,
    this.size = 32,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? Colors.amber;
    final inactive = inactiveColor ?? Colors.grey.shade300;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1;
        final isActive = (value ?? 0) >= starValue;

        return GestureDetector(
          onTap: onChanged != null ? () => onChanged!(starValue) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              isActive ? Icons.star : Icons.star_border,
              size: size,
              color: isActive ? active : inactive,
            ),
          ),
        );
      }),
    );
  }
}

/// Score display badge
class ScoreBadge extends StatelessWidget {
  final double score;
  final bool showLabel;

  const ScoreBadge({
    super.key,
    required this.score,
    this.showLabel = true,
  });

  String _getLabel() {
    if (score >= 4.5) return 'ดีเยี่ยม';
    if (score >= 3.5) return 'ดี';
    if (score >= 2.5) return 'พอใช้';
    if (score >= 1.5) return 'ต้องปรับปรุง';
    return 'ต้องปรับปรุงมาก';
  }

  Color _getColor() {
    if (score >= 4.0) return Colors.green;
    if (score >= 3.0) return Colors.lightGreen;
    if (score >= 2.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            score.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              _getLabel(),
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Passing indicator
class PassingIndicator extends StatelessWidget {
  final double score;
  final double passingScore;

  const PassingIndicator({
    super.key,
    required this.score,
    this.passingScore = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    final isPassing = score >= passingScore;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPassing
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPassing ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isPassing ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isPassing ? 'ผ่านเกณฑ์' : 'ไม่ผ่านเกณฑ์',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isPassing ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
