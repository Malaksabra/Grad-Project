import 'package:flutter/material.dart';

import '../../stories_colors.dart';
import '../../stories_texts.dart';
import '../../widgets/story_progress_dots.dart';

/// The close button and the dots that show which page the child is on.
class QuestionStoryTopBar extends StatelessWidget {
  const QuestionStoryTopBar({
    super.key,
    required this.pageCount,
    required this.currentIndex,
  });

  final int pageCount;
  final int currentIndex;

  static const double _buttonSize = 48;
  static const double _inactiveDotAlpha = 0.35;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: StoriesTexts.back,
          color: StoriesColors.text,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        Expanded(
          child: Center(
            child: StoryProgressDots(
              count: pageCount,
              currentIndex: currentIndex,
              activeColor: StoriesColors.edge,
              inactiveColor: StoriesColors.edge.withValues(
                alpha: _inactiveDotAlpha,
              ),
            ),
          ),
        ),
        // Keeps the dots centered, same width as the close button.
        const SizedBox(width: _buttonSize),
      ],
    );
  }
}
