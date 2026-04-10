# Testing Notes

## Automated Coverage

- Unit tests cover level catalog lookup and no-fallback behavior
- Unit tests cover progression unlock logic and results mapping
- Widget tests cover first-time tutorial presentation and pause sheet actions

Run the suite with:

- `dart format .`
- `flutter analyze`
- `flutter test`

## Manual Smoke Test Focus

### First Launch

- Open the app from a clean install
- Start the first mission
- Confirm tutorial appears once
- Dismiss tutorial and verify the mission starts normally

### Gameplay Loop

- Watch sequence playback on the 3x3 grid
- Enter a correct sequence and confirm success
- Enter a wrong sequence and confirm failure
- Use pause, resume, restart, and quit

### Progression

- Complete mission 1 and confirm mission 2 unlocks
- Confirm completed missions remain replayable
- Confirm locked missions stay visibly locked

### Results

- Confirm success and failure both show mission name, elapsed time, and steps
- Confirm next mission CTA appears only when progression unlocks it
- Confirm replay and back-to-grid actions work from results

### Persistence

- Close and relaunch the app
- Confirm unlocked missions persist
- Confirm best results persist
- Confirm settings toggles persist
- Confirm tutorial state persists

## Known MVP Limits

- Results are based on best saved run per mission, not full attempt history
- Audio and haptics settings are persisted but not fully wired into sensory output yet
- Android release signing still needs real production credentials before distribution
