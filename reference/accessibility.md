# Accessibility

Baseline, not optional. An inaccessible screen is an unfinished screen, and most of this costs minutes when done during the build and days when retrofitted.

## Contrast (mechanical)

- Body text ≥ 4.5:1; large text and UI components/icons ≥ 3:1. WCAG "large" = 18pt (≈24 logical px) or 14pt bold (≈18.5lp). Note Flutter's `textContrastGuideline` uses a looser 18/14lp threshold — passing the widget test is a floor, not full WCAG.
- Applies to: hint text, helper text, error text, placeholder, disabled-looking-but-active labels, text over images (add a scrim), focus indicators (≥ 3:1 against adjacent colors).
- Verify in **both** themes. Dark mode fails contrast more often (desaturated accents on near-black).

## Touch targets

- ≥ 48×48dp (44pt iOS floor). `kMinInteractiveDimension` is 48 — don't shrink it with `materialTapTargetSize: .shrinkWrap` on touch surfaces.
- Visual glyph may be smaller than the hit area: pad the target, not the icon.
- ≥ 8dp between adjacent targets (dense icon rows are misfire farms).

## Semantics (screen readers)

- `tooltip:` on every `IconButton` — it doubles as the semantic label.
- `Semantics(label:, button: true, header: true)` on custom tappables and section headers; concise labels, no "button" suffix (the role announces itself).
- `MergeSemantics` around composed rows (avatar + name + status = one announcement); `ExcludeSemantics` on decorative images.
- Dynamic updates: prefer `Semantics(liveRegion: true)` on the changing widget; `SemanticsService.sendAnnouncement` only as a fallback (`announce` is deprecated, and announcement events are deprecated on Android).
- Images carrying information get labels; decorative ones get excluded. Alt text describes the information, not the picture.
- Custom gesture surfaces (`GestureDetector` painting its own UI) must add `Semantics` with `onTap` handlers or they're invisible to assistive tech.

## Text scaling

- Support to 200%. Read `MediaQuery.textScalerOf(context)`; never `textScaleFactor` (deprecated), never `TextScaler.noScaling` app-wide.
- If a specific surface truly can't flex (a pinned tab bar):

```dart
MediaQuery.withClampedTextScaling(maxScaleFactor: 1.6, child: bar)
```

- No fixed heights around text; min-constraints + padding. Buttons grow with their label.
- Test pass at 130% every screen; 200% for the critical path.

## Motion & input

- `MediaQuery.disableAnimationsOf(context)` honored: movement collapses to crossfade/instant (motion.md). Also respect `MediaQuery.boldTextOf` and `highContrastOf` where the design can flex.
- Keyboard access on web/desktop: everything reachable and operable, visible focus, logical traversal order (`FocusTraversalGroup` where the visual order diverges from the widget order).
- Never color as the only signal (error = red border **and** icon **and** message).

## Verification (do, don't assume)

- Run the critical path with TalkBack (Android) and VoiceOver (iOS) once per milestone: every control announced, actionable, in a sensible order.
- Widget-test guardrails:

```dart
final handle = tester.ensureSemantics();
await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
await expectLater(tester, meetsGuideline(textContrastGuideline));
await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
handle.dispose();
```

**NEVER:** icon-only controls without labels; disabled-state gray below contrast on actionable text; scroll views that trap screen-reader focus; auto-playing motion that can't be stopped; interactive elements announced as plain text.
