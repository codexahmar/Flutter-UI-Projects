import 'dart:ui';
import 'package:onboarding_ui/app_theme.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final String imageAsset;
  final OnboardingPalette palette;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.palette,
  });
}

const List<OnboardingSlide> kOnboardingSlides = [
  OnboardingSlide(
    title: 'Turn rough ideas into screen flows',
    description:
        'Outline what your app does and map core user journeys before writing layout code.',
    imageAsset: 'assets/images/ai_idea.png',
    palette: OnboardingPalette(
      canvas: Color(0xFF0D0F1A),
      surface: Color(0xFF171A2D),
      border: Color(0xFF2B3150),
      accent: Color(0xFFA78BFA),
      secondaryText: Color(0xFFA2ABC2),
    ),
  ),
  OnboardingSlide(
    title: 'Lock in color, type, and spacing',
    description:
        'Define clear tokens once so every card, button, and surface stays balanced across screens.',
    imageAsset: 'assets/images/color_palette.png',
    palette: OnboardingPalette(
      canvas: Color(0xFF091617),
      surface: Color(0xFF112628),
      border: Color(0xFF214448),
      accent: Color(0xFF2DD4BF),
      secondaryText: Color(0xFF9BB7B8),
    ),
  ),
  OnboardingSlide(
    title: 'Preview real states before build',
    description:
        'Inspect mobile layouts, visual hierarchy, and edge states early in the process.',
    imageAsset: 'assets/images/mobile_preview.png',
    palette: OnboardingPalette(
      canvas: Color(0xFF091322),
      surface: Color(0xFF112138),
      border: Color(0xFF223B5E),
      accent: Color(0xFF38BDF8),
      secondaryText: Color(0xFF9AB0CB),
    ),
  ),
  OnboardingSlide(
    title: 'Ship clean Flutter layouts faster',
    description:
        'Move straight from an approved direction into modular, maintainable widget code.',
    imageAsset: 'assets/images/flutter_build.png',
    palette: OnboardingPalette(
      canvas: Color(0xFF150E17),
      surface: Color(0xFF221726),
      border: Color(0xFF3D2844),
      accent: Color(0xFFFB7185),
      secondaryText: Color(0xFFBBA8BE),
    ),
  ),
];
