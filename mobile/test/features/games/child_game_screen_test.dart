import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/data/level_storage.dart';
import 'package:grad_project/features/games/games_texts.dart';
import 'package:grad_project/features/games/models/child_choice.dart';
import 'package:grad_project/features/games/models/game_kind.dart';
import 'package:grad_project/features/games/screens/child_game_screen.dart';
import 'package:grad_project/features/games/screens/game_launcher.dart';
import 'package:grad_project/features/games/screens/memory_game_screen.dart';
import 'package:grad_project/features/games/screens/odd_one_out_game_screen.dart';
import 'package:grad_project/features/games/screens/puzzle_game_screen.dart';

final DateTime _today = DateTime(2026, 11, 7, 10);
final DateTime _tomorrow = DateTime(2026, 11, 8, 9);

void main() {
  Future<void> pumpChild(
    WidgetTester tester,
    LevelStorage storage, {
    DateTime? now,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: ChildGameScreen(storage: storage, now: () => now ?? _today),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('opens the game and level the parent chose', (tester) async {
    await pumpChild(
      tester,
      InMemoryLevelStorage(const ChildChoice(GameKind.puzzle, 1)),
    );

    expect(find.byType(PuzzleGameScreen), findsOneWidget);
    expect(find.text(GamesTexts.levelTitle(1)), findsOneWidget);
  });

  testWidgets('opens the odd one out game when it was chosen', (tester) async {
    await pumpChild(
      tester,
      InMemoryLevelStorage(const ChildChoice(GameKind.oddOneOut, 2)),
    );

    expect(find.byType(OddOneOutGameScreen), findsOneWidget);
  });

  testWidgets('opens the first memory level when nothing was chosen', (
    tester,
  ) async {
    await pumpChild(tester, InMemoryLevelStorage());

    expect(find.byType(MemoryGameScreen), findsOneWidget);
    expect(find.text(GamesTexts.levelTitle(0)), findsOneWidget);
  });

  testWidgets('shows no list of games and no level choices', (tester) async {
    await pumpChild(tester, InMemoryLevelStorage());

    expect(find.text(GamesTexts.chooseForChild), findsNothing);
    expect(find.text(GamesTexts.puzzleTitle), findsNothing);
    expect(find.text(GamesTexts.oddOneOutTitle), findsNothing);
  });

  testWidgets('the game is the child version: the time up panel has no retry', (
    tester,
  ) async {
    await pumpChild(tester, InMemoryLevelStorage());

    await tester.tap(find.byKey(const ValueKey('card_0')));
    await tester.pump(const Duration(seconds: 125));

    expect(find.text(GamesTexts.timeUp), findsOneWidget);
    expect(find.text(GamesTexts.timeUpTomorrow), findsOneWidget);
    expect(find.text(GamesTexts.tryAgain), findsNothing);
    expect(find.text(GamesTexts.tryAgainQuestion), findsNothing);
    expect(find.text(GamesTexts.exit), findsOneWidget);
  });

  testWidgets('when the time is up the day is saved as finished', (
    tester,
  ) async {
    final storage = InMemoryLevelStorage();
    await pumpChild(tester, storage);

    await tester.tap(find.byKey(const ValueKey('card_0')));
    await tester.pump(const Duration(seconds: 125));

    expect(await storage.readFinishedDay(), '2026-11-07');
    // The child still sees the end of the round, not the "done" page.
    expect(find.text(GamesTexts.timeUp), findsOneWidget);
  });

  testWidgets('leaving the game halfway does not lock it', (tester) async {
    final storage = InMemoryLevelStorage();
    await pumpChild(tester, storage);

    await tester.tap(find.byKey(const ValueKey('card_0')));
    await tester.pump(const Duration(seconds: 10));

    expect(await storage.readFinishedDay(), isNull);
  });

  testWidgets('after finishing, the same day shows only the done page', (
    tester,
  ) async {
    await pumpChild(tester, InMemoryLevelStorage(null, '2026-11-07'));

    expect(find.text(GamesTexts.childDoneTitle), findsOneWidget);
    expect(find.text(GamesTexts.childDoneSubtitle), findsOneWidget);
    expect(find.byType(MemoryGameScreen), findsNothing);
    expect(find.byKey(const ValueKey('card_0')), findsNothing);
  });

  testWidgets('the next day the game opens again', (tester) async {
    await pumpChild(
      tester,
      InMemoryLevelStorage(null, '2026-11-07'),
      now: _tomorrow,
    );

    expect(find.byType(MemoryGameScreen), findsOneWidget);
    expect(find.text(GamesTexts.childDoneTitle), findsNothing);
  });

  testWidgets('the exit button of the done page closes it', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final storage = InMemoryLevelStorage(null, '2026-11-07');

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    ChildGameScreen(storage: storage, now: () => _today),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text(GamesTexts.childDoneTitle), findsOneWidget);

    await tester.tap(find.text(GamesTexts.exit));
    await tester.pumpAndSettle();

    expect(find.text(GamesTexts.childDoneTitle), findsNothing);
  });

  group('buildGameScreen', () {
    testWidgets('gives the right page for every game', (tester) async {
      expect(buildGameScreen(GameKind.memory, 0), isA<MemoryGameScreen>());
      expect(buildGameScreen(GameKind.puzzle, 0), isA<PuzzleGameScreen>());
      expect(
        buildGameScreen(GameKind.oddOneOut, 0),
        isA<OddOneOutGameScreen>(),
      );
    });

    testWidgets('the child version reports the end only once', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var reports = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: MemoryGameScreen(
            levelIndex: 0,
            random: Random(1),
            isForChild: true,
            onFinished: () => reports++,
          ),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('card_0')));
      await tester.pump(const Duration(seconds: 125));
      await tester.pump(const Duration(seconds: 10));

      expect(reports, 1);
    });
  });
}
