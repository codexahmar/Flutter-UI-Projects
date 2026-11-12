import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/screens/food_discovery_screen.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Restrained editorial launch screen locking the Crave mark and oversized wordmark cleanly.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Cubic _easeOutQuint = Cubic(0.22, 1.0, 0.36, 1.0);

  late final AnimationController _controller;
  late final Animation<double> _markOpacity;
  late final Animation<double> _markScale;
  late final Animation<double> _markShiftY;
  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _wordmarkShiftY;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _markOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _markScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.68, curve: _easeOutQuint),
      ),
    );
    _markShiftY = Tween<double>(begin: 18.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.68, curve: _easeOutQuint),
      ),
    );

    _wordmarkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.72, curve: Curves.easeOut),
      ),
    );
    _wordmarkShiftY = Tween<double>(begin: 72.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.92, curve: _easeOutQuint),
      ),
    );

    _navTimer = Timer(const Duration(milliseconds: 1650), _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, animation, _) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: _easeOutQuint,
          );
          return FadeTransition(
            opacity: curved,
            child: const FoodDiscoveryScreen(),
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
    return Scaffold(
      backgroundColor: FoodColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: FoodSpacing.xl),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Column(
                children: [
                  const Spacer(flex: 3),
                  Opacity(
                    opacity: _markOpacity.value,
                    child: Transform.translate(
                      offset: Offset(0, _markShiftY.value),
                      child: Transform.scale(
                        scale: _markScale.value,
                        child: Image.asset(
                          'assets/images/crave_logo.png',
                          height: 122,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.lg),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ClipRect(
                      child: Transform.translate(
                        offset: Offset(0, _wordmarkShiftY.value),
                        child: Opacity(
                          opacity: _wordmarkOpacity.value,
                          child: Text(
                            'Crave',
                            style: FoodText.headline.copyWith(
                              fontSize: 94,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -3.4,
                              height: 0.96,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
