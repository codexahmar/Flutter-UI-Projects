import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_marketplace/main.dart';
import 'package:furniture_marketplace/presentation/screens/product_detail_screen.dart';
import 'package:furniture_marketplace/presentation/widgets/product_image.dart';

void main() {
  testWidgets('Furniture Marketplace smoke test - Banner removed from catalog',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FurnitureMarketplaceApp());
    await tester.pumpAndSettle();

    expect(find.text('Catalog'), findsWidgets);
    expect(find.text('Lounge'), findsWidgets);
    expect(find.text('Office'), findsWidgets);

    // Verify banner is fully removed from main screen
    expect(find.text('Explore'), findsNothing);
    expect(find.text('Exclusive Promo'), findsNothing);
    expect(find.text('Make Space For\nSomething Better'), findsNothing);
  });

  testWidgets('Tapping product opens ProductDetailScreen and arrow button shows Exclusive UI',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FurnitureMarketplaceApp());
    await tester.pumpAndSettle();

    // Scroll until first product ('Strandmon') is visible and tap it
    await tester.scrollUntilVisible(
      find.text('Strandmon'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Strandmon'));
    await tester.pumpAndSettle();

    // Verify ProductDetailScreen is shown
    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(find.text('Strandmon'), findsOneWidget);

    // Tap the arrow indicator button beneath the chair
    await tester.tap(find.byIcon(CupertinoIcons.arrow_left_right));
    await tester.pumpAndSettle();

    // Verify Exclusive Promo UI is now active and visible with refined editorial copy
    expect(find.text('Explore Collection'), findsOneWidget);
    expect(find.text('Sculpted Form,\nEnduring Comfort'), findsOneWidget);

    // Tap back button on HeroPromoScreen to return to product details
    await tester.tap(find.byIcon(CupertinoIcons.arrow_left).first);
    await tester.pumpAndSettle();

    expect(find.text('Buy for \$320'), findsOneWidget);

    // Also verify tapping the (i) info icon in top bar opens Exclusive UI
    await tester.tap(find.byIcon(CupertinoIcons.info));
    await tester.pumpAndSettle();
    expect(find.text('Explore Collection'), findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.arrow_left).first);
    await tester.pumpAndSettle();
  });

  testWidgets('Swiping horizontally on upper section shows Exclusive UI',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FurnitureMarketplaceApp());
    await tester.pumpAndSettle();

    // Open product details
    await tester.scrollUntilVisible(
      find.text('Strandmon'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Strandmon'));
    await tester.pumpAndSettle();

    // Fling horizontally on the upper product showcase
    await tester.fling(find.byType(ProductImage).first, const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    // Verify Exclusive Promo UI is visible
    expect(find.text('Explore Collection'), findsOneWidget);
    expect(find.text('Sculpted Form,\nEnduring Comfort'), findsOneWidget);

    // Tap Explore Collection to return to Catalog
    await tester.tap(find.text('Explore Collection'));
    await tester.pumpAndSettle();

    expect(find.text('Catalog'), findsWidgets);
  });

  testWidgets(
      'Buy button transitions into Continue and shows top in-app notification without emojis',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FurnitureMarketplaceApp());
    await tester.pumpAndSettle();

    // Scroll and tap product to open details
    await tester.scrollUntilVisible(
      find.text('Strandmon'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Strandmon'));
    await tester.pumpAndSettle();

    // Tap the Buy button
    await tester.tap(find.text('Buy for \$320'));
    await tester.pump();

    // Verify notification appeared with authentic text without emoji
    expect(find.text('Purchase Confirmed'), findsOneWidget);
    expect(find.text('1 x Strandmon • \$320'), findsOneWidget);

    // Verify button transitioned to Order Confirmed state
    expect(find.text('Order Confirmed'), findsOneWidget);

    // Verify modal bottom sheet is NOT shown
    expect(find.byType(BottomSheet), findsNothing);

    // Wait for the notification and button transition timer (2.2 seconds)
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();

    // Verify button has smoothly transitioned to "Continue"
    expect(find.text('Continue'), findsOneWidget);

    // Tapping Continue navigates back to Catalog
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Catalog'), findsWidgets);
  });
}
