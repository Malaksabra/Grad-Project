/// The settings of one level of the memory game.
class GameLevel {
  const GameLevel({required this.pairs, required this.seconds});

  /// How many different pictures (each one appears on two cards).
  final int pairs;

  /// The fixed time of the level, in seconds.
  final int seconds;

  int get cardCount => pairs * 2;

  /// The three levels, from the easiest to the hardest.
  static const List<GameLevel> all = [
    GameLevel(pairs: 3, seconds: 120),
    GameLevel(pairs: 4, seconds: 180),
    GameLevel(pairs: 6, seconds: 300),
  ];
}

/// Shows seconds as minutes and seconds, for example 125 becomes "2:05".
String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final rest = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$rest';
}
