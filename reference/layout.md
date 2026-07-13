# Layout, spacing & adaptive behavior

Space is the most underused design tool. Generous, consistent whitespace is the single biggest premium signal; a stretched phone layout on a tablet is the single biggest amateur one.

## Spacing system

- 4pt scale (`Insets` in tokens.dart): 4/8/12/16/24/32/48/64. Nothing off-scale.
- **Proximity communicates grouping.** Related items 8–12 apart; distinct sections 24–32; unrelated zones 48+. Equal spacing everywhere reads as no hierarchy at all — vary it for rhythm.
- Screen edge padding: 16–20 (compact) → 24–32 (wider). Same gutter on every screen; inconsistent gutters read as sloppy.
- Prefer `Gap`/`SizedBox` from the scale between siblings over per-widget margins; padding belongs to containers, margins to layouts.

## Hierarchy without cards

Cards are the lazy answer. Ask what the grouping actually needs:
- Whitespace alone (most of the time)
- A hairline `Divider` (themed `outlineVariant`, thickness 1)
- A background tint (`surfaceContainerLow`) *or* a border — rarely both
- A real `Card` only when elevation communicates real hierarchy
- **Nested cards are always wrong.** DENSITY ≥ 7 surfaces (dashboards, tables): no card wrappers at all; data breathes in plain layout with 1px separators.

Squint test: blur your eyes at the screen. The intended reading order should survive. If everything is the same visual weight, hierarchy failed — fix with size (3:1+ between levels), weight, and position before reaching for color.

## Window size classes (M3)

| Class | Width | Navigation | Layout |
|---|---|---|---|
| Compact | < 600 | `NavigationBar` (bottom, 3–5 destinations) | Single column/pane |
| Medium | 600–839 | `NavigationRail` | Single pane + optional secondary |
| Expanded | ≥ 840 | Extended rail or `NavigationDrawer` | Multi-pane (list-detail, supporting pane) |

```dart
enum SizeClass { compact, medium, expanded }

SizeClass sizeClassOf(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width; // .sizeOf, not .of — avoids extra rebuilds
  if (w < 600) return SizeClass.compact;
  if (w < 840) return SizeClass.medium;
  return SizeClass.expanded;
}
```

- `LayoutBuilder` for a widget responsive to its *parent's* constraints; `MediaQuery.sizeOf` for window-level decisions. Never device-model or `Platform.isIOS` checks for layout.
- Reading width: cap prose at ~640–720 logical px, centered. Wide dashboards: grid reflows by `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 360)` rather than fixed column counts.
- **Global scale factor** (the Wonderous move): one multiplier from `MediaQuery.sizeOf(context).shortestSide` (≈0.85 below 400 → 1.0 at 600 → 1.25 above 1000) applied *inside* the token system to fonts and insets together — a 5–25% bump that does most of the tablet-feel legwork without any screen knowing about it.
- Restructure, don't reflow: on expanded, a list screen becomes list-detail (`master + VerticalDivider(width: 1) + detail`), not a wider list.

## Slivers — scroll surfaces that feel designed

A plain `ListView` under a static `AppBar` is the default; scroll-aware composition is the upgrade. `CustomScrollView` + slivers:

- **Collapsing headers:** `SliverAppBar.medium`/`.large` (M3 patterns, free) or `SliverAppBar(pinned: true, expandedHeight:, flexibleSpace: FlexibleSpaceBar)` for art-directed heroes — background image with parallax (`CollapseMode.parallax` is the default), title that scales down as it pins. Add `stretch: true` + `StretchMode.zoomBackground`/`fadeTitle` for iOS-feel overscroll stretch; `floating: true, snap: true` for reappear-on-scroll-up.
- **Pinned section headers:** `SliverPersistentHeader(pinned: true)` (or `sliver_tools`' `SliverPinnedHeader`) for sticky group labels in long lists.
- **Mixed content:** `SliverList.builder` + `SliverGrid` + `SliverToBoxAdapter` compose in one scroll view — never nest scrollables with `shrinkWrap`.
- `CupertinoSliverRefreshControl` for iOS-feel pull-to-refresh inside sliver scrolls; `CupertinoSliverNavigationBar` for iOS large-title screens.
- Overscroll is a design surface: `stretch` (Android 12+) comes free; a subtle custom over-scroll response on a hero header reads premium. Keep it physical, never bouncy-cartoon.
- Since Flutter 3.27, `Row`/`Column` take `spacing:` — prefer it over repeated `SizedBox` gaps for simple runs.

## Device resilience — why flagship-tested layouts break on budget phones

Flutter lays out in logical pixels: `logical = physical ÷ devicePixelRatio`. Three independent multipliers make a budget phone's canvas **smaller while its text renders bigger** — and they stack:

1. **Logical resolution.** The world's #1 phone resolution is **360×800dp** (Redmi/Samsung-A/Tecno class); plenty run 360×640. Your dev flagship is 411–430dp wide — testing only there tests the easiest case.
2. **Display size / OEM density.** Users raise Android's Display size (and OEMs ship denser defaults) → `devicePixelRatio` rises → the same phone becomes **~311–330dp wide**.
3. **System font scale.** Android 14+ reaches **200%**; 115–130% is everyday. Glyphs grow while the canvas shrank: a 120dp label at 1.3× is ~156dp wide, in a column 50dp narrower than your device.

A fixed-size box in that path clips or overflows — and **release builds clip silently** (yellow stripes are debug-only), so users see breakage you never did.

**The floor:** every screen survives **320×568dp @ 1.3× font scale**; **360×640 @ 1.3** must look *good*, not just survive.

**The rule that fixes the whole class** (the constraints model: *constraints go down, sizes go up*): size from **available space**, never from coordinates or device models. Every overflow is a child whose minimum intrinsic size exceeds its incoming constraints — make something elastic (`Expanded`), reflowable (`Wrap`, `maxLines`), scrollable, or, last resort, shrinkable (`FittedBox`).

```dart
// "Fill the screen, scroll when it doesn't fit" screen skeleton:
LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(
  child: ConstrainedBox(
    constraints: BoxConstraints(minHeight: constraints.maxHeight),
    child: IntrinsicHeight(child: Column(
      children: [header, form, const Spacer(), submitButton],
    )),
  ),
));
// One-line display values that must never wrap (prices, stats):
FittedBox(fit: BoxFit.scaleDown, child: Text('₹1,24,999', maxLines: 1, style: display))
// Chrome that genuinely can't flex (tab bars, badges): clamp, never disable
MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3, child: bottomBar)
```

Never `FittedBox` paragraphs — shrinking body text defeats the user's font-size choice; reflow it. Reading content stays functional at 2.0× with scrolling (WCAG 1.4.4).

**The designSize-scaling trap.** `flutter_screenutil`-style `.w/.h/.sp` projects the designer's 375×812 frame onto the device: it scales the *box down* while system font scale pushes the *text up*, and height-ratios lie on short screens. It's zoom, not layout — it produces exactly this bug class. **Banned for product UI** (acceptable only for pixel-faithful art screens, with `minTextAdapt` and clamps). `MediaQuery.width × 0.3` math is the same disease. `auto_size_text`: sparingly — headlines/badges in bounded constraints only.

**Test matrix (CI fails before users do):** 320×568 @ 1.0 · 360×640 @ 1.0 and 1.3 · 360×800 @ 1.3 (the #1 fleet device) — all must pass; 360×800 @ 2.0 functional with scrolling; landscape + ~500dp split-screen as smoke test.

```dart
testWidgets('fits budget phone at 1.3x', (tester) async {
  tester.view.physicalSize = const Size(720, 1280);  // 360×640 @ DPR 2
  tester.view.devicePixelRatio = 2.0;
  tester.platformDispatcher.textScaleFactorTestValue = 1.3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const MyApp());
  expect(tester.takeException(), isNull); // overflow throws in tests — a free regression net
});
```

Emulate on hardware: `adb shell wm size 720x1280 && adb shell wm density 320` (≈360×640dp), `adb shell settings put system font_scale 1.3`; reset with `wm size reset && wm density reset`. One cheap physical Android on the desk catches density, font scale, and low-end GPU truth (blur/shadow overdraw that's free on flagships janks a 2GB device — gate heavy effects) at once.

## Structural safety

- **`SafeArea`** around screen content — notches, status bars, home indicators, camera cutouts.
- **Overflow is a shipped bug, not a warning.** `Expanded`/`Flexible` in every `Row` holding text; `TextOverflow.ellipsis` + `maxLines` on any string you don't control; scroll views around variable content. Test the device-resilience matrix above before declaring done.
- **Keyboard:** scrollable forms; focused field scrolled into view; `resizeToAvoidBottomInset` default respected; bottom CTAs padded by `MediaQuery.viewInsetsOf`.
- Thumb zone: primary actions in the bottom third (FAB, bottom bar, sheet CTAs); destructive/rare actions top. ~75% of interactions are thumb-driven.
- Lists: `ListView.separated` with themed hairlines *or* gap spacing — not both. Rows ≥ 48px tap height, 12–16 vertical padding.

## Screen anatomy discipline

- One primary action per screen. If two CTAs share an intent ("Save" and "Apply"), one label wins app-wide.
- App bar: flat, surface-colored, `scrolledUnderElevation` hairline on scroll only, left-aligned title on Android / centered on iOS (platform.md).
- No layout family repeated wall-to-wall: a feed of identical icon+title+subtitle cards is scaffolding, not design. Vary row anatomy by content type.
- Section labels: plain-language headers. No `01 · SECTION` numbering, no tiny all-caps tracked eyebrows above every block.

**NEVER:** arbitrary paddings (13, 18, 22); `h-screen`-style fixed full-height boxes that fight the keyboard; horizontal scroll as an accident; `Platform.isIOS` to pick a layout (input and width decide layout; platform decides idiom); pixel-perfect absolute `Positioned` layouts that break on the next device.
