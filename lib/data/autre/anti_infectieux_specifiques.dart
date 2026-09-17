// ===========================
//  lib/data/autre/anti_infectieux_specifiques.dart
//  Categorie : ANTI-INFECTIEUX SPECIFIQUES
//  Créé pour lier VIH, hépatite B, hépatite C, rougeole, leishmaniose
// ===========================

import '../../../models/drug.dart';

const List<Drug> antiinfectieuxSpecifiquesDrugs = [

  Drug(
    id: 'ritonavir',
    name: 'Ritonavir',
    genericName: 'Ritonavir — utilisé comme "booster" pharmacocinétique (association ARV)',
    category: DrugCategory.other,
    therapeuticClass: 'Anti-infectieux Spécifiques',
    subCategory: 'Antirétroviral — Inhibiteur de Protéase / Booster CYP3A4',
    bolus: DoseRange(min: 100.0, max: 100.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — traitement de fond chronique, PAS un bolus periop'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive'),
    bolusMethod: 'PO, traitement de fond dans le cadre d\'une trithérapie antirétrovirale (jamais en monothérapie). Poursuivre en périopératoire, éviter toute interruption brutale (risque de résistance virale).',
    infusionRate: 'Non applicable — voie orale exclusive, traitement de fond au long cours.',
    preparation: 'Comprimés, à prendre au cours d\'un repas.',
    shortWarning: 'INHIBITEUR PUISSANT DU CYP3A4/2D6 — interactions majeures avec de nombreux agents d\'anesthésie (fentanyl, midazolam, certains curares). Vérifier systématiquement le traitement antirétroviral en cours.',
    warnings: [
      'Inhibiteur puissant du CYP3A4 — risque de surdosage et de prolongation d\'effet du fentanyl, midazolam, et de nombreux autres agents métabolisés par cette voie',
      'Ne représente qu\'un exemple d\'antirétroviral boosté parmi d\'autres associations possibles (trithérapie) — toujours vérifier le traitement ARV exact du patient',
      'Ne jamais interrompre le traitement antirétroviral sans avis infectiologique (risque de résistance)',
    ],
    indications: [
      'VIH — composant "booster" pharmacocinétique de nombreuses trithérapies antirétrovirales (l\'intérêt ici est avant tout la vigilance sur les interactions médicamenteuses en anesthésie)',
    ],
    mechanism: 'Inhibiteur de la protéase du VIH ; à faible dose, utilisé principalement comme inhibiteur puissant du CYP3A4 pour "booster" les concentrations d\'autres antirétroviraux',
    onset: 'Traitement de fond — pas d\'effet aigu attendu',
    duration: 'Traitement chronique au long cours',
  ),

  Drug(
    id: 'entecavir',
    name: 'Entécavir',
    genericName: 'Entécavir',
    category: DrugCategory.other,
    therapeuticClass: 'Anti-infectieux Spécifiques',
    subCategory: 'Antiviral — Analogue Nucléosidique (Hépatite B)',
    bolus: DoseRange(min: 0.5, max: 1.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — dose fixe (mg/j), traitement de fond'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive'),
    bolusMethod: 'PO 1x/jour à jeun (traitement de fond chronique). Poursuivre en périopératoire sauf avis hépatologique contraire — l\'interruption expose à une réactivation virale B parfois sévère.',
    infusionRate: 'Non applicable — voie orale exclusive.',
    preparation: 'Comprimés, à prendre à distance des repas (1h avant ou 2h après).',
    shortWarning: 'Ne jamais interrompre brutalement — risque de réactivation virale B sévère (parfois fulminante). Adapter la dose à la fonction rénale.',
    warnings: [
      'Interruption brutale à risque de réactivation virale B sévère, y compris hépatite fulminante — ne jamais arrêter sans avis spécialisé',
      'Adapter la posologie à la clairance de la créatinine',
    ],
    indications: [
      'Hépatite B chronique active',
    ],
    mechanism: 'Analogue nucléosidique de la guanosine — inhibition de la polymérase/transcriptase inverse du VHB',
    onset: 'Suppression virale progressive sur plusieurs semaines à mois',
    duration: 'Traitement au long cours, souvent à vie',
  ),

  Drug(
    id: 'sofosbuvir_velpatasvir',
    name: 'Sofosbuvir/Velpatasvir',
    genericName: 'Sofosbuvir 400mg / Velpatasvir 100mg (association fixe, Epclusa®)',
    category: DrugCategory.other,
    therapeuticClass: 'Anti-infectieux Spécifiques',
    subCategory: 'Antiviraux à Action Directe — Hépatite C (pangénotypique)',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — 1 comprimé/jour, traitement de fond'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive'),
    bolusMethod: 'PO 1 comprimé/jour pendant 12 semaines (schéma standard). Traitement curatif à visée d\'éradication virale, pas une administration périopératoire.',
    infusionRate: 'Non applicable — voie orale exclusive.',
    preparation: 'Comprimé combiné, prise unique quotidienne.',
    shortWarning: 'Traitement curatif de l\'hépatite C — pas d\'administration en urgence périopératoire. Interactions avec les inhibiteurs de la pompe à protons à forte dose.',
    warnings: [
      'Nombreuses interactions médicamenteuses (amiodarone — bradycardie sévère rapportée ; IPP à forte dose réduisent l\'absorption)',
      'Vérifier la fonction hépatique (Child-Pugh) avant et pendant le traitement',
    ],
    indications: [
      'Hépatite C chronique, tous génotypes (traitement pangénotypique de référence)',
    ],
    mechanism: 'Sofosbuvir : inhibiteur de l\'ARN polymérase NS5B. Velpatasvir : inhibiteur de la protéine NS5A. Association synergique pangénotypique',
    onset: 'Réponse virologique évaluée à S12 post-traitement',
    duration: 'Traitement 12 semaines (schéma standard)',
  ),

  Drug(
    id: 'vitamine_a',
    name: 'Vitamine A',
    genericName: 'Rétinol (palmitate de rétinol)',
    category: DrugCategory.other,
    therapeuticClass: 'Anti-infectieux Spécifiques',
    subCategory: 'Supplémentation — Adjuvant Rougeole (OMS)',
    bolus: DoseRange(min: 100000.0, max: 200000.0, unit: DoseUnit.unitsFixed, label: 'UI — dose orale unique selon âge, 2 doses à J1 et J2'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive'),
    bolusMethod: 'PO : 100 000 UI (6-11 mois) ou 200 000 UI (≥12 mois), 1 dose à J1 et 1 dose à J2 (schéma OMS), 3ème dose à 4 semaines si signes de carence oculaire.',
    infusionRate: 'Non applicable — voie orale exclusive.',
    preparation: 'Capsules molles à percer et administrer dans la bouche, ou solution buvable.',
    shortWarning: 'Recommandation OMS systématique pour tout enfant atteint de rougeole dans les zones à risque de carence en vitamine A — réduit la morbi-mortalité.',
    warnings: [
      'Ne pas dépasser le schéma recommandé — risque d\'hypervitaminose A si doses répétées hors protocole',
    ],
    indications: [
      'Rougeole chez l\'enfant — recommandation systématique OMS, réduit la sévérité et la mortalité (notamment complications oculaires et pneumonie)',
    ],
    mechanism: 'Restauration des réserves en vitamine A, déplétées lors de l\'infection rougeoleuse — rôle dans l\'immunité muqueuse et épithéliale',
    onset: 'Effet sur la sévérité clinique en quelques jours',
    duration: 'Schéma court (J1-J2, ± J28)',
  ),

  Drug(
    id: 'amphotericine_b_liposomale',
    name: 'Amphotéricine B Liposomale',
    genericName: 'Amphotéricine B liposomale (AmBisome®)',
    category: DrugCategory.other,
    therapeuticClass: 'Anti-infectieux Spécifiques',
    subCategory: 'Antifongique/Antiparasitaire IV — Leishmaniose Viscérale',
    bolus: DoseRange(min: 3.0, max: 5.0, unit: DoseUnit.mgPerKg, label: 'Perfusion IV quotidienne (traitement d\'attaque)'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Perfusion unique quotidienne sur plusieurs heures, pas de perfusion continue'),
    bolusMethod: 'Perfusion IV sur 1-2h, 1x/jour, schéma selon le protocole (ex : J1-J5 puis J14, J21 selon l\'indication et le terrain).',
    infusionRate: 'Perfusion lente sur 1-2h par jour de traitement, jamais en administration rapide.',
    preparation: 'Poudre à reconstituer puis diluer dans du G5% exclusivement (incompatible NaCl).',
    standardConcentrationMgPerMl: 2.0,
    shortWarning: 'Néphrotoxicité (moindre que la forme conventionnelle mais présente), réactions liées à la perfusion (fièvre, frissons) fréquentes au début du traitement.',
    warnings: [
      'Néphrotoxicité — surveillance de la fonction rénale et de la kaliémie/magnésémie pendant le traitement',
      'Réactions aiguës liées à la perfusion (fièvre, frissons, hypotension) — prémédication par paracétamol/antihistaminique possible',
      'Incompatible avec le NaCl — diluer exclusivement dans le glucosé 5%',
    ],
    indications: [
      'Leishmaniose viscérale — traitement de référence',
    ],
    mechanism: 'Fixation à l\'ergostérol de la membrane du parasite/champignon — formation de pores et fuite ionique cellulaire',
    onset: 'Réponse clinique en quelques jours à 1-2 semaines',
    duration: 'Schéma variable selon le protocole (typiquement 5-21 jours cumulés)',
  ),

];
