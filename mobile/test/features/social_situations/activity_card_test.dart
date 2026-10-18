import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/social_situations/social_situations_colors.dart';
import 'package:grad_project/features/social_situations/widgets/activity_card.dart';

void main() {
  testWidgets('ActivityCard shows its title and reports taps', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(
            title: 'Play',
            icon: const Icon(Icons.sports_soccer),
            backgroundColor: SocialSituationsColors.background,
            edgeColor: SocialSituationsColors.edge,
            textColor: SocialSituationsColors.text,
            onTap: () {
              tapCount++;
            },
          ),
        ),
      ),
    );

    expect(find.text('Play'), findsOneWidget);

    await tester.tap(find.byType(ActivityCard));
    expect(tapCount, 1);
  });
}
