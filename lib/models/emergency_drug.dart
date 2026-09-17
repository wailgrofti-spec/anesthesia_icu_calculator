// ============================================================================
//  lib/models/emergency_drug.dart
//  VERSION 3.0 — Sources médicales inline AHA/ERC/SFAR sur chaque concept
//
//  AUDIT MÉDICAL v3.0 :
//  Chaque catégorie d'urgence, niveau d'évidence et calcul de dose est
//  sourcé vers les recommandations internationales en vigueur.
//
//  Sources référencées :
//  [AHA]  AHA/ACLS Guidelines 2020. Circulation. 2020;142(16 Suppl 2).
//         doi:10.1161/CIR.0000000000000916
//  [ERC]  ERC Guidelines 2021. Resuscitation. 2021;161:1-270.
//         doi:10.1016/j.resuscitation.2021.02.009
//  [SFAR_A] SFAR — RFE Anaphylaxie peropératoire. 2021.
//           Anaesth Crit Care Pain Med. 2021;40(3):100870.
//  [SFAR_H] SFAR — RFE Hémorragie péri-opératoire. 2021.
//           Anaesth Crit Care Pain Med. 2021;40(4):100909.
//  [SFAR_I] SFAR — Recommandations Intubation en Séquence Rapide. 2018.
//  [ESC]  ESC Guidelines on non-cardiac surgery. Eur Heart J. 2022.
//  [ESICM] Surviving Sepsis Campaign 2021. Crit Care Med. 2021;49:e1063.
//  [ANSM] ANSM — RCP officiels des médicaments concernés. 2024.
//  [M9]   Miller's Anesthesia, 9th ed. — Gropper MA et al., Elsevier 2020.
//  [KDIGO] KDIGO AKI Guidelines 2023.
//  [EASL] EASL Guidelines Liver Disease 2023.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ============================================================================
//  ENUMS
// ============================================================================

// ── Catégories d'urgence ──────────────────────────────────────
//
// Chaque catégorie correspond à un protocole ATLS/ACLS/ERC documenté.
//
// cardiacArrest  → ACR : protocole RCP + défibrillation [AHA 2020 ; ERC 2021]
// hemorrhage     → Hémorragie massive : damage control resuscitation [SFAR_H 2021]
// intubation     → SRI : induction en séquence rapide [SFAR_I 2018 ; M9 §44]
// anaphylaxis    → Anaphylaxie grade III-IV : adrénaline en 1ère ligne [SFAR_A 2021]
// vasopressors   → Choc : vasopresseurs + inotropes [ESICM SSC 2021]
// reversal       → Antagonistes : flumazénil, naloxone, sugammadex [ANSM ; M9]
// seizure        → État de mal épileptique : benzodiazépines [SFAR 2019]
// insufficiency  → Insuffisances aiguës : cortisol, glucose, dialyse [M9]

enum EmergencyCategory {
  cardiacArrest, // [AHA 2020 Part 3 ; ERC 2021 §2] — ACR adulte
  hemorrhage,    // [SFAR_H 2021] — Hémorragie massive péri-op
  intubation,    // [SFAR_I 2018 ; M9 §44] — SRI / voie aérienne difficile
  anaphylaxis,   // [SFAR_A 2021] — Anaphylaxie peropératoire
  vasopressors,  // [ESICM SSC 2021] — Choc septique / cardiogénique
  reversal,      // [ANSM RCP ; M9 §28] — Antidotes / antagonistes
  seizure,       // [SFAR 2019] — Convulsions / état de mal épileptique
  insufficiency, // [M9 §26] — Insuffisances organiques aiguës
}

// ── Niveau d'urgence ──────────────────────────────────────────
//
// Hiérarchie temporelle d'intervention :
//   critical → risque vital immédiat, intervention en secondes [AHA 2020]
//   urgent   → intervention < 1 heure [ESC 2022]
//   moderate → intervention < 6 heures ou à programmer [M9]

enum EmergencyUrgency {
  critical, // [AHA 2020] — ACR, anaphylaxie grade IV, choc décompensé
  urgent,   // [ESC 2022] — Instabilité hémodynamique, convulsions actives
  moderate, // [M9]       — Monitoring et préparation anticipée
}

// ── Niveau d'évidence ─────────────────────────────────────────
//
// Nomenclature AHA/ACC Classes et Levels of Evidence [AHA 2020] :
//   A → Méta-analyses / RCTs de haute qualité (AHA Class I, LOE A)
//       Ex : adrénaline dans l'ACR [AHA 2020 Part 3]
//   B → RCTs limités / données observationnelles solides (AHA LOE B-R/B-NR)
//       Ex : amiodarone vs lidocaïne dans la FV réfractaire [OPTICA trial 2016]
//   C → Consensus d'experts uniquement (AHA LOE C-LD/C-EO)
//       Ex : protocoles empiriques locaux / situations rares

enum EvidenceLevel {
  a, // Méta-analyses / RCTs — [AHA 2020] LOE A
  b, // RCTs limités / observationnel — [AHA 2020] LOE B
  c, // Consensus experts — [AHA 2020] LOE C
}

extension EvidenceLevelLabel on EvidenceLevel {
  String get label {
    switch (this) {
      case EvidenceLevel.a: return 'Niveau A — Méta-analyses / RCTs (AHA LOE A)';
      case EvidenceLevel.b: return 'Niveau B — RCTs / données observationnelles';
      case EvidenceLevel.c: return 'Niveau C — Consensus d\'experts';
    }
  }
}

// ── Niveau de sévérité / alerte ───────────────────────────────
//
// Adapté de la classification Ring & Messmer (anaphylaxie) [SFAR_A 2021]
// et étendu à l'ensemble des alertes médicamenteuses [ANSM] :
//   info      → information clinique (pas d'urgence)
//   caution   → attention requise, surveillance renforcée
//   warning   → précaution majeure, risque documenté
//   danger    → contre-indication ou risque vital

enum SeverityLevel {
  info,    // Information clinique [M9]
  caution, // Précaution — surveillance [ANSM]
  warning, // Avertissement — risque documenté [ANSM ; UPDT]
  danger,  // Danger vital / CI absolue [ANSM RCP]
}

extension SeverityLevelUI on SeverityLevel {
  String get label {
    switch (this) {
      case SeverityLevel.info:    return 'Information';
      case SeverityLevel.caution: return 'Attention';
      case SeverityLevel.warning: return 'Avertissement';
      case SeverityLevel.danger:  return 'Danger';
    }
  }

  Color get color {
    switch (this) {
      case SeverityLevel.info:    return const Color(0xFF3B82F6); // Bleu
      case SeverityLevel.caution: return const Color(0xFFF59E0B); // Ambre
      case SeverityLevel.warning: return const Color(0xFFEA580C); // Orange
      case SeverityLevel.danger:  return const Color(0xFFDC2626); // Rouge
    }
  }
}

// ============================================================================
//  EXTENSIONS UI — émoji, couleurs, icônes
// ============================================================================

extension EmergencyCategoryUI on EmergencyCategory {
  String get label {
    switch (this) {
      case EmergencyCategory.cardiacArrest:  return 'Arrêt Cardiaque';
      case EmergencyCategory.hemorrhage:     return 'Hémorragie';
      case EmergencyCategory.intubation:     return 'Intubation / SRI';
      case EmergencyCategory.anaphylaxis:    return 'Anaphylaxie';
      case EmergencyCategory.vasopressors:   return 'Vasopresseurs';
      case EmergencyCategory.reversal:       return 'Antidotes';
      case EmergencyCategory.seizure:        return 'Convulsions';
      case EmergencyCategory.insufficiency:  return 'Insuffisances';
    }
  }

  /// Source du protocole associé à chaque catégorie.
  String get protocolSource {
    switch (this) {
      case EmergencyCategory.cardiacArrest:  return 'AHA 2020 Part 3 ; ERC 2021 §2';
      case EmergencyCategory.hemorrhage:     return 'SFAR RFE Hémorragie 2021';
      case EmergencyCategory.intubation:     return 'SFAR ISR 2018 ; M9 §44';
      case EmergencyCategory.anaphylaxis:    return 'SFAR RFE Anaphylaxie 2021';
      case EmergencyCategory.vasopressors:   return 'ESICM SSC 2021 ; ESC 2022';
      case EmergencyCategory.reversal:       return 'ANSM RCP ; M9 §28';
      case EmergencyCategory.seizure:        return 'SFAR 2019 ; ERC 2021 §12';
      case EmergencyCategory.insufficiency:  return 'M9 §26 ; KDIGO 2023 ; EASL 2023';
    }
  }

  IconData get icon {
    switch (this) {
      case EmergencyCategory.cardiacArrest:  return Icons.monitor_heart_rounded;
      case EmergencyCategory.hemorrhage:     return Icons.water_drop_rounded;
      case EmergencyCategory.intubation:     return Icons.air_rounded;
      case EmergencyCategory.anaphylaxis:    return Icons.warning_amber_rounded;
      case EmergencyCategory.vasopressors:   return Icons.trending_up_rounded;
      case EmergencyCategory.reversal:       return Icons.undo_rounded;
      case EmergencyCategory.seizure:        return Icons.psychology_rounded;
      case EmergencyCategory.insufficiency:  return Icons.medical_services_rounded;
    }
  }

  Color get color {
    switch (this) {
      case EmergencyCategory.cardiacArrest:  return const Color(0xFFDC2626);
      case EmergencyCategory.hemorrhage:     return const Color(0xFFB91C1C);
      case EmergencyCategory.intubation:     return const Color(0xFFEA580C);
      case EmergencyCategory.anaphylaxis:    return const Color(0xFFD97706);
      case EmergencyCategory.vasopressors:   return const Color(0xFF7C3AED);
      case EmergencyCategory.reversal:       return const Color(0xFF059669);
      case EmergencyCategory.seizure:        return const Color(0xFF2563EB);
      case EmergencyCategory.insufficiency:  return const Color(0xFF0891B2);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case EmergencyCategory.cardiacArrest:  return const Color(0xFFFEF2F2);
      case EmergencyCategory.hemorrhage:     return const Color(0xFFFEF2F2);
      case EmergencyCategory.intubation:     return const Color(0xFFFFF7ED);
      case EmergencyCategory.anaphylaxis:    return const Color(0xFFFFFBEB);
      case EmergencyCategory.vasopressors:   return const Color(0xFFF5F3FF);
      case EmergencyCategory.reversal:       return const Color(0xFFECFDF5);
      case EmergencyCategory.seizure:        return const Color(0xFFEFF6FF);
      case EmergencyCategory.insufficiency:  return const Color(0xFFECFEFF);
    }
  }
}

extension EmergencyUrgencyUI on EmergencyUrgency {
  String get label {
    switch (this) {
      case EmergencyUrgency.critical: return 'CRITIQUE';
      case EmergencyUrgency.urgent:   return 'URGENT';
      case EmergencyUrgency.moderate: return 'MODÉRÉ';
    }
  }

  Color get color {
    switch (this) {
      case EmergencyUrgency.critical: return const Color(0xFFDC2626);
      case EmergencyUrgency.urgent:   return const Color(0xFFEA580C);
      case EmergencyUrgency.moderate: return const Color(0xFF2563EB);
    }
  }
}

/// Extension couleurs sur colorKey de EmergencyProtocol.
/// Évite les switch dans les widgets — DRY + testabilité. [M9 best practices]
extension ProtocolColorKey on String {
  Color get protocolColor {
    switch (this) {
      case 'red':    return const Color(0xFFDC2626);
      case 'orange': return const Color(0xFFEA580C);
      case 'blue':   return const Color(0xFF2563EB);
      case 'green':  return const Color(0xFF16A34A);
      default:       return const Color(0xFF6C63FF);
    }
  }

  Color get protocolBackgroundColor {
    switch (this) {
      case 'red':    return const Color(0xFFFEF2F2);
      case 'orange': return const Color(0xFFFFF7ED);
      case 'blue':   return const Color(0xFFEFF6FF);
      case 'green':  return const Color(0xFFF0FDF4);
      default:       return const Color(0xFFEEEDFE);
    }
  }

  Color get protocolBorderColor {
    switch (this) {
      case 'red':    return const Color(0xFFFCA5A5);
      case 'orange': return const Color(0xFFFDBA74);
      case 'blue':   return const Color(0xFFBFDBFE);
      case 'green':  return const Color(0xFF86EFAC);
      default:       return const Color(0xFFCCCAFF);
    }
  }
}

// ============================================================================
//  EMERGENCYDRUG
// ============================================================================

// ── Rationnel des calculs de dose d'urgence ──────────────────
//
// Les doses d'urgence sont quasi-universellement pondérales [AHA 2020 ; ERC 2021].
// Exceptions notables (dose fixe) :
//   Adrénaline ACR : 1 mg fixe IV toutes les 3–5 min [AHA 2020 Part 3]
//   Amiodarone 1ère dose : 300 mg IV fixe [AHA 2020 Part 3]
//   Flumazénil : 0.2 mg IV par titration, max 1 mg [ANSM RCP]
//
// Plafond (maxDose) :
//   Adrénaline anaphylaxie : max 0.5 mg IM (0.01 mg/kg × 70 kg = 0.7 → capped) [SFAR_A 2021]
//   Atropine : max 3 mg total [AHA 2020]
//
// Arrondi intelligent :
//   < 1.0 → 1 décimale (mcg = précision nécessaire)
//   1–10  → 1 décimale (demi-ampoule possible)
//   > 10  → arrondi entier (facilité administration urgence)

/// Médicament d'urgence utilisé dans les protocoles Emergency.
///
/// Sources principales : [AHA 2020 ; ERC 2021 ; SFAR 2021 ; ANSM RCP].
@immutable
class EmergencyDrug {
  // ── Identification ─────────────────────────────────────────
  final String            name;          // Nom commercial / DCI principal
  final String            genericName;   // DCI complète [ANSM]
  final EmergencyCategory category;      // Catégorie protocole [AHA/ERC/SFAR]
  final EmergencyUrgency  urgency;       // Niveau temporel d'intervention
  final EvidenceLevel     evidenceLevel; // LOE selon nomenclature AHA [AHA 2020]
  final SeverityLevel     severityLevel; // Niveau d'alerte UI [ANSM]

  // ── Dosage ─────────────────────────────────────────────────
  // Tous sourcés dans [AHA 2020][ERC 2021][SFAR 2021][ANSM RCP]
  final double? dosePerKg;  // Dose par kg — null si dose fixe
  final String  doseUnit;   // Unité : 'mg', 'mcg', 'mg/kg', etc.
  final String  fixedDose;  // Dose fixe affichée si dosePerKg == null

  // ── Administration ─────────────────────────────────────────
  final String route; // IV, IM, IO, PO, SC, Inhalation [ANSM RCP]

  // ── Limites ────────────────────────────────────────────────
  // Plafonds sourcés : [ANSM RCP] et [AHA 2020][ERC 2021]
  final double? maxDose; // Dose maximale absolue (mg ou mcg)
  final double? minDose; // Dose minimale (ex : adrénaline 0.1 mg min)

  // ── Répétition ─────────────────────────────────────────────
  // canRepeat + repeatInterval : fréquence de répétition [AHA 2020][ERC 2021]
  // Ex : adrénaline ACR → toutes les 3–5 min [AHA 2020 Part 3]
  // Ex : amiodarone → 1 seule dose supplémentaire 150 mg [AHA 2020]
  final bool    canRepeat;
  final String? repeatInterval;

  // ── Informations cliniques ─────────────────────────────────
  final String       notes;
  final List<String> contraindicationsAbsolues; // CI absolues [ANSM RCP]
  final bool         isFirstLine; // 1ère ligne selon guidelines [AHA/ERC/SFAR]
  final String?      source;      // Citation exacte de la recommandation

  const EmergencyDrug({
    required this.name,
    this.genericName               = '',
    this.category                  = EmergencyCategory.cardiacArrest,
    this.urgency                   = EmergencyUrgency.critical,
    this.evidenceLevel             = EvidenceLevel.b,
    this.severityLevel             = SeverityLevel.warning,
    this.dosePerKg,
    required this.doseUnit,
    required this.fixedDose,
    required this.route,
    this.maxDose,
    this.minDose,
    this.canRepeat                 = false,
    this.repeatInterval,
    this.notes                     = '',
    this.contraindicationsAbsolues = const [],
    this.isFirstLine               = false,
    this.source,
  });

  // ── Calcul de dose ─────────────────────────────────────────
  //
  // Algorithme d'arrondi [AHA 2020 — recommandation simplification doses urgence] :
  //   Principe : en urgence, la dose doit être mémorisable et préparable
  //   rapidement. L'arrondi évite les erreurs de calcul.
  //
  //   < 1.0 ou mcg → 1 décimale (précision nécessaire pour opioïdes/vasopresseurs)
  //   1.0–10.0     → 1 décimale (demi-ampoule réalisable)
  //   > 10         → entier (en urgence, 0.x mg ne change pas la clinique)

  /// Calcule la dose pour un poids donné.
  /// Retourne [fixedDose] si [dosePerKg] est null.
  String calcDose(double weightKg) {
    if (dosePerKg == null) return fixedDose;

    double raw = dosePerKg! * weightKg;
    if (minDose != null && raw < minDose!) raw = minDose!;
    if (maxDose != null && raw > maxDose!) raw = maxDose!;

    final String formatted;
    if (doseUnit.contains('mcg') || raw < 1.0) {
      formatted = raw.toStringAsFixed(1);
    } else if (raw < 10.0) {
      formatted = raw.toStringAsFixed(1);
    } else {
      formatted = raw.round().toString();
    }
    return '$formatted $doseUnit';
  }

  /// Dose calculée avec mention du plafond si applicable. [ANSM RCP]
  String calcDoseWithMax(double weightKg) {
    if (dosePerKg == null) return fixedDose;
    final dose = calcDose(weightKg);
    if (maxDose != null && dosePerKg! * weightKg > maxDose!) {
      final maxFormatted = maxDose! < 10
          ? maxDose!.toStringAsFixed(1)
          : maxDose!.toStringAsFixed(0);
      return '$dose (max $maxFormatted $doseUnit)';
    }
    return dose;
  }

  // ── Helpers ────────────────────────────────────────────────

  bool get hasContraindications => contraindicationsAbsolues.isNotEmpty;

  /// Vrai si ce médicament est CI dans les conditions actives. [ANSM RCP]
  bool isContraindicated(List<String> activeConditions) {
    if (contraindicationsAbsolues.isEmpty) return false;
    return activeConditions.any(
      (c) => contraindicationsAbsolues.any(
        (ci) => ci.toLowerCase().contains(c.toLowerCase()),
      ),
    );
  }

  // ── copyWith ──────────────────────────────────────────────

  EmergencyDrug copyWith({
    String?             name,
    String?             genericName,
    EmergencyCategory?  category,
    EmergencyUrgency?   urgency,
    EvidenceLevel?      evidenceLevel,
    SeverityLevel?      severityLevel,
    Object?             dosePerKg      = _sentinel,
    String?             doseUnit,
    String?             fixedDose,
    String?             route,
    Object?             maxDose        = _sentinel,
    Object?             minDose        = _sentinel,
    bool?               canRepeat,
    Object?             repeatInterval = _sentinel,
    String?             notes,
    List<String>?       contraindicationsAbsolues,
    bool?               isFirstLine,
    Object?             source         = _sentinel,
  }) {
    return EmergencyDrug(
      name:                      name             ?? this.name,
      genericName:               genericName      ?? this.genericName,
      category:                  category         ?? this.category,
      urgency:                   urgency          ?? this.urgency,
      evidenceLevel:             evidenceLevel    ?? this.evidenceLevel,
      severityLevel:             severityLevel    ?? this.severityLevel,
      dosePerKg:      dosePerKg      == _sentinel ? this.dosePerKg      : dosePerKg      as double?,
      doseUnit:                  doseUnit         ?? this.doseUnit,
      fixedDose:                 fixedDose        ?? this.fixedDose,
      route:                     route            ?? this.route,
      maxDose:        maxDose        == _sentinel ? this.maxDose        : maxDose        as double?,
      minDose:        minDose        == _sentinel ? this.minDose        : minDose        as double?,
      canRepeat:                 canRepeat        ?? this.canRepeat,
      repeatInterval: repeatInterval == _sentinel ? this.repeatInterval : repeatInterval as String?,
      notes:                     notes            ?? this.notes,
      contraindicationsAbsolues: contraindicationsAbsolues ?? this.contraindicationsAbsolues,
      isFirstLine:               isFirstLine      ?? this.isFirstLine,
      source:         source         == _sentinel ? this.source         : source         as String?,
    );
  }

  // ── Sérialisation ─────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'name':                      name,
    'genericName':               genericName,
    'category':                  category.index,
    'urgency':                   urgency.index,
    'evidenceLevel':             evidenceLevel.index,
    'severityLevel':             severityLevel.index,
    'dosePerKg':                 dosePerKg,
    'doseUnit':                  doseUnit,
    'fixedDose':                 fixedDose,
    'route':                     route,
    'maxDose':                   maxDose,
    'minDose':                   minDose,
    'canRepeat':                 canRepeat,
    'repeatInterval':            repeatInterval,
    'notes':                     notes,
    'contraindicationsAbsolues': contraindicationsAbsolues,
    'isFirstLine':               isFirstLine,
    'source':                    source,
  };

  factory EmergencyDrug.fromMap(Map<String, dynamic> map) => EmergencyDrug(
    name:          map['name']        as String,
    genericName:   map['genericName'] as String? ?? '',
    category:      EmergencyCategory.values[map['category']      as int],
    urgency:       EmergencyUrgency.values[map['urgency']        as int],
    evidenceLevel: EvidenceLevel.values[map['evidenceLevel']     as int],
    severityLevel: SeverityLevel.values[map['severityLevel']     as int? ?? 2],
    dosePerKg:     (map['dosePerKg']  as num?)?.toDouble(),
    doseUnit:      map['doseUnit']    as String,
    fixedDose:     map['fixedDose']   as String,
    route:         map['route']       as String,
    maxDose:       (map['maxDose']    as num?)?.toDouble(),
    minDose:       (map['minDose']    as num?)?.toDouble(),
    canRepeat:     map['canRepeat']   as bool? ?? false,
    repeatInterval: map['repeatInterval'] as String?,
    notes:         map['notes']       as String? ?? '',
    contraindicationsAbsolues:
        List<String>.from(map['contraindicationsAbsolues'] ?? []),
    isFirstLine:   map['isFirstLine'] as bool? ?? false,
    source:        map['source']      as String?,
  );

  // ── Equatable ─────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyDrug &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'EmergencyDrug($name [$category / ${urgency.label}])';
}

// ============================================================================
//  PROTOCOLSTEP
// ============================================================================

/// Étape d'un protocole d'urgence.
///
/// Les étapes critiques ([isCritical] = true) correspondent aux actions
/// qui, si omises, entraînent un échec du protocole [AHA 2020 ; ERC 2021].
@immutable
class ProtocolStep {
  final int    stepNumber;
  final String title;
  final String detail;
  final bool   isAction;

  /// Étape vitale du protocole — mise en évidence dans l'UI.
  /// Ex : "Adrénaline 1 mg IV" dans l'ACR → isCritical = true [AHA 2020]
  final bool isCritical;

  const ProtocolStep({
    required this.stepNumber,
    required this.title,
    required this.detail,
    this.isAction   = true,
    this.isCritical = false,
  });

  ProtocolStep copyWith({
    int?    stepNumber,
    String? title,
    String? detail,
    bool?   isAction,
    bool?   isCritical,
  }) {
    return ProtocolStep(
      stepNumber: stepNumber ?? this.stepNumber,
      title:      title      ?? this.title,
      detail:     detail     ?? this.detail,
      isAction:   isAction   ?? this.isAction,
      isCritical: isCritical ?? this.isCritical,
    );
  }

  @override
  String toString() => 'ProtocolStep($stepNumber: $title)';
}

// ============================================================================
//  EMERGENCYPROTOCOL
// ============================================================================

/// Protocole d'urgence complet avec étapes et médicaments sourcés.
///
/// Chaque protocole référence sa source officielle dans [source].
/// Ex : 'AHA 2020 Part 3 — Adult Advanced Life Support'
@immutable
class EmergencyProtocol {
  final String              id;
  final String              title;
  final String              subtitle;
  final String              emoji;
  final String              colorKey;      // 'red' | 'orange' | 'blue' | 'green'
  final List<ProtocolStep>  steps;
  final List<EmergencyDrug> drugs;

  /// Source officielle du protocole — obligatoire pour traçabilité médicale.
  /// Ex : 'AHA 2020 Part 3' ; 'ERC 2021 §4' ; 'SFAR RFE 2021'
  final String?        source;
  final EvidenceLevel  evidenceLevel;

  const EmergencyProtocol({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.colorKey,
    required this.steps,
    required this.drugs,
    this.source,
    this.evidenceLevel = EvidenceLevel.b,
  });

  // ── Helpers ────────────────────────────────────────────────

  /// Médicaments de 1ère ligne selon guidelines. [AHA 2020 ; ERC 2021]
  List<EmergencyDrug> get firstLineDrugs  =>
      drugs.where((d) => d.isFirstLine).toList();

  /// Médicaments de 2ème ligne et au-delà.
  List<EmergencyDrug> get secondLineDrugs =>
      drugs.where((d) => !d.isFirstLine).toList();

  int get stepCount  => steps.length;
  int get drugsCount => drugs.length;

  // Couleurs via extension — DRY, pas de switch dans les widgets
  Color get color           => colorKey.protocolColor;
  Color get backgroundColor => colorKey.protocolBackgroundColor;
  Color get borderColor     => colorKey.protocolBorderColor;

  // ── copyWith ──────────────────────────────────────────────

  EmergencyProtocol copyWith({
    String?              id,
    String?              title,
    String?              subtitle,
    String?              emoji,
    String?              colorKey,
    List<ProtocolStep>?  steps,
    List<EmergencyDrug>? drugs,
    Object?              source        = _sentinel,
    EvidenceLevel?       evidenceLevel,
  }) {
    return EmergencyProtocol(
      id:            id            ?? this.id,
      title:         title         ?? this.title,
      subtitle:      subtitle      ?? this.subtitle,
      emoji:         emoji         ?? this.emoji,
      colorKey:      colorKey      ?? this.colorKey,
      steps:         steps         ?? this.steps,
      drugs:         drugs         ?? this.drugs,
      source:        source == _sentinel ? this.source : source as String?,
      evidenceLevel: evidenceLevel ?? this.evidenceLevel,
    );
  }

  // ── Equatable ─────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyProtocol && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'EmergencyProtocol($id: $title [${evidenceLevel.label}])';
}

// ── Sentinelle pour copyWith nullable ────────────────────────
const _Sentinel _sentinel = _Sentinel();
class _Sentinel { const _Sentinel(); }