import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

/// Notification list item widget
class NotificationItem extends StatelessWidget {
  /// The notification data
  final NotificationData notification;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Callback when item is dismissed
  final VoidCallback? onDismiss;

  /// Callback when mark as read is pressed
  final VoidCallback? onMarkAsRead;

  /// Show time in relative format (e.g., "2 hours ago")
  final bool showRelativeTime;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.onMarkAsRead,
    this.showRelativeTime = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction:
          onDismiss != null ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: notification.isRead
                ? theme.scaffoldBackgroundColor
                : theme.colorScheme.primaryContainer.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(context),
                    const SizedBox(height: 4),
                    _buildMessage(context),
                    const SizedBox(height: 6),
                    _buildFooter(context),
                  ],
                ),
              ),
              if (!notification.isRead && onMarkAsRead != null)
                _buildMarkAsReadButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = _getIconData();
    final iconColor = _getIconColor(theme);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        size: 20,
        color: iconColor,
      ),
    );
  }

  IconData _getIconData() {
    switch (notification.type) {
      case 'milestone_reminder':
        return Icons.calendar_today;
      case 'milestone_overdue':
        return Icons.warning_amber;
      case 'milestone_approved':
        return Icons.check_circle;
      case 'milestone_rejected':
        return Icons.cancel;
      case 'assessment_submitted':
        return Icons.assignment_turned_in;
      case 'supervisor_assessment':
        return Icons.rate_review;
      case 'kpi_assigned':
        return Icons.assignment;
      case 'probation_completed':
        return Icons.celebration;
      case 'approval_reminder':
        return Icons.pending_actions;
      case 'kpi_reminder':
        return Icons.assignment_late;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(ThemeData theme) {
    switch (notification.type) {
      case 'milestone_reminder':
        return Colors.blue;
      case 'milestone_overdue':
        return Colors.orange;
      case 'milestone_approved':
        return Colors.green;
      case 'milestone_rejected':
        return theme.colorScheme.error;
      case 'assessment_submitted':
        return Colors.teal;
      case 'supervisor_assessment':
        return Colors.purple;
      case 'kpi_assigned':
        return Colors.indigo;
      case 'probation_completed':
        return Colors.amber;
      case 'approval_reminder':
        return Colors.deepOrange;
      case 'kpi_reminder':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      notification.title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMessage(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      notification.message,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.textTheme.bodySmall?.color,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final timeText = showRelativeTime
        ? _getRelativeTime(notification.createdAt)
        : DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt);

    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 12,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          timeText,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
          ),
        ),
        if (notification.isActionable) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'ดำเนินการ',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMarkAsReadButton(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onMarkAsRead,
      icon: Icon(
        Icons.done,
        size: 18,
        color: theme.colorScheme.primary,
      ),
      tooltip: 'อ่านแล้ว',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
    );
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'เมื่อกี้';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks สัปดาห์ที่แล้ว';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months เดือนที่แล้ว';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}

/// Compact notification item for dropdown
class NotificationItemCompact extends StatelessWidget {
  /// The notification data
  final NotificationData notification;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  const NotificationItemCompact({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: notification.isRead ? null : theme.colorScheme.primaryContainer.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          notification.isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}
