import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A rounded box with a thick colored edge, thickest at the bottom.
/// Like a button that stands a little above the page.
class ThickBox extends StatelessWidget {
  const ThickBox({
    super.key,
    required this.fill,
    required this.border,
    required this.radius,
    this.top = 2,
    this.side = 2,
    this.bottom = 5,
    this.padding = EdgeInsets.zero,
    this.constraints,
    this.child,
  });

  final Color fill;
  final Color border;
  final BorderRadius radius;

  /// The thickness of the edge on each side.
  final double top;
  final double side;
  final double bottom;

  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;
  final Widget? child;

  // The inner box has smaller corners, so the edge looks even.
  static BorderRadius _shrink(BorderRadius radius, double by) {
    Radius smaller(Radius r) => Radius.circular(math.max(0, r.x - by));
    return BorderRadius.only(
      topLeft: smaller(radius.topLeft),
      topRight: smaller(radius.topRight),
      bottomLeft: smaller(radius.bottomLeft),
      bottomRight: smaller(radius.bottomRight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration: BoxDecoration(color: border, borderRadius: radius),
      padding: EdgeInsets.fromLTRB(side, top, side, bottom),
      child: Container(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: _shrink(radius, side),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
