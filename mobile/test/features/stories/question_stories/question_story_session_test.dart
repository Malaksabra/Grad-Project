import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/stories/question_stories/logic/question_story_session.dart';

import 'question_story_test_data.dart';

QuestionStorySession _newSession() {
  return QuestionStorySession(story: sampleStory, profile: sampleProfile);
}

void main() {
  test('starts on the first page, not answered', () {
    final session = _newSession();

    expect(session.stepIndex, 0);
    expect(session.stepCount, 3);
    expect(session.isAnswered, isFalse);
    expect(session.hasWrongAnswer, isFalse);
  });

  test('a wrong answer does not finish the question', () {
    final session = _newSession();

    final result = session.choose(0);

    expect(result, AnswerResult.wrong);
    expect(session.isWrong(0), isTrue);
    expect(session.isAnswered, isFalse);
    expect(session.hasWrongAnswer, isTrue);
    expect(session.toldLines, isEmpty);
  });

  test('ignores the same wrong answer when tapped again', () {
    final session = _newSession()..choose(0);

    expect(session.choose(0), AnswerResult.ignored);
  });

  test('a correct answer tells the sentence with the real names', () {
    final session = _newSession();

    final result = session.choose(1);

    expect(result, AnswerResult.correct);
    expect(session.isAnswered, isTrue);
    expect(session.correctIndex, 1);
    expect(session.toldLines, ['Omar saw Youssef.']);
  });

  test('still accepts the right answer after a wrong one', () {
    final session = _newSession()
      ..choose(0)
      ..choose(1);

    expect(session.isAnswered, isTrue);
    expect(session.toldLines, ['Omar saw Youssef.']);
  });

  test('ignores more taps once the question is answered', () {
    final session = _newSession()..choose(1);

    expect(session.choose(0), AnswerResult.ignored);
    expect(session.toldLines, hasLength(1));
  });

  test('does not move on before the question is answered', () {
    final session = _newSession()..next();

    expect(session.stepIndex, 0);
  });

  test('moves on after a correct answer and forgets the old mistakes', () {
    final session = _newSession()
      ..choose(0)
      ..choose(1)
      ..next();

    expect(session.stepIndex, 1);
    expect(session.isAnswered, isFalse);
    expect(session.hasWrongAnswer, isFalse);
    expect(session.correctIndex, isNull);
  });

  test('practice questions tell no sentence', () {
    final session = _newSession()
      ..choose(1)
      ..next()
      ..choose(0)
      ..next();

    expect(session.currentLine, isNull);

    session.choose(0);

    expect(session.isAnswered, isTrue);
    expect(session.toldLines, ['Omar saw Youssef.', 'Second line.']);
  });

  test('stays on the last page when asked to move on', () {
    final session = _newSession()
      ..choose(1)
      ..next()
      ..choose(0)
      ..next()
      ..choose(0);

    expect(session.isLastStep, isTrue);

    session.next();

    expect(session.stepIndex, 2);
  });
}
