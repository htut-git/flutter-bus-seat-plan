import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../themes/seat_style.dart';

/// Clean, modern vector painter rendering a sleek, polished automotive seat.
/// Designed for high clarity, minimal clutter, and premium readability.
class SeatPainter extends CustomPainter {
  final Seat seat;
  final SeatStatus effectiveStatus;
  final SeatStyle style;
  final bool isHovered;
  final double animationProgress;

  SeatPainter({
    required this.seat,
    required this.effectiveStatus,
    required this.style,
    this.isHovered = false,
    this.animationProgress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final isSelected = effectiveStatus == SeatStatus.selected;
    final isBooked = effectiveStatus == SeatStatus.booked;
    final isReserved = effectiveStatus == SeatStatus.reserved;
    final isDisabled = effectiveStatus == SeatStatus.disabled;

    final baseColor = style.backgroundColor;
    final borderColor = style.borderColor;
    final accentColor = style.accentColor ?? borderColor;

    // -------------------------------------------------------------
    // 1. Soft, Clean Modern Elevation Shadow
    // -------------------------------------------------------------
    if (isSelected) {
      final glowPaint = Paint()
        ..color = baseColor.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 2, w - 2, h - 1),
          const Radius.circular(10.0),
        ),
        glowPaint,
      );
    } else if (!isBooked && !isDisabled) {
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: isHovered ? 0.12 : 0.06)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, isHovered ? 4.0 : 2.5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 2, w - 2, h),
          const Radius.circular(10.0),
        ),
        shadowPaint,
      );
    }

    // -------------------------------------------------------------
    // 2. Main Seat Body (Smooth Rounded Rectangle)
    // -------------------------------------------------------------
    final seatRect = Rect.fromLTWH(0, 0, w, h);
    final seatRRect = RRect.fromRectAndRadius(
      seatRect,
      const Radius.circular(10.0),
    );

    final bodyPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    if (style.backgroundGradient != null) {
      bodyPaint.shader = style.backgroundGradient!.createShader(seatRect);
    }

    canvas.drawRRect(seatRRect, bodyPaint);

    // Clean outer stroke border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 2.0 : style.borderWidth;
    canvas.drawRRect(seatRRect, borderPaint);

    // -------------------------------------------------------------
    // 3. Sleek Headrest Contour (Minimalist Top Pill)
    // -------------------------------------------------------------
    final headrestW = w * 0.65;
    final headrestH = 4.5;
    final headrestTop = 4.0;
    final headrestRect = Rect.fromLTWH(
      (w - headrestW) / 2,
      headrestTop,
      headrestW,
      headrestH,
    );
    final headrestRRect = RRect.fromRectAndRadius(
      headrestRect,
      const Radius.circular(3.0),
    );

    final headrestPaint = Paint()
      ..color = isSelected
          ? Colors.white.withValues(alpha: 0.45)
          : (isBooked || isDisabled)
              ? borderColor.withValues(alpha: 0.4)
              : accentColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(headrestRRect, headrestPaint);

    // -------------------------------------------------------------
    // 4. Subtle Outer Armrest Notches (Left & Right)
    // -------------------------------------------------------------
    final armrestW = 2.5;
    final armrestH = h * 0.38;
    final armrestTop = h * 0.32;

    final armrestPaint = Paint()
      ..color = isSelected
          ? Colors.white.withValues(alpha: 0.3)
          : borderColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Left armrest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2.0, armrestTop, armrestW, armrestH),
        const Radius.circular(2.0),
      ),
      armrestPaint,
    );

    // Right armrest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w - armrestW - 2.0, armrestTop, armrestW, armrestH),
        const Radius.circular(2.0),
      ),
      armrestPaint,
    );

    // -------------------------------------------------------------
    // 5. Special Status Patterns (VIP Star / Reserved Line)
    // -------------------------------------------------------------
    if (isReserved) {
      // Clean subtle diagonal slash for reserved
      final hatchPaint = Paint()
        ..color = borderColor.withValues(alpha: 0.4)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(w - 10.0, 4.0), Offset(w - 4.0, 10.0), hatchPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SeatPainter oldDelegate) {
    return oldDelegate.seat != seat ||
        oldDelegate.effectiveStatus != effectiveStatus ||
        oldDelegate.style != style ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.animationProgress != animationProgress;
  }
}
