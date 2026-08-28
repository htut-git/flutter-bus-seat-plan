import 'package:flutter/material.dart';
import '../models/legend_item.dart';
import '../models/seat.dart';
import '../themes/bus_seat_theme.dart';

/// Modern pill/chip legend displaying seat status indicators, colors, and counts.
class BusLegendWidget extends StatelessWidget {
  final List<LegendItem> items;
  final BusSeatThemeData theme;
  final Widget Function(BuildContext context, List<LegendItem> items, BusSeatThemeData theme)? customBuilder;

  const BusLegendWidget({
    super.key,
    required this.items,
    required this.theme,
    this.customBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (customBuilder != null) {
      return customBuilder!(context, items, theme);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.busBodyColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.busBorderColor, width: 1.0),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: items.map((item) => _buildLegendChip(context, item)).toList(),
      ),
    );
  }

  Widget _buildLegendChip(BuildContext context, LegendItem item) {
    Color itemColor = item.color ?? _resolveColorForItem(item);
    Color borderColor = _resolveBorderForItem(item);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.busBorderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: itemColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor, width: 1.2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            item.label,
            style: theme.legendTextStyle ??
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.availableStyle.foregroundColor.withValues(alpha: 0.85),
                ),
          ),
          if (item.count != null) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${item.count}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: itemColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _resolveColorForItem(LegendItem item) {
    if (item.status != null) {
      switch (item.status!) {
        case SeatStatus.available:
          return theme.availableStyle.backgroundColor;
        case SeatStatus.selected:
          return theme.selectedStyle.backgroundColor;
        case SeatStatus.booked:
          return theme.bookedStyle.backgroundColor;
        case SeatStatus.reserved:
          return theme.reservedStyle.backgroundColor;
        case SeatStatus.disabled:
          return theme.disabledStyle.backgroundColor;
        case SeatStatus.femaleOnly:
          return theme.femaleOnlyStyle.backgroundColor;
      }
    }
    if (item.type != null) {
      switch (item.type!) {
        case SeatType.vip:
          return theme.vipAvailableStyle?.backgroundColor ??
              theme.availableStyle.backgroundColor;
        case SeatType.sleeper:
          return theme.sleeperAvailableStyle?.backgroundColor ??
              theme.availableStyle.backgroundColor;
        case SeatType.semiSleeper:
        case SeatType.standard:
          return theme.availableStyle.backgroundColor;
      }
    }
    return theme.availableStyle.backgroundColor;
  }

  Color _resolveBorderForItem(LegendItem item) {
    if (item.status != null) {
      switch (item.status!) {
        case SeatStatus.available:
          return theme.availableStyle.borderColor;
        case SeatStatus.selected:
          return theme.selectedStyle.borderColor;
        case SeatStatus.booked:
          return theme.bookedStyle.borderColor;
        case SeatStatus.reserved:
          return theme.reservedStyle.borderColor;
        case SeatStatus.disabled:
          return theme.disabledStyle.borderColor;
        case SeatStatus.femaleOnly:
          return theme.femaleOnlyStyle.borderColor;
      }
    }
    return theme.availableStyle.borderColor;
  }
}
