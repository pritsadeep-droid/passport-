import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/onboarding.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/stamp_collection.dart';

class OnboardingReviewScreen extends ConsumerStatefulWidget {
  final String onboardingId;

  const OnboardingReviewScreen({
    super.key,
    required this.onboardingId,
  });

  @override
  ConsumerState<OnboardingReviewScreen> createState() => _OnboardingReviewScreenState();
}

class _OnboardingReviewScreenState extends ConsumerState<OnboardingReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingDetailProvider(widget.onboardingId));

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
              child: const Icon(Icons.fact_check, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('ตรวจสอบ Onboarding'),
          ],
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (instance) {
          if (instance == null) return const Center(child: Text('Not found'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, instance),
                const SizedBox(height: 16),
                _buildStampOverview(context, instance),
                const SizedBox(height: 16),
                _buildEventChecklist(context, instance),
                const SizedBox(height: 16),
                const Text(
                  'ภารกิจ HAPINES',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                ...instance.templateId.missions.map(
                  (mission) => _buildMissionReviewCard(context, instance, mission),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingInstance instance) {
    final total = instance.templateId.missions.length;
    final passed = instance.reviews.where((r) => r.decision == 'pass').length;
    final eventsTotal = instance.templateId.events.length;
    final eventsCompleted = instance.eventCompletions.length;
    final overallProgress = total > 0
        ? ((passed / total * 0.6) + (eventsTotal > 0 ? eventsCompleted / eventsTotal * 0.4 : 0.4))
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'พนักงาน: ${instance.employeeId}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('สถานะ: ${instance.status}'),
            Text('เริ่ม: ${_formatDate(instance.startDate)}'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('ความคืบหน้ารวม: ', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  '${(overallProgress * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: overallProgress >= 0.8 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: overallProgress.clamp(0.0, 1.0),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStampOverview(BuildContext context, OnboardingInstance instance) {
    final passed = instance.reviews.where((r) => r.decision == 'pass').length;
    final total = instance.templateId.missions.length;

    return Card(
      elevation: 0,
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  'Stamp Collection ($passed/$total)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StampCollectionWidget(
              missions: instance.templateId.missions,
              reviews: instance.reviews,
              startDate: instance.startDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventChecklist(BuildContext context, OnboardingInstance instance) {
    final events = instance.templateId.events;
    if (events.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_available, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'กิจกรรม (${instance.eventCompletions.length}/${events.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...events.map((event) {
              final isCompleted = instance.eventCompletions
                  .any((ec) => ec.eventCode == event.code);

              return CheckboxListTile(
                value: isCompleted,
                title: Text(
                  event.titleTh ?? event.title,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : null,
                  ),
                ),
                subtitle: Text(
                  'Day ${event.day} - ${event.title}',
                  style: const TextStyle(fontSize: 12),
                ),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: isCompleted
                    ? null
                    : (value) {
                        if (value == true) {
                          _completeEvent(event.code);
                        }
                      },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionReviewCard(BuildContext context, OnboardingInstance instance, Mission mission) {
    final questions = instance.templateId.questions
        .where((q) => q.missionCode == mission.code)
        .toList();

    final review = instance.reviews.firstWhere(
      (r) => r.missionCode == mission.code,
      orElse: () => const Review(missionCode: '', decision: ''),
    );

    Color? headerColor;
    if (review.decision == 'pass') {
      headerColor = Colors.green.shade50;
    } else if (review.decision == 'fail') {
      headerColor = Colors.red.shade50;
    } else if (review.decision == 'revision_required') {
      headerColor = Colors.orange.shade50;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        backgroundColor: headerColor,
        collapsedBackgroundColor: headerColor,
        title: Text(mission.title),
        subtitle: Text('สถานะ: ${review.decision.isEmpty ? "รอตรวจ" : _getDecisionText(review.decision)}'),
        leading: _buildMissionStatusIcon(review.decision),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...questions.map((q) {
                  final answer = instance.answers.firstWhere(
                    (a) => a.questionId == q.id,
                    orElse: () => const Answer(questionId: ''),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(q.text, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            answer.text ?? '-',
                            style: TextStyle(
                              color: answer.text == null ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(),
                _buildReviewForm(mission, review),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionStatusIcon(String decision) {
    switch (decision) {
      case 'pass':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'fail':
        return const Icon(Icons.cancel, color: Colors.red);
      case 'revision_required':
        return const Icon(Icons.warning, color: Colors.orange);
      default:
        return const Icon(Icons.pending, color: Colors.grey);
    }
  }

  String _getDecisionText(String decision) {
    switch (decision) {
      case 'pass':
        return 'ผ่าน';
      case 'fail':
        return 'ไม่ผ่าน';
      case 'revision_required':
        return 'แก้ไข';
      default:
        return decision;
    }
  }

  Widget _buildReviewForm(Mission mission, Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ผลการประเมิน', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            _decisionButton(mission.code, 'pass', 'ผ่าน', Colors.green, review.decision),
            const SizedBox(width: 8),
            _decisionButton(mission.code, 'revision_required', 'แก้ไข', Colors.orange, review.decision),
            const SizedBox(width: 8),
            _decisionButton(mission.code, 'fail', 'ไม่ผ่าน', Colors.red, review.decision),
          ],
        ),
        if (review.comment != null && review.comment!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('ความเห็น: ${review.comment}'),
        ]
      ],
    );
  }

  Widget _decisionButton(String missionCode, String decision, String label, Color color, String currentDecision) {
    final isSelected = currentDecision == decision;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color.withOpacity(0.1) : null,
        side: BorderSide(color: isSelected ? color : Colors.grey),
      ),
      onPressed: () => _submitReview(missionCode, decision),
      child: Text(label, style: TextStyle(color: isSelected ? color : Colors.grey)),
    );
  }

  Future<void> _submitReview(String missionCode, String decision) async {
    final commentController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันผล: ${_getDecisionText(decision)}'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(labelText: 'ความคิดเห็น (ถ้ามี)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(onboardingDetailProvider(widget.onboardingId).notifier)
                 .reviewMission(missionCode, decision, null, commentController.text);
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeEvent(String eventCode) async {
    try {
      await ref.read(onboardingDetailProvider(widget.onboardingId).notifier)
          .completeEvent(eventCode);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกเรียบร้อย')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
