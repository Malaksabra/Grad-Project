import 'package:flutter/material.dart';

/// A white circle that frames an icon.
class IconBubble extends StatelessWidget {
  const IconBubble({super.key, required this.color, required this.child});

  final Color color;
  final Widget child;

  static const double _size = 72;
  static const double _iconSize = 36;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconTheme(
        data: IconThemeData(color: color, size: _iconSize),
        child: child,
      ),
    );
  }
}
