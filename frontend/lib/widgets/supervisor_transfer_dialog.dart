import 'package:flutter/material.dart';

/// Supervisor data for selection
class SupervisorOption {
  final String id;
  final String name;
  final String email;
  final String? department;

  SupervisorOption({
    required this.id,
    required this.name,
    required this.email,
    this.department,
  });

  factory SupervisorOption.fromJson(Map<String, dynamic> json) {
    return SupervisorOption(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? json['email'] ?? '',
      email: json['email'] ?? '',
      department: json['department'],
    );
  }
}

/// Supervisor transfer dialog
class SupervisorTransferDialog extends StatefulWidget {
  /// Employee name
  final String employeeName;

  /// Current supervisor name
  final String currentSupervisorName;

  /// List of available supervisors
  final List<SupervisorOption> supervisors;

  /// Current supervisor ID to exclude
  final String currentSupervisorId;

  /// Callback when transfer is confirmed
  final void Function(String newSupervisorId, String reason) onTransfer;

  const SupervisorTransferDialog({
    super.key,
    required this.employeeName,
    required this.currentSupervisorName,
    required this.supervisors,
    required this.currentSupervisorId,
    required this.onTransfer,
  });

  @override
  State<SupervisorTransferDialog> createState() => _SupervisorTransferDialogState();
}

class _SupervisorTransferDialogState extends State<SupervisorTransferDialog> {
  String? _selectedSupervisorId;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSubmitting = false;
  List<SupervisorOption> _filteredSupervisors = [];

  @override
  void initState() {
    super.initState();
    _filteredSupervisors = widget.supervisors
        .where((s) => s.id != widget.currentSupervisorId)
        .toList();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterSupervisors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSupervisors = widget.supervisors
            .where((s) => s.id != widget.currentSupervisorId)
            .toList();
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredSupervisors = widget.supervisors
            .where((s) =>
                s.id != widget.currentSupervisorId &&
                (s.name.toLowerCase().contains(lowerQuery) ||
                    s.email.toLowerCase().contains(lowerQuery) ||
                    (s.department?.toLowerCase().contains(lowerQuery) ?? false)))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('โอนย้ายหัวหน้างาน'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current info
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'พนักงาน: ${widget.employeeName}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.supervisor_account, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'หัวหน้าปัจจุบัน: ${widget.currentSupervisorName}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาหัวหน้างานใหม่...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: _filterSupervisors,
            ),
            const SizedBox(height: 12),

            // Supervisor list
            Text(
              'เลือกหัวหน้างานใหม่',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filteredSupervisors.isEmpty
                  ? Center(
                      child: Text(
                        'ไม่พบหัวหน้างาน',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredSupervisors.length,
                      itemBuilder: (context, index) {
                        final supervisor = _filteredSupervisors[index];
                        final isSelected = _selectedSupervisorId == supervisor.id;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor:
                              theme.colorScheme.primaryContainer.withOpacity(0.3),
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              supervisor.name[0].toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          title: Text(supervisor.name),
                          subtitle: Text(
                            supervisor.department ?? supervisor.email,
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedSupervisorId = supervisor.id;
                            });
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // Reason
            Text(
              'เหตุผลในการโอนย้าย (จำเป็น)',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'ระบุเหตุผล...',
                border: OutlineInputBorder(),
              ),
            ),
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
              : const Text('ยืนยันการโอนย้าย'),
        ),
      ],
    );
  }

  bool _canSubmit() {
    if (_selectedSupervisorId == null) return false;
    if (_reasonController.text.trim().isEmpty) return false;
    if (_isSubmitting) return false;
    return true;
  }

  void _submit() {
    if (!_canSubmit()) return;

    setState(() {
      _isSubmitting = true;
    });

    widget.onTransfer(_selectedSupervisorId!, _reasonController.text.trim());
  }
}

/// Show supervisor transfer dialog
Future<void> showSupervisorTransferDialog({
  required BuildContext context,
  required String employeeName,
  required String currentSupervisorName,
  required String currentSupervisorId,
  required List<SupervisorOption> supervisors,
  required void Function(String newSupervisorId, String reason) onTransfer,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SupervisorTransferDialog(
      employeeName: employeeName,
      currentSupervisorName: currentSupervisorName,
      currentSupervisorId: currentSupervisorId,
      supervisors: supervisors,
      onTransfer: onTransfer,
    ),
  );
}

/// Extension probation dialog
class ExtendProbationDialog extends StatefulWidget {
  /// Employee name
  final String employeeName;

  /// Current end date
  final DateTime currentEndDate;

  /// Callback when extension is confirmed
  final void Function(int additionalDays, String reason) onExtend;

  const ExtendProbationDialog({
    super.key,
    required this.employeeName,
    required this.currentEndDate,
    required this.onExtend,
  });

  @override
  State<ExtendProbationDialog> createState() => _ExtendProbationDialogState();
}

class _ExtendProbationDialogState extends State<ExtendProbationDialog> {
  int _selectedDays = 30;
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
    final newEndDate = widget.currentEndDate.add(Duration(days: _selectedDays));

    return AlertDialog(
      title: const Text('ขยายเวลาทดลองงาน'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('สิ้นสุดปัจจุบัน:'),
                        Text(
                          _formatDate(widget.currentEndDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('สิ้นสุดใหม่:'),
                        Text(
                          _formatDate(newEndDate),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Days selection
            Text(
              'จำนวนวันที่ต้องการขยาย',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [15, 30, 45, 60, 90].map((days) {
                final isSelected = _selectedDays == days;
                return ChoiceChip(
                  label: Text('$days วัน'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedDays = days;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Custom days
            Text(
              'หรือระบุจำนวนวัน',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '1-90 วัน',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                final days = int.tryParse(value);
                if (days != null && days >= 1 && days <= 90) {
                  setState(() {
                    _selectedDays = days;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Reason
            Text(
              'เหตุผลในการขยายเวลา (จำเป็น)',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'ระบุเหตุผล...',
                border: OutlineInputBorder(),
              ),
            ),
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
              : const Text('ยืนยันการขยายเวลา'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _canSubmit() {
    if (_reasonController.text.trim().isEmpty) return false;
    if (_isSubmitting) return false;
    if (_selectedDays < 1 || _selectedDays > 90) return false;
    return true;
  }

  void _submit() {
    if (!_canSubmit()) return;

    setState(() {
      _isSubmitting = true;
    });

    widget.onExtend(_selectedDays, _reasonController.text.trim());
  }
}

/// Show extend probation dialog
Future<void> showExtendProbationDialog({
  required BuildContext context,
  required String employeeName,
  required DateTime currentEndDate,
  required void Function(int additionalDays, String reason) onExtend,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ExtendProbationDialog(
      employeeName: employeeName,
      currentEndDate: currentEndDate,
      onExtend: onExtend,
    ),
  );
}
