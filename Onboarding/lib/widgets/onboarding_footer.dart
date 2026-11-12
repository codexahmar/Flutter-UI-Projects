import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_ui/models/onboarding_slide.dart';
import 'package:onboarding_ui/theme/app_theme.dart';
import 'package:onboarding_ui/widgets/progress_next_button.dart';

/// Anchored bottom bar with interactive step dots and scroll-linked progress CTA.
class OnboardingFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double progress;
  final SlidePalette palette;
  final ValueChanged<int> onSelectPage;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const OnboardingFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.progress,
    required this.palette,
    required this.onSelectPage,
    required this.onNext,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == totalPages - 1;

    return SizedBox(
      height: 60,
      child: Row(
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
                      vertical: OnboardingSpacing.lg,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      height: 6,
                      width: isSelected ? 24 : 6,
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
          ProgressNextButton(
            progress: progress,
            isLastPage: isLastPage,
            palette: palette,
            onNext: onNext,
            onComplete: onComplete,
          ),
        ],
      ),
    );
  }
}
