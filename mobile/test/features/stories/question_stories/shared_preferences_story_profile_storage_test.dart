import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/stories/question_stories/data/shared_preferences_story_profile_storage.dart';
import 'package:grad_project/features/stories/question_stories/models/story_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const profile = StoryProfile(childName: 'Omar', friendName: 'Youssef');

  test('has nothing saved at first', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await SharedPreferencesStoryProfileStorage().read(), isNull);
  });

  test('gives back what was written', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPreferencesStoryProfileStorage();

    await storage.write(profile);

    expect(await storage.read(), profile);
  });

  test('reads names saved earlier', () async {
    SharedPreferences.setMockInitialValues({
      'stories_child_name': 'Omar',
      'stories_friend_name': 'Youssef',
    });

    expect(await SharedPreferencesStoryProfileStorage().read(), profile);
  });

  test('ignores a single saved name', () async {
    SharedPreferences.setMockInitialValues({'stories_child_name': 'Omar'});

    expect(await SharedPreferencesStoryProfileStorage().read(), isNull);
  });

  test('keeps the newest names after a second write', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPreferencesStoryProfileStorage();
    const newer = StoryProfile(childName: 'Salma', friendName: 'Mariam');

    await storage.write(profile);
    await storage.write(newer);

    expect(await storage.read(), newer);
  });
}
