import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/data/shared_preferences_level_storage.dart';
import 'package:grad_project/features/games/models/child_choice.dart';
import 'package:grad_project/features/games/models/game_kind.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('has nothing saved at first', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await SharedPreferencesLevelStorage().read(), isNull);
  });

  test('gives back what was written', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPreferencesLevelStorage();

    await storage.write(const ChildChoice(GameKind.oddOneOut, 2));

    expect(await storage.read(), const ChildChoice(GameKind.oddOneOut, 2));
  });

  test(
    'a level saved before there were three games is a memory level',
    () async {
      SharedPreferences.setMockInitialValues({'games_selected_level': 1});

      expect(
        await SharedPreferencesLevelStorage().read(),
        const ChildChoice(GameKind.memory, 1),
      );
    },
  );

  test('an unknown saved game falls back to the memory game', () async {
    SharedPreferences.setMockInitialValues({
      'games_selected_level': 0,
      'games_selected_game': 'removed_game',
    });

    expect(
      await SharedPreferencesLevelStorage().read(),
      const ChildChoice(GameKind.memory, 0),
    );
  });

  test('has no finished day at first', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await SharedPreferencesLevelStorage().readFinishedDay(), isNull);
  });

  test('keeps the finished day, and null clears it', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPreferencesLevelStorage();

    await storage.writeFinishedDay('2026-11-07');
    expect(await storage.readFinishedDay(), '2026-11-07');

    await storage.writeFinishedDay(null);
    expect(await storage.readFinishedDay(), isNull);
  });
}
