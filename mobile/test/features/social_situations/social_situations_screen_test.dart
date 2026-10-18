import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/social_situations/screens/social_situations_screen.dart';
import 'package:grad_project/features/social_situations/social_activities.dart';
import 'package:grad_project/features/social_situations/social_situations_texts.dart';
import 'package:grad_project/features/social_situations/widgets/activity_card.dart';

void main() {
  testWidgets('shows the section title and every activity', (tester) async {
    // A phone-sized screen, so the whole grid fits.
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: SocialSituationsScreen()));

    expect(find.text(SocialSituationsTexts.sectionTitle), findsOneWidget);
    expect(find.byType(ActivityCard), findsNWidgets(socialActivities.length));
  });
}
