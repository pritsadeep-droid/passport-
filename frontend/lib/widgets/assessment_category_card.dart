import 'package:flutter/material.dart';
import '../services/milestone_service.dart';
import '../utils/theme.dart';
import 'rating_scale.dart';

/// Assessment category card for self-assessment form
class AssessmentCategoryCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final int? score;
  final String? comment;
  final ValueChanged<int> onScoreChanged;
  final ValueChanged<String?>? onCommentChanged;
  final bool enabled;
  final bool showComment;

  const AssessmentCategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
    this.score,
    this.comment,
    required this.onScoreChanged,
    this.onCommentChanged,
    this.enabled = true,
    this.showComment = true,
  });

  @override
  State<AssessmentCategoryCard> createState() => _AssessmentCategoryCardState();
}

class _AssessmentCategoryCardState extends State<AssessmentCategoryCard> {
  late TextEditingController _commentController;
  bool _showCommentField = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.comment);
    _showCommentField = widget.comment?.isNotEmpty == true;
  }

  @override
  void didUpdateWidget(covariant AssessmentCategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.comment != oldWidget.comment) {
      _commentController.text = widget.comment ?? '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _getScoreLabel(int score) {
    switch (score) {
      case 1:
        return 'ต้องปรับปรุงมาก';
      case 2:
        return 'ต้องปรับปรุง';
      case 3:
        return 'พอใช้';
      case 4:
        return 'ดี';
      case 5:
        return 'ดีเยี่ยม';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (widget.iconColor ?? AppColors.primary)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor ?? AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.score != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(widget.score!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getScoreLabel(widget.score!),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _getScoreColor(widget.score!),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Rating scale
            RatingScale(
              value: widget.score,
              onChanged: widget.onScoreChanged,
              enabled: widget.enabled,
              showLabels: true,
            ),

            // Comment section
            if (widget.showComment && widget.onCommentChanged != null) ...[
              const SizedBox(height: 12),
              if (_showCommentField)
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'เพิ่มความคิดเห็น (ไม่บังคับ)...',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          _showCommentField = false;
                          _commentController.clear();
                        });
                        widget.onCommentChanged!(null);
                      },
                    ),
                  ),
                  maxLines: 2,
                  enabled: widget.enabled,
                  onChanged: widget.onCommentChanged,
                )
              else
                TextButton.icon(
                  onPressed: widget.enabled
                      ? () {
                          setState(() {
                            _showCommentField = true;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.add_comment, size: 16),
                  label: const Text('เพิ่มความคิดเห็น'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
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
}

/// Read-only assessment category display
class AssessmentCategoryDisplay extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final AssessmentScore? score;

  const AssessmentCategoryDisplay({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (score?.score != null) ...[
            StarRating(
              value: score!.score,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              score!.score.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ] else
            Text(
              '-',
              style: TextStyle(color: Colors.grey.shade400),
            ),
        ],
      ),
    );
  }
}

/// Assessment categories configuration
class AssessmentCategories {
  static const List<Map<String, dynamic>> categories = [
    {
      'key': 'coreValue',
      'title': 'ค่านิยมองค์กร',
      'description': 'ความคิดสร้างสรรค์และความรวดเร็ว',
      'icon': Icons.lightbulb,
      'color': Colors.amber,
    },
    {
      'key': 'jobPerformance',
      'title': 'ผลงาน',
      'description': 'ผลงานตามรายละเอียดงาน (JD)',
      'icon': Icons.work,
      'color': Colors.blue,
    },
    {
      'key': 'attendance',
      'title': 'การเข้างาน',
      'description': 'การมาทำงานตรงต่อเวลา',
      'icon': Icons.access_time,
      'color': Colors.green,
    },
    {
      'key': 'cultureFit',
      'title': 'วัฒนธรรมองค์กร',
      'description': 'การปรับตัวเข้ากับทีมและ CI ขององค์กร',
      'icon': Icons.people,
      'color': Colors.purple,
    },
  ];
}
