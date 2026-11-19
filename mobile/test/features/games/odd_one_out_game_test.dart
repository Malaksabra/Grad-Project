import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/logic/odd_one_out_game.dart';
import 'package:grad_project/features/games/models/odd_one_out_level.dart';

const List<String> _fruits = ['f1', 'f2', 'f3', 'f4', 'f5'];
const List<String> _vegetables = ['v1', 'v2', 'v3', 'v4', 'v5'];

OddOneOutGame _game({
  int items = 4,
  int rounds = 2,
  int seconds = 10,
  int seed = 3,
}) {
  return OddOneOutGame(
    groupA: _fruits,
    groupB: _vegetables,
    itemsPerRound: items,
    rounds: rounds,
    seconds: seconds,
    random: Random(seed),
  );
}

int _oddIndex(OddOneOutGame game) => game.items.indexWhere((i) => i.isOdd);

int _wrongIndex(OddOneOutGame game) =>
    game.items.indexWhere((i) => !i.isOdd && !i.isWrongPick);

void main() {
  group('OddOneOutLevel', () {
    test('has three levels with more pictures, rounds and time each time', () {
      expect(OddOneOutLevel.all.length, 3);
      for (var i = 1; i < OddOneOutLevel.all.length; i++) {
        expect(
          OddOneOutLevel.all[i].items,
          greaterThan(OddOneOutLevel.all[i - 1].items),
        );
        expect(
          OddOneOutLevel.all[i].rounds,
          greaterThan(OddOneOutLevel.all[i - 1].rounds),
        );
        expect(
          OddOneOutLevel.all[i].seconds,
          greaterThan(OddOneOutLevel.all[i - 1].seconds),
        );
      }
    });

    test('every level can be dealt from the real pictures', () {
      // Five pictures in each group are enough for the biggest level.
      for (final level in OddOneOutLevel.all) {
        expect(level.items - 1, lessThanOrEqualTo(_fruits.length));
      }
    });
  });

  group('OddOneOutGame', () {
    test('every round has one different picture from the other group', () {
      for (var seed = 0; seed < 30; seed++) {
        final game = _game(items: 5, seed: seed);
        final items = game.items;
        final odd = items.singleWhere((i) => i.isOdd);
        final others = items.where((i) => !i.isOdd).toList();

        expect(items.length, 5);
        expect(others.length, 4);
        // All the others belong to one group, and the odd one to the other.
        final othersAreFruits = _fruits.contains(others.first.image);
        expect(
          others.every((i) => _fruits.contains(i.image) == othersAreFruits),
          isTrue,
        );
        expect(_fruits.contains(odd.image), !othersAreFruits);
        expect(items.map((i) => i.image).toSet().length, 5);
      }
    });

    test('a wrong pick is marked and can be followed by another pick', () {
      final game = _game();
      final wrong = _wrongIndex(game);

      expect(game.pick(wrong), PickOutcome.wrong);
      expect(game.items[wrong].isWrongPick, isTrue);
      expect(game.pick(wrong), PickOutcome.ignored);
      expect(game.isRoundSolved, isFalse);
    });

    test('the right pick solves the round and locks the pictures', () {
      final game = _game();

      expect(game.pick(_oddIndex(game)), PickOutcome.correct);

      expect(game.isRoundSolved, isTrue);
      expect(game.status, OddOneOutStatus.playing);
      expect(game.pick(0), PickOutcome.ignored);
    });

    test('nextRound deals a new round only after a right pick', () {
      final game = _game();

      game.nextRound();
      expect(game.round, 0);

      game.pick(_oddIndex(game));
      game.nextRound();

      expect(game.round, 1);
      expect(game.isRoundSolved, isFalse);
      expect(
        game.items.every((i) => !i.isWrongPick && !i.isCorrectPick),
        isTrue,
      );
    });

    test('the right pick of the last round wins the game', () {
      final game = _game(rounds: 2);
      game.pick(_oddIndex(game));
      game.nextRound();

      expect(game.pick(_oddIndex(game)), PickOutcome.correct);

      expect(game.status, OddOneOutStatus.won);
      game.nextRound();
      expect(game.round, 1);
    });

    test('restart begins again from the first round', () {
      final game = _game(rounds: 1);
      game.pick(_oddIndex(game));

      game.restart();

      expect(game.status, OddOneOutStatus.playing);
      expect(game.round, 0);
      expect(game.isRoundSolved, isFalse);
    });

    test('the clock waits for the first pick, then runs', () {
      final game = _game();

      game.tick();
      expect(game.remainingSeconds, 10);

      game.pick(_wrongIndex(game));
      game.tick();
      expect(game.remainingSeconds, 9);
      expect(game.remainingFraction, closeTo(0.9, 0.0001));
    });

    test('time up stops the game', () {
      final game = _game(seconds: 2);
      game.pick(_wrongIndex(game));

      game.tick();
      game.tick();

      expect(game.status, OddOneOutStatus.timeUp);
      expect(game.remainingSeconds, 0);
      expect(game.pick(_oddIndex(game)), PickOutcome.ignored);
    });

    test('winning stops the clock from ending the game', () {
      final game = _game(rounds: 1, seconds: 2);
      game.pick(_oddIndex(game));

      game.tick();
      game.tick();

      expect(game.status, OddOneOutStatus.won);
    });

    test('restart gives the full time again', () {
      final game = _game(seconds: 2);
      game.pick(_wrongIndex(game));
      game.tick();
      game.tick();

      game.restart();

      expect(game.status, OddOneOutStatus.playing);
      expect(game.remainingSeconds, 2);
      expect(game.hasStarted, isFalse);
    });

    test('rejects settings that cannot make a round', () {
      expect(() => _game(items: 2), throwsArgumentError);
      expect(() => _game(rounds: 0), throwsArgumentError);
      expect(() => _game(seconds: 0), throwsArgumentError);
      expect(() => _game(items: 7), throwsArgumentError);
    });
  });
}
