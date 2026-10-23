import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/data/level_storage.dart';
import 'package:grad_project/features/games/logic/games_settings.dart';
import 'package:grad_project/features/games/models/game_level.dart';

void main() {
  group('InMemoryLevelStorage', () {
    test('has nothing saved at first', () async {
      expect(await InMemoryLevelStorage().read(), isNull);
    });

    test('gives back what was written', () async {
      final storage = InMemoryLevelStorage();

      await storage.write(2);

      expect(await storage.read(), 2);
    });

    test('can start with a saved level', () async {
      expect(await InMemoryLevelStorage(1).read(), 1);
    });
  });

  group('GamesSettings', () {
    test('starts with the first level', () {
      final settings = GamesSettings(InMemoryLevelStorage());

      expect(settings.selectedLevel, 0);
      expect(settings.level, GameLevel.all[0]);
    });

    test('load keeps the first level when nothing was saved', () async {
      final settings = GamesSettings(InMemoryLevelStorage());
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.load();

      expect(settings.selectedLevel, 0);
      expect(calls, 0);
    });

    test('load reads the saved level and tells the listeners', () async {
      final settings = GamesSettings(InMemoryLevelStorage(2));
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.load();

      expect(settings.selectedLevel, 2);
      expect(settings.level, GameLevel.all[2]);
      expect(calls, 1);
    });

    test('load fixes a saved level that is outside the levels', () async {
      final tooBig = GamesSettings(InMemoryLevelStorage(9));
      final tooSmall = GamesSettings(InMemoryLevelStorage(-3));

      await tooBig.load();
      await tooSmall.load();

      expect(tooBig.selectedLevel, GameLevel.all.length - 1);
      expect(tooSmall.selectedLevel, 0);
    });

    test('select changes the level, tells the listeners and saves it', () async {
      final storage = InMemoryLevelStorage();
      final settings = GamesSettings(storage);
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.select(1);

      expect(settings.selectedLevel, 1);
      expect(calls, 1);
      expect(await storage.read(), 1);
    });

    test('selecting the same level again does not tell the listeners', () async {
      final settings = GamesSettings(InMemoryLevelStorage());
      await settings.select(1);
      var calls = 0;
      settings.addListener(() => calls++);

      await settings.select(1);

      expect(calls, 0);
    });

    test('select rejects a level that does not exist', () async {
      final storage = InMemoryLevelStorage();
      final settings = GamesSettings(storage);
      var calls = 0;
      settings.addListener(() => calls++);

      await expectLater(settings.select(3), throwsRangeError);
      await expectLater(settings.select(-1), throwsRangeError);

      expect(settings.selectedLevel, 0);
      expect(calls, 0);
      expect(await storage.read(), isNull);
    });

    test('a new settings object finds the choice saved by the old one', () async {
      final storage = InMemoryLevelStorage();
      await GamesSettings(storage).select(2);
      final next = GamesSettings(storage);

      await next.load();

      expect(next.selectedLevel, 2);
    });
  });
}
