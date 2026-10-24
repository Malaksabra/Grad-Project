import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/models/game_level.dart';

void main() {
  group('GameLevel', () {
    test('has three levels', () {
      expect(GameLevel.all.length, 3);
    });

    test('the pairs and the time grow from level to level', () {
      for (var i = 1; i < GameLevel.all.length; i++) {
        expect(GameLevel.all[i].pairs, greaterThan(GameLevel.all[i - 1].pairs));
        expect(
          GameLevel.all[i].seconds,
          greaterThan(GameLevel.all[i - 1].seconds),
        );
      }
    });

    test('has two cards for every pair', () {
      expect([for (final l in GameLevel.all) l.cardCount], [6, 8, 12]);
    });

    test('every board fills its rows with no empty place', () {
      for (final level in GameLevel.all) {
        expect(level.cardCount % level.columns, 0);
      }
    });
  });

  group('formatTime', () {
    test('shows minutes and two digit seconds', () {
      expect(formatTime(120), '2:00');
      expect(formatTime(180), '3:00');
      expect(formatTime(300), '5:00');
      expect(formatTime(65), '1:05');
    });

    test('works under one minute', () {
      expect(formatTime(9), '0:09');
      expect(formatTime(0), '0:00');
    });
  });
}
