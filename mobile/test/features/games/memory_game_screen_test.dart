import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/games_images.dart';
import 'package:grad_project/features/games/games_texts.dart';
import 'package:grad_project/features/games/logic/memory_game.dart';
import 'package:grad_project/features/games/models/game_level.dart';
import 'package:grad_project/features/games/screens/memory_game_screen.dart';

const int _seed = 7;
const int _levelIndex = 0;

/// The same deal the screen gets, because the seed is the same.
List<MemoryCard> _expectedCards() {
  final level = GameLevel.all[_levelIndex];
  return MemoryGame(
    images: GamesImages.fruits,
    pairs: level.pairs,
    seconds: level.seconds,
    random: Random(_seed),
  ).cards;
}

/// The positions of two cards with the same picture.
List<int> _pair(List<MemoryCard> cards) {
  for (var i = 0; i < cards.length; i++) {
    for (var j = i + 1; j < cards.length; j++) {
      if (cards[i].image == cards[j].image) return [i, j];
    }
  }
  throw StateError('no pair found');
}

/// The positions of the first card and a card with another picture.
List<int> _differentCards(List<MemoryCard> cards) {
  final other = cards.indexWhere((c) => c.image != cards[0].image);
  return [0, other];
}

Finder _card(int index) => find.byKey(ValueKey('card_$index'));

Widget _screen() => MaterialApp(
  home: MemoryGameScreen(levelIndex: _levelIndex, random: Random(_seed)),
);

Future<void> _tapCard(WidgetTester tester, int index) async {
  await tester.tap(_card(index));
  await tester.pump();
}

void _useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('starts with the full time and the start message', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    expect(find.text(GamesTexts.messageStart), findsOneWidget);
    expect(find.text('2:00'), findsOneWidget);
    expect(find.byKey(const ValueKey('card_back')), findsNWidgets(GameLevel.all[_levelIndex].cardCount));
  });

  testWidgets('the time does not run before the first card', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await tester.pump(const Duration(seconds: 10));

    expect(find.text('2:00'), findsOneWidget);
  });

  testWidgets('the time runs after the first card', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await _tapCard(tester, 0);
    expect(find.text(GamesTexts.messageFlipSecond), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));

    expect(find.text('1:55'), findsOneWidget);
  });

  testWidgets('a matching pair stays open and shows the match message', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());
    final pair = _pair(_expectedCards());

    await _tapCard(tester, pair[0]);
    await _tapCard(tester, pair[1]);

    expect(find.text(GamesTexts.messageMatch), findsOneWidget);
    // Two cards are open, so four are still closed.
    expect(find.byKey(const ValueKey('card_back')), findsNWidgets(4));

    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const ValueKey('card_back')), findsNWidgets(4));
  });

  testWidgets('a wrong pair is turned back after a second', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());
    final wrong = _differentCards(_expectedCards());

    await _tapCard(tester, wrong[0]);
    await _tapCard(tester, wrong[1]);

    expect(find.text(GamesTexts.messageNoMatch), findsOneWidget);
    expect(find.byKey(const ValueKey('card_back')), findsNWidgets(4));

    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const ValueKey('card_back')), findsNWidgets(6));
  });

  testWidgets('cards are locked while a wrong pair is open', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());
    final cards = _expectedCards();
    final wrong = _differentCards(cards);
    final third = List.generate(cards.length, (i) => i)
        .firstWhere((i) => i != wrong[0] && i != wrong[1]);

    await _tapCard(tester, wrong[0]);
    await _tapCard(tester, wrong[1]);
    await _tapCard(tester, third);

    // The third tap was ignored, so only two cards are open.
    expect(find.byKey(const ValueKey('card_back')), findsNWidgets(4));

    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('finding every pair shows the win panel and plays again', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());
    final cards = _expectedCards();

    final byImage = <String, List<int>>{};
    for (var i = 0; i < cards.length; i++) {
      byImage.putIfAbsent(cards[i].image, () => []).add(i);
    }
    for (final pair in byImage.values) {
      await _tapCard(tester, pair[0]);
      await _tapCard(tester, pair[1]);
    }

    expect(find.text(GamesTexts.won), findsOneWidget);
    expect(find.text(GamesTexts.playAgain), findsOneWidget);

    await tester.tap(find.text(GamesTexts.playAgain));
    await tester.pump();

    expect(find.text(GamesTexts.won), findsNothing);
    expect(find.text(GamesTexts.messageStart), findsOneWidget);
    expect(find.text('2:00'), findsOneWidget);
  });

  testWidgets('when the time is up it shows the time-up panel', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_screen());

    await _tapCard(tester, 0);
    await tester.pump(const Duration(seconds: 125));

    expect(find.text(GamesTexts.timeUp), findsOneWidget);
    expect(find.text(GamesTexts.tryAgainQuestion), findsOneWidget);
    expect(find.text('0:00'), findsOneWidget);
  });

  testWidgets('exit closes the page', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MemoryGameScreen(
                  levelIndex: _levelIndex,
                  random: Random(_seed),
                ),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(MemoryGameScreen), findsOneWidget);

    await _tapCard(tester, 0);
    await tester.pump(const Duration(seconds: 125));
    await tester.tap(find.text(GamesTexts.exit));
    await tester.pumpAndSettle();

    expect(find.byType(MemoryGameScreen), findsNothing);
  });
}
