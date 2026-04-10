# Memory Hacker

Memory Hacker is a modern Flutter mobile game where players watch a neon sequence, memorize it, and reproduce it before the countdown expires.

## Features

- Clean architecture with `models`, `screens`, `widgets`, `services`, and `providers`
- Riverpod state management
- Dynamic level generation that ramps difficulty automatically
- Animated pattern preview and tap grid
- Score, lives, timer, high score, and local progress saving
- Hacker-style dark interface with reusable neon widgets
- Optional hooks for sound effects and vibration feedback

## Project Structure

```text
lib/
  main.dart
  models/
  providers/
  screens/
  services/
  theme/
  widgets/
```

## Run The App

1. Install the latest stable Flutter SDK.
2. Open a terminal in `memory_hacker`.
3. Run `flutter pub get`.
4. Run `flutter run`.

## Release Notes

- Launcher icons are generated from `assets/branding/app_icon.png`.
- Native splash screens are generated from `assets/branding/splash.png`.
- If you update the artwork, rerun `flutter pub run flutter_launcher_icons` and `flutter pub run flutter_native_splash:create`.
- Before uploading to Google Play, replace the debug signing config in `android/app/build.gradle.kts` with your release keystore setup and use your final application ID.

## Notes

- Sound effects are wired as placeholders through `SoundService`, so you can drop assets into `assets/sounds/` later.
- Vibration feedback works on supported devices when the setting is enabled.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
