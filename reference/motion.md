# Motion

Motion is what separates functional from crafted — and it is also where apps most visibly fail. Every animation answers four questions, in order, before it exists.

## 1 · Should this animate at all?

| Frequency of use | Decision |
|---|---|
| 100+ times/day (tab switches for power users, keyboard actions, search focus) | No animation. Ever. |
| Tens of times/day (list navigation, common toggles) | Minimal — press feedback only |
| Occasional (sheets, dialogs, navigation pushes, toasts) | Standard animation |
| Rare / first-time (onboarding, success, celebrations) | Delight allowed |

Never animate keyboard-initiated actions. Speed is the feature for repeated interactions.

## 2 · What's the purpose?

Valid: spatial continuity (where did this come from), state indication, user feedback (the interface heard you), preventing a jarring swap, sequenced storytelling (onboarding). Invalid: "it looks cool" on anything seen often. If you can't justify an animation in one sentence, delete it — deletion is the strongest fix.

## 3 · Which curve?

Flutter ships M3 curves in the `Easing` class. Decision tree:

- Element **entering** → `Easing.emphasizedDecelerate` (fast start = responsive)
- Element **exiting** → `Easing.emphasizedAccelerate`
- Moving/morphing **on screen** → `Curves.easeInOutCubicEmphasized`
- Hover/color change → `Curves.ease`
- Constant motion (progress, marquee) → `Curves.linear` (the only place linear is allowed)

Never `easeIn` for entrances (delays the moment the user watches hardest — feels sluggish at any duration). No `bounceOut`/`elasticOut` on UI chrome; bounce is for playful drag-release moments only, and subtle.

## 4 · How fast?

This is the canonical duration table for the whole skill — other files link here, never restate.

| Element | Duration |
|---|---|
| Press feedback | 100–160ms |
| In-place state change (toggle, chip, selection, hover) | 150–250ms, hard cap 300ms |
| Container/dialog/sheet enter | 250–400ms (decelerate) |
| Full-screen navigation | 300–500ms |
| Exits | 50–75% of the matching enter (accelerate) |
| Onboarding/celebration | may run longer |

The 300ms cap applies to **in-place UI state changes**; container enters and navigation legitimately run longer. Utility register: keep in-place motion at the fast end (150–250ms) — sheets/dialogs/navigation keep the standard rows above. **Asymmetric timing is a signature of craft:** slow where the user is deciding, fast where the system is responding. Perceived performance is real: a fast-spinning indicator makes the same load feel shorter; a 180ms sheet feels snappier than a 400ms one.

## The toolbox, cheapest first

**Implicit widgets (80% of needs):** `AnimatedContainer`, `AnimatedOpacity`, `AnimatedScale`, `AnimatedSwitcher`, `AnimatedSize`, `AnimatedDefaultTextStyle`, `TweenAnimationBuilder`. Any value that changes with state animates implicitly instead of snapping.

```dart
AnimatedContainer(
  duration: Motion.base,
  curve: Easing.emphasizedDecelerate,
  decoration: BoxDecoration(
    color: selected ? scheme.secondaryContainer : scheme.surfaceContainerLow,
    borderRadius: Radii.card,
  ),
  child: child,
)
```

**`AnimatedSwitcher`** for content swaps (loading → content, value changes). Fade + tiny slide reads better than bare fade:

```dart
AnimatedSwitcher(
  duration: Motion.base,
  switchInCurve: Easing.emphasizedDecelerate,
  transitionBuilder: (child, anim) => FadeTransition(
    opacity: anim,
    child: SlideTransition(
      position: Tween(begin: const Offset(0, .04), end: Offset.zero).animate(anim),
      child: child,
    ),
  ),
  child: KeyedSubtree(key: ValueKey(stateId), child: body),
)
```

**Never animate from nothing:** entrances start at scale ≥ 0.9 or offset a few px with opacity — not `scale: 0`. Nothing in the real world appears from nothing.

**`flutter_animate`** for choreography — chainable, with stagger built in:

```dart
children.animate(interval: 50.ms)
  .fadeIn(duration: 300.ms, curve: Curves.easeOutCubic)
  .slideY(begin: .06, end: 0);
```

Stagger: 30–80ms between items, short lists only, never blocking interaction, total ≤ 500ms.

## Navigation transitions

- **`animations` package (first reach):** `OpenContainer` (list item → detail container transform — instant premium), `SharedAxisTransition` (x: siblings, y: steps/wizards, z: parent→child), `FadeThroughTransition` (bottom-nav tab switches).
- Set the vocabulary **app-wide once** via the theme, not per-route:

```dart
ThemeData(pageTransitionsTheme: const PageTransitionsTheme(builders: {
  TargetPlatform.android: SharedAxisPageTransitionsBuilder(
    transitionType: SharedAxisTransitionType.horizontal),
  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(), // keep back-swipe
}))
```

- **`Hero`** for shared elements (stable tags: `'item-${id}'`); `precacheImage` the destination image before flight (flicker mid-flight is the tell); `flightShuttleBuilder` when text style or shape changes between screens; `createRectTween: MaterialRectArcTween` for curved flight paths.
- Custom `PageRouteBuilder` when the app has a signature transition — define once, use app-wide.
- **Never replace the platform default with something worse:** iOS keeps its slide-with-parallax and edge-swipe; a custom transition that kills back-swipe is a shipped defect (platform.md).

## Springs & gestures

Springs settle by physics, not duration — right for anything draggable, interruptible, or velocity-carrying:

- Drag-release (sheet dismiss, swipe cards): project momentum; a fast flick dismisses regardless of distance.
- Interrupted animations continue from current value and velocity — never restart from zero. `AnimationController.animateWith(SpringSimulation(...))` or `SpringDescription.withDampingRatio(mass: 1, stiffness: 500, ratio: 1.0)` (ratio 1.0 = no bounce for most UI; 0.8 for playful moments).
- Boundaries get friction/rubber-banding, not walls.

## Micro-interactions

- Haptics accompany *physical metaphors*, never decoration: `HapticFeedback.selectionClick()` on pickers/snap points, `.lightImpact()` on confirm/toggle-on, `.mediumImpact()` on drag-drop landing. Overuse causes fatigue.
- Value changes roll (`AnimatedSwitcher` slide) rather than snap; toggles animate thumb and track together; icons morph (`AnimatedIcon`, or Rive for signature moments).
- One rehearsed entrance choreography on a hero screen (expressive register) beats micro-motion sprinkled everywhere.

## Reduced motion & discipline

- `MediaQuery.disableAnimationsOf(context)` → collapse movement to crossfade/instant; keep opacity/color that aids comprehension. Fewer and gentler, not zero.
- Every reveal enhances an already-visible default — never gate content visibility on an animation firing.
- Don't animate everything at once; motion guides the eye to *one* change.
- Debug like a craftsperson: run it at 5× duration (`timeDilation = 5.0`), watch for two-distinct-objects crossfades, wrong origins, out-of-sync properties. Review with fresh eyes the next day.

**NEVER:** linear curves on UI; uniform 300ms for everything; blocking input during decoration; `Opacity` widget in an animation (use `FadeTransition`); animating layout properties when a transform does it; motion added because the dial says high while the screen's purpose says calm.
