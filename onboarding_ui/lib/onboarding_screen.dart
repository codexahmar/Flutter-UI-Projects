import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:onboarding_ui/app_theme.dart';
import 'package:onboarding_ui/onboarding_slides.dart';
import 'package:onboarding_ui/widgets/onboarding_complete_sheet.dart';
import 'package:onboarding_ui/widgets/onboarding_footer.dart';
import 'package:onboarding_ui/widgets/onboarding_page.dart';
import 'package:onboarding_ui/widgets/onboarding_top_bar.dart';
import 'package:onboarding_ui/widgets/swipe_handle.dart';

/// Full-screen liquid-swipe onboarding flow for UIForge AI.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LiquidController _liquidController = LiquidController();
  int _currentPage = 0;

  void _goToPage(int index) {
    final target = index.clamp(0, kOnboardingSlides.length - 1);
    if (target == _currentPage) return;
    _liquidController.animateToPage(page: target, duration: 480);
  }

  void _showCompletionSheet() {
    HapticFeedback.mediumImpact();
    final palette = kOnboardingSlides[_currentPage].palette;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OnboardingCompleteSheet(
        accentColor: palette.accent,
        onReplay: () => _goToPage(0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final activePalette = kOnboardingSlides[_currentPage].palette;
    final totalPages = kOnboardingSlides.length;

    final pages = List<Widget>.generate(totalPages, (index) {
      return OnboardingPage(
        key: ValueKey(index),
        slide: kOnboardingSlides[index],
        index: index,
        totalPages: totalPages,
        isActive: index == _currentPage,
      );
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: activePalette.canvas,
        body: Stack(
          children: [
            LiquidSwipe(
              pages: pages,
              liquidController: _liquidController,
              enableLoop: false,
              fullTransitionValue: 560,
              waveType: WaveType.liquidReveal,
              enableSideReveal: true,
              positionSlideIcon: 0.42,
              slideIconWidget: SwipeHandle(palette: activePalette),
              onPageChangeCallback: (index) {
                if (index != _currentPage) {
                  setState(() => _currentPage = index);
                }
              },
            ),
            Positioned(
              top: padding.top + OnboardingSpacing.md,
              left: OnboardingSpacing.xl,
              right: OnboardingSpacing.xl,
              child: OnboardingTopBar(
                palette: activePalette,
                showSkip: _currentPage < totalPages - 1,
                onSkip: () => _goToPage(totalPages - 1),
              ),
            ),
            Positioned(
              left: OnboardingSpacing.xl,
              right: OnboardingSpacing.xl,
              bottom: padding.bottom + OnboardingSpacing.lg,
              child: OnboardingFooter(
                currentPage: _currentPage,
                totalPages: totalPages,
                palette: activePalette,
                onSelectPage: _goToPage,
                onNext: () => _goToPage(_currentPage + 1),
                onComplete: _showCompletionSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

