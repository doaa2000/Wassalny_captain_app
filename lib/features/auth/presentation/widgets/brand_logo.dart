import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The Captain app's rounded gradient logo mark.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 56, this.radius = 18});

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Icon(Icons.local_taxi_rounded, color: AppColors.white, size: size * 0.55),
    );
  }
}
