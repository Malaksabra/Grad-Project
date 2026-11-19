import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import 'game_button.dart';
import 'games_page.dart';

/// What the child sees after finishing the game of the day: no game and no
/// choices, only a happy message. The game opens again the next day.
class ChildDoneView extends StatelessWidget {
  const ChildDoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return GamesPage(
      title: GamesTexts.sectionTitle,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                size: 110,
                color: GamesColors.star,
              ),
              const SizedBox(height: 8),
              Text(
                GamesTexts.childDoneTitle,
                textAlign: TextAlign.center,
                style: GamesStyles.display(size: 26),
              ),
              const SizedBox(height: 6),
              Text(
                GamesTexts.childDoneSubtitle,
                textAlign: TextAlign.center,
                style: GamesStyles.body(color: GamesColors.inkSoft),
              ),
              const SizedBox(height: 20),
              GameButton(
                GamesTexts.exit,
                primary: true,
                big: true,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
