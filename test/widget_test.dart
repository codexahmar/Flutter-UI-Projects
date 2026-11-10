import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspirational_app_ui/main.dart';

void main() {
  testWidgets('Inspire Hub full interaction flow across all 4 screens', (WidgetTester tester) async {
    // Smartphone viewport for reel/TikTok aspect ratio
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Home Screen Verification (Original UI elevated)
    expect(find.text('Find Your'), findsOneWidget);
    expect(find.text('Inspiration'), findsOneWidget);
    expect(find.text('Promo Today'), findsOneWidget);
    expect(find.text('Best Design'), findsOneWidget);
    expect(find.text('DAILY REFLECTION'), findsOneWidget);

    // 2. Test Shuffle 5 Famous Short Quotes
    expect(find.text('1/5'), findsOneWidget);
    final quoteFinder = find.text('DAILY REFLECTION');
    await tester.tap(quoteFinder);
    await tester.pumpAndSettle();
    expect(find.text('2/5'), findsOneWidget);

    // 3. Test Theme Toggle (Dark/Light)
    final themeIcon = find.byWidgetPredicate(
      (w) => w is Icon && (w.icon == Icons.light_mode_rounded || w.icon == Icons.dark_mode_rounded),
    );
    expect(themeIcon, findsWidgets);
    await tester.tap(themeIcon.first);
    await tester.pumpAndSettle();

    // 4. Test Favorites Tab Navigation
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Saved collection'), findsOneWidget);

    // 5. Test Search / Explore Tab Navigation
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('Fashion'), findsOneWidget);
    expect(find.text('Minimal'), findsOneWidget);

    // 6. Test Profile Tab Navigation
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('alex.vance'), findsOneWidget);
    expect(find.text('Alex Vance'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);

    // 7. Return to Home Tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Best Design'), findsOneWidget);
  });
}
