import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SeatStatus { booked, reserved, blocked, booking, canBuy }

// ignore: must_be_immutable
class SeatPlanModal extends Equatable {
  String seatNo;
  String rawNo;
  SeatStatus status;
  Icon icon;
  SeatPlanModal(
      {required this.seatNo,
      required this.rawNo,
      this.status = SeatStatus.canBuy,
      this.icon = const Icon(Icons.person)});
  @override
  List<Object> get props => [rawNo];
}

class BookedSeatModal {
  final List<String> rawIds;
  final Icon icon;
  BookedSeatModal({required this.rawIds, required this.icon});
}

class SeatStatusColor {
  final Color bookedColor;
  final Color reserveColor;
  final Color blockColor;
  final Color bookingColor;
  final Color canBuyColor;
  final Color selectedColor;

  SeatStatusColor(
      {this.bookedColor = const Color(0xFFC4740B),
      this.reserveColor = const Color(0xFF0000FF),
      this.blockColor = const Color(0xFF472B34),
      this.bookingColor = const Color(0xFFcccccc),
      this.canBuyColor = const Color(0xFF03A60F),
      this.selectedColor = const Color(0xFFFF0400)});
}
