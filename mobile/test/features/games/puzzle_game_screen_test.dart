import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/games_images.dart';
import 'package:grad_project/features/games/games_texts.dart';
import 'package:grad_project/features/games/logic/puzzle_game.dart';
import 'package:grad_project/features/games/models/puzzle_level.dart';
import 'package:grad_project/features/games/screens/puzzle_game_screen.dart';

const int _seed = 7;
const int _levelIndex = 0;

/// The same deal the screen gets, because the seed is the same.
PuzzleGame _expectedGame() {
  final level = PuzzleLevel.all[_levelIndex];
  return PuzzleGame(
    images: GamesImages.fruits,
    rows: level.rows,
    columns: level.columns,
    seconds: level.seconds,
    random: Random(_seed),
  );
}

Finder _piece(int position) => find.byKey(ValueKey('piece_$position'));

Widget _screen() => MaterialApp(
  home: PuzzleGameScreen(levelIndex: _levelIndex, random: Random(_seed)),
);

Future<void> _tapPiece(WidgetTester tester, int position) async {
  await tester.tap(_piece(position));
  await tester.pump();
}

void _useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// The pairs of positions to tap to finish the picture.
List<List<int>> _solution(PuzzleGame game) {
  final order = [for (var i = 0; i < game.pieceCount; i++) game.pieceAt(i)];
  final swaps = <List<int>>[];
  for (var position = 0; position < order.length; position++) {
    if (order[position] == position) continue;
    final home = order.indexOf(position);
    swaps.add([position, home]);
    final moved = order[position];
    order[position] = order[home];
    order[home] = moved;
  }
  return swaps;
}

void main() {
  testWidgets('starts with the full time, the start message and the pieces', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    expect(find.text(GamesTexts.puzzleMessageStart), findsOneWidget);
    expect(find.text('2:00'), findsOneWidget);
    for (var i = 0; i < PuzzleLevel.all[_levelIndex].pieceCount; i++) {
      expect(_piece(i), findsOneWidget);
    }
  });

  testWidgets('the time runs only after the first piece is chosen', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await tester.pump(const Duration(seconds: 10));
    expect(find.text('2:00'), findsOneWidget);

    await _tapPiece(tester, 0);
    expect(find.text(GamesTexts.puzzleMessageSecond), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('1:55'), findsOneWidget);
  });

  testWidgets('tapping the chosen piece again cancels the choice', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await _tapPiece(tester, 1);
    await _tapPiece(tester, 1);

    expect(find.text(GamesTexts.puzzleMessageCancel), findsOneWidget);
  });

  testWidgets('finishing the picture shows the win panel and plays again', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    for (final swap in _solution(_expectedGame())) {
      await _tapPiece(tester, swap[0]);
      await _tapPiece(tester, swap[1]);
    }

    expect(find.text(GamesTexts.won), findsOneWidget);

    await tester.tap(find.text(GamesTexts.playAgain));
    await tester.pump();

    expect(find.text(GamesTexts.won), findsNothing);
    expect(find.text(GamesTexts.puzzleMessageStart), findsOneWidget);
    expect(find.text('2:00'), findsOneWidget);
  });

  testWidgets('when the time is up it shows the time-up panel', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await _tapPiece(tester, 0);
    await tester.pump(const Duration(seconds: 125));

    expect(find.text(GamesTexts.timeUp), findsOneWidget);
    expect(find.text('0:00'), findsOneWidget);
  });

  testWidgets('the game panel fills the screen under the top bar', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    final board = tester.getRect(_piece(0));
    final lastPiece = tester.getRect(
      _piece(PuzzleLevel.all[_levelIndex].pieceCount - 1),
    );

    // The pieces are tall, because they share all the free height.
    expect(lastPiece.bottom - board.top, greaterThan(800));
  });

  testWidgets(
    'after winning, every piece is still on screen next to the panel',
    (tester) async {
      _useTallScreen(tester);
      await tester.pumpWidget(_screen());

      for (final swap in _solution(_expectedGame())) {
        await _tapPiece(tester, swap[0]);
        await _tapPiece(tester, swap[1]);
      }
      // Wait: the finished picture must not go away by itself.
      await tester.pump(const Duration(seconds: 30));

      expect(find.text(GamesTexts.won), findsOneWidget);
      for (var i = 0; i < PuzzleLevel.all[_levelIndex].pieceCount; i++) {
        expect(_piece(i), findsOneWidget);
      }
      final lastPiece = tester.getRect(_piece(3));
      final panel = tester.getRect(find.text(GamesTexts.won));
      // The panel is under the picture, not on top of it.
      expect(panel.top, greaterThanOrEqualTo(lastPiece.bottom));
    },
  );

  testWidgets('for the child there is no play again after winning', (
    tester,
  ) async {
    _useTallScreen(tester);
    var finished = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: PuzzleGameScreen(
          levelIndex: _levelIndex,
          random: Random(_seed),
          isForChild: true,
          onFinished: () => finished++,
        ),
      ),
    );

    for (final swap in _solution(_expectedGame())) {
      await _tapPiece(tester, swap[0]);
      await _tapPiece(tester, swap[1]);
    }

    expect(find.text(GamesTexts.won), findsOneWidget);
    expect(find.text(GamesTexts.playAgain), findsNothing);
    expect(find.text(GamesTexts.exit), findsOneWidget);
    expect(finished, 1);
  });
}
