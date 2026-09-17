// ===========================
//  lib/data/autre/orl_local.dart
//  Categorie : ORL LOCAL
//  Créé pour lier otite externe
// ===========================

import '../../../models/drug.dart';

const List<Drug> orlLocalDrugs = [

  Drug(
    id: 'gouttes_auriculaires_ab_corticoide',
    name: 'Gouttes Auriculaires Antibiotique-Corticoïde',
    genericName: 'Association antibiotique (ex. ofloxacine) + corticoïde local',
    category: DrugCategory.other,
    therapeuticClass: 'ORL Local',
    subCategory: 'Antibiotique + Corticoïde Topique Auriculaire',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: 'Quelques gouttes x2/j — pas de dose systémique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — usage local exclusif'),
    bolusMethod: 'Quelques gouttes dans le conduit auditif externe, 2x/jour pendant 7-10 jours. Vérifier l\'intégrité du tympan avant prescription (certaines associations sont ototoxiques si tympan perforé).',
    infusionRate: 'Non applicable — usage local exclusif, aucune administration systémique.',
    preparation: 'Flacon compte-gouttes prêt à l\'emploi, à température ambiante avant instillation (limiter les vertiges liés au froid).',
    shortWarning: 'Vérifier l\'absence de perforation tympanique avant utilisation — certaines molécules sont ototoxiques si passage à l\'oreille moyenne.',
    warnings: [
      'Vérifier l\'intégrité tympanique avant prescription — ototoxicité possible de certains antibiotiques (aminosides) si passage transtympanique',
      'Ne pas utiliser au-delà de la durée prescrite (risque de surinfection fongique)',
    ],
    indications: [
      'Otite externe bactérienne',
    ],
    mechanism: 'Action antibactérienne locale (selon la molécule) associée à un effet anti-inflammatoire corticoïde local',
    onset: '48-72h',
    duration: 'Traitement 7-10 jours',
  ),

];
