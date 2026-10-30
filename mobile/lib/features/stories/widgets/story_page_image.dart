import 'package:flutter/material.dart';

/// The picture of a story page, filling the whole screen.
class StoryPageImage extends StatelessWidget {
  const StoryPageImage({
    super.key,
    required this.imagePath,
    required this.fallbackColor,
  });

  final String imagePath;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return ColoredBox(
          color: fallbackColor,
          child: const Center(child: Icon(Icons.image_not_supported_outlined)),
        );
      },
    );
  }
}
