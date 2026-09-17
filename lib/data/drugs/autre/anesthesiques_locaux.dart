// ===========================
//  lib/data/autre/anesthesiques_locaux.dart
//  Categorie : ANESTHESIQUES LOCAUX
//  Issu de l'éclatement de other_data.dart (regroupement sous la
//  méta-catégorie "Autre" de l'écran Doses)
//  1 medicament(s)
// ===========================

import '../../../models/drug.dart';

const List<Drug> anesthesiquesLocauxDrugs = [

  Drug(
    id: 'lidocaine',
    name: 'Lidocaïne',
    genericName: 'Lidocaïne chlorhydrate',
    category: DrugCategory.other,
    therapeuticClass: 'Anesthésiques Locaux',
    subCategory: 'Anesthésique Local / Antiarythmique Classe Ib / Analgésique IV',
    bolus: DoseRange(min: 1.0, max: 1.5, unit: DoseUnit.mgPerKg, label: 'Bolus antiarythmique', maxAbsoluteDose: 100),
    infusion: DoseRange(min: 1.0, max: 3.0, unit: DoseUnit.mgPerKgH, label: 'Perfusion analgésique / antiarythmique'),
    bolusMethod: 'TV/FV : 1–1.5 mg/kg IV. Max 3 mg/kg total en 1h. Analgésie IV : 1.5 mg/kg bolus avant incision.',
    infusionRate: 'Antiarythmique : 20–50 mcg/kg/min (1–4 mg/min fixe). Analgésie perop : 1.5–2 mg/kg/h.',
    preparation: '10 mg/ml (1%) ou 20 mg/ml (2%). Diluer à 4 mg/ml pour perfusion (200 mg dans 50 ml NaCl).',
    standardConcentrationMgPerMl: 4.0,
    shortWarning: 'LAST (toxicité systémique) : goût métallique, acouphènes, convulsions, arrêt cardiaque. Antidote : Intralipide 20%.',
    warnings: [
      'LAST (Local Anesthetic Systemic Toxicity) — signes précoces : goût métallique, acouphènes, paresthésies péri-orales, vertiges',
      'LAST sévère : convulsions, arythmies, collapsus cardiovasculaire',
      'Antidote LAST : Intralipide 20% 1.5 ml/kg IV bolus — disponibilité obligatoire dans tout bloc d\'ALR',
      'Dose max infiltration : 3 mg/kg sans adrénaline ; 7 mg/kg avec adrénaline 1:200 000',
      'Pire en acidose, hypoxie, hypercapnie — corriger avant tout geste ALR',
      'Bloc auriculoventriculaire en cas de surdosage cardiaque',
    ],
    indications: [
      'Analgésie IV peropératoire (épargne morphinique démontrée en chirurgie colorectale)',
      'Antiarythmique ventriculaire d\'urgence',
      'Anesthésie locale topique (lidocaïne spray 10% pour intubation éveillée)',
      'Anesthésie locorégionale (bloc nerveux périphérique, rachianesthésie)',
      'Prétraitement SRI pour réduire la montée de PIC',
    ],
    mechanism: 'Blocage des canaux Na⁺ voltage-dépendants (stabilisation membranaire)',
    onset: '30–90 sec IV ; 5–15 min infiltration',
    duration: '15–20 min IV ; 1–2 h infiltration',
  ),

];
