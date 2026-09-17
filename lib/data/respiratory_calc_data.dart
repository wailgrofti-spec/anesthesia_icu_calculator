// ============================================================================
//  lib/data/respiratory_calc_data.dart
//  Valeurs numériques (bornes min/max) utilisées par le moteur de calcul
//  des paramètres ventilatoires — 1er écran (respiratory_screen.dart).
//
//  Équivalent, pour les profils ventilatoires, de pathologies_data.dart
//  pour les pathologies générales du module Drugs.
//
//  Étape 1 : seul `protective` est utilisé dans l'app (les autres profils
//  sont préparés ici, prêts à être activés à l'étape 3 — voir
//  VentilationProfileLabel.isImplemented dans models/respiratory_params.dart).
//
//  Sources (référencement complet — auteurs, DOI, liens — livré séparément
//  dans le document de référence final) :
//  - Ventilation protectrice : ARDSNet (N Engl J Med. 2000;342(18):1301-8) ;
//    SFAR RFE Ventilation périopératoire 2019.
//  - SDRA                    : SFAR/SRLF Recommandations SDRA ; ESICM 2023 ;
//    Amato et al. N Engl J Med 2015 (driving pressure).
//  - BPCO                    : ERS/ATS BPCO ; Nunn's Applied Respiratory
//    Physiology (gestion de l'auto-PEEP).
//  - Obésité                 : SFAR Ventilation périopératoire du patient obèse.
//  - Post-opératoire         : SFAR RFE Ventilation périopératoire 2019.
// ============================================================================

import '../models/respiratory_params.dart';

/// Bornes (min/max) appliquées par le moteur de calcul pour un profil
/// ventilatoire donné. Toutes les valeurs sont des recommandations issues
/// de sociétés savantes — aucune n'est inventée.
class VentilationProfileRules {
  final double vtPerKgMin;          // mL/kg PBW
  final double vtPerKgMax;          // mL/kg PBW
  final double frMin;               // /min
  final double frMax;               // /min
  final double peepMin;             // cmH2O
  final double peepMax;             // cmH2O
  final double fio2Min;             // fraction 0.21–1.0
  final double fio2Max;             // fraction 0.21–1.0
  final double plateauPressureMax;  // cmH2O
  final double drivingPressureMin;  // cmH2O
  final double drivingPressureMax;  // cmH2O
  final double inspPressureMin;     // cmH2O (au-dessus de la PEEP, VPC)
  final double inspPressureMax;     // cmH2O
  final String ieRatio;             // ex. "1:2"
  final double triggerFlowMin;      // L/min
  final double triggerFlowMax;      // L/min
  final double triggerPressureMin;  // cmH2O
  final double triggerPressureMax;  // cmH2O
  final double alarmHighPressureMin; // cmH2O
  final double alarmHighPressureMax; // cmH2O

  const VentilationProfileRules({
    required this.vtPerKgMin,
    required this.vtPerKgMax,
    required this.frMin,
    required this.frMax,
    required this.peepMin,
    required this.peepMax,
    required this.fio2Min,
    required this.fio2Max,
    required this.plateauPressureMax,
    required this.drivingPressureMin,
    required this.drivingPressureMax,
    required this.inspPressureMin,
    required this.inspPressureMax,
    required this.ieRatio,
    required this.triggerFlowMin,
    required this.triggerFlowMax,
    required this.triggerPressureMin,
    required this.triggerPressureMax,
    required this.alarmHighPressureMin,
    required this.alarmHighPressureMax,
  });
}

/// Dictionnaire des règles de calcul par profil ventilatoire.
/// Clé = `VentilationProfile`. Étape 1 : seul `protective` est marqué
/// "implémenté" côté UI, mais les autres jeux de valeurs sont déjà corrects
/// et prêts à être activés (étape 3).
final Map<VentilationProfile, VentilationProfileRules> respiratoryCalcRules = {
  // ══════════════════════════════════════════════════════════
  //  VENTILATION PROTECTRICE — poumons sains / post-op standard
  //  [ARDSNet 2000 ; SFAR RFE Ventilation périopératoire 2019]
  // ══════════════════════════════════════════════════════════
  VentilationProfile.protective: const VentilationProfileRules(
    vtPerKgMin: 6.0,
    vtPerKgMax: 8.0,
    frMin: 12.0,
    frMax: 16.0,
    peepMin: 5.0,
    peepMax: 5.0,
    fio2Min: 0.4,
    fio2Max: 0.6,
    plateauPressureMax: 30.0,
    drivingPressureMin: 10.0,
    drivingPressureMax: 15.0,
    inspPressureMin: 12.0,
    inspPressureMax: 18.0,
    ieRatio: '1:2',
    triggerFlowMin: 1.0,
    triggerFlowMax: 3.0,
    triggerPressureMin: 1.0,
    triggerPressureMax: 2.0,
    alarmHighPressureMin: 35.0,
    alarmHighPressureMax: 40.0,
  ),

  // ══════════════════════════════════════════════════════════
  //  BPCO — éviter l'hyperinflation dynamique / auto-PEEP
  //  [ERS/ATS BPCO ; Nunn's Applied Respiratory Physiology]
  // ══════════════════════════════════════════════════════════
  VentilationProfile.copd: const VentilationProfileRules(
    vtPerKgMin: 6.0,
    vtPerKgMax: 8.0,
    frMin: 10.0,
    frMax: 12.0,
    peepMin: 0.0,
    peepMax: 5.0,
    fio2Min: 0.3,
    fio2Max: 0.5,
    plateauPressureMax: 30.0,
    drivingPressureMin: 10.0,
    drivingPressureMax: 15.0,
    inspPressureMin: 12.0,
    inspPressureMax: 18.0,
    ieRatio: '1:3',
    triggerFlowMin: 1.0,
    triggerFlowMax: 3.0,
    triggerPressureMin: 1.0,
    triggerPressureMax: 2.0,
    alarmHighPressureMin: 35.0,
    alarmHighPressureMax: 40.0,
  ),

  // ══════════════════════════════════════════════════════════
  //  SDRA — protection pulmonaire renforcée
  //  [SFAR/SRLF Recommandations SDRA ; ESICM 2023 ; Amato NEJM 2015]
  // ══════════════════════════════════════════════════════════
  VentilationProfile.ards: const VentilationProfileRules(
    vtPerKgMin: 6.0,
    vtPerKgMax: 6.0,
    frMin: 20.0,
    frMax: 30.0,
    peepMin: 8.0,
    peepMax: 15.0,
    fio2Min: 0.5,
    fio2Max: 1.0,
    plateauPressureMax: 30.0,
    drivingPressureMin: 10.0,
    drivingPressureMax: 15.0,
    inspPressureMin: 14.0,
    inspPressureMax: 22.0,
    ieRatio: '1:2',
    triggerFlowMin: 1.0,
    triggerFlowMax: 3.0,
    triggerPressureMin: 1.0,
    triggerPressureMax: 2.0,
    alarmHighPressureMin: 35.0,
    alarmHighPressureMax: 40.0,
  ),

  // ══════════════════════════════════════════════════════════
  //  OBÉSITÉ — PEEP plus élevée pour compenser la baisse de la CRF
  //  [SFAR Ventilation périopératoire du patient obèse]
  // ══════════════════════════════════════════════════════════
  VentilationProfile.obesity: const VentilationProfileRules(
    vtPerKgMin: 6.0,
    vtPerKgMax: 8.0,
    frMin: 14.0,
    frMax: 18.0,
    peepMin: 8.0,
    peepMax: 12.0,
    fio2Min: 0.4,
    fio2Max: 0.6,
    plateauPressureMax: 30.0,
    drivingPressureMin: 10.0,
    drivingPressureMax: 15.0,
    inspPressureMin: 14.0,
    inspPressureMax: 20.0,
    ieRatio: '1:2',
    triggerFlowMin: 1.0,
    triggerFlowMax: 3.0,
    triggerPressureMin: 1.0,
    triggerPressureMax: 2.0,
    alarmHighPressureMin: 35.0,
    alarmHighPressureMax: 40.0,
  ),

  // ══════════════════════════════════════════════════════════
  //  POST-OPÉRATOIRE — identique à la ventilation protectrice standard
  //  [SFAR RFE Ventilation périopératoire 2019]
  // ══════════════════════════════════════════════════════════
  VentilationProfile.postOp: const VentilationProfileRules(
    vtPerKgMin: 6.0,
    vtPerKgMax: 8.0,
    frMin: 12.0,
    frMax: 16.0,
    peepMin: 5.0,
    peepMax: 5.0,
    fio2Min: 0.4,
    fio2Max: 0.6,
    plateauPressureMax: 30.0,
    drivingPressureMin: 10.0,
    drivingPressureMax: 15.0,
    inspPressureMin: 12.0,
    inspPressureMax: 18.0,
    ieRatio: '1:2',
    triggerFlowMin: 1.0,
    triggerFlowMax: 3.0,
    triggerPressureMin: 1.0,
    triggerPressureMax: 2.0,
    alarmHighPressureMin: 35.0,
    alarmHighPressureMax: 40.0,
  ),
};
