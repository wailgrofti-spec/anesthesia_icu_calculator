// ============================================================================
//  lib/models/respiratory_params.dart
//  VERSION 2.0 — Classes + moteur de calcul génériques.
//  Les valeurs numériques par pathologie sont dans :
//  lib/data/respiratory_calc_data.dart
// ============================================================================

import '../models/patient.dart';
import '../data/respiratory_calc_data.dart';
import '../data/respiratory_calc_pediatric_data.dart';
import '../services/pediatric_validation_service.dart';

// ============================================================================
//  ENUM — Onglets / profils ventilatoires
// ============================================================================

/// Profils de ventilation disponibles (onglets de l'écran).
/// Étape 1 : seul `protective` est pleinement actif côté UI.
/// Les autres ont déjà leurs règles de calcul prêtes dans
/// data/respiratory_calc_data.dart, en attente de l'étape 3.
enum VentilationProfile {
  protective,   // Ventilation protectrice standard (poumons sains)
  copd,         // BPCO
  ards,         // SDRA
  obesity,      // Obésité
  postOp,       // Post-opératoire
}

extension VentilationProfileLabel on VentilationProfile {
  String get label {
    switch (this) {
      case VentilationProfile.protective: return 'Ventilation protectrice';
      case VentilationProfile.ards:        return 'SDRA';
      case VentilationProfile.copd:        return 'BPCO';
      case VentilationProfile.obesity:     return 'Obésité';
      case VentilationProfile.postOp:      return 'Post-op.';
    }
  }

  /// `true` si ce profil est sélectionnable dans l'UI.
  bool get isImplemented => true;
}

// ============================================================================
//  RESULTAT — Plage de valeurs (la plupart des paramètres ventilatoires
//  sont exprimés comme une fourchette, jamais un chiffre unique imposé)
// ============================================================================

class RespiratoryRange {
  final double min;
  final double max;
  final int decimalPlaces;
  const RespiratoryRange(this.min, this.max, {this.decimalPlaces = 0});

  /// Valeur médiane — utile quand un calcul en aval a besoin d'UN chiffre.
  double get mid => (min + max) / 2;

  String get display {
    if (decimalPlaces == 0) {
      return '${min.round()}–${max.round()}';
    }
    return '${min.toStringAsFixed(decimalPlaces)}–${max.toStringAsFixed(decimalPlaces)}';
  }

  @override
  String toString() => display;
}

// ============================================================================
//  RESPIRATORYPARAMS — Résultat complet du calcul pour un patient donné
// ============================================================================

/// Regroupe l'ensemble des paramètres ventilatoires calculés automatiquement
/// à partir du profil patient et du profil de ventilation sélectionné.
///
/// Toutes les valeurs sont calculées — aucune saisie manuelle. Si le patient
/// est incomplet, `RespiratoryParams.compute` retourne `null` (l'écran
/// affiche alors l'état vide invitant à compléter le profil patient).
class RespiratoryParams {
  final Patient patient;
  final VentilationProfile profile;

  /// `true` si ce résultat a été calculé avec les règles pédiatriques
  /// (poids réel comme référence + FR/pressions adaptées à l'âge).
  final bool isPediatric;

  /// Libellé de la tranche d'âge pédiatrique utilisée (null si adulte).
  final String? ageBandLabel;

  // ── Poids de référence ────────────────────────────────────
  final double pbw; // Poids prédit (Predicted Body Weight) — kg

  // ── Volume / ventilation minute ───────────────────────────
  final RespiratoryRange tidalVolumeMlPerKg;  // mL/kg PBW
  final RespiratoryRange tidalVolumeMl;       // mL (absolu)
  final RespiratoryRange minuteVolume;        // L/min

  // ── Fréquence & temps ─────────────────────────────────────
  final RespiratoryRange respiratoryRate;     // /min
  final String ieRatio;                       // ex. "1:2"
  final double inspiratoryTimeSec;            // s
  final RespiratoryRange inspiratoryFlow;      // L/min

  // ── Pressions ──────────────────────────────────────────────
  final double plateauPressureMax;            // cmH2O — limite à ne pas dépasser
  final RespiratoryRange peep;                 // cmH2O
  final RespiratoryRange drivingPressure;      // cmH2O (cible)
  final RespiratoryRange inspiratoryPressure;  // cmH2O (en VPC, au-dessus de la PEEP)

  // ── Oxygénation ────────────────────────────────────────────
  final RespiratoryRange fio2;                 // fraction 0.21–1.0

  // ── Trigger / déclenchement ───────────────────────────────
  final RespiratoryRange triggerFlow;          // L/min (trigger en débit)
  final RespiratoryRange triggerPressure;      // cmH2O (trigger en pression, alternative)

  // ── Alarmes ────────────────────────────────────────────────
  final RespiratoryRange alarmLowTidalVolume;  // mL
  final RespiratoryRange alarmHighPressure;    // cmH2O

  const RespiratoryParams({
    required this.patient,
    required this.profile,
    this.isPediatric = false,
    this.ageBandLabel,
    required this.pbw,
    required this.tidalVolumeMlPerKg,
    required this.tidalVolumeMl,
    required this.minuteVolume,
    required this.respiratoryRate,
    required this.ieRatio,
    required this.inspiratoryTimeSec,
    required this.inspiratoryFlow,
    required this.plateauPressureMax,
    required this.peep,
    required this.drivingPressure,
    required this.inspiratoryPressure,
    required this.fio2,
    required this.triggerFlow,
    required this.triggerPressure,
    required this.alarmLowTidalVolume,
    required this.alarmHighPressure,
  });

  // ══════════════════════════════════════════════════════════
  //  CALCUL PRINCIPAL — générique, lit les bornes depuis
  //  data/respiratory_calc_data.dart (respiratoryCalcRules)
  // ══════════════════════════════════════════════════════════

  /// Calcule tous les paramètres ventilatoires pour un [patient] donné,
  /// selon le [profile] de ventilation sélectionné.
  ///
  /// [isPediatric] : quand `true` (mode pédiatrique actif dans l'app), le
  /// calcul utilise le poids réel comme référence (pas le PBW/Devine, non
  /// valide chez l'enfant) et adapte FR/PEEP/Pplat à la tranche d'âge.
  ///
  /// Retourne `null` si les données patient sont insuffisantes **ou** si
  /// les valeurs saisies sont physiologiquement impossibles (voir
  /// [dataIssue] pour obtenir le message d'erreur à afficher à l'écran
  /// dans ce cas — ne jamais interpréter un retour `null` silencieusement
  /// comme "pas encore de données").
  static RespiratoryParams? compute(
    Patient patient, {
    VentilationProfile profile = VentilationProfile.protective,
    bool isPediatric = false,
  }) {
    // Garde-fou global : toute valeur physiologiquement impossible (âge,
    // poids ou taille incompatibles) bloque le calcul plutôt que de
    // produire un PBW/Vt/volume minute négatif ou aberrant.
    if (dataIssue(patient, isPediatric: isPediatric) != null) return null;

    if (isPediatric) {
      // En pédiatrie, le poids réel est la référence — la taille/le sexe
      // ne sont pas indispensables (contrairement au PBW adulte).
      if (!patient.hasWeight) return null;
    } else {
      if (!patient.hasHeight || !patient.hasSex) return null;
    }

    final rules = respiratoryCalcRules[profile] ??
        respiratoryCalcRules[VentilationProfile.protective]!;

    if (isPediatric) {
      final refWeight = patient.weight!;
      if (refWeight <= 0) return null;
      final ageMonths = patient.ageInMonths ?? 12.0; // repli : ~1 an si âge non saisi
      final band = pediatricAgeBandFromMonths(ageMonths);
      final adjustedRules = _pediatricAdjustedRules(rules, band);
      final result = _computeFromRules(patient, refWeight, profile, adjustedRules);
      if (!_isSane(result)) return null;
      return RespiratoryParams(
        patient: result.patient,
        profile: result.profile,
        isPediatric: true,
        ageBandLabel: band.label,
        pbw: result.pbw,
        tidalVolumeMlPerKg: result.tidalVolumeMlPerKg,
        tidalVolumeMl: result.tidalVolumeMl,
        minuteVolume: result.minuteVolume,
        respiratoryRate: result.respiratoryRate,
        ieRatio: result.ieRatio,
        inspiratoryTimeSec: result.inspiratoryTimeSec,
        inspiratoryFlow: result.inspiratoryFlow,
        plateauPressureMax: result.plateauPressureMax,
        peep: result.peep,
        drivingPressure: result.drivingPressure,
        inspiratoryPressure: result.inspiratoryPressure,
        fio2: result.fio2,
        triggerFlow: result.triggerFlow,
        triggerPressure: result.triggerPressure,
        alarmLowTidalVolume: result.alarmLowTidalVolume,
        alarmHighPressure: result.alarmHighPressure,
      );
    }

    // ── Adulte : PBW (Predicted Body Weight) — formule ARDSNet / Devine ──
    // Homme : PBW = 50.0  + 0.91 × (taille_cm − 152.4)
    // Femme : PBW = 45.5  + 0.91 × (taille_cm − 152.4)
    // [ARDSNet — N Engl J Med. 2000;342(18):1301-8]
    final pbw = patient.computedIbw;
    // Garde-fou : la formule de Devine peut, avec une taille aberrante,
    // produire un PBW négatif ou nul (voir dataIssue — ce cas doit déjà
    // être intercepté en amont, mais on ne fait jamais confiance à un
    // seul point de contrôle pour une valeur affichée au clinicien).
    if (pbw == null || pbw <= 0) return null;

    final result = _computeFromRules(patient, pbw, profile, rules);
    if (!_isSane(result)) return null;
    return result;
  }

  /// Dernier filet de sécurité avant affichage : aucun résultat calculé ne
  /// doit jamais comporter de volume, pression ou fréquence négative —
  /// une valeur négative ne veut rien dire cliniquement et ne doit jamais
  /// atteindre l'écran (voir exigence "Sécurisation des calculs").
  static bool _isSane(RespiratoryParams p) {
    bool rangeOk(RespiratoryRange r) => r.min >= 0 && r.max >= 0 && r.max >= r.min;
    return p.pbw > 0 &&
        rangeOk(p.tidalVolumeMl) &&
        rangeOk(p.minuteVolume) &&
        rangeOk(p.respiratoryRate) &&
        rangeOk(p.peep) &&
        rangeOk(p.drivingPressure) &&
        rangeOk(p.inspiratoryPressure) &&
        rangeOk(p.fio2) &&
        rangeOk(p.triggerFlow) &&
        rangeOk(p.triggerPressure) &&
        rangeOk(p.alarmLowTidalVolume) &&
        rangeOk(p.alarmHighPressure) &&
        p.inspiratoryTimeSec > 0 &&
        p.plateauPressureMax > 0;
  }

  // ══════════════════════════════════════════════════════════
  //  VALIDATION — message d'erreur à afficher, ou `null` si les
  //  données patient permettent un calcul fiable.
  // ══════════════════════════════════════════════════════════

  /// Retourne un message d'erreur clair si les données du [patient] sont
  /// insuffisantes ou physiologiquement impossibles pour calculer les
  /// paramètres ventilatoires ; retourne `null` si tout est en ordre.
  ///
  /// À appeler par l'écran AVANT [compute], pour distinguer :
  /// - "aucune donnée saisie pour l'instant" (état vide neutre)
  /// - "donnée saisie mais impossible" (état d'erreur — jamais un calcul
  ///   silencieusement faux).
  static String? dataIssue(Patient patient, {required bool isPediatric}) {
    if (isPediatric) {
      if (!patient.hasWeight) return null; // état vide normal, pas une erreur
    } else {
      if (!patient.hasHeight || !patient.hasSex) return null;
    }

    final validation = PediatricValidationService.validateAll(patient);
    if (validation.isDanger) {
      return validation.message;
    }

    if (!isPediatric) {
      final pbw = patient.computedIbw;
      if (pbw == null || pbw <= 0) {
        return '🔴 Impossible de calculer un poids prédictif (PBW) fiable '
            'avec la taille et le sexe renseignés. Vérifiez la saisie.';
      }
    } else if ((patient.weight ?? 0) <= 0) {
      return '🔴 Le poids renseigné doit être supérieur à 0 kg.';
    }

    return null;
  }

  /// Adapte les bornes FR / PEEP / Pplat d'une règle adulte à la tranche
  /// d'âge pédiatrique [band] — le Vt/kg, FiO2 et driving pressure restent
  /// les ratios des sociétés savantes (transposables tels quels à l'enfant).
  static VentilationProfileRules _pediatricAdjustedRules(
    VentilationProfileRules base,
    PediatricAgeBand band,
  ) {
    final fr = pediatricFrByAgeBand[band]!;
    final peep = pediatricPeepByAgeBand[band]!;
    return VentilationProfileRules(
      vtPerKgMin: base.vtPerKgMin,
      vtPerKgMax: base.vtPerKgMax,
      frMin: fr.min,
      frMax: fr.max,
      peepMin: peep.min,
      peepMax: peep.max,
      fio2Min: base.fio2Min,
      fio2Max: base.fio2Max,
      plateauPressureMax: pediatricPlateauPressureMax,
      drivingPressureMin: base.drivingPressureMin,
      drivingPressureMax: base.drivingPressureMax,
      inspPressureMin: base.inspPressureMin,
      inspPressureMax: base.inspPressureMax,
      ieRatio: base.ieRatio,
      triggerFlowMin: base.triggerFlowMin,
      triggerFlowMax: base.triggerFlowMax,
      triggerPressureMin: base.triggerPressureMin,
      triggerPressureMax: base.triggerPressureMax,
      alarmHighPressureMin: base.alarmHighPressureMin,
      alarmHighPressureMax: base.alarmHighPressureMax,
    );
  }

  /// Applique les bornes [rules] (issues de data/respiratory_calc_data.dart)
  /// au [pbw] du patient pour produire l'ensemble des paramètres calculés.
  /// Cette méthode est volontairement générique : elle ne contient aucune
  /// valeur médicale en dur, uniquement des formules.
  static RespiratoryParams _computeFromRules(
    Patient patient,
    double pbw,
    VentilationProfile profile,
    VentilationProfileRules rules,
  ) {
    // Vt = bornes mL/kg PBW × PBW, arrondi à la dizaine (convention clinique :
    // les ventilateurs se règlent par paliers de 10 mL pour le volume courant).
    final vtMl = RespiratoryRange(
      _roundToTen(pbw * rules.vtPerKgMin),
      _roundToTen(pbw * rules.vtPerKgMax),
    );

    // Volume minute estimé = Vt × FR sur toute la plage (mL → L).
    final minuteVolume = RespiratoryRange(
      (vtMl.min / 1000.0) * rules.frMin,
      (vtMl.max / 1000.0) * rules.frMax,
      decimalPlaces: 1,
    );

    // Temps inspiratoire pour un cycle à FR médiane, selon le rapport I:E.
    final frMid = (rules.frMin + rules.frMax) / 2;
    final cycleSec = 60.0 / frMid;
    final ieParts = _parseIeRatio(rules.ieRatio); // ex. "1:3" -> (1, 3)
    final inspiratoryTimeSec = cycleSec * (ieParts.$1 / (ieParts.$1 + ieParts.$2));

    // Débit inspiratoire conseillé (L/min) ≈ Vt(L) / Ti(min), avec une marge
    // clinique de ±15 % autour de la valeur médiane.
    final vtMidL = (vtMl.min + vtMl.max) / 2 / 1000.0;
    final flowMid = vtMidL / (inspiratoryTimeSec / 60.0);
    final inspiratoryFlow = RespiratoryRange(
      flowMid * 0.85,
      flowMid * 1.15,
      decimalPlaces: 0,
    );

    return RespiratoryParams(
      patient: patient,
      profile: profile,
      pbw: pbw,
      tidalVolumeMlPerKg: RespiratoryRange(rules.vtPerKgMin, rules.vtPerKgMax, decimalPlaces: 0),
      tidalVolumeMl: vtMl,
      minuteVolume: minuteVolume,
      respiratoryRate: RespiratoryRange(rules.frMin, rules.frMax),
      ieRatio: rules.ieRatio,
      inspiratoryTimeSec: inspiratoryTimeSec,
      inspiratoryFlow: inspiratoryFlow,
      plateauPressureMax: rules.plateauPressureMax,
      peep: RespiratoryRange(rules.peepMin, rules.peepMax),
      drivingPressure: RespiratoryRange(rules.drivingPressureMin, rules.drivingPressureMax),
      inspiratoryPressure: RespiratoryRange(rules.inspPressureMin, rules.inspPressureMax),
      fio2: RespiratoryRange(rules.fio2Min, rules.fio2Max, decimalPlaces: 1),
      triggerFlow: RespiratoryRange(rules.triggerFlowMin, rules.triggerFlowMax, decimalPlaces: 1),
      triggerPressure: RespiratoryRange(rules.triggerPressureMin, rules.triggerPressureMax, decimalPlaces: 1),
      alarmLowTidalVolume: RespiratoryRange(
        (vtMl.min * 0.7).roundToDouble(),
        (vtMl.min * 0.85).roundToDouble(),
      ),
      alarmHighPressure: RespiratoryRange(rules.alarmHighPressureMin, rules.alarmHighPressureMax),
    );
  }

  // ── Affichage condensé du poids de référence ──────────────
  // Adulte : PBW (poids prédit/théorique). Pédiatrie : poids réel.
  String get pbwDisplay => '${pbw.toStringAsFixed(1)} kg';

  /// Libellé du poids de référence utilisé pour le calcul du Vt —
  /// "PBW" (poids prédit) chez l'adulte, "poids réel" en pédiatrie.
  String get referenceWeightLabel => isPediatric ? 'Poids réel' : 'PBW';
}

/// Arrondit à la dizaine la plus proche — convention clinique : les
/// ventilateurs se règlent par paliers de 10 mL pour le volume courant.
double _roundToTen(double value) => (value / 10).round() * 10.0;

/// Parse un rapport I:E ("1:2", "1:3"...) en un tuple (inspiration, expiration).
(double, double) _parseIeRatio(String ratio) {
  final parts = ratio.split(':');
  if (parts.length != 2) return (1.0, 2.0); // valeur de repli sûre
  final i = double.tryParse(parts[0]) ?? 1.0;
  final e = double.tryParse(parts[1]) ?? 2.0;
  return (i, e);
}
