import '../models/story_profile.dart';

/// Where the names entered by the parents are kept.
///
/// The names belong to a child, so they stay on the phone and are never sent
/// anywhere. The stories code only knows this interface, so the way of saving
/// can change later without touching the screens.
abstract class StoryProfileStorage {
  /// The saved names, or null if the parents did not enter any yet.
  Future<StoryProfile?> read();

  Future<void> write(StoryProfile profile);
}

/// Keeps the names in memory only, so they are forgotten when the app closes.
/// Useful in tests, where nothing should be saved on a real phone.
class InMemoryStoryProfileStorage implements StoryProfileStorage {
  InMemoryStoryProfileStorage([this._saved]);

  StoryProfile? _saved;

  @override
  Future<StoryProfile?> read() async => _saved;

  @override
  Future<void> write(StoryProfile profile) async {
    _saved = profile;
  }
}
