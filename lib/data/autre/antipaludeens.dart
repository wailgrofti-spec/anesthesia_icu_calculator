// ===========================
//  lib/data/autre/antipaludeens.dart
//  Categorie : ANTIPALUDEENS
//  Créé pour lier paludisme
// ===========================

import '../../../models/drug.dart';

const List<Drug> antimalarialDrugs = [

  Drug(
    id: 'artemether_lumefantrine',
    name: 'Artéméther-Luméfantrine',
    genericName: 'Artéméther 20mg / Luméfantrine 120mg (Riamet®/Coartem®)',
    category: DrugCategory.other,
    therapeuticClass: 'Antipaludéens',
    subCategory: 'Antipaludéen — Combinaison à base d\'Artémisinine (ACT)',
    bolus: DoseRange(min: 4.0, max: 4.0, unit: DoseUnit.unitsFixed, label: 'Comprimés PO — dose fixe adulte, 6 prises sur 3 jours'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive dans les formes simples'),
    bolusMethod: 'PO : 4 comprimés à H0, H8, puis 2x/j à J2 et J3 (schéma 6 prises sur 3 jours), à prendre avec un repas gras (améliore l\'absorption de la luméfantrine).',
    infusionRate: 'Non applicable pour le paludisme simple — le paludisme grave (neuropaludisme) nécessite l\'artésunate IV, hors catalogue actuel, en milieu spécialisé.',
    preparation: 'Comprimés, prise obligatoire avec aliments gras pour optimiser l\'absorption.',
    shortWarning: 'Réservé au paludisme simple (non compliqué) — le paludisme grave nécessite une prise en charge spécialisée en urgence (artésunate IV). Risque d\'allongement du QT.',
    warnings: [
      'Réservé au paludisme simple — toute forme grave (neuropaludisme, défaillance d\'organe) nécessite un transfert en urgence vers un centre spécialisé',
      'Allongement du QT possible — prudence en association avec d\'autres agents allongeant le QT, ECG si facteurs de risque',
      'Absorption optimale nécessite la prise concomitante d\'aliments gras',
    ],
    indications: [
      'Paludisme simple (non compliqué) à Plasmodium falciparum ou autre espèce',
    ],
    mechanism: 'Artéméther : génération de radicaux libres toxiques pour le parasite. Luméfantrine : inhibition de la formation de l\'hémozoïne — action synergique',
    onset: 'Clairance parasitaire en 24-48h',
    duration: 'Traitement complet sur 3 jours (6 prises)',
  ),

];
