import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Showcase app loads tabs and selects seats', (tester) async {
    await tester.pumpWidget(const BusSeatPlanShowcaseApp());
    await tester.pumpAndSettle();

    expect(find.text('Bus Seat Plan 3.0'), findsOneWidget);
    expect(find.text('2+2 Express'), findsOneWidget);
    expect(find.text('2+1 VIP Club'), findsOneWidget);
    expect(find.text('1+1+1 Sleeper'), findsOneWidget);
    expect(find.text('Double Decker'), findsOneWidget);

    // Tap on seat 1A to select it
    await tester.tap(find.text('1A'));
    await tester.pumpAndSettle();

    // Confirm that Selected (1/4) updates
    expect(find.textContaining('Selected (1/4):'), findsOneWidget);

    // Switch tab to 2+1 VIP Club
    await tester.tap(find.text('2+1 VIP Club'));
    await tester.pumpAndSettle();

    // Switch theme to Luxury Gold
    await tester.tap(find.text('Luxury Gold'));
    await tester.pumpAndSettle();
  });
}
