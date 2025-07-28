import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF4E4CBC);
  static const Color primaryLight = Color(0xFF7B77D9);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B5C);
  static const Color secondaryLight = Color(0xFFFF8A7F);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);

  // Favorite Color
  static const Color favorite = Color(0xFFEF4444);

  // Surface Colors
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF374151);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFF9FAFB);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF374151), Color(0xFF1F2937)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTypography {
  static TextTheme get lightTextTheme => GoogleFonts.interTextTheme().copyWith(
    headlineMedium: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.textMuted,
    ),
  );

  static TextTheme get darkTextTheme => lightTextTheme.apply(
    bodyColor: AppColors.textLight,
    displayColor: AppColors.textLight,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
}

class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
}

class AppShadows {
  static const BoxShadow soft = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );
}

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);

  static const Curve easeOut = Curves.easeOut;
}
