import 'package:flutter/material.dart';

/// One color family: a soft background, a strong edge, and a dark text color.
/// The values are copied from the prototype, so the app matches it exactly.
class CommunicationHue {
  const CommunicationHue({
    required this.background,
    required this.edge,
    required this.text,
  });

  final Color background;
  final Color edge;
  final Color text;

  /// Blue: the whole communication section, including the signs page.
  static const CommunicationHue blue = CommunicationHue(
    background: CommunicationColors.blueBackground,
    edge: CommunicationColors.blueEdge,
    text: CommunicationColors.blueText,
  );
}

// Colors of the communication section, taken from the prototype.
// To change a color of the whole section, change it here only.
class CommunicationColors {
  const CommunicationColors._();

  // Blue (prototype: --comm, --comm-strong, --comm-ink).
  static const Color blueBackground = Color(0xFFE2F2FE);
  static const Color blueEdge = Color(0xFF52AEE5);
  static const Color blueText = Color(0xFF154C73);

  // The default of the section is blue, so older code keeps working.
  static const Color background = blueBackground;
  static const Color edge = blueEdge;
  static const Color text = blueText;

  // Background of the white-ish stage that holds an activity.
  static const Color stage = Color(0xFFF2F7FC);

  // The teddy keeps its own colors so it looks the same on every page.
  static const Color teddyEar = Color(0xFFE89C47);
  static const Color teddyFace = Color(0xFFFFF4E6);
  static const Color teddyCheek = Color(0xFFE873A2);
  static const Color teddyEye = Color(0xFF22304A);
  static const Color teddyNose = Color(0xFF703C08);
}
