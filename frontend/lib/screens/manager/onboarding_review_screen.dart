import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/onboarding.dart';
import '../../providers/onboarding_provider.dart';

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
        title: const Text('ตรวจสอบ Onboarding'),
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
                const SizedBox(height: 24),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'พนักงาน: ${instance.employeeId}', // Ideally name, but we only have ID in this model unless populated? Backed populates it?
              // In our backend controller `getOnboardingById`, we populated employeeId. 
              // But our Frontend model OnboardingInstance defines employeeId as String.
              // This is a common issue. Let's assume for now it's just ID or upgrade model later.
              // For MVP, just ID is sufficient or we rely on 'name' if dynamic.
               style: Theme.of(context).textTheme.titleLarge,
             ),
             const SizedBox(height: 8),
             Text('สถานะ: ${instance.status}'),
             Text('เริ่ม: ${instance.startDate}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionReviewCard(BuildContext context, OnboardingInstance instance, Mission mission) {
    // Find answers for this mission
    // We need to filter answers by questions belonging to this mission.
    // In templateId.questions, find those with missionCode == mission.code
    final questions = instance.templateId.questions
        .where((q) => q.missionCode == mission.code)
        .toList();
    
    // Find review
    final review = instance.reviews.firstWhere(
      (r) => r.missionCode == mission.code,
      orElse: () => const Review(missionCode: '', decision: ''),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(mission.title),
        subtitle: Text('สถานะ: ${review.decision.isEmpty ? "รอตรวจ" : review.decision}'),
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
    // Show dialog for comment
    final commentController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันผล: $decision'),
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
}
