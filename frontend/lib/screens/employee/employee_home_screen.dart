import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/milestone.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/self_assessment_provider.dart';
import '../../services/assessment_service.dart';
import '../../utils/theme.dart';
import '../../widgets/milestone_timeline.dart';
import '../../widgets/stamp_collection.dart';

class EmployeeHomeScreen extends ConsumerStatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  ConsumerState<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends ConsumerState<EmployeeHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myMilestonesProvider.notifier).loadMyMilestones();
      ref.read(currentAssessmentProvider.notifier).loadCurrentAssessment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _DashboardTab(),
          _MilestonesTab(),
          _ProfileTab(),
        ],
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
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline_outlined),
            activeIcon: Icon(Icons.timeline),
            label: 'Milestones',
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

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAssessmentState = ref.watch(currentAssessmentProvider);
    final myMilestonesState = ref.watch(myMilestonesProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าแรก'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(currentAssessmentProvider.notifier).refresh(),
            ref.read(myMilestonesProvider.notifier).refresh(),
          ]);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome card
              _buildWelcomeCard(context, ref, user),
              const SizedBox(height: AppSpacing.lg),

              // Onboarding Card
              _buildOnboardingCard(context, ref),
              const SizedBox(height: AppSpacing.lg),

              // Countdown card

              // Countdown card
              if (myMilestonesState.data?.record != null)
                _buildCountdownCard(myMilestonesState.data!.record!),
              const SizedBox(height: AppSpacing.lg),

              // Current milestone action card
              if (currentAssessmentState.hasCurrentMilestone)
                _buildCurrentMilestoneCard(
                  context,
                  currentAssessmentState.data!,
                ),
              const SizedBox(height: AppSpacing.lg),

              // Quick stats
              if (myMilestonesState.data != null)
                _buildQuickStats(myMilestonesState.data!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, WidgetRef ref, user) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สวัสดี, ${user?.name ?? ""}',
                    style: AppTextStyles.headline3.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'พนักงานทดลองงาน • ${user?.department ?? ""}',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingCard(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(myOnboardingProvider);

    return Card(
      color: Colors.indigo.shade50,
      child: InkWell(
        onTap: () => context.push('/employee/onboarding'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.indigo, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Culture Passport',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        onboardingState.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => Text(
                            'ทำภารกิจเพื่อก้าวสู่พนักงานมืออาชีพ',
                            style: TextStyle(color: Colors.indigo.shade800, fontSize: 12),
                          ),
                          data: (instance) {
                            if (instance == null) {
                              return Text(
                                'ยังไม่มีโปรแกรม Onboarding',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              );
                            }
                            final passed = instance.reviews.where((r) => r.decision == 'pass').length;
                            final total = instance.templateId.missions.length;
                            return Text(
                              '$passed/$total stamps collected',
                              style: TextStyle(color: Colors.indigo.shade800, fontSize: 12),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.indigo),
                ],
              ),
              // Mini stamp dots
              onboardingState.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (instance) {
                  if (instance == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: MiniStampDots(
                      missions: instance.templateId.missions,
                      reviews: instance.reviews,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownCard(MyRecordInfo record) {
    final now = DateTime.now();
    final daysRemaining = record.endDate.difference(now).inDays;
    final daysElapsed = now.difference(record.startDate).inDays;
    final totalDays = record.probationDays;
    final progress = (daysElapsed / totalDays).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ระยะเวลาทดลองงาน',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalDays วัน',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        daysRemaining > 0 ? '$daysRemaining' : '0',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'วันที่เหลือ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$daysElapsed',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'วันที่ผ่านมา',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(record.startDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDate(record.endDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentMilestoneCard(
    BuildContext context,
    CurrentAssessmentData data,
  ) {
    final milestone = data.currentMilestone!;
    final record = data.record!;
    final daysUntilDue = milestone.dueDate.difference(DateTime.now()).inDays;
    final isOverdue = daysUntilDue < 0;

    return Card(
      color: isOverdue
          ? Colors.red.shade50
          : AppColors.primary.withOpacity(0.05),
      child: InkWell(
        onTap: () {
          context.push('/employee/assessment/${record.id}/${milestone.day}');
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isOverdue
                      ? Colors.red.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${milestone.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isOverdue ? Colors.red : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOverdue
                          ? 'มี Milestone รอประเมิน!'
                          : 'ถึงเวลาประเมินตนเอง',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isOverdue ? Colors.red : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Milestone วันที่ ${milestone.day}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isOverdue
                          ? 'เกินกำหนด ${-daysUntilDue} วัน'
                          : daysUntilDue == 0
                              ? 'กำหนดวันนี้'
                              : 'เหลืออีก $daysUntilDue วัน',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue ? Colors.red : Colors.grey.shade600,
                        fontWeight: isOverdue ? FontWeight.w500 : null,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.edit_note,
                color: isOverdue ? Colors.red : AppColors.primary,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(MyMilestonesData data) {
    final milestones = data.milestones;
    final passed = milestones.where((m) => m.status == MilestoneStatus.passed).length;
    final failed = milestones.where((m) => m.status == MilestoneStatus.failed).length;
    final pending = milestones
        .where((m) =>
            m.status == MilestoneStatus.pendingSelf ||
            m.status == MilestoneStatus.pendingSupervisor ||
            m.status == MilestoneStatus.pendingApproval)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'สถานะ Milestone',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'ผ่าน',
                value: passed.toString(),
                color: Colors.green,
                icon: Icons.check_circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'รอดำเนินการ',
                value: pending.toString(),
                color: Colors.orange,
                icon: Icons.pending,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'ไม่ผ่าน',
                value: failed.toString(),
                color: Colors.red,
                icon: Icons.cancel,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    return '${date.day} ${months[date.month]} ${date.year + 543}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestonesTab extends ConsumerWidget {
  const _MilestonesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myMilestonesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(myMilestonesProvider.notifier).refresh(),
        child: state.isLoading && state.data == null
            ? const Center(child: CircularProgressIndicator())
            : state.data == null || state.data!.milestones.isEmpty
                ? const Center(child: Text('ไม่พบข้อมูล Milestone'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: MilestoneTimeline(
                      milestones: state.data!.milestones,
                      onMilestoneTap: (milestone) {
                        if (milestone.status == MilestoneStatus.pendingSelf ||
                            milestone.status == MilestoneStatus.overdue) {
                          context.push(
                            '/employee/assessment/${state.data!.record!.id}/${milestone.day}',
                          );
                        } else {
                          context.push(
                            '/employee/milestone/${state.data!.record!.id}/${milestone.day}',
                          );
                        }
                      },
                    ),
                  ),
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
