import 'package:flutter/material.dart';

/// Shows an emoji so that it fills the space it is given.
/// Temporary: replace it with Image.asset once the final images are ready.
class EmojiIcon extends StatelessWidget {
  const EmojiIcon({super.key, required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return FittedBox(child: Text(emoji));
  }
}