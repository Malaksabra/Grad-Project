import 'package:flutter/material.dart';

import '../models/game_kind.dart';
import 'memory_game_screen.dart';
import 'odd_one_out_game_screen.dart';
import 'puzzle_game_screen.dart';

/// The page that plays [game] at [levelIndex] (0, 1 or 2).
/// Used by the parent's pages and by the child's page.
///
/// With [isForChild] the round cannot be played again, and [onFinished] is
/// called when the round ends.
Widget buildGameScreen(
  GameKind game,
  int levelIndex, {
  bool isForChild = false,
  VoidCallback? onFinished,
}) {
  return switch (game) {
    GameKind.memory => MemoryGameScreen(
      levelIndex: levelIndex,
      isForChild: isForChild,
      onFinished: onFinished,
    ),
    GameKind.puzzle => PuzzleGameScreen(
      levelIndex: levelIndex,
      isForChild: isForChild,
      onFinished: onFinished,
    ),
    GameKind.oddOneOut => OddOneOutGameScreen(
      levelIndex: levelIndex,
      isForChild: isForChild,
      onFinished: onFinished,
    ),
  };
}
