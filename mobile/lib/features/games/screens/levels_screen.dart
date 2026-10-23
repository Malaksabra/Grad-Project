import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import '../logic/games_settings.dart';
import '../models/game_level.dart';
import '../widgets/games_page.dart';
import '../widgets/games_panel.dart';
import '../widgets/guide_row.dart';
import '../widgets/thick_box.dart';
import '../widgets/time_label.dart';

/// The levels page. The parent can try any level, and choose the one the
/// child will find ready.
class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key, required this.settings, required this.onPlay});

  final GamesSettings settings;

  /// Called with the level number (0, 1 or 2) when the parent wants to try it.
  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context) {
    return GamesPage(
      title: GamesTexts.memoryCardsTitle,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const GuideRow(text: GamesTexts.levelsGuide),
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
                      for (var i = 0; i < GameLevel.all.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _LevelOption(
                            index: i,
                            selected: settings.selectedLevel == i,
                            onPlay: () => onPlay(i),
                            onSelect: () => settings.select(i),
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

class _LevelOption extends StatelessWidget {
  const _LevelOption({
    required this.index,
    required this.selected,
    required this.onPlay,
    required this.onSelect,
  });

  final int index;
  final bool selected;
  final VoidCallback onPlay;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final level = GameLevel.all[index];
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
                            Text(
                              '${GamesTexts.cardsCount(level.cardCount)}'
                              '${GamesTexts.summarySeparator}',
                              style: summaryStyle,
                            ),
                            TimeLabel(
                              seconds: level.seconds,
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
