import 'package:flutter/material.dart';
import 'package:onboarding_ui/app_theme.dart';

/// Edge affordance rendered by LiquidSwipe along the right reveal boundary.
class SwipeHandle extends StatelessWidget {
  final OnboardingPalette palette;

  const SwipeHandle({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: palette.surface,
        shape: BoxShape.circle,
        border: Border.all(color: palette.border),
      ),
      child: const Icon(
        Icons.chevron_left_rounded,
        color: OnboardingColors.textPrimary,
        size: 26,
      ),
    );
  }
}

