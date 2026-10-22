import 'story_page.dart';

/// A short illustrated story that a child reads page by page.
class Story {
  const Story({required this.id, required this.title, required this.pages});

  factory Story.fromJson(Map<String, dynamic> json, {required String folder}) {
    final pages = json['pages'] as List<dynamic>;
    return Story(
      id: json['id'] as String,
      title: json['title'] as String,
      pages: [
        for (final page in pages)
          StoryPage.fromJson(page as Map<String, dynamic>, folder: folder),
      ],
    );
  }

  final String id;
  final String title;
  final List<StoryPage> pages;
}
