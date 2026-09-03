import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Uber / Wassalny-style location pin drawn as a screen overlay so it stays
/// visually fixed while the map pans underneath. The tip sits on the camera
/// target (the point being "picked").
class MapCenterPin extends StatelessWidget {
  const MapCenterPin({super.key, this.lifted = false});

  /// Raised slightly while the user is dragging the map, then drops on idle.
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 8,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            scale: lifted ? 0.55 : 1,
            child: Container(
              width: 18,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: lifted ? 0.18 : 0.32),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            bottom: lifted ? 22 : 6,
            left: 0,
            right: 0,
            child: const Center(child: _PinBody()),
          ),
        ],
      ),
    );
  }
}

class _PinBody extends StatelessWidget {
  const _PinBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 56,
      child: CustomPaint(painter: _WassalnyPinPainter()),
    );
  }
}

/// Teardrop pin with a white "hole" — the classic Wassalny / ride-hailing look.
class _WassalnyPinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double r = w * 0.46;
    final Offset head = Offset(cx, r + 1);

    final Path pin = Path()
      ..moveTo(cx, h)
      ..quadraticBezierTo(w * 0.08, h * 0.62, head.dx - r * 0.78, head.dy + r * 0.45)
      ..arcToPoint(
        Offset(head.dx + r * 0.78, head.dy + r * 0.45),
        radius: Radius.circular(r),
        clockwise: true,
      )
      ..quadraticBezierTo(w * 0.92, h * 0.62, cx, h)
      ..close();

    canvas.drawPath(
      pin,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawPath(
      pin,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryLight, AppColors.primary, AppColors.primaryDark],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      pin,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    canvas.drawCircle(head, r * 0.42, Paint()..color = Colors.white);
    canvas.drawCircle(head, r * 0.18, Paint()..color = AppColors.primary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
