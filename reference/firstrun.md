# First-run experience — icon, splash, onboarding

"Beautiful" is judged in the first 60 seconds, before any screen is used. This file owns the app's first impression.

## App icon

**iOS 26:** icons are layered, light-responsive objects — foreground/mid/background layers assembled in Apple's **Icon Composer** (ships with Xcode 26), exported as one `.icon` file that drives default, dark, clear-glass, and tinted modes. 1024×1024 canvas, symbol centered with breathing room (the system masks corners). **Don't bake in shadows/highlights/gradients** — the system's glass material adds them. Supply deliberate dark/tinted-aware layers or the system auto-generates muddy ones. `flutter_launcher_icons` handles static PNG sets; the layered `.icon` is authored in Icon Composer and dropped into `ios/Runner`.

**Android:** adaptive icon = foreground + background layers (108×108dp, artwork inside the 66dp safe zone) **plus the monochrome layer** — Android 13+ themed icons tint it from the wallpaper; **Android 16 auto-themes icons that don't provide one**, so omitting it means the system invents your silhouette. Emit all three in `flutter_launcher_icons` config (`adaptive_icon_foreground/_background/_monochrome`). Design the glyph to survive arbitrary tint: one readable silhouette — the same discipline iOS tinted mode demands.

## Splash → content choreography (kill both seams)

1. **Native frame (0ms):** `flutter_native_splash` — plain background + centered icon (Android 12+ enforces this recipe anyway), light AND dark variants configured.
2. **Preserve + release:** `FlutterNativeSplash.preserve(widgetsBinding:)` in `main()`, minimal init, `remove()` once the first real frame is ready — no white flash between native and Flutter.
3. **Animated handoff:** route `/` renders **pixel-identical** to the native splash (same color, same logo, same position), then animates — logo scales/fades 300–500ms `easeOutCubic`, content staggers in 50–80ms/element. The eye can't find the native→Flutter switch.

Bad version: native splash → different-looking Flutter loader → hard cut to home. Two visible seams = template app.

## Onboarding (the evidence)

- **Value before signup:** let the user complete one real unit of work, then ask for the account to "save your progress" (Duolingo: +20% DAU). Soft walls before hard walls (+8.2%).
- **Tour vs quiz:** tour-style capped at 3–5 screens with a visible Skip. **Personalization quizzes may run longer** — length isn't the variable, perceived value per screen is (a longer quiz beat a short one: +40% payment conversion in Adapty's data). One question per screen, big targets, instant visible reaction to each answer, answers echoed back ("Based on your 10 min/day goal…").
- **Structure:** emotional anchor first (character, imagery, one beautiful moment) → micro-commitment → proof of value → bigger asks. Immediate first-win celebration. Reach real value within ~60 seconds (3–5× retention difference).
- **No instructional tutorial carousels** — measured to make apps feel harder (psychology.md). Empty states teach instead.
- **Progress:** dots for ≤5 tour screens; a thin filling bar for quizzes (progress itself motivates — never moves backward).

## Permission priming (never cold-fire an OS dialog)

Soft-ask screen first: the concrete benefit + **"Enable"** and **"Not now"** (never "No"). Fire the native prompt only after Enable. Data: cold asks convert 35–45%; primed asks 60–75%. Ask at the value moment (after setting a reminder), never on first launch. "Not now" preserves the re-ask; a denied native prompt is nearly unrecoverable.

## Store screenshots (the last surface)

Users decide in ~7 seconds and see 2–3 screenshots. Lead with the core benefit screen; caption formula = 3–5 words, verb + outcome ("Build habits that stick"); one consistent background system across the set so the gallery reads as a single banner. Baseline sizes: iPhone 6.9″ 1290×2796, iPad 13″ 2064×2752.

**NEVER:** default splash or template icon in any release; a full-color-only Android icon (broken on themed home screens); permission dialogs on first launch; signup before value; a tutorial explaining what good design would make obvious.
