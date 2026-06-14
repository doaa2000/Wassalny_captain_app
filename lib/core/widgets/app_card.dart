import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';

/// The base surface card used everywhere in the app. Encapsulates the design's
/// rounded, bordered, dark surfaces so screens stay free of styling noise.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
    this.color,
    this.borderColor,
    this.gradient,
    this.onTap,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final Color bg = color ??
        (context.isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurface);
    final Color border = borderColor ??
        (context.isDark ? AppColors.darkBorderSoft : AppColors.lightBorder);

    final Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? bg : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border),
        boxShadow: boxShadow,
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: content,
      ),
    );
  }
}
