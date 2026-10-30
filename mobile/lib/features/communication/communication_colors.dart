import 'package:flutter/material.dart';

/// A family of three colors. Every card of the communication section picks
/// one; blue is the default. A new family is one new line here.
enum CommunicationHue {
  blue(
    background: Color(0xFFE8F3FC),
    edge: Color(0xFF8FC1EA),
    text: Color(0xFF1E5A8C),
  ),
  green(
    background: Color(0xFFE6F6EC),
    edge: Color(0xFF6FBF8E),
    text: Color(0xFF1F6B3F),
  );

  const CommunicationHue({
    required this.background,
    required this.edge,
    required this.text,
  });

  final Color background;
  final Color edge;
  final Color text;
}

/// Colors of the communication section. They are `const`, so they can be
/// used inside const widgets. Background, edge and text are the blue family.
class CommunicationColors {
  const CommunicationColors._();

  static const Color background = Color(0xFFE8F3FC);
  static const Color edge = Color(0xFF8FC1EA);
  static const Color text = Color(0xFF1E5A8C);

  // The stage of the signs page.
  static const Color stage = Color(0xFFF4F9FE);

  // The teddy.
  static const Color teddyFace = Color(0xFFE8B98A);
  static const Color teddyEar = Color(0xFFC98E5B);
  static const Color teddyCheek = Color(0xFFF2A0A0);
  static const Color teddyEye = Color(0xFF3B2A20);
  static const Color teddyNose = Color(0xFF5A3A28);
}
