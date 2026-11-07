import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_images.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import 'game_button.dart';
import 'game_icon.dart';

/// What is shown when the round is over, in any game.
///
/// A null [onPlayAgain] is for the child, who plays only once a day: there is
/// no "play again" button and no "try again?" question.
/// The [compact] form is smaller, so it can sit under the board without
/// hiding it.
class EndPanel extends StatelessWidget {
  const EndPanel({
    super.key,
    required this.won,
    required this.onExit,
    this.onPlayAgain,
    this.compact = false,
  });

  final bool won;
  final VoidCallback onExit;
  final VoidCallback? onPlayAgain;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return compact ? _buildCompact() : _buildFull();
  }

  String get _title => won ? GamesTexts.won : GamesTexts.timeUp;

  // The line under the time-up title: a question for the parent's try-out,
  // and a promise for the child.
  String get _subtitle => onPlayAgain == null
      ? GamesTexts.timeUpTomorrow
      : GamesTexts.tryAgainQuestion;

  Widget _buildButtons({required bool big}) {
    final playAgain = onPlayAgain;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        if (playAgain != null)
          GameButton(
            won ? GamesTexts.playAgain : GamesTexts.tryAgain,
            primary: true,
            big: big,
            onTap: playAgain,
          ),
        GameButton(
          GamesTexts.exit,
          primary: playAgain == null,
          big: big,
          onTap: onExit,
        ),
      ],
    );
  }

  Widget _buildFull() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (won)
          const Icon(Icons.star_rounded, size: 78, color: GamesColors.star)
        else
          const GameIcon(GamesImages.alarm, size: 64),
        Text(
          _title,
          textAlign: TextAlign.center,
          style: GamesStyles.display(size: 24),
        ),
        if (!won)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _subtitle,
              style: GamesStyles.body(color: GamesColors.inkSoft),
            ),
          ),
        const SizedBox(height: 14),
        _buildButtons(big: true),
      ],
    );
  }

  Widget _buildCompact() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (won)
              const Icon(Icons.star_rounded, size: 38, color: GamesColors.star)
            else
              const GameIcon(GamesImages.alarm, size: 34),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: GamesStyles.display(size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildButtons(big: false),
      ],
    );
  }
}
