# Components & states

Unseen details compound. Every control the user touches ships with its full state cycle, and every screen ships loading, empty, and error designs. Half-finished states are how trust is lost.

## The state cycle (mandatory per interactive element)

default · pressed · hover (web/desktop) · focus (keyboard) · disabled · loading · error/success where applicable.

Define once in component themes with `WidgetStateProperty.resolveWith` (theme.md §4) — never per-widget. Resolution order matters: check `disabled` first, then `pressed`, then `hovered`/`focused`.

Press feedback on *everything pressable*: ink (`InkWell` with correct `borderRadius`) or scale:

```dart
// Tactile press: scale to ~0.97 over ~120ms, spring back on release.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.onTap});
  final Widget child; final VoidCallback? onTap;
  @override State<Pressable> createState() => _PressableState();
}
class _PressableState extends State<Pressable> {
  bool _down = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => setState(() => _down = true),
    onTapUp: (_) => setState(() => _down = false),
    onTapCancel: () => setState(() => _down = false),
    onTap: widget.onTap,
    child: AnimatedScale(
      scale: _down ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: widget.child,
    ),
  );
}
```

Hover exists on web/desktop: gate hover-revealed functionality — anything hover shows must also be reachable by tap/keyboard.

## A tappable card done right

Ink must clip to the radius; the border rides the ink, not a wrapper:

```dart
Material(
  color: scheme.surfaceContainerLow,
  borderRadius: Radii.card,
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: onTap,
    child: Ink(
      decoration: BoxDecoration(
        borderRadius: Radii.card,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(padding: const EdgeInsets.all(Insets.lg), child: child),
    ),
  ),
)
```

## Buttons

- Primary = `FilledButton`; secondary = `FilledButton.tonal` or `OutlinedButton`; tertiary = `TextButton`. One vocabulary app-wide — if "Save" is filled on one screen, it's filled everywhere.
- Height ≥ 48. Label ≤ 3 words for primary CTAs, never wrapping to two lines.
- **Loading state lives inside the button** — width stable, no layout jump:

```dart
FilledButton(
  onPressed: loading ? null : submit,
  child: AnimatedSwitcher(
    duration: Motion.fast,
    child: loading
      ? const SizedBox.square(key: ValueKey('s'), dimension: 18,
          child: CircularProgressIndicator(strokeWidth: 2))
      : Text(label, key: const ValueKey('l')),
  ),
)
```

- Destructive actions: named for the object ("Delete 5 photos", not "Delete selected" or "OK"), styled with `error` colors, confirmed via undo where possible ("most confirmation dialogs are design failures").

## Forms

- Label **above** the field, persistent — placeholder-as-label is banned (it vanishes on focus and fails recall).
- Validate on blur/submit, not per keystroke. Errors below the field, specific, actionable: what happened + how to fix.
- `keyboardType`, `textInputAction` (`.next`/`.done`), and `autofillHints` on every field — autofill makes form completion roughly a third faster. Wrap flows in `AutofillGroup`.
- Single column. Group related fields; ≤ 4 fields per visual group.

## Loading / empty / error (design all three, always)

**Loading**
- < 300ms expected: show nothing (spinner-flash reads as a glitch).
- Content-shaped loads: skeletons matching the final layout — no layout shift on arrival. Package: `skeletonizer` (wraps your *real* layout with fake data: `Skeletonizer(enabled: loading, child: ...)`, `enableSwitchAnimation: true` for the skeleton→content crossfade, `Skeleton.ignore/.keep` annotations) — or hand-rolled containers in `surfaceContainerHighest` pulsing opacity.
- Action feedback: inline in the triggering control (button spinner above).
- Bare centered `CircularProgressIndicator` on a content screen: banned as the strategy.

**Empty** — first-use, cleared, no-results, and no-permission are different states. Anatomy: a visual (restrained), one line of what will be here, one primary action to populate it. Empty states teach the interface.

**Error** — plain-language what-happened + retry action. Distinguish offline from server error. Never a raw exception string, never "Oops! Something went wrong!" with an exclamation mark and no action.

## Lists

- `ListView.builder`/`.separated` beyond ~20 items. Fixed-height rows: pass `itemExtent` or `prototypeItem`.
- Row anatomy varies with content; a wall of identical `ListTile`s with the same trailing chevron is scaffolding.
- Swipe actions (`Dismissible`) need an undo path. Pull-to-refresh via `RefreshIndicator.adaptive()`.
- Staggered entrance only for short, above-the-fold lists (motion.md); never delay a long scrolling list.

## Dialogs, sheets, menus

- Bottom sheets over dialogs on mobile for anything with > 2 choices or any input; thumb-reachable, draggable, themed shape (top radius from `Radii.sheet`).
- `AlertDialog.adaptive()` when a dialog is genuinely right (blocking decisions only).
- `showModalBottomSheet(isScrollControlled: true, useSafeArea: true)` + `DraggableScrollableSheet` for tall content; `wolt_modal_sheet` for multi-page flows that morph between bottom-sheet (compact) and dialog (wide) — the current best-in-class modal package.
- Everything that floats (menu, dialog, sheet) sits on the correct container-ladder step (theme.md) — dark mode depth comes free.

**NEVER:** ship a control missing its disabled state; a hover-only affordance; a form that loses input on rotation; toasts for errors that need action (snackbar with action, or inline); more than one FAB; disabled buttons with no way to discover why.
