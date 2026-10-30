import 'story_profile.dart';

/// One answer the child can pick under a story picture.
class QuestionChoice {
  const QuestionChoice({
    required this.label,
    required this.isCorrect,
    this.imagePath,
  });

  factory QuestionChoice.fromJson(Map<String, dynamic> json) {
    return QuestionChoice(
      label: json['label'] as String,
      imagePath: json['image'] as String?,
      isCorrect: json['correct'] as bool,
    );
  }

  final String label;

  /// Null when the choice is shown as text only.
  final String? imagePath;

  final bool isCorrect;
}

/// One picture of a story, with the question shown under it.
class QuestionPage {
  const QuestionPage({
    required this.imagePath,
    required this.question,
    required this.choices,
    this.storyLine,
  });

  factory QuestionPage.fromJson(Map<String, dynamic> json) {
    return QuestionPage(
      imagePath: json['image'] as String,
      question: json['question'] as String,
      choices: [
        for (final choice in json['choices'] as List<dynamic>)
          QuestionChoice.fromJson(choice as Map<String, dynamic>),
      ],
      storyLine: json['storyLine'] as String?,
    );
  }

  final String imagePath;

  /// May contain the `{child}` and `{friend}` name markers.
  final String question;

  final List<QuestionChoice> choices;

  /// The sentence the child "tells" after a correct answer. Practice
  /// questions have none, because they are not part of the story.
  final String? storyLine;

  /// The question with the real names filled in.
  String questionFor(StoryProfile profile) => profile.fill(question);

  /// The story sentence with the real names filled in, if the page has one.
  String? storyLineFor(StoryProfile profile) {
    final line = storyLine;
    return line == null ? null : profile.fill(line);
  }
}

/// Whether a story is finished, or only holds a place for a later one.
enum QuestionStoryStatus {
  ready,
  placeholder;

  static QuestionStoryStatus fromJson(String value) {
    return value == 'ready'
        ? QuestionStoryStatus.ready
        : QuestionStoryStatus.placeholder;
  }
}

/// A social story: its pictures in order, and optional practice questions.
class QuestionStory {
  const QuestionStory({
    required this.id,
    required this.title,
    required this.status,
    required this.pages,
    this.practicePages = const [],
  });

  factory QuestionStory.fromJson(Map<String, dynamic> json) {
    return QuestionStory(
      id: json['id'] as String,
      title: json['title'] as String,
      status: QuestionStoryStatus.fromJson(json['status'] as String),
      pages: _pagesFrom(json['pages']),
      practicePages: _pagesFrom(json['practice']),
    );
  }

  final String id;
  final String title;
  final QuestionStoryStatus status;
  final List<QuestionPage> pages;
  final List<QuestionPage> practicePages;

  bool get isReady => status == QuestionStoryStatus.ready;

  static List<QuestionPage> _pagesFrom(Object? json) {
    if (json == null) return const [];
    return [
      for (final page in json as List<dynamic>)
        QuestionPage.fromJson(page as Map<String, dynamic>),
    ];
  }
}

/// Everything in `stories.json`.
class QuestionStoryLibrary {
  const QuestionStoryLibrary({
    required this.defaultProfile,
    required this.myStoryTitle,
    required this.myStoryButton,
    required this.stories,
  });

  factory QuestionStoryLibrary.fromJson(Map<String, dynamic> json) {
    final defaults = json['defaults'] as Map<String, dynamic>;
    final myStory = json['myStory'] as Map<String, dynamic>;
    return QuestionStoryLibrary(
      defaultProfile: StoryProfile(
        childName: defaults['childName'] as String,
        friendName: defaults['friendName'] as String,
      ),
      myStoryTitle: myStory['title'] as String,
      myStoryButton: myStory['button'] as String,
      stories: [
        for (final story in json['stories'] as List<dynamic>)
          QuestionStory.fromJson(story as Map<String, dynamic>),
      ],
    );
  }

  /// The names used until the parents enter the real ones.
  final StoryProfile defaultProfile;

  /// May contain the `{child}` name marker.
  final String myStoryTitle;

  final String myStoryButton;

  final List<QuestionStory> stories;

  /// Looks a story up by its id, or returns null if there is none.
  QuestionStory? storyById(String id) {
    for (final story in stories) {
      if (story.id == id) return story;
    }
    return null;
  }
}
