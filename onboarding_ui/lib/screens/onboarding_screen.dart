import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_ui/data/onboarding_slides.dart';
import 'package:onboarding_ui/models/onboarding_slide.dart';
import 'package:onboarding_ui/theme/app_theme.dart';
import 'package:onboarding_ui/widgets/onboarding_complete_sheet.dart';
import 'package:onboarding_ui/widgets/onboarding_footer.dart';
import 'package:onboarding_ui/widgets/onboarding_slide_view.dart';
import 'package:onboarding_ui/widgets/onboarding_top_bar.dart';

/// Interactive onboarding flow driven continuously by horizontal page physics.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<double> _pageProgress = ValueNotifier<double>(0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_pageController.hasClients) return;
    final page = _pageController.page;
    if (page != null) {
      _pageProgress.value = page.clamp(
        0.0,
        (kOnboardingSlides.length - 1).toDouble(),
      );
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    _pageProgress.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    final target = index.clamp(0, kOnboardingSlides.length - 1);
    if (target == _currentPage) return;
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 520),
      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
    );
  }

  SlidePalette _interpolatedPalette(double page) {
    final floorIndex = page.floor().clamp(0, kOnboardingSlides.length - 1);
    final ceilIndex = page.ceil().clamp(0, kOnboardingSlides.length - 1);
    final t = page - floorIndex;
    return SlidePalette.lerp(
      kOnboardingSlides[floorIndex].palette,
      kOnboardingSlides[ceilIndex].palette,
      t,
    );
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
    final totalPages = kOnboardingSlides.length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ValueListenableBuilder<double>(
        valueListenable: _pageProgress,
        builder: (context, page, child) {
          final livePalette = _interpolatedPalette(page);
          final normalizedProgress = (page + 1) / totalPages;
          final isLastPage = _currentPage == totalPages - 1;

          return Scaffold(
            backgroundColor: livePalette.canvas,
            body: Stack(
              children: [
                child!,
                Positioned(
                  top: padding.top + OnboardingSpacing.md,
                  left: OnboardingSpacing.xl,
                  right: OnboardingSpacing.xl,
                  child: OnboardingTopBar(
                    palette: livePalette,
                    showSkip: !isLastPage,
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
                    progress: normalizedProgress,
                    palette: livePalette,
                    onSelectPage: _goToPage,
                    onNext: () => _goToPage(_currentPage + 1),
                    onComplete: _showCompletionSheet,
                  ),
                ),
              ],
            ),
          );
        },
        child: PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          itemCount: totalPages,
          onPageChanged: (index) {
            if (index != _currentPage) {
              setState(() => _currentPage = index);
            }
          },
          itemBuilder: (context, index) {
            return OnboardingSlideView(
              slide: kOnboardingSlides[index],
              index: index,
              totalPages: totalPages,
              pageProgress: _pageProgress,
              isActive: index == _currentPage,
            );
          },
        ),
      ),
    );
  }
}

