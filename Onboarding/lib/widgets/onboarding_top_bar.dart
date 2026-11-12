import 'package:flutter/material.dart';
import 'package:onboarding_ui/models/onboarding_slide.dart';
import 'package:onboarding_ui/theme/app_theme.dart';

/// Top bar featuring a rolling tabular step odometer and quiet Skip action.
class OnboardingTopBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final SlidePalette palette;
  final bool showSkip;
  final VoidCallback onSkip;

  const OnboardingTopBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.palette,
    required this.showSkip,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final stepNumber = '${currentPage + 1}'.padLeft(2, '0');
    final totalNumber = '$totalPages'.padLeft(2, '0');
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Row(
      children: [
        Semantics(
          label: 'Step ${currentPage + 1} of $totalPages',
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRect(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: reduceMotion ? 0 : 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      if (reduceMotion) return child;
                      final offsetTween = Tween<Offset>(
                        begin: const Offset(0, 0.7),
                        end: Offset.zero,
                      );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetTween.animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      stepNumber,
                      key: ValueKey(currentPage),
                      style: textTheme.bodySmall?.copyWith(
                        color: OnboardingColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Text(
                  ' / $totalNumber',
                  style: textTheme.bodySmall?.copyWith(
                    color: palette.secondaryText.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        AnimatedOpacity(
          opacity: showSkip ? 1 : 0,
          duration: const Duration(milliseconds: 180),
          child: IgnorePointer(
            ignoring: !showSkip,
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: OnboardingColors.textSecondary,
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: OnboardingSpacing.md,
                ),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Skip',
                style: textTheme.labelLarge?.copyWith(
                  color: OnboardingColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
