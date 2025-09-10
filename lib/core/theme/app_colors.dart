import 'package:flutter/material.dart';

class AppColors {
  // Core brand colors
  static const Color primaryColor = Color(0xFF2D8D79); // #2D8D79
  static const Color primaryLight = Color(0xFF8FC79A); // #8FC79A
  static const Color primaryMuted = Color(0xFF5E9387); // #5E9387
  static const Color accentColor = Color(0xFFCEE9B6); // #CEE9B6

  // Neumorphism base
  static const Color backgroundColor = Color(0xFFF7FBF9);
  static const Color surfaceColor = Color(0xFFF1F6F3);
  static const Color cardColor = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF223233);
  static const Color textSecondary = Color(0xFF536A66);
  static const Color textHint = Color(0xFF93A79F);

  // Status colors (derived / neutral)
  static const Color successColor = primaryLight;
  static const Color warningColor = Color(0xFFF6C85F);
  static const Color errorColor = Color(0xFFEF6C6C);
  static const Color infoColor = Color(0xFF63B3ED);

  // Neumorphism shadow colors
  static const Color lightShadow = Color(0xFFFFFFFF);
  static const Color darkShadow = Color(0xFFCFDFD8);

  // Gradients using the brand palette
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryColor],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, primaryMuted],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundColor, surfaceColor],
  );

  // Light ThemeData helper — use this in MaterialApp(theme: AppColors.lightTheme)
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: primaryLight,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSurface: textPrimary,
    ),
    textTheme: Typography.material2018().black.apply(bodyColor: textPrimary),
    iconTheme: const IconThemeData(color: primaryMuted),
  );
}
