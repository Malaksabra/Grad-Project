import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_images.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import '../logic/odd_one_out_game.dart';
import '../models/odd_one_out_level.dart';
import '../widgets/end_panel.dart';
import '../widgets/filled_grid.dart';
import '../widgets/game_play_layout.dart';
import '../widgets/games_image.dart';
import '../widgets/thick_box.dart';
import '../widgets/time_label.dart';

/// The "pick the different one" page. The rules live in [OddOneOutGame]. This
/// screen owns the real timer and the pause between rounds, picks the texts,
/// and draws the pictures.
class OddOneOutGameScreen extends StatefulWidget {
  const OddOneOutGameScreen({
    super.key,
    required this.levelIndex,
    this.fruits = GamesImages.fruits,
    this.vegetables = GamesImages.vegetables,
    this.random,
    this.isForChild = false,
    this.onFinished,
  });

  /// The level number: 0, 1 or 2.
  final int levelIndex;

  final List<String> fruits;
  final List<String> vegetables;

  /// For tests only: makes the shuffle repeatable.
  final Random? random;

  /// True on the child's page: the child cannot play again.
  final bool isForChild;

  /// Called once when the game ends, by winning or when the time is up.
  final VoidCallback? onFinished;

  @override
  State<OddOneOutGameScreen> createState() => _OddOneOutGameScreenState();
}

class _OddOneOutGameScreenState extends State<OddOneOutGameScreen> {
  static const Duration _roundPause = Duration(milliseconds: 1200);

  late final OddOneOutLevel _level;
  late final OddOneOutGame _game;

  Timer? _clock;
  Timer? _roundTimer;
  String _message = GamesTexts.oddMessageStart;
  bool _hasReportedEnd = false;

  @override
  void initState() {
    super.initState();
    _level = OddOneOutLevel.all[widget.levelIndex];
    _game = OddOneOutGame(
      groupA: widget.fruits,
      groupB: widget.vegetables,
      itemsPerRound: _level.items,
      rounds: _level.rounds,
      seconds: _level.seconds,
      random: widget.random,
    );
  }

  @override
  void dispose() {
    _clock?.cancel();
    _roundTimer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _clock = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(_game.tick);
      if (_game.status != OddOneOutStatus.playing) {
        timer.cancel();
        _reportEnd();
      }
    });
  }

  void _reportEnd() {
    if (_hasReportedEnd || _game.status == OddOneOutStatus.playing) return;
    _hasReportedEnd = true;
    widget.onFinished?.call();
  }

  void _onPick(int index) {
    final outcome = _game.pick(index);
    if (outcome == PickOutcome.ignored) return;

    // The clock starts with the first picture of the game.
    if (_clock == null) _startClock();

    setState(() {
      _message = outcome == PickOutcome.correct
          ? GamesTexts.oddMessageCorrect
          : GamesTexts.oddMessageWrong;
    });

    if (_game.status == OddOneOutStatus.won) {
      _clock?.cancel();
      _reportEnd();
    }

    final hasNextRound = _game.status == OddOneOutStatus.playing;
    if (outcome == PickOutcome.correct && hasNextRound) {
      _roundTimer = Timer(_roundPause, () {
        if (!mounted) return;
        setState(() {
          _game.nextRound();
          _message = GamesTexts.oddMessageStart;
        });
      });
    }
  }

  void _newRound() {
    _clock?.cancel();
    _clock = null;
    _roundTimer?.cancel();
    _hasReportedEnd = false;
    setState(() {
      _game.restart();
      _message = GamesTexts.oddMessageStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _game.items;
    return GamePlayLayout(
      pageTitle: GamesTexts.levelTitle(widget.levelIndex),
      guide: GamesTexts.oddGuide,
      heading: GamesTexts.oddGameTitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            GamesTexts.roundOf(_game.round + 1, _level.rounds),
            style: GamesStyles.body(
              size: 14.5,
              weight: FontWeight.w500,
              color: GamesColors.inkSoft,
            ),
          ),
          const SizedBox(width: 12),
          TimeLabel(
            seconds: _game.remainingSeconds,
            style: GamesStyles.display(size: 20, color: GamesColors.text),
            iconSize: 26,
          ),
        ],
      ),
      timeFraction: _game.remainingFraction,
      message: _message,
      board: FilledGrid(
        columns: 2,
        itemCount: items.length,
        itemBuilder: (context, i) => _ItemView(
          key: ValueKey('item_$i'),
          item: items[i],
          onTap: () => _onPick(i),
        ),
      ),
      result: _game.status == OddOneOutStatus.playing
          ? null
          : EndPanel(
              won: _game.status == OddOneOutStatus.won,
              onPlayAgain: widget.isForChild ? null : _newRound,
              onExit: () => Navigator.of(context).maybePop(),
            ),
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({super.key, required this.item, required this.onTap});

  final OddItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        // A wrong picture fades, so the child sees it was already tried.
        opacity: item.isWrongPick ? 0.35 : 1,
        child: ThickBox(
          fill: Colors.white,
          border: item.isCorrectPick ? GamesColors.correct : GamesColors.edge,
          radius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox.expand(child: GamesImage(item.image)),
          ),
        ),
      ),
    );
  }
}
