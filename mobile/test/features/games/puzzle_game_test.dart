import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/logic/puzzle_game.dart';
import 'package:grad_project/features/games/models/puzzle_level.dart';

const List<String> _images = ['a.jpg', 'b.jpg', 'c.jpg'];

PuzzleGame _game({
  int rows = 2,
  int columns = 2,
  int seconds = 10,
  int seed = 1,
}) {
  return PuzzleGame(
    images: _images,
    rows: rows,
    columns: columns,
    seconds: seconds,
    random: Random(seed),
  );
}

/// Taps pairs of positions until every piece is where it belongs.
void _solve(PuzzleGame game) {
  while (!game.isSolved) {
    final wrong = List.generate(
      game.pieceCount,
      (i) => i,
    ).firstWhere((i) => game.pieceAt(i) != i);
    final home = List.generate(
      game.pieceCount,
      (i) => i,
    ).firstWhere((i) => game.pieceAt(i) == wrong);
    game.tap(wrong);
    game.tap(home);
  }
}

void main() {
  group('PuzzleLevel', () {
    test('has three levels with more pieces and more time each time', () {
      expect(PuzzleLevel.all.length, 3);
      for (var i = 1; i < PuzzleLevel.all.length; i++) {
        expect(
          PuzzleLevel.all[i].pieceCount,
          greaterThan(PuzzleLevel.all[i - 1].pieceCount),
        );
        expect(
          PuzzleLevel.all[i].seconds,
          greaterThan(PuzzleLevel.all[i - 1].seconds),
        );
      }
    });
  });

  group('PuzzleGame', () {
    test('starts shuffled, with the full time and no chosen piece', () {
      for (var seed = 0; seed < 20; seed++) {
        final game = _game(seed: seed);

        expect(game.isSolved, isFalse);
        expect(game.status, PuzzleStatus.playing);
        expect(game.remainingSeconds, 10);
        expect(game.selectedPosition, isNull);
        expect(_images, contains(game.image));
      }
    });

    test('has every piece exactly once', () {
      final game = _game(rows: 3, columns: 3);

      final pieces = [for (var i = 0; i < 9; i++) game.pieceAt(i)]..sort();

      expect(pieces, List.generate(9, (i) => i));
    });

    test('the first tap chooses a piece and the same tap again lets it go', () {
      final game = _game();

      expect(game.tap(1), PuzzleTapOutcome.selected);
      expect(game.selectedPosition, 1);
      expect(game.tap(1), PuzzleTapOutcome.deselected);
      expect(game.selectedPosition, isNull);
    });

    test('two taps swap two pieces', () {
      final game = _game();
      final first = game.pieceAt(0);
      final second = game.pieceAt(3);

      game.tap(0);
      final outcome = game.tap(3);

      expect(outcome, anyOf(PuzzleTapOutcome.swapped, PuzzleTapOutcome.solved));
      expect(game.pieceAt(0), second);
      expect(game.pieceAt(3), first);
      expect(game.selectedPosition, isNull);
    });

    test('finishing the picture wins', () {
      final game = _game(rows: 3, columns: 2);

      _solve(game);

      expect(game.status, PuzzleStatus.won);
      expect(game.tap(0), PuzzleTapOutcome.ignored);
    });

    test('the last swap says solved', () {
      final game = _game();
      PuzzleTapOutcome? last;
      while (!game.isSolved) {
        final wrong = List.generate(
          4,
          (i) => i,
        ).firstWhere((i) => game.pieceAt(i) != i);
        final home = List.generate(
          4,
          (i) => i,
        ).firstWhere((i) => game.pieceAt(i) == wrong);
        game.tap(wrong);
        last = game.tap(home);
      }

      expect(last, PuzzleTapOutcome.solved);
    });

    test('the clock waits for the first tap, then runs', () {
      final game = _game();

      game.tick();
      expect(game.remainingSeconds, 10);

      game.tap(0);
      game.tick();
      expect(game.remainingSeconds, 9);
      expect(game.remainingFraction, closeTo(0.9, 0.0001));
    });

    test('time up stops the game', () {
      final game = _game(seconds: 2);
      game.tap(0);

      game.tick();
      game.tick();

      expect(game.status, PuzzleStatus.timeUp);
      expect(game.remainingSeconds, 0);
      expect(game.tap(1), PuzzleTapOutcome.ignored);
    });

    test('restart gives the full time and a shuffled picture again', () {
      final game = _game(seconds: 2);
      game.tap(0);
      game.tick();
      game.tick();

      game.restart();

      expect(game.status, PuzzleStatus.playing);
      expect(game.remainingSeconds, 2);
      expect(game.hasStarted, isFalse);
      expect(game.isSolved, isFalse);
    });

    test('rejects settings that cannot make a puzzle', () {
      expect(() => _game(rows: 1, columns: 1), throwsArgumentError);
      expect(() => _game(seconds: 0), throwsArgumentError);
      expect(
        () => PuzzleGame(images: const [], rows: 2, columns: 2, seconds: 5),
        throwsArgumentError,
      );
    });
  });
}
