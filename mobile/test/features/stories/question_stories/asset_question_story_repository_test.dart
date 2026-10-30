import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/stories/question_stories/data/question_story_repository.dart';

/// Serves one fixed text for any asset, so no real file is needed.
class _FakeBundle extends AssetBundle {
  _FakeBundle(this._content);

  final String _content;
  String? requestedKey;

  @override
  Future<ByteData> load(String key) async {
    requestedKey = key;
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(_content)));
  }
}

const String _smallLibrary = '''
{
  "defaults": { "childName": "Omar", "friendName": "Youssef" },
  "myStory": { "title": "{child}", "button": "my story" },
  "stories": [
    {
      "id": "one",
      "title": "one",
      "status": "ready",
      "pages": [
        {
          "image": "a.png",
          "question": "{friend}?",
          "choices": [
            { "label": "yes", "image": null, "correct": true },
            { "label": "no", "image": null, "correct": false }
          ],
          "storyLine": "{child} knows."
        }
      ]
    }
  ]
}
''';

void main() {
  test('loads the stories from the shipped json file', () async {
    final bundle = _FakeBundle(_smallLibrary);

    final library = await AssetQuestionStoryRepository(bundle: bundle).load();

    expect(bundle.requestedKey, AssetQuestionStoryRepository.assetPath);
    expect(library.stories.single.id, 'one');
    expect(library.defaultProfile.childName, 'Omar');
  });

  test('reads Arabic text without breaking it', () async {
    final bundle = _FakeBundle(
      _smallLibrary.replaceAll('"button": "my story"', '"button": "حكايتي"'),
    );

    final library = await AssetQuestionStoryRepository(bundle: bundle).load();

    expect(library.myStoryButton, 'حكايتي');
  });
}
