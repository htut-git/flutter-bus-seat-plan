import 'package:bus_seat_plan/bus_seat_plan.dart';
import 'package:flutter/material.dart';

class BusSeatPlanWidget extends StatefulWidget {
  final Widget Function(int gridCount)? customTopWidget;
  final List<SeatPlanModal> selectedSeats;
  final List<String> seatMap;
  final List<SeatPlanModal> bookedSeats;
  final List<String> blockedSeats;
  final List<String> reserveSeats;
  final List<String> bookingSeats;
  final SeatStatusColor? seatStatusColor;
  final double? maxScreenWidth;
  final Function(SeatPlanModal)? clickSeat;
  final String prefix;
  const BusSeatPlanWidget({
    super.key,
    required this.seatMap,
    this.prefix = 'A',
    this.bookedSeats = const [],
    this.blockedSeats = const [],
    this.reserveSeats = const [],
    this.bookingSeats = const [],
    this.seatStatusColor,
    this.selectedSeats = const [],
    this.clickSeat,
    this.customTopWidget,
    this.maxScreenWidth,
  });

  @override
  State<BusSeatPlanWidget> createState() => _BusSeatPlanWidgetState();
}

class _BusSeatPlanWidgetState extends State<BusSeatPlanWidget> {
  List<List<SeatPlanModal?>> formattedSeatPlan = [];

  @override
  void initState() {
    super.initState();
    _generateSeatPlan();
  }

  @override
  void didUpdateWidget(covariant BusSeatPlanWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.seatMap != oldWidget.seatMap ||
        widget.bookedSeats != oldWidget.bookedSeats ||
        widget.blockedSeats != oldWidget.blockedSeats ||
        widget.reserveSeats != oldWidget.reserveSeats ||
        widget.bookingSeats != oldWidget.bookingSeats) {
      _generateSeatPlan();
    }
  }

  void _generateSeatPlan() {
    formattedSeatPlan = [];
    int seatCount = 0;
    final bookedSeatsMap = {for (var seat in widget.bookedSeats) seat.id: seat};
    for (var i = 0; i < widget.seatMap.length; i++) {
      final rowIndex = i + 1;
      final seatPlanChildRow = widget.seatMap[i].split('');
      List<SeatPlanModal?> rowSeats = [];
      for (var a = 0; a < seatPlanChildRow.length; a++) {
        final colIndex = a + 1;
        if (seatPlanChildRow[a] == 's') {
          seatCount++;
          final id = "${rowIndex}_$colIndex";
          String seatNo = "${widget.prefix}$seatCount";
          SeatPlanModal seatPlanModal = SeatPlanModal(seatNumber: seatNo, id: id, status: SeatStatus.canBuy);

          if (widget.blockedSeats.contains(id)) {
            seatPlanModal.status = SeatStatus.blocked;
          } else if (widget.reserveSeats.contains(id)) {
            seatPlanModal.status = SeatStatus.reserved;
          } else if (widget.bookingSeats.contains(id)) {
            seatPlanModal.status = SeatStatus.booking;
          }

          if (bookedSeatsMap.containsKey(id)) {
            final bookSeat = bookedSeatsMap[id]!;
            seatPlanModal = SeatPlanModal(
              seatNumber: seatNo,
              id: id,
              status: SeatStatus.booked,
              icon: bookSeat.icon,
            );
          }
          rowSeats.add(seatPlanModal);
        } else {
          rowSeats.add(null);
        }
      }
      formattedSeatPlan.add(rowSeats);
    }
  }

  @override
  Widget build(BuildContext context) {
    SeatStatusColor defineseatStatusColor = widget.seatStatusColor ?? SeatStatusColor();
    double screenWidth = MediaQuery.of(context).size.width;
    if (widget.maxScreenWidth != null && widget.maxScreenWidth! < screenWidth) {
      screenWidth = widget.maxScreenWidth!;
    }

    Widget seatLayout(SeatPlanModal seatPlan, int totalLength) {
      return Padding(
        padding: const EdgeInsets.all(3),
        child: InkWell(
          onTap: widget.clickSeat != null
              ? () {
                  widget.clickSeat!(seatPlan);
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: (() {
                switch (seatPlan.status) {
                  case SeatStatus.booked:
                    return defineseatStatusColor.bookedColor;
                  case SeatStatus.blocked:
                    return defineseatStatusColor.blockColor;
                  case SeatStatus.reserved:
                    return defineseatStatusColor.reserveColor;
                  case SeatStatus.booking:
                    return defineseatStatusColor.bookingColor;
                  case SeatStatus.canBuy:
                    return widget.selectedSeats.contains(seatPlan)
                        ? defineseatStatusColor.selectedColor
                        : defineseatStatusColor.canBuyColor;
                }
              })(),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            width: screenWidth / (totalLength + 3.5),
            height: screenWidth / (totalLength + 3.5),
            child: seatPlan.status == SeatStatus.booked
                ? seatPlan.icon ?? const SizedBox.shrink()
                : Text(
                    seatPlan.seatNumber,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      );
    }

    if (formattedSeatPlan.isEmpty) {
      return const Text('SeatPlan Not Found');
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.customTopWidget != null) widget.customTopWidget!(formattedSeatPlan.first.length),
        for (var i = 0; i < formattedSeatPlan.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 30,
                  child: Text(
                    (i + 1).toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              for (var seatPlan in formattedSeatPlan[i])
                seatPlan is SeatPlanModal
                    ? seatLayout(seatPlan, formattedSeatPlan[i].length)
                    : Padding(
                        padding: const EdgeInsets.all(3),
                        child: SizedBox(width: screenWidth / (formattedSeatPlan[i].length + 3.5)),
                      ),
              const SizedBox(width: 30),
            ],
          )
      ],
    );
  }
}
