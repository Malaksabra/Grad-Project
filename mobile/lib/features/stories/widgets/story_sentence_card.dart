import 'package:flutter/material.dart';

/// A card with the sentence of the current story page.
class StorySentenceCard extends StatelessWidget {
  const StorySentenceCard({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.edgeColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color edgeColor;
  final Color textColor;

  static const double _radius = 28;
  static const double _edgeHeight = 6;
  static const double _padding = 16;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(_radius),
        // A shadow without blur gives the card its solid bottom edge.
        boxShadow: [
          BoxShadow(color: edgeColor, offset: const Offset(0, _edgeHeight)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
