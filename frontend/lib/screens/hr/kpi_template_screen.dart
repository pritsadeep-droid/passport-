import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/kpi_template.dart';
import '../../providers/kpi_template_provider.dart';

class KpiTemplateScreen extends ConsumerStatefulWidget {
  const KpiTemplateScreen({super.key});

  @override
  ConsumerState<KpiTemplateScreen> createState() => _KpiTemplateScreenState();
}

class _KpiTemplateScreenState extends ConsumerState<KpiTemplateScreen> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(kpiTemplateListProvider.notifier).load();
    });
  }

  void _loadWithCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    ref.read(kpiTemplateListProvider.notifier).load(category: category);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templatesAsync = ref.watch(kpiTemplateListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('เทมเพลต KPI'),
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
                    ref.read(kpiTemplateListProvider.notifier).load(),
                child: const Text('ลองใหม่'),
              ),
            ],
          ),
        ),
        data: (templates) {
          final categories = _extractCategories(templates);

          return Column(
            children: [
              // Category filter chips
              if (categories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('ทั้งหมด'),
                        selected: _selectedCategory == null,
                        onSelected: (_) => _loadWithCategory(null),
                      ),
                      const SizedBox(width: 8),
                      ...categories.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat,
                            onSelected: (_) => _loadWithCategory(
                              _selectedCategory == cat ? null : cat,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              // Template list
              Expanded(
                child: templates.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 64,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ยังไม่มีเทมเพลต KPI',
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
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref
                            .read(kpiTemplateListProvider.notifier)
                            .load(category: _selectedCategory),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                          itemCount: templates.length,
                          itemBuilder: (context, index) {
                            return _TemplateCard(
                              template: templates[index],
                              onEdit: () => _showTemplateForm(
                                context,
                                template: templates[index],
                              ),
                              onDelete: () =>
                                  _confirmDelete(context, templates[index]),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<String> _extractCategories(List<KpiTemplate> templates) {
    final cats = <String>{};
    for (final t in templates) {
      if (t.category != null && t.category!.isNotEmpty) {
        cats.add(t.category!);
      }
    }
    return cats.toList()..sort();
  }

  void _showTemplateForm(BuildContext context, {KpiTemplate? template}) {
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
                .read(kpiTemplateListProvider.notifier)
                .update(template.id, data);
          } else {
            success =
                await ref.read(kpiTemplateListProvider.notifier).create(data);
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

  void _confirmDelete(BuildContext context, KpiTemplate template) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ลบเทมเพลต'),
        content: Text('ต้องการลบเทมเพลต "${template.title}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(kpiTemplateListProvider.notifier)
                  .delete(template.id);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'ลบเทมเพลตสำเร็จ' : 'ไม่สามารถลบได้ กรุณาลองใหม่',
                  ),
                ),
              );
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
}

class _TemplateCard extends StatelessWidget {
  final KpiTemplate template;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TemplateCard({
    required this.template,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      template.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('แก้ไข'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 20, color: theme.colorScheme.error),
                            const SizedBox(width: 8),
                            Text('ลบ',
                                style:
                                    TextStyle(color: theme.colorScheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                template.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.checklist,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      template.criteria,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (template.category != null && template.category!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    template.category!,
                    style: theme.textTheme.labelSmall,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateFormSheet extends StatefulWidget {
  final KpiTemplate? template;
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
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _criteriaController;
  late final TextEditingController _categoryController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.template?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.template?.description ?? '');
    _criteriaController =
        TextEditingController(text: widget.template?.criteria ?? '');
    _categoryController =
        TextEditingController(text: widget.template?.category ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _criteriaController.dispose();
    _categoryController.dispose();
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
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Text(
                      isEditing ? 'แก้ไขเทมเพลต KPI' : 'สร้างเทมเพลต KPI',
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

              // Form
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
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'ชื่อเทมเพลต *',
                            hintText: 'เช่น ยอมรับกฎระเบียบบริษัท',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 200,
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
                            labelText: 'รายละเอียด *',
                            hintText: 'อธิบายรายละเอียดของ KPI',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                          maxLength: 1000,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'กรุณากรอกรายละเอียด';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _criteriaController,
                          decoration: const InputDecoration(
                            labelText: 'เกณฑ์การวัดผล *',
                            hintText: 'เช่น ผ่านการทดสอบ 80% ขึ้นไป',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 2,
                          maxLength: 500,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'กรุณากรอกเกณฑ์การวัดผล';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _categoryController,
                          decoration: const InputDecoration(
                            labelText: 'หมวดหมู่',
                            hintText: 'เช่น ทั่วไป, ฝ่ายขาย',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 100,
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
                        const SizedBox(height: 16),
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
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'criteria': _criteriaController.text.trim(),
      'category': _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
    };

    await widget.onSave(data);

    if (mounted) {
      setState(() => _saving = false);
    }
  }
}
