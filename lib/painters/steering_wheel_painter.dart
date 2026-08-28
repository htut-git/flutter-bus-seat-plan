import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter that draws a modern vector steering wheel and driver console.
class SteeringWheelPainter extends CustomPainter {
  final Color color;

  const SteeringWheelPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42;

    // Outer steering ring
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, ringPaint);

    // Center hub
    final hubRadius = radius * 0.3;
    final hubPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, hubRadius, hubPaint);

    // 3 Spokes
    final spokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Left spoke
    canvas.drawLine(
      Offset(center.dx - hubRadius, center.dy),
      Offset(center.dx - radius + 1.0, center.dy),
      spokePaint,
    );

    // Right spoke
    canvas.drawLine(
      Offset(center.dx + hubRadius, center.dy),
      Offset(center.dx + radius - 1.0, center.dy),
      spokePaint,
    );

    // Bottom spoke
    canvas.drawLine(
      Offset(center.dx, center.dy + hubRadius),
      Offset(center.dx, center.dy + radius - 1.0),
      spokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant SteeringWheelPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
