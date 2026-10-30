import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_models.dart';

/// One tappable card with a big picture and a label.
class NeedCard extends StatelessWidget {
  const NeedCard({
    super.key,
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