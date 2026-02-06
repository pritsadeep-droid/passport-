import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/onboarding.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingTemplateScreen extends ConsumerStatefulWidget {
  const OnboardingTemplateScreen({super.key});

  @override
  ConsumerState<OnboardingTemplateScreen> createState() =>
      _OnboardingTemplateScreenState();
}

class _OnboardingTemplateScreenState
    extends ConsumerState<OnboardingTemplateScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(onboardingTemplateListProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templatesAsync = ref.watch(onboardingTemplateListProvider);

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
              child:
                  const Icon(Icons.rocket_launch, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('เทมเพลต Onboarding'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTemplateForm(context),
        child: const Icon(Icons.add),
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('ไม่สามารถโหลดเทมเพลตได้: $err'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(onboardingTemplateListProvider.notifier).load(),
                child: const Text('ลองใหม่'),
              ),
            ],
          ),
        ),
        data: (templates) {
          if (templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ยังไม่มีเทมเพลต Onboarding',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'กดปุ่ม + เพื่อสร้างเทมเพลตใหม่',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(onboardingTemplateListProvider.notifier).load(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                return _TemplateCard(
                  template: templates[index],
                  onTap: () => _showTemplateDetail(context, templates[index]),
                  onEdit: () =>
                      _showTemplateForm(context, template: templates[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showTemplateForm(BuildContext context, {OnboardingTemplate? template}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _TemplateFormSheet(
        template: template,
        onSave: (data) async {
          bool success;
          if (template != null) {
            success = await ref
                .read(onboardingTemplateListProvider.notifier)
                .update(template.id, data);
          } else {
            success = await ref
                .read(onboardingTemplateListProvider.notifier)
                .create(data);
          }

          if (!context.mounted) return;
          if (success) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  template != null
                      ? 'อัปเดตเทมเพลตสำเร็จ'
                      : 'สร้างเทมเพลตสำเร็จ',
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่')),
            );
          }
        },
      ),
    );
  }

  void _showTemplateDetail(BuildContext context, OnboardingTemplate template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _TemplateDetailSheet(
        template: template,
        onEditMission: (mission) => _showMissionForm(context, template, mission),
        onEditQuestion: (question) =>
            _showQuestionForm(context, template, question),
        onAddQuestion: (missionCode) =>
            _showQuestionForm(context, template, null, missionCode: missionCode),
        onAddMission: () {
          Navigator.pop(ctx);
          _showAddMissionForm(context, template);
        },
      ),
    );
  }

  void _showAddMissionForm(BuildContext context, OnboardingTemplate template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _MissionCreateSheet(
        existingCodes: template.missions.map((m) => m.code).toList(),
        onSave: (missionData) async {
          final updatedMissions = [
            ...template.missions.map((m) => {
                  'code': m.code,
                  'title': m.title,
                  'description': m.description,
                  'openOffsetDays': m.openOffsetDays,
                  'closeOffsetDays': m.closeOffsetDays,
                }),
            missionData,
          ];

          final success = await ref
              .read(onboardingTemplateListProvider.notifier)
              .update(template.id, {'missions': updatedMissions});

          if (!context.mounted) return;
          Navigator.pop(ctx);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('เพิ่มภารกิจสำเร็จ')),
            );
          }
        },
      ),
    );
  }

  void _showMissionForm(
      BuildContext context, OnboardingTemplate template, Mission mission) {
    showDialog(
      context: context,
      builder: (ctx) => _MissionEditDialog(
        mission: mission,
        onSave: (openDays, closeDays) async {
          final updatedMissions = template.missions.map((m) {
            if (m.code == mission.code) {
              return Mission(
                code: m.code,
                title: m.title,
                description: m.description,
                openOffsetDays: openDays,
                closeOffsetDays: closeDays,
              );
            }
            return m;
          }).toList();

          final success = await ref
              .read(onboardingTemplateListProvider.notifier)
              .update(template.id, {
            'missions': updatedMissions.map((m) => {
              'code': m.code,
              'title': m.title,
              'description': m.description,
              'openOffsetDays': m.openOffsetDays,
              'closeOffsetDays': m.closeOffsetDays,
            }).toList(),
          });

          if (!context.mounted) return;
          if (success) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('บันทึกสำเร็จ')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _showQuestionForm(
      BuildContext context, OnboardingTemplate template, Question? question,
      {String? missionCode}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _QuestionFormSheet(
        question: question,
        missionCode: missionCode ?? question?.missionCode ?? '',
        missions: template.missions,
        onSave: (data) async {
          List<Map<String, dynamic>> updatedQuestions;
          if (question != null) {
            // Update existing
            updatedQuestions = template.questions.map((q) {
              if (q.id == question.id) {
                return data;
              }
              return {
                '_id': q.id,
                'text': q.text,
                'type': q.type.name,
                'missionCode': q.missionCode,
                'required': q.required,
                'sortOrder': q.sortOrder,
                'options': q.options,
              };
            }).toList();
          } else {
            // Add new
            updatedQuestions = [
              ...template.questions.map((q) => {
                    '_id': q.id,
                    'text': q.text,
                    'type': q.type.name,
                    'missionCode': q.missionCode,
                    'required': q.required,
                    'sortOrder': q.sortOrder,
                    'options': q.options,
                  }),
              data,
            ];
          }

          final success = await ref
              .read(onboardingTemplateListProvider.notifier)
              .update(template.id, {'questions': updatedQuestions});

          if (!context.mounted) return;
          Navigator.pop(ctx);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  question != null ? 'อัปเดตคำถามสำเร็จ' : 'เพิ่มคำถามสำเร็จ',
                ),
              ),
            );
          }
        },
        onDelete: question != null
            ? () async {
                final updatedQuestions = template.questions
                    .where((q) => q.id != question.id)
                    .map((q) => {
                          '_id': q.id,
                          'text': q.text,
                          'type': q.type.name,
                          'missionCode': q.missionCode,
                          'required': q.required,
                          'sortOrder': q.sortOrder,
                          'options': q.options,
                        })
                    .toList();

                final success = await ref
                    .read(onboardingTemplateListProvider.notifier)
                    .update(template.id, {'questions': updatedQuestions});

                if (!context.mounted) return;
                Navigator.pop(ctx);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ลบคำถามสำเร็จ')),
                  );
                }
              }
            : null,
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final OnboardingTemplate template;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _TemplateCard({
    required this.template,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.rocket_launch,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (template.description != null)
                          Text(
                            template.description!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatChip(
                    icon: Icons.flag_outlined,
                    label: '${template.missions.length} ภารกิจ',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    icon: Icons.quiz_outlined,
                    label: '${template.questions.length} คำถาม',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    icon: Icons.event_outlined,
                    label: '${template.events.length} กิจกรรม',
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateFormSheet extends StatefulWidget {
  final OnboardingTemplate? template;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const _TemplateFormSheet({
    this.template,
    required this.onSave,
  });

  @override
  State<_TemplateFormSheet> createState() => _TemplateFormSheetState();
}

class _TemplateFormSheetState extends State<_TemplateFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.template?.description ?? '');
    _durationController = TextEditingController(
        text: (widget.template?.durationDays ?? 119).toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.template != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Text(
                      isEditing
                          ? 'แก้ไขเทมเพลต Onboarding'
                          : 'สร้างเทมเพลต Onboarding',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'ชื่อเทมเพลต *',
                            hintText: 'เช่น HAPINES Culture Passport',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'กรุณากรอกชื่อเทมเพลต';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'คำอธิบาย',
                            hintText: 'อธิบายเกี่ยวกับ Onboarding นี้',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _durationController,
                          decoration: const InputDecoration(
                            labelText: 'ระยะเวลา (วัน) *',
                            hintText: '119',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'กรุณากรอกระยะเวลา';
                            }
                            final days = int.tryParse(v);
                            if (days == null || days <= 0) {
                              return 'ระยะเวลาต้องเป็นตัวเลขมากกว่า 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _submit,
                            icon: _saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(isEditing ? Icons.save : Icons.add),
                            label: Text(
                              _saving
                                  ? 'กำลังบันทึก...'
                                  : isEditing
                                      ? 'บันทึก'
                                      : 'สร้างเทมเพลต',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final data = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      'durationDays': int.parse(_durationController.text.trim()),
    };

    await widget.onSave(data);

    if (mounted) {
      setState(() => _saving = false);
    }
  }
}

class _TemplateDetailSheet extends StatelessWidget {
  final OnboardingTemplate template;
  final void Function(Mission mission) onEditMission;
  final void Function(Question question) onEditQuestion;
  final void Function(String missionCode) onAddQuestion;
  final VoidCallback onAddMission;

  const _TemplateDetailSheet({
    required this.template,
    required this.onEditMission,
    required this.onEditQuestion,
    required this.onAddQuestion,
    required this.onAddMission,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Missions section
                  Text(
                    'ภารกิจ HAPINES',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...template.missions.map((mission) {
                    final questions = template.questions
                        .where((q) => q.missionCode == mission.code)
                        .toList();
                    return _MissionExpansionTile(
                      mission: mission,
                      questions: questions,
                      onEditMission: () => onEditMission(mission),
                      onEditQuestion: onEditQuestion,
                      onAddQuestion: () => onAddQuestion(mission.code),
                    );
                  }),

                  // Add Mission button
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.add,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        'เพิ่มภารกิจใหม่',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('สร้างภารกิจและคำถามใหม่'),
                      onTap: onAddMission,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Events section
                  if (template.events.isNotEmpty) ...[
                    Text(
                      'กิจกรรม Journey',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...template.events.map((event) => _EventCard(event: event)),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MissionExpansionTile extends StatelessWidget {
  final Mission mission;
  final List<Question> questions;
  final VoidCallback onEditMission;
  final void Function(Question question) onEditQuestion;
  final VoidCallback onAddQuestion;

  const _MissionExpansionTile({
    required this.mission,
    required this.questions,
    required this.onEditMission,
    required this.onEditQuestion,
    required this.onAddQuestion,
  });

  Color _getMissionColor(String code) {
    switch (code) {
      case 'H':
        return const Color(0xFFE53935);
      case 'A':
        return const Color(0xFFFF9800);
      case 'P':
        return const Color(0xFFFFEB3B);
      case 'I':
        return const Color(0xFF4CAF50);
      case 'N':
        return const Color(0xFF2196F3);
      case 'E':
        return const Color(0xFF3F51B5);
      case 'S':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getMissionColor(mission.code);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: Text(
            mission.code,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                mission.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            // Add question button - visible without expanding
            TextButton.icon(
              onPressed: onAddQuestion,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('เพิ่มคำถาม'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                'วันที่ ${mission.openOffsetDays}-${mission.closeOffsetDays} | ${questions.length} คำถาม',
                style: theme.textTheme.bodySmall,
              ),
            ),
            // Settings button
            InkWell(
              onTap: onEditMission,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.settings_outlined,
                  size: 18,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
        children: [
          if (questions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'ยังไม่มีคำถาม กดปุ่ม "เพิ่มคำถาม" ด้านบนเพื่อเพิ่ม',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return ListTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: color.withOpacity(0.1),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ),
              title: Text(
                question.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => onEditQuestion(question),
              ),
            );
          }),
          // Also keep add button inside for convenience
          ListTile(
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.add,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              'เพิ่มคำถาม',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            onTap: onAddQuestion,
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final JourneyEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getEventColor(event.type),
          child: Text(
            'D${event.day}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(event.titleTh ?? event.title),
        subtitle: Text(event.type.name),
      ),
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.orientation:
        return Colors.blue;
      case EventType.workshop:
        return Colors.purple;
      case EventType.training:
        return Colors.green;
      case EventType.evaluation:
        return Colors.orange;
      case EventType.feedback:
        return Colors.teal;
      case EventType.celebration:
        return Colors.pink;
      case EventType.other:
        return Colors.grey;
    }
  }
}

class _MissionEditDialog extends StatefulWidget {
  final Mission mission;
  final Future<void> Function(int openDays, int closeDays) onSave;

  const _MissionEditDialog({
    required this.mission,
    required this.onSave,
  });

  @override
  State<_MissionEditDialog> createState() => _MissionEditDialogState();
}

class _MissionEditDialogState extends State<_MissionEditDialog> {
  late final TextEditingController _openController;
  late final TextEditingController _closeController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _openController =
        TextEditingController(text: widget.mission.openOffsetDays.toString());
    _closeController =
        TextEditingController(text: widget.mission.closeOffsetDays.toString());
  }

  @override
  void dispose() {
    _openController.dispose();
    _closeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final open = int.tryParse(_openController.text) ?? 0;
    final close = int.tryParse(_closeController.text) ?? 7;

    setState(() => _saving = true);

    await widget.onSave(open, close);

    if (mounted) {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('แก้ไขกำหนดวัน - ${widget.mission.title}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _openController,
            decoration: const InputDecoration(
              labelText: 'วันเปิดภารกิจ',
              suffixText: 'วัน',
            ),
            keyboardType: TextInputType.number,
            enabled: !_saving,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _closeController,
            decoration: const InputDecoration(
              labelText: 'วันปิดภารกิจ',
              suffixText: 'วัน',
            ),
            keyboardType: TextInputType.number,
            enabled: !_saving,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('ยกเลิก'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('บันทึก'),
        ),
      ],
    );
  }
}

class _QuestionFormSheet extends StatefulWidget {
  final Question? question;
  final String missionCode;
  final List<Mission> missions;
  final Future<void> Function(Map<String, dynamic> data) onSave;
  final VoidCallback? onDelete;

  const _QuestionFormSheet({
    this.question,
    required this.missionCode,
    required this.missions,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<_QuestionFormSheet> createState() => _QuestionFormSheetState();
}

class _QuestionFormSheetState extends State<_QuestionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;
  late String _selectedMissionCode;
  late QuestionType _selectedType;
  late bool _required;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question?.text ?? '');
    _selectedMissionCode = widget.question?.missionCode ?? widget.missionCode;
    _selectedType = widget.question?.type ?? QuestionType.textLong;
    _required = widget.question?.required ?? true;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.question != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Text(
                      isEditing ? 'แก้ไขคำถาม' : 'เพิ่มคำถาม',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (widget.onDelete != null)
                      IconButton(
                        onPressed: () => _confirmDelete(context),
                        icon: Icon(Icons.delete_outline,
                            color: theme.colorScheme.error),
                      ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedMissionCode,
                          decoration: const InputDecoration(
                            labelText: 'ภารกิจ *',
                            border: OutlineInputBorder(),
                          ),
                          items: widget.missions.map((m) {
                            return DropdownMenuItem(
                              value: m.code,
                              child: Text('${m.code} - ${m.title}'),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _selectedMissionCode = v);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            labelText: 'คำถาม *',
                            hintText: 'กรอกคำถาม',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 4,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'กรุณากรอกคำถาม';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<QuestionType>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            labelText: 'ประเภทคำถาม',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: QuestionType.textLong,
                              child: Text('ข้อความยาว'),
                            ),
                            DropdownMenuItem(
                              value: QuestionType.textShort,
                              child: Text('ข้อความสั้น'),
                            ),
                            DropdownMenuItem(
                              value: QuestionType.rating,
                              child: Text('ให้คะแนน'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _selectedType = v);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('จำเป็นต้องตอบ'),
                          value: _required,
                          onChanged: (v) => setState(() => _required = v),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _submit,
                            icon: _saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(isEditing ? Icons.save : Icons.add),
                            label: Text(
                              _saving
                                  ? 'กำลังบันทึก...'
                                  : isEditing
                                      ? 'บันทึก'
                                      : 'เพิ่มคำถาม',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ลบคำถาม'),
        content: const Text('ต้องการลบคำถามนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDelete?.call();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final data = {
      if (widget.question != null) '_id': widget.question!.id,
      'text': _textController.text.trim(),
      'type': _selectedType.name,
      'missionCode': _selectedMissionCode,
      'required': _required,
      'sortOrder': widget.question?.sortOrder ?? 0,
      'options': [],
    };

    await widget.onSave(data);

    if (mounted) {
      setState(() => _saving = false);
    }
  }
}

class _MissionCreateSheet extends StatefulWidget {
  final List<String> existingCodes;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const _MissionCreateSheet({
    required this.existingCodes,
    required this.onSave,
  });

  @override
  State<_MissionCreateSheet> createState() => _MissionCreateSheetState();
}

class _MissionCreateSheetState extends State<_MissionCreateSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _openDaysController;
  late final TextEditingController _closeDaysController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _openDaysController = TextEditingController(text: '0');
    _closeDaysController = TextEditingController(text: '14');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _openDaysController.dispose();
    _closeDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Text(
                      'เพิ่มภารกิจใหม่',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            labelText: 'รหัสภารกิจ *',
                            hintText: 'เช่น H, A, P, I, N, E, S',
                            border: OutlineInputBorder(),
                            helperText: 'ตัวอักษรพิมพ์ใหญ่ 1-3 ตัว',
                          ),
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 3,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'กรุณากรอกรหัสภารกิจ';
                            }
                            final code = v.trim().toUpperCase();
                            if (widget.existingCodes.contains(code)) {
                              return 'รหัสนี้ถูกใช้แล้ว';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'ชื่อภารกิจ *',
                            hintText: 'เช่น High Energy Workstyle',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'กรุณากรอกชื่อภารกิจ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'คำอธิบาย',
                            hintText: 'อธิบายเกี่ยวกับภารกิจนี้',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _openDaysController,
                                decoration: const InputDecoration(
                                  labelText: 'วันเปิดภารกิจ *',
                                  border: OutlineInputBorder(),
                                  suffixText: 'วัน',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'กรุณากรอก';
                                  }
                                  if (int.tryParse(v) == null) {
                                    return 'ต้องเป็นตัวเลข';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _closeDaysController,
                                decoration: const InputDecoration(
                                  labelText: 'วันปิดภารกิจ *',
                                  border: OutlineInputBorder(),
                                  suffixText: 'วัน',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'กรุณากรอก';
                                  }
                                  if (int.tryParse(v) == null) {
                                    return 'ต้องเป็นตัวเลข';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ภารกิจจะเปิดให้พนักงานทำได้ตั้งแต่วันที่เริ่มงาน + วันเปิด ถึงวันเปิด + วันปิด',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _submit,
                            icon: _saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add),
                            label: Text(
                              _saving ? 'กำลังบันทึก...' : 'เพิ่มภารกิจ',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final data = {
      'code': _codeController.text.trim().toUpperCase(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      'openOffsetDays': int.parse(_openDaysController.text.trim()),
      'closeOffsetDays': int.parse(_closeDaysController.text.trim()),
    };

    await widget.onSave(data);

    if (mounted) {
      setState(() => _saving = false);
    }
  }
}
