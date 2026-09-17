// ===========================
//  lib/utils/opioid_calculators.dart
//  Calculateurs de doses — Module Opioïdes
//
//  ⚠️ EMPLACEMENT : ce fichier suppose l'arborescence lib/utils/. Si votre
//  projet utilise un autre dossier (lib/services/, lib/logic/...), déplacez
//  le fichier et ajustez l'import de drug.dart en conséquence.
//
//  Fonctions PURES (pas d'état, pas de dépendance UI) : faciles à tester
//  unitairement. Toutes les fonctions retournent des résultats accompagnés
//  d'un statut de confiance (voir DoseCalculationResult) plutôt que de
//  masquer les cas limites (poids nul, dose plafond dépassé, méthadone...).
//
//  RAPPEL DE SÉCURITÉ : ces calculateurs assistent la prescription, ils ne
//  la remplacent pas. Toute dose calculée doit être relue par le
//  prescripteur avant administration. La méthadone est volontairement
//  exclue du calcul automatique de rotation (voir [OpioidProfile] sur
//  methadone) — n'implémentez pas de conversion automatique pour cette
//  molécule sans avis pharmacologique clinique formalisé.
// ===========================

import '../models/drug.dart';

/// Résultat d'un calcul de dose — inclut la valeur ET un statut de
/// confiance, pour que l'UI puisse afficher un avertissement visuel
/// (ex : dose plafond dépassée, poids hors intervalle usuel).
class DoseCalculationResult {
  final double value;
  final String unitLabel;
  final bool exceedsMaxAbsoluteDose;
  final bool belowTypicalRange;
  final bool aboveTypicalRange;
  final String? warning;

  const DoseCalculationResult({
    required this.value,
    required this.unitLabel,
    this.exceedsMaxAbsoluteDose = false,
    this.belowTypicalRange = false,
    this.aboveTypicalRange = false,
    this.warning,
  });

  @override
  String toString() => "${value.toStringAsFixed(2)} $unitLabel";
}

class OpioidCalculators {
  OpioidCalculators._(); // classe utilitaire statique, non instanciable

  // ──────────────────────────────────────────────────────────
  //  1. CONVERSIONS D'UNITÉS DE BASE
  // ──────────────────────────────────────────────────────────

  static double mcgToMg(double mcg) => mcg / 1000.0;
  static double mgToMcg(double mg) => mg * 1000.0;

  /// Convertit une dose en mg vers un volume en ml selon la concentration
  /// standard de la préparation (mg/ml). Retourne null si la concentration
  /// n'est pas renseignée pour ce médicament (ex : hydromorphone,
  /// péthidine — présentations variables selon le pays, à vérifier
  /// localement avant tout calcul automatique de volume).
  static double? mgToMl(double doseMg, Drug drug) {
    final conc = drug.standardConcentrationMgPerMl;
    if (conc == null || conc <= 0) return null;
    return doseMg / conc;
  }

  // ──────────────────────────────────────────────────────────
  //  2. BOLUS — mcg/kg, mg/kg → dose absolue (mg) + volume (ml)
  // ──────────────────────────────────────────────────────────

  /// Calcule la dose de bolus (en mg) pour un patient de [weightKg], à
  /// partir de la [DoseRange] bolus du médicament. Retourne un intervalle
  /// [min, max] car [Drug.bolus] est lui-même exprimé en intervalle.
  ///
  /// Applique automatiquement le plafond [DoseRange.maxAbsoluteDose] si
  /// renseigné (ex : morphine 10 mg, tramadol 100 mg) et le signale dans
  /// [DoseCalculationResult.exceedsMaxAbsoluteDose].
  static (DoseCalculationResult min, DoseCalculationResult max) calculateBolusRange(
    Drug drug,
    double weightKg, {
    bool pediatric = false,
  }) {
    final range = pediatric ? (drug.pediatricBolus ?? drug.bolus) : drug.bolus;
    final maxAbs = pediatric
        ? (drug.pediatricMaxAbsoluteDose ?? range.maxAbsoluteDose)
        : range.maxAbsoluteDose;

    double rawMin = _perWeightToAbsoluteMg(range.min, range.unit, weightKg);
    double rawMax = _perWeightToAbsoluteMg(range.max, range.unit, weightKg);

    bool minExceeds = maxAbs != null && rawMin > maxAbs;
    bool maxExceeds = maxAbs != null && rawMax > maxAbs;

    double finalMin = minExceeds ? maxAbs! : rawMin;
    double finalMax = maxExceeds ? maxAbs! : rawMax;

    return (
      DoseCalculationResult(
        value: finalMin,
        unitLabel: 'mg',
        exceedsMaxAbsoluteDose: minExceeds,
        warning: minExceeds
            ? 'Dose pondérale théorique (${rawMin.toStringAsFixed(2)} mg) plafonnée à ${maxAbs!.toStringAsFixed(2)} mg (maxAbsoluteDose)'
            : null,
      ),
      DoseCalculationResult(
        value: finalMax,
        unitLabel: 'mg',
        exceedsMaxAbsoluteDose: maxExceeds,
        warning: maxExceeds
            ? 'Dose pondérale théorique (${rawMax.toStringAsFixed(2)} mg) plafonnée à ${maxAbs!.toStringAsFixed(2)} mg (maxAbsoluteDose)'
            : null,
      ),
    );
  }

  /// Volume à injecter (ml) pour une dose bolus donnée, selon la
  /// concentration standard. Retourne null si non calculable (voir
  /// [mgToMl]) — dans ce cas, afficher le texte de [Drug.preparation]
  /// plutôt qu'un chiffre non fiable.
  static double? calculateBolusVolumeMl(Drug drug, double doseMg) =>
      mgToMl(doseMg, drug);

  // ──────────────────────────────────────────────────────────
  //  3. PERFUSION CONTINUE — mcg/kg/min, mg/kg/h, mcg/kg/h → ml/h
  // ──────────────────────────────────────────────────────────

  /// Débit de perfusion (ml/h) pour un patient de [weightKg], une dose
  /// cible exprimée dans l'unité native du médicament ([doseValue] dans
  /// l'unité de [drug.infusion.unit]), et la concentration standard de la
  /// poche/seringue préparée.
  static double? calculateInfusionRateMlPerH({
    required Drug drug,
    required double weightKg,
    required double doseValue, // valeur choisie dans l'intervalle infusion.min–max
  }) {
    final conc = drug.standardConcentrationMgPerMl;
    if (conc == null || conc <= 0) return null;

    final doseMgPerH = _perWeightRateToMgPerHour(doseValue, drug.infusion.unit, weightKg);
    return doseMgPerH / conc;
  }

  /// Intervalle de débit (ml/h) correspondant à [Drug.infusion] (min→max).
  static (double? minMlH, double? maxMlH) calculateInfusionRateRangeMlPerH(
    Drug drug,
    double weightKg,
  ) {
    final minMlH = calculateInfusionRateMlPerH(
        drug: drug, weightKg: weightKg, doseValue: drug.infusion.min);
    final maxMlH = calculateInfusionRateMlPerH(
        drug: drug, weightKg: weightKg, doseValue: drug.infusion.max);
    return (minMlH, maxMlH);
  }

  // ──────────────────────────────────────────────────────────
  //  4. PCA — bolus, verrouillage, plafond horaire
  // ──────────────────────────────────────────────────────────

  /// Vérifie la cohérence d'une prescription PCA vis-à-vis du protocole
  /// de référence embarqué dans [OpioidProfile.pca], si disponible.
  /// Retourne une liste d'avertissements (vide si tout est cohérent).
  static List<String> checkPcaConsistency({
    required Drug drug,
    required double proposedBolusMg,
    required int proposedLockoutMinutes,
    double? proposedMaxHourlyMg,
  }) {
    final pca = drug.opioidProfile?.pca;
    if (pca == null) {
      return [
        "Aucun protocole PCA de référence n'est renseigné pour ${drug.name} "
            "dans ce module — vérifier le protocole local avant de valider une PCA."
      ];
    }
    final warnings = <String>[];

    if (proposedBolusMg > pca.bolusDoseMg * 1.5) {
      warnings.add(
          'Bolus proposé (${proposedBolusMg.toStringAsFixed(2)} mg) nettement supérieur à la référence habituelle (~${pca.bolusDoseMg} mg) — vérifier.');
    }
    if (proposedLockoutMinutes < pca.lockoutMinutes - 2) {
      warnings.add(
          'Période de verrouillage proposée (${proposedLockoutMinutes} min) plus courte que la référence habituelle (~${pca.lockoutMinutes} min) — vérifier le risque de surdosage.');
    }
    if (pca.doseMaxHoraireMg != null &&
        proposedMaxHourlyMg != null &&
        proposedMaxHourlyMg > pca.doseMaxHoraireMg!) {
      warnings.add(
          'Plafond horaire proposé (${proposedMaxHourlyMg.toStringAsFixed(2)} mg/h) supérieur à la référence habituelle (~${pca.doseMaxHoraireMg} mg/h) — vérifier.');
    }
    return warnings;
  }

  // ──────────────────────────────────────────────────────────
  //  5. DOSE PÉDIATRIQUE
  // ──────────────────────────────────────────────────────────

  /// Calcule la dose pédiatrique (mg) pour un [weightKg] donné. Retourne
  /// null explicitement (plutôt qu'une valeur inventée) si aucune donnée
  /// pédiatrique n'est renseignée pour ce médicament — c'est le cas
  /// volontaire de plusieurs molécules de ce module (alfentanil,
  /// méthadone, péthidine, tapentadol, tilidine, buprénorphine...) : voir
  /// [Drug.pediatricNotes] pour la justification clinique de cette absence.
  static DoseCalculationResult? calculatePediatricBolusMg(Drug drug, double weightKg) {
    final range = drug.pediatricBolus;
    if (range == null) return null;
    final maxAbs = drug.pediatricMaxAbsoluteDose ?? range.maxAbsoluteDose;
    final raw = _perWeightToAbsoluteMg(range.max, range.unit, weightKg);
    final exceeds = maxAbs != null && raw > maxAbs;
    return DoseCalculationResult(
      value: exceeds ? maxAbs! : raw,
      unitLabel: 'mg',
      exceedsMaxAbsoluteDose: exceeds,
      warning: exceeds
          ? 'Dose pondérale théorique (${raw.toStringAsFixed(2)} mg) plafonnée à ${maxAbs!.toStringAsFixed(2)} mg'
          : null,
    );
  }

  // ──────────────────────────────────────────────────────────
  //  6. ÉQUIVALENCE MORPHINIQUE (ROTATION D'OPIOÏDES)
  // ──────────────────────────────────────────────────────────

  /// Convertit une dose orale de [drug] en équivalent morphine orale
  /// (OME). Retourne null si [OpioidProfile.facteurOMEVsMorphineOrale]
  /// n'est pas renseigné — c'est un choix volontaire pour la méthadone
  /// (conversion non-linéaire) et les antagonistes (non applicable).
  ///
  /// ⚠️ Ce calcul est un ORDRE DE GRANDEUR bibliographique. Toute rotation
  /// d'opioïde réelle chez un patient doit être validée par un avis
  /// spécialisé (algologie/pharmacologie clinique), avec réduction de dose
  /// de sécurité (typiquement -25 à -50%) pour tenir compte de la
  /// tolérance croisée incomplète — ce module NE PRATIQUE PAS cette
  /// réduction automatiquement, elle reste de la responsabilité du
  /// prescripteur.
  static double? convertToOralMorphineEquivalent(Drug drug, double doseMgPO) {
    final factor = drug.opioidProfile?.facteurOMEVsMorphineOrale;
    if (factor == null) return null;
    return doseMgPO * factor;
  }

  // ──────────────────────────────────────────────────────────
  //  Helpers internes
  // ──────────────────────────────────────────────────────────

  static double _perWeightToAbsoluteMg(double value, DoseUnit unit, double weightKg) {
    switch (unit) {
      case DoseUnit.mgPerKg:
        return value * weightKg;
      case DoseUnit.mcgPerKg:
        return mcgToMg(value * weightKg);
      case DoseUnit.unitsFixed:
        return value; // déjà une dose absolue
      default:
        // Unités de débit (mgPerKgH, mcgPerKgMin, mcgPerKgH, mlPerKgH, mlPerKg)
        // ne représentent pas un bolus ponctuel — cas d'usage incorrect.
        throw ArgumentError(
            'Unité $unit non convertible en dose bolus absolue — utiliser calculateInfusionRateMlPerH pour les débits.');
    }
  }

  static double _perWeightRateToMgPerHour(double value, DoseUnit unit, double weightKg) {
    switch (unit) {
      case DoseUnit.mgPerKgH:
        return value * weightKg;
      case DoseUnit.mcgPerKgH:
        return mcgToMg(value * weightKg);
      case DoseUnit.mcgPerKgMin:
        return mcgToMg(value * weightKg * 60.0);
      default:
        throw ArgumentError(
            'Unité $unit non convertible en débit mg/h — vérifier Drug.infusion.unit.');
    }
  }
}
