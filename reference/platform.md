# Platform adaptation — iOS, Android, web, desktop

The decision rule: **conventions differ → adapt; brand-owned → keep identical.** Navigation transitions, switches, dialogs, date pickers, scroll physics, edit menus adapt per platform. Buttons, cards, and custom brand components stay identical everywhere. Cupertino widgets are used selectively, not as a blanket replacement.

The slop test per platform: on iOS, the tell is "ported from a website / an Android app" — broken back-swipe, Material zoom transitions, Android-style dialogs. On Android, it's "an iOS app wearing Android's skin" — iOS-style back chevrons, non-Material patterns fighting system navigation.

## What Flutter adapts automatically (don't break it)

- **Page transitions:** Android zoom, iOS slide-with-parallax; `fullscreenDialog: true` → bottom-up modal.
- **iOS edge-swipe back works out of the box** with standard routes. It is muscle memory. Custom transitions or `PopScope` handlers that eat it are shipped defects. Android predictive back likewise.
- **Scroll physics:** iOS bouncing + status-bar-tap scroll-to-top; Android clamping + stretch. Don't override globally.
- Text selection handles/toolbars, and built-in haptics (picker ticks, long-press) per platform.

## Adaptive constructors (free wins — use them)

`Switch.adaptive()`, `Slider.adaptive()`, `Checkbox.adaptive()`, `Radio.adaptive()`, `CircularProgressIndicator.adaptive()`, `RefreshIndicator.adaptive()`, `AlertDialog.adaptive()`, `Icons.adaptive.share`, `Icons.adaptive.arrow_back`.

## iOS recipes (where manual adaptation earns its keep)

- **App bar:** `toolbarHeight: 44`, `centerTitle: true`, transparent surface tint, `scrolledUnderElevation: 0.1`. Large-title pattern via `CupertinoSliverNavigationBar` in a `CustomScrollView` for top-level screens; negative letterSpacing on large titles.
- **Bottom navigation:** `CupertinoTabBar` styling or a themed `NavigationBar` that respects iOS type; max 5 tabs; tabs are sections, never actions.
- **Text fields:** flat bordered box, ~36px height, minimal padding — not the Material underline.
- **Sheets:** `showCupertinoSheet` (drag-to-dismiss, stacked-card look) for iOS-facing modals; `CupertinoContextMenu` for long-press previews.
- **Corners:** iOS 26-era polish uses the real squircle — `RoundedSuperellipseBorder` / `ClipRSuperellipse` (Flutter 3.32+) on custom iOS-facing components.
- **Dialogs:** `AlertDialog.adaptive()` renders `CupertinoAlertDialog` on iOS automatically. Action sheets: `showCupertinoModalPopup` + `CupertinoActionSheet` for destructive choice lists.
- Gaps in Cupertino (pull-down menus etc.): `pull_down_button`, `modal_bottom_sheet` packages rather than hand-rolled approximations.
- HIG numbers: 44×44pt targets, Body anchors at 17px, tab bar ≤ 5, system-gesture zones left alone.

## Android recipes

- Material 3 is the rulebook: `NavigationBar` 3–5 destinations with `secondaryContainer` indicator pill; rail/drawer per window class (layout.md).
- Edge-to-edge with correct window insets; predictive back always works.
- 48×48dp targets, 8dp between; sp-based type (automatic via `TextScaler`); tonal elevation via the surface ladder, not arbitrary shadows.
- One FAB, one primary action. Snackbars (floating, themed) not raw toasts.
- Navigation transitions: container transform / shared-axis / fade-through (`animations` package) are the native-feeling vocabulary.
- Dynamic Color: support `DynamicColorBuilder` (package `dynamic_color`) with your tuned scheme as fallback when the user's wallpaper palette is available — expressive apps may deliberately opt out to protect brand color; decide, don't default.

## Platform-conditional idiom

```dart
final ios = Theme.of(context).platform == TargetPlatform.iOS; // respects overrides & tests
```

Use `Theme.of(context).platform` (not `Platform.isIOS`) so tests and per-widget overrides work. Adapt idiom (which control), never layout (width decides layout — layout.md).

## The 2026 design languages — what's real in Flutter today

Be precise about availability; faking unavailable system chrome reads as uncanny.

**Material 3 Expressive** (Android 16 QPR1 system-wide): springs-over-durations, 35 morphing shapes, XL type, new components. Flutter SDK support is **paused** — all M3E work lands in the future `material_ui` package, not `flutter/flutter`. What you CAN do today:
- Opt into the updated 2024-spec components: `Slider(year2023: false)`, `LinearProgressIndicator(year2023: false)`, `CircularProgressIndicator(year2023: false)` — gapped tracks, stop indicators, press morphs. `CarouselView` is in the SDK.
- Spring physics via the `motor` package (M3 + Apple spring presets, velocity-preserving retargets) or built-in `SpringSimulation`.
- Community `m3e_collection` / `material_new_shapes` for M3E shapes and components — pin versions, pre-1.0.
- Expressive *feel* without the library: vibrant seeded scheme, oversized display type, shape-morph on press, springy micro-interactions.

**iOS 26 Liquid Glass:** Cupertino SDK support is likewise **paused** (future `cupertino_ui` package). Today:
- `RoundedSuperellipseBorder`/`ClipRSuperellipse` (3.32+) for true Apple squircles — free, use everywhere iOS-facing.
- **Concentric corners:** child radius = parent radius − padding, so nested shapes and hardware corners align.
- The *behaviors* are plain Flutter: floating inset tab/tool bars, chrome that shrinks on scroll-down and re-expands on scroll-up, edge-to-edge content flowing under bars.
- True refraction: `liquid_glass_renderer` (Impeller-only, experimental — hero moments, capable devices, `FakeGlass` fallback) or real native chrome via `cupertino_native` (actual SwiftUI tab bar on iOS 26+).
- **A plain `BackdropFilter` blur is 2020 glassmorphism, not Liquid Glass** — on iOS 26 devices it reads as imitation. Either go native/shader or design deliberately custom.

**Android 16 (API 36):** edge-to-edge is **mandatory** (opt-out deprecated and ignored) — correct inset handling via `SafeArea`/`MediaQuery.paddingOf` is no longer optional polish. Predictive back is on by default; use `PopScope` + `PredictiveBackPageTransitionsBuilder`, and never gate back on a confirmation dialog — back must be previewable and cancellable.

## System chrome & app identity

The pixels outside your widgets are part of the design:

- **Status/nav bar icons per theme** — the classic dark-mode miss. Set `AppBarTheme.systemOverlayStyle` in both themes (`SystemUiOverlayStyle.dark` icons on light surfaces, `.light` on dark), or `AnnotatedRegion<SystemUiOverlayStyle>` for app-bar-less screens.
- **Edge-to-edge:** `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)` + transparent system bars; content scrolls under, `SafeArea` protects interactive elements.
- **Launcher icon and splash:** full recipes (iOS 26 layered `.icon`, Android adaptive **+ monochrome** layer, seamless splash-to-content handoff) live in [firstrun.md](firstrun.md).
- Keyboard appearance follows theme on iOS (`TextField.keyboardAppearance` defaults from brightness — verify on custom-themed inputs).
- **The last 5% (award-tier micro-details):** gradient/blur scroll-edge fades under floating chrome (the iOS 26 scroll-edge pocket, approximated with a `BackdropFilter`/gradient beneath app and tab bars); bottom list padding = `viewPadding.bottom + 16`; refresh indicator colored `primary`; text-selection handles themed; haptics land on the same frame as their visual event (a late haptic feels broken); platform overscroll kept (iOS bounce, Android stretch); heavy destination images precached so first navigation doesn't jank.

## Navigation architecture & gesture conflicts

- **go_router** for anything beyond trivial: `StatefulShellRoute.indexedStack` preserves per-tab state (tab switches must not reset scroll/form state); URL paths deep-linkable on web; dialogs/sheets that represent state get routes (`pageBuilder` with a dialog/sheet page) so back/URL behave.
- **The #1 accidental back-swipe killer:** a full-width horizontal `PageView`/`TabBarView` or `Dismissible` swallows the iOS edge-swipe. Fixes: leave edge insets to the system (padding the gesture area), use `DragStartBehavior.down`, or prefer tap-driven tab switching on iOS with the swipe as enhancement. Test the left-edge swipe on every horizontally-scrolling screen.
- Back always means "up one level," never "discard silently" — unsaved-changes surfaces intercept with `PopScope(canPop: false)` + an explicit choice, and that is the *only* sanctioned `PopScope` use.

## Web & desktop

- **Hover and focus are real states here** — every interactive element gets them (components.md). Cursor: `SystemMouseCursors.click` on tappables.
- **Keyboard:** full tab traversal, visible focus indicators (≥ 3:1 contrast — keep `WidgetState.focused` overlays/borders in component themes; `FocusableActionDetector` for custom controls), Enter/Space activate, Escape closes overlays. Shortcuts via `Shortcuts`/`Actions` for power surfaces.
- **Scrollbars:** visible for mouse input (`Scrollbar`/`ScrollbarTheme`); scroll wheels + trackpads both tested.
- Desktop density: `VisualDensity.adaptivePlatformDensity` or explicit compact density; 48dp touch minimums relax to ~32–40 for pointer-first surfaces, but never below.
- Window resize is continuous on desktop — layouts must be fluid between breakpoints, not snap-only. Test mid-drag widths.
- Web: no horizontal body scroll ever; back button = browser back (go_router paths, deep-linkable state); text selectable where users expect it (`SelectionArea` on content).

**NEVER:** Material zoom transition visible on iOS; `WillPopScope`/`PopScope` that swallows back gestures; Cupertino widgets on Android surfaces; hover-only affordances on touch builds; `Platform.isIOS` layout forks; disabling scroll physics to fake "app-like" feel on web.
