# Release Checklist

## Product Check

- Confirm MVP scope still matches [MVP_SCOPE.md](MVP_SCOPE.md)
- Confirm only `Sequence Breach` is shipped
- Confirm all ten handcrafted missions are playable from the mission grid
- Confirm tutorial appears on first run and stays dismissed on later runs

## Quality Check

- Run `dart format .`
- Run `flutter analyze`
- Run `flutter test`
- Smoke-test first launch, repeat launch, mission unlock flow, results flow, and settings persistence
- Check gameplay, level select, settings, and results on a small portrait device size

## Android Build Check

- Verify `applicationId`, app name, and version are correct for the intended build
- Replace debug signing fallback with a real release signing config before distribution
- Run `flutter build apk --release`
- Run `flutter build appbundle --release` if preparing Play Store delivery
- Install the release build on a physical Android device and verify startup, progression, and navigation

## Portfolio / Demo Check

- README reflects the current playable MVP
- Screenshots or recording capture splash, mission grid, gameplay, pause, and results
- Remove any debug-only copy, stale placeholder text, or obsolete compatibility files
- Confirm the repo root and docs folder are tidy enough for public review

## Final Review

- Check invalid mission ids fail safely
- Check quitting mid-run never corrupts progression
- Check restart fully resets the current mission
- Check no route leads to an unrecoverable blank screen
