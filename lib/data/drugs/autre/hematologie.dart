// ===========================
//  lib/data/autre/hematologie.dart
//  Categorie : HEMATOLOGIE
//  Créé pour lier anémie ferriprive, drépanocytose, thalassémie
// ===========================

import '../../../models/drug.dart';

const List<Drug> hematologyDrugs = [

  Drug(
    id: 'fer_carboxymaltose',
    name: 'Fer Carboxymaltose',
    genericName: 'Carboxymaltose ferrique (Ferinject®)',
    category: DrugCategory.other,
    therapeuticClass: 'Hématologie',
    subCategory: 'Supplémentation Martiale IV',
    bolus: DoseRange(min: 500.0, max: 1000.0, unit: DoseUnit.unitsFixed, label: 'Perfusion IV — dose fixe (mg) selon déficit calculé'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Perfusion unique, pas de perfusion continue prolongée'),
    bolusMethod: 'Perfusion IV sur 15 min minimum (jusqu\'à 1000 mg), dose calculée selon le déficit en fer (poids et hémoglobine). Optimisation préopératoire idéalement ≥2 semaines avant la chirurgie.',
    infusionRate: 'Perfusion unique en 15-30 min selon la dose. Pas d\'administration continue.',
    preparation: 'Solution 50 mg/ml, diluer dans NaCl 0.9% si dose >200 mg (max 1000 mg par perfusion, 1x/semaine).',
    standardConcentrationMgPerMl: 50.0,
    shortWarning: 'Réactions d\'hypersensibilité possibles (rares mais sévères) — surveillance 30 min post-perfusion. Hypophosphatémie possible.',
    warnings: [
      'Réactions d\'hypersensibilité, y compris anaphylactiques (rares) — surveillance clinique 30 min après chaque perfusion',
      'Hypophosphatémie possible, surtout si perfusions répétées — surveillance si traitement prolongé',
      'Ne pas administrer en cas d\'infection active non contrôlée',
    ],
    indications: [
      'Anémie ferriprive préopératoire (optimisation dans le cadre du Patient Blood Management) — alternative à la transfusion si délai suffisant',
      'Intolérance ou inefficacité du fer oral',
    ],
    mechanism: 'Complexe fer-carbohydrate permettant une libération contrôlée de fer, capté par le système réticulo-endothélial puis utilisé pour l\'érythropoïèse',
    onset: 'Correction de l\'hémoglobine en 2-4 semaines',
    duration: 'Effet prolongé — reconstitution des réserves martiales',
  ),

  Drug(
    id: 'hydroxyuree',
    name: 'Hydroxyurée',
    genericName: 'Hydroxycarbamide',
    category: DrugCategory.other,
    therapeuticClass: 'Hématologie',
    subCategory: 'Traitement de Fond — Hémoglobinopathies',
    bolus: DoseRange(min: 15.0, max: 35.0, unit: DoseUnit.mgPerKg, label: 'Dose orale quotidienne (traitement de fond, PAS un bolus periop)'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Non applicable — traitement oral chronique'),
    bolusMethod: 'PO 1x/jour, traitement de fond chronique (pas d\'administration en urgence peropératoire). Poursuivre en périopératoire sauf avis contraire de l\'hématologue.',
    infusionRate: 'Non applicable — voie orale, traitement de fond au long cours uniquement.',
    preparation: 'Gélules, dose ajustée selon NFS (myélosuppression dose-dépendante).',
    shortWarning: 'Traitement de fond au long cours — ne traite PAS la crise aiguë. Myélosuppression à surveiller (NFS régulière).',
    warnings: [
      'Myélosuppression dose-dépendante — surveillance NFS régulière indispensable',
      'Ne traite pas la crise vaso-occlusive aiguë — traitement de fond préventif uniquement',
      'Tératogène — contraception efficace nécessaire',
    ],
    indications: [
      'Drépanocytose — réduction de la fréquence des crises vaso-occlusives (traitement de fond)',
      'Thalassémie intermédiaire (induction de l\'hémoglobine fœtale, indication plus limitée)',
    ],
    mechanism: 'Inhibiteur de la ribonucléotide réductase — augmente la synthèse d\'hémoglobine fœtale (HbF), qui interfère avec la polymérisation de l\'HbS',
    onset: 'Effet clinique après plusieurs semaines à mois de traitement continu',
    duration: 'Traitement chronique au long cours',
  ),

];
