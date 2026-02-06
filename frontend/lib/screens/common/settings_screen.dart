import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../widgets/custom_app_bar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String _language = 'th';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'ตั้งค่า',
        logoIcon: Icons.settings,
        showBackButton: true,
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('บัญชี'),
          _buildListTile(
            icon: Icons.person,
            title: 'โปรไฟล์',
            subtitle: user?.name ?? 'ดูและแก้ไขข้อมูลส่วนตัว',
            onTap: () => context.push('/profile'),
          ),
          _buildListTile(
            icon: Icons.lock,
            title: 'รหัสผ่าน',
            subtitle: 'เปลี่ยนรหัสผ่าน',
            onTap: () => _showChangePasswordDialog(),
          ),

          const Divider(),

          // Notifications Section
          _buildSectionHeader('การแจ้งเตือน'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('เปิดการแจ้งเตือน'),
            subtitle: const Text('รับการแจ้งเตือนทั้งหมด'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          if (_notificationsEnabled) ...[
            SwitchListTile(
              secondary: const Icon(Icons.email),
              title: const Text('แจ้งเตือนทางอีเมล'),
              subtitle: const Text('รับการแจ้งเตือนทางอีเมล'),
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.phone_android),
              title: const Text('Push Notification'),
              subtitle: const Text('รับการแจ้งเตือนบนอุปกรณ์'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
              },
            ),
          ],

          const Divider(),

          // Preferences Section
          _buildSectionHeader('การตั้งค่าทั่วไป'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('ภาษา'),
            subtitle: Text(_language == 'th' ? 'ไทย' : 'English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(),
          ),

          const Divider(),

          // About Section
          _buildSectionHeader('เกี่ยวกับ'),
          _buildListTile(
            icon: Icons.info,
            title: 'เกี่ยวกับแอป',
            subtitle: 'เวอร์ชัน 1.0.0',
            onTap: () => _showAboutDialog(),
          ),
          _buildListTile(
            icon: Icons.description,
            title: 'ข้อกำหนดการใช้งาน',
            subtitle: 'อ่านข้อกำหนดและเงื่อนไข',
            onTap: () => _showTermsDialog(),
          ),
          _buildListTile(
            icon: Icons.privacy_tip,
            title: 'นโยบายความเป็นส่วนตัว',
            subtitle: 'อ่านนโยบายความเป็นส่วนตัว',
            onTap: () => _showPrivacyDialog(),
          ),

          const Divider(),

          // Logout Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutConfirmation(),
              icon: const Icon(Icons.logout),
              label: const Text('ออกจากระบบ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
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
              if (newPasswordController.text.length < 8) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกภาษา'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('ไทย'),
              value: 'th',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Culture Passport',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 Lottery Plus Co., Ltd.',
      children: [
        const SizedBox(height: 16),
        const Text(
          'ระบบติดตามการทดลองงานและ KPI สำหรับพนักงานใหม่',
        ),
      ],
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ข้อกำหนดการใช้งาน'),
        content: const SingleChildScrollView(
          child: Text(
            'ข้อกำหนดและเงื่อนไขการใช้งานระบบ Culture Passport\n\n'
            '1. ผู้ใช้ตกลงที่จะใช้ระบบนี้เพื่อวัตถุประสงค์ทางธุรกิจเท่านั้น\n'
            '2. ข้อมูลทั้งหมดในระบบเป็นความลับของบริษัท\n'
            '3. ห้ามแชร์ข้อมูลเข้าสู่ระบบกับบุคคลอื่น\n'
            '4. บริษัทขอสงวนสิทธิ์ในการเปลี่ยนแปลงข้อกำหนดได้ทุกเมื่อ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('นโยบายความเป็นส่วนตัว'),
        content: const SingleChildScrollView(
          child: Text(
            'นโยบายความเป็นส่วนตัว Culture Passport\n\n'
            '1. บริษัทเก็บรวบรวมข้อมูลส่วนบุคคลเท่าที่จำเป็น\n'
            '2. ข้อมูลจะถูกใช้เพื่อการประเมินผลการทำงานเท่านั้น\n'
            '3. ข้อมูลจะไม่ถูกเปิดเผยต่อบุคคลภายนอกโดยไม่ได้รับอนุญาต\n'
            '4. ผู้ใช้มีสิทธิ์ขอดูและแก้ไขข้อมูลของตนเอง',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }
}
