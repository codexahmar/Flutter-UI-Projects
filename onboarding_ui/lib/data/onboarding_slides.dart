import 'dart:ui';

import 'package:onboarding_ui/models/onboarding_slide.dart';

const List<OnboardingSlide> kOnboardingSlides = [
  OnboardingSlide(
    stageLabel: 'Flow mapping',
    title: 'Turn rough ideas into screen flows',
    description:
        'Outline what your app does and structure core user journeys before touching layout code.',
    imageAsset: 'assets/images/ai_idea.png',
    palette: SlidePalette(
      canvas: Color(0xFF0C0E16),
      surface: Color(0xFF161927),
      border: Color(0xFF282D45),
      accent: Color(0xFFA78BFA),
      secondaryText: Color(0xFF9EA6BD),
    ),
  ),
  OnboardingSlide(
    stageLabel: 'Design tokens',
    title: 'Lock in color, type, and spacing',
    description:
        'Set visual rules once so every surface, button, and card stays balanced across screens.',
    imageAsset: 'assets/images/color_palette.png',
    palette: SlidePalette(
      canvas: Color(0xFF0A1214),
      surface: Color(0xFF132023),
      border: Color(0xFF22393E),
      accent: Color(0xFF2DD4BF),
      secondaryText: Color(0xFF97AFB2),
    ),
  ),
  OnboardingSlide(
    stageLabel: 'Live states',
    title: 'Preview real states before build',
    description:
        'Inspect mobile layouts, interactive hierarchy, and edge cases early in the flow.',
    imageAsset: 'assets/images/mobile_preview.png',
    palette: SlidePalette(
      canvas: Color(0xFF0A101B),
      surface: Color(0xFF131D30),
      border: Color(0xFF233554),
      accent: Color(0xFF38BDF8),
      secondaryText: Color(0xFF98AAC3),
    ),
  ),
  OnboardingSlide(
    stageLabel: 'Flutter export',
    title: 'Ship clean Flutter layouts faster',
    description:
        'Move straight from an approved direction into modular, maintainable widget code.',
    imageAsset: 'assets/images/flutter_build.png',
    palette: SlidePalette(
      canvas: Color(0xFF130C14),
      surface: Color(0xFF201522),
      border: Color(0xFF38243C),
      accent: Color(0xFFFB7185),
      secondaryText: Color(0xFFB39FB7),
    ),
  ),
];

