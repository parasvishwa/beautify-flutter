# Signature moments — the extraordinary layer

What separates award-tier apps from merely polished ones is **one signature interaction, polished obsessively** — not many mediocre effects. The 2025 award winners (Pokémon TCG Pocket's pack-tearing, Balatro's card physics, CapWords' label-the-world) share tactility: every touch produces coordinated motion + haptic + sound. This file is the toolbox for that layer.

**The one-hero-effect rule:** shader background OR glass panels OR 3D card OR choreographed entrance — one per screen, never stacked. This layer sits on top of a finished foundation; a shader on an untested layout is decoration on a defect. Gate everything here by `MOTION_INTENSITY ≥ 7` or an explicit user ask.

## Fragment shaders (Impeller-era: build-time compiled, no jank)

```yaml
flutter:
  shaders: [shaders/grain.frag]
```

```dart
final program = await FragmentProgram.fromAsset('shaders/grain.frag');
final shader = program.fragmentShader()   // create ONCE, reuse
  ..setFloat(0, time);                    // float-slot indices flatten: a vec2 = 2 slots
canvas.drawRect(rect, Paint()..shader = shader);
```

GLSL side: `#include <flutter/runtime_effect.glsl>`, `FlutterFragCoord().xy` (not `gl_FragCoord`), `out vec4 fragColor`. Limits: only `sampler2D`, 2-arg `texture()`, no UBOs, no booleans. ShaderToy ports: flip Y (`uv.y = 1.0 - uv.y`), map `iTime`/`iResolution` to your own uniforms.

Premium uses, cheapest first:
- **Film grain** at 3–6% opacity over a hero surface — the single cheapest "expensive feel" trick.
- **Shimmer/sheen sweeps** (or `flutter_animate`'s built-in `ShimmerEffect`).
- **Animated mesh-gradient backgrounds** — `mesh_gradient` package (`AnimatedMeshGradient` easy mode) — the signature premium backdrop of the era.
- Touch ripple/refraction as a **backdrop**: `BackdropFilter(filter: ImageFilter.shader(...))` — Impeller only.
- Dissolve/glitch transitions: `flutter_shaders`' `AnimatedSampler` captures any widget subtree as a texture for your shader.

Rules: mutate uniforms per frame, never recreate the shader; drive repaints with `CustomPainter(repaint: animation)`, not `setState`; no dynamic-length loops in GLSL; `RepaintBoundary` around static shader output.

## Rive & Lottie

- **Rive** (0.14+, native C++ runtime): *stateful* animation — nav icons reacting to selection, loaders with idle→loading→success state machines, data-bound gauges/characters (`controller.dataBind`, `vmi.number('progress')!.value = 0.7`, `vmi.trigger('confetti')!.trigger()`). Files run 10–15× smaller than equivalent Lottie.
- **Lottie**: fire-and-forget decorative illustration (onboarding art, empty states) when the asset exists on LottieFiles. No real interactivity.
- **Decision rule:** if it animates *real UI*, animate in code (implicit widgets / flutter_animate); if it's an *illustration that reacts*, Rive; if it's a *static-ish illustration that plays*, Lottie. Don't stack multiple Lottie compositions with blurs/mattes in one screen.

## CustomPainter — bespoke identity elements

Where stock widgets end: charts with gradient fills, arc progress with `SweepGradient` + `StrokeCap.round`, ticket-notch cards (`Path.combine(PathOperation.difference, …)`), hand-drawn underlines, confetti.

- **Draw-along-path:** `path.computeMetrics()` → `metric.extractPath(0, metric.length * t)` — line-drawing reveals, progress along arbitrary shapes.
- **Physical shadows for odd shapes:** `canvas.drawShadow(path, color, elevation, false)` beats `BoxShadow` off-rectangle.
- **Glow/additive:** `MaskFilter.blur` on a stroke Paint; `saveLayer` + `BlendMode.plus` for particles — budget saveLayers (≤ 2–3 per frame).
- **Particles:** batch via `drawPoints`/`drawRawAtlas`/`drawVertices`, never N `drawCircle` calls; the `confetti` package for celebrations.
- Honest `shouldRepaint`; `repaint:` listenable constructor; allocate `Paint`/`Path` outside `paint()`; check `Directionality` for RTL-sensitive geometry.

## 3D depth — Matrix4, no packages needed

```dart
Transform(
  alignment: FractionalOffset.center,
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001)              // perspective (0.0005–0.002)
    ..rotateX(tilt.dy)..rotateY(-tilt.dx), // pointer-mapped, cap ±0.15 rad
  child: heroCard,
)
```

Pointer-tracking tilt on **a single hero card**, spring-back on release, a gradient highlight translated by the same tilt vector, a shadow that shifts opposite — premium. Tilting every list item — gimmick. 3D flips: `rotateY` 0→π with a midpoint child swap. `flutter_gpu`/`flutter_scene` remain preview-channel; not for production UI chrome yet.

## Glass, done honestly

- Primitive: `ClipRRect → BackdropFilter(ImageFilter.blur(sigma 6–12)) → Container(white 8% fill, 1px white 15–20% border, subtle sheen gradient)`. **Always clip** — an unclipped BackdropFilter blurs the whole scene.
- Costs a saveLayer each: few per screen, never nested, never inside scrolling list items, never animate sigma per-frame. Non-blur fallback (semi-opaque fill) for low-end devices and reduced-transparency.
- True Liquid-Glass refraction and the availability rules: [platform.md](platform.md).

## Gesture-scrubbed choreography (the Wonderous pattern)

The most transferable technique from the reference app: expose **one 0–1 value from the live gesture** and multiply it into many properties across layers. Nothing fires-and-forgets; everything tracks the finger.

```dart
// A ValueNotifier<double> swipeAmt (0..1) driven by drag distance, then:
midground:  zoom = .05 * swipeAmt          // layers move at different rates =
foreground: zoom = .40 * swipeAmt          // parallax depth
gradient:   opacity = .5 + (isPointerDown ? .05 : 0) + swipeAmt * .20
```

Details that make it feel alive: pointer-down alone (before any movement) already shifts the UI ~5%; release springs back with the gesture's velocity; when the gesture commits to navigation, **freeze the scrubbed state during the route transition** and stagger elements back in (~300ms delay, per-element controllers) on return — transitions feel continuous, never reset.

Multi-layer parallax `PageView`: background/midground/foreground as separate `Stack` layers keyed to the page, only the midground is the real `PageView.builder`; infinite paging via `initialPage: n * 9999` + `index % n`; `HapticFeedback.lightImpact()` in `onPageChanged`.

## Ambient idle motion

Screens never sit dead — but idle motion must be barely-there: a slow drifting background element, or the **teaser loop** for a tappable discovery (long idle delay, short burst, settle):

```dart
collectible.animate(onPlay: (c) => c.repeat())
  .shimmer(delay: 4000.ms, duration: 1800.ms)
  .shake(hz: 4, curve: Curves.easeInOutCubic)
  .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 600.ms)
  .then(delay: 600.ms)
  .scale(end: const Offset(1 / 1.1, 1 / 1.1));
```

4s of silence, 2s of invitation. Continuous fidgeting is noise; periodic invitation is craft. Respect `disableAnimations` here first.

## Multisensory choreography (the award-winner pattern)

One signature interaction = motion + haptic + sound firing on the **same frame**, telling the same story:

- Motion: spring-driven, inherits gesture velocity, interruptible (motion.md).
- Haptic: `haptic_feedback` package for iOS-preset fidelity cross-platform (success/warning/error/rigid/soft; graceful Android composition fallbacks) — or SDK `HapticFeedback` for the basics. Intensity maps to importance; system presets for standard moments, custom patterns only for the brand's one signature gesture.
- Sound: far rarer than haptics — send/success/capture moments only, always paired with the haptic, always respecting silent mode. Silence is the default.

Anatomy of a signature gesture (e.g. pull-to-reveal, card-tear, slide-to-confirm): 1:1 finger tracking while dragging → threshold crossing gets a `selectionClick` + visual state change → release either springs back (fast, accelerate) or commits with impact haptic + settle animation + optional sound. Slow where deciding, instant where confirming.

## Where to study

Wonderous (gskinner, open source) — parallax, custom app bars, shader effects, art direction with accessibility intact. `flutter_vignettes` (gskinner) — premium micro-interaction patterns. Both are reference implementations, not copy sources: extract the *technique*, re-derive the *aesthetic* from your own Design Read.

**NEVER:** two hero effects on one screen; a shader/glass/3D layer before the foundation passes pre-flight; effects that fight scrolling; uninterruptible flourishes; haptics on every tap; celebration animations the user will see 50×/day.
