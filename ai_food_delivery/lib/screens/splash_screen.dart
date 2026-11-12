import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/screens/food_discovery_screen.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Studio launch screen showcasing the bespoke Crave mark and oversized wordmark reveal.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Cubic _expoOut = Cubic(0.16, 1.0, 0.3, 1.0);
  static const List<String> _letters = ['C', 'r', 'a', 'v', 'e'];

  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoShiftY;
  late final Animation<double> _tracking;
  late final Animation<double> _loaderProgress;
  late final Animation<double> _loaderOpacity;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();

    _logoScale = Tween<double>(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.44, curve: _expoOut),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.24, curve: Curves.easeOut),
      ),
    );
    _logoShiftY = Tween<double>(begin: 26.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.44, curve: _expoOut),
      ),
    );

    _tracking = Tween<double>(begin: 9.0, end: -3.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.74, curve: _expoOut),
      ),
    );

    _loaderProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.98, curve: Curves.easeInOutCubic),
      ),
    );
    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    _navTimer = Timer(const Duration(milliseconds: 2650), _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 480),
        pageBuilder: (_, animation, _) {
          final curved = CurvedAnimation(parent: animation, curve: _expoOut);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1.0).animate(curved),
              child: const FoodDiscoveryScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: FoodColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            FoodSpacing.xl,
            FoodSpacing.xl,
            FoodSpacing.xl,
            bottomPadding + FoodSpacing.xl,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Column(
                children: [
                  const Spacer(flex: 3),
                  Opacity(
                    opacity: _logoFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _logoShiftY.value),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Image.asset(
                          'assets/images/crave_logo.png',
                          height: 156,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.lg),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ClipRect(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          ...List.generate(_letters.length, (index) {
                            final start = 0.18 + (index * 0.055);
                            final end = (start + 0.36).clamp(0.0, 1.0);
                            final t = CurvedAnimation(
                              parent: _controller,
                              curve: Interval(start, end, curve: _expoOut),
                            ).value;
                            return Transform.translate(
                              offset: Offset(0, (1.0 - t) * 102),
                              child: Opacity(
                                opacity: t.clamp(0.0, 1.0),
                                child: Text(
                                  _letters[index],
                                  style: FoodText.headline.copyWith(
                                    fontSize: 98,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: _tracking.value,
                                    height: 0.96,
                                  ),
                                ),
                              ),
                            );
                          }),
                          Builder(
                            builder: (_) {
                              final dotT = CurvedAnimation(
                                parent: _controller,
                                curve: const Interval(
                                  0.52,
                                  0.82,
                                  curve: _expoOut,
                                ),
                              ).value;
                              return Transform.scale(
                                scale: dotT,
                                child: Text(
                                  '.',
                                  style: FoodText.headline.copyWith(
                                    fontSize: 98,
                                    fontWeight: FontWeight.w700,
                                    color: FoodColors.accent,
                                    height: 0.96,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                  Opacity(
                    opacity: _loaderOpacity.value,
                    child: Container(
                      width: 112,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: FoodColors.border,
                        borderRadius: BorderRadius.circular(FoodRadius.pill),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _loaderProgress.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: FoodColors.accent,
                            borderRadius:
                                BorderRadius.circular(FoodRadius.pill),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
