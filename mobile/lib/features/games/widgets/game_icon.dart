import 'package:flutter/material.dart';

/// A small picture used as an icon. It is only decoration, so screen readers
/// skip it, and if the file is missing it leaves an empty space.
class GameIcon extends StatelessWidget {
  const GameIcon(this.path, {super.key, required this.size});

  final String path;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox.square(dimension: size);
      },
    );
  }
}
