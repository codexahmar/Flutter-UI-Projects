import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_ui/app_theme.dart';
import 'package:onboarding_ui/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: OnboardingColors.sheetSurface,
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
