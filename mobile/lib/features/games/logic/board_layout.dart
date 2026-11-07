import 'dart:math';

/// Picks how many columns a memory board should have, so the cards are as big
/// as possible inside the free space ([width] x [height]).
/// Only column counts that fill every row are used, so no row is left half
/// empty.
int bestColumns({
  required int count,
  required double width,
  required double height,
  double gap = 10,
}) {
  var best = 1;
  var bestSize = double.negativeInfinity;
  for (var columns = 1; columns <= count; columns++) {
    if (count % columns != 0) continue;
    final rows = count ~/ columns;
    final cellWidth = (width - gap * (columns - 1)) / columns;
    final cellHeight = (height - gap * (rows - 1)) / rows;
    // The smaller side decides how big a card looks.
    final size = min(cellWidth, cellHeight);
    if (size > bestSize) {
      bestSize = size;
      best = columns;
    }
  }
  return best;
}
