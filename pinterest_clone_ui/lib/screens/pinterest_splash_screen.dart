import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';
import 'home_page.dart';

/// Authentic Pinterest Startup Splash Screen (Pure Light Mode)
class PinterestSplashScreen extends StatefulWidget {
  const PinterestSplashScreen({super.key});

  @override
  State<PinterestSplashScreen> createState() => _PinterestSplashScreenState();
}

class _PinterestSplashScreenState extends State<PinterestSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  Timer? _navigationTimer;

  bool get _isTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('Test');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Fast-track during automated tests, smooth delay on real device
    final delay = _isTest
        ? const Duration(milliseconds: 50)
        : const Duration(milliseconds: 1100);

    _navigationTimer = Timer(delay, _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.lightBg,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: SizedBox(
            width: 112,
            height: 112,
            child: Image.asset(
              AppAssets.pinterestLogo,
              width: 112,
              height: 112,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

