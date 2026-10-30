import 'package:flutter/material.dart';

/// Small dots that show which page of the story the child is on.
class StoryProgressDots extends StatelessWidget {
  const StoryProgressDots({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  static const double _dotSize = 12;
  static const double _activeDotWidth = 28;
  static const double _gap = 6;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < count; index++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _gap / 2),
            child: AnimatedContainer(
              duration: _animationDuration,
              width: index == currentIndex ? _activeDotWidth : _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: index == currentIndex ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(_dotSize),
              ),
            ),
          ),
      ],
    );
  }
}
