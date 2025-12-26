import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SeatStatus { available, booked, reserved, disabled, selected }

@immutable
class Seat extends Equatable {
  final String seatNo;
  final String rawNo;
  final SeatStatus status;
  final Widget? icon;

  const Seat({
    required this.seatNo,
    required this.rawNo,
    this.status = SeatStatus.available,
    this.icon,
  });

  Seat copyWith({
    String? seatNo,
    String? rawNo,
    SeatStatus? status,
    Widget? icon,
    bool clearIcon = false,
  }) {
    return Seat(
      seatNo: seatNo ?? this.seatNo,
      rawNo: rawNo ?? this.rawNo,
      status: status ?? this.status,
      icon: clearIcon ? null : (icon ?? this.icon),
    );
  }

  @override
  List<Object?> get props => [seatNo, rawNo, status];
}

class BookedSeat {
  final List<String> rawIds;
  final Widget icon;
  BookedSeat({required this.rawIds, required this.icon});
}

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
