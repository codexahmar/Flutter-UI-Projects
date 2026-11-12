import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding_ui/main.dart';
import 'package:onboarding_ui/onboarding_slides.dart';

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
    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text(kOnboardingSlides[1].title), findsOneWidget);
    expect(find.text('Step 2 of 4'), findsOneWidget);
  });

  testWidgets('Skip jumps to final slide and opens completion sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UIForgeApp());
    await tester.pump();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text(kOnboardingSlides.last.title), findsOneWidget);
    expect(find.text('Step 4 of 4'), findsOneWidget);
    expect(find.text('Start building'), findsOneWidget);

    await tester.tap(find.text('Start building'));
    await tester.pumpAndSettle();

    expect(find.text('Workspace ready'), findsOneWidget);
    expect(find.text('Replay tour'), findsOneWidget);

    await tester.tap(find.text('Replay tour'));
    await tester.pumpAndSettle();

    expect(find.text(kOnboardingSlides[0].title), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);
  });
}
