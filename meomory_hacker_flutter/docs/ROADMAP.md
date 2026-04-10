# 6-Week Execution Roadmap

## Week 1: Foundation
- Initialize Flutter project structure and dependencies
- Set up app theme, routing shell, portrait lock, and baseline folders
- Define domain models for levels, settings, progression, and results
- Add Hive bootstrap and basic repository interfaces
- Create visual mood references and UI component targets

## Week 2: App Shell
- Build splash, home, level select, settings, and result screens
- Wire GoRouter flows
- Implement Riverpod providers for settings and progression
- Add placeholder data for level list and unlock flow
- Validate mobile-first spacing and navigation on device

## Week 3: Core Gameplay Slice
- Create Flame game scene and memory board component
- Implement reveal -> hide -> input -> resolve round loop
- Add tap handling, timing, and basic success/fail states
- Connect one test level end-to-end from shell to gameplay and back

## Week 4: Content And Scoring
- Implement score calculator and result summary
- Add level definition loading and the 10 handcrafted levels
- Support first modifier set: time pressure, decoy flash, ordered sequence
- Persist completion, best score, and unlock progression
- Run first full difficulty tuning pass

## Week 5: Polish
- Improve animations, transitions, audio, and haptics
- Refine tutorial/onboarding clarity
- Add accessibility toggles such as reduced motion and high contrast groundwork
- Tighten failure/retry flow for fast replays
- Perform device performance checks on mid-range hardware targets

## Week 6: Stabilization And Launch Prep
- Fix gameplay state edge cases, app lifecycle issues, and persistence bugs
- Finish QA pass across all levels
- Balance level timings and score thresholds
- Clean code, remove dead paths, and document setup
- Prepare store-ready assets and release checklist

## Risks
- Flame/Flutter boundary getting messy if gameplay state leaks into UI
- Solo-dev polish time expanding beyond schedule
- Level design taking longer than expected if mechanics proliferate
- Over-animating the interface and hurting gameplay readability

## Scope-Control Advice
- Keep one mode for MVP: handcrafted mission progression
- Cap mechanic count at three meaningful modifiers for launch
- Prefer tuning existing levels over inventing new systems
- If schedule slips, cut decorative features before cutting clarity or responsiveness
- Treat premium feel as polish on a simple loop, not as more features
