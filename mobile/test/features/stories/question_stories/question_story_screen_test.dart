import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/stories/question_stories/question_stories_texts.dart';
import 'package:grad_project/features/stories/question_stories/screens/question_story_screen.dart';
import 'package:grad_project/features/stories/stories_texts.dart';

import 'question_story_test_data.dart';

void main() {
  // A tall screen, so every button is on screen without scrolling.
  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> openStory(WidgetTester tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(
      const MaterialApp(
        home: QuestionStoryScreen(
          story: sampleStory,
          profile: sampleProfile,
          myStoryTitle: sampleMyStoryTitle,
        ),
      ),
    );
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the first question with the real names', (tester) async {
    await openStory(tester);

    expect(find.text('Where is Youssef?'), findsOneWidget);
  });

  testWidgets('a wrong answer asks to try again and tells nothing', (
    tester,
  ) async {
    await openStory(tester);

    await tapText(tester, 'wrong one');

    expect(find.text(QuestionStoriesTexts.tryAgain), findsOneWidget);
    expect(find.text('Omar saw Youssef.'), findsNothing);
  });

  testWidgets('a correct answer shows the sentence the child tells', (
    tester,
  ) async {
    await openStory(tester);

    await tapText(tester, 'right one');

    expect(find.text('Omar saw Youssef.'), findsOneWidget);
  });

  testWidgets('the next button moves to the next question', (tester) async {
    await openStory(tester);

    await tapText(tester, 'right one');
    await tapText(tester, StoriesTexts.next);

    expect(find.text('Second?'), findsOneWidget);
  });

  testWidgets('finishing shows the whole story in the child words', (
    tester,
  ) async {
    await openStory(tester);

    await tapText(tester, 'right one');
    await tapText(tester, StoriesTexts.next);
    await tapText(tester, 'second right');
    await tapText(tester, StoriesTexts.next);
    await tapText(tester, 'practice right');
    await tapText(tester, StoriesTexts.finish);

    expect(find.text('Omar story'), findsOneWidget);
    expect(find.text('Omar saw Youssef.'), findsOneWidget);
    expect(find.text('Second line.'), findsOneWidget);
  });
}
