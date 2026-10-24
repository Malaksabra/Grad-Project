import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/games_texts.dart';
import 'package:grad_project/features/games/screens/games_screen.dart';

void main() {
  testWidgets('shows the section header and the memory cards game', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GamesScreen()));

    expect(find.text(GamesTexts.sectionTitle), findsOneWidget);
    expect(find.text(GamesTexts.sectionSubtitle), findsOneWidget);
    expect(find.text(GamesTexts.memoryCardsTitle), findsOneWidget);
  });

  testWidgets('opens the levels page, then a level to play', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: GamesScreen()));

    await tester.tap(find.text(GamesTexts.memoryCardsTitle));
    await tester.pumpAndSettle();
    expect(find.text(GamesTexts.levelsTitle), findsOneWidget);

    await tester.tap(find.text(GamesTexts.levelTitle(0)));
    await tester.pumpAndSettle();
    expect(find.text(GamesTexts.gameGuide), findsOneWidget);
  });

  testWidgets('the back button of a page returns to the one before', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GamesScreen()));

    await tester.tap(find.text(GamesTexts.memoryCardsTitle));
    await tester.pumpAndSettle();
    expect(find.text(GamesTexts.levelsTitle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    expect(find.text(GamesTexts.levelsTitle), findsNothing);
    expect(find.text(GamesTexts.sectionSubtitle), findsOneWidget);
  });
}
