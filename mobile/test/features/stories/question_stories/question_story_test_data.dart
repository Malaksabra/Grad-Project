import 'package:grad_project/features/stories/question_stories/models/question_story_models.dart';
import 'package:grad_project/features/stories/question_stories/models/story_profile.dart';

/// A tiny story for the tests: two story pages and one practice question.
/// The English texts keep the tests easy to read.
const StoryProfile sampleProfile = StoryProfile(
  childName: 'Omar',
  friendName: 'Youssef',
);

const String sampleMyStoryTitle = '{child} story';

const QuestionStory sampleStory = QuestionStory(
  id: 'sample',
  title: 'sample',
  status: QuestionStoryStatus.ready,
  pages: [
    QuestionPage(
      imagePath: 'a.png',
      question: 'Where is {friend}?',
      choices: [
        QuestionChoice(label: 'wrong one', isCorrect: false),
        QuestionChoice(label: 'right one', isCorrect: true),
      ],
      storyLine: '{child} saw {friend}.',
    ),
    QuestionPage(
      imagePath: 'b.png',
      question: 'Second?',
      choices: [
        QuestionChoice(label: 'second right', isCorrect: true),
        QuestionChoice(label: 'second wrong', isCorrect: false),
      ],
      storyLine: 'Second line.',
    ),
  ],
  practicePages: [
    QuestionPage(
      imagePath: 'c.png',
      question: 'Practice?',
      choices: [
        QuestionChoice(label: 'practice right', isCorrect: true),
        QuestionChoice(label: 'practice wrong', isCorrect: false),
      ],
    ),
  ],
);
