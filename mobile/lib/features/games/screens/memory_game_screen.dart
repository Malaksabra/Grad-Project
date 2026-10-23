import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_images.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import '../logic/memory_game.dart';
import '../models/game_level.dart';
import '../widgets/game_button.dart';
import '../widgets/games_image.dart';
import '../widgets/games_page.dart';
import '../widgets/games_panel.dart';
import '../widgets/guide_row.dart';
import '../widgets/thick_box.dart';

/// The memory game page. The rules live in [MemoryGame]. This screen only
/// owns the two real timers, picks the texts, and draws the board.
class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({
    super.key,
    required this.levelIndex,
    this.images = GamesImages.fruits,
    this.random,
  });

  /// The level number: 0, 1 or 2.
  final int levelIndex;

  /// The pictures the cards are dealt from.
  final List<String> images;

  /// For tests only: makes the shuffle repeatable.
  final Random? random;

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  static const Duration _mismatchPause = Duration(seconds: 1);

  late final GameLevel _level;
  late final MemoryGame _game;

  Timer? _clock;
  Timer? _mismatchTimer;
  String _message = GamesTexts.messageStart;

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
      if (_game.status != MemoryStatus.playing) timer.cancel();
    });
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

    if (_game.status == MemoryStatus.won) _clock?.cancel();

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
    setState(() {
      _game.restart();
      _message = GamesTexts.messageStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = _game.cards;
    final playing = _game.status == MemoryStatus.playing;

    return GamesPage(
      title: GamesTexts.levelTitle(widget.levelIndex),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GuideRow(text: GamesTexts.gameGuide),
            GamesPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          GamesTexts.gameTitle,
                          style: GamesStyles.display(size: 19.2),
                        ),
                      ),
                      Text(
                        '⏱ ${formatTime(_game.remainingSeconds)}',
                        style: GamesStyles.display(
                          size: 20,
                          color: GamesColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _TimeBar(value: _game.remainingFraction),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: _level.columns,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: _level.cardAspectRatio,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (var i = 0; i < cards.length; i++)
                        _CardView(
                          key: ValueKey('card_$i'),
                          card: cards[i],
                          onTap: () => _onCardTap(i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (playing)
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 27),
                      child: Text(
                        _message,
                        style: GamesStyles.body(color: GamesColors.inkSoft),
                      ),
                    )
                  else
                    _EndPanel(
                      won: _game.status == MemoryStatus.won,
                      onPlayAgain: _newRound,
                      onExit: () => Navigator.of(context).maybePop(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The bar that gets shorter while the time runs out.
class _TimeBar extends StatelessWidget {
  const _TimeBar({required this.value});

  /// From 1.0 (full time) to 0.0 (time is up).
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: GamesColors.line, width: 2),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: GamesColors.edge,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
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
            : Center(
                child: Text(
                  '❓',
                  style: GamesStyles.body(size: 36, weight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}

/// What the child sees when the round is over.
class _EndPanel extends StatelessWidget {
  const _EndPanel({
    required this.won,
    required this.onPlayAgain,
    required this.onExit,
  });

  final bool won;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (won)
          const Icon(Icons.star_rounded, size: 78, color: GamesColors.star)
        else
          const Text('⏰', style: TextStyle(fontSize: 56)),
        Text(
          won ? GamesTexts.won : GamesTexts.timeUp,
          textAlign: TextAlign.center,
          style: GamesStyles.display(size: 24),
        ),
        if (!won)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              GamesTexts.tryAgainQuestion,
              style: GamesStyles.body(color: GamesColors.inkSoft),
            ),
          ),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            GameButton(
              won ? GamesTexts.playAgain : GamesTexts.tryAgain,
              primary: true,
              big: true,
              onTap: onPlayAgain,
            ),
            GameButton(GamesTexts.exit, big: true, onTap: onExit),
          ],
        ),
      ],
    );
  }
}
