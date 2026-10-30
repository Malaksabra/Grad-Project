import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/stories/question_stories/models/question_story_models.dart';
import 'package:grad_project/features/stories/question_stories/models/story_profile.dart';

// flutter test runs from the mobile folder, so this is the real shipped file.
const String _storiesFile = 'assets/data/question_stories.json';

QuestionStoryLibrary _loadLibrary() {
  final rawJson = File(_storiesFile).readAsStringSync();
  return QuestionStoryLibrary.fromJson(
    jsonDecode(rawJson) as Map<String, dynamic>,
  );
}

Iterable<QuestionPage> _allPages(QuestionStoryLibrary library) sync* {
  for (final story in library.stories) {
    yield* story.pages;
    yield* story.practicePages;
  }
}

void main() {
  group('stories.json', () {
    test('has two ready stories and two placeholders', () {
      final library = _loadLibrary();

      expect(library.stories.where((story) => story.isReady), hasLength(2));
      expect(library.stories.where((story) => !story.isReady), hasLength(2));
    });

    test('keeps the ready stories first, then the placeholders', () {
      final library = _loadLibrary();

      final readyFlags = library.stories.map((story) => story.isReady);
      expect(readyFlags, [true, true, false, false]);
    });

    test('has no pages in a placeholder', () {
      final library = _loadLibrary();

      for (final story in library.stories.where((story) => !story.isReady)) {
        expect(story.pages, isEmpty);
      }
    });

    test('gives every question at least one correct answer', () {
      final library = _loadLibrary();

      for (final page in _allPages(library)) {
        expect(
          page.choices.where((choice) => choice.isCorrect),
          isNotEmpty,
          reason: page.question,
        );
        expect(page.choices.length, greaterThanOrEqualTo(2));
      }
    });

    test('gives every story page a sentence for the child to tell', () {
      final library = _loadLibrary();

      for (final story in library.stories) {
        for (final page in story.pages) {
          expect(page.storyLine, isNotNull, reason: page.question);
        }
      }
    });

    test('uses only the two known name markers', () {
      final library = _loadLibrary();
      final markers = RegExp(r'\{[^}]*\}');
      const known = {'{child}', '{friend}'};

      for (final page in _allPages(library)) {
        final texts = [page.question, ?page.storyLine];
        for (final text in texts) {
          for (final match in markers.allMatches(text)) {
            expect(known, contains(match.group(0)), reason: text);
          }
        }
      }
    });

    test('leaves no marker behind after the names are filled in', () {
      final library = _loadLibrary();

      for (final page in _allPages(library)) {
        final texts = [
          page.questionFor(library.defaultProfile),
          ?page.storyLineFor(library.defaultProfile),
        ];
        for (final text in texts) {
          expect(text, isNot(contains('{')));
        }
      }
    });

    // Catches a mistyped path before the child sees a broken picture.
    test('points every picture to a file that exists', () {
      final library = _loadLibrary();

      for (final page in _allPages(library)) {
        final paths = [
          page.imagePath,
          for (final choice in page.choices) ?choice.imagePath,
        ];
        for (final path in paths) {
          expect(File(path).existsSync(), isTrue, reason: path);
        }
      }
    });
  });

  group('QuestionStoryLibrary', () {
    test('finds a story by its id', () {
      final library = _loadLibrary();

      expect(library.storyById('sharing')?.isReady, isTrue);
    });

    test('returns null for an unknown id', () {
      final library = _loadLibrary();

      expect(library.storyById('nothing'), isNull);
    });

    test('fills the names into the title of "my story"', () {
      final library = _loadLibrary();
      const profile = StoryProfile(childName: 'Omar', friendName: 'Youssef');

      expect(profile.fill(library.myStoryTitle), isNot(contains('{child}')));
      expect(profile.fill(library.myStoryTitle), contains('Omar'));
    });
  });
}
