import 'dart:ui';
import 'package:flutter/material.dart' as material;

class ResColors {
  static const primary = Color(0xFFE2DE7E);
  static const secondary = Color(0xFFC7A6E9);
  static const dark = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const error = Color(0xFFB00020);
  static const success = Color(0xFF00C853);
  static const black = Color(0xFF000000);
  static const failed = Color(0xFFB00020);
  static const info = Color(0xFF2196F3);
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFFF5F5F5);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textColorDisabled = Color(0xFFBDBDBD);
  static const Color textColorLink = Color(0xFF2196F3);
  static const Color textColorError = Color(0xFFE53935);
  static const Color transparent = Color(0x00000000);

  // Primary Swatch
  static const primarySwatch = material.MaterialColor(
    0xFFE2DE7E, // Primary color value
    <int, Color>{
      50: Color(0xFFFBFAEF),  // Lightest
      100: Color(0xFFF7F6E0),
      200: Color(0xFFF2F0CE),
      300: Color(0xFFEDEBBD),
      400: Color(0xFFE7E5A0),
      500: Color(0xFFE2DE7E),  // Primary
      600: Color(0xFFCCC975),
      700: Color(0xFFB3B168),
      800: Color(0xFF99975A),
      900: Color(0xFF807F4C),  // Darkest
    },
  );

}