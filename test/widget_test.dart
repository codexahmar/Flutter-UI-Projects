import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:crpyto_portfolio/core/theme/app_theme_controller.dart';
import 'package:crpyto_portfolio/main.dart';

void main() {
  testWidgets('App shell smoke test and crypto features', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final themeController = AppThemeController();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeController,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify navigation tabs
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Markets'), findsWidgets);
    expect(find.text('Portfolio'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);

    // Verify Web3 Crypto Wallet card elements
    expect(find.text('Ethereum Mainnet'), findsOneWidget);
    expect(find.text('0x71C8...49B2'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Receive'), findsOneWidget);
    expect(find.text('Buy'), findsOneWidget);
    expect(find.text('Swap'), findsOneWidget);

    // Verify Analytics Timeframe Selector
    expect(find.text('24H'), findsOneWidget);
    expect(find.text('1W'), findsOneWidget);
    expect(find.text('1M'), findsOneWidget);
    expect(find.text('1Y'), findsOneWidget);
    expect(find.text('ALL'), findsOneWidget);

    // Test switching timeframe
    await tester.tap(find.text('24H'));
    await tester.pumpAndSettle();
    expect(find.text('Performance (24H)'), findsOneWidget);

    await tester.tap(find.text('1M'));
    await tester.pumpAndSettle();
    expect(find.text('Performance (1M)'), findsOneWidget);

    // Test Theme Toggle Switch
    final themeToggleFinder = find.byTooltip('Switch to Light mode');
    expect(themeToggleFinder, findsOneWidget);
    await tester.tap(themeToggleFinder);
    await tester.pumpAndSettle();

    expect(themeController.preference, AppThemePreference.light);
  });
}
