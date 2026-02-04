import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../services/settings_service.dart';

class MilestoneSettingsScreen extends ConsumerStatefulWidget {
  const MilestoneSettingsScreen({super.key});

  @override
  ConsumerState<MilestoneSettingsScreen> createState() =>
      _MilestoneSettingsScreenState();
}

class _MilestoneSettingsScreenState
    extends ConsumerState<MilestoneSettingsScreen> {
  MilestoneSettingsData? _draft;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(milestoneSettingsProvider.notifier).loadSettings();
    });
  }

  void _initDraft(MilestoneSettingsData source) {
    _draft ??= MilestoneSettingsData(
      defaultProbationDays: source.defaultProbationDays,
      probationDayOptions: List<int>.from(source.probationDayOptions),
      milestoneDays: source.milestoneDays.map(
        (key, value) => MapEntry(key, List<int>.from(value)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(milestoneSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า Milestone'),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('ไม่สามารถโหลดการตั้งค่าได้: $err'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(milestoneSettingsProvider.notifier).loadSettings(),
                child: const Text('ลองใหม่'),
              ),
            ],
          ),
        ),
        data: (settings) {
          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }
          _initDraft(settings);
          final draft = _draft!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Default probation days dropdown
                Text(
                  'ระยะเวลาทดลองงานเริ่มต้น',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: draft.probationDayOptions
                          .contains(draft.defaultProbationDays)
                      ? draft.defaultProbationDays
                      : draft.probationDayOptions.first,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  items: draft.probationDayOptions.map((days) {
                    return DropdownMenuItem<int>(
                      value: days,
                      child: Text('$days วัน'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _draft = draft.copyWith(defaultProbationDays: value);
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),

                // Probation day options
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ตัวเลือกระยะเวลาทดลองงาน',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'เพิ่มตัวเลือก',
                      onPressed: () => _showAddProbationDaysDialog(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: draft.probationDayOptions.map((days) {
                    return Chip(
                      label: Text('$days วัน'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: draft.probationDayOptions.length > 1
                          ? () => _removeProbationOption(days)
                          : null,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Milestone days per probation duration
                Text(
                  'วัน Milestone สำหรับแต่ละระยะเวลา',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                ...draft.probationDayOptions.map((probDays) {
                  final key = probDays.toString();
                  final milestones = draft.milestoneDays[key] ?? [];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flag_outlined,
                                  color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'ทดลองงาน $probDays วัน',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ...milestones.map((day) {
                                return Chip(
                                  label: Text('วันที่ $day'),
                                  deleteIcon:
                                      const Icon(Icons.close, size: 18),
                                  onDeleted: milestones.length > 1
                                      ? () =>
                                          _removeMilestoneDay(key, day)
                                      : null,
                                );
                              }),
                              ActionChip(
                                avatar: const Icon(Icons.add, size: 18),
                                label: const Text('เพิ่ม'),
                                onPressed: () =>
                                    _showAddMilestoneDayDialog(key),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_saving ? 'กำลังบันทึก...' : 'บันทึก'),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _removeProbationOption(int days) {
    final draft = _draft!;
    final newOptions =
        draft.probationDayOptions.where((d) => d != days).toList();
    final newMilestones = Map<String, List<int>>.from(draft.milestoneDays)
      ..remove(days.toString());
    final newDefault = newOptions.contains(draft.defaultProbationDays)
        ? draft.defaultProbationDays
        : newOptions.first;
    setState(() {
      _draft = draft.copyWith(
        probationDayOptions: newOptions,
        milestoneDays: newMilestones,
        defaultProbationDays: newDefault,
      );
    });
  }

  void _removeMilestoneDay(String key, int day) {
    final draft = _draft!;
    final newMilestones = Map<String, List<int>>.from(draft.milestoneDays);
    newMilestones[key] =
        (newMilestones[key] ?? []).where((d) => d != day).toList();
    setState(() {
      _draft = draft.copyWith(milestoneDays: newMilestones);
    });
  }

  void _showAddProbationDaysDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('เพิ่มระยะเวลาทดลองงาน'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'จำนวนวัน',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(ctx);
                _addProbationOption(value);
              }
            },
            child: const Text('เพิ่ม'),
          ),
        ],
      ),
    );
  }

  void _addProbationOption(int days) {
    final draft = _draft!;
    if (draft.probationDayOptions.contains(days)) return;
    final newOptions = [...draft.probationDayOptions, days]..sort();
    final newMilestones = Map<String, List<int>>.from(draft.milestoneDays);
    newMilestones.putIfAbsent(days.toString(), () => [days]);
    setState(() {
      _draft = draft.copyWith(
        probationDayOptions: newOptions,
        milestoneDays: newMilestones,
      );
    });
  }

  void _showAddMilestoneDayDialog(String key) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('เพิ่มวัน Milestone'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'วันที่',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(ctx);
                _addMilestoneDay(key, value);
              }
            },
            child: const Text('เพิ่ม'),
          ),
        ],
      ),
    );
  }

  void _addMilestoneDay(String key, int day) {
    final draft = _draft!;
    final current = draft.milestoneDays[key] ?? [];
    if (current.contains(day)) return;
    final newMilestones = Map<String, List<int>>.from(draft.milestoneDays);
    newMilestones[key] = [...current, day]..sort();
    setState(() {
      _draft = draft.copyWith(milestoneDays: newMilestones);
    });
  }

  Future<void> _save() async {
    if (_draft == null) return;
    setState(() => _saving = true);

    final success = await ref
        .read(milestoneSettingsProvider.notifier)
        .updateSettings(_draft!);

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      // Reset draft so it reinitializes from the new server data
      _draft = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกสำเร็จ')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถบันทึกได้ กรุณาลองใหม่')),
      );
    }
  }
}
