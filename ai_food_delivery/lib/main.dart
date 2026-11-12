import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_food_delivery/screens/food_discovery_screen.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: FoodColors.canvas,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const FoodDiscoveryScreen(),
    );
  }
}
