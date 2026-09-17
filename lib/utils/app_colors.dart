// ============================================================================
//  lib/utils/app_colors.dart
//  Design System 3.0 — Identity: Stylized Lungs & ECG Logo
// ============================================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ══════════════════════════════════════════════════════════
  //  CORE PALETTE (Logo: Blue & Turquoise Gradients)
  // ══════════════════════════════════════════════════════════
  static const Color primary    = Color(0xFF0F4C81); // Medical Navy Blue
  static const Color secondary  = Color(0xFF1F7AE0); // Bright Medical Blue
  static const Color accent     = Color(0xFF2DD4BF); // Turquoise Accent
  static const Color background = Color(0xFFF8FAFC); // Clean Slate Gray Background
  static const Color cardWhite  = Color(0xFFFFFFFF); // Pure White Surface
  static const Color textDark   = Color(0xFF0F172A); // Dark text color

  // ── Semantic Colors ───────────────────────────────────────
  static const Color success        = Color(0xFF22C55E);
  static const Color successSurface = Color(0xFFDCFCE7);
  static const Color successBorder  = Color(0xFF86EFAC);
  static const Color successText    = Color(0xFF15803D);

  static const Color warning        = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFEF3C7);
  static const Color warningBorder  = Color(0xFFFCD34D);
  static const Color warningText    = Color(0xFFB45309);

  static const Color danger         = Color(0xFFEF4444);
  static const Color dangerSurface  = Color(0xFFFEE2E2);
  static const Color dangerBorder   = Color(0xFFFCA5A5);
  static const Color dangerText     = Color(0xFFB91C1C);

  // ── UI Details ───────────────────────────────────────────
  static const Color divider    = Color(0xFFE2E8F0);
  static const Color border     = Color(0xFFE2E8F0);
  static const Color shadow     = Color(0x0A000000);

  // ── Dark-mode Palette ─────────────────────────────────────
  static const Color darkBackground    = Color(0xFF08111F); // Dark slate blue
  static const Color darkSurface       = Color(0xFF0F172A); // Deeper slate
  static const Color darkCard          = Color(0xFF1E293B); // Slate card
  static const Color darkBorder        = Color(0xFF334155); // Slate border
  static const Color darkTextPrimary   = Color(0xFFF8FAFC); // Off-white
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted slate

  // ── Legacy Aliases (Compatibility) ──────────────────────
  static const Color primaryRed      = primary;
  static const Color darkRed         = secondary;
  static const Color lightRed        = Color(0xFFE0F2FE); // Light blue instead of light red
  static const Color card            = cardWhite;
  static const Color surface         = background;
  static const Color textDarkVariant = textDark;
  static const Color textGrey        = Color(0xFF64748B);
  static const Color textLight       = Color(0xFF94A3B8);
  static const Color textPrimary     = textDark;
  static const Color textSecondary   = Color(0xFF475569);
  static const Color textMuted       = Color(0xFF94A3B8);
  static const Color primaryDeep     = secondary;
  static const Color primarySurface  = cardWhite;
  static const Color primarySurfaceMid = Color(0xFFF0F9FF);
  static const Color primaryDark     = primary;

  // ══════════════════════════════════════════════════════════
  //  PATHOLOGY CATEGORIES (Tailored modern colors)
  // ══════════════════════════════════════════════════════════
  static const Color neurologique       = Color(0xFF8B5CF6);
  static const Color neurologiqueBg     = Color(0xFFF5F3FF);

  static const Color cardiovasculaire   = Color(0xFFEF4444);
  static const Color cardiovasculaireBg = Color(0xFFFEE2E2);

  static const Color respiratoire       = Color(0xFF0EA5E9);
  static const Color respiratoireBg     = Color(0xFFF0F9FF);

  static const Color renal              = Color(0xFF06B6D4);
  static const Color renalBg            = Color(0xFFECFEFF);

  static const Color hepatique          = Color(0xFFF97316);
  static const Color hepatiqueBg        = Color(0xFFFFF7ED);

  static const Color metabolique        = Color(0xFFF59E0B);
  static const Color metaboliqueBg      = Color(0xFFFEF3C7);

  static const Color obstetrique        = Color(0xFFEC4899);
  static const Color obstetrigueBg      = Color(0xFFFDF2F8);

  static const Color allergique         = Color(0xFFEF4444);
  static const Color allergiqueBg       = Color(0xFFFEE2E2);

  // ── Protocol colorKey Helpers ─────────────────────────────
  static const Color protocolRed    = Color(0xFFEF4444);
  static const Color protocolRedBg  = Color(0xFFFEE2E2);
  static const Color protocolRedBd  = Color(0xFFFCA5A5);

  static const Color protocolOrange   = Color(0xFFF97316);
  static const Color protocolOrangeBg = Color(0xFFFFF7ED);
  static const Color protocolOrangeBd = Color(0xFFFDBA74);

  static const Color protocolBlue   = Color(0xFF3B82F6);
  static const Color protocolBlueBg = Color(0xFFEFF6FF);
  static const Color protocolBlueBd = Color(0xFFBFDBFE);

  static const Color protocolGreen   = Color(0xFF22C55E);
  static const Color protocolGreenBg = Color(0xFFF0FDF4);
  static const Color protocolGreenBd = Color(0xFF86EFAC);

  static Color mainFromKey(String key) {
    switch (key) {
      case 'red':    return protocolRed;
      case 'orange': return protocolOrange;
      case 'blue':   return protocolBlue;
      case 'green':  return protocolGreen;
      default:       return primary;
    }
  }

  static Color bgFromKey(String key) {
    switch (key) {
      case 'red':    return protocolRedBg;
      case 'orange': return protocolOrangeBg;
      case 'blue':   return protocolBlueBg;
      case 'green':  return protocolGreenBg;
      default:       return Color(0xFFF0F9FF);
    }
  }

  static Color borderFromKey(String key) {
    switch (key) {
      case 'red':    return protocolRedBd;
      case 'orange': return protocolOrangeBd;
      case 'blue':   return protocolBlueBd;
      case 'green':  return protocolGreenBd;
      default:       return divider;
    }
  }

  static Color catColor(String categorieId) {
    switch (categorieId) {
      case 'neurologique':     return neurologique;
      case 'cardiovasculaire': return cardiovasculaire;
      case 'respiratoire':     return respiratoire;
      case 'renal':            return renal;
      case 'hepatique':        return hepatique;
      case 'metabolique':      return metabolique;
      case 'obstetrique':      return obstetrique;
      case 'allergique':       return allergique;
      default:                 return textGrey;
    }
  }

  static Color catBg(String categorieId) {
    switch (categorieId) {
      case 'neurologique':     return neurologiqueBg;
      case 'cardiovasculaire': return cardiovasculaireBg;
      case 'respiratoire':     return respiratoireBg;
      case 'renal':            return renalBg;
      case 'hepatique':        return hepatiqueBg;
      case 'metabolique':      return metaboliqueBg;
      case 'obstetrique':      return obstetrigueBg;
      case 'allergique':       return allergiqueBg;
      default:                 return background;
    }
  }
  // ── Glow Colors (for custom painters & glowing effects) ──────
  static const Color glowTeal    = Color(0x552DD4BF); // 33% teal glow
  static const Color glowBlue    = Color(0x551F7AE0); // 33% blue glow
  static const Color glowNavy    = Color(0x550F4C81); // 33% navy glow
  static const Color glowTealBright = Color(0x882DD4BF); // 53% teal glow (stronger)

  // ── Dark Primary for explicit use ─────────────────────────────
  static const Color darkPrimaryBlue = Color(0xFF38BDF8); // sky blue in dark mode
}

// ══════════════════════════════════════════════════════════════
//  ADAPTIVE COLORS BUILDCONTEXT EXTENSION
// ══════════════════════════════════════════════════════════════
extension AppColorsExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get primaryColor    => isDarkMode ? AppColors.darkTextPrimary : AppColors.primary;
  Color get secondaryColor  => AppColors.secondary;
  Color get accentColor     => AppColors.accent;
  Color get backgroundColor => isDarkMode ? AppColors.darkBackground : AppColors.background;
  Color get surfaceColor    => isDarkMode ? AppColors.darkSurface : AppColors.cardWhite;
  Color get cardColor       => isDarkMode ? AppColors.darkCard : AppColors.cardWhite;
  Color get borderColor     => isDarkMode ? AppColors.darkBorder : AppColors.border;
  Color get textColor       => isDarkMode ? AppColors.darkTextPrimary : AppColors.textDark;
  Color get textMutedColor  => isDarkMode ? AppColors.darkTextSecondary : AppColors.textGrey;
}

// ══════════════════════════════════════════════════════════════
//  APPSPACING — Standard spacings
// ══════════════════════════════════════════════════════════════
class AppSpacing {
  AppSpacing._();

  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xxl  = 24.0;
  static const double xxxl = 32.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(lg, md, lg, lg);
}

// ══════════════════════════════════════════════════════════════
//  APPRADIUS — Modern rounded corners (increased for premium feel)
// ══════════════════════════════════════════════════════════════
class AppRadius {
  AppRadius._();

  static const double xs   = 6.0;
  static const double sm   = 10.0;
  static const double md   = 14.0;
  static const double lg   = 18.0;
  static const double xl   = 22.0;
  static const double xxl  = 28.0;
  static const double pill = 100.0;

  static BorderRadius get card   => BorderRadius.circular(lg);
  static BorderRadius get button => BorderRadius.circular(md);
  static BorderRadius get chip   => BorderRadius.circular(pill);
  static BorderRadius get small  => BorderRadius.circular(sm);
  static BorderRadius get dialog => BorderRadius.circular(xl);
}

// ══════════════════════════════════════════════════════════════
//  APPDURATIONS — Animation durations
// ══════════════════════════════════════════════════════════════
class AppDurations {
  AppDurations._();

  static const Duration fast     = Duration(milliseconds: 150);
  static const Duration normal   = Duration(milliseconds: 250);
  static const Duration slow     = Duration(milliseconds: 400);
  static const Duration verySlow = Duration(milliseconds: 600);
}

// ══════════════════════════════════════════════════════════════
//  APPTEXTSIZE — Standard text sizes
// ══════════════════════════════════════════════════════════════
class AppTextSize {
  AppTextSize._();

  static const double caption = 10.0;
  static const double small   = 11.5;
  static const double body    = 13.0;
  static const double bodyMd  = 14.0;
  static const double title   = 15.0;
  static const double titleLg = 16.5;
  static const double heading = 18.0;
  static const double display = 22.0;
}

// ══════════════════════════════════════════════════════════════
//  APPGRADIENTS — Brand gradient tokens
// ══════════════════════════════════════════════════════════════
class AppGradients {
  AppGradients._();

  /// Primary brand gradient: Navy → Bright Blue (horizontal)
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient: Bright Blue → Turquoise (horizontal)
  static const LinearGradient accent = LinearGradient(
    colors: [AppColors.secondary, AppColors.accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Logo gradient: Navy → Turquoise (diagonal, matches logo)
  static const LinearGradient logo = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark background radial glow (for splash/dark screens)
  static const RadialGradient darkRadial = RadialGradient(
    center: Alignment(0, -0.2),
    radius: 1.4,
    colors: [Color(0xFF0F1E36), AppColors.darkBackground, Color(0xFF02070F)],
    stops: [0.0, 0.6, 1.0],
  );

  /// Card surface gradient (light mode)
  static const LinearGradient card = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark card surface gradient
  static const LinearGradient darkCard = LinearGradient(
    colors: [AppColors.darkCard, AppColors.darkBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Turquoise glow fade (for monitor dots / pulse rings)
  static const RadialGradient pulseGlow = RadialGradient(
    colors: [AppColors.accent, Color(0x002DD4BF)],
    stops: [0.0, 1.0],
  );
}