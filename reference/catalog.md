# Component & Animation Catalog

Named recipes the interview maps onto. Each entry: what it is, when it fits, how it's built. Personality fit uses the [interview.md](interview.md) styles. Everything here obeys the foundation rules (theme-sourced values, full state cycles, motion.md durations).

## Buttons

**Fill styles**
| Variant | Build | Fits |
|---|---|---|
| Solid filled | `FilledButton`, primary fill | Every style — the default primary |
| Tonal | `FilledButton.tonal`, `secondaryContainer` | Minimal, Soft, secondary actions everywhere |
| Outlined hairline | `OutlinedButton`, 1px `outlineVariant` | Minimal, Editorial, Dark Tech |
| Ghost/text | `TextButton` | Tertiary actions, all styles |
| Pill CTA | Full-radius shape, generous horizontal padding | Playful, Soft, Bold |
| Inverse block | Ink-on-paper flipped (black button on light editorial page) | Editorial, Minimal |
| Glass | Blur fill + 1px white border — sparingly | Glass only |
| Glow accent | Solid fill + subtle same-hue shadow | Dark Tech (one per screen) |

Gradient buttons: allowed only when the brand genuinely owns a gradient; never as decoration. Two more with narrow homes: **3D-edge** (flat top + 2–4px darker bottom edge; press translates down into it — the Duolingo signature, Playful only) and M3 Expressive's **split button / button group** (main action + morphing chevron segment — Bold, via `m3e_collection`).

**Press behaviors** (pick ONE app-wide)
- **Scale press** — `AnimatedScale` 0.97, 120ms (components.md `Pressable`). Premium/minimal default.
- **Ink ripple** — Material `InkWell`/`InkSparkle`. Android-native feel, utility apps.
- **Opacity dim** — 0.6–0.7 while pressed. iOS-native/editorial feel.
- **Fill sweep** — background fills from press point (custom). Bold/editorial statement, hero CTAs only.
- **Spring pop** — scale ~0.93 in, overshoot ~1.03 out via spring (ratio 0.5–0.65). Playful only.
- **Glow intensify** — accent shadow blur 12→24px, ~200ms. Dark Tech, one per screen.

**Loading:** in-button `AnimatedSwitcher` to a small spinner, width stable, container keeps its color (graying out reads as disabled-forever), double-submit blocked (components.md). Past ~5s a spinner feels broken — switch to progress or skeleton. Success: morph to a checkmark 150–250ms; Playful may add the confetti burst. Never a dialog for a button action.

**Sizes:** primary ≥ 48–56dp tall; icon buttons 40–48 visual in ≥ 48 hit area; one primary per screen, `FilledButton` weight reserved for it.

## Navigation

| Pattern | Build | Fits / rules |
|---|---|---|
| Bottom bar (labeled) | `NavigationBar`, 3–5 destinations, indicator pill | Default mobile; labels always shown for utility |
| Bottom bar (icon-only) | `labelBehavior: onlyShowSelected` or none | Expressive apps with unambiguous icons |
| Floating pill bar | Inset rounded bar over content (Stack + SafeArea margin, ~16px side margins, 16–24px bottom inset), scroll-aware hide/reveal | Glass, Premium, iOS-26 feel; keep ≥ 48dp targets |
| Center-action bar | Bottom bar + prominent center FAB (notched or floating) | Creation-first apps (post, scan, add) |
| Rail / extended rail | `NavigationRail` ≥ 600dp | Tablet/desktop, auto per window class |
| Drawer | `NavigationDrawer` | ≥ 840dp or overflow destinations; never the primary mobile nav |
| Top tabs | `TabBar` underline or pill indicator | Peer content within a screen, 2–4 tabs |
| Segmented control | `SegmentedButton` / `CupertinoSlidingSegmentedControl` | Filters and modes, not navigation |

Scroll-aware chrome (premium tell): bar shrinks/hides on scroll-down, returns on scroll-up — `NotificationListener<UserScrollNotification>` driving an `AnimatedSlide/Container`.

## Menus & overlays

| Pattern | Build | When |
|---|---|---|
| Bottom sheet | `showModalBottomSheet` themed shape, drag handle | Mobile default for >2 choices or any input |
| Multi-page sheet | `wolt_modal_sheet` | Flows inside a sheet; morphs to dialog on wide screens |
| Detent sheet | `DraggableScrollableSheet` with `snapSizes` ~[0.33, 0.5, 0.95] (iOS medium/large detent feel) | Maps-style persistent panels |
| iOS pull-down | `pull_down_button` | iOS-facing overflow menus |
| Context menu | `CupertinoContextMenu` (iOS long-press preview) / `MenuAnchor` | Item-level actions |
| Dropdown/select | `DropdownMenu` (M3) or sheet on mobile | Prefer sheets under ~600dp |
| FAB menu / speed dial | Expanding FAB actions, staggered 30–50ms | 2–4 related create-actions; Playful/Bold |
| Dialog | `AlertDialog.adaptive` | Blocking decisions only |
| Toast/snackbar | Floating `SnackBar` + action | Transient confirmations; never for errors needing action |

## Iconography

One family app-wide; a stray glyph from a second family is the strongest "unstyled Flutter" tell. Coherence axes:

- **Stroke ↔ type weight:** ~1.5dp strokes pair with regular body text; 2dp with 500–600-weight UI. A thin icon next to bold text reads as a different product.
- **Corner language ↔ radius family:** rounded-terminal icons with soft/pill UIs; sharp icons with editorial/square UIs.
- **Selected state:** outlined at rest → **filled when selected** (M3 `NavigationBar` supports `selectedIcon:` natively; with Material Symbols animate the fill axis 0→100). No-fill families (Lucide): color + weight bump or the pill indicator instead.

| Family | Character |
|---|---|
| `material_symbols_icons` | The M3 default — variable axes (fill 0–100, weight 100–700, grade, optical size); Outlined/Rounded/Sharp. Use `Symbols.x`; tune weight ~300 + grade for premium feel |
| `phosphor_flutter` | 6 weights incl. duotone; design-forward, premium at light weight |
| `iconsax_flutter` | 6 styles; "Bulk" duotone reads premium in fintech-class UIs |
| `lucide_icons` | Clean modern-SaaS; no filled variants (plan selected states accordingly) |
| `hugeicons` | Largest consistent system; obscure glyphs |
| `cupertino_icons` / `flutter_sficon` | iOS-facing; note SF Symbols' license restricts to Apple platforms |

Default Material `Icons.*` at default weight is the "untouched template" signal — if staying Material, use Symbols with tuned axes.

## Charts & data viz

`fl_chart` is the default (themeable, implicit animations); `CustomPainter` for one signature sparkline/ring; Syncfusion when enterprise interactivity and its license fit. What makes charts beautiful:

- **Lines:** 2–3px stroke, `isStrokeCapRound: true`, `isCurved: true` (`curveSmoothness` ~0.35, `preventCurveOverShooting: true`), gradient area fill `primary` @ ~25–30% → transparent.
- **Grid:** horizontal only, 3–4 lines max, 1px at 8–12% opacity `onSurface`. No vertical gridlines, no chart border.
- **Bars:** rounded tops (radius ≈ ¼–½ bar width); non-selected bars dim when one is selected.
- **Tooltips:** themed card (`surfaceContainerHigh`, app radius token, bold tabular values) — never the default gray.
- **Draw-in:** swap from zeroed data to real data 250–800ms `easeOutCubic`, bars staggered 30–60ms; respect `disableAnimations`.
- **Numbers:** `FontFeature.tabularFigures()` on every changing/aligned number; hero metrics 32–48sp semibold with a small `onSurfaceVariant` label and a direction-colored delta chip; count-ups 600–1000ms.
- **Ramps from the scheme:** series = `primary`, `tertiary`, `secondary`, then tone steps of primary — never random hex; harmonize semantic green/red toward the scheme. Categorical max ~6 then group "other".
- **States:** loading = skeleton silhouette of the *same chart type* (never a spinner); empty = faint ghost chart + one line + a CTA that creates the first data point; error keeps the card with a retry.

## Cards & surfaces

- **Flat tinted** (`surfaceContainerLow`, no border) — Minimal, Soft
- **Hairline** (flat + 1px `outlineVariant`) — Editorial, Dark Tech, Minimal
- **Elevated soft** (low shadow, tuned) — Premium, Soft; light mode only
- **Color-blocked** (saturated fills, ink text) — Bold, Playful
- **Glass panel** — Glass style, few per screen (signature.md rules)
- **No card** — Density ≥ 7: plain rows + hairlines

One treatment per app. Tappable cards get the full ink/scale recipe (components.md).

## Inputs

- **Filled soft** (M3 filled, tinted fill, no heavy border) — most styles
- **Outlined hairline** — Editorial, Dark Tech, Minimal
- **iOS flat box** — bordered box ~36px, iOS-facing (platform.md)
- **Underline-only** — editorial forms, sparing
- Search: pill field or `SearchAnchor`; chips for active filters.

## Loading, empty, success

- **Skeletons** (skeletonizer) — all styles; shimmer sweep for Premium, plain pulse for Minimal.
- **Branded loader** — custom painter or Rive mark; only where waits are real and rare.
- **Empty states**: Minimal → typographic; Soft/Playful → illustration + action; Editorial → pull-quote style.
- **Success**: Calm styles → checkmark draw-on (`PathMetrics`); Playful → confetti + spring pop + success haptic; Premium → subtle scale-settle + light haptic.

## Animation catalog

**Entrances** (screen/content level)
- *Fade-rise*: opacity + 8–24px translateY, staggered 40–80ms — the universal entrance.
- *Scale-in*: 0.95→1.0 + fade for dialogs/popovers (origin-aware).
- *Blur-in*: blur 8→0 + fade — Premium hero moments (flutter_animate `.blur()`).
- *Clip reveal*: rect/circular reveal for onboarding panels — Bold.
- *Choreographed hero*: 3–5 elements sequenced (image → title → meta → CTA), once per app on a key screen — Premium/Bold.

**Screen transitions**
- *Container transform* (`OpenContainer`) — list→detail, the highest-impact premium transition.
- *Shared axis x/y/z* — siblings / steps / parent-child.
- *Fade-through* — bottom-nav tab switches.
- *Hero* — shared element continuity, stable tags.
- *Platform default* — always right on iOS pushes.

**Micro-interactions**
- Scale press, ink, fill sweep (buttons above).
- *Value roll*: number changes slide/roll via `AnimatedSwitcher` — dashboards, prices.
- *Icon morph*: `AnimatedIcon` / Rive state machine — nav, play/pause, like.
- *Toggle glide*: thumb + track color animate together, spring for Playful.
- *Chip select*: background sweep + check reveal, 150–200ms.
- *Progress draw-on*: `PathMetrics` line drawing — Premium/Editorial.

**Gesture-driven** (always interruptible, velocity-respecting)
- *Swipe-dismiss* with spring return below threshold.
- *Drag sheets* with detent snapping + `selectionClick` at snap.
- *Pull-to-refresh*: platform default, or `custom_refresh_indicator` branded pull — one custom gesture max per app.
- *Gesture-scrubbed parallax* (signature.md Wonderous pattern) — Premium/Bold hero screens.

**Ambient** (rare, subtle)
- *Mesh gradient drift* — Glass/Premium backdrops.
- *Teaser loop* (4s idle → 2s shimmer/shake invitation) — discoverables (signature.md).
- *Live indicator pulse* — only for genuinely live things.

**Celebration** (rare-moment budget only)
- Confetti burst + notification haptic + spring pop — Playful.
- Checkmark draw-on + light haptic — everyone else.
- Never celebrate routine actions; the 50th daily celebration is noise.

## Personality → default picks (cheat sheet)

| Style | Button press | Nav | Sheet | Card | Entrance | Transition |
|---|---|---|---|---|---|---|
| Minimal | Scale | Labeled bottom bar | Standard sheet | Flat tinted / hairline | Fade-rise (small) | Fade-through |
| Premium | Scale | Floating pill or labeled bar | Detent sheet | Elevated soft | Blur-in hero, fade-rise | Container transform + Hero |
| Bold | Fill sweep (heroes) | Icon bar or top tabs | Standard | Color-blocked | Clip reveal, choreographed | Shared axis |
| Soft | Scale (gentle spring) | Labeled bottom bar | Standard | Flat tinted, big radius | Fade-rise | Fade-through |
| Playful | Spring pop | Center-action bar | Multi-page sheet | Color-blocked | Staggered pops | Container transform |
| Editorial | Ink or inverse block | Top tabs / minimal bar | Standard | No card / hairline | Fade only | Platform default |
| Dark Tech | Scale, crisp | Labeled bar / rail | Standard | Hairline | Fade-rise fast | Shared axis x |
| Glass | Scale | Floating pill | Detent sheet | Glass panel | Blur-in | Container transform |
