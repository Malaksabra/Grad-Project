import 'package:flutter/foundation.dart';

import '../data/level_storage.dart';
import '../models/game_level.dart';

/// The level the parents chose for the child.
/// Screens listen to it, and it saves the choice through a [LevelStorage].
class GamesSettings extends ChangeNotifier {
  GamesSettings(this._storage);

  final LevelStorage _storage;

  int _selectedLevel = 0;

  /// The number of the chosen level: 0, 1 or 2.
  int get selectedLevel => _selectedLevel;

  GameLevel get level => GameLevel.all[_selectedLevel];

  /// Reads the saved choice. Keeps the first level if nothing was saved.
  Future<void> load() async {
    final int? saved;
    try {
      saved = await _storage.read();
    } on Object {
      // The saved choice could not be read, so the first level stays.
      return;
    }
    if (saved == null) return;
    final index = saved.clamp(0, GameLevel.all.length - 1).toInt();
    if (index == _selectedLevel) return;
    _selectedLevel = index;
    notifyListeners();
  }

  /// Chooses a level for the child and saves it.
  Future<void> select(int index) async {
    RangeError.checkValueInInterval(
      index,
      0,
      GameLevel.all.length - 1,
      'index',
    );
    if (index != _selectedLevel) {
      _selectedLevel = index;
      notifyListeners();
    }
    try {
      await _storage.write(index);
    } on Object {
      // Saving is best effort: the choice still works until the app closes.
    }
  }
}
