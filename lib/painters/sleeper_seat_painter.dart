import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../themes/seat_style.dart';

/// Clean, modern vector painter for sleeper berths/bunks.
class SleeperSeatPainter extends CustomPainter {
  final Seat seat;
  final SeatStatus effectiveStatus;
  final SeatStyle style;
  final bool isHovered;
  final double animationProgress;

  SleeperSeatPainter({
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
    final isDisabled = effectiveStatus == SeatStatus.disabled;

    final baseColor = style.backgroundColor;
    final borderColor = style.borderColor;
    final accentColor = style.accentColor ?? borderColor;

    // 1. Soft Shadow
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

    // 2. Berth Body
    final berthRect = Rect.fromLTWH(0, 0, w, h);
    final berthRRect = RRect.fromRectAndRadius(
      berthRect,
      const Radius.circular(10.0),
    );

    final bodyPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(berthRRect, bodyPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 2.0 : style.borderWidth;
    canvas.drawRRect(berthRRect, borderPaint);

    // 3. Pillow at Top
    final pillowW = w * 0.72;
    final pillowH = 14.0;
    final pillowRect = Rect.fromLTWH(
      (w - pillowW) / 2,
      6.0,
      pillowW,
      pillowH,
    );
    final pillowRRect = RRect.fromRectAndRadius(
      pillowRect,
      const Radius.circular(4.0),
    );

    final pillowPaint = Paint()
      ..color = isSelected
          ? Colors.white.withValues(alpha: 0.4)
          : (isBooked || isDisabled)
              ? borderColor.withValues(alpha: 0.35)
              : accentColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(pillowRRect, pillowPaint);

    final pillowBorder = Paint()
      ..color = isSelected
          ? Colors.white.withValues(alpha: 0.5)
          : borderColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(pillowRRect, pillowBorder);

    // 4. Subtle Mattress Sheet Line
    final sheetY = h * 0.38;
    final linePaint = Paint()
      ..color = borderColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(6.0, sheetY), Offset(w - 6.0, sheetY), linePaint);
  }

  @override
  bool shouldRepaint(covariant SleeperSeatPainter oldDelegate) {
    return oldDelegate.seat != seat ||
        oldDelegate.effectiveStatus != effectiveStatus ||
        oldDelegate.style != style ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.animationProgress != animationProgress;
  }
}
