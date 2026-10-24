import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/data/shared_preferences_level_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('has nothing saved at first', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await SharedPreferencesLevelStorage().read(), isNull);
  });

  test('gives back what was written', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPreferencesLevelStorage();

    await storage.write(2);

    expect(await storage.read(), 2);
  });

  test('reads a level saved earlier', () async {
    SharedPreferences.setMockInitialValues({'games_selected_level': 1});

    expect(await SharedPreferencesLevelStorage().read(), 1);
  });
}
