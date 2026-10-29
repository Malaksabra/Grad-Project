import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/story.dart';

/// Loads stories from the app assets.
class StoryRepository {
  StoryRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  static const String _storyFileName = 'story.json';

  /// [folder] is the asset folder of one story, for example
  /// `assets/stories/sharing_01`.
  Future<Story> load(String folder) async {
    final content = await _bundle.loadString('$folder/$_storyFileName');
    final json = jsonDecode(content) as Map<String, dynamic>;
    return Story.fromJson(json, folder: folder);
  }
}
