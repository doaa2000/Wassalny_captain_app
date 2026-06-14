import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';

/// Rounded square back button used in the design's secondary screens.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Color bg = context.isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color border = context.isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: context.colors.onSurface),
        ),
      ),
    );
  }
}
