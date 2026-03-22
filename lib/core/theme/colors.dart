import 'package:flutter/material.dart';

class AppColors {
  // Primary & Secondary (Electric Blue)
  static const Color primary = Color(0xFF85ADFF);
  static const Color primaryDim = Color(0xFF0070EB);
  static const Color secondary = Color(0xFF7F98FF);
  static const Color accent = Color(0xFF00B2FF);

  // Surface Hierarchy (The Obsidian Lens)
  static const Color background = Color(0xFF0E0E0E); // Infinite void
  static const Color surfaceLow = Color(0xFF131313); // Section Layer
  static const Color surface = Color(0xFF1A1919);    // Base Surface
  static const Color surfaceHigh = Color(0xFF201F1F); // Component Layer
  static const Color surfaceBright = Color(0xFF2C2C2C); // Floating Layer
  static const Color surfaceLowest = Color(0xFF000000); // Input Base

  // Gradients (Metallic & Glass)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDim, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surfaceLow, surfaceHigh],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF201F1F), Color(0xFF131313)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status Colors
  static const Color success = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);
  static const Color tertiary = Color(0xFFFAB0FF); // For highlights

  // Text Colors (Refined Editorial)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFADAAAA); // on_surface_variant
  static const Color textDimmed = Color(0xFF767575);    // outline

  // Backdrop / Glass Tokens
  static const Color glassBackground = Color(0x990E0E0E); // 60% opacity
  static const double glassBlur = 20.0;

  // Elevation Colors
  static Color get shadowColor => Colors.white.withValues(alpha: 0.06);

  // Backward Compatibility / Utilities
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceLight = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextDimmed = Color(0xFF94A3B8);
  static const Color info = Color(0xFF3B82F6);
  static const Color surfaceLight = Color(0xFF2C2C2C); // Alias for surfaceBright

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
