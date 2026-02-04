import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/onboarding.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingTimelineScreen extends ConsumerStatefulWidget {
  const OnboardingTimelineScreen({super.key});

  @override
  ConsumerState<OnboardingTimelineScreen> createState() => _OnboardingTimelineScreenState();
}

class _OnboardingTimelineScreenState extends ConsumerState<OnboardingTimelineScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myOnboardingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ภารกิจ Onboarding ของฉัน'),
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
                children: [
                  const Icon(Icons.assignment_ind, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('คุณยังไม่มีโปรแกรม Onboarding'),
                ],
              ),
            );
          }

          final template = instance.templateId;
          final missions = template.missions;
          
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(myOnboardingProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: missions.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeader(context, instance);
                }
                
                final mission = missions[index - 1];
                return _buildMissionCard(context, instance, mission);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingInstance instance) {
    // Calculate progress
    // Simple logic: count passed missions / total missions
    final total = instance.templateId.missions.length;
    final passed = instance.reviews.where((r) => r.decision == 'pass').length;
    final submitted = instance.answers.map((a) => a.questionId).toSet().length; 
    // This is vague, answers are per question. 
    // Let's rely on completed status if we computed it, but we didn't yet.
    // For now display Start Date.
    
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              instance.templateId.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('เริ่มงาน: ${_formatDate(instance.startDate)}'),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: total > 0 ? passed / total : 0,
              backgroundColor: Colors.grey[200],
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Text('$passed / $total ภารกิจสำเร็จ'),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, OnboardingInstance instance, Mission mission) {
    // Determine status
    // 1. Check if reviewed
    final review = instance.reviews.firstWhere(
      (r) => r.missionCode == mission.code, 
      orElse: () => const Review(missionCode: '', decision: ''), // dummy
    );
    
    // 2. Check if submitted (any answer for this mission?)
    // This requires linking questions to mission code.
    // In our model Question has missionCode.
    // We need to know if ALL required questions for this mission are answered.
    // For MVP, let's just check if start date is open.
    
    final isOpen = _isMissionOpen(instance.startDate, mission.openOffsetDays);
    
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
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: isOpen 
            ? () {
               // Navigate to Mission Detail
               context.push('/onboarding/mission/${mission.code}'); 
              } 
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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

  bool _isMissionOpen(DateTime startDate, int offsetDays) {
    final openDate = startDate.add(Duration(days: offsetDays));
    return DateTime.now().isAfter(openDate);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
