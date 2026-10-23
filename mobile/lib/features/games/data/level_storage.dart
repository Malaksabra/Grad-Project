/// Where the level chosen for the child is kept.
///
/// The games code only knows this interface, so the way of saving can change
/// later without touching the screens or the settings.
abstract class LevelStorage {
  /// The saved level number (0, 1 or 2), or null if nothing was saved yet.
  Future<int?> read();

  Future<void> write(int index);
}

/// Keeps the level in memory only, so it is forgotten when the app closes.
///
/// Temporary: replace it with a version that uses shared_preferences after the
/// team agrees to add that package.
class InMemoryLevelStorage implements LevelStorage {
  InMemoryLevelStorage([this._saved]);

  int? _saved;

  @override
  Future<int?> read() async => _saved;

  @override
  Future<void> write(int index) async {
    _saved = index;
  }
}
