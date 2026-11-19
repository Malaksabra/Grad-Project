import 'package:flutter/material.dart';

import '../games_colors.dart';

/// The bar that gets shorter while the time runs out.
class TimeBar extends StatelessWidget {
  const TimeBar({super.key, required this.value});

  /// From 1.0 (full time) to 0.0 (time is up).
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: GamesColors.line, width: 2),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: GamesColors.edge,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}
