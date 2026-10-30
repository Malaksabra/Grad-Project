import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/social_situations/screens/social_situations_screen.dart';
import 'package:grad_project/features/social_situations/social_situations_texts.dart';
import 'package:grad_project/features/stories/stories_texts.dart';

Future<void> _pumpScreen(WidgetTester tester, {String? title}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: SocialSituationsScreen(onBack: () {}, title: title),
    ),
  );
}

void main() {
  testWidgets('shows the default section title', (tester) async {
    await _pumpScreen(tester);

    expect(find.text(SocialSituationsTexts.sectionTitle), findsOneWidget);
  });

  testWidgets('shows the given title instead of the default one', (
    tester,
  ) async {
    await _pumpScreen(tester, title: StoriesTexts.sectionTitle);

    expect(find.text(StoriesTexts.sectionTitle), findsOneWidget);
    expect(find.text(SocialSituationsTexts.sectionTitle), findsNothing);
  });
}
