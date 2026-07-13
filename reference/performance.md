# Performance as UX

Jank is a design defect. A beautiful screen that stutters reads cheaper than a plain one that glides. Budget: 16ms/frame at 60Hz, ~8ms build + ~8ms raster; aim for half that on 120Hz devices.

Impeller is the default renderer (iOS, and Android API 29+) — classic shader-compilation jank is gone; remaining jank is almost always *your* build/raster cost.

## Rebuild discipline

- `const` everywhere the analyzer allows; enforce `prefer_const_constructors` in `analysis_options.yaml`.
- Extract widgets as **classes**, not helper methods — classes get their own element, support const, and rebuild independently.
- Push `setState`/watch scope to the smallest subtree. A `TextField` listener rebuilding the whole screen is a classic.
- Pass static subtrees as `child:` to `AnimatedBuilder`/`ListenableBuilder` so they build once:

```dart
AnimatedBuilder(
  animation: controller,
  builder: (_, child) => Transform.rotate(angle: controller.value * tau, child: child),
  child: const ExpensiveStaticChild(), // built once, not per frame
)
```

- Scoped `MediaQuery` accessors (`MediaQuery.sizeOf`, `.paddingOf`, `.textScalerOf`) — the bare `.of` rebuilds on every inset/keyboard change.

## Lists & scrolling

- `ListView.builder` / `GridView.builder` / slivers past ~20 items — never a mapped `Column` or non-builder list.
- Fixed row heights: `itemExtent` or `prototypeItem` (cheap scroll math).
- Never `shrinkWrap: true` inside another scrollable — compose with `CustomScrollView` + slivers.
- Heavy rows: keep build cheap; defer images (below) and expensive computation off the row build.

## Images

- Decode at display size: `Image.network(url, cacheWidth: logicalWidth * dpr)` or `ResizeImage` — a full-res photo decoded for a 64px avatar wastes hundreds of MB.
- Network image caching: `cached_network_image` is the household name but effectively unmaintained (known leak issues) — check its state before adopting; alternatives are the `cached_network_image_ce` fork or plain `Image.network` + `frameBuilder` fades with server-side sizing. `precacheImage` for hero/next-screen images either way.
- Placeholders that hold layout (skeleton/BlurHash/solid `surfaceContainerHighest`) — pop-in and layout shift are visible defects.
- Prefer WebP/AVIF assets; provide 1x/2x/3x variants.

## Expensive operations (know the list)

- `saveLayer()` triggers: `Opacity` over complex subtrees (→ `AnimatedOpacity`/`FadeTransition` on the leaf), `ShaderMask`, `ColorFilter`, `Clip.antiAliasWithSaveLayer`. Check DevTools for unexpected layers.
- Animated clipping → pre-clip or animate a transform inside a static clip.
- `BackdropFilter` blur is per-frame GPU cost — small regions, never over scrolling content.
- Intrinsic layout (`IntrinsicHeight/Width`) in lists — replace with fixed constraints.
- `RepaintBoundary` around isolated animating regions (spinner over static content) so repaints don't spread; don't wrap things that repaint every frame anyway.

## Perceived performance

- Optimistic UI for reversible actions (favorite, reorder) — commit visually, reconcile in background; never for payments.
- Skeletons make waits feel ~2× shorter than spinners; nothing at all under 300ms.
- Ticker providers (`SingleTickerProviderStateMixin` for one controller, `TickerProviderStateMixin` for several) respect `TickerMode`, so tickers mute in inactive routes/tabs — don't hand-roll visibility pausing.
- Startup: defer non-critical init past first frame; splash-to-content without a blank flash.

## Verify

Profile mode on a real low-end Android device — debug-mode and simulator judgments are fiction. DevTools: Performance overlay for frame spikes, rebuild stats for storms, memory view for image bloat. Measure before and after; don't optimize what isn't slow.

**NEVER:** `setState` in scroll listeners per-frame (use `NotificationListener` throttling or positional math); rebuilding a `ListView` item tree from a parent watch when only one row changed; blocking the UI isolate with JSON parsing (`compute()` it); shipping without one profile-mode pass on the critical path.
