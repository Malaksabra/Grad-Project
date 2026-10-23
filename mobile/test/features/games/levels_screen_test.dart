import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/data/level_storage.dart';
import 'package:grad_project/features/games/games_texts.dart';
import 'package:grad_project/features/games/logic/games_settings.dart';
import 'package:grad_project/features/games/models/game_level.dart';
import 'package:grad_project/features/games/screens/levels_screen.dart';

void main() {
  late GamesSettings settings;
  int? played;

  setUp(() {
    settings = GamesSettings(InMemoryLevelStorage());
    played = null;
  });

  Future<void> pumpLevels(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: LevelsScreen(settings: settings, onPlay: (i) => played = i),
      ),
    );
  }

  testWidgets('shows the three levels with their cards and time', (
    tester,
  ) async {
    await pumpLevels(tester);

    for (var i = 0; i < GameLevel.all.length; i++) {
      final level = GameLevel.all[i];
      expect(find.text(GamesTexts.levelTitle(i)), findsOneWidget);
      expect(
        find.text(
          '${GamesTexts.cardsCount(level.cardCount)}'
          '${GamesTexts.summarySeparator}',
        ),
        findsOneWidget,
      );
      expect(find.text(formatTime(level.seconds)), findsOneWidget);
    }
  });

  testWidgets('the first level is the chosen one at the start', (tester) async {
    await pumpLevels(tester);

    expect(find.text(GamesTexts.chosenForChild), findsOneWidget);
    expect(find.text(GamesTexts.chooseForChild), findsNWidgets(2));
  });

  testWidgets('choosing a level for the child updates the settings', (
    tester,
  ) async {
    await pumpLevels(tester);

    // The first button that says "choose" belongs to the second level.
    await tester.tap(find.text(GamesTexts.chooseForChild).first);
    await tester.pumpAndSettle();

    expect(settings.selectedLevel, 1);
    expect(find.text(GamesTexts.chosenForChild), findsOneWidget);
    expect(find.text(GamesTexts.chooseForChild), findsNWidgets(2));
  });

  testWidgets('tapping a level asks to play it', (tester) async {
    await pumpLevels(tester);

    await tester.tap(find.text(GamesTexts.levelTitle(2)));
    await tester.pump();

    expect(played, 2);
  });
}
