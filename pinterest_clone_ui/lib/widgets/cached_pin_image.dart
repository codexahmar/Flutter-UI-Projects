import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../themes/design_tokens.dart';

/// Shared Pinterest photo container with consistent hairline edge (#37),
/// studio-cutout contain framing, cached image placeholder/fallback,
/// and optional smooth Hero transition support.
class CachedPinImage extends StatelessWidget {
  final String imageUrl;
  final String assetFallback;
  final bool isStudioCutout;
  final double borderRadius;
  final double cutoutPadding;
  final bool showHairline;
  final String? heroTag;
  final Widget? overlay;

  const CachedPinImage({
    super.key,
    required this.imageUrl,
    required this.assetFallback,
    this.isStudioCutout = false,
    this.borderRadius = AppTokens.radiusPin,
    this.cutoutPadding = AppTokens.space8,
    this.showHairline = true,
    this.heroTag,
    this.overlay,
  });

  Widget _buildFramedImage({required bool includeOverlay}) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      decoration: BoxDecoration(
        color: AppTokens.lightBg,
        borderRadius: radius,
      ),
      foregroundDecoration: showHairline
          ? BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: AppTokens.lightImageHairline,
                width: 0.8,
              ),
            )
          : null,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: isStudioCutout
                ? EdgeInsets.all(cutoutPadding)
                : EdgeInsets.zero,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: isStudioCutout ? BoxFit.contain : BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 180),
              fadeOutDuration: const Duration(milliseconds: 120),
              placeholder: (_, __) => Container(
                color: AppTokens.lightSurfaceSubtle,
              ),
              errorWidget: (_, __, ___) => Image.asset(
                assetFallback,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (includeOverlay && overlay != null) overlay!,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final framedWithOverlay = _buildFramedImage(includeOverlay: true);
    if (heroTag == null) return framedWithOverlay;

    return Hero(
      tag: heroTag!,
      flightShuttleBuilder: (_, __, ___, ____, _____) => Material(
        type: MaterialType.transparency,
        child: _buildFramedImage(includeOverlay: false),
      ),
      child: framedWithOverlay,
    );
  }
}
