import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_provider.dart';

/// Notification badge widget showing unread count
class NotificationBadge extends ConsumerStatefulWidget {
  /// Child widget (usually an icon)
  final Widget child;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Badge color (defaults to red)
  final Color? badgeColor;

  /// Text color (defaults to white)
  final Color? textColor;

  /// Show badge even when count is 0
  final bool showZero;

  /// Maximum count to display (shows "99+" if exceeded)
  final int maxCount;

  const NotificationBadge({
    super.key,
    required this.child,
    this.onTap,
    this.badgeColor,
    this.textColor,
    this.showZero = false,
    this.maxCount = 99,
  });

  @override
  ConsumerState<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends ConsumerState<NotificationBadge> {
  @override
  void initState() {
    super.initState();
    // Fetch unread count on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(unreadCountProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadState = ref.watch(unreadCountProvider);
    final count = unreadState.count;
    final theme = Theme.of(context);

    final badgeColor = widget.badgeColor ?? theme.colorScheme.error;
    final textColor = widget.textColor ?? Colors.white;

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.child,
          ),
          if (count > 0 || widget.showZero)
            Positioned(
              right: 0,
              top: 0,
              child: _buildBadge(count, badgeColor, textColor),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(int count, Color badgeColor, Color textColor) {
    final displayText = count > widget.maxCount ? '${widget.maxCount}+' : '$count';
    final isLargeNumber = count > 9;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isLargeNumber ? 6 : 4,
        vertical: 2,
      ),
      constraints: BoxConstraints(
        minWidth: isLargeNumber ? 20 : 18,
        minHeight: 18,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Simple notification icon with badge for app bar
class NotificationIconBadge extends ConsumerWidget {
  /// Callback when tapped
  final VoidCallback? onTap;

  /// Icon size
  final double iconSize;

  /// Icon color
  final Color? iconColor;

  const NotificationIconBadge({
    super.key,
    this.onTap,
    this.iconSize = 24,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return NotificationBadge(
      onTap: onTap,
      child: Icon(
        Icons.notifications_outlined,
        size: iconSize,
        color: iconColor ?? theme.iconTheme.color,
      ),
    );
  }
}

/// Animated notification bell with shake effect
class AnimatedNotificationBell extends ConsumerStatefulWidget {
  /// Callback when tapped
  final VoidCallback? onTap;

  /// Icon size
  final double iconSize;

  /// Icon color
  final Color? iconColor;

  /// Animate on new notification
  final bool animateOnChange;

  const AnimatedNotificationBell({
    super.key,
    this.onTap,
    this.iconSize = 24,
    this.iconColor,
    this.animateOnChange = true,
  });

  @override
  ConsumerState<AnimatedNotificationBell> createState() =>
      _AnimatedNotificationBellState();
}

class _AnimatedNotificationBellState
    extends ConsumerState<AnimatedNotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0.1)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shake() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadState = ref.watch(unreadCountProvider);
    final theme = Theme.of(context);

    // Animate on count increase
    if (widget.animateOnChange && unreadState.count > _previousCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _shake());
    }
    _previousCount = unreadState.count;

    return NotificationBadge(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 3.14159,
            child: child,
          );
        },
        child: Icon(
          unreadState.count > 0
              ? Icons.notifications_active
              : Icons.notifications_outlined,
          size: widget.iconSize,
          color: widget.iconColor ?? theme.iconTheme.color,
        ),
      ),
    );
  }
}
