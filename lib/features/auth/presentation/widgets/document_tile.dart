import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Dashed upload tile for KYC documents (uploaded vs. add states).
class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key, required this.label, required this.uploaded, this.onTap});

  final String label;
  final bool uploaded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color accent = uploaded ? AppColors.success : AppColors.textMutedDark;
    return GestureDetector(
      onTap: onTap,
      child: DottedBorderBox(
        color: uploaded ? AppColors.success : const Color(0xFF3A4756),
        background: uploaded ? AppColors.success.withValues(alpha: 0.07) : null,
        child: Column(
          children: [
            Icon(uploaded ? Icons.check_rounded : Icons.add_rounded, color: accent, size: 22),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: uploaded ? AppColors.textPrimaryDark : AppColors.textSecondaryDark,
                  fontWeight: FontWeight.w700,
                )),
            Text(uploaded ? 'Uploaded' : 'Add',
                style: AppTextStyles.micro.copyWith(color: accent)),
          ],
        ),
      ),
    );
  }
}

/// Lightweight dashed-border container (avoids extra package dependency).
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child, required this.color, this.background});

  final Widget child;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(color: color),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final RRect rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(15),
    );
    final Path path = Path()..addRRect(rect);
    const double dash = 5, gap = 4;
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        canvas.drawPath(metric.extractPath(dist, dist + dash), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) => oldDelegate.color != color;
}
