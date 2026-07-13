# The Design Interview

Before changing a pixel, find out what the user actually wants. The interview replaces guessing with asking — and replaces asking with smart inference the moment the user skips. Every answer maps to concrete specs (below), so an answer is never just a vibe: it sets tokens, curves, and component choices.

## When to run

- `craft` on a new app or major feature → **always**, before the Design Read.
- `theme` / full `redesign` → **always**.
- Small scoped tasks ("fix this button", "audit") → **never**; use the existing theme + Design Read.
- User already specified the direction in their prompt ("make it minimal, black and white") → skip the answered questions, ask only what's still open (often nothing).

## How to ask

- Use the harness's question tool (e.g. AskUserQuestion) when available — max 4 questions per round, **max 2 rounds**. Otherwise one compact numbered message.
- **Round 1 is the interview.** Round 2 only if the user engages and details remain genuinely open.
- Every question offers **"You decide"** — and silence = "You decide."
- **Skip protocol:** any unanswered question is inferred from the project (app category, existing theme, pubspec, register) via the Design Read. Before building, declare the resolved choices in two lines: *"Going with: Elegant Premium, dark-first, ink+brass, smooth-premium motion. Say 'change X' to override."* The user can course-correct in one word instead of answering forms.

## Round 1 — Direction (the four that matter)

**Q1 · Design style** *(always first — anchor apps beat adjectives, so name both)*
> "What overall design style should this app have?"
1. **Minimal & Clean** — quiet, monochrome, generous whitespace *(like Things, Linear, Notion)*
2. **Elegant & Premium** — refined, luxurious, understated depth *(like Airbnb, Aesop)*
3. **Bold & Expressive** — loud color, big type, shape-morphing *(like Google's M3 Expressive apps, Spotify)*
4. **Soft & Friendly** — rounded, warm, approachable *(like Headspace, Calm)*
5. **Playful & Pop** — bouncy, colorful, fun *(like Duolingo)*
6. **Editorial** — type-led, magazine-like, ink on paper *(like NYT, Medium)*
7. **Dark Tech** — near-black, sharp, engineered *(like Revolut, Vercel)*
8. **Glass & Futuristic** — floating translucent layers, depth *(like iOS 26, Apple Music)*
9. **You decide from my app**

Extended styles, offered only when the brief hints at them: **Brutalist/Raw** (hard black borders, offset shadows, zero radius — Gumroad-like) and **Neumorphic** (soft dual-shadow monochrome — accent use only; warn that full neumorphic UIs fail WCAG component contrast).

If the user names a reference app instead of picking ("make it feel like Airbnb"), map the app to the nearest style row and say so. A follow-up worth its cost when the user is engaged: *"Any style or app you definitely DON'T want this to look like?"* — anti-preferences prune the space as fast as preferences.

**Q2 · Primary theme** *(always second, and ALWAYS asked — this question is never silently skipped)*
> "What's your primary theme — dark or light?"
1. **Light primary** · 2. **Dark primary** · 3. Both equal, follow system · 4. You decide

The primary theme is the design target: the palette is tuned in that mode first, every screen is built and reviewed in it first, and demos/screenshots default to it. The other mode still ships fully designed (never a compile-only afterthought — theme.md §6 toggle test applies to both), but it is *derived after* the primary is right. If the user picks "you decide," infer from the app's scene (media/night-use/dev-tools lean dark; reading/productivity/outdoor lean light) and declare the choice.

**Q3 · Color**
> "Do you have a brand color or a logo I should match? And how much color overall?"
- **Hex code** ("#1B4D3E") — used as the seed, tuned per [color.md](color.md)
- **Description** ("forest green", "warm terracotta") — resolved to a concrete hex, echoed back for confirmation
- **Logo** — ask for the file path (or the asset already in the project: check `assets/`, `android/.../ic_launcher`, `web/icons/`). Read the image, extract the dominant brand hue + supporting tones, and derive the seed from it. State what was extracted: *"Your logo reads as deep teal #14655A with a coral accent — building the scheme around that."* The scheme must keep the logo legible on every surface it appears on.
- **Skip / none** — infer a relevant palette from the app's category, chosen style, and register — while still passing the category-reflex check in [color.md](color.md) (relevant ≠ cliché: a finance app gets a trustworthy palette, not the navy-and-gold template).
- Amount: **Restrained** (neutral + one accent) · **Committed** (color carries key surfaces) · **Colorful** (full palette) · **Monochrome + one pop** · You decide

**Q4 · Animation personality**
> "How should the app move?"
1. **Calm & Minimal** — nearly still; instant, quiet transitions
2. **Subtle & Elegant** — soft fades and small slides, nothing bouncy
3. **Smooth & Premium** — flowing container morphs, hero transitions, rich but restrained
4. **Springy & Playful** — bouncy pops, wiggle, celebratory moments
5. **Bold & Dramatic** — choreographed entrances, big cinematic moves
6. **You decide**

## Round 2 — Voice, hierarchy & expression (ask for full builds; skip for scoped tasks)

**Q5 · The anchor question** *(highest-signal question for hierarchy — ask whenever building screens)*
> "What is the ONE thing users should do most in this app?"
The answer sets the entire prominence system: that action gets the only filled high-contrast button, the thumb-zone placement, slot 1 in lists, and the celebration moment. Everything else demotes to tonal/outlined/text. If skipped: infer from the app's category (e-commerce → add to cart; social → post/reply; fitness → start workout) and declare it.

**Q6 · Copy voice**
> "How should the app talk to users?"
1. **Friendly & Warm** *(Airbnb, Slack)* · 2. **Playful & Funny** *(Duolingo)* · 3. **Minimal & Matter-of-fact** *(Apple, Notion)* · 4. **Professional & Corporate** · 5. **Premium & Refined** · 6. **Bold & Direct** *(Stripe, Nike)* · 7. **Supportive & Encouraging** *(Headspace)* · 8. You decide
Follow-up when engaged: *"Complete this: 'We're ___ but never ___.'"* — the "never" half becomes the banned-tone list. Full personalities, tone-by-moment rules, and microcopy numbers: [copy.md](copy.md). If skipped: infer from register + category (utility → Minimal; education/kids → Playful; health → Supportive) and declare.

**Q7 · Expression style (brevity & icons)**
> "How wordy should the interface be?"
1. **Crisp & icon-led** — minimal text, icon-forward visuals, tight headlines *(labels still present; only universal icons work solo — copy.md rules)*
2. **Balanced** (default) — normal labels, short helper text
3. **Explanatory** — more guidance text, spelled-out actions *(first-time-user-heavy or complex-domain apps)*
If skipped: Balanced, leaning Crisp for utility register.

**Q8 · Fine-tuning** *(one combined question, or inferred)*
> "Any preferences on corners, density, typography, or navigation — or should I decide?"
Corners: sharp 0–4 / soft 8–16 / pill / iOS squircle · Density: airy / balanced / compact · Type vibe: neutral-system / distinctive display / editorial serif / mono-technical · Nav: bottom bar / floating pill / rail / drawer / top tabs. All default to the Style Matrix row for the chosen Q1 style.

## Redesign-only round (existing apps)

**QR1 · Scope:** Everything (full overhaul) · Modernize but keep the brand · Colors & theme only · Polish only (spacing, states, motion) · Specific screens: ___
**QR2 · Must-keep:** brand colors / logo treatment / layout structure / copy voice / nothing sacred
**QR3 · Pain point:** "What bothers you most about the current design?" (free text — this is the highest-signal question in the whole interview)

## The Style Matrix — answers become specs

Every Q1 answer resolves to a full spec. Tune to the brand; never ship the matrix raw without the Design Read pass.

| Style | Color | Type | Corners | Surfaces | Spacing | Default motion |
|---|---|---|---|---|---|---|
| **Minimal & Clean** | Off-white/off-black + 1 accent ≤5% | One neutral sans, weight-led hierarchy | 8–12 | Hairline borders, no shadows | Generous (24–32 sections) | Calm-minimal |
| **Elegant & Premium** | Deep ink base, muted warm neutrals, 1 rich accent | Refined grotesk or serif display + quiet body | 12–16 | Soft layered depth, optional film grain | Generous | Smooth-premium |
| **Bold & Expressive** | Committed saturated color 30–60%, high contrast | Heavy display weights, oversized headlines | 0–8 or full pill (pick one) | Flat, color-blocked | Tight-but-rhythmic | Bold-dramatic |
| **Soft & Friendly** | Warm light base, gentle accent pair | Rounded humanist sans (600 max) | 16–24 | Tinted fills, barely-there shadows | Airy | Springy-playful (gentle) |
| **Playful & Pop** | Bright base or white + 2–3 vivid accents | Chunky rounded display | Pill-heavy | Color-blocked cards, sticker-like | Balanced | Springy-playful (full) |
| **Editorial** | Paper + ink, one restrained accent | Serif display + sans body, big type scale | 0–4 | Ruled hairline dividers, no cards | Column-led, generous | Subtle-elegant |
| **Dark Tech** | Near-black + desaturated neutrals + 1 electric accent | Grotesk + mono for data | 4–8 | 1px borders, subtle glow on accent only | Compact-balanced | Calm-minimal, crisp |
| **Glass & Futuristic** | Dark or vivid backdrop, translucent surfaces | Clean grotesk, light weights | 16–24 + squircle | Blur panels (few!), floating chrome | Airy | Smooth-premium |

Style × register conflicts resolve toward the register: Playful + finance app → soften to Soft & Friendly and say so. Glass + low-end-device target → solid-fill fallbacks (signature.md rules).

## The Animation Matrix — Q4 becomes parameters

| Personality | Curves | Durations | Springs (`SpringDescription.withDampingRatio`) | Signature moves | Haptics |
|---|---|---|---|---|---|
| **Calm & Minimal** | easeOutCubic / platform default | 120–200 | None | Fades only, 2–4px slides; instant where frequent | Selection ticks only |
| **Subtle & Elegant** | `Easing.emphasizedDecelerate`, easeOutCubic | 200–300 | None (ratio 1.0) | Fade + 8–16px rise, gentle staggers (40ms) | Light, sparse |
| **Smooth & Premium** | Emphasized set, easeOutQuart | 250–450 | ratio 0.9–1.0, stiffness 300–700 | Container transform, Hero, gesture-scrubbed parallax, crossfade+scale 0.96→1, shimmer accents | Choreographed to landings |
| **Springy & Playful** | Springs everywhere | Spring-settled (~400–700) | ratio 0.5–0.7, stiffness 200–400 | Scale pops 1→1.15→1, error wobble (3× ±8px, 300ms), confetti on wins, stretchy overscroll, mascot/Rive reactions | Rich: pops, ticks, success buzz |
| **Bold & Dramatic** | Emphasized + long deceleration | 350–650 (heroes only) | ratio 0.6–0.8 spatial (visible overshoot) | Shape morphs, choreographed entrances, big shared-axis moves, full-screen blur-in reveals | Strong at moments, quiet between |

Spring anchor values (M3 Expressive motion tokens): *spatial* properties (position/size/shape) may bounce — fast 0.9/1400, default 0.9/700, slow 0.9/300 (damping/stiffness); *effects* (color/opacity/blur) never bounce — damping 1.0. Expressive feel drops spatial damping to 0.6–0.8. iOS reference points: `.smooth` ≈ damping 1.0, `.snappy` ≈ 0.85, `.bouncy` ≈ 0.7. Dark Tech adds: number count-up tickers, chart draw-ins 600–900ms, slow glow pulses.

Universal floors regardless of personality: press feedback everywhere, exits faster than enters, `disableAnimations` respected, keyboard-frequency actions never animated ([motion.md](motion.md) owns the canonical numbers).

## Component mapping

Q1/Q4 answers select component recipes from [catalog.md](catalog.md): button style + press behavior, nav pattern, sheet/menu flavors, card treatment, loading personality. Q5's answer drives placement and prominence via [psychology.md](psychology.md) (thumb zone, one-filled-button rule, slot-1 pinning). Q6 selects the voice system in [copy.md](copy.md); Q7 sets its brevity dial. Load all three when building after an interview.

**NEVER:** ask more than 2 rounds; re-ask what the prompt already answered; ask mid-build (interview happens once, upfront); ship matrix specs without the register/brand pass; treat a skipped question as "do nothing" instead of "infer and declare."
