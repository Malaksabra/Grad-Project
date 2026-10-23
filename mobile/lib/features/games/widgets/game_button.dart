import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_styles.dart';
import 'thick_box.dart';

/// A pill button of the games section.
/// [primary] is the filled one. A null [onTap] shows it faded and disabled.
class GameButton extends StatelessWidget {
  const GameButton(
    this.label, {
    super.key,
    this.onTap,
    this.primary = false,
    this.big = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool primary;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      excludeSemantics: true,
      label: label,
      child: Opacity(
        opacity: onTap == null ? 0.45 : 1,
        child: GestureDetector(
          onTap: onTap,
          child: ThickBox(
            fill: primary ? GamesColors.text : Colors.white,
            border: primary ? GamesColors.text : GamesColors.edge,
            radius: BorderRadius.circular(999),
            constraints: BoxConstraints(minHeight: big ? 60 : 52),
            padding: EdgeInsets.symmetric(horizontal: big ? 30 : 22),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GamesStyles.body(
                  size: big ? 18.4 : 16.3,
                  weight: FontWeight.w500,
                  color: primary ? Colors.white : GamesColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
