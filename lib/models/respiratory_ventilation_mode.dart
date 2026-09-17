// ============================================================================
//  lib/models/respiratory_ventilation_mode.dart
//  NOUVEAU — Mode ventilatoire (2ᵉ axe de sélection de l'écran, en plus du
//  profil clinique/pathologique déjà existant dans respiratory_params.dart).
//
//  N'ALTÈRE AUCUNE LOGIQUE EXISTANTE : ce fichier ajoute uniquement un
//  nouvel enum + des tables de correspondance "mode → paramètres à
//  afficher". Le moteur de calcul (RespiratoryParams.compute) et le
//  profil clinique (VentilationProfile) restent inchangés et pleinement
//  fonctionnels indépendamment de ce nouveau fichier.
//
//  Principe clinique :
//  - Le PROFIL (Ventilation protectrice / BPCO / SDRA / Obésité / Post-op /
//    Pédiatrie) détermine LES VALEURS cibles (Vt/kg, PEEP, FiO2...).
//  - Le MODE ventilatoire détermine QUELS paramètres sont pertinents à
//    régler et à afficher (ex. en VCV le Vt est réglé et la Pinsp est une
//    conséquence mesurée ; en VPC c'est l'inverse).
//
//  Sources : Dräger Academy — Modes de ventilation ; GE Healthcare
//  Anesthesia & Ventilation ; Hamilton Medical Academy ; Tobin M.
//  "Principles and Practice of Mechanical Ventilation", 3e éd. ; Miller's
//  Anesthesia 9e éd., chap. Ventilation mécanique.
// ============================================================================

import 'package:flutter/material.dart';
import 'respiratory_params.dart';

/// Modes ventilatoires sélectionnables sur l'écran des paramètres
/// respiratoires. Purement une couche d'affichage/organisation — n'affecte
/// pas le calcul des valeurs (assuré par [VentilationProfile]).
enum VentilationMode {
  vcv,     // Ventilation contrôlée en volume
  pcv,     // Ventilation contrôlée en pression
  psv,     // Ventilation spontanée en aide inspiratoire (Pressure Support)
  simvVc,  // SIMV à cyclage volumétrique
  simvPc,  // SIMV à cyclage barométrique
  cpapPs,  // CPAP + aide inspiratoire (sevrage / ventilation spontanée assistée)
}

extension VentilationModeLabel on VentilationMode {
  String get shortLabel {
    switch (this) {
      case VentilationMode.vcv:    return 'VCV';
      case VentilationMode.pcv:    return 'PCV';
      case VentilationMode.psv:    return 'PSV';
      case VentilationMode.simvVc: return 'SIMV-VC';
      case VentilationMode.simvPc: return 'SIMV-PC';
      case VentilationMode.cpapPs: return 'CPAP/PS';
    }
  }

  String get fullLabel {
    switch (this) {
      case VentilationMode.vcv:    return 'Ventilation contrôlée en volume';
      case VentilationMode.pcv:    return 'Ventilation contrôlée en pression';
      case VentilationMode.psv:    return 'Aide inspiratoire (Pressure Support)';
      case VentilationMode.simvVc: return 'SIMV à cyclage volumétrique';
      case VentilationMode.simvPc: return 'SIMV à cyclage barométrique';
      case VentilationMode.cpapPs: return 'CPAP + aide inspiratoire';
    }
  }

  IconData get icon {
    switch (this) {
      case VentilationMode.vcv:    return Icons.airline_seat_flat_angled;
      case VentilationMode.pcv:    return Icons.airline_seat_flat_angled;
      case VentilationMode.psv:    return Icons.self_improvement_rounded;
      case VentilationMode.simvVc: return Icons.sync_alt_rounded;
      case VentilationMode.simvPc: return Icons.sync_alt_rounded;
      case VentilationMode.cpapPs: return Icons.air_rounded;
    }
  }

  /// Profil clinique suggéré par défaut pour ce mode (exemple donné dans
  /// le cahier des charges : VCV + Ventilation protectrice, VPC + SDRA,
  /// PSV + BPCO...). L'utilisateur reste libre de choisir toute autre
  /// combinaison ensuite — ceci n'est qu'une pré-sélection intelligente.
  VentilationProfile get suggestedProfile {
    switch (this) {
      case VentilationMode.vcv:    return VentilationProfile.protective;
      case VentilationMode.pcv:    return VentilationProfile.ards;
      case VentilationMode.psv:    return VentilationProfile.copd;
      case VentilationMode.simvVc: return VentilationProfile.postOp;
      case VentilationMode.simvPc: return VentilationProfile.obesity;
      case VentilationMode.cpapPs: return VentilationProfile.postOp;
    }
  }

  /// `true` si ce mode règle directement le volume courant (le Vt est une
  /// consigne). `false` si le Vt est une conséquence mesurée d'une
  /// consigne de pression (VPC) ou de l'effort du patient (PSV/CPAP).
  bool get isVolumeControlled =>
      this == VentilationMode.vcv || this == VentilationMode.simvVc;

  /// `true` si ce mode règle directement un niveau de pression (Pinsp/AI)
  /// plutôt qu'un volume.
  bool get isPressureControlled => !isVolumeControlled;

  /// `true` si le patient a une activité respiratoire spontanée
  /// nécessaire/attendue dans ce mode (PSV, CPAP/PS, SIMV) — utilisé pour
  /// adapter les libellés de FR ("réglée" vs "de sécurité/backup").
  bool get requiresSpontaneousEffort => this == VentilationMode.psv || this == VentilationMode.cpapPs;

  /// Libellé court affiché dans le titre "Réglages recommandés" :
  /// "VCV + Ventilation protectrice", "PCV + SDRA", etc.
  String comboLabel(VentilationProfile profile) => '$shortLabel + ${profile.label}';

  /// Liste ordonnée des `paramId` (voir data/respiratory_detail_data.dart
  /// et respiratory_screen.dart) pertinents à afficher pour ce mode, dans
  /// la grille "Réglages ventilatoires recommandés".
  List<String> get visibleParamIds {
    switch (this) {
      // VCV : le Vt est la consigne réglée ; Pinsp/Pplat sont mesurées.
      case VentilationMode.vcv:
        return const [
          'vt', 'fr', 'peep', 'fio2',
          'insp_flow', 'ie', 'insp_time', 'trigger',
          'pplat', 'driving', 'insp_pressure', 'minute_volume',
        ];

      // VPC : Driving Pressure et Pinsp sont les consignes réglées ; le Vt
      // obtenu devient une valeur surveillée/estimée.
      case VentilationMode.pcv:
        return const [
          'driving', 'insp_pressure', 'peep', 'fr',
          'fio2', 'ie', 'insp_time', 'minute_volume',
          'pplat', 'trigger', 'vt',
        ];

      // PSV : uniquement les paramètres pertinents à l'aide inspiratoire
      // (pas de Vt/FR imposés — réglés par le patient, seulement surveillés).
      case VentilationMode.psv:
        return const [
          'insp_pressure', 'peep', 'fio2', 'trigger',
          'insp_flow', 'minute_volume', 'vt',
        ];

      // SIMV-VC : cycles obligatoires en volume + cycles spontanés assistés.
      case VentilationMode.simvVc:
        return const [
          'vt', 'fr', 'peep', 'fio2',
          'insp_pressure', 'trigger', 'ie', 'minute_volume', 'insp_flow',
        ];

      // SIMV-PC : cycles obligatoires en pression + cycles spontanés assistés.
      case VentilationMode.simvPc:
        return const [
          'driving', 'insp_pressure', 'fr', 'peep',
          'fio2', 'trigger', 'ie', 'minute_volume', 'vt',
        ];

      // CPAP/PS : ventilation spontanée assistée — pression seule.
      case VentilationMode.cpapPs:
        return const [
          'peep', 'insp_pressure', 'fio2', 'trigger', 'minute_volume',
        ];
    }
  }
}

/// `true` si ce paramètre est réglé par le clinicien dans ce mode (badge
/// "consigne"), par opposition à une valeur mesurée/estimée en résultante
/// (badge "surveillée"). Purement informatif côté UI.
bool isSettableInMode(String paramId, VentilationMode mode) {
  const volumeSetParams = {'vt', 'fr', 'peep', 'fio2', 'insp_flow', 'ie', 'trigger'};
  const pressureSetParams = {'driving', 'insp_pressure', 'peep', 'fio2', 'fr', 'trigger'};
  return mode.isVolumeControlled
      ? volumeSetParams.contains(paramId)
      : pressureSetParams.contains(paramId);
}
