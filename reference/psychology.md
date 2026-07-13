# UX psychology — placement, prominence, and order

The science behind where things go, how loud they are, and what comes first. Numbers here are from eye-tracking and A/B evidence (NN/g, Baymard, Hoober's touch research, Kivetz, Cowan) — treat them as constraints, not suggestions.

## The laws, as mobile rules

| Law | The mobile rule |
|---|---|
| **Fitts** | Targets ≥ 48dp/44pt; primary CTAs 48–56dp tall, bottom third, near where the user just acted. Touch accuracy: ~7mm error at screen center, ~12mm at corners — **enlarge** edge/corner targets, never shrink them. ≥ 8dp between adjacent targets. |
| **Hick** | 3–5 tab destinations; one primary + ≤ 2 secondary actions per decision point; pre-highlight the recommended option; chunk long option sets, don't delete them. |
| **Miller/Cowan** | Working memory is **4±1 chunks**, not 7. Applies to what must be *remembered* (steps, comparisons), not visible lists. Chunk codes (XXX-XXX), group settings into 3–5-row sections. |
| **Jakob** | Users live in other apps. Bottom tabs, back-swipe, pull-to-refresh, gear=settings, magnifier=search. Convention is a feature; novelty needs a measured reason. |
| **Von Restorff** | Exactly ONE isolated primary action per screen — if two elements compete, neither is emphasized. Differentiate on ≥ 2 channels (never color alone). |
| **Serial position** | Tab-bar ends are premium (Home leftmost, Profile rightmost); slot 1 of any list gets ~2.5× the clicks — pin the user's current job there; strongest onboarding message first, CTA last. |
| **Zeigarnik** | Progress meters + "Resume" cards + step indicators ("2 of 4") create productive tension. Peek the next carousel card (~10–20% visible). Cap the nagging. |
| **Peak-End** | Users judge the whole app by its peak moment and its ending. Spend animation budget on: completion moments, the single peak of value, and graceful exits. Middle-of-flow screens stay fast and plain. **Negative peaks weigh more** — design error/empty/wait states before polishing chrome. |
| **Aesthetic-Usability** | Polish buys real forgiveness (first impressions form in ~50ms) — and masks problems in testing. Never use beauty to paper over a broken flow. |
| **Doherty** | < 100ms tap feedback, < 400ms interaction round-trip, no spinner under 1s, percent-done over 10s. Optimistic UI for reversible actions. |
| **Tesler** | Complexity is conserved — absorb it: smart defaults, autodetect (card type from digits, city from ZIP), autofill, auto-format. Every inferable field is a field to delete. |
| **Goal-Gradient** | Never show 0% progress — seed it ("Account created ✓" as step 1; a 12-step bar with 2 pre-filled beats an empty 10-step). Surface shrinking distance ("1 step left"). Present the next goal immediately after completion. |
| **Postel** | Accept every plausible input format, normalize internally; never block paste; validate on blur; display back in one canonical format. |
| **Proximity / Common Region** | Between-group spacing ≥ 2× within-group. A card binds image+title+price+button into one unit — and the whole region is the tap target. |

## Where the eyes go (mobile eye-tracking)

- **Top-left → top-half is prime real estate** on app UIs; the geometric center matters for content feeds, not chrome. Users fixate **text** first — labels, not icons, not bright colors ("when everything stands out, nothing pops").
- **57% of attention is in viewport 1; 74% in the first two screenfuls.** Identity/status, the primary action, and the key data must render above the fold; attention roughly halves per scroll.
- Users read ~20–28% of words. Headings + bolded keywords + bullets convert the lazy F-pattern scan into the effective layer-cake scan.
- **Banner blindness:** anything styled like a promo (big colorful rounded box, marketing typography) is skipped even in slot 1. Never dress critical content as an ad.

## Hierarchy mechanics

- Salience levers, strongest first: **size → luminance contrast → position → weight → hue → whitespace**. Give the primary element ONE dominant cue; "the large AND red one" isn't preattentive.
- **Max 3 size steps per screen**, only 1–2 elements at the largest; reach for weight (Medium/Semibold) before a fourth size. Scale ratio 1.2–1.25 for app UI.
- **The blur test** (mechanical squint test): blur the screenshot ~8px. Exactly one blob should dominate and groupings should still read. If the CTA disappears, hierarchy failed.
- One filled high-contrast button per screen; evidence: single-CTA layouts convert measurably better (1:1 attention ratio); Material's emphasis tiers exist for this.

## Button placement (the evidence)

- **75% of touches are thumb-driven; 49% one-handed.** Natural zone = bottom-center/bottom-right arc (96% tap accuracy vs 61% in the stretch zone). Top-left is the "ow" zone for the right-thumb majority — rare/dangerous actions only.
- Primary CTA: **bottom third**, full-width or right-aligned, out of the iOS 34pt home-indicator band and Android's gesture zone. Duplicate it inline at the decision point; make it sticky once the inline one scrolls away (~5–12% conversion lift in commerce).
- Pairs: **primary right, secondary left**; stacks: **primary on top**. Both platforms.
- Destructive: never the default, never adjacent to a frequent control, label restates the act ("Delete account", not "Yes"), prefer undo over confirmation for frequent actions.
- FAB: only when ONE creative action dominates usage (compose, add); never two, never destructive, never covering list rows' trailing actions.
- Navigation: visible bottom bar beats hamburger by every metric (86% vs 57% usage, +20% discoverability, 15% faster on mobile); icon+label beats icon-only (labels lifted engagement 75% in Robinson's data).

## What comes first, second, third

The **priority guide** method: before layout, write the screen as a single column of real content, ordered strictly by user importance. Then design it.

App home screen order: **(1) where am I / what's this worth → (2) my current state** (balance, streak, next lesson, order status) **→ (3) the one thing to do next** (dominant CTA in thumb reach) → supporting content → secondary actions. ≤ 2 levels of progressive disclosure — deeper loses users.

Onboarding order (measured): **value before signup** — Duolingo moved signup after the first lesson: **+20% DAU**; soft walls before hard walls: +8.2%. No tutorial carousels (users who read them rated tasks *harder*); the empty state carries the first-run CTA instead. Reassure before the ask (a transparent trial timeline lifted signups +23%). Permissions asked in context, never on first launch.

Forms: single column (15.4s faster); target ≤ 8 fields (average checkout has 11.3 — cut three); one topic per screen with a progress cue (Just Eat gained ~2M orders/year splitting checkout); combine name fields; hide optionals behind links; billing = shipping by default.

## Category psychology — the emotional job sets the design

The master dial is IBM Carbon's **productive : expressive** motion split — productive motion stays out of the way (task contexts), expressive motion is the rare rhythmic break (celebrations, brand moments). Set the ratio per category:

| Category | Emotional job | Productive:expressive | Design/copy implication |
|---|---|---|---|
| Finance | Trust, control | 95:5 | Desaturated blues/greens, tabular numerals (always show cents), strict grids (+17% perceived professionalism), reassurance microcopy *next to* sensitive fields at the anxiety moment (not footers, ~+31% willingness), zero bounce near money, deterministic skeletons |
| Health/wellness | Encouragement, privacy, non-judgment | 80:20 | Fogg's B=MAP: make the first action tiny (<30s) and celebrate immediately after. Never shame ("You missed a workout" → "Ready when you are"); forgiving streaks beat hard resets; state privacy in-context ("Stored only on your device"); gentle 200–400ms motion; neutral (not alarm-red) colors for gaps |
| Social | Belonging | 60:40 | Springy reaction animations expected; name people not metrics ("Maya replied"); presence honest, never fabricated; batch non-urgent notifications |
| E-commerce | Desire + honest urgency | 75:25 | #1 abandonment cause IS a dark pattern (surprise costs, 48%) — show totals early. Real variant-level stock counts help; blanket timers train blindness. Add-to-cart spatial continuity; purchase-success is the peak-end moment |
| Productivity | Momentum, flow | 90:10 | Flow needs clear goals + immediate feedback: 70–240ms everything, nothing blocks input; Zeigarnik progress persistently visible; celebration rare, randomized, opt-out (the Asana model) |
| Education | Progress, mastery | 55:45 | The one category where big celebration IS core mechanics (Duolingo: streak animation alone +1.7% D7; 7-day streak → 3.6× course completion; leagues +25% completion). SDT: autonomy + competence + relatedness; forgiveness mechanics (freezes cut at-risk churn ~21%) |
| Media/content | Immersion | 85:15 | Chrome recedes (scroll-away bars), content is the interface, quiet CTAs |

**The ethical line — the Deceptive Design taxonomy (18 types; FTC 2022 + EU DSA Art. 25 make this compliance, not taste).** Never: fake urgency/scarcity/social proof (timers that reset on reload are fraud); confirmshaming; hidden costs until checkout; hard-to-cancel (cancel takes ≤ the steps signup took); preselected paid add-ons or consents; trick wording/double negatives; disguised ads; visually burying the user-favoring option; nagging past a "no"; virtual currency obscuring real cost; variable rewards used purely to extend sessions. Persuasion aligns the user's goal with the path; a dark pattern works against it.

## Motion psychology

Motion personality IS brand perception: springy = playful/young, smooth-emphasized = premium/trustworthy, instant = professional/efficient (interview.md maps this). Easing is the tone of voice, duration the tempo, distance the volume — the same layout with a different curve is a different brand.

**Celebration rules (evidence-backed):** celebrate the *user's* goal (task done, milestone hit), never continued consumption (scroll depth, session length — that's the "addictive design" dark pattern). Full celebration ≤ 1/session, genuine milestones only; routine completions get a ≤300ms micro-acknowledgment; randomize variants to preserve surprise; never block input; provide an off switch; suppress under reduced-motion; never celebrate in loss contexts (no confetti on a budget overdraft). Frequency law: the more often an animation occurs, the shorter and subtler it must be.

Calm-technology principles for utility surfaces: status via peripheral signals, motion resolves and *stops* (no ambient loops in the periphery), notification restraint is a design property.

**NEVER:** two competing primary actions; critical actions in the top-left thumb-ow zone; progress bars starting at 0%; signup walls before value; tutorial carousels; humor or decoration around money/errors; any pattern from the dark-patterns list.
