# Craft — building a feature or app end-to-end

Most generated UIs fail not because of bad code, but because of skipped thinking. Craft makes the thinking explicit, then builds to a production bar.

## Step 0 · Foundation check

Look at the project. Existing theme/tokens → use them; don't fork a parallel visual system. No theme (greenfield) → the foundation comes first, full stop: [theme.md](theme.md) greenfield order before any screen. Existing state-management/navigation choices → respect them.

## Step 1 · Shape (before code)

Produce a compact brief and pause. 3–5 bullets when the request is unambiguous, fuller when it isn't:

- **What's being built** and the one primary user action per screen.
- **Design Read + dials** (from SKILL.md setup).
- **Content reality:** what does this screen hold at 0 items, 5, and 500? What's the longest realistic string? Design for those, not for the demo data.
- **Key states:** loading / empty / error / success enumerated now, not discovered later.
- **Direction:** color strategy + type direction + one named reference or anti-reference. "Not adjectives" — 'clean and modern' is not a direction; 'ink-on-paper density like Things, one warm accent' is.
- End with "confirm or override." **The pause is the point** — shape confirmation is the green light, not the request itself, unless the user's ask was already fully specified. In a non-interactive run (CI, headless agent), state the brief's assumptions explicitly and proceed; the brief still gets written.

## Step 2 · Build order

1. Tokens/theme deltas first (anything new this feature needs — a semantic color, a component theme).
2. Static structure: layout, hierarchy, real content shapes. Verify overflow-safety immediately (smallest width, 130% scale).
3. The full state cycle: interactive states, loading/empty/error.
4. Motion pass: transitions and micro-interactions per the dials ([motion.md](motion.md)).
5. Platform pass: check both idioms, size classes if targeted ([platform.md](platform.md)).

## Production bar (definition of done, not inspiration)

- Real content shapes — no lorem, no "John Doe", realistic lengths and counts.
- Every state reachable and designed: default, pressed, hover/focus (web/desktop), disabled, loading, error, empty, overflow (long text, many items), first-run.
- Zero inline styling; everything through theme/tokens.
- Both themes verified visually; contrast passes; 130% text-scale pass.
- Semantics: labeled icon buttons, merged rows, tested tap-target/contrast guidelines where tests exist.
- `const` discipline, builder lists, sized images.
- The SKILL.md pre-flight check run honestly.

## Verify like a designer

Run the app (device/simulator — not just `flutter analyze`). Look at what you built the way a design director would: squint test for hierarchy, both themes, rotation, text scale, slow-motion pass on animations (`timeDilation = 5.0`), scroll feel on a real device when possible. Screenshot key screens if a screenshot tool exists; a screenshot you didn't look at doesn't count.

When no interactive device is available, make verification executable with a matrix golden/screenshot test — both themes × two text scales, per key screen:

```dart
testWidgets('home screen matrix', (tester) async {
  for (final (mode, scale) in [(ThemeMode.light, 1.0), (ThemeMode.dark, 1.0),
                               (ThemeMode.light, 1.3), (ThemeMode.dark, 1.3)]) {
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: app(themeMode: mode),
    ));
    await tester.pumpAndSettle();
    await expectLater(find.byType(HomeScreen),
      matchesGoldenFile('goldens/home_${mode.name}_${scale}x.png'));
  }
});
// flutter test --update-goldens  → then READ the generated PNGs.
```

Overflow errors fail these tests automatically — that alone catches the most common shipped defect.

**The self-polish loop** (generate → screenshot → critique → patch, gated):
1. Screenshot the built screens at two sizes (360×690 + 430×932), both themes, with a long-content and an empty-data fixture.
2. Critique against a **falsifiable rubric** in a fresh pass — score 0–2 each: spacing on the token scale? one type system? one icon family? contrast ≥ 4.5:1? states present (loading/empty/error)? one filled CTA in the thumb zone? blur test passes? dark mode actually designed? Run the anti-patterns greps in parallel — some defects are cheaper to find in code than pixels.
3. Patch what scored < 2, re-screenshot.
4. **Hard cap: 3 iterations.** First pass catches layout/hierarchy, second spacing/color; beyond three you're trading wall-clock for micro-nudges and risking fix-A-breaks-B oscillation. Stop early when scores plateau. Report residual misses honestly.

Don't invent defects to look thorough; "first pass clean" is a legitimate verdict when it's true.

## Present

Show what was built, the states covered, deviations from the brief (never hide them), and what you'd polish next. Ask: what's working, what isn't?
