import 'package:flutter/material.dart';

import '../games_colors.dart';

/// The white panel with a faint purple border that holds the content of a
/// games page.
class GamesPanel extends StatelessWidget {
  const GamesPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GamesColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: GamesColors.panelBorder, width: 2),
      ),
      child: child,
    );
  }
}
