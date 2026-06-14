import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The pickup → drop-off connector (green dot, line, blue square) reused on
/// every trip-related card in the design.
///
/// Always render this inside an [IntrinsicHeight] row with
/// `crossAxisAlignment: CrossAxisAlignment.stretch` so it receives a bounded
/// height to fill.
class RouteIndicator extends StatelessWidget {
  const RouteIndicator({super.key, this.dotSize = 9});

  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 4),
        _Dot(size: dotSize, color: AppColors.success, isSquare: false),
        Expanded(
          child: Container(
            width: 2,
            constraints: const BoxConstraints(minHeight: 14),
            margin: const EdgeInsets.symmetric(vertical: 3),
            color: AppColors.darkTrack,
          ),
        ),
        _Dot(size: dotSize, color: AppColors.primary, isSquare: true),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color, required this.isSquare});

  final double size;
  final Color color;
  final bool isSquare;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isSquare ? 2 : size),
      ),
    );
  }
}
