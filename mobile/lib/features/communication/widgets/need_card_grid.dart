import 'package:flutter/material.dart';

import '../communication_models.dart';
import 'need_card.dart';

/// The cards of the selected category, three in a row.
class NeedCardGrid extends StatelessWidget {
  const NeedCardGrid({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final List<NeedItem> items;
  final NeedItem? selectedItem;
  final ValueChanged<NeedItem> onItemSelected;

  static const double _gap = 12;
  static const double _baseCardHeight = 120;
  static const int _columnCount = 3;

  @override
  Widget build(BuildContext context) {
    // Cards grow with the text size, so labels are never cut off.
    final cardHeight = MediaQuery.textScalerOf(context).scale(_baseCardHeight);

    return GridView(
      shrinkWrap: true,
      // The page scrolls, not the grid.
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columnCount,
        mainAxisSpacing: _gap,
        crossAxisSpacing: _gap,
        mainAxisExtent: cardHeight,
      ),
      children: [
        for (final item in items)
          NeedCard(
            item: item,
            isSelected: item == selectedItem,
            onTap: () => onItemSelected(item),
          ),
      ],
    );
  }
}