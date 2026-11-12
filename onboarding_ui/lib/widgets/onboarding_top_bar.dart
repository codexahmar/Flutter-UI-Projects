import 'package:flutter/material.dart';
import 'package:onboarding_ui/models/onboarding_slide.dart';
import 'package:onboarding_ui/theme/app_theme.dart';

/// Top bar with geometric brand mark and quiet Skip action.
class OnboardingTopBar extends StatelessWidget {
  final SlidePalette palette;
  final bool showSkip;
  final VoidCallback onSkip;

  const OnboardingTopBar({
    super.key,
    required this.palette,
    required this.showSkip,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: palette.accent,
                borderRadius: BorderRadius.circular(OnboardingRadius.sm - 2),
              ),
              child: const Icon(
                Icons.layers_rounded,
                color: OnboardingColors.inkOnAccent,
                size: 17,
              ),
            ),
            const SizedBox(width: OnboardingSpacing.sm),
            Text('UIForge AI', style: textTheme.titleMedium),
          ],
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
