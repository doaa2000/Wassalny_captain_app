import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Visual intent for [AppButton]. Maps to the design's filled colors.
enum AppButtonVariant { primary, success, outlined, ghost, danger }

/// The single, reusable filled/outlined button used across the whole app.
///
/// Variants cover every button style in the design so screens never style
/// raw [ElevatedButton]s themselves.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.height = 58,
    this.expand = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final double height;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;
    final _ButtonColors c = _resolveColors(context);

    final Widget child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: c.foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: c.foreground),
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTextStyles.button.copyWith(color: c.foreground)),
            ],
          );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: SizedBox(
        height: height,
        width: expand ? double.infinity : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: c.fill != null && enabled
                ? [
                    BoxShadow(
                      color: c.fill!.withValues(alpha: 0.45),
                      blurRadius: 26,
                      offset: const Offset(0, 14),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: c.fill ?? Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: c.border != null ? BorderSide(color: c.border!, width: 1.5) : BorderSide.none,
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled ? onPressed : null,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _resolveColors(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.primary:
        return const _ButtonColors(fill: AppColors.primary, foreground: AppColors.onPrimary);
      case AppButtonVariant.success:
        return const _ButtonColors(fill: AppColors.success, foreground: AppColors.onSuccess);
      case AppButtonVariant.danger:
        return const _ButtonColors(fill: AppColors.danger, foreground: AppColors.white);
      case AppButtonVariant.outlined:
        return _ButtonColors(
          foreground: Theme.of(context).colorScheme.onSurface,
          border: Theme.of(context).dividerColor,
        );
      case AppButtonVariant.ghost:
        return const _ButtonColors(foreground: AppColors.textSecondaryDark);
    }
  }
}

class _ButtonColors {
  const _ButtonColors({required this.foreground, this.fill, this.border});
  final Color foreground;
  final Color? fill;
  final Color? border;
}
