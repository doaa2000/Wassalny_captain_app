import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Centered loading spinner used while a bloc is in a loading state.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
          ],
        ],
      ),
    );
  }
}

/// Generic empty-state placeholder.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconBubble(icon: icon, color: AppColors.textMutedDark),
            const SizedBox(height: 14),
            Text(title, style: AppTextStyles.sectionTitle.copyWith(color: context.colors.onSurface)),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Generic error-state placeholder with retry.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _IconBubble(icon: Icons.error_outline_rounded, color: AppColors.danger),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyStrong.copyWith(color: context.colors.onSurface),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              AppButton(
                label: AppLocalizations.of(context)?.tryAgain ?? 'Try again',
                onPressed: onRetry,
                expand: false,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }
}
