import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_ui/models/onboarding_slide.dart';
import 'package:onboarding_ui/theme/app_theme.dart';

/// Renders one onboarding slide with continuous scroll-linked parallax and depth.
class OnboardingSlideView extends StatefulWidget {
  final OnboardingSlide slide;
  final int index;
  final int totalPages;
  final ValueListenable<double> pageProgress;
  final bool isActive;

  const OnboardingSlideView({
    super.key,
    required this.slide,
    required this.index,
    required this.totalPages,
    required this.pageProgress,
    required this.isActive,
  });

  @override
  State<OnboardingSlideView> createState() => _OnboardingSlideViewState();
}

class _OnboardingSlideViewState extends State<OnboardingSlideView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idleFloatController;

  @override
  void initState() {
    super.initState();
    _idleFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncIdleMotion();
  }

  @override
  void didUpdateWidget(OnboardingSlideView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _syncIdleMotion();
    }
  }

  void _syncIdleMotion() {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (widget.isActive && !reduceMotion) {
      if (!_idleFloatController.isAnimating) {
        _idleFloatController.repeat(reverse: true);
      }
    } else if (_idleFloatController.isAnimating) {
      _idleFloatController.stop();
      _idleFloatController.value = 0;
    }
  }

  @override
  void dispose() {
    _idleFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        OnboardingSpacing.xl,
        padding.top + OnboardingSpacing.xxxl + OnboardingSpacing.lg,
        OnboardingSpacing.xl,
        padding.bottom + OnboardingSpacing.xxxl + OnboardingSpacing.xxxl,
      ),
      child: ValueListenableBuilder<double>(
        valueListenable: widget.pageProgress,
        builder: (context, page, child) {
          final delta = (page - widget.index).clamp(-1.0, 1.0);
          final absDelta = delta.abs();
          final contentOpacity = (1.0 - absDelta * 1.15).clamp(0.0, 1.0);

          final heroTransform = reduceMotion
              ? Matrix4.identity()
              : (Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..translateByDouble(delta * 44, 0, 0, 1)
                  ..rotateY(delta * 0.22)
                  ..scaleByDouble(
                    1.0 - absDelta * 0.14,
                    1.0 - absDelta * 0.14,
                    1.0,
                    1.0,
                  ));

          final titleOffset = reduceMotion
              ? Offset.zero
              : Offset(-delta * 10, absDelta * 10);
          final bodyOffset = reduceMotion
              ? Offset.zero
              : Offset(delta * 14, absDelta * 16);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Opacity(
                  opacity: contentOpacity,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: heroTransform,
                    child: child,
                  ),
                ),
              ),
              const SizedBox(height: OnboardingSpacing.xl),
              Opacity(
                opacity: contentOpacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0${widget.index + 1} · ${widget.slide.stageLabel}',
                      style: textTheme.bodySmall?.copyWith(
                        color: widget.slide.palette.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: OnboardingSpacing.sm),
                    Transform.translate(
                      offset: titleOffset,
                      child: Text(
                        widget.slide.title,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: OnboardingSpacing.md),
                    Transform.translate(
                      offset: bodyOffset,
                      child: Text(
                        widget.slide.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: widget.slide.palette.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        child: _SlideHeroArtwork(
          imageAsset: widget.slide.imageAsset,
          accentColor: widget.slide.palette.accent,
          idleFloatController: _idleFloatController,
        ),
      ),
    );
  }
}

class _SlideHeroArtwork extends StatelessWidget {
  final String imageAsset;
  final Color accentColor;
  final Animation<double> idleFloatController;

  const _SlideHeroArtwork({
    required this.imageAsset,
    required this.accentColor,
    required this.idleFloatController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSide = math.min(
          math.min(constraints.maxWidth, constraints.maxHeight),
          320.0,
        );

        return Center(
          child: SizedBox(
            width: maxSide,
            height: maxSide,
            child: Stack(
              alignment: Alignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.16),
                        accentColor.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.52, 1.0],
                    ),
                  ),
                  child: SizedBox.square(dimension: maxSide),
                ),
                AnimatedBuilder(
                  animation: idleFloatController,
                  builder: (context, child) {
                    final floatY =
                        -5 * math.sin(idleFloatController.value * math.pi);
                    return Transform.translate(
                      offset: Offset(0, floatY),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    imageAsset,
                    width: maxSide * 0.94,
                    height: maxSide * 0.94,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.layers_outlined,
                      size: 64,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

