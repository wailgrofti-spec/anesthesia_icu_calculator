// ============================================================================
//  lib/widgets/monitor_card.dart
//  Medical Monitor Card — animated vital stat display with gradient header
// ============================================================================

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'medical_animations.dart';

/// A premium medical monitor card displaying a vital sign value with:
/// - Gradient accent top bar
/// - Animated ECG mini-line
/// - Live pulse ring indicator
/// - Animated value counter
class MedicalMonitorCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String normalRange;
  final IconData icon;
  final Color color;
  final VitalCardStatus status;
  final bool showEcg;
  final bool showPulse;

  const MedicalMonitorCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.normalRange,
    required this.icon,
    required this.color,
    this.status = VitalCardStatus.normal,
    this.showEcg = true,
    this.showPulse = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.cardWhite;
    final borderC = isDark ? AppColors.darkBorder : AppColors.border;
    final textP = isDark ? AppColors.darkTextPrimary : AppColors.textDark;
    final textS = isDark ? AppColors.darkTextSecondary : AppColors.textGrey;

    Color statusBg, statusText, statusBorder;
    String statusLabel;

    switch (status) {
      case VitalCardStatus.critical:
        statusBg = isDark ? const Color(0xFF2E1717) : AppColors.dangerSurface;
        statusText = isDark ? const Color(0xFFFFA5A5) : AppColors.dangerText;
        statusBorder = isDark ? const Color(0xFF5C2626) : AppColors.dangerBorder;
        statusLabel = 'Critique';
        break;
      case VitalCardStatus.warning:
        statusBg = isDark ? const Color(0xFF2B200A) : AppColors.warningSurface;
        statusText = isDark ? const Color(0xFFFCD34D) : AppColors.warningText;
        statusBorder = isDark ? const Color(0xFF5C4010) : AppColors.warningBorder;
        statusLabel = 'Anormal';
        break;
      case VitalCardStatus.normal:
      default:
        statusBg = isDark ? const Color(0xFF0F2617) : AppColors.successSurface;
        statusText = isDark ? const Color(0xFF86EFAC) : AppColors.successText;
        statusBorder = isDark ? const Color(0xFF1E5C2D) : AppColors.successBorder;
        statusLabel = 'Normale';
    }

    final valueColor = status == VitalCardStatus.critical
        ? AppColors.danger
        : status == VitalCardStatus.warning
            ? AppColors.warning
            : textP;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.card,
        border: Border.all(color: borderC, width: 0.8),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: color.withOpacity(0.06),
                  blurRadius: 14,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient accent top bar ────────────────────────────────────
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: Icon + Name + Pulse indicator ─────────────────
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 15, color: color),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: textS,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showPulse)
                      PulseRingAnimation(
                        size: 6,
                        color: status == VitalCardStatus.critical
                            ? AppColors.danger
                            : status == VitalCardStatus.warning
                                ? AppColors.warning
                                : AppColors.accent,
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Value + Unit ───────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: valueColor,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 10,
                        color: textS,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ── ECG mini animation ─────────────────────────────────────
                if (showEcg)
                  SizedBox(
                    height: 22,
                    width: double.infinity,
                    child: ClipRRect(
                      child: EcgPulseAnimation(color: color, height: 22),
                    ),
                  ),

                if (showEcg) const SizedBox(height: 6),

                // ── Status badge + normal range ───────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusBorder, width: 0.6),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: statusText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '($normalRange)',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: textS,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum VitalCardStatus { normal, warning, critical }
