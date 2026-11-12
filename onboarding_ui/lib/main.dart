import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_ui/screens/onboarding_screen.dart';
import 'package:onboarding_ui/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: OnboardingColors.baseCanvas,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const UIForgeApp());
}

class UIForgeApp extends StatelessWidget {
  const UIForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UIForge AI',
      debugShowCheckedModeBanner: false,
      theme: OnboardingTheme.dark(),
      home: const OnboardingScreen(),
    );
  }
}
