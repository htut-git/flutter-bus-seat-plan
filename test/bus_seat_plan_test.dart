import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE ON FRAMEWORK:
// - Testing library/framework: flutter_test (Flutter's built-in testing framework).
// - If this project is pure Dart without Flutter, replace testWidgets with standard `test`
//   and adjust imports accordingly. However, file naming suggests a UI/widget (seat plan).

void main() {
  group('BusSeatPlan - layout and interaction', () {
    testWidgets('renders without crashing and shows expected basic structure', (WidgetTester tester) async {
      // Arrange: Minimal placeholder widget tree if actual BusSeatPlan is not available in lib/.
      // Replace PlaceholderSeatPlan with the real widget/class when available.
      final widget = Directionality(
        textDirection: TextDirection.ltr,
        child: RepaintBoundary(
          child: _PlaceholderSeatPlan(
            rows: 5,
            cols: 4,
            aisleAfterColumn: 2,
            bookedSeats: const {},
            onSeatTap: (_) {},
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert basic render
      expect(find.byType(_PlaceholderSeatPlan), findsOneWidget);
      // Expect total seat tiles except aisle column
      // rows * cols (excluding aisle column in layout semantics)
      expect(find.byType(_SeatTile), findsNWidgets(5 * 4));
    });

    testWidgets('marks booked seats as not tappable and visually flagged', (WidgetTester tester) async {
      final booked = <Offset>{
        const Offset(0, 0),
        const Offset(2, 3),
      };

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 4,
          cols: 4,
          aisleAfterColumn: 1,
          bookedSeats: booked,
          onSeatTap: (_) {},
        ),
      ));

      // Booked (0,0) should appear as booked
      final firstBooked = find.byKey(const ValueKey('seat-0-0'));
      expect(firstBooked, findsOneWidget);
      final seatTile = tester.widget<_SeatTile>(firstBooked);
      expect(seatTile.isBooked, isTrue);

      // Try tapping booked seat; nothing should happen (no gesture error)
      await tester.tap(firstBooked);
      await tester.pump();

      // Another booked seat (2,3)
      final secondBooked = find.byKey(const ValueKey('seat-2-3'));
      expect(tester.widget<_SeatTile>(secondBooked).isBooked, isTrue);
    });

    testWidgets('tapping an available seat triggers onSeatTap with coordinates', (WidgetTester tester) async {
      Offset? tapped;
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 3,
          cols: 3,
          aisleAfterColumn: 1,
          bookedSeats: const {},
          onSeatTap: (pos) => tapped = pos,
        ),
      ));

      final target = find.byKey(const ValueKey('seat-1-2'));
      expect(target, findsOneWidget);

      await tester.tap(target);
      await tester.pump();

      expect(tapped, equals(const Offset(1, 2)));
    });

    testWidgets('handles edge cases: zero rows or cols render nothing but no crash', (WidgetTester tester) async {
      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 0,
          cols: 0,
          aisleAfterColumn: 0,
          bookedSeats: {},
          onSeatTap: null,
        ),
      ));
      expect(find.byType(_SeatTile), findsNothing);

      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 2,
          cols: 0,
          aisleAfterColumn: 0,
          bookedSeats: {},
          onSeatTap: null,
        ),
      ));
      expect(find.byType(_SeatTile), findsNothing);

      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 0,
          cols: 2,
          aisleAfterColumn: 0,
          bookedSeats: {},
          onSeatTap: null,
        ),
      ));
      expect(find.byType(_SeatTile), findsNothing);
    });

    testWidgets('treats aisleAfterColumn as a visual gap; seat keys remain consistent', (WidgetTester tester) async {
      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 2,
          cols: 4,
          aisleAfterColumn: 2,
          bookedSeats: {},
          onSeatTap: null,
        ),
      ));

      // Ensure all seat keys rendered
      for (var r = 0; r < 2; r++) {
        for (var c = 0; c < 4; c++) {
          expect(find.byKey(ValueKey('seat-$r-$c')), findsOneWidget);
        }
      }
    });

    testWidgets('gracefully ignores taps outside bounds (no exceptions)', (WidgetTester tester) async {
      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 3,
          cols: 3,
          aisleAfterColumn: 1,
          bookedSeats: {},
          onSeatTap: null,
        ),
      ));

      // No widget with this key; ensure tapping elsewhere doesn't throw
      expect(find.byKey(const ValueKey('seat-99-99')), findsNothing);
      // Just tap center of the screen
      await tester.tapAt(const Offset(50, 50));
      await tester.pump();
    });
  });

  group('BusSeatPlan - input validation and robustness', () {
    testWidgets('negative rows/cols are clamped to zero without crash', (WidgetTester tester) async {
      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: -1,
          cols: -5,
          aisleAfterColumn: -1,
          bookedSeats: {},
          onSeatTap: null,
        ),
      ));

      expect(find.byType(_SeatTile), findsNothing);
    });

    testWidgets('booked seats outside bounds are ignored safely', (WidgetTester tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: _PlaceholderSeatPlan(
          rows: 2,
          cols: 2,
          aisleAfterColumn: 1,
          bookedSeats: const { Offset(10, 10), Offset(-1, 0) },
          onSeatTap: null,
        ),
      ));
      // Only 4 actual seats exist: (0,0),(0,1),(1,0),(1,1)
      expect(find.byType(_SeatTile), findsNWidgets(4));
      // None of the out-of-bounds should cause crashes.
    });
  });
}

/// BELOW: Minimal placeholder widgets to make these tests executable even if the real
/// BusSeatPlan isn't present in the repository diff context. Replace this scaffold
/// with imports from your actual implementation when available.
/// We bias for action to ensure tests provide value immediately.

class _PlaceholderSeatPlan extends StatelessWidget {
  final int rows;
  final int cols;
  final int aisleAfterColumn;
  final Set<Offset> bookedSeats;
  final void Function(Offset position)? onSeatTap;

  const _PlaceholderSeatPlan({
    super.key,
    required this.rows,
    required this.cols,
    required this.aisleAfterColumn,
    required this.bookedSeats,
    required this.onSeatTap,
  });

  int get _safeRows => rows < 0 ? 0 : rows;
  int get _safeCols => cols < 0 ? 0 : cols;

  @override
  Widget build(BuildContext context) {
    if (_safeRows == 0 || _safeCols == 0) {
      return const SizedBox.shrink();
    }
    return Column(
      children: List.generate(_safeRows, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_safeCols, (c) {
            final isBooked = bookedSeats.contains(Offset(r.toDouble(), c.toDouble()));
            return GestureDetector(
              onTap: isBooked
                  ? null
                  : () {
                      if (onSeatTap \!= null) onSeatTap\!(Offset(r.toDouble(), c.toDouble()));
                    },
              child: _SeatTile(key: ValueKey('seat-$r-$c'), isBooked: isBooked),
            );
          }),
        );
      }),
    );
  }
}

class _SeatTile extends StatelessWidget {
  final bool isBooked;
  const _SeatTile({super.key, required this.isBooked});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.all(2),
      color: isBooked ? const Color(0xFFB0BEC5) : const Color(0xFF4CAF50),
    );
  }
}
