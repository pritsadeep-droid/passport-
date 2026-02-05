import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/probation_record.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/milestone_provider.dart';
import '../../providers/probation_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/approval_buttons.dart';
import 'team_list_screen.dart';

class SupervisorHomeScreen extends ConsumerStatefulWidget {
  const SupervisorHomeScreen({super.key});

  @override
  ConsumerState<SupervisorHomeScreen> createState() =>
      _SupervisorHomeScreenState();
}

class _SupervisorHomeScreenState extends ConsumerState<SupervisorHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TeamListScreen(),
    const _DashboardTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'ทีมของฉัน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'ภาพรวม',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends ConsumerStatefulWidget {
  const _DashboardTab();

  @override
  ConsumerState<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<_DashboardTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pendingApprovalsProvider.notifier).loadPendingApprovals();
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(teamProbationProvider.notifier).refresh(),
      ref.read(pendingApprovalsProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamProbationProvider);
    final pendingApprovalsState = ref.watch(pendingApprovalsProvider);
    final records = state.records;

    // Calculate stats
    final pendingKpi =
        records.where((r) => r.status.isPendingKpi).length;
    final inProgress =
        records.where((r) => r.status.isInProgress).length;
    final pendingDecision =
        records.where((r) => r.status.isPendingDecision).length;
    final passed = records.where((r) => r.status.isPassed).length;
    final pendingMilestoneApprovals = pendingApprovalsState.approvals.length;

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
              child: const Icon(Icons.auto_stories, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('CulturePassport'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome card
              _buildWelcomeCard(ref),
              const SizedBox(height: AppSpacing.lg),

              // Pending approvals section
              if (pendingMilestoneApprovals > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'รออนุมัติ Milestone',
                      style: AppTextStyles.headline3,
                    ),
                    TextButton(
                      onPressed: () => context.push('/supervisor/pending-approvals'),
                      child: const Text('ดูทั้งหมด'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ...pendingApprovalsState.approvals.take(3).map(
                      (approval) => PendingApprovalCard(
                        employeeName: approval.employee.name ?? approval.employee.email ?? '',
                        department: approval.employee.department,
                        milestoneDay: approval.milestone.day,
                        dueDate: approval.milestone.dueDate,
                        onTap: () => context.push(
                          '/supervisor/milestone-approval/${approval.probationRecordId}/${approval.milestone.day}',
                        ),
                      ),
                    ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Stats grid
              Text(
                'สถิติพนักงานทดลองงาน',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: AppSpacing.md),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(
                    title: 'รอกำหนด KPI',
                    value: pendingKpi.toString(),
                    icon: Icons.flag_outlined,
                    color: AppColors.warning,
                  ),
                  _StatCard(
                    title: 'กำลังดำเนินการ',
                    value: inProgress.toString(),
                    icon: Icons.pending_actions,
                    color: AppColors.info,
                  ),
                  _StatCard(
                    title: 'รอตัดสินใจ',
                    value: pendingDecision.toString(),
                    icon: Icons.how_to_reg,
                    color: AppColors.primary,
                  ),
                  _StatCard(
                    title: 'ผ่านทดลองงาน',
                    value: passed.toString(),
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Quick actions
              Text(
                'การดำเนินการด่วน',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildQuickActions(context, ref, pendingKpi, pendingDecision, pendingMilestoneApprovals),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDC2626), // red-600
            Color(0xFFB91C1C), // red-700
            Color(0xFFBE123C), // rose-800
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'แดชบอร์ดผู้จัดการ',
              style: AppTextStyles.headline2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ติดตามและประเมินผลทีมของคุณ',
              style: AppTextStyles.body2.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            // Manager info grid
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildInfoChip(Icons.person_outline, 'ชื่อ-นามสกุล', user?.name ?? '-'),
                _buildInfoChip(Icons.badge_outlined, 'รหัสพนักงาน', user?.employeeId ?? '-'),
                _buildInfoChip(Icons.business_outlined, 'แผนก', user?.department ?? '-'),
                _buildInfoChip(Icons.work_outline, 'ตำแหน่ง', user?.position ?? 'หัวหน้างาน'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: const Color(0xFFB91C1C), size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(
      BuildContext context, WidgetRef ref, int pendingKpi, int pendingDecision, int pendingMilestoneApprovals) {
    final hasActions = pendingKpi > 0 || pendingDecision > 0 || pendingMilestoneApprovals > 0;

    return Column(
      children: [
        if (pendingMilestoneApprovals > 0)
          _QuickActionCard(
            icon: Icons.pending_actions,
            title: 'อนุมัติ Milestone',
            subtitle: 'มี $pendingMilestoneApprovals รายการรออนุมัติ',
            color: Colors.orange,
            onTap: () => context.push('/supervisor/pending-approvals'),
          ),
        if (pendingKpi > 0)
          _QuickActionCard(
            icon: Icons.flag,
            title: 'กำหนด KPI',
            subtitle: 'มี $pendingKpi คนที่รอกำหนด KPI',
            color: AppColors.warning,
            onTap: () {
              // Navigate to team list with filter
            },
          ),
        if (pendingDecision > 0)
          _QuickActionCard(
            icon: Icons.how_to_reg,
            title: 'รอการประเมิน',
            subtitle: 'มี $pendingDecision คนที่รอการประเมิน',
            color: AppColors.primary,
            onTap: () {
              // Navigate to team list with filter
            },
          ),
        if (!hasActions)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 40,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'ไม่มีรายการที่ต้องดำเนินการ',
                      style: AppTextStyles.body1,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  value,
                  style: AppTextStyles.headline2.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Profile card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      _getInitials(user?.name ?? ''),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    user?.name ?? '',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Chip(
                    label: Text(user?.role.displayName ?? ''),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Menu items
          _MenuTile(
            icon: Icons.person_outline,
            title: 'แก้ไขโปรไฟล์',
            onTap: () {},
          ),
          _MenuTile(
            icon: Icons.lock_outline,
            title: 'เปลี่ยนรหัสผ่าน',
            onTap: () {},
          ),
          _MenuTile(
            icon: Icons.notifications_outlined,
            title: 'การแจ้งเตือน',
            onTap: () => context.push('/notifications'),
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'ตั้งค่า',
            onTap: () => context.push('/settings'),
          ),
          const Divider(),
          _MenuTile(
            icon: Icons.logout,
            title: 'ออกจากระบบ',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('ยืนยันการออกจากระบบ'),
                  content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('ยกเลิก'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('ออกจากระบบ'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(authProvider.notifier).logout();
              }
            },
            textColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
