import 'package:bus_seat_plan/bus_seat_plan.dart';
import 'package:flutter/material.dart';

class BusSeatPlanWidget extends StatelessWidget {
  final Widget Function(int gridCount)? customTopWidget;
  final List<SeatPlanModal> selectedSeats;
  final List<String> seatMap;
  final List<BookedSeatModal> bookedSeats;
  final List<String> blockedSeats;
  final List<String> reserveSeats;
  final List<String> bookingSeats;
  final SeatStatusColor? seatSetusColor;
  final Function(SeatPlanModal)? clickSeat;
  final Function(SeatPlanModal)? callBackSelectedSeatCannotBuy;
  final String prefix;
  const BusSeatPlanWidget(
      {super.key,
      required this.seatMap,
      this.prefix = 'A',
      this.bookedSeats = const [],
      this.blockedSeats = const [],
      this.reserveSeats = const [],
      this.bookingSeats = const [],
      this.seatSetusColor,
      this.selectedSeats = const [],
      this.clickSeat,
      this.customTopWidget,
      this.callBackSelectedSeatCannotBuy});

  @override
  Widget build(BuildContext context) {
    List<List<List<SeatPlanModal?>>> formattedSeatPlan =
        <List<List<SeatPlanModal?>>>[];

    SeatStatusColor defineSeatSetusColor = SeatStatusColor();

    if (seatSetusColor != null) {
      defineSeatSetusColor = defineSeatSetusColor;
    }

    final screenWidth = MediaQuery.of(context).size.width;

    //Formatting and Checking Seats
    for (var i = 0; i < seatMap.length; i++) {
      final rowIndex = i + 1;
      final seatPlanChildRow = seatMap[i].split('');
      List<SeatPlanModal?> rowSeats = [];
      for (var a = 0; a < seatPlanChildRow.length; a++) {
        final colIndex = a + 1;
        if (seatPlanChildRow[a] == 's') {
          final rawNumber = "${rowIndex}_$colIndex";
          final seatLetter = String.fromCharCode(
              65 + (prefix == "A" ? rowIndex - 1 : colIndex));
          SeatPlanModal seatPlanModal = SeatPlanModal(
              seatNo: prefix == "A"
                  ? '$seatLetter$colIndex'
                  : '$rowIndex$seatLetter',
              rawNo: rawNumber,
              status: SeatStatus.canBuy);
          //checking The Seat Status
          if (blockedSeats.contains(rawNumber)) {
            seatPlanModal.status = SeatStatus.blocked;
          } else if (reserveSeats.contains(rawNumber)) {
            seatPlanModal.status = SeatStatus.reserved;
          } else if (bookingSeats.contains(rawNumber)) {
            seatPlanModal.status = SeatStatus.booking;
          }
          for (var bookSeat in bookedSeats) {
            if (bookSeat.rawIds.contains(rawNumber)) {
              seatPlanModal.status = SeatStatus.booked;
              seatPlanModal.icon = bookSeat.icon;
            }
          }
          rowSeats.add(seatPlanModal);
        } else {
          rowSeats.add(null);
        }
      }
      formattedSeatPlan.add([rowSeats]);
    }

    Widget seatLayout(SeatPlanModal seatPlan, int totalLength) {
      if (seatPlan.status != SeatStatus.canBuy &&
          selectedSeats.contains(seatPlan)) {
        WidgetsBinding.instance.addPersistentFrameCallback((_) {
          if (callBackSelectedSeatCannotBuy != null) {
            callBackSelectedSeatCannotBuy!(seatPlan);
          }
        });
      }
      return Padding(
        padding: EdgeInsets.all(3),
        child: InkWell(
          onTap: clickSeat != null
              ? () {
                  clickSeat!(seatPlan);
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: (() {
                switch (seatPlan.status) {
                  case SeatStatus.booked:
                    return defineSeatSetusColor.bookedColor;
                  case SeatStatus.blocked:
                    return defineSeatSetusColor.blockColor;
                  case SeatStatus.reserved:
                    return defineSeatSetusColor.reserveColor;
                  case SeatStatus.booking:
                    return defineSeatSetusColor.bookingColor;
                  case SeatStatus.canBuy:
                    return selectedSeats.contains(seatPlan)
                        ? defineSeatSetusColor.selectedColor
                        : defineSeatSetusColor.canBuyColor;
                }
              })(),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            width: screenWidth / (totalLength + 3.5),
            height: screenWidth / (totalLength + 3.5),
            child: seatPlan.status == SeatStatus.booked
                ? seatPlan.icon
                : Text(
                    seatPlan.seatNo,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      );
    }

    if (formattedSeatPlan.isEmpty) {
      return Text('SeatPlan Not Found');
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customTopWidget!(formattedSeatPlan.first.first.length),
        for (var i = 0; i < formattedSeatPlan.length; i++)
          for (var seatPlanChildRow in formattedSeatPlan[i])
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 30,
                    child: Text(
                      (i + 1).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                for (var seatPlan in seatPlanChildRow)
                  seatPlan is SeatPlanModal
                      ? seatLayout(seatPlan, seatPlanChildRow.length)
                      : Padding(
                          padding: EdgeInsets.all(3),
                          child: SizedBox(
                              width: screenWidth /
                                  (seatPlanChildRow.length + 3.5)),
                        ),
                SizedBox(width: 30),
              ],
            )
      ],
    );
  }
}
