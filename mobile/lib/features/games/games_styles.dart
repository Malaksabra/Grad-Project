import 'package:flutter/material.dart';

import '../../core/theme/app_fonts.dart';
import 'games_colors.dart';

// Text styles of the games section.
// The fonts are registered in pubspec.yaml and named in AppFonts.
class GamesStyles {
  const GamesStyles._();

  // Normal text.
  static TextStyle body({
    double size = 17,
    FontWeight weight = FontWeight.w400,
    Color color = GamesColors.ink,
  }) {
    return TextStyle(
      fontFamily: AppFonts.body,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.65,
    );
  }

  // Titles and numbers.
  static TextStyle display({double size = 19, Color color = GamesColors.ink}) {
    return TextStyle(
      fontFamily: AppFonts.display,
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.35,
    );
  }
}
