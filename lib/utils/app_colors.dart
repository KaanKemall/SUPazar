import 'package:flutter/material.dart';

/// All colors used in the app. Screens never use raw Color values,
/// they always read from here so the design stays consistent.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF12355B); // navy
  static const Color primaryLight = Color(0xFF2F5D8C);
  static const Color accent = Color(0xFFF28C28); // orange
  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color soldBadge = Color(0xFF6B7280);
  static const Color chipSelected = primary;
  static const Color onPrimary = Colors.white;
}
