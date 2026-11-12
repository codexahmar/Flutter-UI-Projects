import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_food_delivery/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('launches the discovery screen and renders Pakistani fast food', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.pump();

    expect(find.text('Fresh flavors, delivered fast'), findsOneWidget);
    expect(find.text('Featured restaurants'), findsOneWidget);
    expect(find.text('Son of a Bun Smash'), findsOneWidget);
  });
}
