import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../painters/steering_wheel_painter.dart';
import '../themes/bus_seat_theme.dart';

/// Renders the driver cabin at the front of the bus with vector steering wheel.
class BusDriverWidget extends StatelessWidget {
  final DriverPosition position;
  final BusSeatThemeData theme;
  final Widget Function(BuildContext context, DriverPosition position, BusSeatThemeData theme)? customBuilder;

  const BusDriverWidget({
    super.key,
    required this.position,
    required this.theme,
    this.customBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (position == DriverPosition.none) {
      return const SizedBox.shrink();
    }

    if (customBuilder != null) {
      return customBuilder!(context, position, theme);
    }

    return Container(
      width: theme.seatWidth,
      height: theme.seatHeight,
      margin: EdgeInsets.symmetric(
        horizontal: theme.seatGap / 2,
      ),
      decoration: BoxDecoration(
        color: theme.driverCabinColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.busBorderColor, width: 1.2),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(theme.seatWidth * 0.62, theme.seatHeight * 0.62),
          painter: SteeringWheelPainter(
            color: theme.steeringWheelColor,
          ),
        ),
      ),
    );
  }
}
