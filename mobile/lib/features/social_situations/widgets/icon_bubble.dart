import 'package:flutter/material.dart';

/// A white circle that frames an image.
class IconBubble extends StatelessWidget {
  const IconBubble({super.key, required this.child, this.size = 64});

  final Widget child;
  final double size;

  static const double _paddingRatio = 0.22;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * _paddingRatio),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
