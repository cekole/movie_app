import 'package:flutter/material.dart';

/// App color palette
abstract class AppColors {
  // Primary colors
  static const Color black = Color(0xFF0F0E0E);
  static const Color white = Color(0xFFF3E9E9);
  static const Color gray = Color(0xFFDED5D5);
  static const Color grayDark = Color(0xFF968D8D);
  static const Color redDark = Color(0xFF8C2626);
  static const Color redLight = Color(0xFFCB2C2C);

  // Semantic colors
  static const Color primary = redLight;
  static const Color primaryDark = redDark;
  static const Color background = black;
  static const Color surface = Color(0xFF1A1818);
  static const Color textPrimary = white;
  static const Color textSecondary = gray;
  static const Color textTertiary = grayDark;
  static const Color error = redDark;

  // Rating color
  static const Color rating = Color(0xFFFFD700);
}
