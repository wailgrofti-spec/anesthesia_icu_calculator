// ===========================
//  lib/data/autre/antiviraux.dart
//  Categorie : ANTIVIRAUX
//  Créé pour lier les pathologies virales (zona, herpès, varicelle, grippe)
// ===========================

import '../../../models/drug.dart';

const List<Drug> antiviralDrugs = [

  Drug(
    id: 'aciclovir',
    name: 'Aciclovir',
    genericName: 'Aciclovir',
    category: DrugCategory.other,
    therapeuticClass: 'Antiviraux',
    subCategory: 'Antiviral — Inhibiteur de l\'ADN polymérase virale (Herpèsviridae)',
    bolus: DoseRange(min: 5.0, max: 10.0, unit: DoseUnit.mgPerKg, label: 'Bolus IV toutes les 8h'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Pas de perfusion continue — administration discontinue q8h'),
    bolusMethod: 'IV lente sur 1h (perfusion, pas de bolus rapide). 5-10 mg/kg q8h selon l\'indication et la fonction rénale.',
    infusionRate: 'Non applicable — administration en perfusion courte (1h) répétée toutes les 8h, jamais en continu.',
    preparation: 'Poudre à reconstituer, diluer à ≤5 mg/ml. Hydratation associée obligatoire (prévention néphrotoxicité).',
    standardConcentrationMgPerMl: 5.0,
    shortWarning: 'Néphrotoxicité si perfusion rapide ou déshydratation — hydratation associée obligatoire. Adapter à la fonction rénale.',
    warnings: [
      'Néphrotoxicité par cristallisation tubulaire si perfusion trop rapide ou patient déshydraté — hydratation IV concomitante obligatoire',
      'Adapter la dose et l\'intervalle à la clairance de la créatinine',
      'Neurotoxicité (confusion, tremblements) possible en cas de surdosage ou d\'insuffisance rénale non ajustée',
    ],
    indications: [
      'Zona (surtout si ophtalmique ou chez l\'immunodéprimé)',
      'Herpès (formes sévères, disséminées ou chez l\'immunodéprimé)',
      'Varicelle compliquée ou chez l\'adulte/l\'immunodéprimé',
    ],
    mechanism: 'Analogue nucléosidique — inhibition sélective de l\'ADN polymérase virale après phosphorylation par la thymidine kinase virale',
    onset: 'Effet clinique en 24-48h',
    duration: 'Traitement 5-10 jours selon indication',
  ),

  Drug(
    id: 'oseltamivir',
    name: 'Oseltamivir',
    genericName: 'Oseltamivir phosphate (Tamiflu®)',
    category: DrugCategory.other,
    therapeuticClass: 'Antiviraux',
    subCategory: 'Antiviral — Inhibiteur de la neuraminidase (Influenza)',
    bolus: DoseRange(min: 75.0, max: 75.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — dose fixe adulte (mg), 2x/jour'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive'),
    bolusMethod: 'PO : 75 mg x2/j pendant 5 jours, à débuter idéalement dans les 48h suivant le début des symptômes.',
    infusionRate: 'Non applicable — pas de forme IV, voie orale uniquement.',
    preparation: 'Gélules 75 mg ou suspension buvable. Adapter la dose si clairance créatinine <60 ml/min.',
    shortWarning: 'Efficacité maximale si débuté dans les 48h suivant le début des symptômes. Adapter si insuffisance rénale.',
    warnings: [
      'Efficacité clinique significativement réduite si débuté après 48h d\'évolution',
      'Adapter la posologie en cas d\'insuffisance rénale (clairance <60 ml/min)',
      'Nausées/vomissements fréquents — prise au cours d\'un repas recommandée',
    ],
    pediatricNotes: 'Dose pédiatrique pondérale (2-4 mg/kg x2/j selon le poids, formes pédiatriques disponibles).',
    indications: [
      'Grippe (Influenza A/B), traitement curatif si <48h ou prophylaxie post-exposition chez sujet à risque',
    ],
    mechanism: 'Inhibiteur sélectif de la neuraminidase virale — bloque la libération des virions et la propagation intercellulaire',
    onset: 'Réduction de la durée des symptômes de ~24-36h si débuté précocement',
    duration: 'Traitement 5 jours',
  ),

];
