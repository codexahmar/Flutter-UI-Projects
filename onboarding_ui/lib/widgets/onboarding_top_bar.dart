import 'package:flutter/material.dart';
import 'package:onboarding_ui/app_theme.dart';

/// Persistent top navigation chrome showing the app mark and Skip action.
class OnboardingTopBar extends StatelessWidget {
  final OnboardingPalette palette;
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: palette.accent,
                borderRadius: BorderRadius.circular(OnboardingRadius.sm),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: OnboardingColors.inkOnAccent,
                size: 18,
              ),
            ),
            const SizedBox(width: OnboardingSpacing.sm),
            Text(
              'UIForge AI',
              style: textTheme.titleMedium?.copyWith(
                fontSize: 16,
                letterSpacing: -0.3,
              ),
            ),
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
                foregroundColor: OnboardingColors.textPrimary,
                backgroundColor: palette.surface,
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: OnboardingSpacing.lg,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(color: palette.border),
              ),
              child: Text('Skip', style: textTheme.labelLarge),
            ),
          ),
        ),
      ],
    );
  }
}

