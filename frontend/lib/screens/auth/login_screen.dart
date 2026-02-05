import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/loading.dart';
import '../../widgets/error_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Show error snackbar when login fails
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.hasError && next.errorMessage != null) {
        showErrorSnackBar(context, next.errorMessage!);
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  _buildLogo(),
                  const SizedBox(height: AppSpacing.xxl),

                  // Title
                  Text(
                    'CulturePassport',
                    style: AppTextStyles.headline1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'ระบบติดตามการเข้าปรับตัวพนักงานใหม่',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Form header
                  Text(
                    'กรอกข้อมูลเพื่อเข้าใช้งาน',
                    style: AppTextStyles.headline3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'ใช้อีเมลและรหัสผ่านของคุณเพื่อเข้าสู่ระบบ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'อีเมล',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      }
                      if (!value.contains('@')) {
                        return 'กรุณากรอกอีเมลที่ถูกต้อง';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      if (value.length < 8) {
                        return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Login button
                  LoadingButton(
                    onPressed: _handleLogin,
                    text: 'เข้าสู่ระบบ',
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Forgot password link (placeholder)
                  TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                      showWarningSnackBar(
                        context,
                        'กรุณาติดต่อ HR เพื่อรีเซ็ตรหัสผ่าน',
                      );
                    },
                    child: const Text('ลืมรหัสผ่าน?'),
                  ),

                  // Debug: Quick login buttons for testing
                  const SizedBox(height: AppSpacing.xl),
                  const Divider(),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Quick Login (Dev)',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.sm,
                    children: [
                      _buildQuickLoginChip('Employee', 'employee1@company.com'),
                      _buildQuickLoginChip('Supervisor', 'supervisor@company.com'),
                      _buildQuickLoginChip('HR', 'hr@company.com'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginChip(String label, String email) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _emailController.text = email;
        _passwordController.text = 'password123';
        // Auto-submit the form
        _handleLogin();
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.auto_stories,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
