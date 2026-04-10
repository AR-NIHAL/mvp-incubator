# Memory Hacker

Memory Hacker is a mobile-first cyberpunk memory puzzle game built with Flutter and Flame. The current MVP focuses on one playable mode, `Sequence Breach`, where players watch a short grid sequence, remember it, and repeat it before the timer expires.

## What I Built

- A premium dark Flutter shell for splash, landing, level select, settings, gameplay, and results
- A playable Flame-powered `Sequence Breach` board on a 3x3 grid
- Ten handcrafted MVP levels with gradual difficulty ramping
- Persistent local progression, best-result tracking, and first-run tutorial state using Hive
- GoRouter-based app flow and Riverpod-based app bootstrap/data wiring

## Core Mechanic

`Sequence Breach` follows a simple loop:

1. Watch the sequence playback on the 3x3 board.
2. Remember the order after the board resets.
3. Repeat the sequence before the timer runs out.

Success unlocks the next mission. Failure keeps the mission replayable. Results show elapsed time, step count, progression messaging, and next actions.

## Stack

- Flutter for the app shell, routing, screens, and theming
- Flame for the gameplay board and session loop
- Riverpod for bootstrap and state access
- Hive / Hive Flutter for local persistence
- GoRouter for route handling

## Architecture

The project keeps Flutter shell concerns separate from Flame gameplay logic.

- `lib/app`
  App bootstrap, theme, and router
- `lib/features`
  Flutter screens for splash, home, level select, gameplay shell, settings, and results
- `lib/game`
  Flame engine, board components, gameplay session logic, controllers, models, and level catalog
- `lib/data/local`
  Hive-backed repositories and bootstrap services
- `lib/shared/widgets`
  Reusable shell widgets and state panels
- `docs`
  Product, architecture, roadmap, testing, and release notes

See [TECH_ARCHITECTURE.md](docs/TECH_ARCHITECTURE.md) for the planning source of truth that shaped the scaffold.

## MVP Feature List

- Portrait mobile-first UI
- Splash and landing flow
- Mission grid with locked and unlocked level states
- Ten real `Sequence Breach` missions
- Tutorial overlay for first-time players
- Pause, resume, restart, and quit flow
- Results screen with progression messaging and replay / next actions
- Local settings for sound, haptics, reduced motion, and contrast flags

## Run Locally

1. Install Flutter 3.35+ and a working Android or iOS toolchain.
2. Run `flutter pub get`
3. Run `flutter run`

Useful checks:

- `dart format .`
- `flutter analyze`
- `flutter test`

## Android Release Path

The Android project still uses the default Flutter-generated release setup. For a real distributable build, add your own signing config and replace the debug signing fallback before shipping.

- Debug build: `flutter run`
- Release APK: `flutter build apk --release`
- Release App Bundle: `flutter build appbundle --release`

Use [RELEASE_CHECKLIST.md](docs/RELEASE_CHECKLIST.md) before cutting a portfolio or store-ready build.

## What Is Deferred

- Additional game modes
- Audio, haptics, and richer FX implementation
- Cloud sync, leaderboards, achievements, multiplayer, ads, or monetization
- Deeper analytics, attempt history, and live-ops style features
- Native platform polish beyond a normal Flutter MVP release path

## Portfolio Framing

This repo is intentionally scoped as a clean MVP slice:

- product planning docs first
- shell architecture before gameplay expansion
- one mode polished end to end
- persistence and progression included
- no cloud features or scope-heavy extras
