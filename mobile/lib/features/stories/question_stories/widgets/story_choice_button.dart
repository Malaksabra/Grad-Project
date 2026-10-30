import 'package:flutter/material.dart';

import '../../stories_colors.dart';
import '../question_stories_colors.dart';

/// How a choice looks, depending on what the child did.
enum StoryChoiceState { idle, correct, unavailable }

/// One answer under the question. It can show a small picture above the
/// label. A wrong or unused answer fades and stops reacting to taps.
class StoryChoiceButton extends StatelessWidget {
  const StoryChoiceButton({
    super.key,
    required this.label,
    required this.state,
    required this.onPressed,
    this.imagePath,
  });

  final String label;
  final String? imagePath;
  final StoryChoiceState state;
  final VoidCallback onPressed;

  static const double _radius = 28;
  static const double _edgeHeight = 6;
  static const double _minHeight = 64;
  static const double _padding = 12;
  // The picture fills the top of the button edge to edge (width / height).
  static const double _imageAspectRatio = 1.2;
  static const double _fontSize = 20;
  static const double _unavailableOpacity = 0.45;

  bool get _isCorrect => state == StoryChoiceState.correct;
  bool get _isUnavailable => state == StoryChoiceState.unavailable;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);
    final path = imagePath;

    return Opacity(
      opacity: _isUnavailable ? _unavailableOpacity : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _isCorrect
              ? QuestionStoriesColors.correctBackground
              : StoriesColors.background,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: _isCorrect
                  ? QuestionStoriesColors.correctEdge
                  : StoriesColors.edge,
              offset: const Offset(0, _edgeHeight),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: state == StoryChoiceState.idle ? onPressed : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _minHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (path != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(_radius),
                      ),
                      child: AspectRatio(
                        aspectRatio: _imageAspectRatio,
                        child: Image.asset(
                          path,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(_padding),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: StoriesColors.text,
                        fontSize: _fontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
