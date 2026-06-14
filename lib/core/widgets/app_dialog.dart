import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Centralized confirmation dialog. Returns `true` when confirmed.
abstract final class AppDialog {
  AppDialog._();

  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool destructive = false,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.darkSurfaceAlt,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: AppTextStyles.sectionTitle.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
              const SizedBox(height: 22),
              AppButton(
                label: confirmLabel,
                variant: destructive ? AppButtonVariant.danger : AppButtonVariant.primary,
                height: 50,
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: cancelLabel,
                variant: AppButtonVariant.ghost,
                height: 46,
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }
}
