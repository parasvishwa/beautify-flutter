# Color

More color ≠ better. Strategic color beats rainbow vomit. Mechanics live in [theme.md](theme.md); this file is the decision layer.

## Pick a strategy before picking colors

Four steps on the commitment axis. Utility register defaults to Restrained; Expressive may go further — but choose, don't drift.

- **Restrained** — tinted neutrals + one accent ≤ 10% of the surface. The product floor.
- **Committed** — one saturated color carries 30–60% (a colored onboarding, a hero header, a category system).
- **Full palette** — 3–4 named roles used deliberately (content categories, data viz).
- **Drenched** — the surface IS the color (a splash/onboarding moment, a brand-first screen). One or two screens max in an app.

Write one sentence of physical scene before choosing dark vs light default: who uses this, where, under what light, in what mood. If the sentence doesn't force the answer, it's not concrete enough.

## The category-reflex ban

If the palette is guessable from the app category, it's the training-data reflex, not a decision:

| Category | The reflex (banned as default) | Rotate instead |
|---|---|---|
| Meditation/wellness | Sage green + cream + serif | Deep ink + warm white; dawn gradient as one moment; monochrome + one saturated pop |
| Finance | Navy + gold, or black + neon green | Cool paper + one confident blue; warm graphite; forest + bone |
| AI/tech | Purple/violet gradient glow | Neutral base + electric single accent; terminal-adjacent dark with restraint |
| Food delivery | Red/orange + rounded everything | Market-fresh green + charcoal; editorial photo-led neutral |
| Health/medical | Teal + white | Warm neutral + coral; ink + sky |
| Premium/luxury | Beige + brass + espresso | Cold luxury (silver/smoke); black + tan; cobalt + cream |

The LILA rule: AI purple/blue glow is banned as a default reach. If the brand genuinely IS purple, embrace it with intent — consistent palette, harmonized neutrals, no gradient slop.

## Semantic roles, not raw hex

Widgets speak the scheme's vocabulary: `primary` (primary actions, selection, active state), `onSurfaceVariant` (muted/secondary text), `outlineVariant` (hairlines), `surfaceContainer*` (depth), `error`/`tertiary`/`secondaryContainer` per M3 semantics. Success/warning don't exist in `ColorScheme` — put them in a `ThemeExtension` (theme.md §5).

- Accent = primary actions, current selection, state indicators. Never decoration.
- **Color consistency lock:** one accent across the whole app. Audit every screen before shipping.
- Tinted neutrals: pull grays slightly toward the brand hue. Pure gray is dead; heavy warm-tint-by-default is the reflex. Small chroma, brand's own direction.
- Gray text on a colored background looks washed out — use a darker shade of the background's own hue instead.

## Contrast (mechanical check, not vibes)

- Body text ≥ 4.5:1. Large text and UI components/icons ≥ 3:1 (WCAG "large" = ~24 logical px, or ~18.5lp bold — exact thresholds in [accessibility.md](accessibility.md)). Hint/placeholder text: same 4.5:1 — the muted-gray default usually fails.
- The #1 failure: light gray body on tinted near-white "for elegance." If it's close, darken the text toward ink.
- Buttons: label vs button fill checked for every state including disabled.
- Alpha on **text** is a design smell — prefer a real color step from the ramp (alpha compounds unpredictably over varied surfaces). Alpha on fills/overlays (pressed states, scrims, input fills) is fine and idiomatic.
- Red/green never the only differentiator (8% of men can't tell). Pair with icon/label.

## Dark mode protocol

Designed, not inverted. Both modes ship from day one.

1. Base surface near-black with the brand's undertone (`#101014`, `#0E1210`…) — never `#000` (kills elevation, smears on OLED scroll).
2. Elevation = lighter surface, via the container ladder. No drop shadows to indicate depth in dark.
3. Desaturate accents 20–30%; full-saturation accents vibrate on dark.
4. Text: off-white (`#ECECEF`-ish) not `#FFF`; muted text still ≥ 4.5:1.
5. Hierarchy parity: whatever pops in light pops in dark. If the CTA recedes in dark mode, retune it.
6. Brand fidelity: the primary hue stays recognizable across modes.
7. Verify both modes on-screen before calling any screen done. A compiled-but-never-viewed dark theme is unfinished work.

Test: toggle `themeMode` while looking at the busiest screen. Anything that visually "swaps sides" (a light card on dark page becoming dark-on-light) is a token wired to the wrong role.

**NEVER:** hex literals in widget files; two accent hues without a documented role system; a light-mode-only ship "for now"; `Colors.grey[600]`-style palette access (bypasses theming entirely); gradients as a substitute for a palette decision.
