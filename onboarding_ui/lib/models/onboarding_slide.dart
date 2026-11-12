import 'dart:ui';

/// Color tokens defining the surface and accent character of a single slide.
class SlidePalette {
  final Color canvas;
  final Color surface;
  final Color border;
  final Color accent;
  final Color secondaryText;

  const SlidePalette({
    required this.canvas,
    required this.surface,
    required this.border,
    required this.accent,
    required this.secondaryText,
  });

  /// Smoothly interpolates between two slide palettes during interactive scrolling.
  static SlidePalette lerp(SlidePalette a, SlidePalette b, double t) {
    return SlidePalette(
      canvas: Color.lerp(a.canvas, b.canvas, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      secondaryText: Color.lerp(a.secondaryText, b.secondaryText, t)!,
    );
  }
}

/// Content model for a single screen in the onboarding flow.
class OnboardingSlide {
  final String stageLabel;
  final String title;
  final String description;
  final String imageAsset;
  final SlidePalette palette;

  const OnboardingSlide({
    required this.stageLabel,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.palette,
  });
}

