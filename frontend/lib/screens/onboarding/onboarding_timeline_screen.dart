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
        title: const Text('Culture Passport'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
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
          Card(
            elevation: 0,
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'Stamp Collection',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
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

    return Card(
      color: const Color(0xFF1A237E),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'HAPINES\nCulture Passport',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Day $daysElapsed/$totalDays',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'เริ่มงาน: ${_formatDate(instance.startDate)}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context) {
    final total = instance.templateId.missions.length;
    final passed = instance.reviews.where((r) => r.decision == 'pass').length;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ภารกิจ HAPINES',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: total > 0 ? passed / total : 0,
              backgroundColor: Colors.grey[200],
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text('$passed / $total ภารกิจสำเร็จ'),
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
