import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single row in the profile settings menu.
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor = AppColors.primary,
    this.labelColor = AppColors.textPrimaryDark,
    this.trailing,
    this.showChevron = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color labelColor;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: AppTextStyles.body.copyWith(color: labelColor, fontWeight: FontWeight.w700)),
            ),
            if (trailing != null) trailing!,
            if (showChevron && trailing == null)
              const Icon(Icons.chevron_right_rounded, size: 22, color: AppColors.textFaintDark),
          ],
        ),
      ),
    );
  }
}
