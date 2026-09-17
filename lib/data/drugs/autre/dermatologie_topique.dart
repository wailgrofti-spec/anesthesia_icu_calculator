// ===========================
//  lib/data/autre/dermatologie_topique.dart
//  Categorie : DERMATOLOGIE TOPIQUE
//  Créé pour lier eczéma, psoriasis, acné
// ===========================

import '../../../models/drug.dart';

const List<Drug> dermatologyTopicalDrugs = [

  Drug(
    id: 'betamethasone_topique',
    name: 'Bétaméthasone Topique',
    genericName: 'Bétaméthasone dipropionate crème/pommade',
    category: DrugCategory.other,
    therapeuticClass: 'Dermatologie Topique',
    subCategory: 'Dermocorticoïde Classe Forte',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: 'Application cutanée 1-2x/j — pas de dose systémique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — usage topique exclusif'),
    bolusMethod: 'Application cutanée fine 1-2x/j sur les lésions, durée limitée (2-4 semaines en traitement d\'attaque), dégression progressive.',
    infusionRate: 'Non applicable — traitement topique exclusivement.',
    preparation: 'Crème ou pommade selon le type de lésion (crème si suintante, pommade si sèche/lichénifiée).',
    shortWarning: 'Atrophie cutanée si usage prolongé ou sur zones fines (visage, plis). Absorption systémique possible si surfaces étendues.',
    warnings: [
      'Atrophie cutanée, télangiectasies en cas d\'usage prolongé — limiter la durée de traitement',
      'Prudence sur le visage, les plis et chez l\'enfant (peau plus fine, absorption accrue)',
      'Absorption systémique possible si application sur de larges surfaces ou sous occlusion — risque de freination surrénalienne',
    ],
    indications: [
      'Eczéma (poussées inflammatoires)',
      'Psoriasis en plaques localisé',
    ],
    mechanism: 'Agoniste des récepteurs glucocorticoïdes cutanés — effet anti-inflammatoire, immunosuppresseur et vasoconstricteur local',
    onset: '2-3 jours',
    duration: 'Traitement d\'attaque 2-4 semaines, puis dégression',
  ),

  Drug(
    id: 'tretinoine_topique',
    name: 'Trétinoïne Topique',
    genericName: 'Trétinoïne (acide rétinoïque tout-trans) crème/gel',
    category: DrugCategory.other,
    therapeuticClass: 'Dermatologie Topique',
    subCategory: 'Rétinoïde Topique — Kératolytique',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: 'Application cutanée le soir — pas de dose systémique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — usage topique exclusif'),
    bolusMethod: 'Application cutanée fine le soir sur peau sèche, débuter à faible fréquence (1x/2-3 jours) pour limiter l\'irritation, puis quotidien selon tolérance.',
    infusionRate: 'Non applicable — traitement topique exclusivement.',
    preparation: 'Crème ou gel 0.025-0.05%.',
    shortWarning: 'Photosensibilisation — protection solaire obligatoire. Irritation cutanée initiale fréquente. Tératogène (voie topique : risque théorique faible mais CI grossesse par précaution).',
    warnings: [
      'Photosensibilisation — application le soir uniquement, protection solaire quotidienne obligatoire',
      'Irritation, érythème et desquamation fréquents en début de traitement (phénomène attendu)',
      'Contre-indiqué pendant la grossesse par précaution',
    ],
    indications: [
      'Acné (comédons, lésions inflammatoires légères à modérées)',
    ],
    mechanism: 'Agoniste des récepteurs nucléaires de l\'acide rétinoïque — normalise la kératinisation folliculaire, effet comédolytique et anti-inflammatoire',
    onset: 'Amélioration visible après 4-6 semaines',
    duration: 'Traitement au long cours (plusieurs mois)',
  ),

];
