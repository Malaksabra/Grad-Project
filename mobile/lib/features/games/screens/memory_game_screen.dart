import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../games_images.dart';
import '../games_styles.dart';
import '../games_colors.dart';
import '../games_texts.dart';
import '../logic/board_layout.dart';
import '../logic/memory_game.dart';
import '../models/game_level.dart';
import '../widgets/end_panel.dart';
import '../widgets/filled_grid.dart';
import '../widgets/game_icon.dart';
import '../widgets/game_play_layout.dart';
import '../widgets/games_image.dart';
import '../widgets/thick_box.dart';
import '../widgets/time_label.dart';

/// The memory game page. The rules live in [MemoryGame]. This screen only
/// owns the two real timers, picks the texts, and draws the board.
class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({
    super.key,
    required this.levelIndex,
    this.images = GamesImages.fruits,
    this.random,
    this.isForChild = false,
    this.onFinished,
  });

  /// The level number: 0, 1 or 2.
  final int levelIndex;

  /// The pictures the cards are dealt from.
  final List<String> images;

  /// For tests only: makes the shuffle repeatable.
  final Random? random;

  /// True on the child's page: the child cannot play the round again.
  final bool isForChild;

  /// Called once when the round ends, by winning or when the time is up.
  final VoidCallback? onFinished;

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  static const Duration _mismatchPause = Duration(seconds: 1);
  static const double _gap = 10;

  late final GameLevel _level;
  late final MemoryGame _game;

  Timer? _clock;
  Timer? _mismatchTimer;
  String _message = GamesTexts.messageStart;
  bool _hasReportedEnd = false;

  @override
  void initState() {
    super.initState();
    _level = GameLevel.all[widget.levelIndex];
    _game = MemoryGame(
      images: widget.images,
      pairs: _level.pairs,
      seconds: _level.seconds,
      random: widget.random,
    );
  }

  @override
  void dispose() {
    _clock?.cancel();
    _mismatchTimer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _clock = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(_game.tick);
      if (_game.status != MemoryStatus.playing) {
        timer.cancel();
        _reportEnd();
      }
    });
  }

  void _reportEnd() {
    if (_hasReportedEnd || _game.status == MemoryStatus.playing) return;
    _hasReportedEnd = true;
    widget.onFinished?.call();
  }

  void _onCardTap(int index) {
    final outcome = _game.flip(index);
    if (outcome == FlipOutcome.ignored) return;

    // The clock starts with the first card of the round.
    if (_clock == null) _startClock();

    setState(() {
      _message = switch (outcome) {
        FlipOutcome.firstCard => GamesTexts.messageFlipSecond,
        FlipOutcome.match => GamesTexts.messageMatch,
        FlipOutcome.mismatch => GamesTexts.messageNoMatch,
        FlipOutcome.ignored => _message,
      };
    });

    if (_game.status == MemoryStatus.won) {
      _clock?.cancel();
      _reportEnd();
    }

    if (outcome == FlipOutcome.mismatch) {
      _mismatchTimer = Timer(_mismatchPause, () {
        if (!mounted) return;
        setState(_game.hideMismatch);
      });
    }
  }

  void _newRound() {
    _clock?.cancel();
    _clock = null;
    _mismatchTimer?.cancel();
    _hasReportedEnd = false;
    setState(() {
      _game.restart();
      _message = GamesTexts.messageStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GamePlayLayout(
      pageTitle: GamesTexts.levelTitle(widget.levelIndex),
      guide: GamesTexts.gameGuide,
      heading: GamesTexts.gameTitle,
      trailing: TimeLabel(
        seconds: _game.remainingSeconds,
        style: GamesStyles.display(size: 20, color: GamesColors.text),
        iconSize: 26,
      ),
      timeFraction: _game.remainingFraction,
      message: _message,
      board: _buildBoard(),
      result: _game.status == MemoryStatus.playing
          ? null
          : EndPanel(
              won: _game.status == MemoryStatus.won,
              onPlayAgain: widget.isForChild ? null : _newRound,
              onExit: () => Navigator.of(context).maybePop(),
            ),
    );
  }

  Widget _buildBoard() {
    final cards = _game.cards;
    return LayoutBuilder(
      builder: (context, box) {
        final columns = bestColumns(
          count: cards.length,
          width: box.maxWidth,
          height: box.maxHeight,
          gap: _gap,
        );
        return FilledGrid(
          columns: columns,
          itemCount: cards.length,
          gap: _gap,
          itemBuilder: (context, i) => _CardView(
            key: ValueKey('card_$i'),
            card: cards[i],
            onTap: () => _onCardTap(i),
          ),
        );
      },
    );
  }
}

class _CardView extends StatelessWidget {
  const _CardView({super.key, required this.card, required this.onTap});

  final MemoryCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shown = card.isFaceUp || card.isMatched;

    return GestureDetector(
      onTap: card.isMatched ? null : onTap,
      child: ThickBox(
        fill: shown ? GamesColors.background : Colors.white,
        border: shown ? GamesColors.text : GamesColors.edge,
        radius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(6),
        child: shown
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox.expand(child: GamesImage(card.image)),
              )
            : const Center(
                child: GameIcon(
                  GamesImages.question,
                  size: 40,
                  key: ValueKey('card_back'),
                ),
              ),
      ),
    );
  }
}
