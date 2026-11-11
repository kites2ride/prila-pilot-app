import 'package:flutter/material.dart';
import 'package:pilot/core/theme/prila_colors.dart';

class PrilaTheme {
  static ThemeData light() => _base(Brightness.light, PrilaColors.light);
  static ThemeData dark() => _base(Brightness.dark, PrilaColors.dark);

  static ThemeData _base(Brightness brightness, PrilaColors colors) {
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: brightness,
      primary: colors.primary,
      secondary: colors.secondary,
      error: colors.danger,
      surface: colors.surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border),
        ),
      ),
    );
  }
}

extension PrilaColorsX on BuildContext {
  PrilaColors get prilaColors => Theme.of(this).extension<PrilaColors>() ?? PrilaColors.light;
}
