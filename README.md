# Pinterest UI Clone

A high-performance, pixel-accurate Pinterest mobile interface built with Flutter. Designed for smooth 60/120 FPS animations, responsive layout scaling, authentic staggered masonry grids, and iconic Pinterest pure light mode aesthetic.

---

## Screenshots

| Pinterest Home Wall | Creator Profile Screen |
|:---:|:---:|
| <img src="Screenshot/home_wall.png" width="360" alt="Pinterest Home Wall" /> | <img src="Screenshot/profile_screen.png" width="360" alt="Creator Profile Screen" /> |

---

## Overview

This project reproduces the modern Pinterest mobile application interface with strict fidelity to its design tokens, typography, motion physics, and user experience patterns. It avoids external UI dependencies, leveraging Flutter's native layout engine and standard library to ensure low memory overhead and predictable runtime behavior.

Key capabilities include:
- Infinite staggered masonry photo wall with variable aspect ratios.
- Full pin inspection sheet with creator attribution, action controls, and recommendation grids.
- Native shimmer skeleton placeholder on startup with index-staggered entrance animations.
- Official Pinterest brand header, search screen with 2x2 visual category discovery, and notifications feed.
- Creator profile with collage board previews, saved pin filters, and authentic user controls.
- Zero-dependency design architecture powered by centralized design tokens and asset registries.

---

## Architecture & Project Structure

The project follows a layered architectural separation dividing concerns between design tokens, data models, domain widgets, and top-level screen scaffolds:

```text
lib/
├── constants/
│   └── app_assets.dart           # Centralized static image asset registry
├── data/
│   └── pinterest_data.dart        # Pin models, board collages, ideas, and live API client
├── screens/
│   ├── home_page.dart             # Root scaffold with 5-tab indexed navigation controller
│   ├── pinterest_home_screen.dart # Infinite staggered masonry feed & official brand header
│   ├── pinterest_profile_screen.dart # Creator profile, collage boards, and saved collections
│   ├── pinterest_search_screen.dart  # Search discovery, trending terms, and query results
│   ├── pinterest_splash_screen.dart  # Official startup splash screen with scale-in brand logo
│   └── pinterest_updates_screen.dart # Notifications and activity feed
├── themes/
│   ├── app_themes.dart            # Material 3 light theme configuration
│   └── design_tokens.dart         # Authentic Pinterest color palette, spacing, and radii
└── widgets/
    ├── create_pin_modal.dart      # Bottom sheet modal for Pin, Board, or Collage creation
    ├── masonry_grid.dart          # Reusable 2-column masonry grid layout
    ├── pin_card.dart              # Interactive pin card with quick save and context menu
    ├── pin_detail_modal.dart      # Fullscreen pin inspector and 'More like this' recommendations
    ├── pin_options_sheet.dart     # Context menu for hide, download, copy link, and report actions
    ├── pinterest_board_card.dart  # Authentic 3-image collage board preview widget
    ├── pinterest_logo.dart        # Official brand logo and home header app bar
    ├── pinterest_nav_bar.dart     # Custom 5-item docked bottom navigation bar
    ├── profile_header.dart        # Profile header with avatar, metrics, bio, and actions
    ├── shimmer_skeleton.dart      # Zero-dependency startup shimmer loading placeholder
    ├── sliver_tab_bar_delegate.dart # Pinned sticky tab bar delegate
    └── staggered_pin_animation.dart # Index-delayed slide and fade entrance animator
```

---

## Core Components

- **PinterestMasonryGrid (`lib/widgets/masonry_grid.dart`)**  
  A generic, high-performance two-column masonry layout that distributes items into alternating staggered columns. Used identically across the Home Feed, Search Results, and Profile Saved collections to eliminate code duplication.

- **PinCard (`lib/widgets/pin_card.dart`)**  
  Renders individual pins with accurate border radius (16px), dynamic network loading with asset fallback, contextual quick Save pill, and integrated options sheet trigger via tap or long-press.

- **PinDetailModal (`lib/widgets/pin_detail_modal.dart`)**  
  Presents full-screen pin details including creator row, Follow toggle, official action buttons (Pinterest Red Save `#E60023`, neutral View button), and an infinite same-category recommendation grid.

- **ProfileHeader (`lib/widgets/profile_header.dart`)**  
  Encapsulates profile metadata, verified creator badges, follower counts, bio description, external links, and account action buttons.

- **PinterestBoardCard (`lib/widgets/pinterest_board_card.dart`)**  
  Reproduces the Pinterest 3-image collage format featuring a dominant left image paired with two stacked preview thumbnails.

- **ShimmerLoading & PinterestMasonrySkeleton (`lib/widgets/shimmer_skeleton.dart`)**  
  Pure Flutter native animation controller that simulates content shimmer during data loading without third-party package dependencies.

- **PinterestSplashScreen (`lib/screens/pinterest_splash_screen.dart`)**  
  Startup entry point that smoothly animates the authentic Pinterest logo with scale and fade curves before transitioning to the primary home scaffold.

- **StaggeredPinAnimation (`lib/widgets/staggered_pin_animation.dart`)**  
  Micro-interaction component that cascades individual pins into the viewport one by one using combined slide, scale, and fade animations upon skeleton completion.

---

## Design System & Tokens

The application strictly implements Pinterest's visual identity defined in `lib/themes/design_tokens.dart`:

- **Primary Brand Color**: `#E60023` (Pinterest Red)
- **Light Theme Palette**:
  - Background: `#FFFFFF` (Pure White)
  - Pill / Card: `#E9E9E9` (Pinterest Neutral Gray)
  - Subtle Border: `#E0E0E0`
  - Text Primary: `#111111` (High-contrast charcoal)
  - Text Secondary: `#5F5F5F` (Secondary captions)
  - Text Tertiary: `#8E8E8E` (Subtle placeholders)
- **Corner Radii**: 16px for cards and boards, 24px for action pills and search inputs.

---

## Getting Started

### Prerequisites

- Flutter SDK version 3.4.3 or higher
- Dart SDK version 3.4.3 or higher
- Xcode (for iOS simulator) or Android Studio (for Android emulator)

### Installation

1. Clone or navigate to the project directory:

```bash
cd pinterest_ui_clone
```

2. Fetch project dependencies:

```bash
flutter pub get
```

3. Run the application on your connected simulator or device:

```bash
flutter run
```

---

## Verification & Testing

The project includes an end-to-end widget test suite verifying startup skeleton resolution, home feed rendering, pin detail opening, category recommendation browsing, search query filtering, bottom sheet flows, and profile navigation.

Run all tests via terminal:

```bash
flutter test
```

Run static analysis:

```bash
dart analyze
```

---

## Creator

- Name: Ahmaryar Khan
- Handle: @codexahmar
- GitHub: [github.com/codexahmar](https://github.com/codexahmar)

---

## License

This project is licensed under the MIT License for educational and portfolio demonstration purposes.
