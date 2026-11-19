import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/logic/day_key.dart';

void main() {
  test('writes the year, month and day with two digits', () {
    expect(dayKey(DateTime(2026, 11, 7)), '2026-11-07');
    expect(dayKey(DateTime(2026, 1, 31)), '2026-01-31');
  });

  test('the hour does not change the day', () {
    expect(
      dayKey(DateTime(2026, 11, 7, 0, 1)),
      dayKey(DateTime(2026, 11, 7, 23, 59)),
    );
  });
}
