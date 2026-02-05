import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/onboarding.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/stamp_collection.dart';
import '../../widgets/journey_timeline.dart';

class OnboardingTimelineScreen extends ConsumerStatefulWidget {
  const OnboardingTimelineScreen({super.key});

  @override
  ConsumerState<OnboardingTimelineScreen> createState() => _OnboardingTimelineScreenState();
}

class _OnboardingTimelineScreenState extends ConsumerState<OnboardingTimelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myOnboardingProvider);

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
            const Text('Culture Passport'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF6B35),
          indicatorWeight: 3,
          labelColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFFFF6B35),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'ภารกิจ HAPINES'),
            Tab(text: 'เส้นทาง Onboarding'),
          ],
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('เกิดข้อผิดพลาด: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.refresh(myOnboardingProvider),
                child: const Text('ลองใหม่'),
              ),
            ],
          ),
        ),
        data: (instance) {
          if (instance == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.assignment_ind, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('คุณยังไม่มีโปรแกรม Onboarding'),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _MissionsTab(instance: instance),
              _JourneyTab(instance: instance),
            ],
          );
        },
      ),
    );
  }
}

class _MissionsTab extends ConsumerWidget {
  final OnboardingInstance instance;

  const _MissionsTab({required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = instance.templateId;
    final missions = template.missions;

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(myOnboardingProvider),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Passport Info Card
          _buildPassportInfoCard(context),
          const SizedBox(height: 16),

          // Stamp Collection
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFF7ED), // orange-50
                  const Color(0xFFFEF3C7).withOpacity(0.5), // amber-100
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFED7AA)), // orange-200
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.stars, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stamp Collection',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF9A3412), // orange-800
                              ),
                            ),
                            Text(
                              'สะสมแสตมป์ทั้ง 7 ภารกิจ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEA580C), // orange-600
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StampCollectionWidget(
                    missions: missions,
                    reviews: instance.reviews,
                    startDate: instance.startDate,
                    onStampTap: (mission) {
                      if (_isMissionOpen(mission)) {
                        context.push('/employee/onboarding/mission/${mission.code}');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Progress
          _buildProgressHeader(context),
          const SizedBox(height: 16),

          // Mission List
          ...missions.map((mission) => _buildMissionCard(context, mission)),
        ],
      ),
    );
  }

  Widget _buildPassportInfoCard(BuildContext context) {
    final now = DateTime.now();
    final daysElapsed = now.difference(instance.startDate).inDays;
    final totalDays = instance.templateId.durationDays;
    final passed = instance.reviews.where((r) => r.decision == 'pass').length;
    final total = instance.templateId.missions.length;

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
        padding: const EdgeInsets.all(20),
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
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_stories, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HAPINES Culture Passport',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'เส้นทางสู่พนักงานมืออาชีพ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            // Stats row
            Row(
              children: [
                _buildPassportStat(
                  icon: Icons.calendar_today,
                  value: 'Day $daysElapsed',
                  label: 'จาก $totalDays วัน',
                ),
                const SizedBox(width: 24),
                _buildPassportStat(
                  icon: Icons.verified,
                  value: '$passed/$total',
                  label: 'stamps',
                ),
                const SizedBox(width: 24),
                _buildPassportStat(
                  icon: Icons.play_arrow,
                  value: _formatDate(instance.startDate),
                  label: 'เริ่มงาน',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassportStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressHeader(BuildContext context) {
    final total = instance.templateId.missions.length;
    final passed = instance.reviews.where((r) => r.decision == 'pass').length;
    final progress = total > 0 ? (passed / total * 100).round() : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ภารกิจ HAPINES',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: progress >= 100
                        ? const Color(0xFFDCFCE7) // green-100
                        : const Color(0xFFDBEAFE), // blue-100
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$progress%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: progress >= 100
                          ? const Color(0xFF16A34A) // green-600
                          : const Color(0xFF2563EB), // blue-600
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: total > 0 ? passed / total : 0,
                backgroundColor: Colors.grey[200],
                minHeight: 10,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 100
                      ? const Color(0xFF16A34A) // green-600
                      : const Color(0xFF2563EB), // blue-600
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$passed / $total ภารกิจสำเร็จ',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${total - passed} ภารกิจเหลือ',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, Mission mission) {
    final review = instance.reviews.firstWhere(
      (r) => r.missionCode == mission.code,
      orElse: () => const Review(missionCode: '', decision: ''),
    );

    final isOpen = _isMissionOpen(mission);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (review.decision == 'pass') {
      statusColor = Colors.green;
      statusText = 'ผ่านแล้ว';
      statusIcon = Icons.check_circle;
    } else if (review.decision == 'revision_required') {
      statusColor = Colors.orange;
      statusText = 'แก้ไข';
      statusIcon = Icons.warning;
    } else if (review.decision == 'fail') {
      statusColor = Colors.red;
      statusText = 'ไม่ผ่าน';
      statusIcon = Icons.cancel;
    } else if (isOpen) {
      statusColor = Colors.blue;
      statusText = 'เปิดอยู่';
      statusIcon = Icons.lock_open;
    } else {
      statusColor = Colors.grey;
      statusText = 'ยังไม่ถึงกำหนด';
      statusIcon = Icons.lock;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isOpen || review.decision == 'pass'
            ? () => context.push('/employee/onboarding/mission/${mission.code}')
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  mission.code,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (mission.description != null)
                      Text(
                        mission.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(statusIcon, color: statusColor),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: TextStyle(fontSize: 10, color: statusColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isMissionOpen(Mission mission) {
    final openDate = instance.startDate.add(Duration(days: mission.openOffsetDays));
    return DateTime.now().isAfter(openDate);
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
    ];
    return '${date.day} ${months[date.month]} ${date.year + 543}';
  }
}

class _JourneyTab extends ConsumerWidget {
  final OnboardingInstance instance;

  const _JourneyTab({required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(myOnboardingProvider),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เส้นทาง Onboarding',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'กิจกรรมและภารกิจตลอด ${instance.templateId.durationDays} วัน',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            JourneyTimelineWidget(
              instance: instance,
              onMissionTap: (mission) {
                final openDate = instance.startDate.add(Duration(days: mission.openOffsetDays));
                if (DateTime.now().isAfter(openDate)) {
                  context.push('/employee/onboarding/mission/${mission.code}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
