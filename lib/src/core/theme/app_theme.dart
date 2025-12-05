import 'package:flutter/material.dart';
import 'package:shop_agence/src/core/helpers/adaptative_dark_theme.dart';

class AppTheme {
  final bool isDarkmode;

  AppTheme({required this.isDarkmode});

  // COLORES PRINCIPALES
  static const Color primaryColor = Color(
    0xFF3366CC,
  ); // Azul principal del tema
  static const Color secondaryColor = Color(0xFF34A853); // Verde ingresos
  static const Color expenseColor = Color(0xFFEA4335); // Rojo gastos
  static const Color accentColor = Color(0xFFFF9500); // Naranja

  // COLORES APP
  static const Color blue = Color(0xFF0059D6);
  static const Color blueForDarkMode = Color(0xFF5087E6);
  static const Color blueTitle = Color(0xFF2F1BB0);
  static const Color red = Color(0xffB11C1C);
  static const Color platinum = Color(0xfff6f6f6);
  static const Color green = Color(0xFF34A853);
  static const Color pink = Color(0xFFFF6F61);
  static const Color pinkClaro = Color(0xFFFF8B78);
  static const Color pinkDark = Color(0xFFCC554D);
  static const Color lightGrey = Color(0xffe5e5e7);
  static const Color mediumGrey = Color(0xff808084);
  static const Color darkGrey = Color(0xFF0F0C25);
  static const Color black = Color(0xFF080845);
  static const Color blackdark = Color(0xFF0F0C35);

  // COLORES BASE PARA TEMAS
  static const Color lightScaffoldBackground = Color(0xFFF8F9FA);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightDialogBackground = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF8E8E93);
  static const Color lightTextDisabled = Color(0xFFC7C7CC);

  // COLORES PARA TEMA OSCURO - NEGRO
  static const Color darkScaffoldBackground = Color(0xFF0F0C25);
  static const Color darkCardColor = Color(0xFF1A1A1A);
  static const Color darkDialogBackground = Color(0xFF1A1A1A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextDisabled = Color(0xFF6D6D6D);

  // COLORES ESPECÍFICOS PARA EL DRAWER
  static const Color lightDrawerBackground = Color(
    0xFF34A853,
  ); // Pink para tema claro
  static const Color darkDrawerBackground = Color(
    0xFF000000,
  ); // Negro para tema oscuro
  static const Color drawerForeground = Color(
    0xFFFFFFFF,
  ); // Texto siempre blanco

  // COLORES SEMÁNTICOS
  static const Color successColor = Color(0xFF34C759);
  static const Color warningColor = Color(0xFFFF9500);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color infoColor = Color(0xFF007AFF);

  ThemeData getTheme() {
    if (!isDarkmode) {
      return _buildLightTheme();
    } else {
      return _buildDarkTheme();
    }
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: green, 
      scaffoldBackgroundColor: lightScaffoldBackground,
      cardColor: lightCardColor,
      dialogBackgroundColor: lightDialogBackground,
      colorScheme: ColorScheme.light(
        primary: pink, 
        secondary: secondaryColor,
        surface: lightCardColor,
        background: lightScaffoldBackground,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onBackground: lightTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: lightTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: lightTextSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: lightTextDisabled,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCardColor,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: pink,
            width: 2,
          ), 
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary),
        hintStyle: const TextStyle(color: lightTextDisabled),
        errorStyle: const TextStyle(color: errorColor),
      ),
      cardTheme: CardThemeData(
        color: lightCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: green, 
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E5EA),
        thickness: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF363333),
      scaffoldBackgroundColor: darkScaffoldBackground,
      cardColor: blackdark,
      dialogBackgroundColor: darkDialogBackground,
      colorScheme: ColorScheme.dark(
        primary: darkGrey,
        secondary: secondaryColor,
        surface: darkCardColor,
        background: darkScaffoldBackground,
        error: errorColor,
        onPrimary: Colors.white, 
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkGrey, 
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: darkTextSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: darkTextDisabled,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGrey, 
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkTextDisabled.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkTextDisabled.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: darkGrey,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: TextStyle(color: darkTextSecondary),
        hintStyle: TextStyle(color: darkTextDisabled),
        errorStyle: const TextStyle(color: errorColor),
      ),
      cardTheme: CardThemeData(
        color: darkGrey,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkGrey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: darkTextDisabled.withOpacity(0.3),
        thickness: 1,
      ),
    );
  }

  //  MÉTODOS PARA ACCEDER A COLORES DINÁMICOS
  Color get scaffoldBackgroundColor =>
      isDarkmode ? darkScaffoldBackground : lightScaffoldBackground;
  Color get cardBackgroundColor => isDarkmode ? darkGrey : lightCardColor;
  Color get textPrimaryColor => isDarkmode ? darkTextPrimary : lightTextPrimary;
  Color get textSecondaryColor =>
      isDarkmode ? darkTextSecondary : lightTextSecondary;

  // MÉTODOS PARA COLORES ESPECÍFICOS DE TU APP
  Color get pinkColor => isDarkmode ? pinkDark : pink;
  Color get blueColor => isDarkmode ? blueForDarkMode : blue;

  //  NUEVO: Color para AppBar y FAB
  Color get appBarColor => isDarkmode ? darkGrey : green;
  Color get fabColor => isDarkmode ? black : green;

  //  MÉTODOS PARA EL DRAWER
  Color get drawerBackgroundColor =>
      isDarkmode ? darkGrey : lightDrawerBackground;
  Color get drawerForegroundColor => drawerForeground;

  // MÉTODO PARA TEXTOS ADAPTATIVOS
  AdaptiveTextStyles get textStyles =>
      AdaptiveTextStyles(isDarkMode: isDarkmode);
}
