import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  static const Map<String, Color> _missionColors = {
    'H': Color(0xFFE53935),
    'A': Color(0xFFFF9800),
    'P': Color(0xFF4CAF50),
    'I': Color(0xFF2196F3),
    'N': Color(0xFF9C27B0),
    'E': Color(0xFF00BCD4),
    'S': Color(0xFFFF5722),
  };

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

          final review = instance.reviews.firstWhere(
            (r) => r.missionCode == widget.missionCode,
            orElse: () => const Review(missionCode: '', decision: ''),
          );
          final isPassed = review.decision == 'pass';
          final missionColor = _missionColors[widget.missionCode] ?? Colors.grey;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission header with colored circle
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPassed ? missionColor : missionColor.withOpacity(0.1),
                          border: Border.all(color: missionColor, width: 3),
                        ),
                        child: Center(
                          child: isPassed
                              ? const Icon(Icons.check, size: 40, color: Colors.white)
                              : Text(
                                  mission.code,
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: missionColor,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mission.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isPassed) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, color: Colors.green.shade600, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'ผ่านแล้ว',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (mission.description != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: missionColor.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: missionColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              mission.description!,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ...questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return _buildQuestionCard(question, instance, index + 1, questions.length);
                }),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(Question question, OnboardingInstance instance, int number, int total) {
    final existingAnswer = instance.answers.firstWhere(
      (a) => a.questionId == question.id,
      orElse: () => const Answer(questionId: ''),
    );

    if (!_controllers.containsKey(question.id)) {
      _controllers[question.id] = TextEditingController(text: existingAnswer.text);
    }

    final saved = existingAnswer.questionId.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$number/$total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                if (question.required) ...[
                  const SizedBox(width: 8),
                  const Text(
                    '* จำเป็น',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
                const Spacer(),
                if (saved)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade400, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'บันทึกแล้ว',
                        style: TextStyle(color: Colors.green.shade400, fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 12),
            _buildInput(question, _controllers[question.id]!),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : () => _saveAnswer(question.id),
                icon: const Icon(Icons.save, size: 18),
                label: Text(saved ? 'อัปเดต' : 'บันทึก'),
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
