/// The settings of one level of the "pick the different one" game.
class OddOneOutLevel {
  const OddOneOutLevel({
    required this.items,
    required this.rounds,
    required this.seconds,
  });

  /// How many pictures are shown in each round (one of them is different).
  final int items;

  /// How many rounds the child plays to finish the level.
  final int rounds;

  /// The fixed time of the whole level, in seconds.
  final int seconds;

  /// The three levels, from the easiest to the hardest.
  static const List<OddOneOutLevel> all = [
    OddOneOutLevel(items: 3, rounds: 3, seconds: 90),
    OddOneOutLevel(items: 4, rounds: 4, seconds: 120),
    OddOneOutLevel(items: 5, rounds: 5, seconds: 180),
  ];
}
