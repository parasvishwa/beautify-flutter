# Imagery & illustration strategy

Every app has a visual lead — chosen deliberately or by accident. Mixing leads (or mixing two illustration styles) is the single most common "cheap app" tell.

## Choose the lead (one primary; others support)

| Lead | Choose when | Anchors | Risk to manage |
|---|---|---|---|
| **Photo-led** | The inventory IS photographable and aspirational: travel, food, real estate, fashion, marketplaces | Airbnb, delivery apps | Inconsistent/UGC photos destroy cohesion → treatment rules below |
| **Illustration-led** | Abstract service (finance, SaaS, health, education); warmth + differentiation wanted | Duolingo, Headspace, Shopify | Generic stock illustration reads as template → commit to ONE grammar |
| **Typography-led** | Data/content is the hero; editorial or premium-minimal positioning | Things, banking, news | Needs excellent type + spacing discipline or reads unfinished |

Interview hook: asked in Q8 fine-tuning, or inferred from category + register and declared.

## Illustration grammar (the consistency system)

Fix these five once; apply to every non-photo visual — empty states, onboarding, errors must read as siblings:

1. **Palette recipe:** neutrals + 2–3 brand colors per illustration, *less* saturated than the surrounding UI (illustrations never compete with interactive elements — the Polaris rule).
2. **Stroke:** one weight, or none — never mixed.
3. **Corner/shape language:** matches the app's radius family.
4. **Detail level:** one altitude (geometric-simple ↔ detailed) everywhere.
5. **Humans:** whether they appear, and at what proportions.

One illustration = one idea. Empty-state art ~160–240dp tall above a 1-line title + 1–2-line body + one CTA.

**Sources & licenses (verify at use time):** unDraw (free, commercial, no attribution; SVG with a recolorable accent — pipe the brand primary through `flutter_svg`), Humaaans/Open Peeps/3dicons (CC0), Storyset (attribution required — awkward in-app; put it in Settings → About), Popsy (attribution required). AI-generated illustration: lock a single prompt template or the grammar fragments.

## Photo treatment (when photos vary, the treatment unifies)

- **Duotone:** shadows → brand dark, highlights → brand light, same pair everywhere (the Spotify system — makes any third-party photo on-brand). Flutter: grayscale `ColorFilter.matrix` composited under a brand-gradient `BlendMode.multiply`/`screen`, or a shader.
- **Scrim standard:** if text ever sits on photos, one scrim rule app-wide (e.g., black 0→60% bottom gradient, fixed height fraction) — never ad-hoc per screen, always contrast-checked.
- **Crop ratios fixed per context:** hero 3:2, card 16:9, avatar 1:1; `BoxFit.cover`; consistent subject placement.
- Normalize warmth/saturation in one direction and stay there.

## 3D illustration

Works: hero/onboarding moments, object metaphors (cards, coins), playful consumer brands — shipped as pre-rendered 2–3× PNG/WebP or Rive for animated pseudo-3D. Doesn't: dense utility UI, below ~120dp (renders muddy), or mixed with flat vector elsewhere. Real-time 3D isn't worth it for decoration.

**NEVER:** two illustration styles in one app; stock photos and illustrations used interchangeably for the same job; text on untreated photos; an empty-state style that doesn't match the onboarding style; imagery decisions made per-screen instead of per-system.
