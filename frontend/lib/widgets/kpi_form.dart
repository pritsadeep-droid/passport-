import 'package:flutter/material.dart';
import '../models/kpi.dart';
import '../utils/theme.dart';

/// Form for creating or editing a single KPI
class KpiForm extends StatefulWidget {
  final Kpi? initialKpi;
  final ValueChanged<CreateKpiRequest> onSave;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;
  final bool showDelete;
  final bool isEditing;

  const KpiForm({
    super.key,
    this.initialKpi,
    required this.onSave,
    this.onCancel,
    this.onDelete,
    this.showDelete = false,
    this.isEditing = false,
  });

  @override
  State<KpiForm> createState() => _KpiFormState();
}

class _KpiFormState extends State<KpiForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _criteriaController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialKpi?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialKpi?.description ?? '',
    );
    _criteriaController = TextEditingController(
      text: widget.initialKpi?.criteria ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _criteriaController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        CreateKpiRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          criteria: _criteriaController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title field
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'ชื่อเป้าหมาย *',
              hintText: 'เช่น เรียนรู้ระบบการทำงาน',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            maxLength: 200,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกชื่อเป้าหมาย';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Description field
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'รายละเอียด *',
              hintText: 'อธิบายรายละเอียดของเป้าหมายนี้',
              prefixIcon: Icon(Icons.description_outlined),
              alignLabelWithHint: true,
            ),
            maxLength: 1000,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกรายละเอียด';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Criteria field
          TextFormField(
            controller: _criteriaController,
            decoration: const InputDecoration(
              labelText: 'เกณฑ์วัดผล *',
              hintText: 'เช่น สามารถใช้งานระบบได้อย่างคล่องแคล่ว',
              prefixIcon: Icon(Icons.check_circle_outline),
              alignLabelWithHint: true,
            ),
            maxLength: 500,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกเกณฑ์วัดผล';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.showDelete && widget.onDelete != null)
                TextButton.icon(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  label: const Text(
                    'ลบ',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              const Spacer(),
              if (widget.onCancel != null)
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('ยกเลิก'),
                ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: _handleSave,
                child: Text(widget.isEditing ? 'บันทึก' : 'เพิ่ม'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for adding/editing KPI
class KpiFormBottomSheet extends StatelessWidget {
  final Kpi? initialKpi;
  final ValueChanged<CreateKpiRequest> onSave;
  final VoidCallback? onDelete;
  final bool showDelete;

  const KpiFormBottomSheet({
    super.key,
    this.initialKpi,
    required this.onSave,
    this.onDelete,
    this.showDelete = false,
  });

  static Future<CreateKpiRequest?> show(
    BuildContext context, {
    Kpi? initialKpi,
    VoidCallback? onDelete,
    bool showDelete = false,
  }) async {
    return showModalBottomSheet<CreateKpiRequest>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: KpiFormBottomSheet(
          initialKpi: initialKpi,
          onSave: (kpi) => Navigator.pop(context, kpi),
          onDelete: onDelete != null
              ? () {
                  onDelete();
                  Navigator.pop(context);
                }
              : null,
          showDelete: showDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                initialKpi != null ? Icons.edit : Icons.add_circle_outline,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                initialKpi != null ? 'แก้ไข KPI' : 'เพิ่ม KPI',
                style: AppTextStyles.headline3,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Form
          KpiForm(
            initialKpi: initialKpi,
            onSave: onSave,
            onCancel: () => Navigator.pop(context),
            onDelete: onDelete,
            showDelete: showDelete,
            isEditing: initialKpi != null,
          ),
        ],
      ),
    );
  }
}

/// Dialog for confirming KPI deletion
class DeleteKpiDialog extends StatelessWidget {
  final Kpi kpi;

  const DeleteKpiDialog({
    super.key,
    required this.kpi,
  });

  static Future<bool?> show(BuildContext context, Kpi kpi) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteKpiDialog(kpi: kpi),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ยืนยันการลบ'),
      content: Text('คุณต้องการลบ KPI "${kpi.title}" ใช่หรือไม่?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          child: const Text('ลบ'),
        ),
      ],
    );
  }
}
