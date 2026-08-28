import 'package:flutter/material.dart';
import 'seat.dart';

/// Legacy model retained for backwards compatibility with v2.x.
/// Prefer using [Seat] directly in v3.x.
class BookedSeat {
  final List<String> rawIds;
  final Widget icon;

  const BookedSeat({
    required this.rawIds,
    required this.icon,
  });
}

/// Legacy color config retained for backwards compatibility with v2.x.
/// Prefer using [BusSeatThemeData] in v3.x.
class SeatStatusColor {
  final Color bookedColor;
  final Color reservedColor;
  final Color disabledColor;
  final Color availableColor;
  final Color selectedColor;

  const SeatStatusColor({
    this.bookedColor = const Color(0xFFC4740B),
    this.reservedColor = const Color(0xFF0000FF),
    this.disabledColor = const Color(0xFF472B34),
    this.availableColor = const Color(0xFF03A60F),
    this.selectedColor = const Color(0xFFFF0400),
  });
}
