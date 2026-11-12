import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_tracking/main.dart';
import 'package:ride_tracking/ride_routing.dart';
import 'package:ride_tracking/widgets/car_marker.dart';
import 'package:ride_tracking/widgets/customer_marker.dart';
import 'package:ride_tracking/widgets/ride_bottom_sheet.dart';
import 'package:ride_tracking/widgets/ride_snackbar.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';
import 'package:ride_tracking/widgets/route_step_indicator.dart';

void main() {
  testWidgets(
    'App launches with only Book a ride CTA, runs full trip, car departs after drop-off, and rating returns to Book a ride',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      // Starts idle with only "Book a ride" CTA over the live map.
      expect(find.text('Book a ride'), findsOneWidget);
      expect(find.byType(RideBottomSheet), findsNothing);
      expect(find.byType(RideStatusCard), findsNothing);
      expect(find.byType(RouteStepIndicator), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('You'), findsOneWidget);
      expect(find.byType(CustomerMarker), findsNWidgets(3));
      expect(find.byType(CarMarker), findsNWidgets(3));

      // Tapping map while idle keeps landing screen minimal until "Book a ride" is tapped.
      await tester.tapAt(const Offset(240, 220));
      await tester.pump();
      expect(find.byType(RideBottomSheet), findsNothing);

      // Tapping "Book a ride" reveals route selection UI.
      await tester.tap(find.text('Book a ride'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(RideBottomSheet), findsOneWidget);
      expect(find.byType(RideStatusCard), findsOneWidget);
      expect(find.byType(RouteStepIndicator), findsOneWidget);
      expect(find.text('Set destination'), findsOneWidget);
      expect(find.text('Choose destination'), findsOneWidget);

      // Presets dynamically recalculate fare based on route distance.
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

      // Tapping Gulberg Park updates pickup, lowers fare, and triggers notification snackbar.
      await tester.tap(find.text('Pickup'));
      await tester.pump();
      expect(find.text('Set pickup point'), findsOneWidget);
      await tester.tapAt(const Offset(240, 220));
      await tester.pump();

      final snappedPickup = RideRouting.snapToRoad(const Offset(0.3, 220 / 600));
      final updatedPlan = RideRouting.planRoute(
        snappedPickup.point,
        dhaPreset.point,
      );
      expect(snappedPickup.label, 'Gulberg Park');
      expect(find.text('Gulberg Park'), findsOneWidget);
      expect(find.byType(RideSnackbar), findsOneWidget);
      expect(find.text('Pickup updated'), findsOneWidget);
      expect(find.text('At Gulberg Park'), findsOneWidget);
      expect(updatedPlan.farePkr, lessThan(longPlan.farePkr));
      expect(
        find.text('Find drivers · PKR ${updatedPlan.farePkr}'),
        findsOneWidget,
      );

      // Searching finds a driver and pauses in matched preview awaiting confirmation.
      await tester.tap(find.text('Find drivers · PKR ${updatedPlan.farePkr}'));
      await tester.pump();
      expect(find.text('Finding drivers'), findsOneWidget);
      expect(find.text('Matching you nearby'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 2200));
      await tester.pump();
      expect(find.text('Driver found'), findsOneWidget);
      expect(find.text('Driver found nearby'), findsOneWidget);
      expect(find.text('Ahsan Malik'), findsOneWidget);
      expect(find.byType(CarMarker), findsNWidgets(4));
      expect(find.text('Cancel'), findsOneWidget);
      expect(
        find.text('Book ride · PKR ${updatedPlan.farePkr}'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Driver found'), findsOneWidget);

      await tester.tap(find.text('Book ride · PKR ${updatedPlan.farePkr}'));
      await tester.pump();
      expect(find.text('Driver on the way'), findsOneWidget);
      expect(find.text('Ride booked'), findsOneWidget);

      // Communication uses custom top notification snackbar with zero Material SnackBar.
      await tester.tap(find.text('Message'));
      await tester.pump();
      expect(find.text('Message sent'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);

      await tester.tap(find.text('Call driver'));
      await tester.pump();
      expect(find.text('Calling Ahsan Malik…'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);

      // Approach progresses to arriving soon and driver arrival without "Ahsan is waiting".
      await tester.pump(const Duration(milliseconds: 5600));
      expect(find.text('Arriving soon'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1600));
      expect(find.text('Driver arrived'), findsOneWidget);
      expect(find.text('PIN 4920'), findsOneWidget);
      expect(find.text('Driver has arrived'), findsOneWidget);
      expect(find.textContaining('waiting'), findsNothing);
      expect(find.text("I'm coming"), findsOneWidget);

      // Boarding drives to drop-off, then driver's car drives away cleanly.
      await tester.tap(find.text("I'm coming"));
      await tester.pump();
      expect(find.text('Boarding RideX'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('To ${dhaPreset.label}'), findsOneWidget);

      await tester.pump(const Duration(seconds: 7));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('You arrived'), findsOneWidget);
      expect(find.text('You have arrived'), findsOneWidget);
      expect(find.byType(CarMarker), findsNWidgets(4));
      final departStart = tester.getCenter(find.byType(CarMarker).last);

      await tester.pump(const Duration(milliseconds: 1200));
      final departMid = tester.getCenter(find.byType(CarMarker).last);
      expect((departMid - departStart).distance, greaterThan(5.0));

      await tester.pump(const Duration(milliseconds: 1600));
      expect(find.byType(CarMarker), findsNWidgets(3));

      // Submitting a rating collapses sheet directly back to "Book a ride" with thank-you notice.
      await tester.tap(find.byTooltip('Rate 4 stars'));
      await tester.pump();
      await tester.tap(find.text('Submit rating'));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(RideBottomSheet), findsNothing);
      expect(find.byType(RideStatusCard), findsNothing);
      expect(find.text('Book a ride'), findsOneWidget);
      expect(find.text('Thanks for rating Ahsan'), findsOneWidget);
      expect(find.text('Rated Ahsan Malik 4 of 5'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Thanks for rating Ahsan'), findsNothing);
    },
  );

  testWidgets(
    'Skipping rating collapses bottom sheet cleanly to Book a ride CTA',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Book a ride'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(
        find.widgetWithText(ChoiceChip, RideRouting.presets[0].label),
      );
      await tester.pump();
      await tester.tap(find.textContaining('Find drivers'));
      await tester.pump(const Duration(milliseconds: 2200));
      await tester.pump();

      await tester.tap(find.textContaining('Book ride'));
      await tester.pump(const Duration(milliseconds: 7200));
      await tester.tap(find.text("I'm coming"));
      await tester.pump(const Duration(milliseconds: 9200));
      expect(find.text('Skip'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 2700));
      await tester.tap(find.text('Skip'));
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.byType(RideBottomSheet), findsNothing);
      expect(find.byType(RideStatusCard), findsNothing);
      expect(find.text('Book a ride'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
    },
  );

  testWidgets(
    'Cancelling a matched driver returns cleanly to route selection',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Book a ride'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(
        find.widgetWithText(ChoiceChip, RideRouting.presets[0].label),
      );
      await tester.pump();
      await tester.tap(find.textContaining('Find drivers'));
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 2200));
      await tester.pump();
      expect(find.text('Driver found'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pump();
      expect(find.text('Ride request cancelled'), findsOneWidget);
      expect(find.text('Choose destination'), findsNothing);
      expect(find.textContaining('Find drivers'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Ride request cancelled'), findsNothing);
    },
  );
}
