import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/social_situations/models/story.dart';
import 'package:grad_project/features/social_situations/models/story_page.dart';
import 'package:grad_project/features/social_situations/screens/story_viewer_screen.dart';
import 'package:grad_project/features/social_situations/social_situations_texts.dart';
import 'package:grad_project/features/social_situations/widgets/story_navigation_button.dart';

const _story = Story(
  id: 'sample',
  title: 'Sample',
  pages: [
    StoryPage(imagePath: 'assets/missing/p1.png', text: 'One'),
    StoryPage(imagePath: 'assets/missing/p2.png', text: 'Two'),
    StoryPage(imagePath: 'assets/missing/p3.png', text: 'Three'),
  ],
);

/// Opens the viewer from another screen, so closing it can be tested.
Future<void> _openViewer(WidgetTester tester) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const StoryViewerScreen(story: _story),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('starts on the first page with previous disabled', (
    tester,
  ) async {
    await _openViewer(tester);

    expect(find.text('One'), findsOneWidget);
    final previous = tester.widget<StoryNavigationButton>(
      find.widgetWithText(
        StoryNavigationButton,
        SocialSituationsTexts.previous,
      ),
    );
    expect(previous.onPressed, isNull);
  });

  testWidgets('next moves through the pages and the last one says finish', (
    tester,
  ) async {
    await _openViewer(tester);

    await tester.tap(find.text(SocialSituationsTexts.next));
    await tester.pump();
    expect(find.text('Two'), findsOneWidget);

    await tester.tap(find.text(SocialSituationsTexts.next));
    await tester.pump();
    expect(find.text('Three'), findsOneWidget);
    expect(find.text(SocialSituationsTexts.finish), findsOneWidget);
    expect(find.text(SocialSituationsTexts.next), findsNothing);
  });

  testWidgets('finish closes the story', (tester) async {
    await _openViewer(tester);

    await tester.tap(find.text(SocialSituationsTexts.next));
    await tester.pump();
    await tester.tap(find.text(SocialSituationsTexts.next));
    await tester.pump();
    await tester.tap(find.text(SocialSituationsTexts.finish));
    await tester.pumpAndSettle();

    expect(find.byType(StoryViewerScreen), findsNothing);
  });

  testWidgets('does not overflow when the text size is doubled', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _openViewer(tester);

    expect(tester.takeException(), isNull);
  });
}
