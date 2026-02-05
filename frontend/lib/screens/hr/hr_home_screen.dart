import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/notification_badge.dart';
import 'hr_dashboard_screen.dart';
import 'all_employees_screen.dart';
import 'reports_screen.dart';

/// HR Home screen with bottom navigation
class HRHomeScreen extends ConsumerStatefulWidget {
  /// Initial tab index
  final int initialTab;

  const HRHomeScreen({
    super.key,
    this.initialTab = 0,
  });

  @override
  ConsumerState<HRHomeScreen> createState() => _HRHomeScreenState();
}

class _HRHomeScreenState extends ConsumerState<HRHomeScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HRDashboardScreen(),
    const AllEmployeesScreen(),
    const ReportsScreen(),
    const _SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'พนักงาน',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment),
            label: 'รายงาน',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'ตั้งค่า',
          ),
        ],
      ),
    );
  }
}

/// Settings screen for HR
class _SettingsScreen extends ConsumerWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              child: const Icon(Icons.settings, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('ตั้งค่า'),
          ],
        ),
      ),
      body: ListView(
        children: [
          // Profile section
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    (user?.name ?? user?.email ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'HR Admin',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'HR Admin',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.push('/profile'),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Settings options
          _buildSettingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'การแจ้งเตือน',
            subtitle: 'ตั้งค่าการแจ้งเตือน',
            onTap: () => context.push('/notifications'),
          ),

          _buildSettingsTile(
            context,
            icon: Icons.schedule_outlined,
            title: 'ตั้งค่า Milestone',
            subtitle: 'กำหนดวัน Milestone เริ่มต้น',
            onTap: () => context.push('/hr/milestone-settings'),
          ),

          _buildSettingsTile(
            context,
            icon: Icons.assignment_outlined,
            title: 'เทมเพลต KPI',
            subtitle: 'จัดการเทมเพลต KPI เริ่มต้น',
            onTap: () => context.push('/hr/kpi-templates'),
          ),

          _buildSettingsTile(
            context,
            icon: Icons.email_outlined,
            title: 'ตั้งค่าอีเมล',
            subtitle: 'กำหนดเทมเพลตอีเมลแจ้งเตือน',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('กำลังพัฒนา...')),
              );
            },
          ),

          const Divider(),

          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: 'ช่วยเหลือ',
            subtitle: 'คู่มือการใช้งาน',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('กำลังพัฒนา...')),
              );
            },
          ),

          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'เกี่ยวกับ',
            subtitle: 'เวอร์ชัน 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'KPI Probation',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Lottery Plus Co., Ltd.',
              );
            },
          ),

          const Divider(),

          // Logout
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: 'ออกจากระบบ',
            subtitle: '',
            showTrailing: false,
            iconColor: theme.colorScheme.error,
            titleColor: theme.colorScheme.error,
            onTap: () => _showLogoutDialog(context, ref),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    bool showTrailing = true,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: showTrailing ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }
}
