import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/social_situations/data/story_repository.dart';

const _storyJson = """
{
  "id": "sample_01",
  "title": "Sample story",
  "pages": [
    { "image": "p1.png", "text": "Page one" },
    { "image": "p2.png", "text": "Page two" }
  ]
}
""";

/// An asset bundle that serves text files from memory.
class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.files);

  final Map<String, String> files;

  @override
  Future<ByteData> load(String key) async {
    final content = files[key];
    if (content == null) {
      throw FlutterError('Asset not found: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(content)));
  }
}

void main() {
  test('loads a story and builds the image paths', () async {
    final repository = StoryRepository(
      bundle: _FakeBundle({'assets/stories/sample_01/story.json': _storyJson}),
    );

    final story = await repository.load('assets/stories/sample_01');

    expect(story.id, 'sample_01');
    expect(story.title, 'Sample story');
    expect(story.pages, hasLength(2));
    expect(story.pages.first.imagePath, 'assets/stories/sample_01/p1.png');
    expect(story.pages.first.text, 'Page one');
  });
}
