import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/features/games/logic/board_layout.dart';

void main() {
  test('a tall space gets few columns and many rows', () {
    expect(bestColumns(count: 6, width: 300, height: 600), 2);
    expect(bestColumns(count: 8, width: 300, height: 600), 2);
    expect(bestColumns(count: 12, width: 300, height: 600), 3);
  });

  test('a wide space gets more columns', () {
    expect(bestColumns(count: 6, width: 900, height: 300), 3);
    expect(bestColumns(count: 12, width: 900, height: 300), 6);
  });

  test('only column counts that fill every row are used', () {
    for (final count in [6, 8, 12]) {
      for (final size in [200.0, 400.0, 800.0]) {
        final columns = bestColumns(count: count, width: size, height: 500);
        expect(count % columns, 0);
      }
    }
  });
}
