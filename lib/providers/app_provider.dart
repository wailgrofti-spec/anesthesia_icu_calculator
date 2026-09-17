// ============================================================================
//  lib/providers/app_provider.dart
//  VERSION 2.2 — Optimisé : cache des règles, persistance sélection,
//                Selector-ready (getters atomiques)
//
//  Sources médicales :
//  [1] Miller's Anesthesia, 9th ed. — Gropper MA et al., Elsevier 2020
//  [2] SFAR — Recommandations formalisées d'experts, anesthésie-réanimation
//  [3] KDIGO Guidelines for AKI & CKD, 2023
//  [4] EASL Clinical Practice Guidelines — liver disease, 2023
//  [5] ANSM — RCP officiels
//  [6] UpToDate — Drug prescribing in organ failure, 2024
// ============================================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';
import '../models/vitals.dart';
import '../models/pathologie.dart';
import '../data/pathologies_data.dart';
import '../data/drug_pathology_rules.dart';

class AppProvider extends ChangeNotifier {

  // ══════════════════════════════════════════════════════════
  //  ÉTAT PRIVÉ
  // ══════════════════════════════════════════════════════════

  Patient _patient         = const Patient();
  Vitals  _vitals          = const Vitals();
  bool    _isDarkMode      = false;
  bool    _isPediatricMode = false;
  bool    _initialized     = false;

  List<Pathologie> _pathologies = List<Pathologie>.from(pathologiesData);

  /// Cache des règles résolu — invalidé à chaque sélection/désélection.
  Map<String, DrugPathologyRule>? _cachedRules;

  // ══════════════════════════════════════════════════════════
  //  GETTERS DE BASE  (Selector-friendly — granulaires)
  // ══════════════════════════════════════════════════════════

  Patient get patient         => _patient;
  Vitals  get vitals          => _vitals;
  bool    get isDarkMode      => _isDarkMode;
  bool    get isPediatricMode => _isPediatricMode;
  bool    get initialized     => _initialized;

  // ══════════════════════════════════════════════════════════
  //  GETTERS PATHOLOGIES
  // ══════════════════════════════════════════════════════════

  List<Pathologie> get pathologies => _pathologies;

  List<Pathologie> get pathologiesSelectionnees =>
      _pathologies.where((p) => p.estSelectionnee).toList();

  bool get aDesPathologiesSelectionnees =>
      _pathologies.any((p) => p.estSelectionnee);

  int get nombrePathologiesSelectionnees =>
      _pathologies.where((p) => p.estSelectionnee).length;

  Map<CategoriePathologie, List<Pathologie>> get pathologiesParCategorie {
    final map = <CategoriePathologie, List<Pathologie>>{};
    for (final p in _pathologies) {
      map.putIfAbsent(p.categorie, () => []).add(p);
    }
    return map;
  }

  // ══════════════════════════════════════════════════════════
  //  RÈGLES MÉDICAMENT ↔ PATHOLOGIE  (avec cache)
  // ══════════════════════════════════════════════════════════

  /// Règles résolues pour toutes les pathologies sélectionnées.
  /// Résultat mis en cache — recalculé uniquement si la sélection change.
  Map<String, DrugPathologyRule> get resolvedDrugRules {
    _cachedRules ??= resolveRulesForPathologies(
      pathologiesSelectionnees.map((p) => p.id),
    );
    return _cachedRules!;
  }

  /// IDs médicaments ⭐ préférés toutes pathologies confondues. [1][2]
  Set<String> get drugsPreferesIds {
    final ids = <String>{};
    for (final p in pathologiesSelectionnees) {
      ids.addAll(p.droguesFavorisees);
    }
    resolvedDrugRules.forEach((id, rule) {
      if (rule.status == DrugPathologyStatus.preferred) ids.add(id);
    });
    return ids;
  }

  /// IDs médicaments ❌ contre-indiqués toutes pathologies confondues. [1][2][5]
  Set<String> get drugsContreindiqueIds {
    final ids = <String>{};
    for (final p in pathologiesSelectionnees) {
      ids.addAll(p.contreIndications);
    }
    resolvedDrugRules.forEach((id, rule) {
      if (rule.status == DrugPathologyStatus.contraindicated) ids.add(id);
    });
    return ids;
  }

  /// IDs médicaments ⚠️ prudence toutes pathologies confondues. [3][4][6]
  Set<String> get drugsCautionIds {
    final ids = <String>{};
    resolvedDrugRules.forEach((id, rule) {
      if (rule.status == DrugPathologyStatus.caution) ids.add(id);
    });
    return ids;
  }

  /// Retourne la règle consolidée pour un médicament donné, ou null.
  DrugPathologyRule? getRuleForDrug(String drugId) =>
      resolvedDrugRules[drugId];

  // ══════════════════════════════════════════════════════════
  //  RÉSOLUTION DES RÈGLES
  //  Priorité : contraindicated > caution > preferred [1][2]
  // ══════════════════════════════════════════════════════════

  /// Résout les règles drug↔pathologie pour un ensemble d'IDs de pathologies.
  /// Accepte [List<String>] ou [Set<String>] grâce à [Iterable].
  /// Appelable depuis drugs_screen.dart via le provider.
  Map<String, DrugPathologyRule> resolveRulesForPathologies(
      Iterable<String> pathologyIds) {
    final result = <String, DrugPathologyRule>{};
    final idSet  = pathologyIds.toSet();

    for (final entry in pathologyDrugRules.entries) {
      if (!idSet.contains(entry.key)) continue;
      for (final rule in entry.value) {
        final existing = result[rule.drugId];
        if (existing == null) {
          result[rule.drugId] = rule;
        } else {
          // CI > prudence > préféré
          if (rule.status == DrugPathologyStatus.contraindicated ||
              (rule.status == DrugPathologyStatus.caution &&
               existing.status == DrugPathologyStatus.preferred)) {
            result[rule.drugId] = rule;
          }
        }
      }
    }
    return result;
  }

  // ══════════════════════════════════════════════════════════
  //  AJUSTEMENTS DE DOSE  [3][4][5][6]
  // ══════════════════════════════════════════════════════════

  /// Retourne tous les ajustements applicables à un médicament donné
  /// selon les pathologies sélectionnées.
  List<DoseAjustee> getAjustementsPourDrug(String drugId) {
    final ajustements = <DoseAjustee>[];
    for (final p in pathologiesSelectionnees) {
      for (final da in p.dosesAjustees) {
        if (da.drugId == drugId) ajustements.add(da);
      }
    }
    return ajustements;
  }

  /// Facteur de dose résultant (produit de tous les ajustements, planché 0.1).
  double facteurDosePourDrug(String drugId) {
    final ajust = getAjustementsPourDrug(drugId);
    if (ajust.isEmpty) return 1.0;
    double facteur = ajust.fold(1.0, (acc, da) => acc * da.facteur);
    return facteur.clamp(0.1, 1.0);
  }

  List<String> get toutesConsignes {
    final list = <String>[];
    for (final p in pathologiesSelectionnees) {
      list.addAll(p.consignes.map((c) => '[${p.nom}] $c'));
    }
    return list;
  }

  List<String> get toutesAlertes {
    final list = <String>[];
    for (final p in pathologiesSelectionnees) {
      list.addAll(p.alertes.map((a) => '[${p.nom}] $a'));
    }
    return list;
  }

  // ══════════════════════════════════════════════════════════
  //  MÉTHODES PATHOLOGIES
  // ══════════════════════════════════════════════════════════

  void basculerPathologie(String id) {
    _pathologies = _pathologies.map((p) {
      if (p.id == id) return p.copierAvec(estSelectionnee: !p.estSelectionnee);
      return p;
    }).toList().cast<Pathologie>();
    _cachedRules = null; // invalider le cache
    _savePathologiesSelectionnees();
    notifyListeners();
  }

  void reinitialiserPathologies() {
    _pathologies = List<Pathologie>.from(pathologiesData);
    _cachedRules = null;
    _clearPathologiesSelectionnees();
    notifyListeners();
  }

  // ══════════════════════════════════════════════════════════
  //  INITIALISATION / PERSISTENCE
  // ══════════════════════════════════════════════════════════

  AppProvider() { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _isPediatricMode = prefs.getBool('pediatricMode') ?? false;

    // Patient
    final w  = prefs.getDouble('weight');
    final h  = prefs.getDouble('height');
    final av = prefs.getDouble('ageValue');
    final au = prefs.getInt('ageUnit');
    final s  = prefs.getInt('sex');
    if (w != null || h != null || av != null) {
      _patient = Patient(
        weight:   w,
        height:   h,
        ageValue: av,
        ageUnit:  au != null ? AgeUnit.values[au] : AgeUnit.years,
        sex:      s != null ? Sex.values[s] : null,
      );
    }

    // Pathologies sélectionnées (persistées entre sessions)
    final savedIds = prefs.getStringList('selectedPathologies') ?? [];
    if (savedIds.isNotEmpty) {
      final idSet = savedIds.toSet();
      _pathologies = _pathologies
          .map((p) => idSet.contains(p.id) ? p.copierAvec(estSelectionnee: true) : p)
          .toList()
          .cast<Pathologie>();
      _cachedRules = null;
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> _savePathologiesSelectionnees() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = pathologiesSelectionnees.map((p) => p.id).toList();
    await prefs.setStringList('selectedPathologies', ids);
  }

  Future<void> _clearPathologiesSelectionnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedPathologies');
  }

  // ══════════════════════════════════════════════════════════
  //  PATIENT & MODE PÉDIATRIQUE
  // ══════════════════════════════════════════════════════════

  void setPediatricMode(bool value) {
    _isPediatricMode = value;
    _savePediatricMode();
    notifyListeners();
  }

  void togglePediatricMode() {
    _isPediatricMode = !_isPediatricMode;
    _savePediatricMode();
    notifyListeners();
  }

  Future<void> _savePediatricMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pediatricMode', _isPediatricMode);
  }

  void updatePatient({
    double?  weight,
    double?  height,
    double?  ageValue,
    AgeUnit? ageUnit,
    Sex?     sex,
    bool     clearAge = false,
  }) {
    final oldAgeYears = _patient.ageInYears;
    _patient = Patient(
      weight:   weight   ?? _patient.weight,
      height:   height   ?? _patient.height,
      ageValue: clearAge ? null : (ageValue ?? _patient.ageValue),
      ageUnit:  ageUnit  ?? _patient.ageUnit,
      sex:      sex      ?? _patient.sex,
    );

    // Auto-détection pédiatrique si l'âge (en années) change
    final newAgeYears = _patient.ageInYears;
    if (newAgeYears != null && newAgeYears != oldAgeYears) {
      if (newAgeYears < 18 && !_isPediatricMode) {
        _isPediatricMode = true;
        _savePediatricMode();
      } else if (newAgeYears >= 18 && _isPediatricMode) {
        _isPediatricMode = false;
        _savePediatricMode();
      }
    }

    _savePatient();
    notifyListeners();
  }

  void clearPatient() {
    _patient = const Patient();
    _savePatient();
    notifyListeners();
  }

  Future<void> _savePatient() async {
    final prefs = await SharedPreferences.getInstance();
    if (_patient.weight   != null) await prefs.setDouble('weight',   _patient.weight!);
    if (_patient.height   != null) await prefs.setDouble('height',   _patient.height!);
    if (_patient.ageValue != null) await prefs.setDouble('ageValue', _patient.ageValue!);
    await prefs.setInt('ageUnit', _patient.ageUnit.index);
    if (_patient.sex      != null) await prefs.setInt('sex',        _patient.sex!.index);
  }

  // ══════════════════════════════════════════════════════════
  //  VITAUX
  // ══════════════════════════════════════════════════════════

  void updateVitals({
    double? systolicBP,
    double? diastolicBP,
    double? heartRate,
    double? spo2,
    double? temperature,
    double? respiratoryRate,
    double? etco2,
  }) {
    _vitals = Vitals(
      systolicBP:      systolicBP      ?? _vitals.systolicBP,
      diastolicBP:     diastolicBP     ?? _vitals.diastolicBP,
      heartRate:       heartRate       ?? _vitals.heartRate,
      spo2:            spo2            ?? _vitals.spo2,
      temperature:     temperature     ?? _vitals.temperature,
      respiratoryRate: respiratoryRate ?? _vitals.respiratoryRate,
      etco2:           etco2           ?? _vitals.etco2,
    );
    notifyListeners();
  }

  void clearVitals() {
    _vitals = const Vitals();
    notifyListeners();
  }

  // ══════════════════════════════════════════════════════════
  //  THÈME
  // ══════════════════════════════════════════════════════════

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }
}