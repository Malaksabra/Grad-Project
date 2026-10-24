import 'package:flutter/material.dart';

import '../games_images.dart';
import '../models/game_level.dart';
import 'game_icon.dart';

/// A time such as "2:00", with the timer picture next to it.
class TimeLabel extends StatelessWidget {
  const TimeLabel({
    super.key,
    required this.seconds,
    required this.style,
    required this.iconSize,
  });

  final int seconds;
  final TextStyle style;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GameIcon(GamesImages.timer, size: iconSize),
        const SizedBox(width: 4),
        Text(formatTime(seconds), style: style),
      ],
    );
  }
}
