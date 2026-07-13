# Content & copy

Every string the user sees is design. Copy has a **voice** (constant personality) and a **tone** (how that personality flexes to the moment). Voice is chosen once in the interview; tone shifts are rules, not choices. Clarity always beats cleverness: measured usability gains — concise text +58%, non-promotional language +27%, both combined with scannable layout +124% (NN/g).

## Voice: pick one, on four dials

Every voice sits somewhere on NN/g's four dimensions: **formal↔casual · serious↔funny · respectful↔irreverent · matter-of-fact↔enthusiastic.** Record the four positions plus 3–5 **"we're ___ but never ___"** pairs (the "never" halves are the banned-tone list).

### The seven voices (interview options)

| Voice | Anchor apps | Signature | Button style | Emoji |
|---|---|---|---|---|
| **Friendly & Warm** | Airbnb, Slack | Conversational, contractions, second person | "Save changes", "Invite friends" | Rare, celebratory only |
| **Playful & Funny** | Duolingo, Discord | Big feelings, simple words; joke in sentence 2, never in the button | Short + punchy | Yes, with intent |
| **Minimal & Matter-of-fact** | Apple system apps, Notion | Fewest words; fragments fine; restraint IS the personality | 1–2 words ("Done") | Never |
| **Professional & Corporate** | Microsoft 365, enterprise | Complete sentences, precise nouns, consistent terminology | Specific verbs | Never |
| **Premium & Refined** | Apple marketing, luxury | Unhurried, confident, zero urgency tactics, earned adjectives | Elegant verbs ("Explore", "Reserve") | Never |
| **Bold & Direct** | Stripe, Nike | Imperative, verb-first, numbers over adjectives, zero fluff | Terse + concrete | No |
| **Supportive & Encouraging** | Headspace, Calm | Permission-giving, never guilt-tripping; compassionate streak-loss copy | Gentle verbs | Soft, rare |

Example — the same error in four voices:
- Minimal: *"Couldn't save. Check your connection and try again."*
- Friendly: *"Something went wrong on our end. Try again in a minute."*
- Playful (low-stakes only): *"Well, this is awkward. We lost the connection. Try again?"*
- Corporate: *"Your changes couldn't be saved because the file is open elsewhere. Close it there, then try again."*

**Personality lives in headlines, empty states, and success moments. Functional copy (buttons, forms, errors) stays nearly identical across all voices.**

## Tone shifts by moment (voice stays constant)

| Moment | Tone | Hard rules |
|---|---|---|
| Errors / payment / data loss | Serious, matter-of-fact | **No humor ever**, no blame, no "Oops!", no exclamation marks |
| Success / milestone | Briefly enthusiastic | One line; earned celebration only |
| Onboarding | Warm, lightly explanatory | Explain "why" once |
| Routine UI (settings, forms) | Neutral | Personality mostly disappears |
| Empty states | Helpful, lightly warm | Why empty + what goes here + how to fill it |
| Destructive confirmations | Dead serious, specific | Name the item and the consequence |

## Microcopy rules (the numbers)

- **Reading level:** grade 6–8 for consumer apps (Polaris mandates 7th grade); ≤12 even for experts.
- **Buttons:** 1–3 words, verb-first, outcome-specific — "Delete 3 photos" / "Keep editing", never "OK"/"Yes"/"Submit". ~20–35 chars max.
- **Headlines:** 30–40 chars; subheads 40–60. Users judge a list item by its **first ~2 words (~11 chars)** — front-load the differentiating word.
- **Errors:** what happened + why (if useful) + how to fix, next to the source. Never "invalid/illegal/error 403". Preserve the user's input. System faults take responsibility.
- **Empty states:** status + what could be here + one action button. Never bare "No data."
- **Onboarding:** most apps don't need instructional onboarding (users who read tutorials rated tasks *harder* — NN/g). If used: visible Skip, one concept per card, headline ≤40 chars + one line ≤90.
- **Forms:** labels persist above fields (placeholder-as-label failed in every Baymard test); mark required AND optional; helper text one line, only when needed.
- **Confirmations:** destructive/irreversible only. Name the item: *"Delete 'Q3 budget'? You can't undo this."* Buttons state outcomes ("Delete file" / "Keep file"). No pre-selected destructive default.
- **Casing:** Material/Android = sentence case everywhere; Apple = Title Case on controls, sentence case for prose. Follow the platform (or the chosen brand rule, applied everywhere).
- Leave +30–35% width headroom for translation (intl.md).

## Icons vs text (the evidence)

**Universal icons are rare** — the safe icon-only list is roughly: search, home, play/pause, settings-gear, back-arrow, close-X, share (platform glyph) — in their standard positions. Everything else is ambiguous (a clock icon for "history" scored 0% comprehension). Obscure icon = wasted feature.

Decision rule:
- **Default: icon + always-visible label** (navigation, tabs, primary actions — both Apple and Google require nav labels).
- **Icon-only** passes only if ALL hold: universal-list icon · standard placement · low-stakes/recoverable action · tooltip + Semantics label present.
- **Text-only is always acceptable; icon-only almost never is.** 5-second test: can't think of an obviously fitting icon in 5 seconds → ship text.
- "Crisp, icon-led" style (interview) = icon-forward *visual* weight with tiny labels still present, universal icons doing solo work, and text carrying everything non-universal — not mystery-meat navigation.

## The brevity spectrum

79% of users scan; 16% read. Aim for ~50% of conventional word count — by deleting redundancy, never by deleting information the user needs to act (the object, the consequence, the remedy).

- Cut: "Welcome to", "In order to", "please", "simply", "just", promotional adjectives ("powerful", "seamless", "revolutionize").
- Crisp headline formulas: value-first noun phrase ("This week"), verb-first imperative ("Track every subscription in one place"), outcome + timeframe ("Set up in 2 minutes"), question only when the UI answers it.
- Progressive disclosure of text: label → helper line → "Learn more" → docs. Never front-load layer 3.
- When short hurts: "Manage" (manage *what*?), "Something went wrong" with no remedy, "Are you sure?" without the item name — under-informative is worse than long.

## The copy self-audit (before shipping any screen)

Re-read every visible string: grammatically sound · no AI-cute phrases · no em-dashes in generated copy · voice-consistent · errors follow the formula · buttons verb-first and outcome-specific · numbers real or labeled mock · reading level sane. AI-generated clever copy is worse than boring copy.

**NEVER:** humor in errors; shame mechanics ("You abandoned your streak") in any voice; mixed voices across screens; placeholder-as-label; "Oops!"; a button that doesn't say what happens next.
