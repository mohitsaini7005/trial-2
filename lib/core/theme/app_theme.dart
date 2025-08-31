import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeLight({Color seed = Colors.teal}) {
    final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.marcellus(fontSize: 42, fontWeight: FontWeight.w600),
      displayMedium: GoogleFonts.marcellus(fontSize: 36, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.marcellus(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(color: colorScheme.surface, foregroundColor: colorScheme.onSurface, elevation: 0),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(side: BorderSide(color: colorScheme.outlineVariant)),
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  static ThemeData themeDark({Color seed = Colors.teal}) {
    final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.marcellus(fontSize: 42, fontWeight: FontWeight.w600),
      displayMedium: GoogleFonts.marcellus(fontSize: 36, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.marcellus(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(color: colorScheme.surface, foregroundColor: colorScheme.onSurface, elevation: 0),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(side: BorderSide(color: colorScheme.outlineVariant)),
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}
