import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_texts.dart';

/// The big main button of a page, grayed out when it cannot be pressed.
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.hue = CommunicationHue.blue,
  });

  final String label;
  final VoidCallback? onPressed;
  final CommunicationHue hue;

  static const double _height = 56;
  static const double _disabledAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: hue.text,
        foregroundColor: Colors.white,
        disabledBackgroundColor: hue.text.withValues(alpha: _disabledAlpha),
        disabledForegroundColor: Colors.white,
        minimumSize: const Size(0, _height),
        shape: const StadiumBorder(),
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      child: Text(label),
    );
  }
}

/// The "sound" button that reads the sentence out loud.
class SoundButton extends StatelessWidget {
  const SoundButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  static const double _height = 56;
  static const double _borderWidth = 2;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.volume_up_rounded),
      label: const Text(CommunicationTexts.sound),
      style: OutlinedButton.styleFrom(
        foregroundColor: CommunicationColors.text,
        minimumSize: const Size(0, _height),
        shape: const StadiumBorder(),
        side: const BorderSide(
          color: CommunicationColors.edge,
          width: _borderWidth,
        ),
      ),
    );
  }
}

/// A pill button that selects a category; the selected one is filled.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.title,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _borderWidth = 2;
  static const double _minHeight = 48;
  static const double _horizontalPadding = 14;
  static const double _spacing = 6;

  @override
  Widget build(BuildContext context) {
    const shape = StadiumBorder();
    final textColor = isSelected ? Colors.white : CommunicationColors.text;

    return Material(
      color: isSelected ? CommunicationColors.text : Colors.white,
      shape: shape.copyWith(
        side: const BorderSide(
          color: CommunicationColors.edge,
          width: _borderWidth,
        ),
      ),
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji),
                const SizedBox(width: _spacing),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
