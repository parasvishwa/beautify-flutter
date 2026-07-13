# Theme — the foundation

Everything visual flows from here. Build this before any screen. The exit bar: a widget should never need an inline color, size, or radius — it reads `Theme.of(context)` or a token constant.

## 1. Design tokens (one file: `lib/theme/tokens.dart`)

```dart
import 'package:flutter/widgets.dart';

/// 4pt spacing scale. The only paddings/gaps that exist in this app.
abstract final class Insets {
  static const double xs = 4, sm = 8, md = 12, lg = 16, xl = 24, xxl = 32, xxxl = 48, huge = 64;
}

/// One radius family. Pick a language (sharp/soft/pill) and stay in it.
abstract final class Radii {
  static const Radius sm = Radius.circular(8);
  static const Radius md = Radius.circular(12);
  static const Radius lg = Radius.circular(16);
  static const BorderRadius card = BorderRadius.all(md);
  static const BorderRadius sheet = BorderRadius.vertical(top: Radius.circular(24));
}

/// Motion tokens, M3-aligned. Canonical duration rules live in motion.md.
abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 150);   // press feedback, small state
  static const Duration base = Duration(milliseconds: 250);   // in-place UI transitions
  static const Duration enter = Duration(milliseconds: 400);  // container enters (decelerate)
  static const Duration exit = Duration(milliseconds: 250);   // exits: 50-75% of enter (accelerate)
}
```

Two-layer token hierarchy when the app grows: primitive tokens (raw values) → semantic tokens (`surfaceCard`, `textMuted`). Widgets only ever touch the semantic layer.

## 2. ColorScheme — seed, then tune

`fromSeed` is a generator, not an answer. Untuned output is the monoculture.

```dart
const _seed = Color(0xFF3D5AFE); // the brand hue, never Colors.deepPurple

final lightScheme = ColorScheme.fromSeed(
  seedColor: _seed,
  brightness: Brightness.light,
  // .fidelity / .content keep a vivid seed vivid; .tonalSpot (default) mutes it.
  dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
).copyWith(
  // Tune the roles that carry the design. These are examples of the *kind* of
  // tuning — derive actual values from the brand, don't copy these.
  surface: const Color(0xFFFCFCFD),
  onSurfaceVariant: const Color(0xFF5A5B66), // muted text: a real step, still ≥4.5:1
  outlineVariant: const Color(0xFFE4E4EA),   // hairline borders
);

final darkScheme = ColorScheme.fromSeed(
  seedColor: _seed,
  brightness: Brightness.dark,
  dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
).copyWith(
  surface: const Color(0xFF101014), // near-black, never #000
);
```

**The surface-container ladder is the depth system.** Seven tone-based roles replace shadow-based elevation:

| Role | Use for |
|---|---|
| `surface` | Page background |
| `surfaceContainerLowest` | Cards on tinted backgrounds, lowest emphasis |
| `surfaceContainerLow` | Cards, list containers |
| `surfaceContainer` | Bottom sheets, menus, nav bar |
| `surfaceContainerHigh` | Dialogs |
| `surfaceContainerHighest` | Input fills, skeletons, highest-emphasis containers |
| `surfaceDim` / `surfaceBright` | Full-screen dim/bright variants |

Deprecated → replacement: `background` → `surface`, `onBackground` → `onSurface`, `surfaceVariant` → `surfaceContainerHighest`.

Dark-mode rules: base near `#101014`-ish, higher elevation = lighter container (the ladder does this for you), desaturate accents 20–30% (`fromSeed` dark handles most of it — verify), text off-white not `#FFF`.

## 3. TextTheme

Full treatment in [typography.md](typography.md). The theme-level requirement: build a complete `TextTheme` with deliberate sizes, weights, `height`, and `letterSpacing`, and `.apply()` scheme colors. Never ship `Typography` defaults untouched.

## 4. ThemeData assembly — style components once, centrally

```dart
ThemeData buildTheme(ColorScheme scheme, TextTheme text) => ThemeData(
  colorScheme: scheme,
  textTheme: text,
  scaffoldBackgroundColor: scheme.surface,
  splashFactory: InkSparkle.splashFactory,
  visualDensity: VisualDensity.standard,

  appBarTheme: AppBarTheme(
    backgroundColor: scheme.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0.5, // hairline appears only on scroll (iOS builds use 0.1 — platform.md)
    centerTitle: false,          // true on iOS builds; see platform.md
    titleTextStyle: text.titleLarge,
  ),

  cardTheme: CardThemeData( // CardThemeData, not CardTheme (3.29+)
    color: scheme.surfaceContainerLow,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: Radii.card,
      side: BorderSide(color: scheme.outlineVariant),
    ),
    margin: EdgeInsets.zero, // margins come from the layout, not the card
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: Insets.xl)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radii.md)),
      ),
      textStyle: WidgetStatePropertyAll(text.labelLarge),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return scheme.onSurface.withValues(alpha: .12);
        if (states.contains(WidgetState.pressed)) return scheme.primary.withValues(alpha: .88);
        return scheme.primary;
      }),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: scheme.surfaceContainerHighest.withValues(alpha: .5),
    contentPadding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radii.md),
      borderSide: BorderSide(color: scheme.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radii.md),
      borderSide: BorderSide(color: scheme.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radii.md),
      borderSide: BorderSide(color: scheme.error),
    ),
  ),

  dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: scheme.surfaceContainer,
    shape: const RoundedRectangleBorder(borderRadius: Radii.sheet),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: scheme.surfaceContainer,
    indicatorColor: scheme.secondaryContainer,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: Radii.card),
  ),
);
```

Wire up both modes — dark is first-class, not a compile-time afterthought:

```dart
MaterialApp(
  theme: buildTheme(lightScheme, buildTextTheme(lightScheme)),
  darkTheme: buildTheme(darkScheme, buildTextTheme(darkScheme)),
  themeMode: ThemeMode.system,
)
```

Don't blanket-transparent every `surfaceTintColor` "to clean up" — kill it selectively (app bar, card) where the tint fights your tuned surfaces; the container ladder already replaced tint-based elevation.

## 5. ThemeExtension — tokens Material doesn't model

Semantic colors (success/warning), brand gradients, or chart palettes go in a `ThemeExtension` so they stay theme-accessible and lerp on mode change:

```dart
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({required this.success, required this.warning});
  final Color success, warning;

  @override
  AppColors copyWith({Color? success, Color? warning}) =>
      AppColors(success: success ?? this.success, warning: warning ?? this.warning);

  @override
  AppColors lerp(AppColors? other, double t) => AppColors(
        success: Color.lerp(success, other?.success, t)!,
        warning: Color.lerp(warning, other?.warning, t)!,
      );
}
// ThemeData(extensions: [AppColors(...)])
// Theme.of(context).extension<AppColors>()!.success
```

## 6. Theme-switch integrity — the light-text-on-light-background bug

The most common shipped theming defect: the app looks perfect in one mode, then switching modes changes the background but **some text keeps its old color** — white text on a now-white surface. It is always the same class of mistake: a color that was *resolved once* instead of *derived from the active theme on every build*. The offenders, in order of frequency:

**1. Baked-in colors in shared TextStyle constants.**
```dart
// BROKEN: this white is forever, in both modes
abstract final class AppTextStyles {
  static const title = TextStyle(fontSize: 20, color: Colors.white);
}
```
Fix: shared styles are **colorless** — size/weight/height only. Color joins at use time from the scheme, or via the `TextTheme` (which is built per scheme):
```dart
static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.w600); // no color
Text('Hi', style: AppTextStyles.title.copyWith(color: scheme.onSurface));
// Better: just use the role — Theme.of(context).textTheme.titleLarge
```

**2. One TextTheme object passed to both modes.** A custom `TextTheme` with colors set for dark, reused inside the light `ThemeData`, ships dark's text into light mode. Fix: build the TextTheme **per scheme** and `.apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface)` — the pattern in §3/typography.md does this by taking the scheme as a parameter. Never share one colored TextTheme instance across both ThemeDatas.

**3. Theme values cached outside build.** Colors read in `initState`, stored in `static` fields, singletons, or passed once into a controller don't update when the theme changes — `Theme.of(context)` in `build` does, because it subscribes the widget to theme changes. Fix: read theme in `build` (or `didChangeDependencies`), never store resolved colors long-term.

**4. Broken role pairing.** Every container role has its on-role, and they only work as pairs:

| Background | Text/icon on it |
|---|---|
| `surface` / `surfaceContainer*` | `onSurface`, `onSurfaceVariant` |
| `primary` | `onPrimary` |
| `primaryContainer` | `onPrimaryContainer` |
| `secondaryContainer` | `onSecondaryContainer` |
| `error` / `errorContainer` | `onError` / `onErrorContainer` |
| `inverseSurface` | `onInverseSurface` |

`onSurface` text on a `primary` button, or `onPrimary` text on a card, works by coincidence in one mode and fails in the other. If text sits on a color, its color comes from **that color's** on-role.

**5. Hardcoded one-mode values in decorations** — a `Colors.white` card fill, a `Colors.black12` divider, shimmer/skeleton base colors, hint text grays. All become invisible or glaring in the other mode. Everything user-visible goes through scheme roles or a `ThemeExtension` (which **lerps between modes** — that's why it exists, §5).

**6. Construction traps.** `ColorScheme.copyWith(brightness: .dark)` relabels the scheme without recomputing a single color; `ThemeData.dark().copyWith(colorScheme: myDark)` leaves dozens of legacy fields derived from the *default* dark palette. Build each mode in one shot from its properly-generated scheme via one shared function (`themeFor(scheme)` — §4 does this). One source of truth: pass `colorScheme:`, never also `brightness:`. And branch on `Theme.of(context).brightness`, never `MediaQuery.platformBrightness` — the latter is the OS setting and disagrees the moment the user forces an in-app mode.

**7. The perimeter — things outside the Material tree that don't switch by themselves:**
- **Status bar icons**: set per theme via `appBarTheme: AppBarTheme(systemOverlayStyle: ...)` (`SystemUiOverlayStyle.dark` = dark *icons*, for light surfaces); `AnnotatedRegion` for app-bar-less screens. A one-time `SystemChrome.setSystemUIOverlayStyle` in `main()` never re-runs on switch.
- **Text outside a `Material` ancestor** (overlays, `showGeneralDialog`) falls back to the red/yellow-underline style and ignores theme colors → wrap in `Material(type: MaterialType.transparency)` or an explicit `DefaultTextStyle`.
- **Cupertino widgets inside a Material app** resolve brightness from the OS, not your `themeMode` → bridge with `MaterialBasedCupertinoThemeData(materialTheme: themeData)` and resolve dynamic colors via `CupertinoDynamicColor.resolve(color, context)`.
- **Assets & packages**: monochrome SVGs tinted at render time (`colorFilter: ColorFilter.mode(scheme.onSurface, BlendMode.srcIn)`), dual raster assets switched on `Theme.of(context).brightness`, and skeleton/shimmer base colors from the scheme (`surfaceContainerHighest`), never the README's `Colors.grey[300]`.
- **Hint/label/divider defaults**: themed once per mode in `inputDecorationTheme`/`dividerTheme` (§4) — a hardcoded `Colors.grey[600]` hint is invisible on dark.

Keep both `ThemeData`s **structurally symmetric** (same function, same TextTheme slots defined on both sides) — asymmetric themes can throw or flash during the built-in `AnimatedTheme` lerp on switch.

**The toggle test (mandatory before shipping any screen):** flip `themeMode` while looking at the busiest screen, both directions — including loading, dialog, and overlay states. Every piece of text, icon, divider, and fill must visibly adapt. Anything that "stays behind" is one of the seven above. Automate two ways: the golden matrix in craft.md (both modes × two text scales), and a toggle-assert widget test that reads the *effective* rendered color:

```dart
Color effectiveColor(WidgetTester t) =>
    t.renderObject<RenderParagraph>(find.text('Title')).text.style!.color!;
// pump light → record → set themeMode dark → pumpAndSettle → expect color changed
```

**Grep for offenders when debugging this bug:**
```bash
grep -rnE "color:\s*Colors\.(white|black|grey)" lib/ --include="*.dart" | grep -v theme/
grep -rnE "static (const|final).*TextStyle\(.*color:" lib/ --include="*.dart"
grep -rnE "ThemeData\.(dark|light)\(\)\.copyWith|copyWith\(brightness|platformBrightness" lib/ --include="*.dart"
grep -rnE "(baseColor|highlightColor):\s*Colors\." lib/ --include="*.dart"
grep -rn "Theme.of(context)" lib/ --include="*.dart" | grep -iE "initState|static"
```

## 7. Greenfield order of operations

1. Pick the brand hue from the brief (never a Material default; run the slop test on the choice).
2. Generate + tune both schemes. Check contrast on every text role pair.
3. Build the type scale (typography.md).
4. Write tokens.dart.
5. Assemble ThemeData with component themes for every component the app will use.
6. Build one representative screen; verify in both modes at 100% and 130% text scale.
7. Only then scale out to remaining screens.

## 8. User-selectable theming

- **A System/Light/Dark picker is table stakes.** Default to System; persist a `ThemeMode` with `shared_preferences` and apply it before the first frame (no theme flash at launch).
- **Accent pickers** suit personal tools (notes, habits, planners), not strongly-branded products. Implementation is nearly free under M3: store one seed `Color`, regenerate both schemes via `ColorScheme.fromSeed`. Offer **6–10 curated seeds**, never a free color wheel (curated always looks good; free pickers let users build unreadable themes).
- **Android dynamic color** (`dynamic_color` package, `DynamicColorBuilder`): opt in for utilities/readers where feeling native beats brand recall; opt out when color IS the brand. Middle path: brand seed by default, "Use wallpaper colors" as an option. Always harmonize semantic colors toward the active scheme; always keep the tuned brand scheme as the fallback.

**NEVER:** style a component inline that a component theme could own; introduce a second radius family "just for this sheet"; define dark mode by inverting light values; use `flex_color_scheme` output without reviewing what it generated.
