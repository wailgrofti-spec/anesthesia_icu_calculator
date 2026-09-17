// ===========================
//  lib/data/autre/antidotes_reversion.dart
//  Categorie : ANTIDOTES / REVERSION
//  Issu de l'éclatement de other_data.dart (regroupement sous la
//  méta-catégorie "Autre" de l'écran Doses)
//  1 medicament(s)
// ===========================

import '../../../models/drug.dart';

const List<Drug> antidotesReversionDrugs = [

  Drug(
    id: 'neostigmine',
    name: 'Néostigmine',
    genericName: 'Méthylsulfate de Néostigmine',
    category: DrugCategory.other,
    therapeuticClass: 'Antidotes / Réversion',
    subCategory: 'Anticholinestérasique — Antagoniste des Curares',
    bolus: DoseRange(min: 0.03, max: 0.07, unit: DoseUnit.mgPerKg, label: 'Décurarisation', maxAbsoluteDose: 5),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Pas de perfusion'),
    bolusMethod: '0.04–0.07 mg/kg IV LENTEMENT. Associer systématiquement à l\'atropine 0.02 mg/kg ou glycopyrrolate 0.01 mg/kg (effets muscariniques).',
    infusionRate: 'Bolus unique. Pas de perfusion.',
    preparation: '0.5 mg/ml ou 2.5 mg/ml. Diluer dans 10 ml NaCl. Préparer atropine dans la même seringue ou séparément.',
    standardConcentrationMgPerMl: 0.5,
    shortWarning: 'Toujours associer à l\'atropine (bradycardie, bronchospasme). Efficace uniquement si TOF>10%.',
    warnings: [
      'Bradycardie, bronchospasme, hypersalivation si administré sans anticholinergique — toujours associer atropine ou glycopyrrolate',
      'Inefficace si curarisation profonde (TOF=0, PTC=0) — risque de re-curarisation paradoxale',
      'Efficace UNIQUEMENT si monitorage TOF >10% (au moins 1 réponse sur 4)',
      'Dose maximale : 5 mg IV (sans effet supplémentaire au-delà)',
      'Précaution en asthme ou BPCO (bronchospasme par effets muscariniques)',
      'Remplacé par sugammadex pour rocuronium/vecuronium — réserver à l\'atracurium/cisatracurium',
    ],
    indications: [
      'Antagonisme des curares non dépolarisants (atracurium, cisatracurium)',
      'Myasthénie gravis (traitement symptomatique)',
    ],
    mechanism: 'Inhibition réversible de l\'acétylcholinestérase → accumulation d\'ACh à la jonction neuromusculaire',
    onset: '5–10 min',
    duration: '30–90 min',
  ),

];
