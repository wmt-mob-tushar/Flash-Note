import 'dart:ui';
import 'package:flutter/material.dart' as material;

class ResColors {
  static const primary = Color(0xFFE2DE7E);
  static const secondary = Color(0xFFC7A6E9);
  static const dark = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const error = Color(0xFFB00020);

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