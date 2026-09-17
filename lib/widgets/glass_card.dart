// ============================================================================
//  lib/widgets/glass_card.dart
//  Glassmorphism surface card — premium semi-transparent UI element
// ============================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// A frosted-glass card surface with configurable blur, gradient border, and
/// opacity — matching the premium medical brand identity.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final bool showBorder;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 12.0,
    this.opacity = 0.12,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.gradient,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.lg);

    final surfaceColor = isDark
        ? const Color(0xFF0F172A).withOpacity(opacity * 1.5)
        : Colors.white.withOpacity(opacity * 2);

    final borderColor = isDark
        ? AppColors.accent.withOpacity(0.15)
        : AppColors.primary.withOpacity(0.10);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppColors.darkSurface.withOpacity(0.65),
                          AppColors.darkBackground.withOpacity(0.45),
                        ]
                      : [
                          Colors.white.withOpacity(0.75),
                          Colors.white.withOpacity(0.45),
                        ],
                ),
            border: showBorder
                ? Border.all(color: borderColor, width: 0.8)
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.30)
                    : AppColors.glowBlue,
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
//  GRADIENT CARD — premium card with a gradient header accent strip
// ──────────────────────────────────────────────────────────────────────────────

/// Premium card with a thin gradient accent strip at the top, soft shadow, and
/// rounded corners — for key statistics and monitor readouts.
class GradientAccentCard extends StatelessWidget {
  final Widget child;
  final Gradient? accentGradient;
  final double accentHeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const GradientAccentCard({
    super.key,
    required this.child,
    this.accentGradient,
    this.accentHeight = 3.0,
    this.padding = const EdgeInsets.all(14),
    this.borderRadius = AppRadius.lg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.cardWhite;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    final gradient = accentGradient ?? AppGradients.accent;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border, width: 0.8),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient top accent
          Container(
            height: accentHeight,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
          ),
          // Content
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}
