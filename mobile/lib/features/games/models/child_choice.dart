import 'game_kind.dart';

/// The game and the level the parent chose for the child.
class ChildChoice {
  const ChildChoice(this.game, this.level);

  final GameKind game;

  /// The level number: 0, 1 or 2.
  final int level;

  @override
  bool operator ==(Object other) =>
      other is ChildChoice && other.game == game && other.level == level;

  @override
  int get hashCode => Object.hash(game, level);
}
