import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lays [itemCount] items in rows of [columns], and stretches the cells to
/// fill all the space it is given. A last row with fewer items is centered.
/// It never scrolls, so give it a space with a fixed height.
class FilledGrid extends StatelessWidget {
  const FilledGrid({
    super.key,
    required this.columns,
    required this.itemCount,
    required this.itemBuilder,
    this.gap = 10,
  });

  final int columns;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// The space between two neighbor items.
  final double gap;

  @override
  Widget build(BuildContext context) {
    final rows = (itemCount / columns).ceil();
    return Column(
      children: [
        for (var row = 0; row < rows; row++)
          Expanded(child: _buildRow(context, row)),
      ],
    );
  }

  Widget _buildRow(BuildContext context, int row) {
    final first = row * columns;
    final inRow = math.min(columns, itemCount - first);
    // Every cell has flex 2, so a short row can be centered with spacers
    // while its cells stay as wide as the cells of a full row.
    final spare = columns - inRow;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (spare > 0) Spacer(flex: spare),
        for (var i = 0; i < inRow; i++)
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(gap / 2),
              child: itemBuilder(context, first + i),
            ),
          ),
        if (spare > 0) Spacer(flex: spare),
      ],
    );
  }
}
