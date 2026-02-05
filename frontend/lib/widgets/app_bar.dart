import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';

/// Custom app bar widget with notification badge
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showNotificationBadge;
  final VoidCallback? onNotificationTap;
  final PreferredSizeWidget? bottom;
  final IconData? logoIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.showNotificationBadge = true,
    this.onNotificationTap,
    this.bottom,
    this.logoIcon,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (logoIcon != null) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(logoIcon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Text(title),
        ],
      ),
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )
              : null),
      actions: [
        if (actions != null) ...actions!,
        if (showNotificationBadge && user != null)
          NotificationBadgeButton(
            onTap: onNotificationTap,
          ),
        const SizedBox(width: 8),
      ],
      bottom: bottom,
    );
  }
}

/// Notification badge button
class NotificationBadgeButton extends StatelessWidget {
  final VoidCallback? onTap;
  final int unreadCount;

  const NotificationBadgeButton({
    super.key,
    this.onTap,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onTap,
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// App bar with search functionality
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String hintText;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onClear;
  final List<Widget>? actions;

  const SearchAppBar({
    super.key,
    required this.title,
    this.hintText = 'ค้นหา...',
    this.onSearch,
    this.onClear,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onClear?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
              onChanged: widget.onSearch,
            )
          : Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        if (!_isSearching && widget.actions != null) ...widget.actions!,
      ],
    );
  }
}

/// Sliver app bar for scrollable content
class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final Widget? flexibleSpace;
  final double expandedHeight;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.flexibleSpace,
    this.expandedHeight = 200,
    this.actions,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      flexibleSpace: flexibleSpace,
      actions: actions,
    );
  }
}
