import 'package:flutter/material.dart';
import '../models/onboarding.dart';

class StampCollectionWidget extends StatelessWidget {
  final List<Mission> missions;
  final List<Review> reviews;
  final DateTime startDate;
  final void Function(Mission mission)? onStampTap;

  const StampCollectionWidget({
    super.key,
    required this.missions,
    required this.reviews,
    required this.startDate,
    this.onStampTap,
  });

  static const Map<String, Color> _stampColors = {
    'H': Color(0xFFE53935),
    'A': Color(0xFFFF9800),
    'P': Color(0xFF4CAF50),
    'I': Color(0xFF2196F3),
    'N': Color(0xFF9C27B0),
    'E': Color(0xFF00BCD4),
    'S': Color(0xFFFF5722),
  };

  static const Map<String, String> _stampThaiLabels = {
    'H': 'พลังบวก',
    'A': 'เป้าหมายชัด',
    'P': 'พัฒนาตัวเอง',
    'I': 'สร้างคุณค่า',
    'N': 'ลงมือทันที',
    'E': 'สื่อสารดี',
    'S': 'ทีมเข้มแข็ง',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: missions.map((mission) {
          final review = reviews.firstWhere(
            (r) => r.missionCode == mission.code,
            orElse: () => const Review(missionCode: '', decision: ''),
          );
          final isPassed = review.decision == 'pass';
          final isOpen = _isMissionOpen(mission);
          final color = _stampColors[mission.code] ?? Colors.grey;

          return GestureDetector(
            onTap: onStampTap != null ? () => onStampTap!(mission) : null,
            child: _StampItem(
              letter: mission.code,
              label: _stampThaiLabels[mission.code] ?? '',
              color: color,
              isPassed: isPassed,
              isOpen: isOpen,
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isMissionOpen(Mission mission) {
    final openDate = startDate.add(Duration(days: mission.openOffsetDays));
    return DateTime.now().isAfter(openDate);
  }
}

class _StampItem extends StatelessWidget {
  final String letter;
  final String label;
  final Color color;
  final bool isPassed;
  final bool isOpen;

  const _StampItem({
    required this.letter,
    required this.label,
    required this.color,
    required this.isPassed,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed ? color : Colors.transparent,
            border: Border.all(
              color: isPassed
                  ? color
                  : isOpen
                      ? color.withOpacity(0.6)
                      : Colors.grey.shade300,
              width: isPassed ? 3 : 2,
            ),
          ),
          child: Center(
            child: isPassed
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: 16,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    letter,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isOpen ? color : Colors.grey.shade400,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isPassed ? color : Colors.grey.shade600,
            fontWeight: isPassed ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Mini stamp dots for use on home screen card
class MiniStampDots extends StatelessWidget {
  final List<Mission> missions;
  final List<Review> reviews;

  const MiniStampDots({
    super.key,
    required this.missions,
    required this.reviews,
  });

  static const Map<String, Color> _stampColors = {
    'H': Color(0xFFE53935),
    'A': Color(0xFFFF9800),
    'P': Color(0xFF4CAF50),
    'I': Color(0xFF2196F3),
    'N': Color(0xFF9C27B0),
    'E': Color(0xFF00BCD4),
    'S': Color(0xFFFF5722),
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: missions.map((mission) {
        final review = reviews.firstWhere(
          (r) => r.missionCode == mission.code,
          orElse: () => const Review(missionCode: '', decision: ''),
        );
        final isPassed = review.decision == 'pass';
        final color = _stampColors[mission.code] ?? Colors.grey;

        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed ? color : Colors.grey.shade300,
          ),
        );
      }).toList(),
    );
  }
}
