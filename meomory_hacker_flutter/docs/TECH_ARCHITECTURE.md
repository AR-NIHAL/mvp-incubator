# Technical Architecture

## Architecture Goals
- Keep app shell and gameplay clearly separated
- Favor simple, testable data flow over clever abstractions
- Build for mobile performance and iteration speed
- Make future level/content additions cheap

## Stack Roles
- Flutter: app shell, menus, overlays, theming, navigation, lifecycle integration
- Flame: gameplay loop, board rendering, timers, tap hit-testing, in-round effects
- Riverpod: shared app state, settings, progression, repositories, and level session orchestration
- Hive: local persistence for settings, unlocked levels, and best scores
- GoRouter: route definitions and transitions between non-gameplay screens

## Recommended App Layers
1. Presentation
   Flutter widgets, screens, overlays, theme, and navigation entry points
2. Game Application Layer
   Coordinators/use-cases that start levels, evaluate results, and bridge Flutter with Flame
3. Domain Layer
   Plain models and rules such as `LevelDefinition`, `LevelModifier`, `RunResult`, `ScoreBreakdown`
4. Data Layer
   Hive-backed repositories for progression and settings

## Gameplay Ownership Split
- Flutter owns shell navigation, top-level overlays, onboarding, settings, results, and level select
- Flame owns active board state, reveal timing, tile interaction, and round resolution visuals
- A small session controller bridges them so game logic does not leak into UI widgets

## Recommended State Boundaries
- Riverpod providers for:
  - app theme/settings
  - progression repository
  - level catalog
  - current level session controller
  - audio/haptics services
- Flame game instance should keep frame-level state local unless Flutter needs to react to it
- Persist only meaningful outcomes, not transient frame data

## Data Models
- `LevelDefinition`
  - id, chapter, title, gridSize, targetPattern, revealMs, inputMs, modifiers
- `LevelModifier`
  - type, params
- `RunResult`
  - levelId, success, accuracy, durationMs, attempts, score
- `ProgressionState`
  - unlockedLevelIds, bestScores, starsOrRanks, tutorialSeen
- `SettingsState`
  - soundOn, hapticsOn, reducedMotion, highContrast

## Routing Plan
- `/` splash/bootstrap
- `/home`
- `/levels`
- `/play/:levelId`
- `/result/:levelId`
- `/settings`

## Persistence Plan
- One Hive box for settings
- One Hive box for progression/profile
- Keep schema small and versioned early
- Save on level completion and important settings changes only

## Folder Structure
```text
lib/
  app/
    app.dart
    router.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_text_styles.dart
  core/
    constants/
    extensions/
    services/
      audio_service.dart
      haptics_service.dart
    utils/
  features/
    bootstrap/
      presentation/
    home/
      presentation/
    settings/
      application/
      data/
      domain/
      presentation/
    progression/
      application/
      data/
      domain/
    levels/
      data/
      domain/
    gameplay/
      application/
        level_session_controller.dart
        score_calculator.dart
      domain/
        models/
        rules/
      presentation/
        screens/
        widgets/
        overlays/
      flame/
        memory_hacker_game.dart
        components/
        systems/
  main.dart

assets/
  audio/
  fonts/
  images/
  levels/
    level_definitions.json

docs/
```

## Content Strategy
- Store handcrafted levels as JSON or Dart constants loaded through a level repository
- Use data-driven modifiers so new levels do not require new screen logic
- Keep mechanic count intentionally low and recombine them for variety

## Testing Strategy
- Unit test score calculation and progression unlock rules
- Widget test critical shell flows such as level select and result screens
- Lightweight integration test for start level -> finish level -> save progress path
- Manual device testing for gameplay feel, timing, and touch accuracy

## Keep It Realistic
- Start with one Flame game scene, not multiple scene frameworks
- Avoid event buses unless a simple controller/provider can handle the flow
- Avoid premature plugin/service abstractions that only wrap one implementation
- Do not over-model the domain until the first 10 levels are fun
