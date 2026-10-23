/// The settings of one level of the memory game.
class GameLevel {
  const GameLevel({
    required this.pairs,
    required this.seconds,
    required this.columns,
    required this.cardAspectRatio,
  });

  /// How many different pictures (each one appears on two cards).
  final int pairs;

  /// The fixed time of the level, in seconds.
  final int seconds;

  /// How many cards in each row of the board.
  final int columns;

  /// Width divided by height of one card.
  final double cardAspectRatio;

  int get cardCount => pairs * 2;

  /// The three levels, from the easiest to the hardest.
  static const List<GameLevel> all = [
    GameLevel(pairs: 3, seconds: 120, columns: 3, cardAspectRatio: 0.9),
    GameLevel(pairs: 4, seconds: 180, columns: 4, cardAspectRatio: 0.8),
    GameLevel(pairs: 6, seconds: 300, columns: 4, cardAspectRatio: 0.8),
  ];
}

/// Shows seconds as minutes and seconds, for example 125 becomes "2:05".
String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final rest = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$rest';
}
