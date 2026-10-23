import 'package:flutter/material.dart';


class HomeSectionColors {
  const HomeSectionColors({
    required this.background,
    required this.accent,
    required this.title,
  });

  final Color background;
  final Color accent;
  final Color title;
}

class HomeStyle {
  const HomeStyle._();

  static const Color screenBackground = Color(0xFFF3F9FF);
  static const Color appBarBackground = Colors.white;
  static const Color primaryText = Color(0xFF1F2A44);
  static const Color star = Color(0xFFF5B400);
  static const Color badgeBorder = Color(0xFFD6E8F7);
  static const Color progressTrack = Colors.white;
  static const Color iconCircle = Colors.white;

  static const Color welcomeGradientStart = Color(0xFFFFF3E0);
  static const Color welcomeGradientEnd = Color(0xFFE8F1FA);
  static const Color welcomeAccent = Color(0xFFE8A04C);

  static const HomeSectionColors communication = HomeSectionColors(
    background: Color(0xFFE3F1FD),
    accent: Color(0xFF4DA9E6),
    title: Color(0xFF1B4B7A),
  );
  static const HomeSectionColors dailyRoutine = HomeSectionColors(
    background: Color(0xFFE3F6E9),
    accent: Color(0xFF46BE7B),
    title: Color(0xFF1F5C3B),
  );
  static const HomeSectionColors socialSituations = HomeSectionColors(
    background: Color(0xFFFFE1EC),
    accent: Color(0xFFEA79A2),
    title: Color(0xFF8A1F4A),
  );

  // أسماء الخطوط زي ما هي متسجلة في pubspec.yaml
  static const String headingFont = 'BalooBhaijaan2';
  static const String bodyFont = 'ReadexPro';

  static const double screenPadding = 16;
  static const double cardSpacing = 16;
  static const double cardRadius = 28;
  static const double cardDepth = 6;
  static const double iconCircleSize = 76;
  static const double iconSize = 44;
  static const double progressHeight = 12;
  static const double starsBadgeWidth = 100;
}


class HomeAssets {
  const HomeAssets._();

  static const String bear = 'assets/images/home/bear.png';
  static const String communication =
      'assets/images/navigation/communication.png';
  static const String routines = 'assets/images/navigation/routines.png';
  static const String socialSituations =
      'assets/images/navigation/social_situations.png';
}