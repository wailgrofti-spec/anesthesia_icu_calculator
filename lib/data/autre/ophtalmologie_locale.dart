// ===========================
//  lib/data/autre/ophtalmologie_locale.dart
//  Categorie : OPHTALMOLOGIE LOCALE
//  Créé pour lier conjonctivite, kératite, cataracte
// ===========================

import '../../../models/drug.dart';

const List<Drug> ophthalmologyDrugs = [

  Drug(
    id: 'collyre_antibiotique',
    name: 'Collyre Antibiotique',
    genericName: 'Tobramycine collyre 0.3% (ou équivalent selon protocole local)',
    category: DrugCategory.other,
    therapeuticClass: 'Ophtalmologie Locale',
    subCategory: 'Antibiotique Topique Ophtalmique',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: '1 goutte x4-6/j — pas de dose systémique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — usage local exclusif'),
    bolusMethod: '1 goutte dans l\'œil atteint, 4-6x/jour selon la sévérité, durée 5-7 jours. Occlusion du point lacrymal 1 min après instillation pour limiter le passage systémique.',
    infusionRate: 'Non applicable — collyre exclusivement, aucune administration systémique.',
    preparation: 'Flacon collyre prêt à l\'emploi, conservation après ouverture limitée à 15 jours (péremption courte).',
    shortWarning: 'Usage local exclusif — absorption systémique négligeable. Ne pas porter de lentilles de contact pendant le traitement.',
    warnings: [
      'Ne pas porter de lentilles de contact pendant toute la durée du traitement',
      'Irritation locale transitoire possible à l\'instillation',
      'Péremption courte après ouverture (15 jours) — jeter le flacon au-delà',
    ],
    indications: [
      'Conjonctivite bactérienne',
      'Kératite bactérienne (formes légères — les formes sévères nécessitent une prise en charge ophtalmologique spécialisée urgente)',
    ],
    mechanism: 'Aminoside — inhibition de la synthèse protéique bactérienne par fixation à la sous-unité 30S ribosomale',
    onset: '24-48h',
    duration: 'Traitement 5-7 jours selon indication',
  ),

  Drug(
    id: 'collyre_mydriatique',
    name: 'Collyre Mydriatique',
    genericName: 'Tropicamide collyre 0.5-1%',
    category: DrugCategory.other,
    therapeuticClass: 'Ophtalmologie Locale',
    subCategory: 'Mydriatique/Cycloplégique Topique — Préparation Chirurgicale',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: '1 goutte, répétable — pas de dose systémique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — usage local exclusif'),
    bolusMethod: '1 goutte dans l\'œil à opérer, répétable toutes les 5-10 min (2-3 instillations) avant la chirurgie de cataracte pour obtenir une mydriase suffisante.',
    infusionRate: 'Non applicable — collyre exclusivement.',
    preparation: 'Flacon collyre prêt à l\'emploi, à conserver à température ambiante.',
    shortWarning: 'CONTRE-INDIQUÉ en cas de glaucome à angle fermé non traité — risque de précipiter une crise de glaucome aigu.',
    warnings: [
      'Contre-indiqué en cas de glaucome à angle fermé non traité ou d\'angle étroit non évalué — se référer à la pathologie \'Glaucome Aigu\'',
      'Vision floue transitoire (plusieurs heures) — informer le patient avant sortie',
      'Absorption systémique possible chez le nourrisson/personne âgée fragile (effets anticholinergiques)',
    ],
    indications: [
      'Préparation à la chirurgie de la cataracte (mydriase préopératoire)',
      'Examen du fond d\'œil',
    ],
    mechanism: 'Antagoniste muscarinique — relaxation du muscle sphincter de l\'iris (mydriase) et du muscle ciliaire (cycloplégie)',
    onset: '15-30 min',
    duration: '4-6h',
  ),

];
