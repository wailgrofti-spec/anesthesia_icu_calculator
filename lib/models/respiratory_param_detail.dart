// ============================================================================
//  lib/models/respiratory_param_detail.dart
//  VERSION 3.0 — Classes uniquement (structure).
//  Les données communes (PEEP, VT, Pplat, FiO2...) sont dans :
//  lib/data/respiratory_detail_data.dart
//  Les données par profil pathologique sont dans :
//  lib/data/respiratory_profile_detail_data.dart
// ============================================================================

import 'package:flutter/material.dart';

/// Un effet (bénéfique ou indésirable) listé dans "Effets physiologiques".
class PhysiologicalEffect {
  final String text;
  const PhysiologicalEffect(this.text);
}

/// Une ligne du tableau "Comment ajuster ?" — une situation clinique
/// associée à une recommandation de réglage.
class AdjustmentTableRow {
  final String situation;
  final String recommendation;
  const AdjustmentTableRow(this.situation, this.recommendation);
}

/// Un point de surveillance (carte "À surveiller").
class MonitoringPoint {
  final IconData icon;
  final String title;
  final String subtitle;
  const MonitoringPoint({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

/// Contenu complet d'une page de détail de paramètre ventilatoire
/// (PEEP, VT, FiO2, FR, Pplat, Driving Pressure, I:E, Trigger, etc.)
class RespiratoryParamDetail {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  final String definitionTitle;
  final String definitionText;

  final String whyTitle;
  final String whyText;
  final List<String> whyBullets;

  final String recommendedValueLabel;
  final String recommendedValue;
  final String recommendedValueBadge;
  final String recommendedValueNote;

  final List<PhysiologicalEffect> benefits;
  final List<PhysiologicalEffect> risks;

  final String adjustmentTitle;
  final List<AdjustmentTableRow> adjustmentTable;

  final String monitoringTitle;
  final List<MonitoringPoint> monitoringPoints;

  final String footerNote;

  // ══════════════════════════════════════════════════════════
  //  NOUVEAU (v3.1) — Enrichissement pédagogique + sources.
  //  Champs OPTIONNELS (valeur par défaut = vide) : toutes les fiches
  //  existantes continuent de compiler et de s'afficher à l'identique
  //  si elles ne les renseignent pas. La page de détail n'affiche une
  //  section que si elle contient au moins un élément.
  // ══════════════════════════════════════════════════════════

  /// Rappel physiologique (mécanique respiratoire, échanges gazeux...).
  final String physiology;

  /// Objectif clinique poursuivi par le réglage de ce paramètre.
  final String clinicalGoal;

  /// Valeurs normales physiologiques (≠ valeur *recommandée sur le
  /// ventilateur*, donnée par [recommendedValue]).
  final String normalValues;

  /// Comment la valeur est calculée (formule / méthode).
  final String howToCalculate;

  /// Situations cliniques qui justifient une AUGMENTATION du paramètre.
  final List<String> whenToIncrease;

  /// Situations cliniques qui justifient une DIMINUTION du paramètre.
  final List<String> whenToDecrease;

  /// Erreurs fréquentes de réglage ou d'interprétation.
  final List<String> commonErrors;

  /// Cas particuliers (BPCO, SDRA, Obésité, Pédiatrie...).
  final List<String> specialCases;

  /// Conseils pratiques au bloc opératoire / en réanimation.
  final List<String> practicalTips;

  /// Références scientifiques (sociétés savantes, essais, ouvrages).
  final List<String> sources;

  const RespiratoryParamDetail({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.definitionTitle,
    required this.definitionText,
    required this.whyTitle,
    required this.whyText,
    required this.whyBullets,
    required this.recommendedValueLabel,
    required this.recommendedValue,
    required this.recommendedValueBadge,
    required this.recommendedValueNote,
    required this.benefits,
    required this.risks,
    required this.adjustmentTitle,
    required this.adjustmentTable,
    required this.monitoringTitle,
    required this.monitoringPoints,
    required this.footerNote,
    this.physiology = '',
    this.clinicalGoal = '',
    this.normalValues = '',
    this.howToCalculate = '',
    this.whenToIncrease = const [],
    this.whenToDecrease = const [],
    this.commonErrors = const [],
    this.specialCases = const [],
    this.practicalTips = const [],
    this.sources = const [],
  });
}

// ============================================================================
//  PROFIL PATHOLOGIQUE — Note spécifique par profil pour un paramètre donné
//  Utilisée par lib/data/respiratory_profile_detail_data.dart
// ============================================================================

/// Contenu pédagogique spécifique à un profil (BPCO, SDRA, Obésité, Post-op)
/// pour un paramètre ventilatoire donné. Affiché en bas de la page de détail
/// quand un profil pathologique est actif.
class ProfileParamNote {
  /// Valeur recommandée pour ce profil (ex. "6", "8 - 12").
  final String recommendedValue;

  /// Unité / badge (ex. "mL/kg PBW", "cmH₂O").
  final String recommendedValueBadge;

  /// Phrase contextuelle courte expliquant la spécificité du profil.
  final String contextNote;

  /// Lignes du tableau "Ajustement — spécificités du profil".
  final List<AdjustmentTableRow> adjustmentRows;

  /// Points de surveillance propres à ce profil.
  final List<MonitoringPoint> monitoringPoints;

  /// Référence source affichée en bas de section.
  final String footerSource;

  /// Références scientifiques détaillées (optionnel — [footerSource]
  /// reste affiché tel quel si cette liste est vide).
  final List<String> sources;

  const ProfileParamNote({
    required this.recommendedValue,
    required this.recommendedValueBadge,
    required this.contextNote,
    required this.adjustmentRows,
    required this.monitoringPoints,
    required this.footerSource,
    this.sources = const [],
  });
}
