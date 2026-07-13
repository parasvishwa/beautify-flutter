# Anti-patterns — the tells of default & AI-generated Flutter

Match-and-refuse. These are the signatures a generated Flutter app defaults to. When auditing, scan for these first; when building, catch yourself mid-keystroke.

## Tier 1 · Template tells (instantly recognizable)

1. **The default purple.** `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` untouched, or `Colors.blue`, or `primarySwatch`. → Real brand hue, tuned scheme ([color.md](color.md)).
2. **The default TextTheme.** Roboto/SF at stock sizes, no `height`, no `letterSpacing`. → Deliberate scale ([typography.md](typography.md)).
3. **`debugShowCheckedModeBanner`, default splash, "flutter_application_1".** Remove/replace all three.
4. **The counter-app AppBar:** primary-colored fill, centered title, hard shadow. → Flat, surface-colored, hairline on scroll only.
5. **Identical card grids** — icon + title + subtitle × N, same size, default elevation. → Vary anatomy by content; cards only when elevation means something.
6. **`Icons.rocket_launch` / `Icons.auto_awesome`-grade icon clichés** on feature rows, and mixed icon families. One family, consistent weight.

## Tier 2 · Visual tells

7. **Magic numbers everywhere:** `EdgeInsets.all(16)`, `SizedBox(height: 20)`, `BorderRadius.circular(8)` inline, four radius families on one screen. → Token scale, one radius family.
8. **Pure black dark mode** (`#000`), pure white text, drop shadows in dark. → Near-black base, ladder elevation, off-white text.
9. **Raw hex/`Colors.grey[600]` sprinkled in widgets.** → Scheme roles only.
10. **Side-stripe accent borders** on cards/alerts/list items. → Full hairline, tint, or leading glyph.
11. **Gradient text, glassmorphism-by-default, neon glow.** → Solid color; blur rare and purposeful.
12. **Gray text below 4.5:1** "for elegance", especially on tinted backgrounds. → Darken toward ink.
13. **Cramped edge-to-edge layout** or uniform spacing with no rhythm. → Spacing scale with grouped proximity.
14. **Category-reflex palette** (meditation = sage, finance = navy/gold, AI = purple glow). → Run the category-reflex check.

## Tier 3 · Behavioral tells

15. **Bare centered spinner** as the loading strategy; spinner flash under 300ms; layout shift when content lands. → Skeletons matching layout; nothing < 300ms.
16. **Blank or exception-text screens** for empty/error. → Designed states with a next action.
17. **No press feedback** on tappable cards/rows; hover missing on web/desktop; no disabled states. → Full state cycle ([components.md](components.md)).
18. **Instant content swaps** with no transition; or the opposite — the same fade-and-rise on every widget. → Motion where it explains something ([motion.md](motion.md)).
19. **Broken iOS back-swipe / Android predictive back**; Material zoom transition on iOS. → Platform respect ([platform.md](platform.md)).
20. **Overflow stripes** at narrow widths, landscape, or 130% text scale; content under notches. → SafeArea + flexible layout, tested.
21. **Phone UI stretched to tablet/desktop/web** — 1200px-wide list rows, bottom nav on a 27" monitor. → Window size classes.
22. **Elastic/bounce entrances on chrome**, 600ms dropdowns, animation on every keystroke-frequency action. → Duration/curve discipline.

## Tier 4 · Code tells that surface visually

23. **Deprecated API fingerprints:** `MaterialStateProperty`, `surfaceVariant`, `colorScheme.background`, `textScaleFactor`, `withOpacity`, `CardTheme(` — signs of stale generated code. → Current APIs.
24. **Missing `const`,** mapped-`Column` "lists", `shrinkWrap` stacks, full-res images in avatars → jank tells ([performance.md](performance.md)).
25. **Styling copy-pasted across widgets** instead of component themes; the same button styled three slightly different ways.
26. **1000-line build methods** / helper-method widget factories. → Extracted widget classes.

## Tier 5 · Content tells

27. **"John Doe", "Jane Smith", "Acme Corp", `user@email.com`, 555-phone numbers.** → Realistic, locale-appropriate sample data.
28. **Fake-perfect numbers** (99.9%, 12345, $100.00 everywhere). → Organic values ($47.20, 3 min ago).
29. **AI-cute copy:** "Oops! Something went wrong 🚀", "Elevate your workflow", "Seamless. Powerful. Yours.", playful-metaphor loading messages. → Plain, specific, useful strings.
30. **Em-dashes in UI strings.** Zero tolerance — restructure the sentence.
31. **Placeholder-as-label forms; "Submit"/"OK"/"Yes/No" buttons.** → Persistent labels; verb-specific buttons ("Save changes", "Delete 3 items", "Keep editing").
32. **Emoji as icons** in production chrome. → Icon set glyphs.

## Audit protocol (for `audit` / `critique` invocations)

Scan then score. Grep-pass first (mechanical, fast):

```bash
# Inline styling in screens: NUMERIC literals only, so token-based code
# (EdgeInsets.all(Insets.lg)) and Colors.transparent don't false-positive.
grep -rnE "Color\(0x|Color\.fromARGB|Color\.fromRGBO" lib/ --include="*.dart" | grep -vE "theme/|tokens" | head -30
grep -rnE "Colors\.[a-z]" lib/ --include="*.dart" | grep -vE "theme/|tokens|Colors\.transparent" | head -30
grep -rnE "fontSize:\s*[0-9]|BorderRadius\.circular\(\s*[0-9]|EdgeInsets\.(all|symmetric|only)\(\s*[0-9]" lib/ --include="*.dart" | grep -v theme/ | head -30
# Deprecated APIs
grep -rnE "MaterialStateProperty|surfaceVariant|textScaleFactor|withOpacity\(|CardTheme\(" lib/ --include="*.dart"
# Template leftovers
grep -rnE "deepPurple|debugShowCheckedModeBanner|flutter_application" lib/ --include="*.dart"
# List hygiene
grep -rn "shrinkWrap: true" lib/ --include="*.dart"
```

Grep hits are leads, not verdicts — read the line before reporting it.

Then score five dimensions 0–4 each (0 = slop gallery, 4 = no tells found):

| Dimension | What 4 looks like |
|---|---|
| Theming | All styling via theme/tokens; both modes designed; current APIs |
| Typography & color | Deliberate scale, tuned palette, contrast passes |
| States & interaction | Full state cycles; loading/empty/error designed |
| Platform & adaptivity | Native-feeling on both platforms; size classes handled; no overflow |
| Motion & performance | Purposeful, disciplined motion; builder lists, const, no jank tells |

/20 with bands: 18–20 excellent · 14–17 solid, polish pass · 9–13 significant work · ≤ 8 foundation rebuild. Most real apps score 10–15. Report findings as P0 (blocks trust/usability) → P3 (polish), each with location, why it matters, and the fix. Be brutally honest — start with the verdict: *does this look default-generated or designed?*
