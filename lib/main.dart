import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/presentation/app_shell.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeController>(
      builder: (context, controller, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Atlas Crypto',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: controller.themeMode,
          home: const AppShell(),
        );
      },
    );
  }
}
