import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_ui/models/onboarding_slide.dart';
import 'package:onboarding_ui/theme/app_theme.dart';

/// Scroll-linked radial Next control that morphs into the final Start CTA.
class ProgressNextButton extends StatefulWidget {
  final double progress;
  final bool isLastPage;
  final SlidePalette palette;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const ProgressNextButton({
    super.key,
    required this.progress,
    required this.isLastPage,
    required this.palette,
    required this.onNext,
    required this.onComplete,
  });

  @override
  State<ProgressNextButton> createState() => _ProgressNextButtonState();
}

class _ProgressNextButtonState extends State<ProgressNextButton> {
  bool _pressed = false;

  void _handleTap() {
    HapticFeedback.lightImpact();
    if (widget.isLastPage) {
      widget.onComplete();
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _handleTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: widget.isLastPage
              ? Container(
                  key: const ValueKey('cta_start'),
                  height: 52,
                  padding: const EdgeInsets.symmetric(
                    horizontal: OnboardingSpacing.xl,
                  ),
                  decoration: BoxDecoration(
                    color: widget.palette.accent,
                    borderRadius: BorderRadius.circular(OnboardingRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start building',
                        style: textTheme.labelLarge?.copyWith(
                          color: OnboardingColors.inkOnAccent,
                        ),
                      ),
                      const SizedBox(width: OnboardingSpacing.sm),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: OnboardingColors.inkOnAccent,
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  key: const ValueKey('cta_next_ring'),
                  width: 60,
                  height: 60,
                  child: CustomPaint(
                    painter: _ProgressRingPainter(
                      progress: widget.progress.clamp(0.0, 1.0),
                      accentColor: widget.palette.accent,
                      trackColor: OnboardingColors.ringTrack,
                    ),
                    child: Center(
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: widget.palette.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: widget.palette.border),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: OnboardingColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final Color trackColor;

  const _ProgressRingPainter({
    required this.progress,
    required this.accentColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 2.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final arcPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.trackColor != trackColor;
  }
}

