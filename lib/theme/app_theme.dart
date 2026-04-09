import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Common Colors
  static const Color myTerracotta = Color(0xFFE2725B);

  // Light Mode Colors
  static const Color _lightBackground = Colors.white;
  static const Color _lightSurface = Color(0xFFFAF9F6); // Off-white cards
  static const Color _lightPrimary = Color(0xFF2E8B57); // Forest Green
  static const Color _lightText = Colors.black87;
  static const Color _lightTextSecondary = Colors.grey;

  // Dark Mode Colors
  static const Color _darkBackground = Color(0xFF121212); // Deep Charcoal
  static const Color _darkSurface = Color(0xFF2C2C2C); // Floating Cards depth
  static const Color _darkPrimary = Color(0xFF48A672); // Brightened Forest Green
  static const Color _darkText = Color(0xFFECECEC); // Off-white text

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _lightPrimary,
      scaffoldBackgroundColor: _lightBackground,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: myTerracotta,
        surface: _lightSurface,
        onSurface: _lightText,
        onSecondary: _lightTextSecondary,
      ),
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: _lightText,
        displayColor: _lightText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        foregroundColor: _lightText,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _lightBackground,
        selectedColor: _lightPrimary,
        labelStyle: GoogleFonts.montserrat(color: _lightText),
        secondaryLabelStyle: GoogleFonts.montserrat(color: Colors.white),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _darkPrimary,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: myTerracotta,
        surface: _darkSurface,
        onSurface: _darkText,
      ),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: _darkText,
        displayColor: _darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        foregroundColor: _darkText,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _darkSurface,
        selectedColor: _darkPrimary,
        labelStyle: GoogleFonts.montserrat(color: _darkText),
        secondaryLabelStyle: GoogleFonts.montserrat(color: Colors.white),
      ),
    );
  }
}
