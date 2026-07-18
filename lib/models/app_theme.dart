import 'package:flutter/cupertino.dart';

enum AppThemeColor { pink, blue, purple, green, orange }

class ThemeColors {
  final Color primary;
  final Color secondary;

  const ThemeColors({required this.primary, required this.secondary});

  static ThemeColors from(AppThemeColor theme) {
    switch (theme) {
      case AppThemeColor.pink:
        return const ThemeColors(
          primary: Color(0xFFC2185B),
          secondary: Color(0xFFF48FB1),
        );
      case AppThemeColor.blue:
        return const ThemeColors(
          primary: Color(0xFF1565C0),
          secondary: Color(0xFF90CAF9),
        );
      case AppThemeColor.purple:
        return const ThemeColors(
          primary: Color(0xFF6A1B9A),
          secondary: Color(0xFFCE93D8),
        );
      case AppThemeColor.green:
        return const ThemeColors(
          primary: Color(0xFF2E7D32),
          secondary: Color(0xFFA5D6A7),
        );
      case AppThemeColor.orange:
        return const ThemeColors(
          primary: Color(0xFFEF6C00),
          secondary: Color(0xFFFFCC80),
        );
    }
  }
}
