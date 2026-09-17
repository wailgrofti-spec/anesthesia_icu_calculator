// ===========================
//  lib/data/autre/hormones_antidiabetiques_oraux.dart
//  Categorie : HORMONES / ANTIDIABETIQUES ORAUX
//  Créé pour lier SOPK, syndrome métabolique
// ===========================

import '../../../models/drug.dart';

const List<Drug> hormoneDrugs = [

  Drug(
    id: 'metformine',
    name: 'Metformine',
    genericName: 'Metformine chlorhydrate',
    category: DrugCategory.other,
    therapeuticClass: 'Hormones / Antidiabétiques Oraux',
    subCategory: 'Biguanide — Insulinosensibilisateur',
    bolus: DoseRange(min: 500.0, max: 1000.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — traitement de fond chronique, PAS un bolus periop'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Non applicable — traitement oral chronique exclusivement'),
    bolusMethod: 'PO, traitement de fond chronique (pas d\'administration en urgence). À ARRÊTER avant chirurgie/produit de contraste iodé selon protocole (risque d\'acidose lactique).',
    infusionRate: 'Non applicable — voie orale exclusive, traitement de fond au long cours.',
    preparation: 'Comprimés, prise au cours des repas pour limiter les troubles digestifs.',
    shortWarning: 'ARRÊT PRÉOPÉRATOIRE recommandé (48h avant chirurgie majeure ou produit de contraste iodé) — risque d\'acidose lactique en cas d\'insuffisance rénale aiguë périopératoire.',
    warnings: [
      'Arrêt recommandé 48h avant une chirurgie majeure ou l\'injection de produit de contraste iodé, à reprendre seulement après vérification de la fonction rénale',
      'Risque d\'acidose lactique en cas d\'insuffisance rénale aiguë périopératoire, d\'hypoxie ou d\'instabilité hémodynamique — contre-indication relative en réanimation',
      'Contre-indiqué si DFG <30 ml/min',
    ],
    indications: [
      'Syndrome des ovaires polykystiques (insulinorésistance associée)',
      'Syndrome métabolique avec insulinorésistance',
      'Diabète de type 2 (indication princeps)',
    ],
    mechanism: 'Réduction de la production hépatique de glucose (néoglucogenèse) et amélioration de la sensibilité périphérique à l\'insuline',
    onset: 'Effet métabolique en 1-2 semaines',
    duration: 'Traitement chronique au long cours',
  ),

];
