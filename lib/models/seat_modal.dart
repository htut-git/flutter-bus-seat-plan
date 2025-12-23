import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SeatStatus { booked, reserved, blocked, booking, canBuy }

// ignore: must_be_immutable
class SeatPlanModal extends Equatable {
  final String seatNumber;
  final String id;
  SeatStatus status;
  final Icon? icon;
  SeatPlanModal({
    required this.seatNumber,
    required this.id,
    this.status = SeatStatus.canBuy,
    this.icon,
  });
  @override
  List<Object> get props => [id];
}

class SeatStatusColor {
  final Color bookedColor;
  final Color reserveColor;
  final Color blockColor;
  final Color bookingColor;
  final Color canBuyColor;
  final Color selectedColor;

  SeatStatusColor({
    this.bookedColor = const Color(0xFFC4740B),
    this.reserveColor = const Color(0xFF0000FF),
    this.blockColor = const Color(0xFF472B34),
    this.bookingColor = const Color(0xFFcccccc),
    this.canBuyColor = const Color(0xFF03A60F),
    this.selectedColor = const Color(0xFFFF0400),
  });
}
