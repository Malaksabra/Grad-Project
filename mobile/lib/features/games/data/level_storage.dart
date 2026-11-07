import '../models/child_choice.dart';

/// Where the game and level chosen for the child are kept, and the day the
/// child finished the game.
///
/// The games code only knows this interface, so the way of saving can change
/// later without touching the screens or the settings.
abstract class LevelStorage {
  /// The saved choice, or null if nothing was saved yet.
  Future<ChildChoice?> read();

  Future<void> write(ChildChoice choice);

  /// The day the child finished the game, like "2026-11-07", or null.
  Future<String?> readFinishedDay();

  /// Saves the day the child finished the game. A null [day] clears it.
  Future<void> writeFinishedDay(String? day);
}

/// Keeps everything in memory only, so it is forgotten when the app closes.
/// Useful in tests, where nothing should be saved on a real phone.
class InMemoryLevelStorage implements LevelStorage {
  InMemoryLevelStorage([this._saved, this._finishedDay]);

  ChildChoice? _saved;
  String? _finishedDay;

  @override
  Future<ChildChoice?> read() async => _saved;

  @override
  Future<void> write(ChildChoice choice) async {
    _saved = choice;
  }

  @override
  Future<String?> readFinishedDay() async => _finishedDay;

  @override
  Future<void> writeFinishedDay(String? day) async {
    _finishedDay = day;
  }
}
