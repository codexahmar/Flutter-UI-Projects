import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Reusable Circular Icon Button with optional Badge
class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final String? badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool hasShadow;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.pureBlack,
    this.size = 44,
    this.iconSize = 18,
    this.badgeText,
    this.badgeColor = AppColors.badgeRed,
    this.badgeTextColor = Colors.white,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            if (badgeText != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: badgeText!.isEmpty ? 7 : 14,
                  height: badgeText!.isEmpty ? 7 : 14,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  child: badgeText!.isNotEmpty
                      ? Text(
                          badgeText!,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: badgeTextColor,
                          ),
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
