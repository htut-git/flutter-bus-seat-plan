import 'package:flutter/material.dart';
import 'package:bus_seat_plan/bus_seat_plan.dart';

class BusSeatPlanWidget extends StatefulWidget {
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
  State<BusSeatPlanWidget> createState() => _BusSeatPlanWidgetState();
}

class _BusSeatPlanWidgetState extends State<BusSeatPlanWidget> {
  late List<List<Seat?>> _seatPlan;

  @override
  void initState() {
    super.initState();
    _seatPlan = _generateSeatPlan();
  }

  @override
  void didUpdateWidget(covariant BusSeatPlanWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.seatMap != oldWidget.seatMap ||
        widget.bookedSeats != oldWidget.bookedSeats ||
        widget.reservedSeats != oldWidget.reservedSeats ||
        widget.disabledSeats != oldWidget.disabledSeats ||
        widget.selectedSeats != oldWidget.selectedSeats) {
      setState(() {
        _seatPlan = _generateSeatPlan();
      });
    }
  }

  List<List<Seat?>> _generateSeatPlan() {
    return List.generate(widget.seatMap.length, (row) {
      final seatRow = widget.seatMap[row].split('');
      return List.generate(seatRow.length, (col) {
        if (seatRow[col] == 's') {
          final rawId = '${row + 1}_${col + 1}';
          final seatNo = widget.seatNoBuilder(row + 1, col + 1);
          Seat seat = Seat(seatNo: seatNo, rawNo: rawId);

          if (widget.disabledSeats.contains(rawId)) {
            return seat.copyWith(status: SeatStatus.disabled);
          }
          if (widget.reservedSeats.contains(rawId)) {
            return seat.copyWith(status: SeatStatus.reserved);
          }
          final bookedSeat = widget.bookedSeats.firstWhere(
            (booked) => booked.rawIds.contains(rawId),
            orElse: () => BookedSeat(rawIds: [], icon: const SizedBox()),
          );
          if (bookedSeat.rawIds.isNotEmpty) {
            return seat.copyWith(
                status: SeatStatus.booked, icon: bookedSeat.icon);
          }
          if (widget.selectedSeats.any((s) => s.rawNo == rawId)) {
            return seat.copyWith(status: SeatStatus.selected);
          }

          return seat;
        }
        return null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (widget.maxScreenWidth != null && widget.maxScreenWidth! < screenWidth) {
      screenWidth = widget.maxScreenWidth!;
    }

    if (_seatPlan.isEmpty) {
      return const Center(child: Text('Seat plan not found'));
    }

    int totalSeatsInRow = _seatPlan.first.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.customTopWidget != null)
          widget.customTopWidget!(totalSeatsInRow),
        ...List.generate(_seatPlan.length, (rowIndex) {
          final seatRow = _seatPlan[rowIndex];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  (rowIndex + 1).toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...List.generate(seatRow.length, (colIndex) {
                final seat = seatRow[colIndex];
                if (seat != null) {
                  return _buildSeatWidget(seat, totalSeatsInRow, screenWidth);
                } else {
                  return _buildEmptySpace(totalSeatsInRow, screenWidth);
                }
              }),
              const SizedBox(width: 30),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSeatWidget(Seat seat, int totalSeatsInRow, double screenWidth) {
    final colors = widget.seatStatusColor;
    Color seatColor;
    switch (seat.status) {
      case SeatStatus.available:
        seatColor = colors.availableColor;
        break;
      case SeatStatus.booked:
        seatColor = colors.bookedColor;
        break;
      case SeatStatus.reserved:
        seatColor = colors.reservedColor;
        break;
      case SeatStatus.disabled:
        seatColor = colors.disabledColor;
        break;
      case SeatStatus.selected:
        seatColor = colors.selectedColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: seat.status != SeatStatus.booked &&
                seat.status != SeatStatus.disabled
            ? () => widget.onSeatSelect(seat)
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: seatColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          width: screenWidth / (totalSeatsInRow + 3.5),
          height: screenWidth / (totalSeatsInRow + 3.5),
          child: seat.status == SeatStatus.booked
              ? seat.icon
              : Text(
                  seat.seatNo,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget _buildEmptySpace(int totalSeatsInRow, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(width: screenWidth / (totalSeatsInRow + 3.5)),
    );
  }
}
