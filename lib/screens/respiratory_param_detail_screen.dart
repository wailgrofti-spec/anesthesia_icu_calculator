// ============================================================================
//  lib/screens/respiratory_param_detail_screen.dart
//  Page de détail générique pour un paramètre ventilatoire (PEEP, VT, FiO2…)
//  Réutilisable pour tous les paramètres — contenu défini dans
//  data/respiratory_detail_data.dart (structure : models/respiratory_param_detail.dart)
// ============================================================================

import 'package:flutter/material.dart';
import '../models/respiratory_param_detail.dart';
import '../utils/theme.dart';

class RespiratoryParamDetailScreen extends StatelessWidget {
  final RespiratoryParamDetail detail;

  /// Note spécifique au profil actif (BPCO, SDRA, Obésité, Post-op).
  /// `null` si le profil est "Ventilation protectrice" (pas de section ajoutée).
  final ProfileParamNote? profileNote;

  /// Nom du profil actif — affiché dans l'en-tête de la section profil.
  final String? profileLabel;

  const RespiratoryParamDetailScreen({
    super.key,
    required this.detail,
    this.profileNote,
    this.profileLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = context.surfaceColor;
    final pageBg = context.backgroundColor;
    final borderC = context.borderColor;
    final textP = context.textColor;
    final textS = context.textMutedColor;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 44,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textS, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textP),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              detail.subtitle,
              style: TextStyle(fontSize: 10, color: textS, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.close_rounded, color: textS, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: borderC),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── DÉFINITION ──────────────────────────────────────
            _DefinitionCard(detail: detail),
            const SizedBox(height: 12),

            // ── POURQUOI CETTE VALEUR ? + carte valeur recommandée ──
            _WhySection(detail: detail),
            const SizedBox(height: 12),

            // ── EFFETS PHYSIOLOGIQUES ────────────────────────────
            _EffectsSection(detail: detail),
            const SizedBox(height: 12),

            // ── COMMENT AJUSTER ? (tableau) + SURVEILLANCE ──────
            _AdjustmentSection(detail: detail),
            const SizedBox(height: 12),

            // ── ENRICHISSEMENT PÉDAGOGIQUE (v3.1) ────────────────
            // Physiologie / objectif clinique / valeurs normales / calcul /
            // quand augmenter / quand diminuer / erreurs fréquentes / cas
            // particuliers / conseils pratiques. N'apparaît que si au
            // moins un champ est renseigné (rétrocompatible).
            if (_EnrichedSection.hasContent(detail)) ...[
              _EnrichedSection(detail: detail),
              const SizedBox(height: 12),
            ],

            // ── SPÉCIFICITÉS DU PROFIL PATHOLOGIQUE ─────────────
            if (profileNote != null && profileLabel != null) ...[
              _ProfileNoteSection(
                note: profileNote!,
                profileLabel: profileLabel!,
                color: detail.color,
              ),
              const SizedBox(height: 12),
            ],

            // ── SOURCES SCIENTIFIQUES (v3.1) ─────────────────────
            if (detail.sources.isNotEmpty) ...[
              _SourcesSection(detail: detail),
              const SizedBox(height: 12),
            ],

            // ── NOTE DE BAS DE PAGE ──────────────────────────────
            _FooterNote(text: detail.footerNote),
          ],
        ),
      ),
    );
  }
}

// ── Carte conteneur générique réutilisée partout sur la page ────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = context.cardColor;
    final borderC = context.borderColor;
    return Container(
      width: double.infinity,
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
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: child,
    );
  }
}

// ── DÉFINITION ───────────────────────────────────────────────────────────────
class _DefinitionCard extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _DefinitionCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;

    return _SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: detail.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(detail.icon, size: 19, color: detail.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.definitionTitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: textS,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  detail.definitionText,
                  style: TextStyle(fontSize: 13, color: textP, height: 1.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── POURQUOI CETTE VALEUR ? + carte valeur recommandée ──────────────────────
class _WhySection extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _WhySection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;
        final whyCard = _SectionCard(child: _WhyContent(detail: detail));
        final valueCard = _RecommendedValueCard(detail: detail);

        if (isNarrow) {
          return Column(
            children: [
              whyCard,
              const SizedBox(height: 12),
              valueCard,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: whyCard),
            const SizedBox(width: 12),
            Expanded(flex: 1, child: valueCard),
          ],
        );
      },
    );
  }
}

class _WhyContent extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _WhyContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.whyTitle,
          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: textS, letterSpacing: 0.6),
        ),
        const SizedBox(height: 8),
        Text(
          detail.whyText,
          style: TextStyle(fontSize: 13, color: textP, height: 1.5, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        ...detail.whyBullets.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, size: 15, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: TextStyle(fontSize: 12.5, color: textP, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _RecommendedValueCard extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _RecommendedValueCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final textS = context.textMutedColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: detail.color.withOpacity(dark ? 0.10 : 0.06),
        borderRadius: AppRadius.card,
        border: Border.all(color: detail.color.withOpacity(0.30), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.recommendedValueLabel,
            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: textS, letterSpacing: 0.5),
          ),
          const SizedBox(height: 10),
          Text(
            detail.recommendedValue,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: detail.color),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: detail.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              detail.recommendedValueBadge,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: detail.color),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            detail.recommendedValueNote,
            style: TextStyle(fontSize: 11, color: textS, height: 1.4, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ── EFFETS PHYSIOLOGIQUES ────────────────────────────────────────────────────
class _EffectsSection extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _EffectsSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final textS = context.textMutedColor;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EFFETS PHYSIOLOGIQUES',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: textS, letterSpacing: 0.6),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 480;
              final benefitsCol = _EffectColumn(
                title: 'Effets bénéfiques',
                titleColor: AppColors.successText,
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.success,
                effects: detail.benefits,
              );
              final risksCol = _EffectColumn(
                title: 'Effets indésirables possibles',
                titleColor: AppColors.dangerText,
                icon: Icons.warning_rounded,
                iconColor: AppColors.warning,
                effects: detail.risks,
              );
              if (isNarrow) {
                return Column(
                  children: [
                    benefitsCol,
                    const SizedBox(height: 14),
                    risksCol,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: benefitsCol),
                  const SizedBox(width: 16),
                  Expanded(child: risksCol),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EffectColumn extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData icon;
  final Color iconColor;
  final List<PhysiologicalEffect> effects;

  const _EffectColumn({
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.iconColor,
    required this.effects,
  });

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: titleColor),
        ),
        const SizedBox(height: 8),
        ...effects.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 14, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e.text,
                      style: TextStyle(fontSize: 12, color: textP, height: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// ── COMMENT AJUSTER ? (tableau) + SURVEILLANCE ───────────────────────────────
class _AdjustmentSection extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _AdjustmentSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;
        final tableCard = _SectionCard(child: _AdjustmentTable(detail: detail));
        final monitoringCard = _SectionCard(child: _MonitoringList(detail: detail));

        if (isNarrow) {
          return Column(
            children: [
              tableCard,
              const SizedBox(height: 12),
              monitoringCard,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: tableCard),
            const SizedBox(width: 12),
            Expanded(flex: 1, child: monitoringCard),
          ],
        );
      },
    );
  }
}

class _AdjustmentTable extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _AdjustmentTable({required this.detail});

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;
    final borderC = context.borderColor;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.adjustmentTitle,
          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: textS, letterSpacing: 0.6),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: borderC, width: 0.8)),
            child: Table(
              columnWidths: const {0: FlexColumnWidth(1.2), 1: FlexColumnWidth(1)},
              border: TableBorder(
                horizontalInside: BorderSide(color: borderC, width: 0.6),
                verticalInside: BorderSide(color: borderC, width: 0.6),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: headerBg),
                  children: [
                    _TableCell('Situation clinique', isHeader: true, textColor: textS),
                    _TableCell('Ajustement recommandé', isHeader: true, textColor: textS),
                  ],
                ),
                for (final row in detail.adjustmentTable)
                  TableRow(children: [
                    _TableCell(row.situation, textColor: textP),
                    _TableCell(row.recommendation, textColor: textP, bold: true),
                  ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool bold;
  final Color textColor;
  const _TableCell(this.text, {this.isHeader = false, this.bold = false, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 10.5 : 12,
          fontWeight: isHeader ? FontWeight.w700 : (bold ? FontWeight.w700 : FontWeight.w500),
          color: textColor,
          letterSpacing: isHeader ? 0.3 : 0,
        ),
      ),
    );
  }
}

class _MonitoringList extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _MonitoringList({required this.detail});

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: detail.color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            detail.monitoringTitle,
            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: detail.color, letterSpacing: 0.5),
          ),
        ),
        const SizedBox(height: 12),
        ...detail.monitoringPoints.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(p.icon, size: 16, color: detail.color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textP),
                        ),
                        Text(
                          p.subtitle,
                          style: TextStyle(fontSize: 10.5, color: textS, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// ── SPÉCIFICITÉS DU PROFIL PATHOLOGIQUE ─────────────────────────────────────
class _ProfileNoteSection extends StatelessWidget {
  final ProfileParamNote note;
  final String profileLabel;
  final Color color;
  const _ProfileNoteSection({
    required this.note,
    required this.profileLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;
    final borderC = context.borderColor;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final sectionBg = dark
        ? color.withOpacity(0.08)
        : color.withOpacity(0.05);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: sectionBg,
        borderRadius: AppRadius.card,
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête du profil ────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.medical_services_outlined, size: 14, color: color),
                const SizedBox(width: 8),
                Text(
                  'SPÉCIFICITÉS — $profileLabel'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Valeur recommandée pour ce profil ───────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      note.recommendedValue,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: color,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          note.recommendedValueBadge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Note contextuelle ────────────────────────────────
                Text(
                  note.contextNote,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: textP,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),

                // ── Tableau d'ajustement ─────────────────────────────
                Text(
                  'AJUSTEMENTS SPÉCIFIQUES',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textS,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: color.withOpacity(0.2), width: 0.8),
                    ),
                    child: Table(
                      columnWidths: const {0: FlexColumnWidth(1.2), 1: FlexColumnWidth(1)},
                      border: TableBorder(
                        horizontalInside: BorderSide(color: borderC, width: 0.6),
                        verticalInside: BorderSide(color: borderC, width: 0.6),
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: headerBg),
                          children: [
                            _TableCell('Situation clinique', isHeader: true, textColor: textS),
                            _TableCell('Ajustement', isHeader: true, textColor: textS),
                          ],
                        ),
                        for (final row in note.adjustmentRows)
                          TableRow(children: [
                            _TableCell(row.situation, textColor: textP),
                            _TableCell(row.recommendation, textColor: textP, bold: true),
                          ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Points de surveillance ───────────────────────────
                Text(
                  'SURVEILLANCE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textS,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                ...note.monitoringPoints.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(p.icon, size: 15, color: color),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: textP,
                                  ),
                                ),
                                Text(
                                  p.subtitle,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: textS,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 4),

                // ── Source ───────────────────────────────────────────
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 12, color: color.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        note.footerSource,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: color.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
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

// ── ENRICHISSEMENT PÉDAGOGIQUE (v3.1) — additif ─────────────────────────────
class _EnrichedSection extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _EnrichedSection({required this.detail});

  static bool hasContent(RespiratoryParamDetail d) =>
      d.physiology.isNotEmpty ||
      d.clinicalGoal.isNotEmpty ||
      d.normalValues.isNotEmpty ||
      d.howToCalculate.isNotEmpty ||
      d.whenToIncrease.isNotEmpty ||
      d.whenToDecrease.isNotEmpty ||
      d.commonErrors.isNotEmpty ||
      d.specialCases.isNotEmpty ||
      d.practicalTips.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'POUR ALLER PLUS LOIN',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: context.textMutedColor, letterSpacing: 0.6),
          ),
          const SizedBox(height: 12),
          if (detail.physiology.isNotEmpty) _EnrichedBlock(label: 'PHYSIOLOGIE', text: detail.physiology, color: detail.color),
          if (detail.clinicalGoal.isNotEmpty) _EnrichedBlock(label: 'OBJECTIF CLINIQUE', text: detail.clinicalGoal, color: detail.color),
          if (detail.normalValues.isNotEmpty) _EnrichedBlock(label: 'VALEURS NORMALES', text: detail.normalValues, color: detail.color),
          if (detail.howToCalculate.isNotEmpty) _EnrichedBlock(label: 'COMMENT CALCULER', text: detail.howToCalculate, color: detail.color),
          if (detail.whenToIncrease.isNotEmpty)
            _EnrichedList(label: 'QUAND AUGMENTER', items: detail.whenToIncrease, icon: Icons.arrow_upward_rounded, iconColor: AppColors.success),
          if (detail.whenToDecrease.isNotEmpty)
            _EnrichedList(label: 'QUAND DIMINUER', items: detail.whenToDecrease, icon: Icons.arrow_downward_rounded, iconColor: AppColors.warning),
          if (detail.specialCases.isNotEmpty)
            _EnrichedList(label: 'CAS PARTICULIERS', items: detail.specialCases, icon: Icons.medical_information_outlined, iconColor: detail.color),
          if (detail.commonErrors.isNotEmpty)
            _EnrichedList(label: 'ERREURS FRÉQUENTES', items: detail.commonErrors, icon: Icons.error_outline_rounded, iconColor: AppColors.dangerText),
          if (detail.practicalTips.isNotEmpty)
            _EnrichedList(label: 'CONSEILS PRATIQUES AU BLOC / EN RÉANIMATION', items: detail.practicalTips, icon: Icons.lightbulb_outline_rounded, iconColor: detail.color, isLast: true),
        ],
      ),
    );
  }
}

class _EnrichedBlock extends StatelessWidget {
  final String label;
  final String text;
  final Color color;
  const _EnrichedBlock({required this.label, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: textS, letterSpacing: 0.5)),
          const SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 12.5, color: textP, height: 1.5, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _EnrichedList extends StatelessWidget {
  final String label;
  final List<String> items;
  final IconData icon;
  final Color iconColor;
  final bool isLast;
  const _EnrichedList({
    required this.label,
    required this.items,
    required this.icon,
    required this.iconColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: textS, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          ...items.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 14, color: iconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(t, style: TextStyle(fontSize: 12, color: textP, height: 1.4, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── SOURCES SCIENTIFIQUES (v3.1) — additif ──────────────────────────────────
class _SourcesSection extends StatelessWidget {
  final RespiratoryParamDetail detail;
  const _SourcesSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 14, color: detail.color),
              const SizedBox(width: 8),
              Text(
                'SOURCES / RÉFÉRENCES',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: textS, letterSpacing: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...detail.sources.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e.key + 1}.',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: detail.color),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        e.value,
                        style: TextStyle(fontSize: 11.5, color: textP, height: 1.4, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── NOTE DE BAS DE PAGE ──────────────────────────────────────────────────────
class _FooterNote extends StatelessWidget {
  final String text;
  const _FooterNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: AppRadius.card,
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
