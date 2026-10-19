import 'package:flutter/material.dart';

/// A white circle that frames an image.
class IconBubble extends StatelessWidget {
  const IconBubble({super.key, required this.child});

  final Widget child;

  static const double _size = 64;
  static const double _padding = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      padding: const EdgeInsets.all(_padding),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
