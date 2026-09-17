// ============================================================================
//  lib/utils/theme.dart
//  Global Application Theme — Modern Premium Medical Design
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

export 'app_colors.dart'; // re‑export for convenience

class AppTheme {
  const AppTheme._();

  // ══════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ══════════════════════════════════════════════════════════
  static ThemeData light() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.accent,
          surface: AppColors.cardWhite,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,

        // ── AppBar Theme ──────────────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cardWhite,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          titleTextStyle: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          iconTheme: IconThemeData(color: AppColors.textGrey, size: 20),
          actionsIconTheme: IconThemeData(color: AppColors.textGrey, size: 20),
        ),

        // ── Card Theme ────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: AppColors.cardWhite,
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.card,
            side: const BorderSide(color: AppColors.divider, width: 0.8),
          ),
          shadowColor: AppColors.shadow,
        ),

        // ── Bottom Navigation Theme ───────────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.cardWhite,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textGrey,
          selectedLabelStyle: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
          unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // ── Input Decoration Theme ────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight, fontWeight: FontWeight.w400),
          labelStyle: const TextStyle(fontSize: 13, color: AppColors.textGrey, fontWeight: FontWeight.w500),
        ),

        // ── Button Theme ──────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),

        // ── Text Theme ────────────────────────────────────────────
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.4,
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.2,
          ),
          headlineSmall: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrey,
          ),
          bodySmall: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: AppColors.textLight,
          ),
          labelLarge: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
            letterSpacing: 0.8,
          ),
        ),
      );

  // ══════════════════════════════════════════════════════════
  //  DARK THEME
  // ══════════════════════════════════════════════════════════
  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF38BDF8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          primary: const Color(0xFF38BDF8),
          secondary: AppColors.secondary,
          tertiary: AppColors.accent,
          surface: AppColors.darkSurface,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,

        // ── AppBar Theme ──────────────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
          iconTheme: IconThemeData(color: AppColors.darkTextSecondary, size: 20),
          actionsIconTheme: IconThemeData(color: AppColors.darkTextSecondary, size: 20),
        ),

        // ── Card Theme ────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.card,
            side: const BorderSide(color: AppColors.darkBorder, width: 0.8),
          ),
          shadowColor: Colors.transparent,
        ),

        // ── Bottom Navigation Theme ───────────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: Color(0xFF38BDF8),
          unselectedItemColor: AppColors.darkTextSecondary,
          selectedLabelStyle: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
          unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // ── Input Decoration Theme ────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0F172A),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.darkTextSecondary, fontWeight: FontWeight.w400),
          labelStyle: const TextStyle(fontSize: 13, color: AppColors.darkTextSecondary, fontWeight: FontWeight.w500),
        ),

        // ── Button Theme ──────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF38BDF8),
            foregroundColor: AppColors.darkBackground,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),

        // ── Text Theme ────────────────────────────────────────────
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.darkTextPrimary,
            letterSpacing: -0.4,
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
            letterSpacing: -0.2,
          ),
          headlineSmall: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.darkTextSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: AppColors.darkTextSecondary,
          ),
          labelLarge: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextSecondary,
            letterSpacing: 0.8,
          ),
        ),
      );
}
