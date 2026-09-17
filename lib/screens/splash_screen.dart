// ============================================================================
//  lib/screens/splash_screen.dart
//  Interactive Progressive Loading Splash Screen
// ============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'onboarding_screen.dart';
import 'main_screen.dart';
import '../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _particleCtrl;
  late final AnimationController _drawCtrl; // Animation for Lungs drawing
  late final AnimationController _ecgCtrl;  // Animation for ECG line drawing
  late final AnimationController _textCtrl; // Animation for text fade-in
  late final AnimationController _glowCtrl; // Animation for radial glow
  late final AnimationController _exitCtrl; // Animation for exit fade-out

  late final Animation<double> _particleOpacity;
  late final Animation<double> _lungsProgress;
  late final Animation<double> _ecgProgress;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _exitOpacity;

  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _spawnParticles();
    _setupAnimations();
    _runSequence();
  }

  void _spawnParticles() {
    final rng = math.Random(101);
    for (int i = 0; i < 40; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: 1.0 + rng.nextDouble() * 3.5,
        speed: 0.15 + rng.nextDouble() * 0.4,
        opacity: 0.15 + rng.nextDouble() * 0.45,
        phase: rng.nextDouble() * math.pi * 2,
        teal: rng.nextBool(),
      ));
    }
  }

  void _setupAnimations() {
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _particleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleCtrl,
        curve: const Interval(0.0, 0.1, curve: Curves.easeIn),
      ),
    );

    // Lungs draw: 1200ms
    _drawCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _lungsProgress = CurvedAnimation(parent: _drawCtrl, curve: Curves.easeInOut);

    // ECG sweep: 1000ms
    _ecgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _ecgProgress = CurvedAnimation(parent: _ecgCtrl, curve: Curves.easeInOut);

    // Glow pulse/fade
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _glowOpacity = Tween<double>(begin: 0.2, end: 0.85).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    _glowCtrl.repeat(reverse: true);

    // Text fade and slide: 700ms
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textOpacity = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _taglineOpacity = CurvedAnimation(
      parent: _textCtrl,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    // Exit transition
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _exitOpacity = CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn);
  }

  Future<void> _runSequence() async {
    // 1. Draw Lungs
    _drawCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 700));

    // 2. Sweep ECG Line
    _ecgCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    // 3. Fade in Text
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;
    await _exitCtrl.forward();

    // Route checks
    if (!mounted) return;
    final done = await isOnboardingDone();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => done ? const MainScreen() : const OnboardingScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _drawCtrl.dispose();
    _ecgCtrl.dispose();
    _glowCtrl.dispose();
    _textCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _particleCtrl,
        _drawCtrl,
        _ecgCtrl,
        _glowCtrl,
        _textCtrl,
        _exitCtrl,
      ]),
      builder: (context, _) {
        final lungsVal = _lungsProgress.value;
        final ecgVal = _ecgProgress.value;
        final glowVal = _glowOpacity.value;
        final exitVal = _exitOpacity.value;

        return Opacity(
          opacity: (1.0 - exitVal).clamp(0.0, 1.0),
          child: Scaffold(
            backgroundColor: AppColors.darkBackground,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Radial background
                _buildRadialBackground(),

                // 2. Particle layer
                CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    opacity: _particleOpacity.value,
                    tick: _particleCtrl.value,
                  ),
                ),

                // 3. Central Glow behind the logo
                Center(
                  child: Opacity(
                    opacity: (glowVal * 0.45).clamp(0.0, 1.0),
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFF2ECDC8),
                            Color(0xFF0F4C81),
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. Content (Logo drawing + Title + Tagline)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo officiel (nouvelle image) — fondu + zoom, plus de dessin vectoriel
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: AnimatedBuilder(
                          animation: _drawCtrl,
                          builder: (context, child) {
                            final t = Curves.easeOutBack.transform(_drawCtrl.value);
                            return Opacity(
                              opacity: _drawCtrl.value.clamp(0.0, 1.0),
                              child: Transform.scale(
                                scale: 0.6 + (0.4 * t),
                                child: child,
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/logo_ar.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Text and Tagline
                      FadeTransition(
                        opacity: _textOpacity,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'ANESTHÉSIE',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 3.0,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' & ',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'RÉANIMATION',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 3.0,
                                        color: Color(0xFF38BDF8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              FadeTransition(
                                opacity: _taglineOpacity,
                                child: const Text(
                                  'SURVEILLER  |  PROTÉGER  |  SAUVER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.2,
                                    color: Colors.white38,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadialBackground() => Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.4,
            colors: [
              Color(0xFF0F1E36),
              Color(0xFF08111F),
              Color(0xFF02070F),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
      );
}

class _ProgressiveLogoPainter extends CustomPainter {
  final double lungsProgress;
  final double ecgProgress;
  final double glowOpacity;
  final Color primaryColor;
  final Color accentColor;

  _ProgressiveLogoPainter({
    required this.lungsProgress,
    required this.ecgProgress,
    required this.glowOpacity,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintLungs = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.085
      ..strokeCap = StrokeCap.round;

    final paintDrop = Paint()
      ..style = PaintingStyle.fill;

    final paintEcg = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintEcgGlow = Paint()
      ..color = accentColor.withOpacity(0.35 * glowOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ── 1. DRAW LEFT LUNG PROGRESSIVELY ────────────────────
    final leftPath = Path();
    leftPath.moveTo(w * 0.45, h * 0.10);
    leftPath.cubicTo(w * 0.20, h * 0.05, w * 0.08, h * 0.35, w * 0.16, h * 0.65);
    leftPath.cubicTo(w * 0.20, h * 0.82, w * 0.38, h * 0.95, w * 0.44, h * 0.85);

    paintLungs.shader = LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    if (lungsProgress > 0) {
      try {
        final m = leftPath.computeMetrics().first;
        final partial = m.extractPath(0, m.length * lungsProgress);
        canvas.drawPath(partial, paintLungs);
      } catch (_) {
        canvas.drawPath(leftPath, paintLungs);
      }
    }

    // ── 2. DRAW RIGHT LUNG PROGRESSIVELY ───────────────────
    final rightPath = Path();
    rightPath.moveTo(w * 0.55, h * 0.10);
    rightPath.cubicTo(w * 0.80, h * 0.05, w * 0.92, h * 0.35, w * 0.84, h * 0.65);
    rightPath.cubicTo(w * 0.80, h * 0.82, w * 0.62, h * 0.95, w * 0.56, h * 0.85);

    paintLungs.shader = LinearGradient(
      colors: [accentColor, primaryColor],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    if (lungsProgress > 0) {
      try {
        final m = rightPath.computeMetrics().first;
        final partial = m.extractPath(0, m.length * lungsProgress);
        canvas.drawPath(partial, paintLungs);
      } catch (_) {
        canvas.drawPath(rightPath, paintLungs);
      }
    }

    // ── 3. DRAW INNER DROP (FADE-IN) ───────────────────────
    if (lungsProgress > 0.8) {
      double dropProgress = (lungsProgress - 0.8) / 0.2;
      final dropPath = Path();
      dropPath.moveTo(w * 0.70, h * 0.30);
      dropPath.cubicTo(w * 0.80, h * 0.38, w * 0.82, h * 0.55, w * 0.70, h * 0.62);
      dropPath.cubicTo(w * 0.58, h * 0.55, w * 0.60, h * 0.38, w * 0.70, h * 0.30);

      paintDrop.shader = LinearGradient(
        colors: [accentColor.withOpacity(0.85 * dropProgress), primaryColor.withOpacity(0.3 * dropProgress)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(w * 0.55, h * 0.25, w * 0.3, h * 0.4));
      canvas.drawPath(dropPath, paintDrop);
    }

    // ── 4. DRAW ECG LINE PROGRESSIVELY ─────────────────────
    if (ecgProgress > 0) {
      final ecgPath = Path();
      ecgPath.moveTo(w * 0.05, h * 0.53);
      ecgPath.lineTo(w * 0.25, h * 0.53);
      ecgPath.lineTo(w * 0.29, h * 0.40);
      ecgPath.lineTo(w * 0.34, h * 0.68);
      ecgPath.lineTo(w * 0.39, h * 0.22);
      ecgPath.lineTo(w * 0.44, h * 0.58);
      ecgPath.lineTo(w * 0.48, h * 0.53);
      ecgPath.lineTo(w * 0.55, h * 0.53);

      try {
        final m = ecgPath.computeMetrics().first;
        final partial = m.extractPath(0, m.length * ecgProgress);
        canvas.drawPath(partial, paintEcgGlow);
        canvas.drawPath(partial, paintEcg);

        // Sweeping head dot
        final tangent = m.getTangentForOffset(m.length * ecgProgress);
        if (tangent != null && ecgProgress < 0.98) {
          canvas.drawCircle(tangent.position, 5.0, Paint()..color = accentColor);
          canvas.drawCircle(tangent.position, 2.5, Paint()..color = Colors.white);
        }
      } catch (_) {
        canvas.drawPath(ecgPath, paintEcgGlow);
        canvas.drawPath(ecgPath, paintEcg);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressiveLogoPainter oldDelegate) {
    return oldDelegate.lungsProgress != lungsProgress ||
        oldDelegate.ecgProgress != ecgProgress ||
        oldDelegate.glowOpacity != glowOpacity;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double opacity;
  final double tick;

  const _ParticlePainter({
    required this.particles,
    required this.opacity,
    required this.tick,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dx = math.cos(tick * p.speed * math.pi + p.phase) * 6;
      final dy = math.sin(tick * p.speed * math.pi * 2 + p.phase) * 8;
      canvas.drawCircle(
        Offset(p.x * size.width + dx, p.y * size.height + dy),
        p.radius,
        Paint()
          ..color = (p.teal ? AppColors.accent : const Color(0xFF1565C0)).withOpacity(p.opacity * opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 1.5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.tick != tick;
}

class _Particle {
  final double x, y, radius, speed, opacity, phase;
  final bool teal;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.phase,
    required this.teal,
  });
}