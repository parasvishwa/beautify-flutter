# Internationalization & RTL

Apps outgrow their launch locale. Layouts built with left/right instead of start/end, and strings measured only in English, break silently the day Arabic, Hebrew, or German arrives. Build direction-agnostic from the first widget — it costs nothing now and a rewrite later.

## Directional layout (the default, not the exception)

| Never (physical) | Always (logical) |
|---|---|
| `EdgeInsets.only(left:, right:)` | `EdgeInsetsDirectional.only(start:, end:)` |
| `Alignment.centerLeft/Right` | `AlignmentDirectional.centerStart/End` |
| `Positioned(left:, right:)` | `Positioned.directional(start:, end:, textDirection:)` or `PositionedDirectional` |
| `BorderRadius.only(topLeft: …)` | `BorderRadiusDirectional.only(topStart: …)` |
| `Row` children ordered "left to right" mentally | `Row` is already direction-aware — just don't fight it with physical constants |

Symmetric values (`EdgeInsets.symmetric`, `EdgeInsets.all`) are direction-safe — the token examples in [theme.md](theme.md) stay as they are. The rule bites on *asymmetric* padding, alignment, and positioning.

What flips automatically in RTL: `Row` order, `ListTile` leading/trailing, `TextField` alignment, navigation transitions, back icons via `Icons.adaptive.arrow_back`. What doesn't: anything hardcoded physical, custom `CustomPainter` geometry (check `Directionality.of(context)`), and icons whose *meaning* is directional (reply, undo, forward arrows) — wrap genuinely directional glyphs in a conditional flip; leave non-directional ones (play, search) alone.

## Setup

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations: { sdk: flutter }
  intl: any
flutter:
  generate: true # gen-l10n
```

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
)
```

Strings in ARB files from day one — even a single-locale app benefits: it centralizes copy for the SKILL.md copy self-audit, and placeholders force plural/format thinking (`{count, plural, ...}` — never `"$count item(s)"`).

## Expansion-safe layout

- German/Finnish run ~30–35% longer than English; Chinese ~30% shorter but taller line boxes. Buttons, tabs, and nav labels must survive the longest supported translation: flexible width, `maxLines: 1` + ellipsis only as a last resort (truncated labels are a defect, not a strategy).
- Never design a layout that only works because the English string is short. Test key screens with pseudo-long strings ("Übersetzungswissenschaft") during the build, not after.
- Dates, numbers, currency: `intl`'s `DateFormat`/`NumberFormat` with the active locale — never hand-formatted `"$"` or `"MM/DD"`.

## The RTL pass (add to every verify step)

```dart
// Force RTL in a test or debug build:
MaterialApp(locale: const Locale('ar'), ...)
// or wrap a screen: Directionality(textDirection: TextDirection.rtl, child: screen)
```

Check: mirrored layout still reads correctly; asymmetric spacing followed the flip; directional icons flipped and non-directional ones didn't; text fields align start; no overflow from longer strings; `CustomPainter` surfaces mirrored where they should.

**NEVER:** physical left/right in new code without a written reason; concatenating translated fragments into sentences (word order differs — use placeholders); baking text into images; flag icons as language pickers (languages ≠ countries); assuming the app "will only ever be English" — that decision belongs to the user, not the layout.
