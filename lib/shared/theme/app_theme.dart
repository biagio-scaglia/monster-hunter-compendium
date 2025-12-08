import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Enhanced Color Palette
  static const Color primaryColor = Color(0xFFFF5722); // Deep Orange
  static const Color primaryColorLight = Color(0xFFFF8A65); // Light Orange
  static const Color primaryColorDark = Color(0xFFD84315); // Dark Orange
  static const Color secondaryColor = Color(0xFF3E2723); // Dark Brown
  static const Color secondaryColorLight = Color(0xFF5D4037); // Light Brown
  static const Color accentColor = Color(0xFFAEEA00); // Verde Acido
  static const Color accentColorLight = Color(0xFFC6FF00); // Light Green
  static const Color lightBackground = Color(0xFFFFF8E1); // Beige
  static const Color lightBackgroundSecondary = Color(0xFFFFF3E0); // Light Beige
  static const Color darkBackground = Color(0xFF121212); // Dark Grey (more modern)
  static const Color darkBackgroundSecondary = Color(0xFF1E1E1E); // Dark Grey Secondary
  static const Color primaryText = Color(0xFFFFFFFF); // White
  static const Color secondaryText = Color(0xFFB0BEC5); // Light Grey
  static const Color darkOrange = Color(0xFFE64A19); // Dark Orange
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color successColor = Color(0xFF388E3C); // Green
  static const Color infoColor = Color(0xFF1976D2); // Blue
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Enhanced Gradients
  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [primaryColor, darkOrange, primaryColorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [primaryColor, primaryColorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2C2C2C), Color(0xFF262626), Color(0xFF1F1F1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient rareBadgeGradient = LinearGradient(
    colors: [accentColor, Color(0xFF9CCC65), Color(0xFF8BC34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    stops: [0.0, 0.5, 1.0],
  );

  // Enhanced Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 4,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get rareCardShadow => [
        BoxShadow(
          color: accentColor.withOpacity(0.4),
          blurRadius: 16,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: accentColor.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: primaryColor.withOpacity(0.4),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: primaryColor.withOpacity(0.2),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 3),
        ),
      ];

  // Enhanced Text Styles
  static TextStyle get titleStyle => GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyStyle => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
        height: 1.5,
        letterSpacing: 0.2,
      );

  static TextStyle get buttonStyle => GoogleFonts.robotoCondensed(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: 0.8,
      );

  static TextStyle get cardTitleStyle => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  static TextStyle get cardBodyStyle => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get cardSubtitleStyle => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.1,
      );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      splashColor: primaryColor.withOpacity(0.1),
      highlightColor: primaryColor.withOpacity(0.05),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: Colors.white,
        onPrimary: primaryText,
        onSecondary: primaryText,
        onSurface: secondaryColor,
        onError: primaryText,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: primaryText,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        iconTheme: const IconThemeData(color: primaryText),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.robotoCondensed(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.robotoCondensed(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        displayMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        displaySmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: secondaryColor,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: secondaryColor,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey[700],
        ),
        labelLarge: GoogleFonts.robotoCondensed(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: primaryText,
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.robotoCondensed(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
          shadowColor: primaryColor.withOpacity(0.4),
        ),
      ),
      iconTheme: const IconThemeData(
        color: secondaryColor,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 2.5),
        ),
        hintStyle: GoogleFonts.roboto(
          color: Colors.grey.shade500,
          fontSize: 15,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      splashColor: primaryColor.withOpacity(0.2),
      highlightColor: primaryColor.withOpacity(0.1),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: const Color(0xFF424242),
        onPrimary: primaryText,
        onSecondary: primaryText,
        onSurface: primaryText,
        onError: primaryText,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: primaryText,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.2),
        titleTextStyle: GoogleFonts.robotoCondensed(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryText,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(
          color: primaryText,
          size: 24,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF303030),
        selectedItemColor: accentColor,
        unselectedItemColor: secondaryText,
        selectedLabelStyle: GoogleFonts.robotoCondensed(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.robotoCondensed(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: const Color(0xFF303030),
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceDark,
        shadowColor: Colors.black.withOpacity(0.3),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        displayMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        displaySmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: primaryText,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: primaryText,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: secondaryText,
        ),
        labelLarge: GoogleFonts.robotoCondensed(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: primaryText,
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.robotoCondensed(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
          shadowColor: primaryColor.withOpacity(0.4),
        ),
      ),
      iconTheme: const IconThemeData(
        color: primaryText,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 2.5),
        ),
        hintStyle: GoogleFonts.roboto(
          color: Colors.grey.shade500,
          fontSize: 15,
        ),
      ),
    );
  }
}
