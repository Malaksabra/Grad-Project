import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/data/level_storage.dart';
import 'package:grad_project/features/games/games_texts.dart';
import 'package:grad_project/features/games/logic/games_settings.dart';
import 'package:grad_project/features/games/models/game_kind.dart';
import 'package:grad_project/features/games/models/game_level.dart';
import 'package:grad_project/features/games/screens/levels_screen.dart';

void main() {
  late GamesSettings settings;
  int? played;

  setUp(() {
    settings = GamesSettings(InMemoryLevelStorage());
    played = null;
  });

  Future<void> pumpLevels(
    WidgetTester tester, {
    GameKind game = GameKind.memory,
    DateTime? now,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: LevelsScreen(
          game: game,
          settings: settings,
          onPlay: (i) => played = i,
          now: () => now ?? DateTime(2026, 11, 7, 10),
        ),
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

  testWidgets('the puzzle levels show pieces and time', (tester) async {
    await pumpLevels(tester, game: GameKind.puzzle);

    expect(find.text(GamesTexts.puzzleTitle), findsOneWidget);
    expect(
      find.text('${GamesTexts.piecesCount(4)}${GamesTexts.summarySeparator}'),
      findsOneWidget,
    );
    expect(find.text('2:00'), findsOneWidget);
  });

  testWidgets('the odd one out levels show rounds and time', (tester) async {
    await pumpLevels(tester, game: GameKind.oddOneOut);

    for (final rounds in [3, 4, 5]) {
      expect(
        find.text(
          '${GamesTexts.roundsCount(rounds)}${GamesTexts.summarySeparator}',
        ),
        findsOneWidget,
      );
    }
    expect(find.text('1:30'), findsOneWidget);
    expect(find.text('2:00'), findsOneWidget);
    expect(find.text('3:00'), findsOneWidget);
  });

  testWidgets('the first level of memory is the chosen one at the start', (
    tester,
  ) async {
    await pumpLevels(tester);

    expect(find.text(GamesTexts.chosenForChild), findsOneWidget);
    expect(find.text(GamesTexts.chooseForChild), findsNWidgets(2));
  });

  testWidgets('another game shows no chosen level at the start', (
    tester,
  ) async {
    await pumpLevels(tester, game: GameKind.puzzle);

    expect(find.text(GamesTexts.chosenForChild), findsNothing);
    expect(find.text(GamesTexts.chooseForChild), findsNWidgets(3));
  });

  testWidgets('choosing a level for the child updates the settings', (
    tester,
  ) async {
    await pumpLevels(tester);

    // The first button that says "choose" belongs to the second level.
    await tester.tap(find.text(GamesTexts.chooseForChild).first);
    await tester.pumpAndSettle();

    expect(settings.selectedGame, GameKind.memory);
    expect(settings.selectedLevel, 1);
    expect(find.text(GamesTexts.chosenForChild), findsOneWidget);
    expect(find.text(GamesTexts.chooseForChild), findsNWidgets(2));
  });

  testWidgets('choosing a puzzle level changes the chosen game too', (
    tester,
  ) async {
    await pumpLevels(tester, game: GameKind.puzzle);

    await tester.tap(find.text(GamesTexts.chooseForChild).first);
    await tester.pumpAndSettle();

    expect(settings.selectedGame, GameKind.puzzle);
    expect(settings.selectedLevel, 0);
    expect(find.text(GamesTexts.chosenForChild), findsOneWidget);
  });

  testWidgets('tapping a level asks to play it', (tester) async {
    await pumpLevels(tester);

    await tester.tap(find.text(GamesTexts.levelTitle(2)));
    await tester.pump();

    expect(played, 2);
  });

  testWidgets('tells the parents when the child finished today', (
    tester,
  ) async {
    await settings.markFinished('2026-11-07');
    await pumpLevels(tester);

    expect(find.text(GamesTexts.finishedNotice), findsOneWidget);
  });

  testWidgets('shows no note the next day or when the child did not play', (
    tester,
  ) async {
    await pumpLevels(tester);
    expect(find.text(GamesTexts.finishedNotice), findsNothing);

    await settings.markFinished('2026-11-07');
    await pumpLevels(tester, now: DateTime(2026, 11, 8, 9));
    expect(find.text(GamesTexts.finishedNotice), findsNothing);
  });

  testWidgets('the parents can still choose, for the next day', (tester) async {
    await settings.markFinished('2026-11-07');
    await pumpLevels(tester);

    await tester.tap(find.text(GamesTexts.chooseForChild).first);
    await tester.pumpAndSettle();

    expect(settings.selectedLevel, 1);
    expect(settings.isFinishedOn('2026-11-07'), isTrue);
  });
}
