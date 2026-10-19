import 'package:flutter/material.dart';

import 'icon_bubble.dart';

/// A large tappable card with an image and a title, used for one activity.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.edgeColor,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final Widget icon;
  final Color backgroundColor;
  final Color edgeColor;
  final Color textColor;
  final VoidCallback onTap;

  static const double _radius = 28;
  static const double _edgeHeight = 6;
  static const double _padding = 12;
  static const double _spacing = 8;
  static const double _titleFontSize = 18;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        // A shadow without blur gives the card its solid bottom edge.
        boxShadow: [
          BoxShadow(color: edgeColor, offset: const Offset(0, _edgeHeight)),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconBubble(child: icon),
                const SizedBox(height: _spacing),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontSize: _titleFontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
