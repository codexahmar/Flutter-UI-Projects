import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

/// Crisp circular map marker with a solid surface and semantic ring.
class LocationPin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String semanticLabel;

  const LocationPin({
    super.key,
    required this.icon,
    required this.color,
    required this.semanticLabel,
  });

  static const double size = 32;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: RideColors.surface,
          border: Border.all(color: color, width: 2),
          boxShadow: const [
            BoxShadow(
              color: RideColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
