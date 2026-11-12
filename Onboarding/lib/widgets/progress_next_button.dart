import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_ui/models/onboarding_slide.dart';
import 'package:onboarding_ui/theme/app_theme.dart';

/// Scroll-linked radial Next control that physically morphs into the final pill CTA.
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
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final morphDuration = Duration(milliseconds: reduceMotion ? 0 : 280);

    return Semantics(
      button: true,
      label: widget.isLastPage ? 'Start building' : 'Next step',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          _handleTap();
        },
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: SizedBox(
            height: 60,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                AnimatedOpacity(
                  opacity: widget.isLastPage ? 0 : 1,
                  duration: const Duration(milliseconds: 160),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CustomPaint(
                      painter: _ProgressRingPainter(
                        progress: widget.progress.clamp(0.0, 1.0),
                        accentColor: widget.palette.accent,
                        trackColor: OnboardingColors.ringTrack,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: widget.isLastPage ? 0 : 7),
                  child: AnimatedContainer(
                    duration: morphDuration,
                    curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                    width: widget.isLastPage ? 176 : 46,
                    height: widget.isLastPage ? 50 : 46,
                    decoration: BoxDecoration(
                      color: widget.isLastPage
                          ? widget.palette.accent
                          : widget.palette.surface,
                      borderRadius: BorderRadius.circular(
                        OnboardingRadius.pill,
                      ),
                      border: Border.all(
                        color: widget.isLastPage
                            ? Colors.white.withValues(alpha: 0.16)
                            : widget.palette.border,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        OnboardingRadius.pill,
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.isLastPage
                                  ? OnboardingSpacing.lg
                                  : 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.isLastPage) ...[
                                  Text(
                                    'Start building',
                                    maxLines: 1,
                                    style: textTheme.labelLarge?.copyWith(
                                      color: OnboardingColors.inkOnAccent,
                                    ),
                                  ),
                                  const SizedBox(width: OnboardingSpacing.sm),
                                ],
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: widget.isLastPage ? 18 : 20,
                                  color: widget.isLastPage
                                      ? OnboardingColors.inkOnAccent
                                      : OnboardingColors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
