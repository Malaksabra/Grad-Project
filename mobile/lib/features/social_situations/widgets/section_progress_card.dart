import 'package:flutter/material.dart';

import 'icon_bubble.dart';

/// A card that shows the section title and how much of it is completed.
class SectionProgressCard extends StatelessWidget {
  const SectionProgressCard({
    super.key,
    required this.title,
    required this.progressText,
    required this.icon,
    required this.backgroundColor,
    required this.edgeColor,
    required this.textColor,
  });

  final String title;
  final String progressText;
  final Widget icon;
  final Color backgroundColor;
  final Color edgeColor;
  final Color textColor;

  static const double _radius = 28;
  static const double _edgeHeight = 6;
  static const double _padding = 20;
  static const double _spacing = 16;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(color: edgeColor, offset: const Offset(0, _edgeHeight)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Row(
          children: [
            IconBubble(child: icon),
            const SizedBox(width: _spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(color: textColor),
                  ),
                  Text(
                    progressText,
                    style: textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
