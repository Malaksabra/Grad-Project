import '../models/question_story_models.dart';
import '../models/story_profile.dart';

/// What happened when the child tapped an answer.
enum AnswerResult { correct, wrong, ignored }

/// Follows one child through one story: the current page, the answers
/// tried, and the sentences the child has "told" so far.
///
/// It holds no widgets, so the rules of the story can be tested alone.
/// Practice questions come after the story pages and tell no sentence.
class QuestionStorySession {
  QuestionStorySession({required QuestionStory story, required this.profile})
    : _steps = [...story.pages, ...story.practicePages];

  final StoryProfile profile;
  final List<QuestionPage> _steps;
  final List<String> _toldLines = [];
  final Set<int> _wrongChoices = {};

  int _stepIndex = 0;
  int? _correctIndex;

  int get stepCount => _steps.length;
  int get stepIndex => _stepIndex;
  QuestionPage get currentPage => _steps[_stepIndex];

  bool get isLastStep => _stepIndex == _steps.length - 1;
  bool get isAnswered => _correctIndex != null;
  bool get hasWrongAnswer => _wrongChoices.isNotEmpty;

  /// The choice the child answered correctly, or null before that.
  int? get correctIndex => _correctIndex;

  /// The sentences told so far, in order, with the real names filled in.
  List<String> get toldLines => List.unmodifiable(_toldLines);

  /// The sentence of the current page, or null on a practice question.
  String? get currentLine => currentPage.storyLineFor(profile);

  bool isWrong(int choiceIndex) => _wrongChoices.contains(choiceIndex);

  AnswerResult choose(int choiceIndex) {
    if (isAnswered || isWrong(choiceIndex)) return AnswerResult.ignored;

    if (currentPage.choices[choiceIndex].isCorrect) {
      _correctIndex = choiceIndex;
      final line = currentLine;
      if (line != null) _toldLines.add(line);
      return AnswerResult.correct;
    }

    _wrongChoices.add(choiceIndex);
    return AnswerResult.wrong;
  }

  /// Moves to the next page. Does nothing until the question is answered,
  /// and on the last page.
  void next() {
    if (!isAnswered || isLastStep) return;

    _stepIndex++;
    _correctIndex = null;
    _wrongChoices.clear();
  }
}
