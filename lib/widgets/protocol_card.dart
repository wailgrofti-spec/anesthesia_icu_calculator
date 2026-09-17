// ============================================================================
//  lib/widgets/protocol_card.dart
//  Premium medical protocol card component with theme support
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';

/// Animated medical protocol card with support for premium aesthetics.
class ProtocolCard extends StatefulWidget {
  const ProtocolCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCritical = false,
    this.onTap,
    this.animationDelay = Duration.zero,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCritical;
  final VoidCallback? onTap;
  final Duration animationDelay;

  @override
  State<ProtocolCard> createState() => _ProtocolCardState();
}

class _ProtocolCardState extends State<ProtocolCard> with TickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _fadeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleCtrl.forward();

  void _onTapUp(TapUpDetails _) {
    _scaleCtrl.reverse();
    if (widget.isCritical) HapticFeedback.mediumImpact();
    widget.onTap?.call();
  }

  void _onTapCancel() => _scaleCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: child),
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: _CardBody(
              title: widget.title,
              subtitle: widget.subtitle,
              icon: widget.icon,
              isCritical: widget.isCritical,
            ),
          ),
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isCritical,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = context.cardColor;
    final borderC = context.borderColor;
    final textP = context.textColor;
    final textS = context.textMutedColor;

    final criticalColor = dark ? const Color(0xFFEF4444) : AppColors.danger;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.card,
        border: Border.all(color: borderC, width: 0.8),
        boxShadow: dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Bubble
            _IconBubble(icon: icon, isCritical: isCritical, criticalColor: criticalColor),
            const SizedBox(width: 14),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isCritical ? criticalColor : textP,
                      fontSize: isCritical ? 15 : 14,
                      fontWeight: isCritical ? FontWeight.w800 : FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textS,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: isCritical ? criticalColor : AppColors.secondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.isCritical,
    required this.criticalColor,
  });

  final IconData icon;
  final bool isCritical;
  final Color criticalColor;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bubbleBg = isCritical
        ? (dark ? const Color(0xFF2E1717) : AppColors.dangerSurface)
        : (dark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF));
    final bubbleFg = isCritical ? criticalColor : AppColors.secondary;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bubbleBg,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: bubbleFg,
        size: isCritical ? 26 : 22,
      ),
    );
  }
}
