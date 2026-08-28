import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../models/seat_layout.dart';
import '../models/seat_modal.dart';
import '../themes/bus_seat_theme.dart';
import '../themes/seat_style.dart';
import 'bus_seat_plan.dart';

/// Legacy [BusSeatPlanWidget] provided for backwards compatibility with v2.x.
/// For all new projects, use [BusSeatPlan] directly.
class BusSeatPlanWidget extends StatelessWidget {
  final List<String> seatMap;
  final List<Seat> selectedSeats;
  final List<BookedSeat> bookedSeats;
  final List<String> reservedSeats;
  final List<String> disabledSeats;
  final ValueChanged<Seat> onSeatSelect;
  final SeatStatusColor seatStatusColor;
  final Widget Function(int seatCount)? customTopWidget;
  final double? maxScreenWidth;
  final String Function(int row, int col) seatNoBuilder;

  const BusSeatPlanWidget({
    super.key,
    required this.seatMap,
    required this.onSeatSelect,
    required this.seatNoBuilder,
    this.selectedSeats = const [],
    this.bookedSeats = const [],
    this.reservedSeats = const [],
    this.disabledSeats = const [],
    this.seatStatusColor = const SeatStatusColor(),
    this.customTopWidget,
    this.maxScreenWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Convert legacy matrix into SeatLayout
    final layout = _buildLegacyLayout();

    final theme = BusSeatThemeData(
      backgroundColor: Colors.transparent,
      busBodyColor: Colors.transparent,
      busBorderColor: Colors.transparent,
      steeringWheelColor: Colors.grey,
      driverCabinColor: Colors.transparent,
      showBusFrame: false,
      showDriverArea: false,
      showLegend: false,
      useVectorSeats: false,
      availableStyle: SeatStyle(
        backgroundColor: seatStatusColor.availableColor,
        foregroundColor: Colors.white,
      ),
      selectedStyle: SeatStyle(
        backgroundColor: seatStatusColor.selectedColor,
        foregroundColor: Colors.white,
      ),
      bookedStyle: SeatStyle(
        backgroundColor: seatStatusColor.bookedColor,
        foregroundColor: Colors.white,
      ),
      reservedStyle: SeatStyle(
        backgroundColor: seatStatusColor.reservedColor,
        foregroundColor: Colors.white,
      ),
      disabledStyle: SeatStyle(
        backgroundColor: seatStatusColor.disabledColor,
        foregroundColor: Colors.white,
      ),
      femaleOnlyStyle: const SeatStyle(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxScreenWidth ?? double.infinity,
      ),
      child: BusSeatPlan(
        seatLayout: layout,
        theme: theme,
        initialSelectedSeats: selectedSeats,
        onSeatTap: onSeatSelect,
        showRowNumbers: true,
        headerBuilder: customTopWidget != null && seatMap.isNotEmpty
            ? (ctx) => customTopWidget!(seatMap.first.length)
            : null,
      ),
    );
  }

  SeatLayout _buildLegacyLayout() {
    final matrix = List.generate(seatMap.length, (row) {
      final seatRow = seatMap[row].split('');
      return List.generate(seatRow.length, (col) {
        if (seatRow[col] == 's') {
          final rawId = '${row + 1}_${col + 1}';
          final seatNo = seatNoBuilder(row + 1, col + 1);
          Seat seat = Seat(id: rawId, label: seatNo, row: row, column: col);

          if (disabledSeats.contains(rawId)) {
            return seat.copyWith(status: SeatStatus.disabled);
          }
          if (reservedSeats.contains(rawId)) {
            return seat.copyWith(status: SeatStatus.reserved);
          }
          final bookedSeat = bookedSeats.firstWhere(
            (booked) => booked.rawIds.contains(rawId),
            orElse: () => const BookedSeat(rawIds: [], icon: SizedBox()),
          );
          if (bookedSeat.rawIds.isNotEmpty) {
            return seat.copyWith(
              status: SeatStatus.booked,
              icon: bookedSeat.icon,
            );
          }
          if (selectedSeats.any((s) => s.id == rawId || s.label == seatNo)) {
            return seat.copyWith(status: SeatStatus.selected);
          }

          return seat;
        }
        return null;
      });
    });

    return SeatLayout.singleDeck(
      matrix: matrix,
      driverPosition: DriverPosition.none,
    );
  }
}
