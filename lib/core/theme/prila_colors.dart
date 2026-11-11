import 'package:flutter/material.dart';

@immutable
class PrilaColors extends ThemeExtension<PrilaColors> {
  const PrilaColors({
    required this.primary,
    required this.secondary,
    required this.pickup,
    required this.drop,
    required this.danger,
    required this.background,
    required this.surface,
    required this.raised,
    required this.border,
    required this.brandGradient,
  });

  final Color primary;
  final Color secondary;
  final Color pickup;
  final Color drop;
  final Color danger;
  final Color background;
  final Color surface;
  final Color raised;
  final Color border;
  final Gradient brandGradient;

  static const light = PrilaColors(
    primary: Color(0xFF8B2CF5),
    secondary: Color(0xFFFF2D95),
    pickup: Color(0xFF5BD100),
    drop: Color(0xFFFF2D95),
    danger: Color(0xFFE53935),
    background: Color(0xFFF7F6FB),
    surface: Color(0xFFFFFFFF),
    raised: Color(0xFFFFFFFF),
    border: Color(0xFFECEAF2),
    brandGradient: LinearGradient(
      colors: [
        Color(0xFFFFC400),
        Color(0xFFFF8A00),
        Color(0xFFFF2D95),
        Color(0xFF8B2CF5),
        Color(0xFF00C2FF),
      ],
    ),
  );

  static const dark = PrilaColors(
    primary: Color(0xFF8B2CF5),
    secondary: Color(0xFFFF2D95),
    pickup: Color(0xFF5BD100),
    drop: Color(0xFFFF2D95),
    danger: Color(0xFFE53935),
    background: Color(0xFF0B0B12),
    surface: Color(0xFF16161F),
    raised: Color(0xFF1E1E2A),
    border: Color(0xFF2A2A38),
    brandGradient: LinearGradient(
      colors: [
        Color(0xFFFFC400),
        Color(0xFFFF8A00),
        Color(0xFFFF2D95),
        Color(0xFF8B2CF5),
        Color(0xFF00C2FF),
      ],
    ),
  );

  @override
  PrilaColors copyWith({
    Color? primary,
    Color? secondary,
    Color? pickup,
    Color? drop,
    Color? danger,
    Color? background,
    Color? surface,
    Color? raised,
    Color? border,
    Gradient? brandGradient,
  }) {
    return PrilaColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      pickup: pickup ?? this.pickup,
      drop: drop ?? this.drop,
      danger: danger ?? this.danger,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      raised: raised ?? this.raised,
      border: border ?? this.border,
      brandGradient: brandGradient ?? this.brandGradient,
    );
  }

  @override
  PrilaColors lerp(ThemeExtension<PrilaColors>? other, double t) {
    if (other is! PrilaColors) return this;
    return PrilaColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      pickup: Color.lerp(pickup, other.pickup, t)!,
      drop: Color.lerp(drop, other.drop, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      border: Color.lerp(border, other.border, t)!,
      brandGradient: t < 0.5 ? brandGradient : other.brandGradient,
    );
  }
}
