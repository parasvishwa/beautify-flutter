# Redesign — improving an existing Flutter app

Misclassifying the mode is the biggest source of bad redesign output. Detect first, audit second, touch code third.

## 1 · Detect the mode

- **Preserve** — modernize without breaking the brand. Audit, extract existing tokens, evolve.
- **Overhaul** — new visual language over existing structure. Greenfield rules for visuals; information architecture and flows preserved.
- If ambiguous, ask exactly once: *"Should this keep the existing brand and feel, or start visually from scratch?"*

## 2 · Audit before touching (produce this, then act)

Read the theme setup, tokens (or their absence), and 2–3 representative screens. Document:

- **Existing tokens:** seed/colors, fonts, radii, spacing habits — even implicit ones ("cards are always 12px radius" is a token nobody wrote down).
- **Dial reading** of the current app (variance/motion/density) — the starting point, not the target.
- **Patterns to preserve:** signature interactions, recognizable navigation, anything users have muscle memory for.
- **Patterns to retire:** run the full [anti-patterns.md](anti-patterns.md) scan; list hits by tier.
- **State coverage gaps:** which screens lack loading/empty/error.
- **Platform debt:** back-gesture breaks, overflow reports, text-scale failures.

For preserve-mode: a brand that is already purple stays purple — the category-reflex bans apply to *defaults*, not to committed identities.

## 3 · Modernisation levers (priority order — stop when the brief is satisfied)

1. **Typography refresh** — biggest visual lift per unit of risk. New scale + tuned height/tracking, possibly one new display face.
2. **Spacing & rhythm** — normalize to the 4pt scale, open up section spacing, fix gutter inconsistency.
3. **Color recalibration** — tune the scheme, build the surface ladder, fix contrast, design dark mode properly.
4. **State & interaction layer** — full state cycles, skeletons, designed empty/error, press feedback.
5. **Motion layer** — dial-appropriate transitions and micro-interactions on existing components.
6. **Key-screen recomposition** — restructure the home/hero surfaces.
7. **Full component replacement** — only where a component is unsalvageable.

Levers 1–4 ≈ 70% of the perceived value at ~40% of the risk. Apply at the **theme level** so the whole app improves at once — fixing screen-by-screen is how redesigns die half-finished.

## 4 · Never changes silently (ask first)

- Navigation structure, tab order, screen names
- The app icon, logo, brand hue (in preserve mode)
- Form field names/order (analytics + autofill depend on them)
- Copy voice, legal/consent text
- Anything behind analytics events

## 5 · Migration hygiene

- One PR-sized change per lever where possible; theme first, screens follow.
- Replace deprecated APIs as you touch each file (`MaterialStateProperty` → `WidgetStateProperty`, `surfaceVariant` → `surfaceContainerHighest`, `withOpacity` → `withValues`, `CardTheme` → `CardThemeData`, `textScaleFactor` → `TextScaler`).
- Keep the app runnable at every step; verify both themes and 130% text scale after each lever.
- Re-run the anti-patterns audit after the work; report the before/after score honestly.
