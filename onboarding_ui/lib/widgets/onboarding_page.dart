import 'package:flutter/material.dart';
import 'package:onboarding_ui/app_theme.dart';
import 'package:onboarding_ui/onboarding_slides.dart';
import 'package:onboarding_ui/widgets/slide_hero.dart';

/// Single slide view inside the liquid-swipe pager.
class OnboardingPage extends StatelessWidget {
  final OnboardingSlide slide;
  final int index;
  final int totalPages;
  final bool isActive;

  const OnboardingPage({
    super.key,
    required this.slide,
    required this.index,
    required this.totalPages,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: slide.palette.canvas,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          OnboardingSpacing.xl,
          padding.top + OnboardingSpacing.xxxl + OnboardingSpacing.lg,
          OnboardingSpacing.xl,
          padding.bottom + OnboardingSpacing.xxxl + OnboardingSpacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SlideHero(
                imageAsset: slide.imageAsset,
                palette: slide.palette,
                isActive: isActive,
              ),
            ),
            const SizedBox(height: OnboardingSpacing.xl),
            Text(
              'Step ${index + 1} of $totalPages',
              style: textTheme.bodySmall?.copyWith(
                color: slide.palette.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: OnboardingSpacing.sm),
            Text(slide.title, style: textTheme.headlineMedium),
            const SizedBox(height: OnboardingSpacing.md),
            Text(
              slide.description,
              style: textTheme.bodyMedium?.copyWith(
                color: slide.palette.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

