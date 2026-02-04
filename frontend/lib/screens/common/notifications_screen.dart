import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/notification_provider.dart';
import '../../services/notification_service.dart';
import '../../widgets/notification_item.dart';

/// Notifications screen showing all user notifications
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load notifications on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsListProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationsListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(notificationsListProvider);
    final unreadOnly = ref.watch(unreadOnlyFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('การแจ้งเตือน'),
        actions: [
          // Filter toggle
          IconButton(
            onPressed: () {
              ref.read(unreadOnlyFilterProvider.notifier).state = !unreadOnly;
              ref.read(notificationsListProvider.notifier).setUnreadOnly(!unreadOnly);
            },
            icon: Icon(
              unreadOnly ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: unreadOnly ? theme.colorScheme.primary : null,
            ),
            tooltip: unreadOnly ? 'แสดงทั้งหมด' : 'แสดงเฉพาะยังไม่อ่าน',
          ),
          // Mark all as read
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _showMarkAllReadConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20),
                    SizedBox(width: 8),
                    Text('อ่านทั้งหมดแล้ว'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(notificationsListProvider.notifier).refresh();
        },
        child: _buildBody(state, theme),
      ),
    );
  }

  Widget _buildBody(NotificationsListState state, ThemeData theme) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.notifications.isEmpty) {
      return _buildErrorState(state.error!, theme);
    }

    if (state.notifications.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: state.notifications.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.notifications.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final notification = state.notifications[index];
        return NotificationItem(
          notification: notification,
          onTap: () => _handleNotificationTap(notification),
          onDismiss: () => _handleNotificationDismiss(notification),
          onMarkAsRead: notification.isRead
              ? null
              : () => _handleMarkAsRead(notification),
        );
      },
    );
  }

  Widget _buildErrorState(String error, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'เกิดข้อผิดพลาด',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.read(notificationsListProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final unreadOnly = ref.watch(unreadOnlyFilterProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              unreadOnly ? 'ไม่มีการแจ้งเตือนที่ยังไม่อ่าน' : 'ไม่มีการแจ้งเตือน',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              unreadOnly
                  ? 'คุณอ่านการแจ้งเตือนทั้งหมดแล้ว'
                  : 'เมื่อมีการแจ้งเตือนใหม่จะแสดงที่นี่',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (unreadOnly) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  ref.read(unreadOnlyFilterProvider.notifier).state = false;
                  ref.read(notificationsListProvider.notifier).setUnreadOnly(false);
                },
                child: const Text('แสดงทั้งหมด'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationData notification) {
    // Mark as read first
    if (!notification.isRead) {
      ref.read(notificationsListProvider.notifier).markAsRead(notification.id);
    }

    // Navigate based on notification type
    final data = notification.data;
    switch (notification.type) {
      case 'milestone_reminder':
      case 'milestone_overdue':
      case 'milestone_approved':
      case 'milestone_rejected':
        if (data != null && data['milestoneDay'] != null) {
          context.push('/milestones/${data['milestoneDay']}');
        }
        break;
      case 'assessment_submitted':
      case 'supervisor_assessment':
        if (data != null && data['probationRecordId'] != null) {
          context.push('/supervisor/pending-approvals');
        }
        break;
      case 'kpi_assigned':
        context.push('/employee/milestones');
        break;
      case 'approval_reminder':
        context.push('/supervisor/pending-approvals');
        break;
      case 'kpi_reminder':
        if (data != null && data['employeeId'] != null) {
          context.push('/supervisor/employee/${data['employeeId']}/kpi');
        }
        break;
      case 'probation_completed':
        context.push('/employee/results');
        break;
      default:
        // No specific navigation
        break;
    }
  }

  void _handleNotificationDismiss(NotificationData notification) {
    ref.read(notificationsListProvider.notifier).deleteNotification(notification.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('ลบการแจ้งเตือนแล้ว'),
        action: SnackBarAction(
          label: 'เลิกทำ',
          onPressed: () {
            // Refresh to restore
            ref.read(notificationsListProvider.notifier).refresh();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleMarkAsRead(NotificationData notification) {
    ref.read(notificationsListProvider.notifier).markAsRead(notification.id);
  }

  void _showMarkAllReadConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('อ่านทั้งหมดแล้ว'),
        content: const Text('ต้องการทำเครื่องหมายว่าอ่านการแจ้งเตือนทั้งหมดแล้วหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(notificationsListProvider.notifier).markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('อ่านการแจ้งเตือนทั้งหมดแล้ว'),
                ),
              );
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }
}

/// Notifications dropdown for app bar
class NotificationsDropdown extends ConsumerWidget {
  /// Maximum notifications to show
  final int maxItems;

  const NotificationsDropdown({
    super.key,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsListProvider);
    final theme = Theme.of(context);

    return Container(
      width: 320,
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'การแจ้งเตือน',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.notifications.any((n) => !n.isRead))
                  TextButton(
                    onPressed: () {
                      ref.read(notificationsListProvider.notifier).markAllAsRead();
                    },
                    child: const Text('อ่านทั้งหมด'),
                  ),
              ],
            ),
          ),
          // Notifications list
          Flexible(
            child: state.notifications.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 48,
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ไม่มีการแจ้งเตือน',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.notifications.length > maxItems
                        ? maxItems
                        : state.notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationItemCompact(
                        notification: state.notifications[index],
                        onTap: () {
                          Navigator.of(context).pop();
                          // Navigate to notification
                        },
                      );
                    },
                  ),
          ),
          // Footer
          if (state.notifications.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
                ),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/notifications');
                  },
                  child: const Text('ดูทั้งหมด'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
