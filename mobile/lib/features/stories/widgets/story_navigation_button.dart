import 'package:flutter/material.dart';

/// A large button in the same style as the activity cards.
/// It looks faded and does nothing when [onPressed] is null.
class StoryNavigationButton extends StatelessWidget {
  const StoryNavigationButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.edgeColor,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color edgeColor;
  final Color textColor;
  final VoidCallback? onPressed;

  static const double _radius = 28;
  static const double _edgeHeight = 6;
  static const double _height = 64;
  static const double _fontSize = 20;
  static const double _disabledOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return Opacity(
      opacity: onPressed == null ? _disabledOpacity : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(color: edgeColor, offset: const Offset(0, _edgeHeight)),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onPressed,
            child: SizedBox(
              height: _height,
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontSize: _fontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
