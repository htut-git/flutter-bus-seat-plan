import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'seat.dart';

/// Represents a single item displayed in the seat plan legend.
@immutable
class LegendItem extends Equatable {
  /// Display text for this legend item (e.g., "Available", "Selected", "Booked").
  final String label;

  /// Associated [SeatStatus], if any.
  final SeatStatus? status;

  /// Associated [SeatType], if any.
  final SeatType? type;

  /// Optional custom badge/color override.
  final Color? color;

  /// Optional counter displaying how many seats currently match this status/type.
  final int? count;

  /// Optional custom icon or indicator widget.
  final Widget? icon;

  const LegendItem({
    required this.label,
    this.status,
    this.type,
    this.color,
    this.count,
    this.icon,
  });

  /// Factory for standard available seats.
  factory LegendItem.available({String label = 'Available', int? count}) =>
      LegendItem(label: label, status: SeatStatus.available, count: count);

  /// Factory for selected seats.
  factory LegendItem.selected({String label = 'Selected', int? count}) =>
      LegendItem(label: label, status: SeatStatus.selected, count: count);

  /// Factory for booked seats.
  factory LegendItem.booked({String label = 'Booked', int? count}) =>
      LegendItem(label: label, status: SeatStatus.booked, count: count);

  /// Factory for reserved seats.
  factory LegendItem.reserved({String label = 'Reserved', int? count}) =>
      LegendItem(label: label, status: SeatStatus.reserved, count: count);

  /// Factory for disabled/blocked seats.
  factory LegendItem.disabled({String label = 'Disabled', int? count}) =>
      LegendItem(label: label, status: SeatStatus.disabled, count: count);

  /// Factory for female-only seats.
  factory LegendItem.femaleOnly({String label = 'Female Only', int? count}) =>
      LegendItem(label: label, status: SeatStatus.femaleOnly, count: count);

  /// Factory for VIP seats.
  factory LegendItem.vip({String label = 'VIP', int? count}) =>
      LegendItem(label: label, type: SeatType.vip, count: count);

  /// Factory for Sleeper berths.
  factory LegendItem.sleeper({String label = 'Sleeper', int? count}) =>
      LegendItem(label: label, type: SeatType.sleeper, count: count);

  @override
  List<Object?> get props => [label, status, type, color, count];
}
