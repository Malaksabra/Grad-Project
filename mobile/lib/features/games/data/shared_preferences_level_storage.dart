import 'package:shared_preferences/shared_preferences.dart';

import '../models/child_choice.dart';
import '../models/game_kind.dart';
import 'level_storage.dart';

/// Saves the game and level chosen for the child on the phone, so they are
/// still there the next time the app opens.
class SharedPreferencesLevelStorage implements LevelStorage {
  // This key existed before there were three games, so an old saved level
  // still works (it belongs to the memory game).
  static const String _levelKey = 'games_selected_level';
  static const String _gameKey = 'games_selected_game';
  static const String _finishedDayKey = 'games_finished_day';

  @override
  Future<ChildChoice?> read() async {
    final preferences = await SharedPreferences.getInstance();
    final level = preferences.getInt(_levelKey);
    if (level == null) return null;
    final name = preferences.getString(_gameKey);
    final game = GameKind.values.firstWhere(
      (kind) => kind.name == name,
      orElse: () => GameKind.memory,
    );
    return ChildChoice(game, level);
  }

  @override
  Future<void> write(ChildChoice choice) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_levelKey, choice.level);
    await preferences.setString(_gameKey, choice.game.name);
  }

  @override
  Future<String?> readFinishedDay() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_finishedDayKey);
  }

  @override
  Future<void> writeFinishedDay(String? day) async {
    final preferences = await SharedPreferences.getInstance();
    if (day == null) {
      await preferences.remove(_finishedDayKey);
    } else {
      await preferences.setString(_finishedDayKey, day);
    }
  }
}
