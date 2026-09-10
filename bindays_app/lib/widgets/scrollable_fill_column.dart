// External Imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A drop-in replacement for a full-height [Column] that keeps the existing
/// "scale to fit" behaviour but scrolls as a last resort.
///
/// The column fills the viewport, so [Spacer]/[Flexible] children (such as the
/// illustration) distribute and shrink exactly as they do today. When the
/// content fits, the page does not scroll at all: [ClampingScrollPhysics] has
/// nothing to scroll (zero extent) so it stays fixed, with no bounce or glow.
/// Only when the content can no longer fit even after the flexible children have
/// collapsed (for example with extremely large system font sizes on a small
/// device) does the page become scrollable instead of overflowing, keeping
/// every action reachable.
///
/// Flexible children are elastic by definition, so they must never force the
/// page to scroll. Their natural height would otherwise inflate the measured
/// height via [IntrinsicHeight] (a loaded illustration has a real size), so this
/// widget neutralises every [Flexible]/[Expanded] child's intrinsic height
/// automatically. Callers just pass a normal `Flexible(child: Image(...))`.
class ScrollableFillColumn extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  const ScrollableFillColumn({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
  });

  /// Rewrites each [Flexible]/[Expanded] child so it reports a zero intrinsic
  /// height, keeping such children as pure "fill the leftover space" while their
  /// natural size no longer inflates the [IntrinsicHeight] measurement. Other
  /// children (and [Spacer], whose built child is already zero-height) are left
  /// untouched.
  List<Widget> _neutraliseFlexIntrinsics() {
    return [
      for (final child in children)
        if (child is Flexible)
          Flexible(
            key: child.key,
            flex: child.flex,
            fit: child.fit,
            child: _ZeroIntrinsicHeight(child: child.child),
          )
        else
          child,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScrollConfiguration(
          // Remove the overscroll glow so a page whose content fits shows no
          // scroll affordance at all.
          behavior: const _NoOverscrollBehavior(),
          child: SingleChildScrollView(
            // Clamping physics has zero extent when the content fits, so the
            // page will not scroll or bounce unless it actually overflows.
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              // IntrinsicHeight gives the column a bounded height equal to the
              // greater of the viewport and the content's natural height, so the
              // flexible children distribute space when it fits and the whole
              // column scrolls when it does not.
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment,
                  children: _neutraliseFlexIntrinsics(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Reports a zero intrinsic height while laying out and painting its child
/// normally. See [ScrollableFillColumn] for why flexible children need this.
class _ZeroIntrinsicHeight extends SingleChildRenderObjectWidget {
  const _ZeroIntrinsicHeight({required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderZeroIntrinsicHeight();
  }
}

class _RenderZeroIntrinsicHeight extends RenderProxyBox {
  @override
  double computeMinIntrinsicHeight(double width) => 0.0;

  @override
  double computeMaxIntrinsicHeight(double width) => 0.0;
}

/// A scroll behaviour that suppresses the overscroll indicator (the Android
/// stretch/glow), so pages that fit the viewport feel fixed rather than
/// scrollable.
class _NoOverscrollBehavior extends MaterialScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
