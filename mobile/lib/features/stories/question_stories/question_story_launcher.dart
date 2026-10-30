import 'package:flutter/material.dart';

import 'data/question_story_repository.dart';
import 'data/shared_preferences_story_profile_storage.dart';
import 'data/story_profile_storage.dart';
import 'models/question_story_models.dart';
import 'models/story_profile.dart';
import 'question_stories_texts.dart';
import 'screens/question_story_screen.dart';
import 'screens/story_profile_screen.dart';

/// Opens a story from a card: loads it, asks the parents for the names the
/// first time, then starts the story. The cards only call [open].
class QuestionStoryLauncher {
  QuestionStoryLauncher({
    QuestionStoryRepository? repository,
    StoryProfileStorage? storage,
  }) : _repository = repository ?? AssetQuestionStoryRepository(),
       _storage = storage ?? SharedPreferencesStoryProfileStorage();

  final QuestionStoryRepository _repository;
  final StoryProfileStorage _storage;

  Future<void> open(BuildContext context, String storyId) async {
    final library = await _loadLibrary(context);
    if (library == null || !context.mounted) return;

    final story = library.storyById(storyId);
    if (story == null || !story.isReady) return;

    final profile = await _resolveProfile(context, library);
    if (profile == null || !context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuestionStoryScreen(
          story: story,
          profile: profile,
          myStoryTitle: library.myStoryTitle,
        ),
      ),
    );
  }

  /// Lets the parents change the names later, for example from the parent
  /// section. The new names are used from the next story on.
  Future<void> editNames(BuildContext context) async {
    final library = await _loadLibrary(context);
    if (library == null || !context.mounted) return;

    final current = await _storage.read() ?? library.defaultProfile;
    if (!context.mounted) return;

    final entered = await _askForNames(context, current);
    if (entered != null) await _storage.write(entered);
  }

  /// Loads the stories, or shows a short message and returns null if the
  /// file cannot be read.
  Future<QuestionStoryLibrary?> _loadLibrary(BuildContext context) async {
    try {
      return await _repository.load();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(QuestionStoriesTexts.loadError)),
        );
      }
      return null;
    }
  }

  /// The saved names, or the ones the parents enter now. Null when the
  /// parents leave the screen without saving.
  Future<StoryProfile?> _resolveProfile(
    BuildContext context,
    QuestionStoryLibrary library,
  ) async {
    final saved = await _storage.read();
    if (saved != null) return saved;
    if (!context.mounted) return null;

    final entered = await _askForNames(context, library.defaultProfile);
    if (entered != null) await _storage.write(entered);
    return entered;
  }

  Future<StoryProfile?> _askForNames(
    BuildContext context,
    StoryProfile initialProfile,
  ) {
    return Navigator.of(context).push<StoryProfile>(
      MaterialPageRoute<StoryProfile>(
        builder: (_) => StoryProfileScreen(initialProfile: initialProfile),
      ),
    );
  }
}
