import 'package:flutter/material.dart';

/// Clean, modern vector painter for the bus exterior chassis frame.
/// Provides a sleek, blueprint-style outline that snugly frames the seating grid.
class BusChassisPainter extends CustomPainter {
  final Color bodyColor;
  final Color borderColor;
  final double borderWidth;
  final bool hasDriver;
  final int? doorRowIndex;

  const BusChassisPainter({
    required this.bodyColor,
    required this.borderColor,
    this.borderWidth = 1.5,
    this.hasDriver = true,
    this.doorRowIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const cornerRadius = 24.0;

    // 1. Soft Outer Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    final chassisRect = Rect.fromLTWH(0, 0, w, h);
    final chassisRRect = RRect.fromRectAndCorners(
      chassisRect,
      topLeft: const Radius.circular(cornerRadius + 4),
      topRight: const Radius.circular(cornerRadius + 4),
      bottomLeft: const Radius.circular(cornerRadius),
      bottomRight: const Radius.circular(cornerRadius),
    );

    canvas.drawRRect(chassisRRect.shift(const Offset(0, 3)), shadowPaint);

    // 2. Bus Body Fill
    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(chassisRRect, bodyPaint);

    // 3. Clean Outer Border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(chassisRRect, borderPaint);

    // 4. Clean Aerodynamic Front Windshield
    final windshieldH = 20.0;
    final windshieldTop = 10.0;
    final windshieldPath = Path()
      ..moveTo(16.0, windshieldTop + 4.0)
      ..quadraticBezierTo(w / 2, windshieldTop - 3.0, w - 16.0, windshieldTop + 4.0)
      ..lineTo(w - 20.0, windshieldTop + windshieldH)
      ..quadraticBezierTo(w / 2, windshieldTop + windshieldH - 2.0, 20.0, windshieldTop + windshieldH)
      ..close();

    final glassPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawPath(windshieldPath, glassPaint);

    final glassBorder = Paint()
      ..color = borderColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(windshieldPath, glassBorder);

    // 5. Sleek Side Mirrors
    final mirrorPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    // Left Mirror
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5.0, 20.0, 5.0, 14.0),
        const Radius.circular(2.5),
      ),
      mirrorPaint,
    );

    // Right Mirror
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w, 20.0, 5.0, 14.0),
        const Radius.circular(2.5),
      ),
      mirrorPaint,
    );

    // 6. Clean Rear LED Taillights
    final tailPaint = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10.0, h - 5.0, 14.0, 3.0),
        const Radius.circular(1.5),
      ),
      tailPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w - 24.0, h - 5.0, 14.0, 3.0),
        const Radius.circular(1.5),
      ),
      tailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant BusChassisPainter oldDelegate) {
    return oldDelegate.bodyColor != bodyColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.hasDriver != hasDriver ||
        oldDelegate.doorRowIndex != doorRowIndex;
  }
}
