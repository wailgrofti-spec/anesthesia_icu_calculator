// ============================================================================
//  lib/models/respiratory_advanced_calc.dart
//  NOUVEAU — Calculs additifs pour :
//   - la section "Paramètres avancés" (compliance statique/dynamique,
//     résistance des voies aériennes, pression moyenne, auto-PEEP,
//     Mechanical Power) ;
//   - la section "Alarmes recommandées" étendue (10 alarmes).
//
//  Fichier 100 % ADDITIF : il consomme `RespiratoryParams` déjà calculé
//  par respiratory_params.dart sans le modifier et sans dupliquer sa
//  logique. Aucune fonctionnalité existante n'est touchée.
//
//  Avertissement clinique : la compliance, la résistance et l'auto-PEEP
//  sont, en pratique réelle, des grandeurs MESURÉES par le ventilateur
//  (courbes pression/volume/débit), pas des grandeurs qu'on peut déduire
//  du seul poids/taille d'un patient. Les valeurs fournies ici sont donc
//  des VALEURS CIBLES / NORMALES DE RÉFÉRENCE (attendues chez un patient
//  sans pathologie pulmonaire significative), pas des mesures — exactement
//  comme le fait déjà l'app pour la Pplat (limite ≤ 30, pas une mesure).
//  Le Pmean et le Mechanical Power sont en revanche ESTIMÉS à partir des
//  réglages cibles calculés (Vt, FR, PEEP, pressions), avec la mention
//  "estimé" clairement affichée — jamais une mesure réelle.
//
//  Sources : Gattinoni L. et al. "Ventilator-related causes of lung
//  injury: the mechanical power" Intensive Care Med 2016 ; Serpa Neto A.
//  et al. "Mechanical power of ventilation is associated with mortality
//  in critically ill patients" Intensive Care Med 2018 ; Tobin M.
//  "Principles and Practice of Mechanical Ventilation" 3e éd. ; Miller's
//  Anesthesia 9e éd. (mécanique respiratoire) ; Marino's The ICU Book.
// ============================================================================

import 'respiratory_params.dart';

/// Résultat des calculs "Paramètres avancés" pour un [RespiratoryParams]
/// donné. Toutes les plages "cible/normale" sont mises à l'échelle du
/// poids de référence du patient (PBW ou poids réel en pédiatrie) —
/// aucune valeur fixe universelle n'est utilisée pour la compliance.
class RespiratoryAdvancedParams {
  /// Compliance statique normale attendue — seuil plancher (mL/cmH₂O).
  /// Formule : ≈ 0.6 mL/cmH₂O par kg de poids de référence (valeur usuelle
  /// chez l'adulte ~70 kg : ≈ 40-50 mL/cmH₂O ; abaissée en cas de SDRA,
  /// obésité ou rigidité pariétale — voir spécificités par profil).
  final double staticComplianceMin; // mL/cmH2O

  /// Compliance dynamique normale attendue (toujours < compliance
  /// statique car elle intègre en plus la résistance des voies aériennes).
  final RespiratoryRange dynamicCompliance; // mL/cmH2O

  /// Résistance des voies aériennes normale attendue (sonde d'intubation
  /// standard adulte ; plus élevée en pédiatrie du fait du diamètre de
  /// sonde plus petit — résistance ∝ 1/rayon⁴).
  final RespiratoryRange airwayResistance; // cmH2O/L/s

  /// Pression moyenne des voies aériennes — ESTIMÉE à partir des réglages
  /// cibles (PEEP, pression inspiratoire, rapport I:E, FR).
  final double meanAirwayPressureEstimate; // cmH2O

  /// Plage de pression moyenne usuellement observée pour ce profil
  /// (repère de plausibilité, pas une cible stricte).
  final RespiratoryRange meanAirwayPressureReference; // cmH2O

  /// Auto-PEEP (PEEP intrinsèque) cible normale — idéalement proche de 0,
  /// témoignant de l'absence de piégeage gazeux / hyperinflation dynamique.
  final RespiratoryRange autoPeepTarget; // cmH2O

  /// Mechanical Power — ESTIMÉ à partir des réglages cibles calculés
  /// (formule simplifiée de Gattinoni, ventilation contrôlée).
  final double mechanicalPowerEstimate; // J/min

  /// Seuil de vigilance validé par la littérature (association à une
  /// surmortalité au-delà de ce seuil chez le patient de réanimation).
  final double mechanicalPowerAlertThreshold; // J/min — 17 J/min (Serpa Neto 2018)

  const RespiratoryAdvancedParams({
    required this.staticComplianceMin,
    required this.dynamicCompliance,
    required this.airwayResistance,
    required this.meanAirwayPressureEstimate,
    required this.meanAirwayPressureReference,
    required this.autoPeepTarget,
    required this.mechanicalPowerEstimate,
    required this.mechanicalPowerAlertThreshold,
  });

  String get staticComplianceDisplay => '≥ ${staticComplianceMin.toStringAsFixed(0)}';
  String get mechanicalPowerThresholdDisplay =>
      '< ${mechanicalPowerAlertThreshold.toStringAsFixed(0)}';
  String get mechanicalPowerEstimateDisplay =>
      '${mechanicalPowerEstimate.toStringAsFixed(1)} J/min';

  /// `true` si la puissance mécanique estimée dépasse le seuil de
  /// vigilance (17 J/min) — signalé en UI par un badge d'alerte.
  bool get mechanicalPowerIsHigh => mechanicalPowerEstimate >= mechanicalPowerAlertThreshold;

  // ══════════════════════════════════════════════════════════
  //  CALCUL
  // ══════════════════════════════════════════════════════════
  static RespiratoryAdvancedParams compute(RespiratoryParams p) {
    // ── Compliance ────────────────────────────────────────────
    // Cible normale mise à l'échelle du poids de référence (PBW adulte /
    // poids réel pédiatrique) plutôt qu'un chiffre universel fixe.
    final staticComplianceMin = (0.6 * p.pbw).clamp(15.0, 120.0);
    final dynamicCompliance = RespiratoryRange(
      staticComplianceMin * 0.55,
      staticComplianceMin * 0.80,
    );

    // ── Résistance des voies aériennes ──────────────────────────
    final airwayResistance = p.isPediatric
        ? const RespiratoryRange(8, 25) // sonde plus fine → résistance plus élevée
        : const RespiratoryRange(5, 15);

    // ── Pression moyenne (Pmean) — estimation ───────────────────
    // Pmean ≈ PEEP + (Pinsp au-dessus de la PEEP) × (Ti / cycle total)
    final peepMid = p.peep.mid;
    final pInspAbovePeep = p.inspiratoryPressure.mid;
    final frMid = p.respiratoryRate.mid;
    final cycleSec = frMid > 0 ? 60.0 / frMid : 4.0;
    final ti = p.inspiratoryTimeSec;
    final meanAirwayPressureEstimate =
        peepMid + pInspAbovePeep * (ti / cycleSec).clamp(0.0, 1.0);
    final meanAirwayPressureReference = RespiratoryRange(
      peepMid + 2,
      peepMid + 10,
      decimalPlaces: 0,
    );

    // ── Auto-PEEP cible ──────────────────────────────────────────
    const autoPeepTarget = RespiratoryRange(0, 2);

    // ── Mechanical Power — estimation (formule simplifiée Gattinoni,
    //    mode contrôlé) : MP(J/min) = 0.098 × RR × Vt(L) × [Ppeak − 0.5×ΔP]
    final vtL = p.tidalVolumeMl.mid / 1000.0;
    final peakPressureEstimate = peepMid + pInspAbovePeep;
    final drivingPressureMid = p.drivingPressure.mid;
    final mechanicalPowerEstimate = 0.098 *
        frMid *
        vtL *
        (peakPressureEstimate - 0.5 * drivingPressureMid);

    return RespiratoryAdvancedParams(
      staticComplianceMin: staticComplianceMin,
      dynamicCompliance: dynamicCompliance,
      airwayResistance: airwayResistance,
      meanAirwayPressureEstimate: meanAirwayPressureEstimate,
      meanAirwayPressureReference: meanAirwayPressureReference,
      autoPeepTarget: autoPeepTarget,
      mechanicalPowerEstimate: mechanicalPowerEstimate.clamp(0.0, 999.0),
      mechanicalPowerAlertThreshold: 17.0,
    );
  }
}

// ============================================================================
//  ALARMES RECOMMANDÉES — étend les 2 alarmes déjà existantes
//  (alarmLowTidalVolume, alarmHighPressure) à un jeu complet de 10 alarmes,
//  toutes calculées automatiquement à partir de RespiratoryParams.
// ============================================================================

class RespiratoryAlarmSettings {
  final RespiratoryRange lowTidalVolume;   // mL — reprend le calcul existant
  final RespiratoryRange highTidalVolume;  // mL
  final double lowPressureThreshold;       // cmH2O — alerte débranchement
  final RespiratoryRange highPressure;     // cmH2O — reprend le calcul existant
  final double lowMinuteVolume;            // L/min
  final double highMinuteVolume;           // L/min
  final double apneaSeconds;               // s
  final double lowFio2;                    // fraction
  final double highFio2;                   // fraction
  final double lowPeep;                    // cmH2O
  final double highPeep;                   // cmH2O

  const RespiratoryAlarmSettings({
    required this.lowTidalVolume,
    required this.highTidalVolume,
    required this.lowPressureThreshold,
    required this.highPressure,
    required this.lowMinuteVolume,
    required this.highMinuteVolume,
    required this.apneaSeconds,
    required this.lowFio2,
    required this.highFio2,
    required this.lowPeep,
    required this.highPeep,
  });

  static RespiratoryAlarmSettings compute(RespiratoryParams p) {
    final highTidalVolume = RespiratoryRange(
      p.tidalVolumeMl.max * 1.10,
      p.tidalVolumeMl.max * 1.30,
    );
    final lowPressureThreshold = (p.peep.min - 3).clamp(0.0, 99.0);
    final lowMinuteVolume = p.minuteVolume.min * 0.70;
    final highMinuteVolume = p.minuteVolume.max * 1.30;
    // Apnée : seuil plus court chez le nourrisson/petit enfant (réserve
    // respiratoire moindre) que chez l'adulte/grand enfant.
    final apneaSeconds = p.isPediatric ? 15.0 : 20.0;
    final lowFio2 = (p.fio2.min - 0.10).clamp(0.21, 1.0);
    final highFio2 = (p.fio2.max + 0.20).clamp(0.21, 1.0);
    final lowPeep = (p.peep.min - 2).clamp(0.0, 40.0);
    final highPeep = p.peep.max + 3;

    return RespiratoryAlarmSettings(
      lowTidalVolume: p.alarmLowTidalVolume,
      highTidalVolume: highTidalVolume,
      lowPressureThreshold: lowPressureThreshold,
      highPressure: p.alarmHighPressure,
      lowMinuteVolume: lowMinuteVolume,
      highMinuteVolume: highMinuteVolume,
      apneaSeconds: apneaSeconds,
      lowFio2: lowFio2,
      highFio2: highFio2,
      lowPeep: lowPeep,
      highPeep: highPeep,
    );
  }
}
