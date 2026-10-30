import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/stories/question_stories/models/story_profile.dart';
import 'package:grad_project/features/stories/question_stories/question_stories_texts.dart';
import 'package:grad_project/features/stories/question_stories/screens/story_profile_screen.dart';

void main() {
  const startingProfile = StoryProfile(
    childName: 'Omar',
    friendName: 'Youssef',
  );

  // Opens the screen from a button and keeps what it gives back.
  Future<void> openScreen(
    WidgetTester tester,
    void Function(StoryProfile?) onResult,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push<StoryProfile>(
                    MaterialPageRoute<StoryProfile>(
                      builder: (_) => const StoryProfileScreen(
                        initialProfile: startingProfile,
                      ),
                    ),
                  );
                  onResult(result);
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('starts with the names it was given', (tester) async {
    await openScreen(tester, (_) {});

    expect(find.text('Omar'), findsOneWidget);
    expect(find.text('Youssef'), findsOneWidget);
  });

  testWidgets('gives back the names the parents typed', (tester) async {
    StoryProfile? result;
    await openScreen(tester, (profile) => result = profile);

    await tester.enterText(find.byType(TextField).first, 'Salma');
    await tester.enterText(find.byType(TextField).last, 'Mariam');
    await tester.tap(find.text(QuestionStoriesTexts.saveAndStart));
    await tester.pumpAndSettle();

    expect(
      result,
      const StoryProfile(childName: 'Salma', friendName: 'Mariam'),
    );
  });

  testWidgets('keeps the starting name when a field is left empty', (
    tester,
  ) async {
    StoryProfile? result;
    await openScreen(tester, (profile) => result = profile);

    await tester.enterText(find.byType(TextField).first, '   ');
    await tester.tap(find.text(QuestionStoriesTexts.saveAndStart));
    await tester.pumpAndSettle();

    expect(result, startingProfile);
  });
}
