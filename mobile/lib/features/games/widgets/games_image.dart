import 'package:flutter/material.dart';

import '../games_colors.dart';

/// A picture from the assets. If the file is missing it shows a plain
/// placeholder, so one missing picture never breaks the whole page.
class GamesImage extends StatelessWidget {
  const GamesImage(this.path, {super.key, this.fit = BoxFit.cover});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const ColoredBox(
          color: GamesColors.surface,
          child: Center(
            child: Icon(
              Icons.image_outlined,
              color: GamesColors.line,
              size: 40,
            ),
          ),
        );
      },
    );
  }
}
