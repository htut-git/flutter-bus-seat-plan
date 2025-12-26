import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bus_seat_plan/bus_seat_plan.dart';

void main() {
  group('BusSeatPlanWidget', () {
    const seatMap = [
      'ss_ss',
      'ss_ss',
      'ss__ss',
    ];

    String seatNoBuilder(int row, int col) {
      return 'S$row-$col';
    }

    testWidgets('renders correctly with the given seat map', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlanWidget(
              seatMap: seatMap,
              onSeatSelect: (seat) {},
              seatNoBuilder: seatNoBuilder,
            ),
          ),
        ),
      );

      expect(find.byType(BusSeatPlanWidget), findsOneWidget);
      expect(find.text('S1-1'), findsOneWidget);
      expect(find.text('S3-4'), findsOneWidget);
    });

    testWidgets('handles seat selection', (WidgetTester tester) async {
      Seat? selectedSeat;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlanWidget(
              seatMap: seatMap,
              onSeatSelect: (seat) {
                selectedSeat = seat;
              },
              seatNoBuilder: seatNoBuilder,
            ),
          ),
        ),
      );

      await tester.tap(find.text('S1-1'));
      await tester.pump();

      expect(selectedSeat, isNotNull);
      expect(selectedSeat!.seatNo, 'S1-1');
    });

    testWidgets('displays booked seats correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlanWidget(
              seatMap: seatMap,
              onSeatSelect: (seat) {},
              seatNoBuilder: seatNoBuilder,
              bookedSeats: [
                BookedSeat(
                  rawIds: ['1_1'],
                  icon: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

      final seatFinder = find.byWidgetPredicate((widget) {
        if (widget is InkWell) {
          final container = widget.child as Container;
          final boxDecoration = container.decoration as BoxDecoration;
          return boxDecoration.color == const SeatStatusColor().bookedColor;
        }
        return false;
      });
      expect(seatFinder, findsOneWidget);
    });

    testWidgets('displays reserved seats correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlanWidget(
              seatMap: seatMap,
              onSeatSelect: (seat) {},
              seatNoBuilder: seatNoBuilder,
              reservedSeats: ['1_2'],
            ),
          ),
        ),
      );

      final seatFinder = find.byWidgetPredicate((widget) {
        if (widget is InkWell) {
          final container = widget.child as Container;
          final boxDecoration = container.decoration as BoxDecoration;
          return boxDecoration.color == const SeatStatusColor().reservedColor;
        }
        return false;
      });
      expect(seatFinder, findsOneWidget);
    });

    testWidgets('displays disabled seats correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlanWidget(
              seatMap: seatMap,
              onSeatSelect: (seat) {},
              seatNoBuilder: seatNoBuilder,
              disabledSeats: ['1_4'],
            ),
          ),
        ),
      );

      final seatFinder = find.byWidgetPredicate((widget) {
        if (widget is InkWell) {
          final container = widget.child as Container;
          final boxDecoration = container.decoration as BoxDecoration;
          return boxDecoration.color == const SeatStatusColor().disabledColor;
        }
        return false;
      });
      expect(seatFinder, findsOneWidget);
    });

    testWidgets('displays selected seats correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlanWidget(
              seatMap: seatMap,
              onSeatSelect: (seat) {},
              seatNoBuilder: seatNoBuilder,
              selectedSeats: [const Seat(seatNo: 'S2-1', rawNo: '2_1')],
            ),
          ),
        ),
      );

      final seatFinder = find.byWidgetPredicate((widget) {
        if (widget is InkWell) {
          final container = widget.child as Container;
          final boxDecoration = container.decoration as BoxDecoration;
          return boxDecoration.color == const SeatStatusColor().selectedColor;
        }
        return false;
      });

      expect(seatFinder, findsOneWidget);
    });
  });
}
