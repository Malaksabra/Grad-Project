/// One page of a story: an image and the sentence shown under it.
class StoryPage {
  const StoryPage({required this.imagePath, required this.text});

  factory StoryPage.fromJson(
    Map<String, dynamic> json, {
    required String folder,
  }) {
    final image = json['image'] as String;
    return StoryPage(imagePath: '$folder/$image', text: json['text'] as String);
  }

  final String imagePath;
  final String text;
}
