# MVP Scope

## MVP Goal
Ship a polished vertical slice that proves the game loop is fun, readable, and replayable on mobile without depending on content-heavy systems.

## In Scope
- Portrait-only mobile experience
- Flutter app shell for routing, menus, settings, overlays, and persistence wiring
- Flame gameplay scene for the memory board and round state
- One main mode: linear mission progression
- 10 handcrafted levels with escalating complexity
- Grid sizes from simple to moderate, such as 3x3 up to 5x5
- Pattern reveal, hide, input, resolve, and score phases
- Limited modifiers introduced gradually:
  - short reveal windows
  - decoy tiles
  - timed input phase
  - sequence order levels
- Local progression save with Hive
- GoRouter flows for splash, home, level select, gameplay, results, settings
- Riverpod state management for app, progression, and settings state
- Audio and haptic feedback hooks
- Basic analytics-ready event naming, even if not yet wired to a backend

## Out of Scope
- Endless mode
- Daily challenges
- Story cutscenes
- Cloud saves
- Achievements
- Skins and theme unlocks
- Procedural content
- Social features
- Localization beyond writing with future translation in mind

## MVP Quality Bar
- Loads quickly and feels responsive on mid-range phones
- Every button and screen has clear visual hierarchy
- Gameplay states are easy to distinguish at a glance
- Failure feels fair and immediately retryable
- No feature requires backend infrastructure

## Release Checklist
- Tutorial validated through manual playtesting
- All 10 levels tuned for difficulty curve
- Save/load reliability tested across app restarts
- No blocking bugs in navigation or gameplay state transitions
- Audio, haptics, and pause/resume behave safely on device lifecycle changes

## Post-MVP Scope
- Endless survival mode with speed escalation
- Daily challenge seeded locally or remotely later
- More level packs and mechanic variants
- Light meta-progression such as ranks, badges, or visual unlocks
- Accessibility extensions such as higher contrast themes and reduced effects mode
- Cloud sync and cross-device progress
