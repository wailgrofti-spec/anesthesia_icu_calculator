// ============================================================================
//  lib/services/pediatric_validation_service.dart
//  Validation intelligente des données patient — pédiatrie ET adulte.
//
//  Principe général : on renvoie un niveau (normal / warning / danger) +
//  un message clair, à afficher dans l'UI.
//  - normal / warning  → l'app affiche une alerte mais continue d'utiliser
//    la saisie (c'est au clinicien de juger).
//  - danger            → la valeur est physiologiquement impossible pour
//    l'âge déclaré (ex : 20 cm / 1 kg à 1 an, ou 1 kg chez un adulte).
//    Dans ce cas, les écrans appelants (patient_screen, respiratory_screen)
//    DOIVENT bloquer l'affichage d'un résultat calculé et afficher un
//    message d'erreur à la place — voir RespiratoryParams.compute et
//    _ComputedState dans respiratory_screen.dart.
//
//  Plages physiologiques par tranche d'âge (y compris adulte) : ordres de
//  grandeur cliniques larges destinés à repérer une erreur de saisie
//  grossière (ex : 30 kg saisi pour un nouveau-né, ou 1 kg pour un adulte).
//  Ce ne sont PAS des courbes de croissance OMS précises
//  (percentiles/z-score) — voir la note en bas de fichier.
// ============================================================================

import '../models/patient.dart';

// ══════════════════════════════════════════════════════════════════════════
//  NIVEAUX DE VALIDATION
// ══════════════════════════════════════════════════════════════════════════

enum ValidationLevel { normal, warning, danger }

class ValidationResult {
  final ValidationLevel level;
  final String message;

  const ValidationResult(this.level, this.message);

  static const ValidationResult normal =
      ValidationResult(ValidationLevel.normal, 'Données physiologiquement normales.');

  bool get isNormal => level == ValidationLevel.normal;
  bool get isWarning => level == ValidationLevel.warning;
  bool get isDanger => level == ValidationLevel.danger;

  /// Emoji/pictogramme à afficher devant le message (🟢 🟡 🔴).
  String get icon {
    switch (level) {
      case ValidationLevel.normal:  return '🟢';
      case ValidationLevel.warning: return '🟡';
      case ValidationLevel.danger:  return '🔴';
    }
  }

  /// Combine ce résultat avec un autre — retient le niveau le plus sévère
  /// et concatène les messages (utile pour `validateAll`).
  ValidationResult combine(ValidationResult other) {
    if (other.level.index <= level.index) return this;
    return other;
  }
}

// ══════════════════════════════════════════════════════════════════════════
//  TRANCHES D'ÂGE PÉDIATRIQUES — bornes poids/taille
// ══════════════════════════════════════════════════════════════════════════

class _AgeBandRange {
  final String label;
  final double minWeight, maxWeight;
  final double minHeight, maxHeight;
  const _AgeBandRange({
    required this.label,
    required this.minWeight,
    required this.maxWeight,
    required this.minHeight,
    required this.maxHeight,
  });
}

const _neonate = _AgeBandRange(
  label: 'nouveau-né (0-28 jours)',
  minWeight: 1, maxWeight: 6, minHeight: 35, maxHeight: 60);

const _infant = _AgeBandRange(
  label: 'nourrisson (1-12 mois)',
  minWeight: 2, maxWeight: 15, minHeight: 45, maxHeight: 85);

const _band1to2 = _AgeBandRange(
  label: '1-2 ans',
  minWeight: 7, maxWeight: 16, minHeight: 70, maxHeight: 95);

const _band2to5 = _AgeBandRange(
  label: '2-5 ans',
  minWeight: 10, maxWeight: 25, minHeight: 80, maxHeight: 120);

const _band5to12 = _AgeBandRange(
  label: '5-12 ans',
  minWeight: 15, maxWeight: 60, minHeight: 100, maxHeight: 170);

const _band12to18 = _AgeBandRange(
  label: '12-18 ans',
  minWeight: 30, maxWeight: 120, minHeight: 130, maxHeight: 200);

/// Bornes adultes (≥ 18 ans) — permet de repérer une saisie impossible
/// (ex : "1 kg" ou "20 cm" pour un adulte) exactement comme en pédiatrie.
/// Volontairement larges (couvrent la quasi-totalité des morphologies
/// adultes réelles) : le but est de bloquer les erreurs de saisie
/// grossières, pas de juger une morphologie inhabituelle mais réelle.
const _adult = _AgeBandRange(
  label: 'adulte',
  minWeight: 30, maxWeight: 300, minHeight: 130, maxHeight: 230);

/// Détermine la tranche d'âge/morphologie applicable pour la validation
/// (pédiatrique ou adulte), ou `null` seulement si l'âge n'est pas
/// renseigné (rien à valider dans ce cas).
_AgeBandRange? _bandForPatient(Patient patient) {
  final days = patient.ageInDays;
  final months = patient.ageInMonths;
  final years = patient.ageInYears;
  if (days == null || months == null || years == null) return null;

  if (days <= 28) return _neonate;
  if (months <= 12) return _infant;
  if (years <= 2) return _band1to2;
  if (years <= 5) return _band2to5;
  if (years <= 12) return _band5to12;
  if (years <= 18) return _band12to18;
  return _adult;
}

// ══════════════════════════════════════════════════════════════════════════
//  SERVICE DE VALIDATION
// ══════════════════════════════════════════════════════════════════════════

/// Service centralisé de validation pédiatrique. Toutes les vérifications
/// de cohérence poids/taille/âge/IMC en mode pédiatrique doivent passer
/// par ce service plutôt que d'être dupliquées dans les écrans.
class PediatricValidationService {
  PediatricValidationService._();

  /// Marge de tolérance avant de passer de 🟡 (warning) à 🔴 (danger).
  /// Ex : 0.5 → jusqu'à 50 % en dehors des bornes = warning, au-delà = danger.
  static const double _warningTolerance = 0.5;

  // ── Poids ──────────────────────────────────────────────────────────────

  static ValidationResult validateWeight(Patient patient) {
    if (!patient.hasWeight || !patient.hasAge) return ValidationResult.normal;
    final band = _bandForPatient(patient);
    if (band == null) return ValidationResult.normal; // adulte : hors périmètre

    final w = patient.weight!;
    if (w >= band.minWeight && w <= band.maxWeight) {
      return ValidationResult.normal;
    }

    final toleranceLow = band.minWeight * (1 - _warningTolerance);
    final toleranceHigh = band.maxWeight * (1 + _warningTolerance);
    if (w >= toleranceLow && w <= toleranceHigh) {
      return ValidationResult(
        ValidationLevel.warning,
        '🟡 Poids inhabituel pour un ${band.label} '
        '(attendu : ${band.minWeight.toStringAsFixed(0)}–'
        '${band.maxWeight.toStringAsFixed(0)} kg). Veuillez vérifier.',
      );
    }

    return ValidationResult(
      ValidationLevel.danger,
      '🔴 Poids incompatible avec un ${band.label} '
      '(attendu : ${band.minWeight.toStringAsFixed(0)}–'
      '${band.maxWeight.toStringAsFixed(0)} kg). Les calculs peuvent être incorrects.',
    );
  }

  // ── Taille ─────────────────────────────────────────────────────────────

  static ValidationResult validateHeight(Patient patient) {
    if (!patient.hasHeight || !patient.hasAge) return ValidationResult.normal;
    final band = _bandForPatient(patient);
    if (band == null) return ValidationResult.normal;

    final h = patient.height!;
    if (h >= band.minHeight && h <= band.maxHeight) {
      return ValidationResult.normal;
    }

    final toleranceLow = band.minHeight * (1 - _warningTolerance);
    final toleranceHigh = band.maxHeight * (1 + _warningTolerance);
    if (h >= toleranceLow && h <= toleranceHigh) {
      return ValidationResult(
        ValidationLevel.warning,
        '🟡 Taille inhabituelle pour un ${band.label} '
        '(attendue : ${band.minHeight.toStringAsFixed(0)}–'
        '${band.maxHeight.toStringAsFixed(0)} cm). Veuillez vérifier.',
      );
    }

    return ValidationResult(
      ValidationLevel.danger,
      '🔴 Taille incompatible avec un ${band.label} '
      '(attendue : ${band.minHeight.toStringAsFixed(0)}–'
      '${band.maxHeight.toStringAsFixed(0)} cm). Les calculs peuvent être incorrects.',
    );
  }

  // ── Âge ────────────────────────────────────────────────────────────────

  static ValidationResult validateAge(Patient patient) {
    if (!patient.hasAge) return ValidationResult.normal;
    final v = patient.ageValue!;
    if (v < 0) {
      return const ValidationResult(
        ValidationLevel.danger, '🔴 L\'âge ne peut pas être négatif.');
    }
    final years = patient.ageInYears!;
    if (years > 120) {
      return const ValidationResult(
        ValidationLevel.danger,
        '🔴 Âge incompatible avec un être humain (> 120 ans). Vérifiez la saisie.',
      );
    }
    return ValidationResult.normal;
  }

  // ── BMI ────────────────────────────────────────────────────────────────
  //
  // Sans les tables OMS complètes (LMS), on ne peut pas produire un vrai
  // percentile/z-score fiable. On se limite donc à repérer les BMI
  // extrêmes et implausibles, sans jamais coller un label adulte
  // (Surpoids/Obésité) — voir Patient.bmiCategoryDisplay pour l'affichage.
  static ValidationResult validateBMI(Patient patient) {
    final bmi = patient.bmi;
    if (bmi == null || !patient.hasAge) return ValidationResult.normal;
    final band = _bandForPatient(patient);
    // Hors périmètre pour l'adulte : la classification adulte (surpoids,
    // obésité...) est déjà gérée par Patient.bmiCategory et va légitimement
    // au-delà de 35 kg/m² (profil "Obésité" de l'app) — pas une erreur ici.
    if (band == null || band.label == 'adulte') return ValidationResult.normal;

    // Bornes larges, indépendantes de l'âge précis — juste pour repérer
    // une valeur absurde (résultant typiquement d'une erreur de saisie
    // poids/taille), pas pour classer l'enfant.
    if (bmi < 8 || bmi > 35) {
      return ValidationResult(
        ValidationLevel.warning,
        '🟡 IMC (${bmi.toStringAsFixed(1)} kg/m²) inhabituel pour cet âge — '
        'vérifiez le poids et la taille saisis. Interprétation à faire selon '
        'une courbe IMC-pour-âge (OMS), pas selon les seuils adultes.',
      );
    }
    return ValidationResult.normal;
  }

  // ── Agrégation ─────────────────────────────────────────────────────────

  /// Combine toutes les validations en un seul résultat — retient le
  /// niveau le plus sévère. C'est ce résultat qu'il faut afficher dans la
  /// carte "Mode pédiatrique actif" de l'UI.
  static ValidationResult validateAll(Patient patient) {
    final results = [
      validateAge(patient),
      validateWeight(patient),
      validateHeight(patient),
      validateBMI(patient),
    ];

    var worst = results.first;
    for (final r in results.skip(1)) {
      worst = worst.combine(r);
    }

    if (worst.isNormal) return ValidationResult.normal;
    return worst;
  }
}

// ============================================================================
//  NOTE MÉDICALE IMPORTANTE
//
//  Les plages ci-dessus sont des ordres de grandeur cliniques larges —
//  utiles pour repérer une erreur de saisie grossière (ex : 30 kg pour un
//  nouveau-né). Elles ne remplacent PAS les courbes de croissance OMS
//  officielles (WHO Child Growth Standards 0-5 ans, WHO Growth Reference
//  5-19 ans), qui reposent sur des tables LMS complètes par mesure/âge/sexe
//  et permettent un vrai percentile/z-score. Intégrer ces tables est un
//  projet de données à part entière (fichiers volumineux, par sexe et par
//  mesure) — à envisager séparément si un percentile exact est nécessaire.
// ============================================================================
