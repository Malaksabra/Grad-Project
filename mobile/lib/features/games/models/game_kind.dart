import '../games_texts.dart';
import 'game_level.dart';
import 'odd_one_out_level.dart';
import 'puzzle_level.dart';

/// The games of the section. Add a new game here first.
enum GameKind { memory, puzzle, oddOneOut }

/// What the levels page shows about one level, for any game.
class LevelSummary {
  const LevelSummary({required this.countText, this.seconds});

  /// For example "6 كروت" or "3 جولات".
  final String countText;

  /// The time of the level, or null if the game has no clock.
  final int? seconds;
}

extension GameKindInfo on GameKind {
  String get title => switch (this) {
    GameKind.memory => GamesTexts.memoryCardsTitle,
    GameKind.puzzle => GamesTexts.puzzleTitle,
    GameKind.oddOneOut => GamesTexts.oddOneOutTitle,
  };

  int get levelCount => switch (this) {
    GameKind.memory => GameLevel.all.length,
    GameKind.puzzle => PuzzleLevel.all.length,
    GameKind.oddOneOut => OddOneOutLevel.all.length,
  };

  LevelSummary levelSummary(int index) {
    RangeError.checkValueInInterval(index, 0, levelCount - 1, 'index');
    return switch (this) {
      GameKind.memory => LevelSummary(
        countText: GamesTexts.cardsCount(GameLevel.all[index].cardCount),
        seconds: GameLevel.all[index].seconds,
      ),
      GameKind.puzzle => LevelSummary(
        countText: GamesTexts.piecesCount(PuzzleLevel.all[index].pieceCount),
        seconds: PuzzleLevel.all[index].seconds,
      ),
      GameKind.oddOneOut => LevelSummary(
        countText: GamesTexts.roundsCount(OddOneOutLevel.all[index].rounds),
        seconds: OddOneOutLevel.all[index].seconds,
      ),
    };
  }
}
