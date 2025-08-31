import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lali/core/constants/colors.dart';

class AppTheme {
  // Premium Tribal & Tourism Theme - Light Mode
  static ThemeData themeLight({Color seed = AppColors.tribalPrimary}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed, 
      brightness: Brightness.light,
      primary: AppColors.tribalPrimary,
      secondary: AppColors.tribalSecondary,
      tertiary: AppColors.tribalAccent,
      surface: AppColors.tribalCard,
      background: AppColors.tribalBackground,
    );
    
    final textTheme = _buildTextTheme(isDark: false);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      
      // AppBar with glassmorphism effect
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.glassBackground,
        foregroundColor: AppColors.tribalText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.tribalText,
        ),
        iconTheme: const IconThemeData(color: AppColors.tribalPrimary),
      ),
      
      // Enhanced Card Theme
      cardTheme: CardTheme(
        elevation: 8,
        shadowColor: AppColors.tribalPrimary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.glassStroke, width: 1),
        ),
        color: AppColors.tribalCard,
      ),
      
      // Premium Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tribalPrimary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.tribalPrimary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.tribalPrimary,
          side: const BorderSide(color: AppColors.tribalPrimary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.tribalCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.tribalPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Enhanced Chip Theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.tribalSecondary.withOpacity(0.3)),
        ),
        backgroundColor: AppColors.tribalSecondary.withOpacity(0.1),
        selectedColor: AppColors.tribalSecondary,
        labelStyle: GoogleFonts.inter(
          color: AppColors.tribalText,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      
      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.tribalCard,
        selectedItemColor: AppColors.tribalPrimary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.tribalAccent,
        foregroundColor: Colors.white,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Premium Tribal & Tourism Theme - Dark Mode
  static ThemeData themeDark({Color seed = AppColors.tribalPrimary}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed, 
      brightness: Brightness.dark,
      primary: AppColors.tribalSecondary,
      secondary: AppColors.tribalAccent,
      tertiary: AppColors.neonBlue,
      surface: AppColors.darkCard,
      background: AppColors.darkBackground,
    );
    
    final textTheme = _buildTextTheme(isDark: true);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      
      // Dark AppBar with neon accents
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCard,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        iconTheme: const IconThemeData(color: AppColors.tribalSecondary),
      ),
      
      // Dark Card Theme
      cardTheme: CardTheme(
        elevation: 12,
        shadowColor: AppColors.neonBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.tribalSecondary.withOpacity(0.2), width: 1),
        ),
        color: AppColors.darkCard,
      ),
      
      // Dark Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tribalSecondary,
          foregroundColor: AppColors.darkBackground,
          elevation: 12,
          shadowColor: AppColors.neonBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      
      // Dark Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tribalSecondary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tribalSecondary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.tribalSecondary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Dark Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.tribalSecondary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    );
  }
  
  // Premium Typography System
  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color textColor = isDark ? AppColors.darkText : AppColors.tribalText;
    final Color headlineColor = isDark ? AppColors.tribalSecondary : AppColors.tribalPrimary;
    
    return TextTheme(
      // Display styles for hero sections
      displayLarge: GoogleFonts.orbitron(
        fontSize: 48, 
        fontWeight: FontWeight.w700,
        color: headlineColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 36, 
        fontWeight: FontWeight.w600,
        color: headlineColor,
        letterSpacing: -0.25,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 32, 
        fontWeight: FontWeight.w600,
        color: headlineColor,
      ),
      
      // Headlines for sections
      headlineLarge: GoogleFonts.inter(
        fontSize: 28, 
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24, 
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20, 
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      
      // Titles for cards and components
      titleLarge: GoogleFonts.inter(
        fontSize: 18, 
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16, 
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14, 
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      
      // Body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: textColor,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: textColor.withOpacity(0.8),
        height: 1.3,
      ),
      
      // Labels for buttons and UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 16, 
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14, 
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12, 
        fontWeight: FontWeight.w500,
        color: textColor.withOpacity(0.8),
        letterSpacing: 0.5,
      ),
    );
  }
}
