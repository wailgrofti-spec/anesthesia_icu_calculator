// ===========================
//  lib/data/drug_database.dart
//  VERSION 2.1 — Fix conflits import + noms explicites
// ===========================

import '../models/drug.dart';
import '../models/emergency_drug.dart';

import 'classic_drugs_data.dart';
import 'emergency_drugs_data.dart';
import 'urgency_protocols_data.dart' as urgency;
import 'insufficiency_protocols_data.dart' as insufficiency;

class DrugDatabase {
  DrugDatabase._();

  // ── Index précalculés ────────────────────────────────────
  static final Map<String, Drug> _drugIndex = {
    for (final d in classicDrugs) d.id: d,
  };

  static final Map<String, EmergencyProtocol> _protocolIndex = {
    for (final p in [
      ...urgency.urgencyProtocols,
      ...insufficiency.insufficiencyProtocols,
    ])
      p.id: p,
  };

  static final Set<String> _drugIds = _drugIndex.keys.toSet();

  // ── Médicaments classiques ────────────────────────────────
  static final List<Drug> drugs = classicDrugs;

  static Drug? getDrug(String id) => _drugIndex[id];

  static bool hasDrug(String id) => _drugIds.contains(id);

  static List<Drug> getDrugsByCategory(DrugCategory category) =>
      drugs.where((d) => d.category == category).toList();

  // ── Classes thérapeutiques dynamiques (data-driven) ─────────────────
  // Source unique de vérité pour l'écran Doses : aucune catégorie codée
  // en dur. Toute nouvelle classe présente dans lib/data/drugs/ apparaît
  // ici automatiquement, et disparaît automatiquement si elle ne contient
  // plus aucun médicament.

  /// Toutes les classes thérapeutiques actuellement présentes dans la
  /// base, triées par ordre alphabétique.
  static List<String> get availableTherapeuticClasses {
    final set = drugs.map((d) => d.displayClass).toSet().toList();
    set.sort();
    return set;
  }

  /// Classes thérapeutiques dans leur ordre d'apparition dans les
  /// fichiers de données (utile pour un affichage stable, ex : onglets).
  static List<String> get therapeuticClassesInDataOrder {
    final seen = <String>{};
    final ordered = <String>[];
    for (final d in drugs) {
      if (seen.add(d.displayClass)) ordered.add(d.displayClass);
    }
    return ordered;
  }

  static List<Drug> getDrugsByTherapeuticClass(String className) =>
      drugs.where((d) => d.displayClass == className).toList();

  static List<Drug> searchDrugs(String query) {
    if (query.isEmpty) return drugs;
    final q = query.toLowerCase().trim();
    return drugs
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.genericName.toLowerCase().contains(q) ||
            d.subCategory.toLowerCase().contains(q))
        .toList();
  }

  static List<Drug> getDrugsByIds(Iterable<String> ids) =>
      ids.map((id) => _drugIndex[id]).whereType<Drug>().toList();

  static List<DrugCategory> get availableCategories =>
      drugs.map((d) => d.category).toSet().toList()..sort();

  // ── Médicaments d'urgence ─────────────────────────────────
  static const List<EmergencyDrug> emergencyDrugs = emergencyDrugsData;

  static List<EmergencyDrug> getEmergencyDrugsByCategory(
          EmergencyCategory cat) =>
      emergencyDrugs.where((d) => d.category == cat).toList();

  static List<EmergencyDrug> getFirstLineEmergencyDrugs(
          EmergencyCategory cat) =>
      emergencyDrugs
          .where((d) => d.category == cat && d.isFirstLine)
          .toList();

  static EmergencyDrug? getEmergencyDrugByName(String name) {
    final lower = name.toLowerCase();
    try {
      return emergencyDrugs
          .firstWhere((d) => d.name.toLowerCase() == lower);
    } catch (_) {
      return null;
    }
  }

  // ── Protocoles ────────────────────────────────────────────

  /// Tous les protocoles fusionnés
  static List<EmergencyProtocol> get allProtocols => [
        ...urgency.urgencyProtocols,
        ...insufficiency.insufficiencyProtocols,
      ];

  /// Protocoles onglet Urgences
  static List<EmergencyProtocol> get urgencyProtocolsList =>
      urgency.urgencyProtocols.toList();

  /// Protocoles onglet Insuffisances
  static List<EmergencyProtocol> get insufficiencyProtocolsList =>
      insufficiency.insufficiencyProtocols.toList();

  static EmergencyProtocol? getProtocol(String id) =>
      _protocolIndex[id];

  static List<EmergencyProtocol> searchProtocols(String query) {
    if (query.isEmpty) return allProtocols;
    final q = query.toLowerCase().trim();
    return allProtocols
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.subtitle.toLowerCase().contains(q))
        .toList();
  }

  // ── Stats ─────────────────────────────────────────────────
  static int get totalDrugs => drugs.length;
  static int get totalEmergencyDrugs => emergencyDrugs.length;
  static int get totalProtocols => allProtocols.length;

  static Map<String, int> get summary => {
        'drugs': totalDrugs,
        'emergencyDrugs': totalEmergencyDrugs,
        'urgencyProtocols': urgency.urgencyProtocols.length,
        'insufficiencyProtocols': insufficiency.insufficiencyProtocols.length,
        'totalProtocols': totalProtocols,
      };
}