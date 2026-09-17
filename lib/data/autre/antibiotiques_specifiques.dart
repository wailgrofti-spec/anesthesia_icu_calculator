// ===========================
//  lib/data/autre/antibiotiques_specifiques.dart
//  Categorie : ANTIBIOTIQUES SPECIFIQUES
//  Créé pour lier la syphilis (benzathine-pénicilline = traitement de
//  référence réel, distinct des bêta-lactamines déjà présentes dans
//  antibiotics_data.dart)
// ===========================

import '../../../models/drug.dart';

const List<Drug> specificAntibioticDrugs = [

  Drug(
    id: 'benzathine_penicilline',
    name: 'Benzathine-Pénicilline G',
    genericName: 'Benzathine benzylpénicilline (Extencilline®)',
    category: DrugCategory.other,
    therapeuticClass: 'Antibiotiques Spécifiques',
    subCategory: 'Bêta-lactamine Retard IM — Traitement de Référence Syphilis',
    bolus: DoseRange(min: 2.4, max: 2.4, unit: DoseUnit.unitsFixed, label: 'IM profonde — dose fixe adulte (millions UI), injection unique ou répétée'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie IM exclusive, jamais IV'),
    bolusMethod: 'IM profonde stricte (fessier), JAMAIS IV (risque d\'embolie/réaction sévère). Syphilis précoce : injection unique 2.4 MUI. Syphilis tardive : 3 injections à 1 semaine d\'intervalle.',
    infusionRate: 'Non applicable — voie IM exclusive, contre-indication formelle à la voie IV.',
    preparation: 'Poudre à reconstituer extemporanément, suspension IM, injection lente en 2 points si volume important.',
    shortWarning: 'JAMAIS EN IV — risque d\'accident vasculaire/embolique grave. Risque de réaction de Jarisch-Herxheimer dans les heures suivant l\'injection.',
    warnings: [
      'CONTRE-INDICATION ABSOLUE à la voie intraveineuse — injection strictement intramusculaire profonde',
      'Réaction de Jarisch-Herxheimer possible dans les 24h suivant l\'injection (fièvre, myalgies) — phénomène attendu, non allergique',
      'Allergie aux pénicillines — vérifier systématiquement les antécédents avant administration',
    ],
    indications: [
      'Syphilis (tous stades) — traitement de référence international',
    ],
    mechanism: 'Inhibition de la synthèse du peptidoglycane de la paroi bactérienne — libération prolongée depuis le site IM (forme retard)',
    onset: 'Concentrations efficaces maintenues 2-4 semaines après une injection',
    duration: 'Selon le stade : injection unique (précoce) ou 3 injections hebdomadaires (tardive)',
  ),

];
