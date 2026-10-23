import 'package:shared_preferences/shared_preferences.dart';

import 'level_storage.dart';

/// Saves the level chosen for the child on the phone, so it is still there
/// the next time the app opens.
class SharedPreferencesLevelStorage implements LevelStorage {
  static const String _key = 'games_selected_level';

  @override
  Future<int?> read() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_key);
  }

  @override
  Future<void> write(int index) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_key, index);
  }
}
