// ============================================================================
//  lib/widgets/common/patient_header.dart
//  Premium Patient Information Header Widget
// ============================================================================

import 'package:flutter/material.dart';
import '../../models/vitals.dart';
import '../../utils/app_colors.dart';

class PatientHeader extends StatelessWidget {
  final String patientId;
  final String age;
  final String unit;
  final VitalStatus globalStatus;

  const PatientHeader({
    super.key,
    required this.patientId,
    required this.age,
    required this.unit,
    required this.globalStatus,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = dark ? AppColors.darkCard : AppColors.cardWhite;
    final borderC = dark ? AppColors.darkBorder : AppColors.border;
    final textP = dark ? AppColors.darkTextPrimary : AppColors.textDark;
    final textS = dark ? AppColors.darkTextSecondary : AppColors.textGrey;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.card,
        border: Border.all(color: borderC, width: 0.8),
        boxShadow: dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.15), AppColors.accent.withOpacity(0.15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, size: 28, color: dark ? const Color(0xFF38BDF8) : AppColors.primary),
          ),
          const SizedBox(width: 14),

          // Info columns
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoColumn(label: 'Patient ID', value: '#$patientId', textP: textP, textS: textS),
                _InfoColumn(label: 'Âge', value: age, textP: textP, textS: textS),
                _InfoColumn(label: 'Séjour', value: unit, textP: textP, textS: textS),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Status badge
          _StatusBadge(status: globalStatus),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color textP;
  final Color textS;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.textP,
    required this.textS,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.5, color: textS, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textP),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final VitalStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, text, border;
    String label;
    IconData icon;

    switch (status) {
      case VitalStatus.critical:
        bg = AppColors.dangerSurface;
        text = AppColors.dangerText;
        border = AppColors.dangerBorder;
        label = 'CRITIQUE';
        icon = Icons.favorite_rounded;
        break;
      case VitalStatus.warning:
        bg = AppColors.warningSurface;
        text = AppColors.warningText;
        border = AppColors.warningBorder;
        label = 'ANORMAL';
        icon = Icons.warning_rounded;
        break;
      default:
        bg = AppColors.successSurface;
        text = AppColors.successText;
        border = AppColors.successBorder;
        label = 'NORMAL';
        icon = Icons.check_circle_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.card,
        border: Border.all(color: border, width: 0.6),
      ),
      child: Column(
        children: [
          Text(
            'ÉTAT PATIENT',
            style: TextStyle(fontSize: 8.5, color: text, fontWeight: FontWeight.w700, letterSpacing: 0.6),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: text),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: text),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Surveillance',
            style: TextStyle(fontSize: 9, color: text.withOpacity(0.75), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
