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

## Structural safety

- **`SafeArea`** around screen content — notches, status bars, home indicators, camera cutouts.
- **Overflow is a shipped bug, not a warning.** `Expanded`/`Flexible` in every `Row` holding text; `TextOverflow.ellipsis` + `maxLines` on any string you don't control; scroll views around variable content. Test the smallest supported width, landscape, and 130% text scale before declaring done.
- **Keyboard:** scrollable forms; focused field scrolled into view; `resizeToAvoidBottomInset` default respected; bottom CTAs padded by `MediaQuery.viewInsetsOf`.
- Thumb zone: primary actions in the bottom third (FAB, bottom bar, sheet CTAs); destructive/rare actions top. ~75% of interactions are thumb-driven.
- Lists: `ListView.separated` with themed hairlines *or* gap spacing — not both. Rows ≥ 48px tap height, 12–16 vertical padding.

## Screen anatomy discipline

- One primary action per screen. If two CTAs share an intent ("Save" and "Apply"), one label wins app-wide.
- App bar: flat, surface-colored, `scrolledUnderElevation` hairline on scroll only, left-aligned title on Android / centered on iOS (platform.md).
- No layout family repeated wall-to-wall: a feed of identical icon+title+subtitle cards is scaffolding, not design. Vary row anatomy by content type.
- Section labels: plain-language headers. No `01 · SECTION` numbering, no tiny all-caps tracked eyebrows above every block.

**NEVER:** arbitrary paddings (13, 18, 22); `h-screen`-style fixed full-height boxes that fight the keyboard; horizontal scroll as an accident; `Platform.isIOS` to pick a layout (input and width decide layout; platform decides idiom); pixel-perfect absolute `Positioned` layouts that break on the next device.
