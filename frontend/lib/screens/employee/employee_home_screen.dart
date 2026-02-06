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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.webp',
              width: 32,
              height: 32,
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

              // Stats cards row (matching Figma design)
              if (myMilestonesState.data != null)
                _buildStatsCards(myMilestonesState.data!),
              const SizedBox(height: AppSpacing.lg),

              // Onboarding Card (Culture Passport)
              _buildOnboardingCard(context, ref),
              const SizedBox(height: AppSpacing.lg),

              // Probation countdown card
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
            color: const Color(0xFFEF4444).withOpacity(0.3),
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
            // Header with logo
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'CP',
                      style: TextStyle(
                        color: Color(0xFFF62B25),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ยินดีต้อนรับสู่ CulturePassport',
                        style: AppTextStyles.headline3.copyWith(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ติดตามความคืบหน้าการเข้าปรับตัวของคุณ',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            // Employee info grid
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.person_outline,
                    label: 'ชื่อ-นามสกุล',
                    value: user?.name ?? '-',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.badge_outlined,
                    label: 'รหัสพนักงาน',
                    value: user?.employeeId ?? '-',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.business_outlined,
                    label: 'แผนก',
                    value: user?.department ?? '-',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.work_outline,
                    label: 'ตำแหน่ง',
                    value: user?.position ?? 'พนักงาน',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
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
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOnboardingCard(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(myOnboardingProvider);
    const culturePassportOrange = Color(0xFFFF6B35);

    return Card(
      color: const Color(0xFFFFF7ED), // orange-50
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: culturePassportOrange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_stories, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Culture Passport',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF9A3412), // orange-800
                          ),
                        ),
                        const SizedBox(height: 4),
                        onboardingState.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const Text(
                            'ทำภารกิจเพื่อก้าวสู่พนักงานมืออาชีพ',
                            style: TextStyle(color: Color(0xFFEA580C), fontSize: 12),
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
                              style: const TextStyle(color: Color(0xFFEA580C), fontSize: 12),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFEA580C)),
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

  Widget _buildStatsCards(MyMilestonesData data) {
    final milestones = data.milestones;
    final total = milestones.length;
    final completed = milestones.where((m) => m.status == MilestoneStatus.passed).length;
    final inProgress = milestones.where((m) =>
      m.status == MilestoneStatus.pendingSelf ||
      m.status == MilestoneStatus.pendingSupervisor ||
      m.status == MilestoneStatus.pendingApproval
    ).length;
    final progress = total > 0 ? ((completed / total) * 100).round() : 0;

    return Row(
      children: [
        // Progress card
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up,
            iconColor: const Color(0xFF2563EB), // blue-600
            label: 'ความคืบหน้า',
            value: '$progress%',
            subtitle: '$completed/$total',
          ),
        ),
        const SizedBox(width: 8),
        // Completed card
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF16A34A), // green-600
            label: 'เสร็จสิ้น',
            value: '$completed',
            subtitle: 'ภารกิจ',
            valueColor: const Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 8),
        // In progress card
        Expanded(
          child: _buildStatCard(
            icon: Icons.schedule,
            iconColor: const Color(0xFF2563EB), // blue-600
            label: 'กำลังทำ',
            value: '$inProgress',
            subtitle: 'ภารกิจ',
            valueColor: const Color(0xFF2563EB),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String subtitle,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.grey.shade900,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard(MyRecordInfo record) {
    final now = DateTime.now();
    final daysRemaining = record.endDate.difference(now).inDays;
    final daysElapsed = now.difference(record.startDate).inDays;
    final totalDays = record.probationDays;
    final progress = (daysElapsed / totalDays).clamp(0.0, 1.0);
    final isProbationPeriod = daysRemaining > 0;

    // Amber/orange color scheme from Figma
    const amberBg = Color(0xFFFFFBEB); // amber-50
    const amberBorder = Color(0xFFFCD34D); // amber-300
    const amberText = Color(0xFFD97706); // amber-600
    const amberDark = Color(0xFFB45309); // amber-700

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFBEB), Color(0xFFFFF7ED)], // amber-50 to orange-50
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: amberBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: amberBorder.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.calendar_month, color: amberText, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'ระยะเวลาทดลองงาน',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isProbationPeriod)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDE68A), // amber-200
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'กำลังทดลองงาน',
                                style: TextStyle(
                                  color: amberDark,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Days counter
            Row(
              children: [
                Text(
                  '$daysElapsed',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: amberText,
                  ),
                ),
                const Text(
                  ' / ',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  '$totalDays',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'วัน',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'เหลืออีก $daysRemaining วัน คุณจะผ่านระยะทดลองงาน',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            // Progress bar with amber gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFF97316)], // amber-500 to orange-500
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'วันที่เริ่มงาน: ${_formatDate(record.startDate)}',
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
              child: const Icon(Icons.flag, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('Milestones'),
          ],
        ),
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
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('โปรไฟล์'),
          ],
        ),
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
