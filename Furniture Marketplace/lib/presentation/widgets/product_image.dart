import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';

/// Reusable Product Image Widget for local asset images
class ProductImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFF0F1F3),
          child: const Center(
            child: Icon(
              CupertinoIcons.cube_box,
              size: 40,
              color: AppColors.mutedGray,
            ),
          ),
        );
      },
    );
  }
}
