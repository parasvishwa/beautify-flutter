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

## 6. Greenfield order of operations

1. Pick the brand hue from the brief (never a Material default; run the slop test on the choice).
2. Generate + tune both schemes. Check contrast on every text role pair.
3. Build the type scale (typography.md).
4. Write tokens.dart.
5. Assemble ThemeData with component themes for every component the app will use.
6. Build one representative screen; verify in both modes at 100% and 130% text scale.
7. Only then scale out to remaining screens.

**NEVER:** style a component inline that a component theme could own; introduce a second radius family "just for this sheet"; define dark mode by inverting light values; use `flex_color_scheme` output without reviewing what it generated.
