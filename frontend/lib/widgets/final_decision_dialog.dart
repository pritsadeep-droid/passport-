import 'package:flutter/material.dart';

/// Final decision dialog for HR to approve/reject probation
class FinalDecisionDialog extends StatefulWidget {
  /// Employee name for display
  final String employeeName;

  /// Current milestone stats
  final int passedMilestones;
  final int failedMilestones;
  final int totalMilestones;

  /// Average score
  final double? averageScore;

  /// Callback when decision is made
  final void Function(String decision, String? reason) onDecision;

  const FinalDecisionDialog({
    super.key,
    required this.employeeName,
    required this.passedMilestones,
    required this.failedMilestones,
    required this.totalMilestones,
    this.averageScore,
    required this.onDecision,
  });

  @override
  State<FinalDecisionDialog> createState() => _FinalDecisionDialogState();
}

class _FinalDecisionDialogState extends State<FinalDecisionDialog> {
  String? _selectedDecision;
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPass = widget.passedMilestones >= widget.failedMilestones &&
        (widget.passedMilestones + widget.failedMilestones) == widget.totalMilestones;

    return AlertDialog(
      title: const Text('ผลการตัดสินใจทดลองงาน'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee info
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.employeeName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      'Milestone ผ่าน',
                      '${widget.passedMilestones}/${widget.totalMilestones}',
                      Colors.green,
                    ),
                    const SizedBox(height: 4),
                    _buildStatRow(
                      'Milestone ไม่ผ่าน',
                      '${widget.failedMilestones}/${widget.totalMilestones}',
                      theme.colorScheme.error,
                    ),
                    if (widget.averageScore != null) ...[
                      const SizedBox(height: 4),
                      _buildStatRow(
                        'คะแนนเฉลี่ย',
                        widget.averageScore!.toStringAsFixed(2),
                        widget.averageScore! >= 3.0
                            ? Colors.green
                            : theme.colorScheme.error,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Decision options
            Text(
              'ผลการตัดสินใจ',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),

            // Pass option
            _buildDecisionOption(
              theme: theme,
              value: 'passed',
              title: 'ผ่านทดลองงาน',
              subtitle: 'พนักงานผ่านการทดลองงาน กลายเป็นพนักงานประจำ',
              icon: Icons.check_circle,
              color: Colors.green,
              enabled: canPass,
              disabledReason: canPass
                  ? null
                  : 'ต้องมี Milestone ครบและผ่านมากกว่าไม่ผ่าน',
            ),
            const SizedBox(height: 8),

            // Fail option
            _buildDecisionOption(
              theme: theme,
              value: 'failed',
              title: 'ไม่ผ่านทดลองงาน',
              subtitle: 'พนักงานไม่ผ่านการทดลองงาน',
              icon: Icons.cancel,
              color: theme.colorScheme.error,
              enabled: true,
            ),
            const SizedBox(height: 16),

            // Reason
            Text(
              'หมายเหตุ ${_selectedDecision == 'failed' ? '(จำเป็น)' : '(ถ้ามี)'}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _selectedDecision == 'failed'
                    ? 'กรุณาระบุเหตุผล...'
                    : 'หมายเหตุเพิ่มเติม (ถ้ามี)...',
                border: const OutlineInputBorder(),
              ),
            ),

            // Warning for fail
            if (_selectedDecision == 'failed') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'การตัดสินใจนี้จะไม่สามารถย้อนกลับได้ กรุณาตรวจสอบให้แน่ใจ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก'),
        ),
        FilledButton(
          onPressed: _canSubmit() ? _submit : null,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('ยืนยัน'),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDecisionOption({
    required ThemeData theme,
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool enabled,
    String? disabledReason,
  }) {
    final isSelected = _selectedDecision == value;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: enabled
            ? () {
                setState(() {
                  _selectedDecision = value;
                });
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? color : theme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? color.withOpacity(0.1) : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? color : theme.iconTheme.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 18, color: color),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isSelected ? color : null,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      enabled ? subtitle : disabledReason ?? subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: !enabled ? theme.colorScheme.error : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSubmit() {
    if (_selectedDecision == null) return false;
    if (_isSubmitting) return false;
    if (_selectedDecision == 'failed' && _reasonController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void _submit() {
    if (!_canSubmit()) return;

    setState(() {
      _isSubmitting = true;
    });

    widget.onDecision(
      _selectedDecision!,
      _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim(),
    );
  }
}

/// Show final decision dialog
Future<void> showFinalDecisionDialog({
  required BuildContext context,
  required String employeeName,
  required int passedMilestones,
  required int failedMilestones,
  required int totalMilestones,
  double? averageScore,
  required void Function(String decision, String? reason) onDecision,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => FinalDecisionDialog(
      employeeName: employeeName,
      passedMilestones: passedMilestones,
      failedMilestones: failedMilestones,
      totalMilestones: totalMilestones,
      averageScore: averageScore,
      onDecision: onDecision,
    ),
  );
}
