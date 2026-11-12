import 'package:flutter_test/flutter_test.dart';
import 'package:ride_tracking/main.dart';
import 'package:ride_tracking/widgets/car_marker.dart';
import 'package:ride_tracking/widgets/radar_pulse.dart';

void main() {
  testWidgets('RideTrackingScreen progresses through ride phases', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Finding a driver'), findsOneWidget);
    expect(find.text('Matching nearby drivers'), findsOneWidget);
    expect(find.byType(RadarPulse), findsOneWidget);
    expect(find.byType(CarMarker), findsNothing);

    // Advance into matched phase (t = 0.30 * 13s = 3.9s).
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Driver matched'), findsOneWidget);
    expect(find.text('Ahsan Malik'), findsOneWidget);
    expect(find.byType(RadarPulse), findsNothing);
    expect(find.byType(CarMarker), findsOneWidget);

    // Advance into arriving phase (t = 8s / 13s ≈ 0.615).
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Driver arriving'), findsOneWidget);
    expect(find.text('min'), findsOneWidget);

    // Tap Call action button.
    await tester.tap(find.byTooltip('Call driver'));
    await tester.pump();
    expect(find.text('Calling Ahsan Malik…'), findsOneWidget);

    // Advance into arrived phase (t = 12.2s / 13s ≈ 0.938).
    await tester.pump(const Duration(milliseconds: 4200));
    expect(find.text('Driver arrived'), findsOneWidget);
    expect(find.text('Here'), findsOneWidget);
  });
}
