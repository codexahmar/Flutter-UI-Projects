import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'circular_icon_button.dart';

class CatalogHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const CatalogHeader({
    super.key,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Catalog',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.pureBlack,
            letterSpacing: -0.7,
          ),
        ),
        CircularIconButton(
          icon: CupertinoIcons.bell_fill,
          onTap: onNotificationTap,
          iconColor: Colors.black,
          iconSize: 20,
          badgeText: '',
          badgeColor: Colors.black,
        ),
      ],
    );
  }
}
