import 'package:flutter/foundation.dart';

import '../data/level_storage.dart';
import '../models/child_choice.dart';
import '../models/game_kind.dart';

/// The game and level the parents chose for the child, and the day the child
/// finished the game. Screens listen to it, and it saves through a
/// [LevelStorage].
class GamesSettings extends ChangeNotifier {
  GamesSettings(this._storage);

  final LevelStorage _storage;

  GameKind _selectedGame = GameKind.memory;
  int _selectedLevel = 0;
  String? _finishedDay;

  GameKind get selectedGame => _selectedGame;

  /// The number of the chosen level: 0, 1 or 2.
  int get selectedLevel => _selectedLevel;

  /// True if the child already finished the game on [day] (see `dayKey`).
  bool isFinishedOn(String day) => _finishedDay == day;

  /// Reads what was saved. Keeps the first level of the memory game, and no
  /// finished day, for anything that was not saved or cannot be read.
  Future<void> load() async {
    var changed = false;

    try {
      final saved = await _storage.read();
      if (saved != null) {
        final level = saved.level.clamp(0, saved.game.levelCount - 1).toInt();
        if (saved.game != _selectedGame || level != _selectedLevel) {
          _selectedGame = saved.game;
          _selectedLevel = level;
          changed = true;
        }
      }
    } on Object {
      // The saved choice could not be read, so the first choice stays.
    }

    try {
      final day = await _storage.readFinishedDay();
      if (day != _finishedDay) {
        _finishedDay = day;
        changed = true;
      }
    } on Object {
      // The finished day could not be read, so the child can play.
    }

    if (changed) notifyListeners();
  }

  /// Chooses a game and level for the child and saves them. This never opens
  /// the game again on a day the child already finished: the new choice
  /// shows up the next day.
  Future<void> select(GameKind game, int level) async {
    RangeError.checkValueInInterval(level, 0, game.levelCount - 1, 'level');
    if (game != _selectedGame || level != _selectedLevel) {
      _selectedGame = game;
      _selectedLevel = level;
      notifyListeners();
    }
    try {
      await _storage.write(ChildChoice(game, level));
    } on Object {
      // Saving is best effort: the choice still works until the app closes.
    }
  }

  /// The child finished the game on [day]. It stays locked until the next
  /// day.
  Future<void> markFinished(String day) async {
    _finishedDay = day;
    notifyListeners();
    try {
      await _storage.writeFinishedDay(day);
    } on Object {
      // Saving is best effort: the game stays locked until the app closes.
    }
  }
}
