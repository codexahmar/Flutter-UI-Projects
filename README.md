# Atlas Crypto Portfolio

Atlas Crypto Portfolio is a Flutter crypto-wallet showcase app focused on production-style UI architecture, responsive layouts, and polished micro-interactions.

## Highlights

- System-aware theming with explicit `Light`, `Dark`, and `System` modes
- Feature-oriented app shell with drawer + bottom navigation workflow
- Modern typography using Manrope for headings and Inter for body copy
- Reusable data-driven widgets for asset rendering
- Screen-level transitions and staggered content animations
- Analyzer-clean and test-validated baseline

## Run Locally

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode / VS Code

### Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Theming Notes

- Theme mode can be switched from the app drawer under `Appearance`.
- Light mode is tuned for high readability and accessibility contrast.
- Bottom navigation active state uses the wallet blue accent to match the app identity.

## Animation Notes

- Home screen uses staged section animations.
- Markets, Portfolio, and Profile use entrance animations for content blocks.
- Tab switches include animated transitions.
- Returning to Home replays Home animations for a dynamic dashboard feel.

## Quality Bar

Before pushing changes, run:

```bash
flutter analyze && flutter test
```

The project should remain analyzer-clean and test-green at all times.
