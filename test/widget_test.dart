import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspirational_app_ui/main.dart';

void main() {
  testWidgets('Pinterest clone full interaction and navigation flow', (WidgetTester tester) async {
    // Smartphone viewport for reel/TikTok aspect ratio (iPhone 14/15 Pro)
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    // Pump and settle to let initial shimmer skeleton resolve
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    // 1. Home Feed Verification (Pinterest Official Header + Brand)
    expect(find.text('Pinterest'), findsOneWidget);
    expect(find.byTooltip('Create Pin'), findsOneWidget);

    // 2. Test Pin Detail View with Same Category Recommendations
    final pinFinder = find.text('Autumn tailored oversized trench styling');
    expect(pinFinder, findsOneWidget);
    await tester.tap(pinFinder);
    await tester.pumpAndSettle();

    // Verify Pin Detail Modal Elements
    expect(find.text('Elena Mode'), findsWidgets);
    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('View'), findsOneWidget);
    expect(find.text('Save'), findsWidgets);
    expect(find.text('More like this'), findsOneWidget);

    // Close Pin Detail Modal
    final closeBtn = find.byIcon(Icons.close_rounded);
    expect(closeBtn, findsOneWidget);
    await tester.tap(closeBtn);
    await tester.pumpAndSettle();

    // 3. Test Search Screen (Tab Index 1)
    final searchTab = find.byTooltip('Search');
    await tester.tap(searchTab);
    await tester.pumpAndSettle();
    expect(find.text('Search for ideas…'), findsOneWidget);
    expect(find.text('Ideas for you'), findsOneWidget);
    expect(find.text('Popular on Pinterest'), findsOneWidget);

    // 4. Test Create Pin Modal (Tab Index 2)
    final createTab = find.byTooltip('Create');
    await tester.tap(createTab);
    await tester.pumpAndSettle();
    expect(find.text('Start creating now'), findsOneWidget);
    expect(find.text('Pin'), findsOneWidget);
    expect(find.text('Board'), findsOneWidget);

    // Dismiss Create sheet
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    // 5. Test Updates Screen (Tab Index 3)
    final updatesTab = find.byTooltip('Updates');
    await tester.tap(updatesTab);
    await tester.pumpAndSettle();
    expect(find.text('Updates'), findsOneWidget);

    // 6. Test Profile Screen (Tab Index 4 - User Avatar)
    final profileTab = find.byType(InkWell).last;
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    // Verify Ahmaryar khan Profile Screen
    expect(find.text('Ahmaryar khan'), findsOneWidget);
    expect(find.text('@codexahmar'), findsOneWidget);
    expect(find.text('Software Engineer. I build cool stuff.'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Created'), findsOneWidget);
    expect(find.text('Design System & UI'), findsOneWidget);
    expect(find.text('Streetwear & Fits'), findsOneWidget);

    // Test Theme Toggle in Profile
    final themeToggle = find.byTooltip('Toggle Theme');
    expect(themeToggle, findsOneWidget);
    await tester.tap(themeToggle);
    await tester.pumpAndSettle();

    // 7. Return to Home Tab
    final homeTab = find.byTooltip('Home');
    await tester.tap(homeTab);
    await tester.pumpAndSettle();
    expect(find.text('Pinterest'), findsOneWidget);
  });
}
