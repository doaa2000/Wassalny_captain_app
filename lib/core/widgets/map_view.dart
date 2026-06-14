import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Visual states the map can be rendered in.
enum MapVariant { idle, route, tracking }

/// A stylized, dependency-free map backdrop.
///
/// In production this is the single seam where a real map SDK (Google Maps,
/// Mapbox) would be dropped in — every screen already consumes [MapView] rather
/// than a concrete map, so swapping it touches exactly one widget. For now it
/// paints a believable city map so the UI is pixel-faithful to the design.
class MapView extends StatelessWidget {
  const MapView({super.key, this.variant = MapVariant.idle});

  final MapVariant variant;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _MapPainter(variant: variant),
        size: Size.infinite,
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.variant});

  final MapVariant variant;

  @override
  void paint(Canvas canvas, Size size) {
    // Base (dark map tones matching the design).
    final Paint base = Paint()..color = const Color(0xFF11181F);
    canvas.drawRect(Offset.zero & size, base);

    final double w = size.width;
    final double h = size.height;
    final math.Random rnd = math.Random(7);

    // City blocks.
    final Paint block = Paint()..color = const Color(0xFF1A242E);
    for (int i = 0; i < 22; i++) {
      final double bw = 40 + rnd.nextDouble() * 90;
      final double bh = 40 + rnd.nextDouble() * 90;
      final double x = rnd.nextDouble() * (w - bw);
      final double y = rnd.nextDouble() * (h - bh);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, bw, bh), const Radius.circular(7)),
        block,
      );
    }

    // Roads.
    final Paint road = Paint()
      ..color = const Color(0xFF263340)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    for (int i = 1; i < 5; i++) {
      final double y = h * i / 5;
      canvas.drawLine(Offset(-10, y - 20), Offset(w + 10, y + 10), road);
    }
    for (int i = 1; i < 4; i++) {
      final double x = w * i / 4;
      canvas.drawLine(Offset(x, -10), Offset(x + 18, h + 10), road);
    }

    if (variant == MapVariant.idle) {
      _paintCaptainPulse(canvas, Offset(w / 2, h * 0.42));
      return;
    }

    // Route line (pickup -> drop-off) for route/tracking variants.
    final Offset pickup = Offset(w * 0.28, h * 0.66);
    final Offset dropoff = Offset(w * 0.74, h * 0.30);
    final Path route = Path()
      ..moveTo(pickup.dx, pickup.dy)
      ..cubicTo(w * 0.30, h * 0.45, w * 0.62, h * 0.52, dropoff.dx, dropoff.dy);

    canvas.drawPath(
      route,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      route,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    _paintMarker(canvas, pickup, AppColors.success, isSquare: false);
    _paintMarker(canvas, dropoff, AppColors.primary, isSquare: true);

    if (variant == MapVariant.tracking) {
      _paintCaptainPulse(canvas, Offset.lerp(pickup, dropoff, 0.4)!);
    }
  }

  void _paintMarker(Canvas canvas, Offset c, Color color, {required bool isSquare}) {
    canvas.drawCircle(c, 11, Paint()..color = color.withValues(alpha: 0.25));
    if (isSquare) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 13, height: 13), const Radius.circular(3)),
        Paint()..color = color,
      );
    } else {
      canvas.drawCircle(c, 6.5, Paint()..color = color);
    }
    canvas.drawCircle(c, 3, Paint()..color = AppColors.white);
  }

  void _paintCaptainPulse(Canvas canvas, Offset c) {
    canvas.drawCircle(c, 26, Paint()..color = AppColors.primary.withValues(alpha: 0.12));
    canvas.drawCircle(c, 14, Paint()..color = AppColors.primary.withValues(alpha: 0.25));
    canvas.drawCircle(c, 8, Paint()..color = AppColors.primary);
    canvas.drawCircle(c, 3, Paint()..color = AppColors.white);
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => oldDelegate.variant != variant;
}
