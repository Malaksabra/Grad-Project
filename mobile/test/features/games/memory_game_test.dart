import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/logic/memory_game.dart';

void main() {
  const pool = ['a', 'b', 'c', 'd', 'e', 'f'];

  // A game with a fixed shuffle, so every test gets the same board.
  MemoryGame newGame({int pairs = 3, int seconds = 120}) {
    return MemoryGame(
      images: pool,
      pairs: pairs,
      seconds: seconds,
      random: Random(1),
    );
  }

  // The positions of two cards with the same picture.
  (int, int) matchingPair(MemoryGame game) {
    final first = game.cards.first;
    final other = game.cards.firstWhere(
      (c) => c.id != first.id && c.image == first.image,
    );
    return (first.id, other.id);
  }

  // The positions of two cards with different pictures.
  (int, int) differentPair(MemoryGame game) {
    final first = game.cards.first;
    final other = game.cards.firstWhere((c) => c.image != first.image);
    return (first.id, other.id);
  }

  // Turns every pair, one after the other.
  void solve(MemoryGame game) {
    final images = game.cards.map((c) => c.image).toSet();
    for (final image in images) {
      final positions = game.cards.where((c) => c.image == image).toList();
      game.flip(positions[0].id);
      game.flip(positions[1].id);
    }
  }

  group('dealing', () {
    test('makes two cards for every pair', () {
      final game = newGame(pairs: 3);

      expect(game.cards.length, 6);
      final counts = <String, int>{};
      for (final card in game.cards) {
        counts[card.image] = (counts[card.image] ?? 0) + 1;
      }
      expect(counts.length, 3);
      expect(counts.values, everyElement(2));
    });

    test('uses only pictures from the given list', () {
      final game = newGame(pairs: 6);

      expect(game.cards.every((c) => pool.contains(c.image)), isTrue);
    });

    test('starts with every card face down and not matched', () {
      final game = newGame();

      expect(game.cards.every((c) => !c.isFaceUp && !c.isMatched), isTrue);
    });

    test('gives each card its position as id', () {
      final game = newGame();

      expect([for (final c in game.cards) c.id], [0, 1, 2, 3, 4, 5]);
    });

    test('starts playing with the full time and a stopped clock', () {
      final game = newGame(seconds: 120);

      expect(game.status, MemoryStatus.playing);
      expect(game.remainingSeconds, 120);
      expect(game.remainingFraction, 1.0);
      expect(game.hasStarted, isFalse);
      expect(game.isLocked, isFalse);
    });

    test('the same random seed gives the same board', () {
      final one = MemoryGame(
        images: pool,
        pairs: 4,
        seconds: 60,
        random: Random(7),
      );
      final two = MemoryGame(
        images: pool,
        pairs: 4,
        seconds: 60,
        random: Random(7),
      );

      expect(
        [for (final c in one.cards) c.image],
        [for (final c in two.cards) c.image],
      );
    });

    test('rejects settings that cannot make a board', () {
      expect(
        () => MemoryGame(images: pool, pairs: 7, seconds: 60),
        throwsArgumentError,
      );
      expect(
        () => MemoryGame(images: pool, pairs: 0, seconds: 60),
        throwsArgumentError,
      );
      expect(
        () => MemoryGame(images: pool, pairs: 3, seconds: 0),
        throwsArgumentError,
      );
      expect(
        () => MemoryGame(images: const ['a', 'a', 'b'], pairs: 2, seconds: 60),
        throwsArgumentError,
      );
    });
  });

  group('turning cards', () {
    test('the first card turns face up and starts the clock', () {
      final game = newGame();

      final outcome = game.flip(0);

      expect(outcome, FlipOutcome.firstCard);
      expect(game.cards[0].isFaceUp, isTrue);
      expect(game.hasStarted, isTrue);
    });

    test('two cards with the same picture match and stay open', () {
      final game = newGame();
      final (a, b) = matchingPair(game);

      game.flip(a);
      final outcome = game.flip(b);

      expect(outcome, FlipOutcome.match);
      expect(game.cards[a].isMatched, isTrue);
      expect(game.cards[b].isMatched, isTrue);
      expect(game.isLocked, isFalse);
      expect(game.status, MemoryStatus.playing);
    });

    test('two different cards are a mismatch and lock the board', () {
      final game = newGame();
      final (a, b) = differentPair(game);

      game.flip(a);
      final outcome = game.flip(b);

      expect(outcome, FlipOutcome.mismatch);
      expect(game.isLocked, isTrue);
      expect(game.cards[a].isMatched, isFalse);
      expect(game.cards[b].isMatched, isFalse);
      // They stay open until the screen calls hideMismatch.
      expect(game.cards[a].isFaceUp, isTrue);
      expect(game.cards[b].isFaceUp, isTrue);
    });

    test('taps are ignored while a mismatch is waiting', () {
      final game = newGame();
      final (a, b) = differentPair(game);
      game.flip(a);
      game.flip(b);
      final third = game.cards.firstWhere((c) => c.id != a && c.id != b).id;

      final outcome = game.flip(third);

      expect(outcome, FlipOutcome.ignored);
      expect(game.cards[third].isFaceUp, isFalse);
    });

    test('hideMismatch turns both cards back and unlocks the board', () {
      final game = newGame();
      final (a, b) = differentPair(game);
      game.flip(a);
      game.flip(b);

      game.hideMismatch();

      expect(game.cards[a].isFaceUp, isFalse);
      expect(game.cards[b].isFaceUp, isFalse);
      expect(game.isLocked, isFalse);
      expect(game.flip(a), FlipOutcome.firstCard);
    });

    test('hideMismatch does nothing when there is no mismatch', () {
      final game = newGame();
      game.flip(0);

      game.hideMismatch();

      expect(game.cards[0].isFaceUp, isTrue);
    });

    test('turning the same card twice is ignored', () {
      final game = newGame();
      game.flip(0);

      expect(game.flip(0), FlipOutcome.ignored);
      expect(game.isLocked, isFalse);
    });

    test('a matched card cannot be turned again', () {
      final game = newGame();
      final (a, b) = matchingPair(game);
      game.flip(a);
      game.flip(b);

      expect(game.flip(a), FlipOutcome.ignored);
      expect(game.flip(b), FlipOutcome.ignored);
    });

    test('a position outside the board is an error', () {
      final game = newGame();

      expect(() => game.flip(-1), throwsRangeError);
      expect(() => game.flip(6), throwsRangeError);
    });

    test('the game is won when every pair is found', () {
      final game = newGame();

      solve(game);

      expect(game.status, MemoryStatus.won);
      expect(game.cards.every((c) => c.isMatched), isTrue);
    });
  });

  group('the clock', () {
    test('does not run before the first card is turned', () {
      final game = newGame(seconds: 10);

      game.tick();

      expect(game.remainingSeconds, 10);
    });

    test('counts down after the first card', () {
      final game = newGame(seconds: 10);
      game.flip(0);

      game.tick();
      game.tick();

      expect(game.remainingSeconds, 8);
    });

    test('the time fraction goes down with the time', () {
      final game = newGame(seconds: 4);
      game.flip(0);

      game.tick();
      game.tick();

      expect(game.remainingFraction, 0.5);
    });

    test('time is up at zero and never goes below it', () {
      final game = newGame(seconds: 2);
      game.flip(0);

      game.tick();
      game.tick();
      game.tick();

      expect(game.status, MemoryStatus.timeUp);
      expect(game.remainingSeconds, 0);
      expect(game.remainingFraction, 0.0);
    });

    test('no card can be turned after time is up', () {
      final game = newGame(seconds: 1);
      game.flip(0);
      game.tick();

      expect(game.flip(1), FlipOutcome.ignored);
      expect(game.cards[1].isFaceUp, isFalse);
    });

    test('stops when the game is won', () {
      final game = newGame(seconds: 30);
      solve(game);

      game.tick();

      expect(game.status, MemoryStatus.won);
      expect(game.remainingSeconds, 30);
    });
  });

  group('restart', () {
    test('brings back the full time and a new closed board', () {
      final game = newGame(seconds: 10);
      final (a, b) = matchingPair(game);
      game.flip(a);
      game.flip(b);
      game.tick();

      game.restart();

      expect(game.status, MemoryStatus.playing);
      expect(game.remainingSeconds, 10);
      expect(game.hasStarted, isFalse);
      expect(game.isLocked, isFalse);
      expect(game.cards.length, 6);
      expect(game.cards.every((c) => !c.isFaceUp && !c.isMatched), isTrue);
    });

    test('works after time is up', () {
      final game = newGame(seconds: 1);
      game.flip(0);
      game.tick();

      game.restart();

      expect(game.status, MemoryStatus.playing);
      expect(game.flip(0), FlipOutcome.firstCard);
    });

    test('works while a mismatch is waiting', () {
      final game = newGame();
      final (a, b) = differentPair(game);
      game.flip(a);
      game.flip(b);

      game.restart();

      expect(game.isLocked, isFalse);
      expect(game.flip(0), FlipOutcome.firstCard);
    });
  });
}
