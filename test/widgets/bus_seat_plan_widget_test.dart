import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bus_seat_plan/bus_seat_plan.dart';

/// Test suite for BusSeatPlanWidget
/// Testing library/framework: flutter_test (WidgetTester), with MaterialApp scaffold.
///
/// These tests focus on:
/// - Rendering with empty and non-empty seat maps
/// - Correct invocation of customTopWidget with expected grid count
/// - Seat status mapping to background colors for blocked/reserved/booking/canBuy/booked
/// - onTap callback behavior when clickSeat is provided vs null
/// - Seat sizing respects maxScreenWidth cap
///
/// Note: We avoid asserting behavior requiring equality semantics of SeatPlanModal
/// (e.g., selectedSeats highlighting or callBackSelectedSeatCannotBuy), because equality
/// details are not guaranteed here.

Widget _wrap(Widget child, {Size size = const Size(800, 600)}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

String _seatNoBuilder(int r, int c) => 'R${r}C$c';

void main() {
  group('BusSeatPlanWidget', () {
    testWidgets('renders "SeatPlan Not Found" when seatMap is empty', (tester) async {
      final widget = BusSeatPlanWidget(
        seatMap: const [],
        customTopWidget: (gridCount) => const SizedBox(),
        seatNoBuilder: _seatNoBuilder,
      );
      await tester.pumpWidget(_wrap(widget));
      expect(find.text('SeatPlan Not Found'), findsOneWidget);
    });

    testWidgets('invokes customTopWidget with correct gridCount (columns of first row)', (tester) async {
      int? receivedGridCount;
      final widget = BusSeatPlanWidget(
        seatMap: const ['ss_ss'],
        customTopWidget: (gridCount) {
          receivedGridCount = gridCount;
          return const SizedBox(key: Key('top'));
        },
        seatNoBuilder: _seatNoBuilder,
      );
      await tester.pumpWidget(_wrap(widget));
      expect(find.byKey(const Key('top')), findsOneWidget);
      expect(receivedGridCount, 5, reason: 'Row "ss_ss" has 5 columns including spacer');
    });

    testWidgets('displays seat numbers from seatNoBuilder for canBuy seats', (tester) async {
      final widget = BusSeatPlanWidget(
        seatMap: const ['s'],
        customTopWidget: (_) => const SizedBox(),
        seatNoBuilder: _seatNoBuilder,
      );
      await tester.pumpWidget(_wrap(widget));
      expect(find.text('R1C1'), findsOneWidget);
    });

    testWidgets('onTap is null when clickSeat not provided, enabled when provided', (tester) async {
      // Without clickSeat
      await tester.pumpWidget(_wrap(BusSeatPlanWidget(
        seatMap: const ['s'],
        customTopWidget: (_) => const SizedBox(),
        seatNoBuilder: _seatNoBuilder,
      )));
      final ink1 = tester.widget<InkWell>(find.byType(InkWell).first);
      expect(ink1.onTap, isNull);

      // With clickSeat
      SeatPlanModal? tapped;
      await tester.pumpWidget(_wrap(BusSeatPlanWidget(
        seatMap: const ['s'],
        customTopWidget: (_) => const SizedBox(),
        seatNoBuilder: _seatNoBuilder,
        clickSeat: (seat) => tapped = seat,
      )));
      final ink2 = tester.widget<InkWell>(find.byType(InkWell).first);
      expect(ink2.onTap, isNotNull);
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      expect(tapped, isNotNull);
      expect(tapped\!.seatNo, 'R1C1');
      expect(tapped\!.rawNo, '1_1');
    });

    testWidgets('caps seat size using maxScreenWidth', (tester) async {
      // Physical screen width is 800; cap to 200
      final widget = BusSeatPlanWidget(
        seatMap: const ['ss'],
        customTopWidget: (_) => const SizedBox(),
        seatNoBuilder: _seatNoBuilder,
        maxScreenWidth: 200,
      );
      await tester.pumpWidget(_wrap(widget, size: const Size(800, 600)));

      // Find the first seat Container and check its size
      final container = tester.widget<Container>(
        find.descendant(of: find.byType(InkWell).first, matching: find.byType(Container)).first,
      );
      final box = container.decoration as BoxDecoration;
      expect(box.borderRadius, isNotNull);

      // The seat's width is screenWidth / (totalLength + 3.5) where totalLength=2
      // With cap to 200: expected = 200 / (2 + 3.5) = 200 / 5.5 ≈ 36.36
      final size = tester.getSize(find.byType(Container).first);
      expect(size.width, closeTo(200 / 5.5, 0.6));
      expect(size.height, closeTo(200 / 5.5, 0.6));
    });

    testWidgets('maps status colors correctly for blocked, reserved, booking, booked, canBuy', (tester) async {
      final defaults = SeatStatusColor(); // default colors used by widget

      // Build a map with 5 seats in a single row
      // raw positions: 1_1, 1_2, 1_3, 1_4, 1_5
      final widget = BusSeatPlanWidget(
        seatMap: const ['sssss'],
        customTopWidget: (_) => const SizedBox(),
        seatNoBuilder: _seatNoBuilder,
        blockedSeats: const ['1_1'],
        reserveSeats: const ['1_2'],
        bookingSeats: const ['1_3'],
        // Booked seat via BookedSeatModal at 1_4; also provides a custom icon
        bookedSeats: [
          BookedSeatModal(
            rawIds: const ['1_4'],
            icon: const Icon(Icons.lock, key: Key('bookedIcon')),
          ),
        ],
      );
      await tester.pumpWidget(_wrap(widget));

      final allContainers = tester.widgetList<Container>(
        find.descendant(of: find.byType(InkWell), matching: find.byType(Container)),
      ).toList(growable: false);

      Color? bgColorOf(int index) {
        final box = allContainers[index].decoration as BoxDecoration;
        return box.color;
      }

      // Seat indices correspond to column order 0..4
      expect(bgColorOf(0), equals(defaults.blockedColor), reason: '1_1 blocked');
      expect(bgColorOf(1), equals(defaults.reserveColor), reason: '1_2 reserved');
      expect(bgColorOf(2), equals(defaults.bookingColor), reason: '1_3 booking');
      expect(bgColorOf(3), equals(defaults.bookedColor), reason: '1_4 booked');
      expect(bgColorOf(4), equals(defaults.canBuyColor), reason: '1_5 canBuy');

      // Booked seat should render its icon instead of text
      expect(find.byKey(const Key('bookedIcon')), findsOneWidget);
      expect(find.text('R1C4'), findsNothing);
    });

    testWidgets('renders spacer for non-seat positions with same width as seat', (tester) async {
      final widget = BusSeatPlanWidget(
        seatMap: const ['s_s'],
        customTopWidget: (_) => const SizedBox(),
        seatNoBuilder: _seatNoBuilder,
      );
      await tester.pumpWidget(_wrap(widget));

      // Find seats and the spacer SizedBox in the Row
      final row = find.byType(Row).first;
      final containers = find.descendant(of: row, matching: find.byType(Container));
      final sizedBoxes = find.descendant(of: row, matching: find.byType(SizedBox));

      // There should be 2 seat Containers and at least one SizedBox spacer (excluding the side number and trailing 30px box)
      expect(containers, findsNWidgets(2));

      // Find the spacer that is a direct child with width matching seat width
      final seatSize = tester.getSize(containers.first);
      // The spacer immediately after the first seat has equal width
      final spacer = tester.widgetList<SizedBox>(sizedBoxes).where((sb) => sb.width == seatSize.width).first;
      expect(spacer.width, seatSize.width);
    });
  });
}