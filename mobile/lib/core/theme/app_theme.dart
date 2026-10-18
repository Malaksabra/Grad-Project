import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
      fontFamily: AppFonts.body,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: _display(base.textTheme.headlineLarge),
        headlineMedium: _display(base.textTheme.headlineMedium),
        headlineSmall: _display(base.textTheme.headlineSmall),
        titleLarge: _display(base.textTheme.titleLarge),
      ),
    );
  }

  static TextStyle? _display(TextStyle? style) {
    return style?.copyWith(
      fontFamily: AppFonts.display,
      fontWeight: FontWeight.w700,
    );
  }
}