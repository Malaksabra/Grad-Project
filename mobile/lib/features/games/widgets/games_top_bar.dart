import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import 'thick_box.dart';

/// The top bar of the pages inside the games section: a back button and a
/// centered title.
class GamesTopBar extends StatelessWidget {
  const GamesTopBar({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  static const double _buttonSize = 46;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: GamesColors.line)),
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: GamesTexts.back,
            excludeSemantics: true,
            child: GestureDetector(
              onTap: onBack,
              child: ThickBox(
                fill: Colors.white,
                border: GamesColors.line,
                radius: BorderRadius.circular(23),
                bottom: 4,
                constraints: BoxConstraints.tight(
                  const Size(_buttonSize, _buttonSize),
                ),
                child: const Center(
                  // The app is right-to-left, so "back" points to the right.
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: GamesColors.ink,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GamesStyles.display(size: 20),
            ),
          ),
          // Keeps the title in the middle, as wide as the back button.
          const SizedBox(width: _buttonSize),
        ],
      ),
    );
  }
}
