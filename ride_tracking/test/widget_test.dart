import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_tracking/main.dart';
import 'package:ride_tracking/ride_routing.dart';
import 'package:ride_tracking/widgets/car_marker.dart';
import 'package:ride_tracking/widgets/customer_marker.dart';

void main() {
  testWidgets(
    'Rider selects stops with distance pricing, boards driver, and completes drop-off',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      // Starts in route selection mode with zero share button.
      expect(find.text('Set destination on map'), findsOneWidget);
      expect(find.text('Choose destination'), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsNothing);
      expect(find.byType(CustomerMarker), findsNWidgets(3));
      expect(find.byType(CarMarker), findsNWidgets(3));

      // Selecting different destinations updates price dynamically by route distance.
      final libertyPreset = RideRouting.presets[0];
      final dhaPreset = RideRouting.presets[2];
      final shortPlan = RideRouting.planRoute(
        RideRouting.defaultPickup,
        libertyPreset.point,
      );
      final longPlan = RideRouting.planRoute(
        RideRouting.defaultPickup,
        dhaPreset.point,
      );
      expect(longPlan.farePkr, greaterThan(shortPlan.farePkr));

      await tester.tap(find.widgetWithText(ChoiceChip, libertyPreset.label));
      await tester.pump();
      expect(find.text('Route ready'), findsOneWidget);
      expect(find.text('PKR ${shortPlan.farePkr}'), findsOneWidget);
      expect(
        find.text('Find drivers · PKR ${shortPlan.farePkr}'),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(ChoiceChip, dhaPreset.label));
      await tester.pump();
      expect(find.text('PKR ${longPlan.farePkr}'), findsOneWidget);
      expect(
        find.text('Find drivers · PKR ${longPlan.farePkr}'),
        findsOneWidget,
      );

      // Moving pickup closer via map tap recalculates fare downward.
      await tester.tap(find.text('Pickup'));
      await tester.pump();
      expect(find.text('Set pickup on map'), findsOneWidget);
      await tester.tapAt(const Offset(240, 220));
      await tester.pump();

      final snappedPickup = RideRouting.snapToRoad(const Offset(0.3, 220 / 600));
      final updatedPlan = RideRouting.planRoute(
        snappedPickup.point,
        dhaPreset.point,
      );
      expect(updatedPlan.farePkr, lessThan(longPlan.farePkr));
      expect(
        find.text('Find drivers · PKR ${updatedPlan.farePkr}'),
        findsOneWidget,
      );

      // Start finding nearby drivers.
      await tester.tap(find.text('Find drivers · PKR ${updatedPlan.farePkr}'));
      await tester.pump();
      expect(find.text('Finding your driver'), findsOneWidget);
      expect(find.text('Matching you nearby'), findsOneWidget);
      expect(find.text('Cancel ride'), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsNothing);

      // Advance into matched phase (t = 3.5s / 10s = 0.35).
      await tester.pump(const Duration(milliseconds: 3500));
      expect(find.text('Driver on the way'), findsOneWidget);
      expect(find.text('Ahsan Malik'), findsOneWidget);
      expect(find.text('LEA 4821'), findsOneWidget);
      expect(find.text('Call driver'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
      expect(find.byType(CarMarker), findsNWidgets(4));

      // Advance into arriving phase (t = 6.5s / 10s = 0.65).
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Arriving soon'), findsOneWidget);
      expect(find.text('min'), findsOneWidget);

      // Advance to driver arrival at pickup (t = 10s / 10s = 1.0).
      await tester.pump(const Duration(milliseconds: 3600));
      expect(find.text('Driver has arrived'), findsOneWidget);
      expect(find.text('PIN 4920'), findsOneWidget);
      expect(find.text("I'm coming"), findsOneWidget);

      // Tapping "I'm coming" boards the car and heads to the destination.
      await tester.tap(find.text("I'm coming"));
      await tester.pump();
      expect(find.text('Getting in the car'), findsOneWidget);
      expect(find.text('In car'), findsOneWidget);

      // Advance past boarding into live destination driving (t = 2.0s / 9s).
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('On trip to ${dhaPreset.label}'), findsOneWidget);
      expect(find.text('Heading to ${dhaPreset.label}'), findsOneWidget);

      // Advance to drop-off completion (t = 9.0s / 9.0s).
      await tester.pump(const Duration(seconds: 7));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('You have arrived'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Trip completed'), findsOneWidget);
      expect(find.text('Cash paid'), findsOneWidget);
      expect(find.text('PKR ${updatedPlan.farePkr}'), findsOneWidget);
      expect(find.text('Book another ride'), findsOneWidget);

      // Rate driver and reset to book another ride.
      await tester.tap(find.byTooltip('Rate 4 stars'));
      await tester.pump();
      expect(find.text('Rated Ahsan Malik 4 stars'), findsOneWidget);

      await tester.tap(find.text('Book another ride'));
      await tester.pump();
      expect(find.text('Set destination on map'), findsOneWidget);
      expect(find.text('Choose destination'), findsOneWidget);
    },
  );
}
