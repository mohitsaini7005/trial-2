import 'package:flutter/material.dart';

const mainColor = Color.fromARGB(255, 0, 101, 255);

class AppColors {
  // Base colors for compatibility
  static const Color primary = Color(0xFF0065FF);
  static const Color secondary = Color(0xFF6C757D);
  static const Color success = Color(0xFF28A745);
  static const Color danger = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);
  static const Color light = Color(0xFFF8F9FA);
  static const Color dark = Color(0xFF343A40);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF6C757D);
  static const Color lightGrey = Color(0xFFE9ECEF);
  
  // Premium Tribal & Tourism Theme Colors - Futuristic Design
  static const Color tribalPrimary = Color(0xFF1B4B66);    // Deep Ocean Blue
  static const Color tribalSecondary = Color(0xFF4ECDC4);  // Turquoise
  static const Color tribalAccent = Color(0xFFE8AA42);     // Golden Amber
  static const Color tribalBackground = Color(0xFFF8FAFB); // Ultra Light Blue
  static const Color tribalText = Color(0xFF1F2937);       // Dark Slate
  static const Color tribalCard = Color(0xFFFFFFFF);       // Pure White
  
  // Glassmorphism & Neon Gradients
  static const Color glassBackground = Color(0x1AFFFFFF);  // 10% White overlay
  static const Color glassStroke = Color(0x33FFFFFF);     // 20% White border
  static const Color neonBlue = Color(0xFF00E0FF);        // Electric Blue
  static const Color neonPink = Color(0xFFFF006E);        // Vibrant Pink
  static const Color neonGreen = Color(0xFF39FF14);       // Electric Green
  static const Color neonPurple = Color(0xFF9D4EDD);      // Electric Purple
  
  // Cultural & Heritage Colors
  static const Color earthyBrown = Color(0xFF8B4513);     // Traditional Earth
  static const Color forestGreen = Color(0xFF228B22);     // Nature Green
  static const Color sunsetOrange = Color(0xFFFF6B35);    // Warm Sunset
  static const Color mysticalPurple = Color(0xFF6A0572);  // Sacred Purple
  static const Color tribalGold = Color(0xFFD4AF37);      // Rich Gold
  
  // Dark Theme Support
  static const Color darkBackground = Color(0xFF0F172A);  // Dark Slate
  static const Color darkCard = Color(0xFF1E293B);        // Dark Card
  static const Color darkText = Color(0xFFF1F5F9);        // Light Text
  static const Color darkAccent = Color(0xFF4ECDC4);      // Same accent for consistency
  
  // Status & Action Colors
  static const Color bookingConfirmed = Color(0xFF10B981); // Success Green
  static const Color bookingPending = Color(0xFFF59E0B);   // Warning Amber  
  static const Color bookingCancelled = Color(0xFFEF4444); // Error Red
  static const Color premiumGold = Color(0xFFFFD700);      // Premium Features
  
  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [tribalPrimary, tribalSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonBlue, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}