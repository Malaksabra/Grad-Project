import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_images.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import '../logic/puzzle_game.dart';
import '../models/puzzle_level.dart';
import '../widgets/end_panel.dart';
import '../widgets/filled_grid.dart';
import '../widgets/game_play_layout.dart';
import '../widgets/games_image.dart';
import '../widgets/time_label.dart';

/// The puzzle game page. The rules live in [PuzzleGame]. This screen owns the
/// real timer, picks the texts, and draws the pieces.
class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({
    super.key,
    required this.levelIndex,
    this.images = GamesImages.fruits,
    this.random,
    this.isForChild = false,
    this.onFinished,
  });

  /// The level number: 0, 1 or 2.
  final int levelIndex;

  /// The pictures the puzzle is made from. One of them is picked each round.
  final List<String> images;

  /// For tests only: makes the shuffle repeatable.
  final Random? random;

  /// True on the child's page: the child cannot play the round again.
  final bool isForChild;

  /// Called once when the round ends, by winning or when the time is up.
  final VoidCallback? onFinished;

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  late final PuzzleLevel _level;
  late final PuzzleGame _game;

  Timer? _clock;
  String _message = GamesTexts.puzzleMessageStart;
  bool _hasReportedEnd = false;

  @override
  void initState() {
    super.initState();
    _level = PuzzleLevel.all[widget.levelIndex];
    _game = PuzzleGame(
      images: widget.images,
      rows: _level.rows,
      columns: _level.columns,
      seconds: _level.seconds,
      random: widget.random,
    );
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void _startClock() {
    _clock = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(_game.tick);
      if (_game.status != PuzzleStatus.playing) {
        timer.cancel();
        _reportEnd();
      }
    });
  }

  void _reportEnd() {
    if (_hasReportedEnd || _game.status == PuzzleStatus.playing) return;
    _hasReportedEnd = true;
    widget.onFinished?.call();
  }

  void _onPieceTap(int position) {
    final outcome = _game.tap(position);
    if (outcome == PuzzleTapOutcome.ignored) return;

    // The clock starts with the first piece of the round.
    if (_clock == null) _startClock();

    setState(() {
      _message = switch (outcome) {
        PuzzleTapOutcome.selected => GamesTexts.puzzleMessageSecond,
        PuzzleTapOutcome.deselected => GamesTexts.puzzleMessageCancel,
        PuzzleTapOutcome.swapped => GamesTexts.puzzleMessageSwapped,
        PuzzleTapOutcome.solved => _message,
        PuzzleTapOutcome.ignored => _message,
      };
    });

    if (_game.status == PuzzleStatus.won) {
      _clock?.cancel();
      _reportEnd();
    }
  }

  void _newRound() {
    _clock?.cancel();
    _clock = null;
    _hasReportedEnd = false;
    setState(() {
      _game.restart();
      _message = GamesTexts.puzzleMessageStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GamePlayLayout(
      pageTitle: GamesTexts.levelTitle(widget.levelIndex),
      guide: GamesTexts.puzzleGuide,
      heading: GamesTexts.puzzleGameTitle,
      trailing: TimeLabel(
        seconds: _game.remainingSeconds,
        style: GamesStyles.display(size: 20, color: GamesColors.text),
        iconSize: 26,
      ),
      timeFraction: _game.remainingFraction,
      message: _message,
      // The picture must not be mirrored in the right-to-left app, so the
      // pieces are always laid from left to right.
      board: Directionality(
        textDirection: TextDirection.ltr,
        child: FilledGrid(
          columns: _game.columns,
          itemCount: _game.pieceCount,
          gap: 6,
          itemBuilder: (context, position) {
            final piece = _game.pieceAt(position);
            return _PuzzlePiece(
              key: ValueKey('piece_$position'),
              image: _game.image,
              row: piece ~/ _game.columns,
              column: piece % _game.columns,
              rows: _game.rows,
              columns: _game.columns,
              isSelected: _game.selectedPosition == position,
              onTap: () => _onPieceTap(position),
            );
          },
        ),
      ),
      // When the child wins, the finished picture stays fully visible and the
      // end panel sits under it. When the time is up, the panel covers it.
      resultCoversBoard: _game.status != PuzzleStatus.won,
      result: _game.status == PuzzleStatus.playing
          ? null
          : EndPanel(
              won: _game.status == PuzzleStatus.won,
              compact: _game.status == PuzzleStatus.won,
              onPlayAgain: widget.isForChild ? null : _newRound,
              onExit: () => Navigator.of(context).maybePop(),
            ),
    );
  }
}

/// One piece of the picture. It draws the part of the whole picture that
/// belongs to ([row], [column]).
class _PuzzlePiece extends StatelessWidget {
  const _PuzzlePiece({
    super.key,
    required this.image,
    required this.row,
    required this.column,
    required this.rows,
    required this.columns,
    required this.isSelected,
    required this.onTap,
  });

  final String image;
  final int row;
  final int column;
  final int rows;
  final int columns;
  final bool isSelected;
  final VoidCallback onTap;

  // The border has the same width when chosen, so the picture does not move.
  static const double _border = 4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? GamesColors.text : GamesColors.edge,
            width: _border,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: LayoutBuilder(
            builder: (context, box) {
              final width = box.maxWidth;
              final height = box.maxHeight;
              // The whole picture is drawn at the size of all the pieces
              // together, then moved so this piece's part shows.
              return OverflowBox(
                alignment: Alignment.topLeft,
                minWidth: width * columns,
                maxWidth: width * columns,
                minHeight: height * rows,
                maxHeight: height * rows,
                child: Transform.translate(
                  offset: Offset(-column * width, -row * height),
                  child: SizedBox(
                    width: width * columns,
                    height: height * rows,
                    child: GamesImage(image),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
