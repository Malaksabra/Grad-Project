import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/data/level_storage.dart';
import 'package:grad_project/features/games/logic/games_settings.dart';
import 'package:grad_project/features/games/models/child_choice.dart';
import 'package:grad_project/features/games/models/game_kind.dart';

/// A storage that always fails, like a phone with no space left.
class _BrokenStorage implements LevelStorage {
  @override
  Future<ChildChoice?> read() async => throw StateError('cannot read');

  @override
  Future<void> write(ChildChoice choice) async =>
      throw StateError('cannot write');

  @override
  Future<String?> readFinishedDay() async => throw StateError('cannot read');

  @override
  Future<void> writeFinishedDay(String? day) async =>
      throw StateError('cannot write');
}

void main() {
  group('InMemoryLevelStorage', () {
    test('has nothing saved at first', () async {
      expect(await InMemoryLevelStorage().read(), isNull);
    });

    test('gives back what was written', () async {
      final storage = InMemoryLevelStorage();

      await storage.write(const ChildChoice(GameKind.puzzle, 2));

      expect(await storage.read(), const ChildChoice(GameKind.puzzle, 2));
    });

    test('keeps the finished day, and null clears it', () async {
      final storage = InMemoryLevelStorage();
      expect(await storage.readFinishedDay(), isNull);

      await storage.writeFinishedDay('2026-11-07');
      expect(await storage.readFinishedDay(), '2026-11-07');

      await storage.writeFinishedDay(null);
      expect(await storage.readFinishedDay(), isNull);
    });

    test('can start with a saved choice', () async {
      final storage = InMemoryLevelStorage(
        const ChildChoice(GameKind.memory, 1),
      );

      expect(await storage.read(), const ChildChoice(GameKind.memory, 1));
    });
  });

  group('GamesSettings', () {
    test('starts with the first level of the memory game', () {
      final settings = GamesSettings(InMemoryLevelStorage());

      expect(settings.selectedGame, GameKind.memory);
      expect(settings.selectedLevel, 0);
    });

    test('load keeps the first choice when nothing was saved', () async {
      final settings = GamesSettings(InMemoryLevelStorage());
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.load();

      expect(settings.selectedGame, GameKind.memory);
      expect(settings.selectedLevel, 0);
      expect(calls, 0);
    });

    test('load reads the saved choice and tells the listeners', () async {
      final settings = GamesSettings(
        InMemoryLevelStorage(const ChildChoice(GameKind.oddOneOut, 2)),
      );
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.load();

      expect(settings.selectedGame, GameKind.oddOneOut);
      expect(settings.selectedLevel, 2);
      expect(calls, 1);
    });

    test('load fixes a saved level that is outside the levels', () async {
      final tooBig = GamesSettings(
        InMemoryLevelStorage(const ChildChoice(GameKind.puzzle, 9)),
      );
      final tooSmall = GamesSettings(
        InMemoryLevelStorage(const ChildChoice(GameKind.puzzle, -3)),
      );

      await tooBig.load();
      await tooSmall.load();

      expect(tooBig.selectedLevel, GameKind.puzzle.levelCount - 1);
      expect(tooSmall.selectedLevel, 0);
    });

    test('select changes the game and level, tells and saves', () async {
      final storage = InMemoryLevelStorage();
      final settings = GamesSettings(storage);
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.select(GameKind.puzzle, 1);

      expect(settings.selectedGame, GameKind.puzzle);
      expect(settings.selectedLevel, 1);
      expect(calls, 1);
      expect(await storage.read(), const ChildChoice(GameKind.puzzle, 1));
    });

    test('the same level of another game is a new choice', () async {
      final settings = GamesSettings(InMemoryLevelStorage());
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.select(GameKind.oddOneOut, 0);

      expect(settings.selectedGame, GameKind.oddOneOut);
      expect(calls, 1);
    });

    test(
      'selecting the same choice again does not tell the listeners',
      () async {
        final settings = GamesSettings(InMemoryLevelStorage());
        await settings.select(GameKind.puzzle, 1);
        var calls = 0;
        settings.addListener(() => calls++);

        await settings.select(GameKind.puzzle, 1);

        expect(calls, 0);
      },
    );

    test('select rejects a level that does not exist', () async {
      final storage = InMemoryLevelStorage();
      final settings = GamesSettings(storage);
      var calls = 0;
      settings.addListener(() => calls++);

      await expectLater(settings.select(GameKind.memory, 3), throwsRangeError);
      await expectLater(settings.select(GameKind.memory, -1), throwsRangeError);

      expect(settings.selectedLevel, 0);
      expect(calls, 0);
      expect(await storage.read(), isNull);
    });

    test(
      'a new settings object finds the choice saved by the old one',
      () async {
        final storage = InMemoryLevelStorage();
        await GamesSettings(storage).select(GameKind.oddOneOut, 2);
        final next = GamesSettings(storage);

        await next.load();

        expect(next.selectedGame, GameKind.oddOneOut);
        expect(next.selectedLevel, 2);
      },
    );

    test('load keeps the first choice when the storage fails', () async {
      final settings = GamesSettings(_BrokenStorage());

      await settings.load();

      expect(settings.selectedGame, GameKind.memory);
      expect(settings.selectedLevel, 0);
    });

    test('select still changes the choice when saving fails', () async {
      final settings = GamesSettings(_BrokenStorage());
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.select(GameKind.puzzle, 2);

      expect(settings.selectedGame, GameKind.puzzle);
      expect(settings.selectedLevel, 2);
      expect(calls, 1);
    });

    test('markFinished locks that day only, and saves it', () async {
      final storage = InMemoryLevelStorage();
      final settings = GamesSettings(storage);
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.markFinished('2026-11-07');

      expect(settings.isFinishedOn('2026-11-07'), isTrue);
      expect(settings.isFinishedOn('2026-11-08'), isFalse);
      expect(calls, 1);
      expect(await storage.readFinishedDay(), '2026-11-07');
    });

    test('load reads the finished day saved earlier', () async {
      final settings = GamesSettings(InMemoryLevelStorage(null, '2026-11-07'));

      await settings.load();

      expect(settings.isFinishedOn('2026-11-07'), isTrue);
    });

    test(
      'choosing a game for the child does not unlock the finished day',
      () async {
        final storage = InMemoryLevelStorage();
        final settings = GamesSettings(storage);
        await settings.markFinished('2026-11-07');

        await settings.select(GameKind.puzzle, 0);
        await settings.select(GameKind.memory, 0);

        expect(settings.isFinishedOn('2026-11-07'), isTrue);
        expect(await storage.readFinishedDay(), '2026-11-07');
      },
    );

    test('a choice made on a finished day is kept for the next day', () async {
      final storage = InMemoryLevelStorage();
      final settings = GamesSettings(storage);
      await settings.markFinished('2026-11-07');

      await settings.select(GameKind.puzzle, 2);

      expect(await storage.read(), const ChildChoice(GameKind.puzzle, 2));
      expect(settings.isFinishedOn('2026-11-08'), isFalse);
    });

    test('markFinished still locks when saving fails', () async {
      final settings = GamesSettings(_BrokenStorage());

      await settings.markFinished('2026-11-07');

      expect(settings.isFinishedOn('2026-11-07'), isTrue);
    });
  });
}
