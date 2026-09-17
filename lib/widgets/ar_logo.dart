// ============================================================================
//  lib/widgets/ar_logo.dart
//  Official Lung & ECG Logo Widget — Vector Drawn & Responsive
// ============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Interactive, vector-drawn logo representing stylized lungs and an ECG curve.
/// Integrates seamlessly with Light/Dark mode and supports micro-animations.
class ArLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showTagline;
  final bool animate;

  const ArLogo({
    super.key,
    this.size = 48,
    this.showText = false,
    this.showTagline = false,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget logoWidget = SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/logo_ar.png',
        fit: BoxFit.contain,
      ),
    );

    if (animate) {
      logoWidget = _LogoBreathWrapper(child: logoWidget);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoWidget,
        if (showText) ...[
          SizedBox(height: size * 0.10),
          _LogoText(size: size, showTagline: showTagline, isDark: isDark),
        ],
      ],
    );
  }
}

/// Breathing scale animation wrapper (1.0 -> 1.04 -> 1.0) for the logo.
class _LogoBreathWrapper extends StatefulWidget {
  final Widget child;
  const _LogoBreathWrapper({required this.child});

  @override
  State<_LogoBreathWrapper> createState() => _LogoBreathWrapperState();
}

class _LogoBreathWrapperState extends State<_LogoBreathWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

/// Vector Painter drawing the stylized lungs and ECG wave matching the new branding.
class _LungEcgPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;
  final Color accentColor;

  const _LungEcgPainter({
    required this.isDark,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Define brush styles
    final paintLungs = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round;

    final paintDrop = Paint()
      ..style = PaintingStyle.fill;

    final paintEcg = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Glow effect for ECG
    final paintEcgGlow = Paint()
      ..color = accentColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ── 1. DRAW LEFT LUNG ──────────────────────────────────
    final leftPath = Path();
    // Inverted C shape representing the left lung lobe
    leftPath.moveTo(w * 0.45, h * 0.10);
    leftPath.cubicTo(
      w * 0.20, h * 0.05,
      w * 0.08, h * 0.35,
      w * 0.16, h * 0.65,
    );
    leftPath.cubicTo(
      w * 0.20, h * 0.82,
      w * 0.38, h * 0.95,
      w * 0.44, h * 0.85,
    );

    // Apply gradient to the left lung outline (Navy to Accent)
    paintLungs.shader = LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(leftPath, paintLungs);

    // ── 2. DRAW RIGHT LUNG ─────────────────────────────────
    final rightPath = Path();
    // C shape representing the right lung lobe
    rightPath.moveTo(w * 0.55, h * 0.10);
    rightPath.cubicTo(
      w * 0.80, h * 0.05,
      w * 0.92, h * 0.35,
      w * 0.84, h * 0.65,
    );
    rightPath.cubicTo(
      w * 0.80, h * 0.82,
      w * 0.62, h * 0.95,
      w * 0.56, h * 0.85,
    );

    // Apply reversed gradient to the right lung outline
    paintLungs.shader = LinearGradient(
      colors: [accentColor, primaryColor],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(rightPath, paintLungs);

    // ── 3. DRAW INNER ALVEOLAR DROP (Inside Right Lung Lobe)
    final dropPath = Path();
    dropPath.moveTo(w * 0.70, h * 0.30);
    dropPath.cubicTo(
      w * 0.80, h * 0.38,
      w * 0.82, h * 0.55,
      w * 0.70, h * 0.62,
    );
    dropPath.cubicTo(
      w * 0.58, h * 0.55,
      w * 0.60, h * 0.38,
      w * 0.70, h * 0.30,
    );

    paintDrop.shader = LinearGradient(
      colors: [accentColor.withOpacity(0.85), primaryColor.withOpacity(0.3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(w * 0.55, h * 0.25, w * 0.3, h * 0.4));

    canvas.drawPath(dropPath, paintDrop);

    // ── 4. DRAW CENTRAL ECG CURVE ──────────────────────────
    final ecgPath = Path();
    // Sweeps across the left lung and through the center
    ecgPath.moveTo(w * 0.05, h * 0.53);
    ecgPath.lineTo(w * 0.25, h * 0.53); // Flat line
    ecgPath.lineTo(w * 0.29, h * 0.40); // P wave-like peak
    ecgPath.lineTo(w * 0.34, h * 0.68); // Dip
    ecgPath.lineTo(w * 0.39, h * 0.22); // High R spike
    ecgPath.lineTo(w * 0.44, h * 0.58); // S dip
    ecgPath.lineTo(w * 0.48, h * 0.53); // Back to base
    ecgPath.lineTo(w * 0.55, h * 0.53);

    canvas.drawPath(ecgPath, paintEcgGlow);
    canvas.drawPath(ecgPath, paintEcg);
  }

  @override
  bool shouldRepaint(covariant _LungEcgPainter oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor;
  }
}

class _LogoText extends StatelessWidget {
  final double size;
  final bool showTagline;
  final bool isDark;

  const _LogoText({
    required this.size,
    required this.showTagline,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleSize = (size * 0.14).clamp(10.0, 22.0);
    final tagSize = (size * 0.075).clamp(7.0, 11.0);

    final titleNavyColor = isDark ? Colors.white : AppColors.primary;
    final subtitleTealColor = AppColors.accent;

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ANESTHÉSIE',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: subtitleTealColor,
                ),
              ),
              TextSpan(
                text: ' & ',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w300,
                  color: titleNavyColor,
                ),
              ),
              TextSpan(
                text: 'RÉANIMATION',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: titleNavyColor,
                ),
              ),
            ],
          ),
        ),
        if (showTagline) ...[
          SizedBox(height: tagSize * 0.6),
          Text(
            'SURVEILLER  |  PROTÉGER  |  SAUVER',
            style: TextStyle(
              fontSize: tagSize,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: titleNavyColor.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }
}
