// ============================================================================
//  lib/widgets/medical_animations.dart
//  Premium medical micro-animations for cards, dashboard, and splash screen
// ============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  BREATH ANIMATION — Scale + Opacity (1.0 → 1.03 → 1.0 / 1.0 → 0.94 → 1.0)
// ══════════════════════════════════════════════════════════════════════════════

/// Animated widget that scales its child up and down slightly (1.0 → 1.03 → 1.0)
/// with a synchronized opacity fade, simulating gentle breathing. Duration: 4s.
class BreathAnimation extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double maxScale;
  final double minOpacity;

  const BreathAnimation({
    super.key,
    required this.child,
    this.enabled = true,
    this.maxScale = 1.03,
    this.minOpacity = 1.0, // set to 0.92 for stronger effect
  });

  @override
  State<BreathAnimation> createState() => _BreathAnimationState();
}

class _BreathAnimationState extends State<BreathAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.maxScale).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 1.0, end: widget.minOpacity).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    if (widget.enabled) {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant BreathAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.enabled && _ctrl.isAnimating) {
      _ctrl.stop();
      _ctrl.animateTo(0.0, duration: const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(scale: _scale.value, child: child),
      ),
      child: widget.child,
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  LUNG ICON ANIMATION — Standalone breathing lung icon for empty states
// ══════════════════════════════════════════════════════════════════════════════

/// A standalone lung icon that breathes — for empty states and hero sections.
class LungIconAnimation extends StatefulWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;

  const LungIconAnimation({
    super.key,
    this.size = 64,
    this.primaryColor,
    this.accentColor,
  });

  @override
  State<LungIconAnimation> createState() => _LungIconAnimationState();
}

class _LungIconAnimationState extends State<LungIconAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _breathCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _breathScale;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat(reverse: true);

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _breathScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut),
    );
    _glowOpacity = Tween<double>(begin: 0.25, end: 0.65).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = widget.primaryColor ??
        (isDark ? AppColors.darkPrimaryBlue : AppColors.primary);
    final accent = widget.accentColor ?? AppColors.accent;

    return AnimatedBuilder(
      animation: Listenable.merge([_breathCtrl, _glowCtrl]),
      builder: (context, _) {
        return SizedBox(
          width: widget.size * 1.6,
          height: widget.size * 1.6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow ring behind lungs
              Container(
                width: widget.size * 1.5,
                height: widget.size * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withOpacity(_glowOpacity.value * 0.3),
                      primary.withOpacity(_glowOpacity.value * 0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              // Breathing lung painter
              Transform.scale(
                scale: _breathScale.value,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: Image.asset(
                    'assets/images/logo_ar.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LungMiniPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  const _LungMiniPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintLungs = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round;

    final paintEcg = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintEcgGlow = Paint()
      ..color = accentColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Left lung
    final leftPath = Path()
      ..moveTo(w * 0.45, h * 0.10)
      ..cubicTo(w * 0.20, h * 0.05, w * 0.08, h * 0.35, w * 0.16, h * 0.65)
      ..cubicTo(w * 0.20, h * 0.82, w * 0.38, h * 0.95, w * 0.44, h * 0.85);

    paintLungs.shader = LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(leftPath, paintLungs);

    // Right lung
    final rightPath = Path()
      ..moveTo(w * 0.55, h * 0.10)
      ..cubicTo(w * 0.80, h * 0.05, w * 0.92, h * 0.35, w * 0.84, h * 0.65)
      ..cubicTo(w * 0.80, h * 0.82, w * 0.62, h * 0.95, w * 0.56, h * 0.85);

    paintLungs.shader = LinearGradient(
      colors: [accentColor, primaryColor],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(rightPath, paintLungs);

    // Inner drop (right lobe accent)
    final dropPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [accentColor.withOpacity(0.85), primaryColor.withOpacity(0.3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(w * 0.55, h * 0.25, w * 0.3, h * 0.4));

    final dropPath = Path()
      ..moveTo(w * 0.70, h * 0.30)
      ..cubicTo(w * 0.80, h * 0.38, w * 0.82, h * 0.55, w * 0.70, h * 0.62)
      ..cubicTo(w * 0.58, h * 0.55, w * 0.60, h * 0.38, w * 0.70, h * 0.30);
    canvas.drawPath(dropPath, dropPaint);

    // ECG line
    final ecgPath = Path()
      ..moveTo(w * 0.05, h * 0.53)
      ..lineTo(w * 0.25, h * 0.53)
      ..lineTo(w * 0.29, h * 0.40)
      ..lineTo(w * 0.34, h * 0.68)
      ..lineTo(w * 0.39, h * 0.22)
      ..lineTo(w * 0.44, h * 0.58)
      ..lineTo(w * 0.48, h * 0.53)
      ..lineTo(w * 0.55, h * 0.53);

    canvas.drawPath(ecgPath, paintEcgGlow);
    canvas.drawPath(ecgPath, paintEcg);
  }

  @override
  bool shouldRepaint(covariant _LungMiniPainter old) =>
      old.primaryColor != primaryColor || old.accentColor != accentColor;
}

// ══════════════════════════════════════════════════════════════════════════════
//  PULSE RING ANIMATION — Concentric expanding rings (for monitor indicators)
// ══════════════════════════════════════════════════════════════════════════════

/// Emits concentric expanding rings to indicate active real-time monitoring.
class PulseRingAnimation extends StatefulWidget {
  final double size;
  final Color color;
  final int ringCount;

  const PulseRingAnimation({
    super.key,
    this.size = 12,
    this.color = AppColors.accent,
    this.ringCount = 2,
  });

  @override
  State<PulseRingAnimation> createState() => _PulseRingAnimationState();
}

class _PulseRingAnimationState extends State<PulseRingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return SizedBox(
          width: widget.size * 3,
          height: widget.size * 3,
          child: CustomPaint(
            painter: _PulseRingPainter(
              progress: _ctrl.value,
              color: widget.color,
              dotSize: widget.size,
              ringCount: widget.ringCount,
            ),
          ),
        );
      },
    );
  }
}

class _PulseRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double dotSize;
  final int ringCount;

  const _PulseRingPainter({
    required this.progress,
    required this.color,
    required this.dotSize,
    required this.ringCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw expanding rings
    for (int i = 0; i < ringCount; i++) {
      final offset = i / ringCount;
      final t = ((progress + offset) % 1.0);
      final radius = maxRadius * t;
      final opacity = (1.0 - t).clamp(0.0, 1.0) * 0.7;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, paint);
    }

    // Center dot
    canvas.drawCircle(
      center,
      dotSize / 2,
      Paint()..color = color,
    );
    canvas.drawCircle(
      center,
      dotSize / 4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _PulseRingPainter old) =>
      old.progress != progress || old.color != color;
}

// ══════════════════════════════════════════════════════════════════════════════
//  ECG PULSE ANIMATION — Real-time sweeping ECG line widget
// ══════════════════════════════════════════════════════════════════════════════

/// A real-time sweeping ECG line animation widget.
class EcgPulseAnimation extends StatefulWidget {
  final Color color;
  final double height;
  final double width;
  final Duration duration;

  const EcgPulseAnimation({
    super.key,
    required this.color,
    this.height = 24,
    this.width = double.infinity,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<EcgPulseAnimation> createState() => _EcgPulseAnimationState();
}

class _EcgPulseAnimationState extends State<EcgPulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: EcgLinePainter(
            color: widget.color,
            progress: _ctrl.value,
          ),
        );
      },
    );
  }
}

class EcgLinePainter extends CustomPainter {
  final Color color;
  final double progress; // 0.0 to 1.0

  const EcgLinePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.35)
      ..strokeWidth = 5.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final mid = h / 2;

    List<Offset> pts = [];
    int segments = 80;

    for (int i = 0; i <= segments; i++) {
      double pct = i / segments;
      double x = pct * w;
      double y = mid;

      // Standard ECG waves
      if (pct >= 0.15 && pct < 0.22) {
        // P wave (small bump)
        double angle = (pct - 0.15) / 0.07 * math.pi;
        y = mid - math.sin(angle) * (h * 0.18);
      } else if (pct >= 0.28 && pct < 0.31) {
        // Q wave (dip)
        double ratio = (pct - 0.28) / 0.03;
        y = mid + ratio * (h * 0.20);
      } else if (pct >= 0.31 && pct < 0.35) {
        // R wave (peak)
        double ratio = (pct - 0.31) / 0.04;
        y = (mid + h * 0.20) - ratio * (h * 1.0);
      } else if (pct >= 0.35 && pct < 0.39) {
        // S wave (deep dip)
        double ratio = (pct - 0.35) / 0.04;
        y = (mid - h * 0.80) + ratio * (h * 1.1);
      } else if (pct >= 0.39 && pct < 0.42) {
        // Return to baseline
        double ratio = (pct - 0.39) / 0.03;
        y = (mid + h * 0.30) - ratio * (h * 0.30);
      } else if (pct >= 0.52 && pct < 0.62) {
        // T wave (medium bump)
        double angle = (pct - 0.52) / 0.10 * math.pi;
        y = mid - math.sin(angle) * (h * 0.25);
      }

      pts.add(Offset(x, y));
    }

    path.moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }

    // 1. Static faint baseline
    final baselinePaint = Paint()
      ..color = color.withOpacity(0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, baselinePaint);

    // 2. Sweeping segment
    try {
      final pathMetrics = path.computeMetrics().toList();
      if (pathMetrics.isNotEmpty) {
        final pathMetric = pathMetrics.first;
        double totalLength = pathMetric.length;
        double currentOffset = totalLength * progress;

        double trailLength = totalLength * 0.32;
        double startOffset = currentOffset - trailLength;

        Path sweepPath;
        if (startOffset < 0) {
          sweepPath = pathMetric.extractPath(0, currentOffset);
          final tailPath =
              pathMetric.extractPath(totalLength + startOffset, totalLength);
          canvas.drawPath(tailPath, glowPaint);
          canvas.drawPath(tailPath, paint);
        } else {
          sweepPath = pathMetric.extractPath(startOffset, currentOffset);
        }

        canvas.drawPath(sweepPath, glowPaint);
        canvas.drawPath(sweepPath, paint);

        // Glowing head dot
        final tangent = pathMetric.getTangentForOffset(currentOffset);
        if (tangent != null) {
          final head = tangent.position;
          canvas.drawCircle(
            head,
            4.5,
            Paint()
              ..color = color
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
          );
          canvas.drawCircle(head, 2.0, Paint()..color = Colors.white);
        }
      }
    } catch (_) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant EcgLinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}