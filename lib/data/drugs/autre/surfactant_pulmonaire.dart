// ===========================
//  lib/data/autre/surfactant_pulmonaire.dart
//  Categorie : SURFACTANT PULMONAIRE
//  Créé pour lier la détresse respiratoire néonatale
// ===========================

import '../../../models/drug.dart';

const List<Drug> pulmonarySurfactantDrugs = [

  Drug(
    id: 'poractant_alfa',
    name: 'Poractant Alfa',
    genericName: 'Poractant alfa (Curosurf®) — surfactant d\'origine porcine',
    category: DrugCategory.other,
    therapeuticClass: 'Surfactant Pulmonaire',
    subCategory: 'Surfactant Exogène — Maladie des Membranes Hyalines',
    bolus: DoseRange(min: 100.0, max: 200.0, unit: DoseUnit.mgPerKg, label: 'Instillation intratrachéale — dose initiale, répétable'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Non applicable — instillation unique répétable, pas de perfusion'),
    bolusMethod: 'Instillation intratrachéale directe via sonde d\'intubation, en position fractionnée (plusieurs positions) pour une répartition pulmonaire homogène. Dose initiale 100-200 mg/kg, doses suivantes 100 mg/kg si besoin (max 2-3 doses).',
    infusionRate: 'Non applicable — administration exclusivement intratrachéale en bolus fractionné, jamais en perfusion.',
    preparation: 'Suspension prête à l\'emploi, à réchauffer à température ambiante avant instillation, ne pas agiter (agitation douce uniquement).',
    shortWarning: 'Désaturation et bradycardie transitoires fréquentes pendant l\'instillation — monitorage continu obligatoire. Ajuster rapidement les paramètres ventilatoires après administration (amélioration rapide de la compliance).',
    warnings: [
      'Désaturation, bradycardie et reflux par la sonde possibles pendant l\'instillation — monitorage SpO2/FC continu obligatoire',
      'Amélioration rapide de la compliance pulmonaire après administration — ajuster immédiatement les paramètres ventilatoires (risque de volotraumatisme si non anticipé)',
      'Administration réservée au nouveau-né intubé, en unité de réanimation néonatale',
    ],
    indications: [
      'Détresse respiratoire néonatale par maladie des membranes hyalines (déficit en surfactant du prématuré)',
    ],
    mechanism: 'Apport exogène de phospholipides et protéines surfactantes — réduction de la tension superficielle alvéolaire, prévention du collapsus alvéolaire',
    onset: 'Amélioration de l\'oxygénation en quelques minutes à heures',
    duration: 'Effet prolongé, doses répétables selon évolution radio-clinique',
  ),

];
