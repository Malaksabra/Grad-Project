// Arabic texts of the question stories, kept in one place.
class QuestionStoriesTexts {
  const QuestionStoriesTexts._();

  static const String profileTitle =
      '\u0623\u0633\u0645\u0627\u0621 \u0627\u0644\u0642\u0635\u0629';
  static const String profileHint =
      '\u0627\u0643\u062A\u0628\u0648\u0627 \u0627\u0633\u0645 \u0627\u0644\u0637\u0641\u0644 \u0648\u0627\u0633\u0645 \u0635\u0627\u062D\u0628\u0647\u060C \u0648\u0647\u064A\u0638\u0647\u0631\u0648\u0627 \u062C\u0648\u0647 \u0627\u0644\u0642\u0635\u0629.';
  static const String childNameLabel =
      '\u0627\u0633\u0645 \u0627\u0644\u0637\u0641\u0644';
  static const String friendNameLabel =
      '\u0627\u0633\u0645 \u0627\u0644\u0635\u0627\u062D\u0628';
  static const String saveAndStart =
      '\u062D\u0641\u0638 \u0648\u0627\u0628\u062F\u0623';
  static const String tryAgain =
      '\u0646\u062C\u0631\u0651\u0628 \u062A\u0627\u0646\u064A';
  static const String loadError =
      '\u062D\u0635\u0644\u062A \u0645\u0634\u0643\u0644\u0629\u060C \u062C\u0631\u0651\u0628 \u062A\u0627\u0646\u064A.';

  /// Short praise for practice questions. They take turns, so the child
  /// does not hear the same word every time.
  static const List<String> praises = [
    '\u0628\u0631\u0627\u0641\u0648 \u0639\u0644\u064A\u0643!',
    '\u0634\u0627\u0637\u0631!',
    '\u0623\u062D\u0633\u0646\u062A!',
  ];
}
