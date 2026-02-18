import 'package:flutter/material.dart';
import '../models/onboarding.dart';

class JourneyTimelineWidget extends StatelessWidget {
  final OnboardingInstance instance;
  final void Function(JourneyEvent event)? onEventTap;
  final void Function(Mission mission)? onMissionTap;

  const JourneyTimelineWidget({
    super.key,
    required this.instance,
    this.onEventTap,
    this.onMissionTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = _buildTimelineItems();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return _TimelineNode(
          item: item,
          isLast: isLast,
          onTap: () {
            if (item.type == _TimelineItemType.event && onEventTap != null) {
              final event = instance.templateId.events.firstWhere(
                (e) => e.code == item.code,
                orElse: () => const JourneyEvent(code: '', title: '', day: 0),
              );
              if (event.code.isNotEmpty) onEventTap!(event);
            } else if (item.type == _TimelineItemType.mission && onMissionTap != null) {
              final mission = instance.templateId.missions.firstWhere(
                (m) => m.code == item.code,
                orElse: () => const Mission(code: '', title: ''),
              );
              if (mission.code.isNotEmpty) onMissionTap!(mission);
            }
          },
        );
      },
    );
  }

  List<_TimelineItem> _buildTimelineItems() {
    final template = instance.templateId;
    final startDate = instance.startDate;
    final now = DateTime.now();
    final items = <_TimelineItem>[];

    // Add events
    for (final event in template.events) {
      final eventDate = startDate.add(Duration(days: event.day));
      final completion = instance.eventCompletions.firstWhere(
        (ec) => ec.eventCode == event.code,
        orElse: () => const EventCompletion(eventCode: ''),
      );
      final isCompleted = completion.eventCode.isNotEmpty;
      final isPast = now.isAfter(eventDate);

      _TimelineStatus status;
      if (isCompleted) {
        status = _TimelineStatus.completed;
      } else if (isPast) {
        status = _TimelineStatus.current;
      } else {
        status = _TimelineStatus.upcoming;
      }

      items.add(_TimelineItem(
        type: _TimelineItemType.event,
        code: event.code,
        title: event.titleTh ?? event.title,
        subtitle: event.title,
        day: event.day,
        date: eventDate,
        status: status,
        eventType: event.type,
        isLinkedToMilestone: event.isLinkedToMilestone,
        milestoneDay: event.milestoneDay,
        sortOrder: event.sortOrder,
      ));
    }

    // Add missions
    for (final mission in template.missions) {
      final openDate = startDate.add(Duration(days: mission.openOffsetDays));
      final review = instance.reviews.firstWhere(
        (r) => r.missionCode == mission.code,
        orElse: () => const Review(missionCode: '', decision: ''),
      );

      _TimelineStatus status;
      if (review.decision == 'pass') {
        status = _TimelineStatus.completed;
      } else if (review.decision.isNotEmpty) {
        status = _TimelineStatus.current; // reviewed but not passed
      } else if (now.isAfter(openDate)) {
        status = _TimelineStatus.current;
      } else {
        status = _TimelineStatus.upcoming;
      }

      items.add(_TimelineItem(
        type: _TimelineItemType.mission,
        code: mission.code,
        title: 'ภารกิจ ${mission.code}: ${mission.title}',
        subtitle: mission.description,
        day: mission.openOffsetDays,
        date: openDate,
        status: status,
        missionDecision: review.decision.isEmpty ? null : review.decision,
        sortOrder: 100 + mission.openOffsetDays,
      ));
    }

    // Sort by day, then events before missions
    items.sort((a, b) {
      if (a.day != b.day) return a.day.compareTo(b.day);
      if (a.type == _TimelineItemType.event && b.type == _TimelineItemType.mission) return -1;
      if (a.type == _TimelineItemType.mission && b.type == _TimelineItemType.event) return 1;
      return a.sortOrder.compareTo(b.sortOrder);
    });

    return items;
  }
}

enum _TimelineItemType { event, mission }

enum _TimelineStatus { completed, current, upcoming }

class _TimelineItem {
  final _TimelineItemType type;
  final String code;
  final String title;
  final String? subtitle;
  final int day;
  final DateTime date;
  final _TimelineStatus status;
  final EventType? eventType;
  final bool isLinkedToMilestone;
  final int? milestoneDay;
  final String? missionDecision;
  final int sortOrder;

  _TimelineItem({
    required this.type,
    required this.code,
    required this.title,
    this.subtitle,
    required this.day,
    required this.date,
    required this.status,
    this.eventType,
    this.isLinkedToMilestone = false,
    this.milestoneDay,
    this.missionDecision,
    this.sortOrder = 0,
  });
}

class _TimelineNode extends StatelessWidget {
  final _TimelineItem item;
  final bool isLast;
  final VoidCallback onTap;

  const _TimelineNode({
    required this.item,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final opacity = item.status == _TimelineStatus.upcoming ? 0.5 : 1.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day badge
          SizedBox(
            width: 48,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'D${item.day}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color.withOpacity(opacity),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Timeline line + dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.status == _TimelineStatus.completed
                        ? color
                        : Colors.transparent,
                    border: Border.all(color: color.withOpacity(opacity), width: 2),
                  ),
                  child: item.status == _TimelineStatus.completed
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: color.withOpacity(0.2),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Card(
                margin: const EdgeInsets.only(bottom: 8, right: 4, top: 4),
                elevation: item.status == _TimelineStatus.current ? 2 : 0,
                color: item.status == _TimelineStatus.current
                    ? Colors.white
                    : Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Opacity(
                    opacity: opacity,
                    child: Row(
                      children: [
                        _buildIcon(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: item.status == _TimelineStatus.completed
                                      ? Colors.grey.shade700
                                      : null,
                                ),
                              ),
                              if (item.subtitle != null && item.subtitle!.isNotEmpty)
                                Text(
                                  item.subtitle!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (item.type == _TimelineItemType.mission) {
      final missionColor = _getMissionColor();
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: missionColor.withOpacity(0.15),
        ),
        child: Center(
          child: Text(
            item.code,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: missionColor,
            ),
          ),
        ),
      );
    }

    IconData icon;
    switch (item.eventType) {
      case EventType.orientation:
        icon = Icons.school;
        break;
      case EventType.workshop:
        icon = Icons.build;
        break;
      case EventType.training:
        icon = Icons.fitness_center;
        break;
      case EventType.evaluation:
        icon = Icons.assessment;
        break;
      case EventType.feedback:
        icon = Icons.feedback;
        break;
      case EventType.celebration:
        icon = Icons.celebration;
        break;
      default:
        icon = Icons.event;
    }

    return Icon(icon, size: 20, color: _getColor().withOpacity(0.7));
  }

  Widget _buildStatusBadge() {
    if (item.type == _TimelineItemType.mission && item.missionDecision != null) {
      Color badgeColor;
      String text;
      switch (item.missionDecision) {
        case 'pass':
          badgeColor = Colors.green;
          text = 'ผ่าน';
          break;
        case 'fail':
          badgeColor = Colors.red;
          text = 'ไม่ผ่าน';
          break;
        case 'revision_required':
          badgeColor = Colors.orange;
          text = 'แก้ไข';
          break;
        default:
          badgeColor = Colors.grey;
          text = '';
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 10, color: badgeColor, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (item.isLinkedToMilestone) {
      return Icon(Icons.link, size: 16, color: Colors.blue.shade300);
    }

    if (item.status == _TimelineStatus.completed) {
      return Icon(Icons.check_circle, size: 18, color: Colors.green.shade400);
    }

    if (item.status == _TimelineStatus.current) {
      return Icon(Icons.access_time, size: 18, color: Colors.blue.shade400);
    }

    return const SizedBox.shrink();
  }

  Color _getColor() {
    switch (item.status) {
      case _TimelineStatus.completed:
        return Colors.green;
      case _TimelineStatus.current:
        return Colors.blue;
      case _TimelineStatus.upcoming:
        return Colors.grey;
    }
  }

  Color _getMissionColor() {
    const colors = {
      'H': Color(0xFFE53935),
      'A': Color(0xFFFF9800),
      'P': Color(0xFF4CAF50),
      'I': Color(0xFF2196F3),
      'N': Color(0xFF9C27B0),
      'E': Color(0xFF00BCD4),
      'S': Color(0xFFFF5722),
    };
    return colors[item.code] ?? Colors.grey;
  }
}
