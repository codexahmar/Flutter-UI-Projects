import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding_ui/data/onboarding_slides.dart';
import 'package:onboarding_ui/main.dart';

Future<void> _pumpTransition(WidgetTester tester) async {
  for (var i = 0; i < 14; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Onboarding renders initial slide and supports Next navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UIForgeApp());
    await tester.pump();

    expect(find.text('UIForge AI'), findsOneWidget);
    expect(find.text(kOnboardingSlides[0].title), findsOneWidget);
    expect(find.text('01 · ${kOnboardingSlides[0].stageLabel}'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await _pumpTransition(tester);

    expect(find.text(kOnboardingSlides[1].title), findsOneWidget);
    expect(find.text('02 · ${kOnboardingSlides[1].stageLabel}'), findsOneWidget);
  });

  testWidgets('Skip jumps to final slide and opens completion sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UIForgeApp());
    await tester.pump();

    await tester.tap(find.text('Skip'));
    await _pumpTransition(tester);

    expect(find.text(kOnboardingSlides.last.title), findsOneWidget);
    expect(find.text('Start building'), findsOneWidget);

    await tester.tap(find.text('Start building'));
    await _pumpTransition(tester);

    expect(find.text('Workspace ready'), findsOneWidget);
    expect(find.text('Replay tour'), findsOneWidget);

    await tester.tap(find.text('Replay tour'));
    await _pumpTransition(tester);

    expect(find.text(kOnboardingSlides[0].title), findsOneWidget);
  });
}
