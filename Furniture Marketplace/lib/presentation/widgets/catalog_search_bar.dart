import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class CatalogSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onFilterTap;

  const CatalogSearchBar({
    super.key,
    this.hintText = 'Search furniture...',
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.search,
            size: 20,
            color: AppColors.mutedGray,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hintText,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.mutedGray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.1,
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: const Icon(
              CupertinoIcons.slider_horizontal_3,
              size: 20,
              color: AppColors.pureBlack,
            ),
          ),
        ],
      ),
    );
  }
}
