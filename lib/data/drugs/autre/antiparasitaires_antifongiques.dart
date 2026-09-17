// ===========================
//  lib/data/autre/antiparasitaires_antifongiques.dart
//  Categorie : ANTIPARASITAIRES / ANTIFONGIQUES
//  Créé pour lier gale, dermatophytie
// ===========================

import '../../../models/drug.dart';

const List<Drug> antiparasiticDrugs = [

  Drug(
    id: 'permethrine',
    name: 'Perméthrine',
    genericName: 'Perméthrine 5% crème',
    category: DrugCategory.other,
    therapeuticClass: 'Antiparasitaires / Antifongiques',
    subCategory: 'Scabicide Topique',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: 'Application cutanée unique — traitement topique, pas de dose systémique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — usage topique exclusif'),
    bolusMethod: 'Application cutanée sur tout le corps (cou aux pieds), temps de pose 8-12h puis rinçage. Répéter à J7-J14 selon protocole.',
    infusionRate: 'Non applicable — traitement topique exclusivement, aucune administration systémique.',
    preparation: 'Crème 5%, application unique sur peau sèche, tout le corps.',
    shortWarning: 'Usage topique exclusif — pas d\'absorption systémique significative aux doses recommandées. Traiter l\'entourage proche simultanément.',
    warnings: [
      'Traiter simultanément les sujets contacts proches (literie, vêtements) pour éviter la réinfestation',
      'Irritation cutanée locale possible',
      'Ne pas appliquer sur muqueuses ni plaies ouvertes étendues',
    ],
    indications: [
      'Gale (traitement de référence, 1ère intention)',
    ],
    mechanism: 'Neurotoxique pour les acariens — perturbation des canaux sodiques voltage-dépendants',
    onset: 'Traitement en 1 application (8-12h de pose)',
    duration: 'Répéter à J7-J14 selon protocole',
  ),

  Drug(
    id: 'terbinafine',
    name: 'Terbinafine',
    genericName: 'Terbinafine chlorhydrate',
    category: DrugCategory.other,
    therapeuticClass: 'Antiparasitaires / Antifongiques',
    subCategory: 'Antifongique — Allylamine',
    bolus: DoseRange(min: 250.0, max: 250.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — dose fixe adulte (mg/j) si forme systémique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable'),
    bolusMethod: 'Topique (crème 1%) 1-2x/j pour les formes localisées ; PO 250 mg/j pour les formes étendues, unguéales ou résistantes au traitement topique.',
    infusionRate: 'Non applicable — voie topique ou orale, jamais IV.',
    preparation: 'Crème 1% pour usage topique, ou comprimés 250 mg pour la voie orale.',
    shortWarning: 'Forme orale : hépatotoxicité possible — bilan hépatique si traitement prolongé (>6 semaines, onychomycose).',
    warnings: [
      'Forme orale : surveillance hépatique si traitement prolongé (risque d\'hépatotoxicité rare mais sévère)',
      'Forme topique : généralement bien tolérée, irritation locale possible',
    ],
    indications: [
      'Dermatophytie cutanée (forme topique) ou unguéale/étendue (forme orale)',
    ],
    mechanism: 'Inhibition de la squalène époxydase fongique — accumulation de squalène toxique et déficit en ergostérol membranaire',
    onset: 'Amélioration clinique en 1-2 semaines (topique)',
    duration: '1-4 semaines (topique) ; 6-12 semaines (orale, onychomycose)',
  ),

];
