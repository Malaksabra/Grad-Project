/// The settings of one level of the puzzle game.
class PuzzleLevel {
  const PuzzleLevel({
    required this.rows,
    required this.columns,
    required this.seconds,
  });

  final int rows;
  final int columns;

  /// The fixed time of the level, in seconds.
  final int seconds;

  int get pieceCount => rows * columns;

  /// The three levels, from the easiest to the hardest.
  static const List<PuzzleLevel> all = [
    PuzzleLevel(rows: 2, columns: 2, seconds: 120),
    PuzzleLevel(rows: 3, columns: 2, seconds: 180),
    PuzzleLevel(rows: 3, columns: 3, seconds: 300),
  ];
}
