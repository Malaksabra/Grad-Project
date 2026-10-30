import 'package:flutter/material.dart';

import '../logic/question_story_session.dart';
import '../models/question_story_models.dart';
import 'story_choice_button.dart';

/// The answers of one question. Choices with pictures sit side by side;
/// text-only choices are stacked, so long sentences stay readable.
class StoryChoices extends StatelessWidget {
  const StoryChoices({
    super.key,
    required this.session,
    required this.onChoose,
  });

  final QuestionStorySession session;
  final ValueChanged<int> onChoose;

  static const double _gap = 16;

  bool get _hasPictures =>
      session.currentPage.choices.any((choice) => choice.imagePath != null);

  @override
  Widget build(BuildContext context) {
    final choices = session.currentPage.choices;
    final buttons = [
      for (var index = 0; index < choices.length; index++)
        _buttonFor(index, choices[index]),
    ];

    if (_hasPictures) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < buttons.length; index++) ...[
            if (index > 0) const SizedBox(width: _gap),
            Expanded(child: buttons[index]),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < buttons.length; index++) ...[
          if (index > 0) const SizedBox(height: _gap),
          buttons[index],
        ],
      ],
    );
  }

  Widget _buttonFor(int index, QuestionChoice choice) {
    return StoryChoiceButton(
      label: choice.label,
      imagePath: choice.imagePath,
      state: _stateOf(index),
      onPressed: () => onChoose(index),
    );
  }

  StoryChoiceState _stateOf(int index) {
    if (session.correctIndex == index) return StoryChoiceState.correct;
    if (session.isAnswered || session.isWrong(index)) {
      return StoryChoiceState.unavailable;
    }
    return StoryChoiceState.idle;
  }
}
