import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎯 Palette Principale (Core Theme)
  // Questa è la palette base che userai per UI, componenti principali e mood generale.
  
  static const Color dragonSteel = Color(0xFF3A3F44); // Metallo dark, base UI, come armatura Nergigante
  static const Color hunterBrown = Color(0xFF5B4734); // Cuoio, classico MH
  static const Color wyvernGold = Color(0xFFD2A95B); // Oro vissuto, accenti premium
  static const Color tribalRed = Color(0xFFA3392C); // Rosso da caccia, sangue/energia
  static const Color ancientBone = Color(0xFFE3D7C3); // Osso chiaro per UI light o highlight
  static const Color deepForest = Color(0xFF26442A); // Foglia scura, atmosfera giungla
  static const Color oceanScale = Color(0xFF3E6C7B); // Scaglie acquatiche, vibe Legiana / Mizutsune
  static const Color elderPurple = Color(0xFF6C4A7C); // Tono "elder dragon" mistico

  // 🌑 Modalità Dark (consigliata per MH)
  // Il tema perfetto per un'app da cacciatori notturni.
  
  static const Color darkBackground = Color(0xFF1C1E20);
  static const Color darkCard = Color(0xFF2B2F33);
  static const Color darkBorder = Color(0xFF3A3F44);
  static const Color darkTextPrimary = Color(0xFFEDEDED);
  static const Color darkTextSecondary = Color(0xFFB9B9B9);
  static const Color darkAccentGold = Color(0xFFD2A95B);
  static const Color darkAccentDanger = Color(0xFFA3392C);

  // 🌕 Modalità Light (in stile libro del Grembiule)
  // Per quando vuoi un mood più "manuale di caccia".
  
  static const Color lightBackground = Color(0xFFF2EEE7);
  static const Color lightCard = Color(0xFFE7E2DB);
  static const Color lightBorder = Color(0xFFC7C2B8);
  static const Color lightTextPrimary = Color(0xFF3A3F44);
  static const Color lightTextSecondary = Color(0xFF5B5B5B);
  static const Color lightAccentGold = Color(0xFFC89A4D);
  static const Color lightAccentGreen = Color(0xFF4A6E4F);

  // 🔥 Gradient ufficiali (per header, card rare, transizioni)
  
  // 1. Elder Dragon Aura
  static const LinearGradient elderDragonAura = LinearGradient(
    colors: [Color(0xFF6C4A7C), Color(0xFF3A3F44)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 2. Rathalos Blaze
  static const LinearGradient rathalosBlaze = LinearGradient(
    colors: [Color(0xFFA3392C), Color(0xFFD2A95B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 3. Legiana Frost
  static const LinearGradient legianaFrost = LinearGradient(
    colors: [Color(0xFF3E6C7B), Color(0xFFD2E7F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 4. Nergigante Spike
  static const LinearGradient nergiganteSpike = LinearGradient(
    colors: [Color(0xFF1C1E20), Color(0xFF5B4734)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 🧱 Component Palette (pronto all'uso per Flutter)
  
  // Button Primary
  static const Color buttonPrimaryBackground = Color(0xFFD2A95B);
  static const Color buttonPrimaryText = Color(0xFF1C1E20);
  
  // Button Secondary
  static const Color buttonSecondaryBackground = Color(0xFF3A3F44);
  static const Color buttonSecondaryText = Color(0xFFEDEDED);
  
  // Status Colors
  static const Color successColor = Color(0xFF4A6E4F);
  static const Color warningColor = Color(0xFFD2A95B);
  static const Color dangerColor = Color(0xFFA3392C);
  static const Color infoColor = Color(0xFF3E6C7B);

  // 🖌️ Colori per Tipologie Mostri (per tag/taglist)
  
  static const Color flyingWyvern = Color(0xFFA3392C);
  static const Color fangedWyvern = Color(0xFF5B4734);
  static const Color piscineWyvern = Color(0xFF3E6C7B);
  static const Color elderDragon = Color(0xFF6C4A7C);
  static const Color birdWyvern = Color(0xFFC89A4D);
  static const Color bruteWyvern = Color(0xFF3A3F44);

  // Legacy color aliases (per compatibilità con codice esistente)
  static const Color primaryColor = wyvernGold;
  static const Color primaryColorLight = Color(0xFFE5C17A);
  static const Color primaryColorDark = Color(0xFFB8944A);
  static const Color secondaryColor = dragonSteel;
  static const Color secondaryColorLight = Color(0xFF4A5157);
  static const Color accentColor = wyvernGold;
  static const Color accentColorLight = Color(0xFFE5C17A);
  static const Color lightBackgroundSecondary = Color(0xFFEDE8DF);
  static const Color darkBackgroundSecondary = Color(0xFF25282C);
  static const Color primaryText = darkTextPrimary;
  static const Color secondaryText = darkTextSecondary;
  static const Color errorColor = dangerColor;
  static const Color surfaceLight = lightCard;
  static const Color surfaceDark = darkCard;

  // Enhanced Gradients (usando i nuovi gradienti ufficiali)
  static const LinearGradient primaryButtonGradient = rathalosBlaze;
  
  static const LinearGradient appBarGradient = elderDragonAura;
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFE7E2DB), Color(0xFFE3D7C3), Color(0xFFDDD0BD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2B2F33), Color(0xFF25282C), Color(0xFF1F2326)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient rareBadgeGradient = LinearGradient(
    colors: [Color(0xFFD2A95B), Color(0xFFC89A4D), Color(0xFFB8944A)],
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
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get rareCardShadow => [
        BoxShadow(
          color: wyvernGold.withValues(alpha: 0.4),
          blurRadius: 16,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: wyvernGold.withValues(alpha: 0.2),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: wyvernGold.withValues(alpha: 0.4),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: wyvernGold.withValues(alpha: 0.2),
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
      splashColor: wyvernGold.withValues(alpha: 0.1),
      highlightColor: wyvernGold.withValues(alpha: 0.05),
      colorScheme: ColorScheme.light(
        primary: wyvernGold,
        secondary: dragonSteel,
        tertiary: lightAccentGreen,
        error: dangerColor,
        surface: lightCard,
        onPrimary: buttonPrimaryText,
        onSecondary: lightTextPrimary,
        onSurface: lightTextPrimary,
        onError: darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: dragonSteel,
        foregroundColor: darkTextPrimary,
        titleTextStyle: GoogleFonts.robotoCondensed(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: darkTextPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightCard,
        selectedItemColor: lightAccentGold,
        unselectedItemColor: lightTextSecondary,
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
        backgroundColor: lightCard,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: lightCard,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        displayMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        displaySmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: lightTextPrimary,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: lightTextPrimary,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: lightTextSecondary,
        ),
        labelLarge: GoogleFonts.robotoCondensed(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonPrimaryBackground,
          foregroundColor: buttonPrimaryText,
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
          shadowColor: wyvernGold.withValues(alpha: 0.4),
        ),
      ),
      iconTheme: const IconThemeData(
        color: lightTextPrimary,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: wyvernGold, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 2.5),
        ),
        hintStyle: GoogleFonts.roboto(
          color: lightTextSecondary,
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
      splashColor: wyvernGold.withValues(alpha: 0.2),
      highlightColor: wyvernGold.withValues(alpha: 0.1),
      colorScheme: ColorScheme.dark(
        primary: wyvernGold,
        secondary: dragonSteel,
        tertiary: oceanScale,
        error: dangerColor,
        surface: darkCard,
        onPrimary: buttonPrimaryText,
        onSecondary: darkTextPrimary,
        onSurface: darkTextPrimary,
        onError: darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: dragonSteel,
        foregroundColor: darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        titleTextStyle: GoogleFonts.robotoCondensed(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(
          color: darkTextPrimary,
          size: 24,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkCard,
        selectedItemColor: darkAccentGold,
        unselectedItemColor: darkTextSecondary,
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
        backgroundColor: darkCard,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: darkCard,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displayMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displaySmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkTextPrimary,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: darkTextSecondary,
        ),
        labelLarge: GoogleFonts.robotoCondensed(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonPrimaryBackground,
          foregroundColor: buttonPrimaryText,
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
          shadowColor: wyvernGold.withValues(alpha: 0.4),
        ),
      ),
      iconTheme: const IconThemeData(
        color: darkTextPrimary,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: wyvernGold, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 2.5),
        ),
        hintStyle: GoogleFonts.roboto(
          color: darkTextSecondary,
          fontSize: 15,
        ),
      ),
    );
  }

  // Helper method per ottenere il colore di un tipo di mostro
  static Color getMonsterTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'flying wyvern':
        return flyingWyvern;
      case 'fanged wyvern':
        return fangedWyvern;
      case 'piscine wyvern':
        return piscineWyvern;
      case 'elder dragon':
        return elderDragon;
      case 'bird wyvern':
        return birdWyvern;
      case 'brute wyvern':
        return bruteWyvern;
      default:
        return dragonSteel;
    }
  }
}
