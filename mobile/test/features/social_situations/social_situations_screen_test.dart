import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/social_situations/screens/social_situations_screen.dart';
import 'package:grad_project/features/social_situations/social_activities.dart';
import 'package:grad_project/features/social_situations/social_situations_texts.dart';
import 'package:grad_project/features/social_situations/widgets/activity_card.dart';

void main() {
  // A phone-sized screen, so the layout is tested like on a real device.
  void useSmallPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows the section title and every activity', (tester) async {
    useSmallPhone(tester);

    await tester.pumpWidget(const MaterialApp(home: SocialSituationsScreen()));

    expect(find.text(SocialSituationsTexts.sectionTitle), findsOneWidget);
    expect(find.byType(ActivityCard), findsNWidgets(socialActivities.length));
  });

  testWidgets('does not overflow when the text size is doubled', (
    tester,
  ) async {
    useSmallPhone(tester);
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const MaterialApp(home: SocialSituationsScreen()));

    // Any layout overflow makes the test fail on its own.
    expect(tester.takeException(), isNull);
  });
}
