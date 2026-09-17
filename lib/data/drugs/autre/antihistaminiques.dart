// ===========================
//  lib/data/autre/antihistaminiques.dart
//  Categorie : ANTIHISTAMINIQUES
//  Issu de l'éclatement de systemic_adjuvants_data.dart (architecture
//  data-driven — voir models/drug.dart::therapeuticClass)
//  1 medicament(s)
// ===========================

import '../../../models/drug.dart';

const List<Drug> antihistamineDrugs = [

  Drug(
    id: 'dexchlorpheniramine',
    name: 'Dexchlorphéniramine',
    genericName: 'Dexchlorphéniramine maléate (Polaramine®) — équivalent international : Diphenhydramine',
    category: DrugCategory.other,
    therapeuticClass: 'Antihistaminiques',
    subCategory: 'Antihistaminique H1 — Adjuvant Anaphylaxie/Allergie',
    bolus: DoseRange(min: 0.1, max: 0.15, unit: DoseUnit.mgPerKg, label: 'Bolus IV/IM — allergie/anaphylaxie', maxAbsoluteDose: 5),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Pas de perfusion continue standard'),
    bolusMethod: 'IV lente (≥1 min) ou IM. Adulte : 5 mg (1 ampoule) IV/IM, répétable si besoin. Toujours administré APRÈS l\'adrénaline dans l\'anaphylaxie — jamais en 1ère ligne.',
    infusionRate: 'Non utilisé en perfusion continue — bolus itératifs uniquement si besoin (q6–8h).',
    preparation: '5 mg/1 ml (ampoule). Prêt à l\'emploi en IV ou IM, dilution possible dans NaCl 0.9%.',
    standardConcentrationMgPerMl: 5.0,
    shortWarning: 'N\'EST PAS un traitement de l\'anaphylaxie sévère — adjuvant seulement, après adrénaline. Sédation, effet anticholinergique.',
    warnings: [
      'Ne traite PAS le bronchospasme, l\'hypotension ni l\'œdème laryngé de l\'anaphylaxie — l\'adrénaline IM reste le traitement de 1ère ligne incontournable',
      'Sédation et somnolence fréquentes — informer avant sortie en anesthésie ambulatoire',
      'Effets anticholinergiques : sécheresse buccale, rétention urinaire — prudence en glaucome à angle fermé et hypertrophie prostatique',
      'Prudence chez le sujet âgé (confusion, chutes) et en association avec d\'autres sédatifs',
      'Injection IV lente pour limiter le risque d\'hypotension/sédation brutale',
    ],
    pediatricBolus: DoseRange(min: 0.1, max: 0.15, unit: DoseUnit.mgPerKg, label: 'Allergie enfant', maxAbsoluteDose: 5),
    indications: [
      'Traitement adjuvant de l\'anaphylaxie peropératoire (après adrénaline IM/IV et remplissage vasculaire)',
      'Réaction allergique cutanéo-muqueuse (urticaire, prurit) peropératoire ou postopératoire',
      'Prémédication en cas d\'antécédent de réaction allergique aux produits de contraste ou au latex (protocole de prévention)',
    ],
    mechanism: 'Antagoniste compétitif des récepteurs H1 de l\'histamine (1ère génération, franchit la barrière hémato-encéphalique → sédation)',
    onset: '15–30 min IV',
    duration: '4–6h',
  ),

];
