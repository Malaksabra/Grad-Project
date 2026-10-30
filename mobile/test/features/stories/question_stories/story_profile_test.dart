import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/stories/question_stories/models/story_profile.dart';

void main() {
  const profile = StoryProfile(childName: 'Omar', friendName: 'Youssef');

  test('fills both names into a text', () {
    expect(profile.fill('{child} met {friend}'), 'Omar met Youssef');
  });

  test('fills a name that appears more than once', () {
    expect(
      profile.fill('{friend} said thanks, {child}. {friend} smiled.'),
      'Youssef said thanks, Omar. Youssef smiled.',
    );
  });

  test('leaves a text without markers unchanged', () {
    expect(profile.fill('no names here'), 'no names here');
  });

  test('treats two profiles with the same names as equal', () {
    const same = StoryProfile(childName: 'Omar', friendName: 'Youssef');

    expect(profile, same);
    expect(profile.hashCode, same.hashCode);
  });
}
