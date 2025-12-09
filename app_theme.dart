import 'package:flutter/material.dart';

class AppTheme {
  // ---------------------
  // BRAND COLOR PALETTE - VIBRANT & PROFESSIONAL
  // ---------------------
  static const Color porcelainWhite = Color(0xFFF8F4F0);
  static const Color warmTaupe = Color(0xFFB19F91);
  static const Color smokedCharcoal = Color(0xFF48494B);
  static const Color deepOnyx = Color(0xFF1C1C1C);

  // Vibrant variations for better visibility
  static const Color taupeVibrant = Color(0xFFB19F91); // Original, used prominently
  static const Color charcoalRich = Color(0xFF48494B); // Original, high contrast
  
  // Text colors
  static const Color textDark = deepOnyx;
  static const Color textLight = Colors.white;

  // -------------------------
  // LIGHT THEME - PROFESSIONAL & VIBRANT
  // -------------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: smokedCharcoal,
      secondary: warmTaupe,
      tertiary: deepOnyx,
      background: porcelainWhite,
      surface: Colors.white,
      surfaceContainerHighest: porcelainWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: deepOnyx,
      onSurface: deepOnyx,
      error: Color(0xFFD32F2F),
      outline: warmTaupe,
    ),

    scaffoldBackgroundColor: porcelainWhite,

    appBarTheme: const AppBarTheme(
      backgroundColor: smokedCharcoal,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.3,
      ),
      iconTheme: IconThemeData(color: Colors.white, size: 26),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: warmTaupe, width: 1.5),
      ),
      shadowColor: smokedCharcoal.withOpacity(0.15),
      margin: const EdgeInsets.all(8),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: smokedCharcoal,
      unselectedItemColor: warmTaupe,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: warmTaupe,
      foregroundColor: Colors.white,
      elevation: 6,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: smokedCharcoal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        elevation: 4,
        shadowColor: smokedCharcoal.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.8,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: smokedCharcoal,
        side: const BorderSide(color: smokedCharcoal, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.8,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: warmTaupe,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: warmTaupe.withOpacity(0.25),
      selectedColor: warmTaupe,
      deleteIconColor: smokedCharcoal,
      labelStyle: const TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      secondaryLabelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: warmTaupe, width: 1.5),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(
        color: smokedCharcoal.withOpacity(0.5),
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: smokedCharcoal,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: warmTaupe, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: warmTaupe, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: smokedCharcoal, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    dividerTheme: DividerThemeData(
      color: warmTaupe.withOpacity(0.4),
      thickness: 1.5,
      space: 24,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w700,
        fontSize: 28,
      ),
      headlineLarge: TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      headlineMedium: TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.5,
      ),
    ),
  );

  // -------------------------
  // DARK THEME - PROFESSIONAL & VIBRANT
  // -------------------------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: warmTaupe,
      secondary: smokedCharcoal,
      tertiary: porcelainWhite,
      background: deepOnyx,
      surface: Color(0xFF2C2C2E),
      surfaceContainerHighest: Color(0xFF3A3A3C),
      onPrimary: deepOnyx,
      onSecondary: Colors.white,
      onBackground: porcelainWhite,
      onSurface: porcelainWhite,
      error: Color(0xFFEF5350),
      outline: warmTaupe,
    ),

    scaffoldBackgroundColor: deepOnyx,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2C2C2E),
      foregroundColor: porcelainWhite,
      elevation: 4,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: porcelainWhite,
        letterSpacing: 0.3,
      ),
      iconTheme: IconThemeData(color: porcelainWhite, size: 26),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF2C2C2E),
      elevation: 6,
      shadowColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: warmTaupe, width: 1.5),
      ),
      margin: const EdgeInsets.all(8),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2C2C2E),
      selectedItemColor: warmTaupe,
      unselectedItemColor: Color(0xFF8E8E93),
      type: BottomNavigationBarType.fixed,
      elevation: 12,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: warmTaupe,
      foregroundColor: deepOnyx,
      elevation: 6,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: warmTaupe,
        foregroundColor: deepOnyx,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        elevation: 6,
        shadowColor: warmTaupe.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.8,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: warmTaupe,
        side: const BorderSide(color: warmTaupe, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.8,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: warmTaupe,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: warmTaupe.withOpacity(0.2),
      selectedColor: warmTaupe,
      deleteIconColor: porcelainWhite,
      labelStyle: const TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      secondaryLabelStyle: const TextStyle(
        color: deepOnyx,
        fontWeight: FontWeight.w700,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: warmTaupe, width: 1.5),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2E),
      hintStyle: const TextStyle(
        color: Color(0xFF8E8E93),
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: warmTaupe, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: warmTaupe, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: warmTaupe, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    dividerTheme: DividerThemeData(
      color: warmTaupe.withOpacity(0.3),
      thickness: 1.5,
      space: 24,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w700,
        fontSize: 28,
      ),
      headlineLarge: TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      headlineMedium: TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: porcelainWhite,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.5,
      ),
    ),
  );
}