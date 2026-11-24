import 'package:crafty_bay/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's light theme: fonts, app bar, buttons and input fields.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      // Text typed into input fields uses bodyLarge.
      bodyLarge: GoogleFonts.poppins(color: AppColors.inputText),
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      hintStyle: const TextStyle(color: AppColors.inputHint),
      enabledBorder: _border(AppColors.border),
      focusedBorder: _border(AppColors.primary),
      errorBorder: _border(AppColors.error),
      focusedErrorBorder: _border(AppColors.error),
    ),
  );

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color),
  );
}
