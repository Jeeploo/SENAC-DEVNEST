import 'package:flutter/material.dart';

class AppColors {
  // Paleta 3 — Ciano + Laranja
  static const primary   = Color(0xFF00ACC1);
  static const secondary = Color(0xFF00838F);
  static const accent    = Color(0xFFFF9800);
  static const background = Color(0xFFF0F0F0);
  static const surface   = Colors.white;
  static const navDark   = Color(0xFF1A2035);

  // Status
  static const statusPendingBg  = Color(0xFFFFF8E1);
  static const statusPendingFg  = Color(0xFFF57F17);
  static const statusPendingDot = Color(0xFFFF9800);

  static const statusApprovedBg  = Color(0xFFE8F5E9);
  static const statusApprovedFg  = Color(0xFF2E7D32);
  static const statusApprovedDot = Color(0xFF43A047);

  static const statusRejectedBg  = Color(0xFFFFEBEE);
  static const statusRejectedFg  = Color(0xFFC62828);
  static const statusRejectedDot = Color(0xFFE53935);

  // Texto
  static const textPrimary   = Color(0xFF111111);
  static const textSecondary = Color(0xFF666666);
  static const textMuted     = Color(0xFFAAAAAA);
  static const border        = Color(0xFFE5E7EB);
}

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Roboto',
  useMaterial3: true,
);

// Cores dos avatares — cycling por índice
const List<Color> kAvatarColors = [
  AppColors.secondary,
  AppColors.accent,
  AppColors.primary,
  Color(0xFFE53935),
  Color(0xFF43A047),
];