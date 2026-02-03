import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// Full screen error display
class ErrorScreen extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final String retryText;

  const ErrorScreen({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.retryText = 'ลองอีกครั้ง',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              if (details != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  details!,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(retryText),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline error display widget
class ErrorDisplay extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final String retryText;
  final EdgeInsetsGeometry? padding;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.retryText = 'ลองอีกครั้ง',
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: AppTextStyles.subtitle1,
            textAlign: TextAlign.center,
          ),
          if (details != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              details!,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(retryText),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error card widget
class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorCard({
    super.key,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.error.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(
              Icons.error,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
            if (onRetry != null)
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.error),
                onPressed: onRetry,
              ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.error),
                onPressed: onDismiss,
              ),
          ],
        ),
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkError extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkError({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorDisplay(
      message: 'ไม่สามารถเชื่อมต่อเครือข่ายได้',
      details: 'กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
      onRetry: onRetry,
    );
  }
}

/// Session expired widget
class SessionExpired extends StatelessWidget {
  final VoidCallback? onLogin;

  const SessionExpired({
    super.key,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorDisplay(
      message: 'เซสชันหมดอายุ',
      details: 'กรุณาเข้าสู่ระบบอีกครั้ง',
      onRetry: onLogin,
      retryText: 'เข้าสู่ระบบ',
    );
  }
}

/// Snackbar helpers
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showWarningSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.warning, color: Colors.white),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.warning,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
