import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_ui/app_theme.dart';

/// Shared bottom bar with tappable step indicators and the active page CTA.
class OnboardingFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final OnboardingPalette palette;
  final ValueChanged<int> onSelectPage;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const OnboardingFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.palette,
    required this.onSelectPage,
    required this.onNext,
    required this.onComplete,
  });

  bool get _isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalPages, (index) {
            final isSelected = index == currentPage;
            return Semantics(
              button: true,
              selected: isSelected,
              label: 'Go to step ${index + 1} of $totalPages',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelectPage(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OnboardingSpacing.xs,
                    vertical: OnboardingSpacing.md,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: 8,
                    width: isSelected ? 24 : 8,
                    decoration: BoxDecoration(
                      color: isSelected ? palette.accent : palette.border,
                      borderRadius: BorderRadius.circular(
                        OnboardingRadius.pill,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const Spacer(),
        FilledButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            if (_isLastPage) {
              onComplete();
            } else {
              onNext();
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: _isLastPage ? palette.accent : palette.surface,
            foregroundColor: _isLastPage
                ? OnboardingColors.inkOnAccent
                : OnboardingColors.textPrimary,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(
              horizontal: OnboardingSpacing.xl,
            ),
            shape: const StadiumBorder(),
            side: _isLastPage ? BorderSide.none : BorderSide(color: palette.border),
            textStyle: textTheme.labelLarge,
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_isLastPage ? 'Start building' : 'Next'),
              const SizedBox(width: OnboardingSpacing.sm),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}

