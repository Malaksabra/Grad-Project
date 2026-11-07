import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_styles.dart';
import 'games_page.dart';
import 'games_panel.dart';
import 'guide_row.dart';
import 'time_bar.dart';

/// The page every game uses while it is played: the top bar, the teddy guide,
/// and one panel that takes all the rest of the screen. The [board] fills the
/// space inside the panel, and the [result] covers it when the round is over.
class GamePlayLayout extends StatelessWidget {
  const GamePlayLayout({
    super.key,
    required this.pageTitle,
    required this.guide,
    required this.heading,
    required this.board,
    required this.message,
    this.trailing,
    this.timeFraction,
    this.result,
    this.resultCoversBoard = true,
  });

  /// The title in the top bar.
  final String pageTitle;

  /// What the teddy says.
  final String guide;

  /// The title inside the panel.
  final String heading;

  /// The game itself. It gets all the free space of the panel.
  final Widget board;

  /// The short line under the board. Hidden when the [result] is shown.
  final String message;

  /// At the end of the heading row: the time, or the round number.
  final Widget? trailing;

  /// The time bar, from 1.0 to 0.0. No bar if null.
  final double? timeFraction;

  /// The end panel, shown when the round is over.
  final Widget? result;

  /// If true the [result] covers the board. If false it takes the place of
  /// the [message] under the board, so the board stays fully visible (for
  /// example to show the finished puzzle).
  final bool resultCoversBoard;

  @override
  Widget build(BuildContext context) {
    final fraction = timeFraction;
    final end = result;

    return GamesPage(
      title: pageTitle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GuideRow(text: guide),
            Expanded(
              child: GamesPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            heading,
                            style: GamesStyles.display(size: 19.2),
                          ),
                        ),
                        if (trailing != null) trailing!,
                      ],
                    ),
                    if (fraction != null) ...[
                      const SizedBox(height: 10),
                      TimeBar(value: fraction),
                    ],
                    const SizedBox(height: 12),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          board,
                          if (end != null && resultCoversBoard)
                            ColoredBox(
                              color: GamesColors.overlay,
                              child: Center(
                                child: SingleChildScrollView(child: end),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (end != null && !resultCoversBoard)
                      end
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 27),
                        child: Text(
                          end == null ? message : '',
                          style: GamesStyles.body(color: GamesColors.inkSoft),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
