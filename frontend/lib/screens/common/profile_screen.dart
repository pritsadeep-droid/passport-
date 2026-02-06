import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../widgets/custom_app_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _departmentController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _departmentController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _initControllers(User user) {
    if (_nameController.text.isEmpty) {
      _nameController.text = user.name;
      _departmentController.text = user.department;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'โปรไฟล์',
          logoIcon: Icons.person,
          showBackButton: true,
        ),
        body: const Center(child: Text('กรุณาเข้าสู่ระบบ')),
      );
    }

    _initControllers(user);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'โปรไฟล์',
        logoIcon: Icons.person,
        showBackButton: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'แก้ไข',
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() => _isEditing = false);
                _nameController.text = user.name;
                _departmentController.text = user.department;
              },
              tooltip: 'ยกเลิก',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            _buildAvatarSection(user),
            const SizedBox(height: 24),

            // User Info Card
            _buildInfoCard(user),
            const SizedBox(height: 16),

            // Account Info Card
            _buildAccountCard(user),
            const SizedBox(height: 24),

            // Action Buttons
            if (_isEditing) _buildSaveButton(),

            const SizedBox(height: 16),

            // Change Password Button
            _buildChangePasswordButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getRoleColor(user.role).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            user.role.displayName,
            style: TextStyle(
              color: _getRoleColor(user.role),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลส่วนตัว',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.badge,
              label: 'รหัสพนักงาน',
              value: user.employeeId,
              editable: false,
            ),
            _buildInfoRow(
              icon: Icons.person,
              label: 'ชื่อ-นามสกุล',
              value: user.name,
              editable: _isEditing,
              controller: _nameController,
            ),
            _buildInfoRow(
              icon: Icons.business,
              label: 'แผนก',
              value: user.department,
              editable: _isEditing,
              controller: _departmentController,
            ),
            if (user.position != null)
              _buildInfoRow(
                icon: Icons.work,
                label: 'ตำแหน่ง',
                value: user.position!,
                editable: false,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลบัญชี',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.email,
              label: 'อีเมล',
              value: user.email,
              editable: false,
            ),
            _buildInfoRow(
              icon: Icons.verified_user,
              label: 'สถานะบัญชี',
              value: user.isActive ? 'ใช้งานอยู่' : 'ถูกระงับ',
              editable: false,
              valueColor: user.isActive ? Colors.green : Colors.red,
            ),
            if (user.createdAt != null)
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'วันที่สร้างบัญชี',
                value: _formatDate(user.createdAt!),
                editable: false,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool editable,
    TextEditingController? controller,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                if (editable && controller != null)
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                else
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: valueColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveProfile,
        icon: const Icon(Icons.save),
        label: const Text('บันทึกการเปลี่ยนแปลง'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showChangePasswordDialog,
        icon: const Icon(Icons.lock),
        label: const Text('เปลี่ยนรหัสผ่าน'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    // TODO: Implement profile update API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() => _isEditing = false);
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เปลี่ยนรหัสผ่าน'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'รหัสผ่านปัจจุบัน',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'รหัสผ่านใหม่',
                prefixIcon: Icon(Icons.lock),
                helperText: 'อย่างน้อย 8 ตัวอักษร',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'ยืนยันรหัสผ่านใหม่',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password change API call
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('รหัสผ่านไม่ตรงกัน'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('เปลี่ยนรหัสผ่านสำเร็จ'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('เปลี่ยนรหัสผ่าน'),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.employee:
        return Colors.blue;
      case UserRole.supervisor:
        return Colors.orange;
      case UserRole.hrAdmin:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
