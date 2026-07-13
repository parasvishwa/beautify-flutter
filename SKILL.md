---
name: beautify-flutter
description: Use when the user wants to design, redesign, build, critique, audit, polish, theme, animate, adapt, or otherwise improve a Flutter app's UI or UX. Covers full apps, screens, widgets, components, forms, onboarding, empty states, navigation, dashboards, and settings. Handles Material 3 theming, Cupertino/iOS adaptation, design tokens, color, dark mode, typography, fonts, spacing, layout, responsive/adaptive behavior for phones/tablets/desktop/web, motion, micro-interactions, haptics, gestures, loading/empty/error states, accessibility, text scaling, performance-as-UX, and Flutter anti-patterns. Also use for bland Flutter apps that need personality, default-looking Material apps that should feel premium, or apps that feel "ported" instead of native on iOS or Android. Not for backend-only, state-management-only, or non-UI Dart tasks.
version: 1.1.0
user-invocable: true
argument-hint: "[interview|craft · audit|critique · polish|theme|typeset|colorize|layout|animate|signature · adapt|harden|optimize · redesign] [target]"
license: MIT
---

# Beautify Flutter

Designs and iterates production-grade Flutter interfaces for Android, iOS, web, and desktop. Real working Dart, committed design choices, exceptional craft.

The core belief: **default Flutter is a starting point that ships.** `ColorScheme.fromSeed` with the stock purple, the default `TextTheme`, `Card` with default elevation, arbitrary `EdgeInsets` — they all work, and they all look identical to every other unpolished Flutter app. Premium feel comes from replacing every default with an intentional decision, applied through the theme, never per-widget.

## Setup

You MUST do these steps before any design work:

1. **Read the project.** Open `pubspec.yaml` (packages, fonts, Flutter version signals) and the theme setup (`lib/theme/`, `main.dart` `ThemeData`, any tokens file) plus one or two representative screens. Learn what exists before adding to it. If tokens/theme exist, identity-preservation wins: work within them unless asked to overhaul.
2. **Classify the register.** **Expressive** (design IS the product: consumer apps, content, lifestyle, games' shells, portfolio pieces, anything competing on feel) vs **Utility** (design SERVES the task: tools, dashboards, admin, b2b, forms-heavy apps). Pick by first match: task cue → surface in focus → the app's nature. Registers change the rules; see the register sections below.
3. **Interview, then read.** For `craft`, `theme`, `redesign`, or any full-surface work, run the **Design Interview** first ([reference/interview.md](reference/interview.md)): one round of up to 4 skippable questions — **design style first, theme mode second**, then color and animation personality. Every skipped answer is inferred from the project and declared before building. Skip the interview entirely for small scoped tasks or when the prompt already answers it. Then state the **Design Read** in one line: *"Reading this as: \<app kind> for \<audience> on \<platform targets>, \<style> / \<animation personality>, \<register> register, dials \<V/M/D>."* Outside the interview, ask at most **one** clarifying question, and never when you can confidently infer.
4. **Set the dials** (next section) from the read, not from habit.
5. **Load the matching references** from the routing table before writing widget code. At minimum, always load [reference/theme.md](reference/theme.md) for anything touching visuals and [reference/anti-patterns.md](reference/anti-patterns.md) for anything user-visible. **Non-optional; skipping produces generic output.**
6. **If the project is greenfield** (no committed theme), the foundation comes first: tokens → color scheme → type scale → component themes, per [reference/theme.md](reference/theme.md), before any screen is built.

## The Three Dials

Set these after the Design Read. Every layout, motion, and density decision downstream is gated by them.

- **`DESIGN_VARIANCE`** — 1 = strict Material symmetry, 10 = art-directed per-screen compositions
- **`MOTION_INTENSITY`** — 1 = static, 10 = choreographed physics everywhere
- **`VISUAL_DENSITY`** — 1 = airy gallery, 10 = data cockpit

| App kind | VARIANCE | MOTION | DENSITY |
|---|---|---|---|
| Consumer social / lifestyle | 7 | 7 | 4 |
| Content / media / reader | 6 | 5 | 3 |
| E-commerce | 6 | 6 | 5 |
| Productivity / tool | 4 | 4 | 5 |
| Dashboard / b2b / admin | 3 | 3 | 6–7 |
| Finance / health (trust-first) | 3 | 3 | 5 |
| Onboarding & marketing screens inside any app | +2 | +2 | −1 |
| Redesign — preserve | match existing | +1 | match |
| Redesign — overhaul | +2 | +2 | match |

Dial thresholds (mechanical, not vibes):
- **VARIANCE ≤ 4:** symmetric grids, consistent screen anatomy, zero per-screen art direction. **≥ 7:** at least one bespoke composition on a key screen (custom header, art-directed hero, asymmetric layout) — and never at the cost of platform navigation conventions; variance lives in composition, type, and color, not in reinventing back gestures.
- **MOTION ≤ 3:** press feedback + platform transitions only. **> 4:** "motion claimed, motion shown" — entrance choreography on key screens, transitions, micro-interactions; if you can't ship working motion, drop the dial and ship clean static. **≥ 7:** one signature/hero motion moment (see signature.md).
- **DENSITY ≥ 7:** card-wrapping banned — data breathes in plain layout with hairline separators; tabular numbers mandatory. **≤ 3:** generous section spacing (32–48), one focal element per viewport.

## Registers

### Expressive (design IS the product)
The slop test: would a design-literate user look at this and ask *"which template is this?"* If the theme + palette are guessable from the app category alone (meditation app → sage green + serif; finance → navy + gold; AI app → purple gradient), it's the first training-data reflex. Rework until the answer isn't obvious from the domain.
- Permissions: committed color (a saturated surface, a drenched onboarding), display typography, per-section art direction, one rehearsed entrance choreography, custom painted moments (`CustomPainter`, shaders).
- Bans on top of shared: timid palettes ("safe = invisible"), zero imagery in image-led domains (food, travel, fashion need real images), the same fade-and-rise reveal on every element.

### Utility (design SERVES the task)
The slop test is inverted: not "does this look AI-made" but *would a user fluent in Linear, Things, or Stripe's apps trust this screen, or pause at every subtly-off control?* The bar is **earned familiarity** — the tool disappears into the task.
- Permissions: system-feeling fonts, standard navigation patterns, density, consistency over surprise.
- Rules: one type family is often right; fixed type scale (ratio 1.125–1.2); Restrained color is the floor (accent for primary actions, selection, and state — never decoration); in-place motion 150–250ms conveying state only (sheets/dialogs/navigation keep the standard motion.md durations); no page-load choreography.
- Bans on top of shared: decorative motion, display fonts in labels/buttons/data, inconsistent component vocabulary between screens (if "save" looks different in two places, one is wrong), modal-as-first-thought.

## General rules

Single sources of truth: **durations/curves live in motion.md; contrast thresholds in accessibility.md; token values in theme.md.** Everything below summarizes — when in conflict, the owning file wins.

### Foundation
- **Everything flows from `ThemeData`.** Zero inline colors, font sizes, or radii in widget code. If you're typing `Color(0xFF...)`, `fontSize:`, or `BorderRadius.circular(...)` inside a screen file, stop — it belongs in the theme or a token file.
- **Spacing scale:** 4pt base (4/8/12/16/24/32/48/64) as named constants. Related items 8–12 apart, sections 24–32 apart. Consistent gutters screen to screen.
- **One radius family** app-wide (all-sharp, all-soft 8–16, or all-pill for interactive) — mixed only with a documented rule applied everywhere.
- **Current APIs only:** `WidgetStateProperty` (not `MaterialStateProperty`), `surfaceContainer*` roles (not `surfaceVariant`/`background`), `TextScaler` (not `textScaleFactor`), `CardThemeData` (not `CardTheme`), `.withValues(alpha:)` (not `.withOpacity()`).

### Color
- Seed a `ColorScheme` (pick `dynamicSchemeVariant: DynamicSchemeVariant.fidelity` when the brand hue must survive), then **tune** it with `copyWith` — raw `fromSeed` output is the monoculture.
- Build depth with the **surface-container ladder** (`surfaceContainerLowest` → `Highest`), not drop shadows.
- Contrast: body text ≥ 4.5:1, large text and UI components ≥ 3:1. The most common failure: muted gray text on tinted near-white "for elegance."
- Dark mode is designed, not inverted: near-black base (never `#000`), surfaces get *lighter* with elevation, accents desaturated 20–30%, off-white text (never `#FFF`).
- One accent, locked across the whole app. A teal badge on a rose-accented app is broken design.

### Typography
- Never ship the default `TextTheme`. Deliberate scale, tuned `height` (body 1.4–1.6, headings 1.05–1.25) and `letterSpacing` (negative on large display sizes, ~0 at body).
- Max 2 families, 2–4 weights, bundled in assets (never runtime-fetched in production).
- Hierarchy = size + weight, not color. Body ≥ 14–16. Test everything at 130% text scale.

### Layout
- `SafeArea` always. No RenderFlex overflow at any width, orientation, or text scale — the viewport is part of the design.
- Adaptive by window size class: compact < 600dp → bottom `NavigationBar`; medium 600–839 → `NavigationRail`; expanded ≥ 840 → extended rail/drawer + multi-pane. Phone UI stretched to 1200px is an amateur tell.
- Reading width capped ~640–720 logical px on wide screens.
- Cards are the lazy answer. Use them when elevation communicates real hierarchy; otherwise group with spacing and hairline dividers. **Nested cards are always wrong.**

### Motion
Four questions, in order, before any animation (full framework in [reference/motion.md](reference/motion.md)):
1. **Should it animate at all?** 100+ times/day interactions → no animation. Occasional (sheets, dialogs, navigation) → standard. Rare (onboarding, success) → delight allowed.
2. **What's the purpose?** Spatial continuity, state change, feedback, or preventing a jarring swap. "Looks cool" on a frequent element → cut it.
3. **Which curve?** Entering → `Easing.emphasizedDecelerate`; exiting → `Easing.emphasizedAccelerate`; on-screen morph → `Curves.easeInOutCubicEmphasized`. Never `Curves.linear` on UI, never `easeIn` for entrances, no `bounceOut`/`elasticOut` on chrome.
4. **How fast?** Press feedback 100–160ms; in-place state changes ≤ 300ms; container/sheet/dialog enters 250–400ms; full-screen navigation ≤ 500ms; exits 50–75% of the matching enter. (Canonical duration table lives in motion.md — other files link, never restate.)
- Every reveal enhances an already-visible default. Respect `MediaQuery.disableAnimationsOf(context)`.

### Interaction
- Every interactive element ships all its states: default, pressed, hover (web/desktop), focus, disabled, loading, error. `WidgetStateProperty` in component themes.
- Press feedback everywhere: scale ~0.97 or ink, 100–160ms.
- Touch targets ≥ 48×48dp (44pt iOS), ≥ 8dp between adjacent targets. Thumb zone: primary actions live in the bottom third.
- Loading: nothing under 300ms; skeletons matching final layout above it; inline button spinners for action feedback. Empty and error states designed, never blank screens or raw exception text.

### Platform respect
- Never break iOS edge-swipe back or Android predictive back.
- Use `.adaptive()` constructors (`Switch`, `Slider`, `Checkbox`, `AlertDialog`, `CircularProgressIndicator`) where conventions differ; keep brand-owned components identical cross-platform. Full recipes in [reference/platform.md](reference/platform.md).

## Absolute bans

Match-and-refuse. About to write one of these? Rewrite the element with different structure.

- **The default purple.** Untouched `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` or `Colors.blue` in production.
- **Inline styling.** Hex colors, font sizes, radii, or arbitrary paddings inside widget build methods.
- **Pure black/white dark mode.** `#000000` surfaces or `#FFFFFF` text.
- **Drop shadows as dark-mode elevation.** Elevation in dark = lighter surface.
- **`Card` grids of identical icon + title + subtitle tiles** as default scaffolding.
- **Side-stripe accents** — a colored left border on cards/list items/alerts. Full hairline border, background tint, or leading glyph instead.
- **Gradient text** and glassmorphism-as-default. Blur is rare and purposeful, or absent.
- **Centered `CircularProgressIndicator` as the loading strategy** for content-shaped screens.
- **RenderFlex overflow stripes** at any tested size — including 130% text scale.
- **Broken platform navigation** — custom transitions or `PopScope` that eat iOS back-swipe.
- **`shrinkWrap: true` lists inside scrollables** and non-builder lists over ~20 items.
- **Elastic/bounce curves on UI chrome**, `Opacity` widget inside animations (use `FadeTransition`), animation on keyboard-driven actions.
- **Placeholder-as-label forms**, `withOpacity`-gray text below 4.5:1, icon buttons without tooltips/semantics.
- **Em-dash (—) in any string you generate.** Headlines, body, buttons, captions: zero. Restructure with a period, comma, or colon. (User-authored copy is theirs — never "fix" it silently during a redesign.)
- **Debug artifacts:** `debugShowCheckedModeBanner: true` (remove it), default splash, template app name.

## The AI slop test

If someone could look at this app and say "AI made that" (expressive) or "this is an unfinished template" (utility) without doubt, it's failed. Two altitudes:

- **First-order:** theme + palette guessable from the category alone → the first reflex. Rework.
- **Second-order:** aesthetic guessable from category-plus-anti-reference ("meditation app that's not sage-serene → cosmic purple gradient") → the trap one tier deeper. Rework until both answers are non-obvious.

## Reference routing

| Intent | Load | Covers |
|---|---|---|
| `interview` — ask what the user wants | [reference/interview.md](reference/interview.md) | Question flow, style matrix, animation personalities, skip-inference |
| `craft` — build a feature/screen/app end-to-end | [reference/craft.md](reference/craft.md) + [reference/interview.md](reference/interview.md) | Shape → foundation → build → states → verify flow |
| component & animation picks | [reference/catalog.md](reference/catalog.md) | Button/nav/menu/card/loader variants, animation catalog, per-style defaults |
| `theme` — foundation or theming work | [reference/theme.md](reference/theme.md) | Tokens, ColorScheme, ThemeData, component themes, ThemeExtension, dark mode |
| `typeset` — typography | [reference/typography.md](reference/typography.md) | Scale, fonts, variable fonts, platform strategy |
| `colorize` — color strategy | [reference/color.md](reference/color.md) | Strategy axis, tuning, contrast, dark mode protocol |
| `layout` — spacing, structure, responsive | [reference/layout.md](reference/layout.md) | Spacing system, window classes, adaptive nav, overflow safety |
| components & states | [reference/components.md](reference/components.md) | Buttons, cards, inputs, lists, loading/empty/error |
| `animate` — motion | [reference/motion.md](reference/motion.md) | Decision framework, curves/durations, packages, transitions, gestures, springs |
| `adapt` — platform feel | [reference/platform.md](reference/platform.md) | iOS/Cupertino recipes, Android/M3, desktop & web, adaptive widgets |
| `harden` — a11y & resilience | [reference/accessibility.md](reference/accessibility.md) + [reference/intl.md](reference/intl.md) | Semantics, text scaling, contrast, targets, testing; i18n/RTL |
| `signature` / `overdrive` — extraordinary moments | [reference/signature.md](reference/signature.md) | Shaders, Rive, CustomPainter, 3D, glass, multisensory choreography (MOTION ≥ 7 or explicit ask) |
| `optimize` — performance-as-UX | [reference/performance.md](reference/performance.md) | const, rebuilds, lists, images, jank |
| `audit` / `critique` — evaluate | [reference/anti-patterns.md](reference/anti-patterns.md) | The tells, scored audit protocol |
| `polish` — final quality pass | [reference/anti-patterns.md](reference/anti-patterns.md) + [reference/components.md](reference/components.md) | Run the pre-flight check against the target; fix every failure at theme level first |
| `redesign` — improve existing app | [reference/redesign.md](reference/redesign.md) | Audit-first protocol, preserve vs overhaul, modernisation levers |

Routing: first word matches a command → load its reference and follow it. Intent clearly maps ("fix the spacing" → layout; "feels bland" → craft/colorize per register) → load that reference. No match → general invocation: setup steps + General rules + register + the references the task touches.

## FINAL PRE-FLIGHT CHECK

Run before declaring any UI work done. **Not optional. Any unticked box = not done.**

**Foundation**
- [ ] Design Read declared; dials explicit and reasoned?
- [ ] Zero inline colors / font sizes / radii / magic paddings in widget code — all via theme/tokens?
- [ ] No deprecated APIs (`MaterialStateProperty`, `surfaceVariant`, `background`, `textScaleFactor`, `withOpacity`, `CardTheme`-as-constructor)?
- [ ] One radius family, one accent color, one type system across every screen touched?

**Visual**
- [ ] Light AND dark theme both designed and checked (not just compiled)?
- [ ] Dark mode: no pure #000/#FFF, elevation = lighter surface, accents desaturated?
- [ ] Every text/background pair ≥ 4.5:1 (3:1 large text) — including hint text and disabled-looking-but-active text?
- [ ] Type scale has tuned height/letterSpacing; hierarchy readable in grayscale (squint test)?
- [ ] Nothing on screen is an untouched Material default?

**Behavior**
- [ ] Every interactive element has pressed + disabled states (+ hover/focus on web/desktop)?
- [ ] Loading = skeleton or inline (no spinner-flash under 300ms, no bare centered spinner on content screens)? Empty and error states designed with a next action?
- [ ] Motion: each animation justifiable in one sentence; curves eased; UI durations ≤ 300ms; exits faster than enters; `disableAnimations` respected?
- [ ] iOS back-swipe and Android predictive back intact?

**Robustness**
- [ ] No overflow at smallest supported width, landscape, AND 130% text scale?
- [ ] `SafeArea` correct; keyboard doesn't cover focused fields?
- [ ] Window size classes handled (compact/medium/expanded) if the app targets tablets/desktop/web; reading width capped?
- [ ] Touch targets ≥ 48dp; icon-only buttons have tooltip/Semantics labels?
- [ ] Lists are builder-based; images sized (`cacheWidth`) with placeholders; `const` wherever the analyzer allows?
- [ ] Direction-agnostic layout (`EdgeInsetsDirectional`/`AlignmentDirectional` for asymmetric cases); key screens survive an RTL + long-string pass?
- [ ] Status-bar icon brightness set for BOTH themes (`systemOverlayStyle`); launcher icon and splash are not defaults?

**Copy**
- [ ] Every visible string re-read: no broken grammar, no AI-cute copy, no "Oops!", no em-dashes, no fake-precise numbers, no "John Doe" / "Acme" data?
- [ ] Form labels persistent (not placeholder-only); errors below fields, specific, telling the user what to do?
