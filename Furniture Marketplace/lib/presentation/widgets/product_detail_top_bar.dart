import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'circular_icon_button.dart';

class ProductDetailTopBar extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onInfoTap;
  final VoidCallback onFavoriteTap;

  const ProductDetailTopBar({
    super.key,
    required this.isFavorite,
    required this.onBack,
    required this.onInfoTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularIconButton(
            icon: CupertinoIcons.arrow_left,
            onTap: onBack,
          ),
          Row(
            children: [
              CircularIconButton(
                icon: CupertinoIcons.info,
                onTap: onInfoTap,
                iconSize: 18,
              ),
              const SizedBox(width: 10),
              CircularIconButton(
                icon: isFavorite
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                onTap: onFavoriteTap,
                backgroundColor:
                    isFavorite ? AppColors.pureBlack : Colors.white,
                iconColor:
                    isFavorite ? Colors.white : AppColors.pureBlack,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
