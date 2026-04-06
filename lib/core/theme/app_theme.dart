import 'package:flutter/material.dart';

class AppColors {
  // Primary palette — earthy, calm, non-overstimulating
  static const Color seedGreen = Color(0xFF4A7C59);       // primary
  static const Color seedGreenLight = Color(0xFF7AB87A);  // light variant
  static const Color warmCream = Color(0xFFFAF7F0);       // background
  static const Color softAmber = Color(0xFFE8C99A);       // accent
  static const Color skyBlue = Color(0xFF87CEEB);         // child mode accent
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedGreen,
      brightness: Brightness.light,
      surface: AppColors.warmCream,
    ),
    scaffoldBackgroundColor: AppColors.warmCream,
    fontFamily: 'Nunito', // friendly, rounded — good for parents and kids
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.warmCream,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.seedGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.seedGreen, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
