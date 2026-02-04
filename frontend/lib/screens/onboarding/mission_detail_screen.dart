import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/onboarding.dart';
import '../../providers/onboarding_provider.dart';

class MissionDetailScreen extends ConsumerStatefulWidget {
  final String missionCode;

  const MissionDetailScreen({
    super.key,
    required this.missionCode,
  });

  @override
  ConsumerState<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends ConsumerState<MissionDetailScreen> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myOnboardingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ภารกิจ ${widget.missionCode}'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (instance) {
          if (instance == null) return const Center(child: Text('Not found'));

          final template = instance.templateId;
          final mission = template.missions.firstWhere(
            (m) => m.code == widget.missionCode,
            orElse: () => const Mission(code: '', title: 'Unknown'),
          );

          if (mission.code.isEmpty) return const Center(child: Text('Mission not found'));

          final questions = template.questions
              .where((q) => q.missionCode == widget.missionCode)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (mission.description != null) ...[
                  const SizedBox(height: 8),
                  Text(mission.description!),
                ],
                const Divider(height: 32),
                ...questions.map((q) => _buildQuestionCard(q, instance)),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(Question question, OnboardingInstance instance) {
    // Find existing answer
    final existingAnswer = instance.answers.firstWhere(
      (a) => a.questionId == question.id,
      orElse: () => const Answer(questionId: ''), // dummy
    );

    // Init controller if needed
    if (!_controllers.containsKey(question.id)) {
      _controllers[question.id] = TextEditingController(text: existingAnswer.text);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (question.required)
              const Text(
                '* จำเป็น',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 12),
            _buildInput(question, _controllers[question.id]!),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: isSaved(question.id, instance) 
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.green, size: 16),
                        Text(' บันทึกแล้ว', style: TextStyle(color: Colors.green)),
                      ],
                    )
                  : FilledButton(
                      onPressed: () => _saveAnswer(question.id),
                      child: const Text('บันทึก'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(Question question, TextEditingController controller) {
    switch (question.type) {
      case QuestionType.textLong:
        return TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'พิมพ์คำตอบของคุณที่นี่...',
          ),
        );
      case QuestionType.textShort:
        return TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'คำตอบสั้นๆ...',
          ),
        );
      // For MVP, handling other types as text or skipping
      default:
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Unsupported type: ${question.type}',
          ),
        );
    }
  }

  bool isSaved(String questionId, OnboardingInstance instance) {
     final existingAnswer = instance.answers.firstWhere(
      (a) => a.questionId == questionId,
      orElse: () => const Answer(questionId: ''),
    );
    return existingAnswer.questionId.isNotEmpty; // Naive check
  }

  Future<void> _saveAnswer(String questionId) async {
    final text = _controllers[questionId]?.text;
    if (text == null || text.trim().isEmpty) return;

    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(myOnboardingProvider.notifier).submitAnswer(questionId, text);
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
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
