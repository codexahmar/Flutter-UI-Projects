import 'package:flutter/material.dart';
import 'package:onboarding_ui/theme/app_theme.dart';

/// Confirmation sheet shown when the user completes onboarding.
class OnboardingCompleteSheet extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onReplay;

  const OnboardingCompleteSheet({
    super.key,
    required this.accentColor,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: OnboardingColors.sheetSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(OnboardingRadius.md),
        ),
        border: Border(
          top: BorderSide(color: OnboardingColors.sheetBorder),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        OnboardingSpacing.xl,
        OnboardingSpacing.lg,
        OnboardingSpacing.xl,
        bottomPadding + OnboardingSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: OnboardingColors.inkOnAccent,
                  size: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: OnboardingColors.sheetSurfaceSubtle,
                  foregroundColor: OnboardingColors.textPrimary,
                  minimumSize: const Size.square(48),
                  side: const BorderSide(color: OnboardingColors.sheetBorder),
                ),
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: OnboardingSpacing.lg),
          Text('Workspace ready', style: textTheme.headlineMedium),
          const SizedBox(height: OnboardingSpacing.sm),
          Text(
            'You are set to draft screens, define tokens, and export Flutter layouts.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: OnboardingSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onReplay();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: OnboardingColors.textPrimary,
                    backgroundColor: OnboardingColors.sheetSurfaceSubtle,
                    minimumSize: const Size(0, 48),
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      color: OnboardingColors.sheetBorder,
                    ),
                    textStyle: textTheme.labelLarge,
                  ),
                  child: const Text('Replay tour'),
                ),
              ),
              const SizedBox(width: OnboardingSpacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: OnboardingColors.inkOnAccent,
                    minimumSize: const Size(0, 48),
                    shape: const StadiumBorder(),
                    textStyle: textTheme.labelLarge,
                    elevation: 0,
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
