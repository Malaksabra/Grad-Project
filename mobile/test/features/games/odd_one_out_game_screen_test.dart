import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/games_images.dart';
import 'package:grad_project/features/games/games_texts.dart';
import 'package:grad_project/features/games/logic/odd_one_out_game.dart';
import 'package:grad_project/features/games/models/odd_one_out_level.dart';
import 'package:grad_project/features/games/screens/odd_one_out_game_screen.dart';

const int _seed = 7;
const int _levelIndex = 0;

/// The same game the screen has, because the seed is the same.
OddOneOutGame _mirror() {
  final level = OddOneOutLevel.all[_levelIndex];
  return OddOneOutGame(
    groupA: GamesImages.fruits,
    groupB: GamesImages.vegetables,
    itemsPerRound: level.items,
    rounds: level.rounds,
    seconds: level.seconds,
    random: Random(_seed),
  );
}

Widget _screen() => MaterialApp(
  home: OddOneOutGameScreen(levelIndex: _levelIndex, random: Random(_seed)),
);

Future<void> _tapItem(WidgetTester tester, int index) async {
  await tester.tap(find.byKey(ValueKey('item_$index')));
  await tester.pump();
}

void _useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

int _odd(OddOneOutGame game) => game.items.indexWhere((i) => i.isOdd);

void main() {
  testWidgets('shows the first round and every picture', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    expect(find.text(GamesTexts.oddMessageStart), findsOneWidget);
    expect(find.text(GamesTexts.roundOf(1, 3)), findsOneWidget);
    for (var i = 0; i < OddOneOutLevel.all[_levelIndex].items; i++) {
      expect(find.byKey(ValueKey('item_$i')), findsOneWidget);
    }
  });

  testWidgets('a wrong picture gives a kind message and the round goes on', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());
    final wrong = _mirror().items.indexWhere((i) => !i.isOdd);

    await _tapItem(tester, wrong);

    expect(find.text(GamesTexts.oddMessageWrong), findsOneWidget);
    expect(find.text(GamesTexts.roundOf(1, 3)), findsOneWidget);
  });

  testWidgets('the right picture moves to the next round after a pause', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await _tapItem(tester, _odd(_mirror()));
    expect(find.text(GamesTexts.oddMessageCorrect), findsOneWidget);
    expect(find.text(GamesTexts.roundOf(1, 3)), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));

    expect(find.text(GamesTexts.roundOf(2, 3)), findsOneWidget);
    expect(find.text(GamesTexts.oddMessageStart), findsOneWidget);
  });

  testWidgets('finding the different picture in every round wins', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());
    final mirror = _mirror();
    final rounds = OddOneOutLevel.all[_levelIndex].rounds;

    for (var round = 0; round < rounds; round++) {
      await _tapItem(tester, _odd(mirror));
      mirror.pick(_odd(mirror));
      mirror.nextRound();
      await tester.pump(const Duration(milliseconds: 1300));
    }

    expect(find.text(GamesTexts.won), findsOneWidget);

    await tester.tap(find.text(GamesTexts.playAgain));
    await tester.pump();

    expect(find.text(GamesTexts.won), findsNothing);
    expect(find.text(GamesTexts.roundOf(1, 3)), findsOneWidget);
  });

  testWidgets('for the child there is no play again, and the end is reported', (
    tester,
  ) async {
    _useTallScreen(tester);
    var finished = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: OddOneOutGameScreen(
          levelIndex: _levelIndex,
          random: Random(_seed),
          isForChild: true,
          onFinished: () => finished++,
        ),
      ),
    );
    final mirror = _mirror();
    final rounds = OddOneOutLevel.all[_levelIndex].rounds;

    for (var round = 0; round < rounds; round++) {
      await _tapItem(tester, _odd(mirror));
      mirror.pick(_odd(mirror));
      mirror.nextRound();
      await tester.pump(const Duration(milliseconds: 1300));
    }

    expect(find.text(GamesTexts.won), findsOneWidget);
    expect(find.text(GamesTexts.playAgain), findsNothing);
    expect(finished, 1);
  });

  testWidgets('shows the time, which runs after the first pick', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());
    expect(find.text('1:30'), findsOneWidget);

    await tester.pump(const Duration(seconds: 10));
    expect(find.text('1:30'), findsOneWidget);

    await _tapItem(tester, _mirror().items.indexWhere((i) => !i.isOdd));
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('1:25'), findsOneWidget);
  });

  testWidgets('when the time is up it shows the time-up panel', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await _tapItem(tester, _mirror().items.indexWhere((i) => !i.isOdd));
    await tester.pump(const Duration(seconds: 95));

    expect(find.text(GamesTexts.timeUp), findsOneWidget);
    expect(find.text(GamesTexts.tryAgainQuestion), findsOneWidget);
    expect(find.text('0:00'), findsOneWidget);
  });

  testWidgets('for the child, time up shows no retry and reports the end', (
    tester,
  ) async {
    _useTallScreen(tester);
    var finished = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: OddOneOutGameScreen(
          levelIndex: _levelIndex,
          random: Random(_seed),
          isForChild: true,
          onFinished: () => finished++,
        ),
      ),
    );

    await _tapItem(tester, _mirror().items.indexWhere((i) => !i.isOdd));
    await tester.pump(const Duration(seconds: 95));

    expect(find.text(GamesTexts.timeUp), findsOneWidget);
    expect(find.text(GamesTexts.timeUpTomorrow), findsOneWidget);
    expect(find.text(GamesTexts.tryAgain), findsNothing);
    expect(finished, 1);
  });
}
