import 'package:flutter/widgets.dart';

/// A ListWheelScrollView that allows negative perspective values.
/// Positive: items curve away from viewer at edges (convex)
/// Negative: items curve toward viewer at edges (concave)
class InvertedListWheelScrollView extends StatefulWidget {
  final FixedExtentScrollController? controller;
  final double itemExtent;
  final double diameterRatio;
  final double perspective;
  final double offAxisFraction;
  final ScrollPhysics? physics;
  final Clip clipBehavior;
  final ListWheelChildDelegate childDelegate;

  const InvertedListWheelScrollView.useDelegate({
    super.key,
    this.controller,
    required this.itemExtent,
    this.diameterRatio = 2.0,
    this.perspective = 0.003,
    this.offAxisFraction = 0.0,
    this.physics,
    this.clipBehavior = Clip.hardEdge,
    required this.childDelegate,
  });

  @override
  State<InvertedListWheelScrollView> createState() =>
      _InvertedListWheelScrollViewState();
}

class _InvertedListWheelScrollViewState
    extends State<InvertedListWheelScrollView> {
  late FixedExtentScrollController _controller;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? FixedExtentScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(InvertedListWheelScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != _controller) {
      _controller.removeListener(_onScroll);
      _controller = widget.controller!;
      _controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _controller.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isNegative = widget.perspective < 0;
    final absPerspective = widget.perspective.abs().clamp(0.0001, 0.01);

    if (!isNegative) {
      // Positive perspective - use normal ListWheelScrollView
      return ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: widget.itemExtent,
        diameterRatio: widget.diameterRatio,
        perspective: absPerspective,
        offAxisFraction: widget.offAxisFraction,
        physics: widget.physics,
        clipBehavior: widget.clipBehavior,
        childDelegate: widget.childDelegate,
      );
    }

    // Negative perspective - apply inverted transforms per child
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: widget.itemExtent,
      diameterRatio: widget.diameterRatio,
      perspective: 0.000001, // Minimal base perspective
      offAxisFraction: widget.offAxisFraction,
      physics: widget.physics,
      clipBehavior: widget.clipBehavior,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.childDelegate.estimatedChildCount,
        builder: (context, index) {
          final child = widget.childDelegate.build(context, index);
          if (child == null) return null;

          // Calculate distance from center
          final centerIndex = _scrollOffset / widget.itemExtent;
          final distanceFromCenter = (index - centerIndex).clamp(-3.0, 3.0);

          return _buildInvertedChild(child, distanceFromCenter, absPerspective);
        },
      ),
    );
  }

  Widget _buildInvertedChild(
    Widget child,
    double distanceFromCenter,
    double perspective,
  ) {
    final absDistance = distanceFromCenter.abs();

    // Scale multiplier based on perspective intensity
    final intensity = perspective * 150;

    // Center items are smaller (further), edge items are larger (closer)
    final scale = 1.0 + (absDistance * intensity * 0.5);

    // Z translation: edges come forward
    final zTranslation = absDistance * intensity * 50;

    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.000001) // Small perspective for 3D effect
            ..translate(0.0, 0.0, zTranslation)
            ..scale(scale.clamp(0.9, 1.3)),
      child: child,
    );
  }
}
