import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import '../logic/day_key.dart';
import '../logic/games_settings.dart';
import '../models/game_kind.dart';
import '../widgets/games_page.dart';
import '../widgets/games_panel.dart';
import '../widgets/guide_row.dart';
import '../widgets/thick_box.dart';
import '../widgets/time_label.dart';

/// The levels page of one game. The parent can try any level, and choose the
/// game and level the child will find ready.
class LevelsScreen extends StatelessWidget {
  const LevelsScreen({
    super.key,
    required this.game,
    required this.settings,
    required this.onPlay,
    this.now,
  });

  final GameKind game;
  final GamesSettings settings;

  /// The current time. For tests only: lets a test choose the day.
  final DateTime Function()? now;

  /// Called with the level number (0, 1 or 2) when the parent wants to try it.
  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context) {
    return GamesPage(
      title: game.title,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const GuideRow(text: GamesTexts.levelsGuide),
                if (settings.isFinishedOn(dayKey((now ?? DateTime.now)())))
                  const _FinishedNotice(),
                GamesPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        GamesTexts.levelsTitle,
                        style: GamesStyles.display(size: 19.2),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        GamesTexts.levelsHelp,
                        style: GamesStyles.body(
                          size: 14.7,
                          color: GamesColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (var i = 0; i < game.levelCount; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _LevelOption(
                            summary: game.levelSummary(i),
                            index: i,
                            selected:
                                settings.selectedGame == game &&
                                settings.selectedLevel == i,
                            onPlay: () => onPlay(i),
                            onSelect: () => settings.select(game, i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Tells the parents that the child already played today.
class _FinishedNotice extends StatelessWidget {
  const _FinishedNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ThickBox(
        fill: GamesColors.background,
        border: GamesColors.edge,
        radius: BorderRadius.circular(24),
        bottom: 4,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.star_rounded, size: 34, color: GamesColors.star),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                GamesTexts.finishedNotice,
                style: GamesStyles.body(size: 15.2, color: GamesColors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelOption extends StatelessWidget {
  const _LevelOption({
    required this.summary,
    required this.index,
    required this.selected,
    required this.onPlay,
    required this.onSelect,
  });

  final LevelSummary summary;
  final int index;
  final bool selected;
  final VoidCallback onPlay;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final seconds = summary.seconds;
    final ink = selected ? GamesColors.text : GamesColors.ink;
    final summaryStyle = GamesStyles.body(
      size: 14.7,
      color: selected ? GamesColors.text : GamesColors.inkSoft,
    );

    return Semantics(
      button: true,
      label: GamesTexts.tryLevelLabel(index),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onPlay,
        child: ThickBox(
          fill: selected ? GamesColors.background : Colors.white,
          border: selected ? GamesColors.edge : GamesColors.line,
          radius: BorderRadius.circular(30),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: selected ? GamesColors.edge : GamesColors.line,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: GamesStyles.display(size: 26, color: ink),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GamesTexts.levelTitle(index),
                          style: GamesStyles.body(
                            size: 17.6,
                            weight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // A game without a clock shows only the count.
                            Text(
                              seconds == null
                                  ? summary.countText
                                  : '${summary.countText}'
                                        '${GamesTexts.summarySeparator}',
                              style: summaryStyle,
                            ),
                            if (seconds != null)
                              TimeLabel(
                                seconds: seconds,
                                style: summaryStyle,
                                iconSize: 18,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.play_circle_fill_rounded,
                    size: 40,
                    color: selected ? GamesColors.text : GamesColors.edge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ChooseButton(index: index, selected: selected, onTap: onSelect),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChooseButton extends StatelessWidget {
  const _ChooseButton({
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: GamesTexts.chooseLevelLabel(index),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: ThickBox(
          fill: selected ? GamesColors.text : Colors.white,
          border: selected ? GamesColors.text : GamesColors.edge,
          radius: BorderRadius.circular(999),
          bottom: 4,
          constraints: const BoxConstraints(minHeight: 46),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                const Icon(Icons.check_rounded, size: 20, color: Colors.white),
                const SizedBox(width: 6),
              ],
              Text(
                selected
                    ? GamesTexts.chosenForChild
                    : GamesTexts.chooseForChild,
                style: GamesStyles.body(
                  size: 15.2,
                  weight: FontWeight.w500,
                  color: selected ? Colors.white : GamesColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
