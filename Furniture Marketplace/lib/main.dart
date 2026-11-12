import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/mock_product_repository.dart';
import 'presentation/screens/main_shell.dart';

void main() {
  runApp(const FurnitureMarketplaceApp());
}

class FurnitureMarketplaceApp extends StatelessWidget {
  const FurnitureMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MockProductRepository();

    return MaterialApp(
      title: 'Furniture Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainNavigationShell(repository: repository),
    );
  }
}
