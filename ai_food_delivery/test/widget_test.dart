import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_food_delivery/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('launches the discovery screen and allows selecting a dish', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.pump();

    expect(find.text('Fresh flavors, delivered fast'), findsOneWidget);
    expect(find.text('Featured restaurants'), findsOneWidget);
    expect(find.text('Black Label Wagyu Burger'), findsOneWidget);
  });
}
