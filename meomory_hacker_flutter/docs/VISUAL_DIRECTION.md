# Visual Direction Guide

## Creative Direction
The game should feel like a premium cyberpunk operating system, not a noisy arcade screen. Aim for controlled intensity: dark foundations, sharp luminous accents, restrained animation, and typography that feels engineered.

## Tone Words
- precise
- covert
- electric
- high-contrast
- premium
- minimal under pressure

## UI Principles
- Keep one focal action per screen
- Favor strong spacing and alignment over dense decoration
- Use motion to support state changes, not to constantly entertain
- Make gameplay tiles readable first, stylish second
- Preserve one-handed reach for primary actions in portrait mode

## Color Direction
- Base background: near-black with cool blue undertones
- Surface layers: charcoal, gunmetal, smoked glass
- Primary accent: neon cyan
- Secondary accent: acid magenta or electric lime, used sparingly
- Success: bright mint or cyan-green
- Error: vivid coral-red

Suggested palette starting point:
- `#0A0F1E`
- `#121A2B`
- `#1B2740`
- `#00E5FF`
- `#FF4FD8`
- `#7CFF6B`
- `#FF5F6D`
- `#E6F1FF`

## Typography
- Use a headline font with a futuristic edge for titles only
- Use a highly readable sans-serif for body, labels, and buttons
- Avoid overly stylized techno fonts in small sizes
- Keep numerals crisp because timers and scores matter

Recommended pairing approach:
- Display: orbitron-like or squared sci-fi style
- UI/body: modern geometric sans with clean weights

## Gameplay Board Style
- Tiles should read like network nodes or memory chips
- Default tile state should be calm and low-contrast
- Revealed target state should glow clearly with a short pulse
- Incorrect taps should feel sharp and unmistakable
- Sequence mode can use numbered or connected trace overlays

## Motion Direction
- 150ms to 250ms transitions for UI microstates
- Slight stagger when panels enter
- Reveal phase can use scan-line or signal-sweep animation
- Success should feel crisp and upward
- Failure should feel brief and firm, never dramatic or punishing

## Effects Budget
- Use subtle bloom-like glows, not full-screen blur everywhere
- Keep particle effects rare and meaningful
- Limit simultaneous animation layers during gameplay to protect clarity and performance

## Audio Direction
- Soft synth pulses for navigation
- Distinct digital ticks during reveal/input timing
- Clean confirm/deny sounds with light glitch flavor
- Haptics should reinforce correct taps, errors, and completion beats

## Accessibility Notes
- Never rely on color alone to show target vs non-target
- Support high-contrast mode planning from the start
- Keep tap targets generous even when boards become denser
- Allow reduced motion and haptics toggles in settings
