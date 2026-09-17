// ============================================================================
//  lib/models/vitals.dart
//  VERSION 3.0 — Sources médicales inline sur chaque valeur
//
//  AUDIT MÉDICAL v3.0 :
//  Toutes les bornes physiologiques sont citées source par source.
//  Aucune valeur "magique" — chaque chiffre est traçable.
//
//  Sources référencées :
//  [M9]  Miller's Anesthesia, 9th ed. — Gropper MA et al., Elsevier 2020
//          §46 Monitoring, §53 Thermorégulation, §56 Ventilation mécanique
//  [ESC] ESC/ESA Guidelines on cardiovascular assessment &
//          management of patients undergoing non-cardiac surgery. 2022.
//          Eur Heart J. 2022;43(39):3826-3924.
//  [ERC] ERC Guidelines 2021 — Resuscitation. 2021;161:1-60.
//  [AHA] AHA/ACLS Guidelines 2020. Circulation. 2020;142(16 Suppl 2).
//  [BTS] BTS guideline for oxygen use in adults in healthcare.
//          Thorax. 2017;72(Suppl 1):ii1-ii90.
//  [ESICM] ESICM — Surviving Sepsis Campaign 2021.
//          Crit Care Med. 2021;49(11):e1063-e1143.
//  [NEJM] Asfar P et al. High versus low blood pressure targets in septic
//          shock. N Engl J Med. 2014;370(17):1583-93.
//  [NUNN] Lumb AB. Nunn's Applied Respiratory Physiology, 8th ed. 2016.
//  [SFAR] SFAR — RFE Monitorage péri-opératoire. 2017.
//          Anaesth Crit Care Pain Med. 2018;37(2):193-199.
// ============================================================================

import 'package:flutter/foundation.dart';

// ============================================================================
//  ENUMS
// ============================================================================

enum VitalStatus { normal, warning, critical, unknown }

extension VitalStatusLabel on VitalStatus {
  String get label {
    switch (this) {
      case VitalStatus.normal:   return 'Normal';
      case VitalStatus.warning:  return 'Attention';
      case VitalStatus.critical: return 'Critique';
      case VitalStatus.unknown:  return 'Non mesuré';
    }
  }
}

/// Tendance par rapport à la mesure précédente.
enum VitalTrend { improving, stable, worsening, unknown }

extension VitalTrendLabel on VitalTrend {
  String get label {
    switch (this) {
      case VitalTrend.improving: return '↑ En amélioration';
      case VitalTrend.stable:    return '→ Stable';
      case VitalTrend.worsening: return '↓ En dégradation';
      case VitalTrend.unknown:   return '? Inconnu';
    }
  }
}

// ============================================================================
//  VITALSIGN
// ============================================================================

/// Signe vital individuel avec bornes physiologiques et statut calculé.
///
/// Sources des bornes : [M9] §46, [ESC] Table 4, [SFAR] 2017.
@immutable
class VitalSign {
  final String name;
  final String abbreviation;
  final double? value;
  final String unit;
  final double normalMin;
  final double normalMax;
  final double criticalMin;
  final double criticalMax;
  final int    decimalPlaces;
  final VitalTrend trend;

  const VitalSign({
    required this.name,
    required this.abbreviation,
    required this.value,
    required this.unit,
    required this.normalMin,
    required this.normalMax,
    required this.criticalMin,
    required this.criticalMax,
    this.decimalPlaces = 0,
    this.trend = VitalTrend.unknown,
  });

  // ── Statut ────────────────────────────────────────────────

  VitalStatus get status {
    if (value == null) return VitalStatus.unknown;
    if (value! < criticalMin || value! > criticalMax) return VitalStatus.critical;
    if (value! < normalMin   || value! > normalMax)   return VitalStatus.warning;
    return VitalStatus.normal;
  }

  bool get isNormal   => status == VitalStatus.normal;
  bool get isWarning  => status == VitalStatus.warning;
  bool get isCritical => status == VitalStatus.critical;
  bool get isUnknown  => status == VitalStatus.unknown;

  // ── Affichage ─────────────────────────────────────────────

  String get normalRange {
    if (decimalPlaces == 0) {
      return '${normalMin.toInt()}–${normalMax.toInt()} $unit';
    }
    return '${normalMin.toStringAsFixed(decimalPlaces)}–'
        '${normalMax.toStringAsFixed(decimalPlaces)} $unit';
  }

  String get displayValue =>
      value == null ? '—' : value!.toStringAsFixed(decimalPlaces);

  String get displayWithUnit =>
      value == null ? '—' : '${value!.toStringAsFixed(decimalPlaces)} $unit';

  // ── copyWith ──────────────────────────────────────────────

  VitalSign copyWith({
    String?     name,
    String?     abbreviation,
    Object?     value = _sentinel,
    String?     unit,
    double?     normalMin,
    double?     normalMax,
    double?     criticalMin,
    double?     criticalMax,
    int?        decimalPlaces,
    VitalTrend? trend,
  }) {
    return VitalSign(
      name:          name          ?? this.name,
      abbreviation:  abbreviation  ?? this.abbreviation,
      value:         value == _sentinel ? this.value : value as double?,
      unit:          unit          ?? this.unit,
      normalMin:     normalMin     ?? this.normalMin,
      normalMax:     normalMax     ?? this.normalMax,
      criticalMin:   criticalMin   ?? this.criticalMin,
      criticalMax:   criticalMax   ?? this.criticalMax,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      trend:         trend         ?? this.trend,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VitalSign &&
          abbreviation == other.abbreviation &&
          value        == other.value;

  @override
  int get hashCode => Object.hash(abbreviation, value);

  @override
  String toString() => 'VitalSign($abbreviation: $displayWithUnit [$status])';
}

// ============================================================================
//  VITALS — Constantes physiologiques sourcées
// ============================================================================
//
//  TABLEAU DE RÉFÉRENCE DES BORNES (audit médical complet) :
//
//  Paramètre │ Normal      │ Critique    │ Source principale
//  ──────────┼─────────────┼─────────────┼──────────────────────────────────
//  PAS mmHg  │  90–140     │  70–180     │ ESC/ESA 2022 Table 4 ; M9 §46
//  PAD mmHg  │  60–90      │  40–120     │ ESC/ESA 2022 ; M9 §46
//  FC  bpm   │  60–100     │  40–150     │ AHA/ACLS 2020 ; M9 §46
//  SpO2 %    │  94–100     │  88–100     │ BTS 2017 ; ERC 2021
//  Temp °C   │  36.0–37.5  │  34.0–39.5  │ M9 §53 (hypothermie/hyperthermie)
//  FR  /min  │  12–20      │  8–35       │ M9 §56 ; SFAR RFE 2017
//  EtCO2 mmHg│  35–45      │  25–55      │ NUNN 8e ed. ; SFAR 2017
//  PAM mmHg  │  70–100     │  55–130     │ ESICM SSC 2021 ; NEJM 2014
//
//  JUSTIFICATIONS CLINIQUES :
//  PAS criticalMin=70  : choc décompensé, perfusion coronaire compromise [M9 §46]
//  PAS criticalMax=180 : urgence hypertensive per-op, risque AVC/IDM [ESC 2022]
//  PAD criticalMin=40  : insuffisance de la diastole coronaire [M9 §46]
//  FC  criticalMax=150 : seuil cardioversion AHA/ACLS si instabilité [AHA 2020]
//  FC  criticalMin=40  : bradycardie sévère, risque asystolie [AHA 2020]
//  SpO2 criticalMin=88 : insuffisance respiratoire sévère, indication CPAP [BTS 2017]
//  Temp criticalMin=34.0 : hypothermie modérée (34–36 = légère) [M9 §53]
//  Temp criticalMax=39.5 : hyperthermie maligne suspicion (> dantrolène) [SFAR 2015]
//  FR  criticalMin=8  : apnée fonctionnelle / dépression respiratoire [M9 §56]
//  FR  criticalMax=35 : détresse respiratoire sévère [SFAR 2017]
//  EtCO2 criticalMin=25 : alcalose respiratoire sévère (hyperventilation) [NUNN]
//  EtCO2 criticalMax=55 : hypercapnie permissive SDRA/asthme sévère [NUNN]
//  PAM criticalMin=55 : ischémie myocardique/rénale documentée [NEJM 2014]
//  PAM criticalMax=130 : hypertension sévère per-op [ESC 2022]
// ============================================================================

/// Ensemble des constantes vitales d'un patient à un instant donné.
@immutable
class Vitals {
  final double? systolicBP;      // PAS (mmHg)
  final double? diastolicBP;     // PAD (mmHg)
  final double? heartRate;       // FC  (bpm)
  final double? spo2;            // SpO₂ (%)
  final double? temperature;     // Température (°C)
  final double? respiratoryRate; // FR  (/min)
  final double? etco2;           // EtCO₂ (mmHg) — optionnel (si capnographe)

  const Vitals({
    this.systolicBP,
    this.diastolicBP,
    this.heartRate,
    this.spo2,
    this.temperature,
    this.respiratoryRate,
    this.etco2,
  });

  /// Constantes toutes nulles — état initial vide.
  const Vitals.empty()
      : systolicBP      = null,
        diastolicBP     = null,
        heartRate       = null,
        spo2            = null,
        temperature     = null,
        respiratoryRate = null,
        etco2           = null;

  // ── Paramètres dérivés ────────────────────────────────────

  /// Pression Artérielle Moyenne.
  /// PAM = (PAS + 2 × PAD) / 3
  /// Source : M9 §46 — formule de référence per-opératoire.
  double? get map {
    if (systolicBP == null || diastolicBP == null) return null;
    return (systolicBP! + 2.0 * diastolicBP!) / 3.0;
  }

  /// Pression différentielle (pulse pressure = PAS − PAD).
  /// PP < 25 mmHg = index cardiaque effondré [ESC 2022].
  /// PP > 60 mmHg = rigidité aortique / insuffisance aortique [M9 §46].
  double? get pulsePressure {
    if (systolicBP == null || diastolicBP == null) return null;
    return systolicBP! - diastolicBP!;
  }

  // ── Liste des signes vitaux avec bornes sourcées ───────────

  List<VitalSign> get vitalSigns => [
    // ── Pression Systolique ───────────────────────────────────
    // Normal 90–140 mmHg  : ESC/ESA 2022 Table 4 ; M9 §46
    // Critique <70 mmHg   : choc décompensé, PAM < 50 [M9 §46]
    // Critique >180 mmHg  : urgence hypertensive per-op [ESC 2022]
    VitalSign(
      name: 'Pression Systolique', abbreviation: 'PAS',
      value: systolicBP, unit: 'mmHg',
      normalMin: 90,  normalMax: 140,
      criticalMin: 70, criticalMax: 180,
      // [ESC 2022] Table 4 — seuils gestion HTA per-opératoire
      // [M9 §46]  — monitorage hémodynamique peropératoire
    ),

    // ── Pression Diastolique ──────────────────────────────────
    // Normal 60–90 mmHg   : ESC/ESA 2022 ; M9 §46
    // Critique <40 mmHg   : insuffisance de perfusion diastolique coronaire [M9 §46]
    // Critique >120 mmHg  : HTA diastolique sévère (risque dissection) [ESC 2022]
    VitalSign(
      name: 'Pression Diastolique', abbreviation: 'PAD',
      value: diastolicBP, unit: 'mmHg',
      normalMin: 60,  normalMax: 90,
      criticalMin: 40, criticalMax: 120,
      // [ESC 2022] — PAD > 110 = report chirurgie non urgente recommandé
      // [M9 §46]  — PAD < 40 = risque ischémie sous-endocardique
    ),

    // ── Fréquence Cardiaque ───────────────────────────────────
    // Normal 60–100 bpm   : définition sinusale standard [M9 §46]
    // Critique <40 bpm    : bradycardie sévère, risque asystolie [AHA 2020]
    // Critique >150 bpm   : seuil cardioversion si instabilité [AHA/ACLS 2020]
    VitalSign(
      name: 'Fréquence Cardiaque', abbreviation: 'FC',
      value: heartRate, unit: 'bpm',
      normalMin: 60,  normalMax: 100,
      criticalMin: 40, criticalMax: 150,
      // [AHA/ACLS 2020] — Part 7 : FC > 150 avec instabilité = cardioversion
      // [M9 §46]        — Bradycardie < 40 = atropine ± pacing
    ),

    // ── Saturation en Oxygène ─────────────────────────────────
    // Normal 94–100 %     : adulte sain au repos [BTS 2017]
    // Critique <88 %      : insuffisance respiratoire sévère, indication VNI [BTS 2017]
    // Critique >100 %     : non applicable physiquement (borne technique)
    // Note : cible SpO₂ 88–92% en BPCO sévère (risque hypoxie hypercapnique)
    //        → [BTS 2017] §4.2 — ne pas viser >93% en BPCO Gold 3-4
    VitalSign(
      name: 'SpO₂', abbreviation: 'SpO2',
      value: spo2, unit: '%',
      normalMin: 94,  normalMax: 100,
      criticalMin: 88, criticalMax: 100,
      // [BTS 2017] Thorax 72(S1) — seuil d'alerte SpO₂ <94%, critique <88%
      // [ERC 2021] — SpO₂ <94% = démarrer O₂ ; <88% = oxygénothérapie haut débit
    ),

    // ── Température ───────────────────────────────────────────
    // Normal 36.0–37.5 °C : normothermie centrale [M9 §53]
    // Critique <34.0 °C   : hypothermie modérée → troubles coagulation,
    //                       arythmies ventriculaires [M9 §53]
    // Critique >39.5 °C   : hyperthermie maligne suspectée → dantrolène [SFAR 2015]
    //                       T° 38.5–39.5 = fièvre per-op, investigation obligatoire
    VitalSign(
      name: 'Température', abbreviation: 'Temp',
      value: temperature, unit: '°C',
      normalMin: 36.0, normalMax: 37.5,
      criticalMin: 34.0, criticalMax: 39.5,
      decimalPlaces: 1,
      // [M9 §53]   — Thermorégulation & hypothermie per-op
      // [SFAR 2015]— RFE Hyperthermie maligne : T° > 39°C = alerte, >40 = urgence
    ),

    // ── Fréquence Respiratoire ────────────────────────────────
    // Normal 12–20 /min   : adulte au repos [M9 §56 ; NUNN 8e ed.]
    // Critique <8 /min    : dépression respiratoire sévère (opioïdes, apnée) [M9 §56]
    // Critique >35 /min   : détresse respiratoire sévère → intubation à discuter [SFAR 2017]
    VitalSign(
      name: 'Fréquence Respiratoire', abbreviation: 'FR',
      value: respiratoryRate, unit: '/min',
      normalMin: 12,  normalMax: 20,
      criticalMin: 8,  criticalMax: 35,
      // [M9 §56]    — Monitoring respiratoire per-op
      // [SFAR 2017] — RFE Monitorage : FR > 30 = détresse, > 35 = seuil critique
    ),

    // ── EtCO₂ (si capnographe disponible) ───────────────────
    // Normal 35–45 mmHg   : normocapnie physiologique [NUNN 8e ed.]
    //   EtCO₂ ≈ PaCO₂ − 2 à 5 mmHg (gradient alvéolo-artériel normal)
    // Critique <25 mmHg   : alcalose respiratoire sévère (hyperventilation) [NUNN]
    // Critique >55 mmHg   : hypercapnie permissive (SDRA, asthme sévère) [NUNN]
    //   Tolérance jusqu'à 55 en protocole "lung protective ventilation" [M9 §103]
    if (etco2 != null)
      VitalSign(
        name: 'EtCO₂', abbreviation: 'EtCO2',
        value: etco2, unit: 'mmHg',
        normalMin: 35,  normalMax: 45,
        criticalMin: 25, criticalMax: 55,
        // [NUNN 8e] — Lumb AB. Chap. 6 : contrôle de la ventilation
        // [M9 §45]  — Capnographie per-opératoire
        // [M9 §103] — Ventilation protectrice SDRA : PaCO₂ jusqu'à 55 mmHg tolérée
      ),
  ];

  // ── Pression Artérielle Moyenne — VitalSign ───────────────
  //
  // Normal 70–100 mmHg   : objectif per-opératoire standard [ESC 2022, M9 §46]
  // Critique <55 mmHg    : ischémie myocardique et rénale documentée [NEJM 2014]
  //   Asfar P et al. (2014) : PAM 65 vs 85 mmHg — pas de bénéfice >65
  //   Ischémie sous-endocardique documentée pour PAM < 55 mmHg
  // Critique >130 mmHg   : hypertension sévère per-op → poussée hypertensive [ESC 2022]
  VitalSign? get mapSign {
    final m = map;
    if (m == null) return null;
    return VitalSign(
      name: 'Pression Artérielle Moyenne', abbreviation: 'PAM',
      value: m, unit: 'mmHg',
      normalMin: 70,  normalMax: 100,
      criticalMin: 55, criticalMax: 130,
      // [ESICM SSC 2021] — cible PAM ≥ 65 mmHg en choc septique
      // [NEJM 2014]      — PAM < 55 mmHg = ischémie documentée
      // [ESC 2022]       — Table 4 : PAM > 110 = HTA sévère per-op
    );
  }

  // ── Helpers ───────────────────────────────────────────────

  bool get hasAnyValue =>
      systolicBP != null || diastolicBP != null || heartRate != null ||
      spo2 != null || temperature != null || respiratoryRate != null ||
      etco2 != null;

  bool get hasCritical =>
      vitalSigns.any((v) => v.status == VitalStatus.critical);

  bool get hasWarning =>
      vitalSigns.any((v) => v.status == VitalStatus.warning);

  int get criticalCount =>
      vitalSigns.where((v) => v.status == VitalStatus.critical).length;

  int get warningCount =>
      vitalSigns.where((v) => v.status == VitalStatus.warning).length;

  /// Statut global : le pire parmi tous les signes vitaux.
  VitalStatus get overallStatus {
    if (!hasAnyValue)                         return VitalStatus.unknown;
    if (vitalSigns.any((v) => v.isCritical))  return VitalStatus.critical;
    if (vitalSigns.any((v) => v.isWarning))   return VitalStatus.warning;
    return VitalStatus.normal;
  }

  // ── copyWith ──────────────────────────────────────────────

  Vitals copyWith({
    Object? systolicBP      = _sentinel,
    Object? diastolicBP     = _sentinel,
    Object? heartRate       = _sentinel,
    Object? spo2            = _sentinel,
    Object? temperature     = _sentinel,
    Object? respiratoryRate = _sentinel,
    Object? etco2           = _sentinel,
  }) {
    return Vitals(
      systolicBP:      systolicBP      == _sentinel ? this.systolicBP      : systolicBP      as double?,
      diastolicBP:     diastolicBP     == _sentinel ? this.diastolicBP     : diastolicBP     as double?,
      heartRate:       heartRate       == _sentinel ? this.heartRate       : heartRate       as double?,
      spo2:            spo2            == _sentinel ? this.spo2            : spo2            as double?,
      temperature:     temperature     == _sentinel ? this.temperature     : temperature     as double?,
      respiratoryRate: respiratoryRate == _sentinel ? this.respiratoryRate : respiratoryRate as double?,
      etco2:           etco2           == _sentinel ? this.etco2           : etco2           as double?,
    );
  }

  // ── Sérialisation ─────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'systolicBP':      systolicBP,
    'diastolicBP':     diastolicBP,
    'heartRate':       heartRate,
    'spo2':            spo2,
    'temperature':     temperature,
    'respiratoryRate': respiratoryRate,
    'etco2':           etco2,
  };

  factory Vitals.fromMap(Map<String, dynamic> map) => Vitals(
    systolicBP:      (map['systolicBP']      as num?)?.toDouble(),
    diastolicBP:     (map['diastolicBP']     as num?)?.toDouble(),
    heartRate:       (map['heartRate']       as num?)?.toDouble(),
    spo2:            (map['spo2']            as num?)?.toDouble(),
    temperature:     (map['temperature']     as num?)?.toDouble(),
    respiratoryRate: (map['respiratoryRate'] as num?)?.toDouble(),
    etco2:           (map['etco2']           as num?)?.toDouble(),
  );

  // ── Equatable ─────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vitals &&
          systolicBP      == other.systolicBP      &&
          diastolicBP     == other.diastolicBP     &&
          heartRate       == other.heartRate       &&
          spo2            == other.spo2            &&
          temperature     == other.temperature     &&
          respiratoryRate == other.respiratoryRate &&
          etco2           == other.etco2;

  @override
  int get hashCode => Object.hash(
    systolicBP, diastolicBP, heartRate, spo2,
    temperature, respiratoryRate, etco2,
  );

  @override
  String toString() =>
      'Vitals(PAS:${systolicBP?.toStringAsFixed(0) ?? '?'} '
      'PAD:${diastolicBP?.toStringAsFixed(0) ?? '?'} '
      'FC:${heartRate?.toStringAsFixed(0) ?? '?'} '
      'SpO₂:${spo2?.toStringAsFixed(0) ?? '?'}%)';
}

// ── Sentinelle pour copyWith nullable ────────────────────────
const _Sentinel _sentinel = _Sentinel();
class _Sentinel { const _Sentinel(); }