// ===========================
//  lib/data/drugs/antivenoms_data.dart
//  Categorie : SERUMS / IMMUNOGLOBULINES
//  Créé pour lier piqûre de scorpion, envenimation par serpent, rage
// ===========================

import '../../models/drug.dart';

const List<Drug> antivenomDrugs = [

  Drug(
    id: 'serum_antiscorpionique',
    name: 'Sérum Antiscorpionique',
    genericName: 'Immunoglobulines équines antiscorpioniques',
    category: DrugCategory.other,
    therapeuticClass: 'Sérums / Immunoglobulines',
    subCategory: 'Sérothérapie — Envenimation Scorpionique',
    bolus: DoseRange(min: 1.0, max: 2.0, unit: DoseUnit.unitsFixed, label: 'Ampoule(s) IV selon gravité clinique'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — injection unique'),
    bolusMethod: 'IV lente en perfusion courte, sous surveillance stricte (risque de réaction anaphylactique à la protéine équine). Réservé aux formes sévères (grade II-III).',
    infusionRate: 'Non applicable — administration unique, pas de perfusion continue.',
    preparation: 'Ampoule à diluer dans 50-100 ml NaCl 0.9%, perfusion sur 30-60 min sous surveillance médicale continue.',
    shortWarning: 'Risque de réaction anaphylactique (protéine hétérologue équine) — adrénaline et matériel de réanimation disponibles avant administration.',
    warnings: [
      'Risque de choc anaphylactique lié à la protéine équine — test cutané préalable recommandé selon protocole local, adrénaline immédiatement disponible',
      'Réservé aux envenimations sévères avec signes systémiques (grade II-III) — non systématique pour piqûre simple',
      'Maladie sérique possible à distance (J7-J14)',
    ],
    indications: [
      'Envenimation scorpionique sévère avec signes systémiques (orage sympathique, détresse respiratoire)',
    ],
    mechanism: 'Neutralisation des toxines scorpioniques circulantes par anticorps spécifiques équins',
    onset: 'Quelques heures',
    duration: 'Dose unique, répétable selon évolution clinique',
  ),

  Drug(
    id: 'serum_antivenimeux_polyvalent',
    name: 'Sérum Antivenimeux Polyvalent',
    genericName: 'Immunoglobulines antivenimeuses (spécifique selon l\'espèce locale)',
    category: DrugCategory.other,
    therapeuticClass: 'Sérums / Immunoglobulines',
    subCategory: 'Sérothérapie — Envenimation Ophidienne',
    bolus: DoseRange(min: 1.0, max: 10.0, unit: DoseUnit.unitsFixed, label: 'Ampoule(s) IV selon gravité et espèce'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — injection en perfusion courte'),
    bolusMethod: 'IV en perfusion sur 30-60 min, dose selon la gravité clinique (échelle de gravité locale) et l\'espèce en cause. Ne jamais injecter en intramusculaire si coagulopathie.',
    infusionRate: 'Non applicable — administration discontinue selon besoin, pas de perfusion continue standard.',
    preparation: 'Ampoule à diluer dans 100-250 ml NaCl 0.9%, perfusion progressive sous surveillance médicale stricte.',
    shortWarning: 'Risque de réaction anaphylactique (protéine hétérologue) — adrénaline disponible. Ne jamais injecter en IM si coagulopathie associée.',
    warnings: [
      'Risque de choc anaphylactique — adrénaline et matériel de réanimation obligatoirement disponibles avant administration',
      'Éviter toute injection intramusculaire (y compris prémédications) en cas de coagulopathie associée — risque d\'hématome',
      'Efficacité dépendante de la spécificité du sérum vis-à-vis de l\'espèce en cause — identification du serpent utile si possible',
      'Maladie sérique possible à distance',
    ],
    indications: [
      'Envenimation par serpent avec syndrome hémorragique, neurotoxique ou myotoxique systémique',
    ],
    mechanism: 'Neutralisation des toxines du venin circulantes par anticorps spécifiques',
    onset: 'Quelques heures selon la toxine',
    duration: 'Dose répétable selon évolution clinique et biologique (coagulation)',
  ),

  Drug(
    id: 'immunoglobuline_antirabique',
    name: 'Immunoglobuline Antirabique',
    genericName: 'Immunoglobulines humaines ou équines antirabiques',
    category: DrugCategory.other,
    therapeuticClass: 'Sérums / Immunoglobulines',
    subCategory: 'Immunoprophylaxie Post-Exposition — Rage',
    bolus: DoseRange(min: 20.0, max: 40.0, unit: DoseUnit.unitsFixed, label: 'UI/kg — infiltration locale + reliquat IM'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable'),
    bolusMethod: 'Infiltration de la plus grande partie de la dose autour et dans la plaie de morsure, le reliquat en IM à distance. Associée systématiquement à la vaccination antirabique (schéma post-exposition complet).',
    infusionRate: 'Non applicable — infiltration locale et injection IM uniquement.',
    preparation: 'Ampoule prête à l\'emploi, dose calculée selon le poids (20 UI/kg humaine ou 40 UI/kg équine).',
    shortWarning: 'Doit être administrée le plus précocement possible après exposition, idéalement dans les 7 jours suivant la 1ère dose de vaccin.',
    warnings: [
      'Ne doit jamais être administrée après le 7ème jour suivant le début de la vaccination antirabique (inhibition de la réponse immunitaire)',
      'Ne jamais injecter dans le même site ni avec la même seringue que le vaccin',
      'Nettoyage et parage soigneux de la plaie AVANT infiltration',
    ],
    indications: [
      'Prophylaxie post-exposition rabique (morsure/griffure d\'animal suspect), catégorie III OMS',
    ],
    mechanism: 'Neutralisation passive immédiate du virus rabique le temps que la vaccination induise une immunité active',
    onset: 'Immédiat (protection passive)',
    duration: 'Dose unique, associée au schéma vaccinal complet',
  ),

];
