// ===========================
//  lib/data/autre/divers_specialises.dart
//  Categorie : DIVERS SPECIALISES
//  Créé pour lier menace d'accouchement prématuré, ostéoporose,
//  syndrome de l'intestin irritable
// ===========================

import '../../../models/drug.dart';

const List<Drug> gynecoOsteoDigestifDrugs = [

  Drug(
    id: 'nifedipine',
    name: 'Nifédipine',
    genericName: 'Nifédipine',
    category: DrugCategory.other,
    therapeuticClass: 'Divers Spécialisés',
    subCategory: 'Inhibiteur Calcique — Usage Tocolytique',
    bolus: DoseRange(min: 10.0, max: 20.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — dose fixe (mg), répétable'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive dans cette indication'),
    bolusMethod: 'PO 10-20 mg, répétable toutes les 15-20 min si besoin (max 3 prises en 1h), puis relais en traitement d\'entretien selon protocole obstétrical local.',
    infusionRate: 'Non applicable — utilisation orale exclusive en tocolyse (usage hors AMM mais largement répandu selon les recommandations obstétricales).',
    preparation: 'Comprimés/capsules à action rapide, voie orale exclusivement (ne jamais utiliser la voie sublinguale — risque de chute tensionnelle brutale).',
    shortWarning: 'Hypotension maternelle possible — surveillance tensionnelle. Usage tocolytique hors AMM stricte mais recommandé par les sociétés savantes obstétricales.',
    warnings: [
      'Hypotension maternelle, céphalées, flush — surveillance tensionnelle régulière',
      'Ne jamais associer au sulfate de magnésium (risque de potentialisation et de bloc neuromusculaire sévère)',
      'Usage tocolytique hors AMM stricte en France mais recommandé par le CNGOF',
    ],
    indications: [
      'Menace d\'accouchement prématuré — tocolyse de 1ère intention (avec l\'atosiban)',
    ],
    mechanism: 'Inhibiteur calcique — blocage des canaux calciques voltage-dépendants du muscle lisse utérin, réduisant la contractilité',
    onset: '20-30 min PO',
    duration: '4-6h par prise',
  ),

  Drug(
    id: 'acide_zoledronique',
    name: 'Acide Zolédronique',
    genericName: 'Acide zolédronique',
    category: DrugCategory.other,
    therapeuticClass: 'Divers Spécialisés',
    subCategory: 'Bisphosphonate — Traitement de l\'Ostéoporose',
    bolus: DoseRange(min: 5.0, max: 5.0, unit: DoseUnit.unitsFixed, label: 'Perfusion IV — dose fixe (mg), 1x/an'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Perfusion unique annuelle, pas de perfusion continue'),
    bolusMethod: 'Perfusion IV unique sur ≥15 min, 1x/an. Traitement de fond ambulatoire — jamais administré en urgence périopératoire.',
    infusionRate: 'Perfusion unique sur au moins 15 min, à distance de tout contexte chirurgical aigu.',
    preparation: 'Solution prête à l\'emploi ou à diluer selon la spécialité, réchauffer à température ambiante avant perfusion.',
    shortWarning: 'Vérifier la fonction rénale et la calcémie avant chaque perfusion. Hydratation préalable recommandée. Risque d\'ostéonécrose de la mâchoire (rare) — bilan dentaire préalable recommandé.',
    warnings: [
      'Contre-indiqué si clairance de la créatinine <35 ml/min',
      'Hypocalcémie possible — corriger une carence en vitamine D/calcium avant la perfusion',
      'Ostéonécrose de la mâchoire (rare) — bilan dentaire préalable recommandé avant la 1ère perfusion',
      'Syndrome pseudo-grippal fréquent après la 1ère perfusion (fièvre, myalgies) — généralement transitoire',
    ],
    indications: [
      'Ostéoporose (post-ménopausique, cortico-induite ou masculine) — traitement de référence',
    ],
    mechanism: 'Inhibition de la résorption osseuse ostéoclastique par fixation à l\'hydroxyapatite osseuse',
    onset: 'Effet antirésorptif en quelques semaines',
    duration: 'Perfusion annuelle (effet prolongé sur le remodelage osseux)',
  ),

  Drug(
    id: 'phloroglucinol',
    name: 'Phloroglucinol',
    genericName: 'Phloroglucinol',
    category: DrugCategory.other,
    therapeuticClass: 'Divers Spécialisés',
    subCategory: 'Antispasmodique Musculotrope Digestif',
    bolus: DoseRange(min: 80.0, max: 160.0, unit: DoseUnit.unitsFixed, label: 'IV/PO — dose fixe (mg), répétable'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — administration discontinue'),
    bolusMethod: 'IV lente ou PO/sublingual, 80-160 mg, répétable toutes les 6-8h selon besoin (max habituel 480 mg/j).',
    infusionRate: 'Non applicable — administration discontinue en bolus itératifs.',
    preparation: 'Ampoule IV ou lyophilisat oral, prête à l\'emploi.',
    shortWarning: 'Excellente tolérance générale — effets indésirables rares (allergie exceptionnelle).',
    warnings: [
      'Effets indésirables rares — bonne tolérance générale',
      'Efficacité clinique symptomatique modeste, à intégrer dans une prise en charge globale (mesures hygiéno-diététiques, autres antalgiques)',
    ],
    indications: [
      'Syndrome de l\'intestin irritable (composante douloureuse/spasmodique)',
      'Coliques hépatiques et néphrétiques (composante spasmodique, en complément des antalgiques)',
    ],
    mechanism: 'Antispasmodique musculotrope — relâchement direct du muscle lisse digestif et biliaire, sans effet anticholinergique',
    onset: '15-30 min',
    duration: '4-6h',
  ),

];
