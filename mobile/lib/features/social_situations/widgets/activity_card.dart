import 'dart:math' as math;

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
  static const double _titleFontSize = 18;
  static const double _bubbleWidthRatio = 0.6;
  static const double _bubbleHeightRatio = 0.45;
  static const double _minBubbleSize = 56;
  static const double _maxBubbleSize = 120;

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconBubble(size: _bubbleSizeFor(constraints), child: icon),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// The image grows with the card, but stays within sensible limits.
  double _bubbleSizeFor(BoxConstraints constraints) {
    final size = math.min(
      constraints.maxWidth * _bubbleWidthRatio,
      constraints.maxHeight * _bubbleHeightRatio,
    );
    return size.clamp(_minBubbleSize, _maxBubbleSize).toDouble();
  }
}
