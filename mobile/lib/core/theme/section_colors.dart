import 'package:flutter/material.dart';

/// The two colors of a section: a soft background and a darker text color.
class SectionPalette {
  const SectionPalette({required this.background, required this.text});

  final Color background;
  final Color text;
}

/// One palette per section. Each section owner changes their own palette here.
/// Temporary colors until the team agrees on the final ones.
class SectionColors {
  const SectionColors._();

  static const SectionPalette home = SectionPalette(
    background: Color(0xFFDCEBFF),
    text: Color(0xFF1F4E7A),
  );
  static const SectionPalette communication = SectionPalette(
    background: Color(0xFFDCEBFF),
    text: Color(0xFF1F4E7A),
  );
  static const SectionPalette routines = SectionPalette(
    background: Color(0xFFE3F6E8),
    text: Color(0xFF1B4D2E),
  );
  static const SectionPalette socialSituations = SectionPalette(
    background: Color(0xFFFFE0EC),
    text: Color(0xFF7A1F44),
  );
  static const SectionPalette play = SectionPalette(
    background: Color(0xFFEBE1FF),
    text: Color(0xFF4B2A8A),
  );
}
