import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:onboarding_ui/app_theme.dart';

/// Displays an onboarding artwork render directly on the canvas with an
/// understated tonal wash and optional idle motion.
class SlideHero extends StatefulWidget {
  final String imageAsset;
  final OnboardingPalette palette;
  final bool isActive;

  const SlideHero({
    super.key,
    required this.imageAsset,
    required this.palette,
    required this.isActive,
  });

  @override
  State<SlideHero> createState() => _SlideHeroState();
}

class _SlideHeroState extends State<SlideHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(SlideHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _syncAnimationState();
    }
  }

  void _syncAnimationState() {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (widget.isActive && !reduceMotion) {
      if (!_floatController.isAnimating) {
        _floatController.repeat(reverse: true);
      }
    } else if (_floatController.isAnimating) {
      _floatController.stop();
      _floatController.value = 0;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

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
                        widget.palette.accent.withValues(alpha: 0.22),
                        widget.palette.accent.withValues(alpha: 0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                  child: SizedBox.square(dimension: maxSide),
                ),
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    final offsetY =
                        -6 * math.sin(_floatController.value * math.pi);
                    return Transform.translate(
                      offset: Offset(0, offsetY),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    widget.imageAsset,
                    width: maxSide * 0.92,
                    height: maxSide * 0.92,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.layers_outlined,
                      size: 64,
                      color: widget.palette.accent,
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

