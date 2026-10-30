import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/question_story_models.dart';

/// Where the stories come from.
///
/// The screens only know this interface, so the source can change later
/// (a server, for example) without touching them.
abstract class QuestionStoryRepository {
  Future<QuestionStoryLibrary> load();
}

/// Reads the stories from the JSON file that ships inside the app.
///
/// The texts live in the file and not in the code, so a specialist's
/// correction is a one-line edit.
class AssetQuestionStoryRepository implements QuestionStoryRepository {
  AssetQuestionStoryRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const String assetPath = 'assets/data/question_stories.json';

  final AssetBundle _bundle;

  @override
  Future<QuestionStoryLibrary> load() async {
    final rawJson = await _bundle.loadString(assetPath);
    return QuestionStoryLibrary.fromJson(
      jsonDecode(rawJson) as Map<String, dynamic>,
    );
  }
}
