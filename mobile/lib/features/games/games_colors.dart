import 'package:flutter/material.dart';

import '../../core/theme/section_colors.dart';

// Colors of the games section.
// The main two colors come from SectionColors.play, so the tab bar and the
// games pages always match. To change them, change them there only.
// The other colors are used inside the games pages only.
class GamesColors {
  const GamesColors._();

  // Same as the games tab (purple).
  static Color get background => SectionColors.play.background;
  static Color get text => SectionColors.play.text;

  // The strong purple used for borders, the timer bar and the play icons.
  static const Color edge = Color(0xFF9B79E0);

  // The faint purple border around the white panels (the edge at 45% opacity).
  static const Color panelBorder = Color(0x739B79E0);

  // Neutral colors, copied from the prototype.
  static const Color ink = Color(0xFF22304A);
  static const Color inkSoft = Color(0xFF5A6A86);

  // Soft lavender for lines and panel backgrounds.
  static const Color line = Color(0xFFE6DEF5);
  static const Color surface = Color(0xFFF6F2FD);

  // The star shown when the child wins.
  static const Color star = Color(0xFFF5C73B);
}
