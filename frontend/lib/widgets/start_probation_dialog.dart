import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../providers/user_provider.dart';

class StartProbationDialog extends ConsumerStatefulWidget {
  final String employeeName;
  final Function(String supervisorId, DateTime startDate, int probationDays) onStart;

  const StartProbationDialog({
    super.key,
    required this.employeeName,
    required this.onStart,
  });

  @override
  ConsumerState<StartProbationDialog> createState() => _StartProbationDialogState();
}

class _StartProbationDialogState extends ConsumerState<StartProbationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _probationDaysController = TextEditingController(text: '90');
  
  String? _selectedSupervisorId;
  DateTime _startDate = DateTime.now();
  List<User> _supervisors = [];
  bool _isLoadingSupervisors = false;

  @override
  void initState() {
    super.initState();
    _loadSupervisors();
  }

  @override
  void dispose() {
    _probationDaysController.dispose();
    super.dispose();
  }

  Future<void> _loadSupervisors() async {
    setState(() {
      _isLoadingSupervisors = true;
    });

    try {
      // In a real app, we might want a specific provider/method for getting active supervisors
      // For now, let's use UserService directly or through a provider if available
      // Assuming userServiceProvider exists and has getAllUsers or similar.
      // But wait, UserService.getAllUsers allows filtering by role.
      final userService = ref.read(userServiceProvider);
      final response = await userService.getAllUsers(
        limit: 100, // Reasonable limit for dropdown
        role: 'supervisor', // Filter for supervisors
      );
      
      // Also fetch HR admins as they can be supervisors too
      final hrResponse = await userService.getAllUsers(
        limit: 100,
        role: 'hr_admin',
      );

      if (mounted) {
        setState(() {
          _supervisors = [...response.data, ...hrResponse.data];
          _isLoadingSupervisors = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSupervisors = false;
        });
        // Error handling?
      }
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSupervisorId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกหัวหน้างาน')),
        );
        return;
      }
      
      widget.onStart(
        _selectedSupervisorId!,
        _startDate,
        int.parse(_probationDaysController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('เริ่มการทดลองงาน'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'พนักงาน: ${widget.employeeName}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedSupervisorId,
                decoration: const InputDecoration(
                  labelText: 'หัวหน้างาน',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.supervisor_account),
                ),
                items: _supervisors.map((supervisor) {
                  return DropdownMenuItem(
                    value: supervisor.id,
                    child: Text(supervisor.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSupervisorId = value;
                  });
                },
                validator: (value) => value == null ? 'กรุณาเลือกหัวหน้างาน' : null,
                hint: _isLoadingSupervisors 
                    ? const Text('กำลังโหลด...') 
                    : const Text('เลือกหัวหน้างาน'),
              ),
              const SizedBox(height: 16),
              
              InkWell(
                onTap: () => _selectStartDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'วันที่เริ่มงาน',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _probationDaysController,
                decoration: const InputDecoration(
                  labelText: 'ระยะเวลาทดลองงาน (วัน)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาระบุจำนวนวัน';
                  }
                  final days = int.tryParse(value);
                  if (days == null || days <= 0) {
                    return 'จำนวนวันต้องมากกว่า 0';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('ยืนยัน'),
        ),
      ],
    );
  }
}

void showStartProbationDialog({
  required BuildContext context,
  required String employeeName,
  required Function(String supervisorId, DateTime startDate, int probationDays) onStart,
}) {
  showDialog(
    context: context,
    builder: (context) => StartProbationDialog(
      employeeName: employeeName,
      onStart: onStart,
    ),
  );
}
