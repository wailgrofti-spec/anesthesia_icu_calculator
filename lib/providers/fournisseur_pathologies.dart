// lib/providers/fournisseur_app.dart  (PARTIE PATHOLOGIES — à fusionner avec votre provider existant)
//
// Ajoutez ces éléments à votre FournisseurApp existant :
//
// 1) Imports
// 2) Champs
// 3) Getters
// 4) Méthodes
//
// ─────────────────────────────────────────────────────────────────────────────

// ① IMPORTS à ajouter en haut de votre fichier provider :
//
// import '../models/pathologie.dart';
// import '../data/pathologies_data.dart';

// ② CHAMPS à ajouter dans votre classe FournisseurApp :
/*
  List<Pathologie> _pathologies = construirePathologies();
*/

// ③ GETTERS à ajouter :
/*
  List<Pathologie> get pathologies => _pathologies;

  List<Pathologie> get pathologiesSelectionnees =>
      _pathologies.where((p) => p.estSelectionnee).toList();

  Map<CategoriePathologie, List<Pathologie>> get pathologiesParCategorie {
    final map = <CategoriePathologie, List<Pathologie>>{};
    for (final p in _pathologies) {
      map.putIfAbsent(p.categorie, () => []).add(p);
    }
    return map;
  }

  /// IDs des médicaments préférés selon les pathologies sélectionnées
  Set<String> get drugsPreferesIds {
    final ids = <String>{};
    for (final p in pathologiesSelectionnees) {
      ids.addAll(p.droguesFavorisees);
    }
    return ids;
  }

  /// IDs des médicaments contre-indiqués selon les pathologies sélectionnées
  Set<String> get drugsContreindiqueIds {
    final ids = <String>{};
    for (final p in pathologiesSelectionnees) {
      ids.addAll(p.contreIndications);
    }
    return ids;
  }

  /// Récupère les ajustements de dose pour un médicament donné
  List<DoseAjustee> getAjustementsPourDrug(String drugId) {
    final ajustements = <DoseAjustee>[];
    for (final p in pathologiesSelectionnees) {
      for (final da in p.dosesAjustees) {
        if (da.drugId == drugId) {
          ajustements.add(da);
        }
      }
    }
    return ajustements;
  }

  /// Toutes les consignes des pathologies sélectionnées
  List<String> get toutesConsignes {
    final consignes = <String>[];
    for (final p in pathologiesSelectionnees) {
      consignes.addAll(p.consignes.map((c) => '[${p.nom}] $c'));
    }
    return consignes;
  }

  /// Toutes les alertes des pathologies sélectionnées
  List<String> get toutesAlertes {
    final alertes = <String>[];
    for (final p in pathologiesSelectionnees) {
      alertes.addAll(p.alertes.map((a) => '[${p.nom}] $a'));
    }
    return alertes;
  }
*/

// ④ MÉTHODE à ajouter :
/*
  void basculerPathologie(String id) {
    _pathologies = _pathologies.map((p) {
      if (p.id == id) return p.copierAvec(estSelectionnee: !p.estSelectionnee);
      return p;
    }).toList();
    notifyListeners();
  }

  void reinitialiserPathologies() {
    _pathologies = construirePathologies();
    notifyListeners();
  }
*/

// ─────────────────────────────────────────────────────────────────────────────
// EXEMPLE COMPLET DE PROVIDER (si vous voulez tout remplacer) :
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/pathologie.dart';
import '../data/pathologies_data.dart';

/// Provider d'exemple minimal — fusionnez avec votre FournisseurApp existant
class FournisseurPathologies extends ChangeNotifier {
  List<Pathologie> _pathologies = construirePathologies();

  List<Pathologie> get pathologies => _pathologies;

  List<Pathologie> get pathologiesSelectionnees =>
      _pathologies.where((p) => p.estSelectionnee).toList();

  Map<CategoriePathologie, List<Pathologie>> get pathologiesParCategorie {
    final map = <CategoriePathologie, List<Pathologie>>{};
    for (final p in _pathologies) {
      map.putIfAbsent(p.categorie, () => []).add(p);
    }
    return map;
  }

  Set<String> get drugsPreferesIds {
    final ids = <String>{};
    for (final p in pathologiesSelectionnees) {
      ids.addAll(p.droguesFavorisees);
    }
    return ids;
  }

  Set<String> get drugsContreindiqueIds {
    final ids = <String>{};
    for (final p in pathologiesSelectionnees) {
      ids.addAll(p.contreIndications);
    }
    return ids;
  }

  List<DoseAjustee> getAjustementsPourDrug(String drugId) {
    final ajustements = <DoseAjustee>[];
    for (final p in pathologiesSelectionnees) {
      for (final da in p.dosesAjustees) {
        if (da.drugId == drugId) {
          ajustements.add(da);
        }
      }
    }
    return ajustements;
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

  void basculerPathologie(String id) {
    _pathologies = _pathologies.map((p) {
      if (p.id == id) return p.copierAvec(estSelectionnee: !p.estSelectionnee);
      return p;
    }).toList();
    notifyListeners();
  }

  void reinitialiserPathologies() {
    _pathologies = construirePathologies();
    notifyListeners();
  }
}
