// ===========================
//  lib/data/autre/divers_support.dart
//  Categorie : DIVERS / SUPPORT
//  Créé pour lier œdèmes, rétention urinaire, RGO, goitre,
//  ictère néonatal, intoxication au monoxyde de carbone
// ===========================

import '../../../models/drug.dart';

const List<Drug> diversSupportifsDrugs = [

  Drug(
    id: 'furosemide',
    name: 'Furosémide',
    genericName: 'Furosémide',
    category: DrugCategory.other,
    therapeuticClass: 'Divers / Support',
    subCategory: 'Diurétique de l\'Anse',
    bolus: DoseRange(min: 0.5, max: 1.0, unit: DoseUnit.mgPerKg, label: 'Bolus IV — œdèmes/surcharge hydrosodée', maxAbsoluteDose: 80),
    infusion: DoseRange(min: 0.05, max: 0.4, unit: DoseUnit.mgPerKgH, label: 'Perfusion continue si surcharge sévère/résistance aux bolus'),
    bolusMethod: 'IV lente (≥1-2 min pour limiter l\'ototoxicité). Titration selon la réponse diurétique et la tolérance hémodynamique.',
    infusionRate: 'Perfusion continue possible en cas de surcharge sévère ou de résistance aux bolus répétés — sous surveillance ionique rapprochée.',
    preparation: '10 mg/ml. Prêt à l\'emploi IV, dilution possible dans NaCl 0.9%.',
    standardConcentrationMgPerMl: 10.0,
    shortWarning: 'Hypokaliémie, hypovolémie si excès. Ototoxicité si injection IV rapide à forte dose. Surveiller l\'ionogramme.',
    warnings: [
      'Hypokaliémie, hyponatrémie, alcalose métabolique — surveillance ionique régulière si utilisation répétée',
      'Ototoxicité (réversible) si injection IV rapide à forte dose — injecter lentement',
      'Risque d\'hypovolémie et d\'hypotension si diurèse excessive — évaluer la volémie avant traitement',
    ],
    indications: [
      'Œdèmes d\'origine cardiaque, rénale ou hépatique',
      'Surcharge hydrosodée périopératoire',
    ],
    mechanism: 'Inhibition du cotransporteur Na⁺/K⁺/2Cl⁻ de la branche ascendante de l\'anse de Henlé',
    onset: '5 min IV',
    duration: '2-3h',
  ),

  Drug(
    id: 'tamsulosine',
    name: 'Tamsulosine',
    genericName: 'Tamsulosine chlorhydrate',
    category: DrugCategory.other,
    therapeuticClass: 'Divers / Support',
    subCategory: 'Alpha-1 Bloquant Sélectif Urologique',
    bolus: DoseRange(min: 0.4, max: 0.4, unit: DoseUnit.unitsFixed, label: 'Voie orale — dose fixe (mg/j), traitement de fond'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable — voie orale exclusive'),
    bolusMethod: 'PO 1x/jour, traitement de fond (pas d\'administration en urgence pour un épisode de rétention aiguë, qui nécessite un sondage évacuateur en 1er lieu).',
    infusionRate: 'Non applicable — voie orale exclusive.',
    preparation: 'Gélules à libération prolongée, à prendre après le petit-déjeuner.',
    shortWarning: 'Hypotension orthostatique, notamment à l\'introduction — risque majoré en association avec les anesthésiques. Syndrome de l\'iris flasque peropératoire (chirurgie de la cataracte).',
    warnings: [
      'Hypotension orthostatique, surtout à l\'instauration du traitement — prudence en association avec les agents anesthésiques hypotenseurs',
      'Syndrome de l\'iris flasque peropératoire (IFIS) décrit en chirurgie de la cataracte — informer l\'ophtalmologiste du traitement en cours',
    ],
    indications: [
      'Rétention urinaire sur hypertrophie bénigne de la prostate — facilite la reprise des mictions après sondage évacuateur',
    ],
    mechanism: 'Antagoniste sélectif des récepteurs alpha-1A adrénergiques du col vésical et de la prostate — relâchement du muscle lisse',
    onset: 'Quelques heures, effet complet en 1-2 semaines',
    duration: 'Traitement de fond au long cours',
  ),

  Drug(
    id: 'omeprazole',
    name: 'Oméprazole',
    genericName: 'Oméprazole',
    category: DrugCategory.other,
    therapeuticClass: 'Divers / Support',
    subCategory: 'Inhibiteur de la Pompe à Protons',
    bolus: DoseRange(min: 40.0, max: 40.0, unit: DoseUnit.unitsFixed, label: 'IV/PO — dose fixe (mg), 1-2x/j'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Non utilisé en perfusion continue standard'),
    bolusMethod: 'IV lente ou PO, 40 mg 1-2x/jour selon l\'indication. Prémédication possible avant induction si RGO sévère/estomac plein à risque (réduction du volume et de l\'acidité gastrique).',
    infusionRate: 'Non utilisé en perfusion continue en pratique courante — administration discontinue.',
    preparation: 'Poudre à reconstituer pour IV, ou gélules gastro-résistantes PO.',
    shortWarning: 'Bien toléré. Interactions avec certains antiviraux (réduction d\'absorption si prise concomitante à forte dose).',
    warnings: [
      'Réduit l\'absorption de certains antiviraux à action directe (ex : velpatasvir) si co-administration à forte dose',
      'Utilisation prolongée associée à un risque accru d\'infections digestives et de fractures ostéoporotiques (usage chronique uniquement)',
    ],
    indications: [
      'Reflux gastro-œsophagien',
      'Prémédication de réduction du volume/acidité gastrique avant anesthésie si RGO sévère ou estomac plein à risque',
      'Ulcère gastro-duodénal (protection gastrique)',
    ],
    mechanism: 'Inhibition irréversible de la pompe à protons H⁺/K⁺-ATPase des cellules pariétales gastriques',
    onset: '1-2h (effet maximal après plusieurs jours en traitement chronique)',
    duration: '24h (effet sur la sécrétion acide)',
  ),

  Drug(
    id: 'levothyroxine',
    name: 'Lévothyroxine',
    genericName: 'Lévothyroxine sodique',
    category: DrugCategory.other,
    therapeuticClass: 'Divers / Support',
    subCategory: 'Hormone Thyroïdienne de Substitution',
    bolus: DoseRange(min: 1.0, max: 1.0, unit: DoseUnit.unitsFixed, label: 'Voie orale — dose individualisée (mcg/j), traitement de fond'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Non applicable en pratique courante — traitement oral chronique'),
    bolusMethod: 'PO 1x/jour à jeun, dose individualisée selon le poids et la TSH. Poursuivre le matin de la chirurgie avec un peu d\'eau (jeûne non rompu).',
    infusionRate: 'Non applicable — traitement de fond oral, forme IV réservée au coma myxœdémateux (hors administration standard).',
    preparation: 'Comprimés, dose individualisée. Absorption réduite si prise concomitante de calcium, fer ou IPP.',
    shortWarning: 'Ne jamais interrompre en périopératoire (long délai d\'action, la demi-vie longue tolère un oubli ponctuel mais pas un arrêt prolongé).',
    warnings: [
      'Poursuivre impérativement en périopératoire — la longue demi-vie (7 jours) tolère un report ponctuel mais pas un arrêt prolongé',
      'Surdosage : tachycardie, agitation (se référer à \'Hyperthyroïdie\' pour la prise en charge)',
      'Sous-dosage prolongé : risque de coma myxœdémateux (se référer à \'Hypothyroïdie\')',
    ],
    indications: [
      'Goitre avec hypothyroïdie associée — traitement substitutif',
      'Hypothyroïdie (traitement de référence)',
    ],
    mechanism: 'Hormone thyroïdienne de substitution (T4) — conversion périphérique en T3 active',
    onset: 'Effet clinique en 1-2 semaines, équilibre en 6-8 semaines',
    duration: 'Traitement à vie dans la majorité des cas',
  ),

  Drug(
    id: 'immunoglobuline_iv_polyvalente',
    name: 'Immunoglobulines IV Polyvalentes',
    genericName: 'Immunoglobulines humaines normales IV',
    category: DrugCategory.other,
    therapeuticClass: 'Divers / Support',
    subCategory: 'Immunothérapie — Maladie Hémolytique du Nouveau-né',
    bolus: DoseRange(min: 0.5, max: 1.0, unit: DoseUnit.mgPerKg, label: 'Perfusion IV — g/kg, dose unique ou répétée'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Perfusion unique lente, pas de perfusion continue prolongée'),
    bolusMethod: 'Perfusion IV lente et progressive (débit croissant par paliers selon tolérance), 0.5-1 g/kg en perfusion unique, répétable à 12h si besoin.',
    infusionRate: 'Perfusion progressive sur plusieurs heures — débit initial lent, augmenté par paliers selon la tolérance clinique.',
    preparation: 'Solution prête à l\'emploi ou poudre à reconstituer selon la spécialité, conservation au réfrigérateur.',
    shortWarning: 'Réservé aux formes sévères d\'ictère par incompatibilité materno-fœtale (allo-immunisation) réfractaires à la photothérapie seule.',
    warnings: [
      'Réactions liées à la perfusion (fièvre, frissons) — ralentir ou arrêter la perfusion si survenue',
      'Ne remplace pas la photothérapie — traitement adjuvant dans les formes sévères d\'hémolyse par allo-immunisation (incompatibilité Rh/ABO)',
    ],
    indications: [
      'Ictère néonatal sévère par maladie hémolytique du nouveau-né (allo-immunisation Rh/ABO), en complément de la photothérapie intensive',
    ],
    mechanism: 'Blocage compétitif des récepteurs Fc du système réticulo-endothélial — réduit l\'hémolyse par les anticorps maternels',
    onset: 'Quelques heures (réduction de la vitesse de progression de la bilirubine)',
    duration: 'Dose unique, répétable selon évolution',
  ),

  Drug(
    id: 'oxygene_medical',
    name: 'Oxygène Médical',
    genericName: 'Oxygène médical (O₂)',
    category: DrugCategory.other,
    therapeuticClass: 'Divers / Support',
    subCategory: 'Gaz Médical — Traitement de Référence Intoxication au CO',
    bolus: DoseRange(min: 100.0, max: 100.0, unit: DoseUnit.unitsFixed, label: 'FiO2 100% — administration continue au masque à haute concentration'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Administration continue tant que nécessaire, pas de "perfusion" au sens médicamenteux'),
    bolusMethod: 'Administration au masque à haute concentration (FiO2 proche de 100%) dès la suspicion diagnostique, poursuivie jusqu\'à normalisation de la carboxyhémoglobine (HbCO) et disparition des symptômes.',
    infusionRate: 'Administration continue en FiO2 100% — durée guidée par la clinique et la décroissance de l\'HbCO (plusieurs heures habituellement).',
    preparation: 'Gaz médical en bouteille ou réseau mural, masque à haute concentration avec réservoir.',
    shortWarning: 'Réduit la demi-vie de l\'HbCO de ~5h (air ambiant) à ~1-1.5h (FiO2 100%). L\'oxygénothérapie hyperbare peut être discutée dans les formes sévères.',
    warnings: [
      'La SpO2 mesurée par saturomètre standard reste faussement normale — ne pas se fier à ce paramètre pour évaluer l\'efficacité du traitement, se fier à l\'HbCO',
      'Oxygénothérapie hyperbare à discuter en centre spécialisé si troubles de conscience, grossesse ou HbCO très élevée',
    ],
    indications: [
      'Intoxication au monoxyde de carbone — traitement de référence de 1ère intention',
    ],
    mechanism: 'Accélère la dissociation de la carboxyhémoglobine (HbCO) en déplaçant le CO de son site de fixation sur l\'hémoglobine par compétition',
    onset: 'Immédiat (début de la décroissance de l\'HbCO)',
    duration: 'Jusqu\'à normalisation clinique et biologique',
  ),

];
