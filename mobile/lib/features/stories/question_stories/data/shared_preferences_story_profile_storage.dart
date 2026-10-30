import 'package:shared_preferences/shared_preferences.dart';

import '../models/story_profile.dart';
import 'story_profile_storage.dart';

/// Saves the names on the phone, so they are still there the next time the
/// app opens.
class SharedPreferencesStoryProfileStorage implements StoryProfileStorage {
  static const String _childKey = 'stories_child_name';
  static const String _friendKey = 'stories_friend_name';

  @override
  Future<StoryProfile?> read() async {
    final preferences = await SharedPreferences.getInstance();
    final childName = preferences.getString(_childKey);
    final friendName = preferences.getString(_friendKey);
    // Both names are saved together, so one alone means nothing usable.
    if (childName == null || friendName == null) return null;

    return StoryProfile(childName: childName, friendName: friendName);
  }

  @override
  Future<void> write(StoryProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_childKey, profile.childName);
    await preferences.setString(_friendKey, profile.friendName);
  }
}
