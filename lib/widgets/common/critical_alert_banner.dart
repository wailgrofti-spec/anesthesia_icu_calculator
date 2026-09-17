// ============================================================================
//  lib/widgets/common/critical_alert_banner.dart
//  Premium Critical Alert Banner Widget
// ============================================================================

import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CriticalAlertBanner extends StatelessWidget {
  final VoidCallback? onViewDetails;

  const CriticalAlertBanner({super.key, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    
    final bg = dark ? const Color(0xFF2E1717) : AppColors.dangerSurface;
    final border = dark ? const Color(0xFF5C2626) : AppColors.dangerBorder;
    final text = dark ? const Color(0xFFFFA5A5) : AppColors.dangerText;
    final iconColor = dark ? const Color(0xFFEF4444) : AppColors.danger;
    final btnBg = dark ? const Color(0xFFEF4444) : AppColors.danger;
    final btnText = dark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.card,
        border: Border.all(color: border, width: 0.8),
        boxShadow: dark
            ? []
            : [
                BoxShadow(
                  color: AppColors.danger.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning_rounded, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alerte critique',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: text),
                ),
                const SizedBox(height: 2),
                Text(
                  'Plusieurs paramètres en dehors des plages normales.',
                  style: TextStyle(fontSize: 11.5, color: text.withOpacity(0.80), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onViewDetails,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: btnBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'Voir détails',
                    style: TextStyle(color: btnText, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, color: btnText, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
