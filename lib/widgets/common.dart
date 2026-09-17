import 'package:flutter/material.dart';
import '../models/vitals.dart';
import '../utils/theme.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
      );
}

class MedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const MedCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.borderColor, width: 0.8),
      ),
      child: child,
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.borderColor, width: 0.6),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertBanner extends StatelessWidget {
  final String text;

  const AlertBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF2E1717) : AppColors.dangerSurface;
    final border = dark ? const Color(0xFF5C2626) : AppColors.dangerBorder;
    final textC = dark ? const Color(0xFFFFA5A5) : AppColors.dangerText;
    final iconC = dark ? const Color(0xFFEF4444) : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.small,
        border: Border.all(color: border, width: 0.6),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: iconC, shape: BoxShape.circle),
            child: const Center(
              child: Text(
                '!',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: textC, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class DoseResultCard extends StatelessWidget {
  final String label;
  final String amount;
  final String unit;
  final String subtitle;
  final bool isCaution;

  const DoseResultCard({
    super.key,
    required this.label,
    required this.amount,
    required this.unit,
    required this.subtitle,
    this.isCaution = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final bg = isCaution
        ? (dark ? const Color(0xFF2B200A) : AppColors.warningSurface)
        : (dark ? const Color(0xFF0F2617) : AppColors.successSurface);
    final border = isCaution
        ? (dark ? const Color(0xFF5C4010) : AppColors.warningBorder)
        : (dark ? const Color(0xFF1E5C2D) : AppColors.successBorder);
    final text = isCaution
        ? (dark ? const Color(0xFFFCD34D) : AppColors.warningText)
        : (dark ? const Color(0xFF86EFAC) : AppColors.successText);
    final sub = isCaution
        ? (dark ? const Color(0xFFFBBF24) : AppColors.warning)
        : (dark ? const Color(0xFF4ADE80) : AppColors.success);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.small,
        border: Border.all(color: border, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: text, letterSpacing: 0.5),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: text)),
                TextSpan(text: '  $unit', style: TextStyle(fontSize: 13, color: text, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11, color: sub, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

Color vitalStatusColor(VitalStatus s, {bool surface = false}) {
  switch (s) {
    case VitalStatus.normal:
      return surface ? AppColors.successSurface : AppColors.successText;
    case VitalStatus.warning:
      return surface ? AppColors.warningSurface : AppColors.warningText;
    case VitalStatus.critical:
      return surface ? AppColors.dangerSurface : AppColors.dangerText;
    case VitalStatus.unknown:
      return surface ? Colors.grey.shade100 : Colors.grey.shade600;
  }
}
