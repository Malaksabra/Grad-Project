import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_models.dart';

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
          _NeedCard(
            item: item,
            isSelected: item == selectedItem,
            onTap: () => onItemSelected(item),
          ),
      ],
    );
  }
}

/// One tappable card with a big picture and a label.
class _NeedCard extends StatelessWidget {
  const _NeedCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final NeedItem item;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _radius = 24;
  static const double _borderWidth = 2;
  static const double _edgeHeight = 5;
  static const double _emojiSize = 40;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? CommunicationColors.background : Colors.white,
        borderRadius: borderRadius,
        border: Border.all(
          color: isSelected
              ? CommunicationColors.text
              : CommunicationColors.edge,
          width: _borderWidth,
        ),
        // A shadow without blur gives the card its solid bottom edge.
        boxShadow: const [
          BoxShadow(
            color: CommunicationColors.edge,
            offset: Offset(0, _edgeHeight),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: _emojiSize)),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: CommunicationColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
