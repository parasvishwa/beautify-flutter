# Typography

Type is the biggest visual lift per unit of risk. An app with a real type system and default everything else already reads as designed; the inverse never does.

## The register decides the system

- **Utility register:** one family is often right. A well-tuned sans carries headings, buttons, labels, body, and data. Fixed scale, ratio 1.125–1.2 between steps. More type elements live on a product screen than a landing page; exaggerated contrast creates noise.
- **Expressive register:** a contrast pairing earns its place — distinctive display face for headings + readable body face. Scale ratio ≥ 1.25. Pair on a contrast axis (geometric display + humanist body, serif display + sans body). Never pair two similar-but-not-identical sans faces.

## Font selection procedure (expressive; never skip)

1. Write 3 physical-object words for the app's voice ("a brass instrument", "a field notebook", "a glass slab").
2. List your reflex picks, then **reject any on the reflex-reject list**: Inter*, Poppins, DM Sans, Space Grotesk, Plus Jakarta Sans, Outfit, Playfair Display, Fraunces, Instrument Serif, Lora — not because they're bad, because they're what every generated app picks. (*Inter/system stays fine for utility register and body text.)
3. Browse a real catalog (Google Fonts by category, not the front page) hunting the physical object.
4. If the final pick equals the original reflex, start over.

Reliable non-reflex mobile picks to consider: Manrope, Sora, Albert Sans, Schibsted Grotesk, Bricolage Grotesque, Hanken Grotesk, Gabarito, Familjen Grotesk, Newsreader (editorial body), Zodiak/Fraunces-alternatives via variable serifs. If your first instinct was on the reflex list, your second pick should come from a different part of the catalog than your first.

## Platform strategy

- Defaults: Roboto (Android), SF Pro (iOS) — Flutter's `Typography` picks per platform automatically. **SF fonts are license-restricted to Apple platforms; never bundle them for Android.**
- A safe premium strategy: platform-default body (native feel, zero download) + one bundled display face for headings and brand moments.
- iOS feel: negative letterSpacing on large titles (SF-style, e.g. −1.0 to −1.5 at 34px), Body anchors at 17px.

## Building the TextTheme

```dart
TextTheme buildTextTheme(ColorScheme scheme) {
  const display = 'Manrope';  // bundled in assets, declared in pubspec
  // body: platform default (omit fontFamily), or one bundled family

  return TextTheme(
    displayLarge: const TextStyle(fontFamily: display, fontSize: 44, height: 1.05, letterSpacing: -1.0, fontWeight: FontWeight.w700),
    displayMedium: const TextStyle(fontFamily: display, fontSize: 34, height: 1.1, letterSpacing: -0.6, fontWeight: FontWeight.w700),
    headlineMedium: const TextStyle(fontFamily: display, fontSize: 26, height: 1.15, letterSpacing: -0.4, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(fontFamily: display, fontSize: 20, height: 1.2, letterSpacing: -0.2, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w600),
    bodyLarge: const TextStyle(fontSize: 16, height: 1.5),
    bodyMedium: const TextStyle(fontSize: 14, height: 1.5),
    labelLarge: const TextStyle(fontSize: 14, height: 1.2, letterSpacing: 0.1, fontWeight: FontWeight.w600),
    bodySmall: const TextStyle(fontSize: 12, height: 1.4, letterSpacing: 0.1),
  ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
}
```

Keep M3's role names (`displayLarge` … `labelSmall`) even with custom values — components read them.

Rules:
- Body `height` 1.4–1.6; headings 1.05–1.25. Negative tracking scales with size (Flutter's `letterSpacing` is in logical px): large display ≈ fontSize × −0.02, body ≈ 0. Floor: never tighter than fontSize × −0.04 (e.g. −1.8 at 44px).
- ≥ 16 for primary reading text, ≥ 14 for secondary. 11–12 only for captions/overlines.
- ALL-CAPS labels get +0.05–0.12em tracking. Numbers in tables/tickers: `FontFeature.tabularFigures()`.
- Prose measure 65–75ch → on wide layouts cap the text column (layout.md), don't shrink the font.
- Dark mode compensation: same-size text looks heavier on dark — consider weight one notch down or +0.01em tracking for long-form body.

## Bundling and loading

- **Bundle fonts in assets** and declare in pubspec; runtime `google_fonts` fetching flashes fallback glyphs in production. (`google_fonts` supports bundling: put the .ttf in the asset path it checks, or just declare a normal `fonts:` entry.)
- Ship only used weights (400/600/700 typical). Every weight is install size.
- Variable fonts: one file, every weight, plus in-between values that read bespoke:

```dart
Text('Total', style: TextStyle(fontVariations: [FontVariation.weight(650)]))
```

## Text scaling (non-negotiable)

- Respect system scale up to 200%. Read via `MediaQuery.textScalerOf(context)`.
- If scaling truly breaks a layout, clamp — never disable:

```dart
MediaQuery.withClampedTextScaling(maxScaleFactor: 1.6, child: pinnedTabBar)
```

- No fixed-height containers around text. `ConstrainedBox(minHeight:)` + padding instead. Test every screen at 130%; key screens at 200%.

**NEVER:** default `TextTheme` in production; > 2 families; > 4 weights; hierarchy carried by color alone; display fonts on buttons/labels/data (utility register); `fontSize:` inline in a screen file — every size is a named role.
