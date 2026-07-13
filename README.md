# beautify-flutter — the Flutter UI/UX design skill for AI coding agents

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-skill-orange)](https://code.claude.com/docs/en/skills)
[![Cursor](https://img.shields.io/badge/Cursor-rules-black)](#install)
[![Codex](https://img.shields.io/badge/Codex-compatible-green)](#install)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#contributing)

**One design skill for all of Flutter.** Teaches AI coding agents (Claude Code, Cursor, Codex, Windsurf, Copilot — anything that reads `SKILL.md` / rules files) to produce Flutter apps that look **designed, not defaulted** — on Android, iOS, web, and desktop.

Stop shipping the stock purple `ColorScheme.fromSeed`, the untouched `TextTheme`, identical `Card` grids, magic-number paddings, and a centered spinner for every load. This skill replaces every Flutter default with an intentional decision — applied through Material 3 theming, verified against a mechanical pre-flight checklist, and grounded in what's actually current (Impeller, `surfaceContainer` roles, `WidgetStateProperty`, M3 Expressive & iOS 26 Liquid Glass reality).

## Why this exists

AI-generated Flutter apps all look the same: default Material widgets, category-reflex palettes (meditation app → sage green, AI app → purple gradient), no dark mode design, no loading/empty/error states, broken iOS back-swipe, overflow stripes at 130% text scale. That's not a model problem — it's a missing-design-system problem.

`beautify-flutter` fixes it with the discipline of the best web-focused design skills in the AI-agent community, rebuilt from scratch for Flutter, Dart, Material 3, and Cupertino.

## What's inside

```
beautify-flutter/
├── SKILL.md                    # Router: design read, dials, registers, rules, bans, pre-flight check
└── reference/
    ├── interview.md            # The Design Interview: style, theme, color, animation, voice, skip-inference
    ├── catalog.md              # Component & animation catalog: buttons, menus, nav, per-style picks
    ├── psychology.md           # Laws of UX, hierarchy science, CTA placement evidence, category psychology
    ├── copy.md                 # Voice personalities, tone rules, microcopy numbers, icons-vs-text, brevity
    ├── firstrun.md             # App icon (iOS 26/Android monochrome), splash choreography, onboarding, priming
    ├── imagery.md              # Photo/illustration/typography lead, illustration grammar, duotone treatment
    ├── craft.md                # Build a feature/app end-to-end (shape → build → verify → goldens)
    ├── theme.md                # Design tokens, ColorScheme tuning, ThemeData, ThemeExtension, dark mode
    ├── typography.md           # Type scale, font selection procedure, variable fonts, text scaling
    ├── color.md                # Color strategy, category-reflex bans, contrast, dark mode protocol
    ├── layout.md               # Spacing system, window size classes, slivers, adaptive nav, overflow safety
    ├── components.md           # Full state cycles, buttons, forms, loading/empty/error states
    ├── motion.md               # 4-question animation framework, M3 curves & durations, springs, Hero
    ├── platform.md             # iOS/Cupertino recipes, Android 16, M3 Expressive & Liquid Glass reality
    ├── accessibility.md        # Semantics, contrast, touch targets, text scaling, test guardrails
    ├── performance.md          # Rebuild discipline, lists, images, jank — performance as UX
    ├── signature.md            # Fragment shaders, Rive, CustomPainter, 3D, multisensory choreography
    ├── intl.md                 # i18n, RTL, direction-agnostic layout, expansion-safe design
    ├── anti-patterns.md        # 34 tells of AI-generated Flutter + scored 0–20 audit protocol
    └── redesign.md             # Audit-first protocol for improving existing Flutter apps
```

## How it works

1. **Design Interview** — for new designs and redesigns, the agent first asks what you want: design style (minimal / elegant premium / bold / soft / playful / editorial / dark tech / glass, each anchored to real apps), your **primary theme** (dark or light — always asked; the app is designed primary-first, the other mode fully derived after), color (give a hex code, point at your logo to extract the palette from it, or skip), animation personality (calm / subtle / smooth premium / springy playful / dramatic), **copy voice** (friendly / playful / minimal / corporate / premium / bold / supportive), **expression style** (crisp & icon-led ↔ explanatory), and the anchor question: *what's the ONE thing users should do most?* Every question is skippable — skipped answers are inferred from your project and declared so you can override in one word.
2. **Design Read** — the agent classifies the app (kind, audience, platforms, register) in one line before generating anything.
3. **Three dials** — `DESIGN_VARIANCE` / `MOTION_INTENSITY` / `VISUAL_DENSITY`, set from the read with per-app-kind presets and mechanical thresholds.
4. **Two registers** — *Expressive* (design IS the product) and *Utility* (design SERVES the task), each with its own slop test, permissions, and bans.
5. **Theme-first, always** — zero inline styling; everything flows from tokens and `ThemeData`.
6. **Reference routing** — deep guidance loads on demand per task, so agent context stays lean.
7. **Pre-flight check** — a mechanical checklist (dark mode designed, contrast ≥ 4.5:1, 130% text scale, RTL pass, back-gestures intact, states designed…) the agent must pass before declaring UI work done.

## Install

**Claude Code — one project:**
```bash
git clone https://github.com/YOUR_USERNAME/beautify-flutter .claude/skills/beautify-flutter
```

**Claude Code — all projects:**
```bash
git clone https://github.com/YOUR_USERNAME/beautify-flutter ~/.claude/skills/beautify-flutter
```

Then just ask for Flutter UI work — the skill triggers automatically — or invoke it explicitly:

```
/beautify-flutter craft a workout tracking home screen
/beautify-flutter audit lib/screens/
/beautify-flutter redesign — keep the brand, modernize everything else
```

**Cursor / Windsurf / Copilot:** copy `SKILL.md` into your rules directory (`.cursor/rules/`, `.windsurf/rules/`, `.github/copilot-instructions.md`) and keep `reference/` alongside it — the agent loads reference files by path.

**Codex:** point `AGENTS.md` at `SKILL.md` or paste it into your project instructions.

## Commands

| Command | What it does |
|---|---|
| `interview` | Ask your design preferences (style, theme, color, animation) — all skippable |
| `craft [target]` | Interview → shape → build a feature end-to-end to a production bar |
| `audit` / `critique [target]` | Scored 0–20 audit against the 34 anti-pattern tells |
| `theme` | Build or fix the foundation: tokens, schemes, component themes |
| `typeset` / `colorize` / `layout` / `animate` | Focused enhancement passes |
| `adapt [target]` | Make it feel native on iOS / Android / web / desktop |
| `harden` / `optimize` | Accessibility, i18n/RTL & resilience / performance passes |
| `signature [target]` | One extraordinary moment: shaders, Rive, 3D, multisensory choreography |
| `redesign [target]` | Audit-first improvement of an existing app |

## What it covers

Material 3 theming & design tokens · `ColorScheme` seeding and tuning · dark mode done right · typography systems & Google Fonts · spacing scales · responsive & adaptive layout (window size classes, NavigationBar → NavigationRail) · slivers & collapsing headers · Cupertino / iOS-native feel · Android 16 edge-to-edge & predictive back · Material 3 Expressive and iOS 26 Liquid Glass (what's real in Flutter today) · animation curves, durations & springs · Hero and page transitions · haptic feedback choreography · loading skeletons, empty & error states · accessibility (Semantics, contrast, touch targets, text scaling) · internationalization & RTL · performance as UX (const, builder lists, image sizing, Impeller) · fragment shaders, Rive, CustomPainter · UX psychology (Laws of UX, thumb-zone CTA placement, category psychology, dark-pattern bans) · UX writing (voice personalities, tone rules, microcopy) · a 34-item taxonomy of AI-generated Flutter tells.

## Credits

Architecture and philosophy draw on design-skill patterns pioneered by the open-source AI-agent design community — register systems, dial-based configuration, animation decision frameworks, anti-pattern taxonomies, and mechanical pre-flight checks — rebuilt from scratch for Flutter.

Flutter guidance grounded in: Flutter 3.32–3.44 release reality, the Material 3 spec and motion tokens, Apple HIG, the [Wonderous app](https://github.com/gskinnerTeam/flutter-wonderous-app) source, FlutterCon/Flutter Forward talks, and 2025 Apple Design Award / Google Play winners.

## Contributing

Found a Flutter anti-pattern this skill misses? A deprecated API that slipped through? PRs and issues welcome — the bar is: specific, current, and mechanically checkable.

## License

[MIT](LICENSE)

---

*Keywords: Flutter design skill, Claude Code skill, Flutter UI best practices, Flutter UX, Material 3 theming, Flutter dark mode, Flutter animations, Cursor rules Flutter, AI coding agent, Flutter anti-patterns, premium Flutter app, Flutter design system, Flutter accessibility, Cupertino iOS design, Flutter code review.*
