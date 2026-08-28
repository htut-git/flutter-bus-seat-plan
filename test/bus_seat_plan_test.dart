import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bus_seat_plan/bus_seat_plan.dart';

void main() {
  group('LayoutParser & SeatLayout', () {
    test('parses simple 2+2 layout accurately', () {
      final layout = SeatLayout.fromStrings([
        'ss_ss',
        'ss_ss',
        'vv_vv',
      ]);

      expect(layout.decks.length, 1);
      expect(layout.primaryDeck.rowCount, 3);
      expect(layout.totalSeatCount, 12);
      expect(layout.vipSeats.length, 4);
      expect(layout.availableSeats.length, 12);

      final firstSeat = layout.findSeatById('0_1_1');
      expect(firstSeat, isNotNull);
      expect(firstSeat!.label, '1A');
    });

    test('parses sleeper and special status characters', () {
      final layout = SeatLayout.fromStrings([
        'll_ll',
        'bx_rd',
        'ff_ss',
      ]);

      expect(layout.sleeperSeats.length, 4);
      expect(layout.bookedSeats.length, 2);
      expect(layout.reservedSeats.length, 1);
      expect(layout.disabledSeats.length, 1);
      expect(layout.femaleOnlySeats.length, 2);
    });

    test('supports multi-deck layouts', () {
      final layout = SeatLayout.multiDeckFromStrings(
        lowerDeckMap: ['ss_ss', 'ss_ss'],
        upperDeckMap: ['ll_ll', 'll_ll'],
        lowerDeckName: 'Lower Coach',
        upperDeckName: 'Upper Sleeper',
      );

      expect(layout.isMultiDeck, isTrue);
      expect(layout.decks.length, 2);
      expect(layout.decks[0].name, 'Lower Coach');
      expect(layout.decks[1].name, 'Upper Sleeper');
      expect(layout.decks[1].driverPosition, DriverPosition.none);
    });
  });

  group('SeatPlanController', () {
    test('handles selection and deselection', () {
      final controller = SeatPlanController();
      const seat = Seat(id: '1_1', label: '1A');

      expect(controller.isSelected(seat), isFalse);

      final selected = controller.select(seat);
      expect(selected, isTrue);
      expect(controller.isSelected(seat), isTrue);
      expect(controller.selectedCount, 1);

      final deselected = controller.deselect(seat);
      expect(deselected, isTrue);
      expect(controller.isSelected(seat), isFalse);
      expect(controller.selectedCount, 0);
    });

    test('enforces maxSelectedSeats limit', () {
      bool limitReached = false;
      final controller = SeatPlanController(
        maxSelectedSeats: 2,
        onMaxSeatsReached: () => limitReached = true,
      );

      const seat1 = Seat(id: '1_1', label: '1A', price: 20.0);
      const seat2 = Seat(id: '1_2', label: '1B', price: 20.0);
      const seat3 = Seat(id: '1_3', label: '1C', price: 20.0);

      expect(controller.select(seat1), isTrue);
      expect(controller.select(seat2), isTrue);
      expect(controller.select(seat3), isFalse);
      expect(limitReached, isTrue);
      expect(controller.selectedCount, 2);
      expect(controller.totalPrice, 40.0);
    });

    test('supports runtime dynamic status overrides', () {
      final controller = SeatPlanController();
      const seat = Seat(id: '1_1', label: '1A', status: SeatStatus.available);

      controller.overrideSeatStatus('1_1', SeatStatus.booked);
      expect(controller.getEffectiveStatus(seat), SeatStatus.booked);

      // Booked seats should not be selectable
      expect(controller.select(seat), isFalse);
    });
  });

  group('BusSeatPlan Widget (v3 API)', () {
    testWidgets('renders minimalist usage with only layout and tap callback', (tester) async {
      final layout = SeatLayout.fromStrings([
        'ss_ss',
        'ss_ss',
      ]);

      Seat? tappedSeat;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlan(
              seatLayout: layout,
              onSeatTap: (seat) => tappedSeat = seat,
            ),
          ),
        ),
      );

      expect(find.byType(BusSeatPlan), findsOneWidget);
      expect(find.text('1A'), findsOneWidget);
      expect(find.text('2D'), findsOneWidget);

      await tester.tap(find.text('1A'));
      await tester.pumpAndSettle();

      expect(tappedSeat, isNotNull);
      expect(tappedSeat!.label, '1A');
    });

    testWidgets('supports theme customization and vector seat rendering', (tester) async {
      final layout = SeatLayout.fromStrings([
        'vv_vv',
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlan(
              seatLayout: layout,
              theme: BusSeatThemeData.luxury(),
            ),
          ),
        ),
      );

      expect(find.byType(BusSeatPlan), findsOneWidget);
      expect(find.text('VIP'), findsOneWidget); // In legend
    });

    testWidgets('switches decks smoothly in multi-deck layout', (tester) async {
      final layout = SeatLayout.multiDeckFromStrings(
        lowerDeckMap: ['ss_ss'],
        upperDeckMap: ['ll_ll'],
        lowerDeckName: 'Lower Standard',
        upperDeckName: 'Upper Sleeper',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlan(
              seatLayout: layout,
            ),
          ),
        ),
      );

      expect(find.text('Lower Standard'), findsOneWidget);
      expect(find.text('Upper Sleeper'), findsOneWidget);
      expect(find.text('1A'), findsOneWidget);

      // Tap to switch to upper deck
      await tester.tap(find.text('Upper Sleeper'));
      await tester.pumpAndSettle();

      expect(find.text('U1A'), findsOneWidget);
    });

    testWidgets('supports custom seatBuilder', (tester) async {
      final layout = SeatLayout.fromStrings(['ss_ss']);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlan(
              seatLayout: layout,
              seatBuilder: (context, seat, status, theme) {
                return Text('Custom-${seat.label}');
              },
            ),
          ),
        ),
      );

      expect(find.text('Custom-1A'), findsOneWidget);
    });
  });

  group('Legacy BusSeatPlanWidget Adapter', () {
    testWidgets('renders legacy API without errors', (tester) async {
      const seatMap = [
        'ss_ss',
        'ss_ss',
      ];

      Seat? selectedSeat;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusSeatPlanWidget(
              seatMap: seatMap,
              onSeatSelect: (seat) => selectedSeat = seat,
              seatNoBuilder: (row, col) => 'S$row-$col',
            ),
          ),
        ),
      );

      expect(find.text('S1-1'), findsOneWidget);
      await tester.tap(find.text('S1-1'));
      await tester.pumpAndSettle();

      expect(selectedSeat, isNotNull);
      expect(selectedSeat!.label, 'S1-1');
    });
  });
}
