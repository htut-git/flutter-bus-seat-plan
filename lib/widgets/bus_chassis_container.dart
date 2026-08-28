import 'package:flutter/material.dart';
import '../painters/bus_chassis_painter.dart';
import '../themes/bus_seat_theme.dart';

/// Container that optionally wraps the seat grid with the decorative bus chassis frame.
class BusChassisContainer extends StatelessWidget {
  final Widget child;
  final BusSeatThemeData theme;
  final bool hasDriver;
  final int? doorRowIndex;

  const BusChassisContainer({
    super.key,
    required this.child,
    required this.theme,
    this.hasDriver = true,
    this.doorRowIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (!theme.showBusFrame) {
      return Container(
        padding: theme.chassisPadding,
        decoration: BoxDecoration(
          color: theme.busBodyColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.busBorderColor, width: 1.5),
        ),
        child: child,
      );
    }

    return CustomPaint(
      painter: BusChassisPainter(
        bodyColor: theme.busBodyColor,
        borderColor: theme.busBorderColor,
        borderWidth: 1.5,
        hasDriver: hasDriver,
        doorRowIndex: doorRowIndex,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: theme.chassisPadding.left,
          right: theme.chassisPadding.right,
          top: theme.chassisPadding.top + (hasDriver ? 28.0 : 14.0),
          bottom: theme.chassisPadding.bottom + 12.0,
        ),
        child: child,
      ),
    );
  }
}
