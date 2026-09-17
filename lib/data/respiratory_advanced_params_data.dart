// ============================================================================
//  lib/data/respiratory_advanced_params_data.dart
//  NOUVEAU — Fiches pédagogiques des "Paramètres avancés" (mécanique
//  respiratoire), sur le même modèle que respiratory_detail_data.dart.
//  N'ALTÈRE AUCUN FICHIER EXISTANT — purement additif.
// ============================================================================

import 'package:flutter/material.dart';
import '../models/respiratory_param_detail.dart';

final Map<String, RespiratoryParamDetail> respiratoryAdvancedParamDetails = {
  // ══════════════════════════════════════════════════════════
  //  COMPLIANCE STATIQUE (Cstat)
  // ══════════════════════════════════════════════════════════
  'cstat': const RespiratoryParamDetail(
    title: 'Compliance Statique (Cstat)',
    subtitle: 'Distensibilité du système respiratoire',
    color: Color(0xFF0D9488),
    icon: Icons.air_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La compliance statique mesure la distensibilité du poumon et de la '
        'paroi thoracique en l\'absence de flux (pause inspiratoire). '
        'Cstat = Vt / (Pplat − PEEP).',
    physiology:
        'Reflète les propriétés élastiques du parenchyme pulmonaire et de la '
        'cage thoracique. Une compliance basse traduit un poumon "rigide" '
        '(SDRA, œdème, fibrose, épanchement) ou une paroi peu extensible '
        '(obésité, distension abdominale, pneumothorax compressif).',
    clinicalGoal:
        'Évaluer la mécanique pulmonaire pour adapter le Vt et la PEEP, et '
        'suivre l\'évolution d\'une pathologie pulmonaire dans le temps.',
    normalValues: '60 - 100 mL/cmH₂O chez l\'adulte sain sous ventilation contrôlée',
    howToCalculate: 'Cstat = Vt (mL) ÷ (Pression plateau − PEEP), mesurée en pause inspiratoire ≥ 0,5 s',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Une compliance normale confirme un poumon extensible et un Vt bien '
        'toléré pour les pressions appliquées ; une compliance basse impose '
        'de réduire le Vt et de réévaluer la PEEP.',
    whyBullets: ['Guide l\'ajustement du Vt', 'Détecte une aggravation pulmonaire précoce'],
    recommendedValueLabel: 'CIBLE NORMALE (mise à l\'échelle du PBW)',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'mL/cmH₂O',
    recommendedValueNote: '≈ 0,6 mL/cmH₂O par kg de poids de référence',
    benefits: [PhysiologicalEffect('Permet de distinguer atteinte pulmonaire (SDRA) et atteinte pariétale (obésité)')],
    risks: [PhysiologicalEffect('Compliance surestimée si fuite ou pause inspiratoire trop courte')],
    whenToIncrease: ['Non applicable — la compliance est mesurée, pas réglée'],
    whenToDecrease: ['Non applicable — la compliance est mesurée, pas réglée'],
    commonErrors: [
      'Mesurer la Cstat sans plateau de pause inspiratoire vrai (flux non nul)',
      'Confondre compliance statique et dynamique',
      'Oublier de corriger pour l\'auto-PEEP (Cstat = Vt / (Pplat − PEEP totale))',
    ],
    specialCases: [
      'SDRA : compliance effondrée, souvent < 40 mL/cmH₂O',
      'Obésité : compliance pariétale basse, compliance pulmonaire souvent conservée',
      'BPCO : compliance pulmonaire parfois augmentée (destruction élastique) mais piégeage gazeux',
    ],
    practicalTips: [
      'Toujours mesurer sur un patient bien synchronisé, sans effort actif',
      'Répéter la mesure après chaque changement significatif de PEEP',
    ],
    adjustmentTitle: 'INTERPRÉTATION',
    adjustmentTable: [
      AdjustmentTableRow('Cstat basse + Praw normale', 'Cause pulmonaire ou pariétale (SDRA, obésité)'),
      AdjustmentTableRow('Cstat basse ET Praw haute', 'Cause mixte — réévaluer l\'ensemble du circuit'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.show_chart, title: 'Courbe pression-volume', subtitle: 'Rechercher une inflexion (surdistension)'),
    ],
    footerNote: 'Source : Miller\'s Anesthesia 9e éd. ; Tobin, Principles and Practice of Mechanical Ventilation',
    sources: [
      'Tobin MJ. Principles and Practice of Mechanical Ventilation, 3e éd.',
      'Miller\'s Anesthesia, 9e éd. — Mécanique respiratoire',
      'Marino PL. The ICU Book, 4e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  COMPLIANCE DYNAMIQUE (Cdyn)
  // ══════════════════════════════════════════════════════════
  'cdyn': const RespiratoryParamDetail(
    title: 'Compliance Dynamique (Cdyn)',
    subtitle: 'Distensibilité en présence de flux',
    color: Color(0xFF0EA5E9),
    icon: Icons.waves_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La compliance dynamique intègre, en plus de l\'élasticité '
        'pulmonaire, la résistance des voies aériennes puisqu\'elle est '
        'mesurée à la pression de crête (Ppic) et non à la pression plateau. '
        'Cdyn = Vt / (Ppic − PEEP).',
    physiology:
        'Toujours inférieure à la compliance statique. L\'écart entre Cdyn '
        'et Cstat est proportionnel à la résistance des voies aériennes.',
    clinicalGoal: 'Dépister une composante obstructive (bronchospasme, bouchon, sonde coudée).',
    normalValues: '40 - 80 mL/cmH₂O chez l\'adulte sain',
    howToCalculate: 'Cdyn = Vt (mL) ÷ (Pression de crête − PEEP)',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Comparée à la Cstat, elle permet de séparer une cause restrictive d\'une cause obstructive.',
    whyBullets: ['Diagnostic différentiel restrictif/obstructif', 'Suivi simple, sans pause inspiratoire nécessaire'],
    recommendedValueLabel: 'CIBLE NORMALE (mise à l\'échelle du PBW)',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'mL/cmH₂O',
    recommendedValueNote: '≈ 55-80 % de la compliance statique attendue',
    benefits: [PhysiologicalEffect('Mesure simple, disponible en continu sur la plupart des ventilateurs')],
    risks: [PhysiologicalEffect('Non spécifique si mesurée seule, sans comparaison à la Cstat')],
    whenToIncrease: ['Non applicable — grandeur mesurée'],
    whenToDecrease: ['Non applicable — grandeur mesurée'],
    commonErrors: ['Interpréter la Cdyn isolément sans la comparer à la Cstat'],
    specialCases: [
      'Bronchospasme (asthme, BPCO) : chute isolée de la Cdyn, Cstat conservée',
      'SDRA : chute conjointe de Cdyn et Cstat',
    ],
    practicalTips: ['Un écart Ppic-Pplat > 5-10 cmH₂O oriente vers une composante résistive dominante'],
    adjustmentTitle: 'INTERPRÉTATION',
    adjustmentTable: [
      AdjustmentTableRow('Cdyn basse, Cstat normale', 'Cause obstructive (bronchospasme, sécrétions, sonde coudée)'),
      AdjustmentTableRow('Cdyn et Cstat basses', 'Cause restrictive/mixte (SDRA, œdème)'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.show_chart, title: 'Écart Ppic − Pplat', subtitle: 'Reflet direct de la composante résistive'),
    ],
    footerNote: 'Source : Tobin, Principles and Practice of Mechanical Ventilation',
    sources: [
      'Tobin MJ. Principles and Practice of Mechanical Ventilation, 3e éd.',
      'Egan\'s Fundamentals of Respiratory Care',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  RÉSISTANCE DES VOIES AÉRIENNES (Raw)
  // ══════════════════════════════════════════════════════════
  'raw': const RespiratoryParamDetail(
    title: 'Résistance des Voies Aériennes (Raw)',
    subtitle: 'Opposition au débit gazeux',
    color: Color(0xFF6366F1),
    icon: Icons.filter_alt_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La résistance des voies aériennes s\'oppose au débit gazeux durant '
        'l\'inspiration et l\'expiration. Raw = (Ppic − Pplat) / Débit inspiratoire.',
    physiology:
        'Dépend du calibre des voies aériennes (bronches, sonde d\'intubation) '
        'et suit la loi de Poiseuille : la résistance varie en 1/rayon⁴ — un '
        'petit changement de diamètre modifie fortement la résistance.',
    clinicalGoal: 'Détecter un bronchospasme, un bouchon muqueux ou une sonde coudée/trop fine.',
    normalValues: '≈ 5 - 15 cmH₂O/L/s chez l\'adulte intubé (sonde standard)',
    howToCalculate: 'Raw = (Pression de crête − Pression plateau) ÷ Débit inspiratoire (L/s)',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Une résistance élevée majore le travail respiratoire et favorise le piégeage gazeux (auto-PEEP).',
    whyBullets: ['Oriente vers une cause obstructive', 'Guide le traitement bronchodilatateur'],
    recommendedValueLabel: 'PLAGE NORMALE ATTENDUE',
    recommendedValue: '5 - 15',
    recommendedValueBadge: 'cmH₂O/L/s',
    recommendedValueNote: 'Plus élevée en pédiatrie (sonde de plus petit diamètre)',
    benefits: [PhysiologicalEffect('Identification rapide d\'une obstruction du circuit ou des voies aériennes')],
    risks: [PhysiologicalEffect('Résistance élevée non corrigée → auto-PEEP, travail respiratoire excessif')],
    whenToIncrease: ['Non applicable — grandeur mesurée, pas réglée'],
    whenToDecrease: [
      'Aspiration des sécrétions',
      'Bronchodilatateurs (bêta-2 agonistes, anticholinergiques) si bronchospasme',
      'Vérifier/repositionner une sonde coudée ou de diamètre insuffisant',
    ],
    commonErrors: ['Ne pas différencier résistance du circuit/sonde et résistance des voies aériennes du patient'],
    specialCases: [
      'BPCO/asthme : résistance très élevée, risque majeur d\'auto-PEEP',
      'Pédiatrie : sonde fine → résistance physiologiquement plus élevée',
    ],
    practicalTips: ['Toujours réévaluer la Raw après aspiration ou changement de sonde'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Raw élevée + sibilants', 'Bronchodilatateurs, réévaluer la sédation'),
      AdjustmentTableRow('Raw élevée + sécrétions visibles', 'Aspiration trachéale'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.compress_rounded, title: 'Écart Ppic − Pplat', subtitle: 'Augmente proportionnellement à la Raw'),
    ],
    footerNote: 'Source : ERS/ATS BPCO ; Egan\'s Fundamentals of Respiratory Care',
    sources: [
      'ERS/ATS Guidelines — Chronic Obstructive Pulmonary Disease',
      'Egan\'s Fundamentals of Respiratory Care',
      'AARC Clinical Practice Guidelines',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  PRESSION MOYENNE DES VOIES AÉRIENNES (Pmean)
  // ══════════════════════════════════════════════════════════
  'pmean': const RespiratoryParamDetail(
    title: 'Pression Moyenne (Pmean)',
    subtitle: 'Pression moyenne des voies aériennes sur le cycle',
    color: Color(0xFF8B5CF6),
    icon: Icons.speed_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La pression moyenne des voies aériennes est la moyenne de la '
        'pression sur l\'ensemble du cycle respiratoire (inspiration + '
        'expiration). Elle est un déterminant majeur de l\'oxygénation et '
        'du retentissement hémodynamique de la ventilation.',
    physiology:
        'Augmente avec la PEEP, la pression inspiratoire, le temps '
        'inspiratoire (I:E) et la FR. Corrélée à l\'oxygénation (via le '
        'recrutement alvéolaire) et au retour veineux (impact hémodynamique).',
    clinicalGoal: 'Optimiser l\'oxygénation tout en limitant le retentissement hémodynamique et le barotraumatisme.',
    normalValues: '5 - 15 cmH₂O en ventilation conventionnelle protectrice',
    howToCalculate:
        'Pmean ≈ PEEP + (Pinsp au-dessus de la PEEP) × (Ti / temps de cycle total) '
        '— estimation à partir des réglages cibles calculés',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Une Pmean plus élevée améliore souvent l\'oxygénation mais augmente le risque hémodynamique et de barotraumatisme.',
    whyBullets: ['Reflet global de l\'exposition pulmonaire à la pression', 'Utile pour comparer VCV/VPC/modes à I:E inversé'],
    recommendedValueLabel: 'ESTIMATION (à partir des réglages calculés)',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: 'Estimée — à corréler à la valeur réellement mesurée par le ventilateur',
    benefits: [PhysiologicalEffect('Meilleur reflet global que la Pplat seule pour l\'oxygénation en VPC/I:E inversé')],
    risks: [PhysiologicalEffect('Pmean élevée → baisse du retour veineux, hypotension, risque de barotraumatisme')],
    whenToIncrease: [
      'Hypoxémie réfractaire malgré FiO₂ élevée',
      'SDRA modéré à sévère (sous surveillance hémodynamique stricte)',
    ],
    whenToDecrease: [
      'Instabilité hémodynamique',
      'Barotraumatisme (pneumothorax, emphysème sous-cutané)',
    ],
    commonErrors: ['Augmenter la Pmean sans surveiller la tolérance hémodynamique'],
    specialCases: ['SDRA sévère : Pmean cible souvent plus élevée sous surveillance rapprochée'],
    practicalTips: ['Toute augmentation de la Pmean doit être accompagnée d\'une surveillance de la PAM/débit cardiaque'],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Hypoxémie persistante', 'Augmenter la PEEP ou le temps inspiratoire (I:E)'),
      AdjustmentTableRow('Hypotension', 'Réévaluer la PEEP et le remplissage vasculaire'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.favorite, title: 'Hémodynamique', subtitle: 'PAM, fréquence cardiaque, diurèse'),
    ],
    footerNote: 'Source : Tobin, Principles and Practice of Mechanical Ventilation ; SFAR SDRA',
    sources: [
      'Tobin MJ. Principles and Practice of Mechanical Ventilation, 3e éd.',
      'ESICM ARDS Guidelines',
      'SFAR/SRLF Recommandations SDRA',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  AUTO-PEEP (PEEP INTRINSÈQUE)
  // ══════════════════════════════════════════════════════════
  'autopeep': const RespiratoryParamDetail(
    title: 'Auto-PEEP (PEEP intrinsèque)',
    subtitle: 'Piégeage gazeux / hyperinflation dynamique',
    color: Color(0xFFEF4444),
    icon: Icons.warning_amber_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'auto-PEEP est une pression résiduelle positive dans les alvéoles '
        'en fin d\'expiration, due à une vidange pulmonaire incomplète avant '
        'le cycle suivant (temps expiratoire insuffisant et/ou résistance élevée).',
    physiology:
        'Résulte d\'un déséquilibre entre le temps expiratoire disponible et '
        'la constante de temps pulmonaire (résistance × compliance). '
        'Favorisée par une FR élevée, un I:E court et une résistance élevée (BPCO, asthme).',
    clinicalGoal: 'Prévenir l\'hyperinflation dynamique, ses conséquences hémodynamiques et le risque de barotraumatisme.',
    normalValues: '0 - 2 cmH₂O chez le sujet sans pathologie obstructive',
    howToCalculate: 'Mesurée par pause expiratoire prolongée (occlusion en fin d\'expiration) sur le ventilateur',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Une auto-PEEP élevée non détectée expose à l\'hypotension, au barotraumatisme et fausse les calculs de compliance/driving pressure.',
    whyBullets: ['Prévention du barotraumatisme et du collapsus hémodynamique', 'Nécessaire pour un calcul correct de la Cstat/driving pressure'],
    recommendedValueLabel: 'CIBLE NORMALE',
    recommendedValue: '0 - 2',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: 'Toute valeur significative doit être corrigée activement',
    benefits: [PhysiologicalEffect('Sa détection précoce permet d\'éviter le collapsus hémodynamique par hyperinflation')],
    risks: [PhysiologicalEffect('Non détectée → hypotension brutale, barotraumatisme, sous-estimation de la PEEP totale')],
    whenToIncrease: ['Non applicable — l\'objectif est toujours de la minimiser'],
    whenToDecrease: [
      'Diminuer la FR pour allonger le temps expiratoire',
      'Allonger le rapport I:E (ex. 1:3 ou plus en BPCO/asthme)',
      'Bronchodilatateurs si composante obstructive',
      'Réduire le Vt si compatible avec les objectifs de CO₂',
    ],
    commonErrors: [
      'Oublier de rechercher une auto-PEEP chez un patient BPCO/asthmatique instable',
      'Calculer la driving pressure sans intégrer la PEEP totale (PEEP réglée + auto-PEEP)',
    ],
    specialCases: [
      'BPCO/asthme aigu grave : risque majeur, surveillance systématique',
      'FR élevée en SDRA : risque d\'auto-PEEP si temps expiratoire insuffisant',
    ],
    practicalTips: ['En cas d\'arrêt cardio-circulatoire brutal sous ventilation, déconnecter le circuit pour éliminer une hyperinflation dynamique en urgence'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Auto-PEEP > 2-3 cmH₂O', 'Diminuer FR, allonger le temps expiratoire'),
      AdjustmentTableRow('Instabilité hémodynamique brutale sous ventilation', 'Déconnexion transitoire du circuit (test diagnostique et thérapeutique)'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.show_chart, title: 'Courbe de débit', subtitle: 'Débit expiratoire ne revenant pas à zéro avant le cycle suivant'),
      MonitoringPoint(icon: Icons.favorite, title: 'Hémodynamique', subtitle: 'Surveiller la PAM, signes de tamponnade gazeuse'),
    ],
    footerNote: 'Source : Nunn\'s Applied Respiratory Physiology ; ERS/ATS BPCO',
    sources: [
      'Nunn\'s Applied Respiratory Physiology, 8e éd.',
      'ERS/ATS Guidelines — COPD',
      'Marino PL. The ICU Book, 4e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  MECHANICAL POWER
  // ══════════════════════════════════════════════════════════
  'mpower': const RespiratoryParamDetail(
    title: 'Mechanical Power (Puissance Mécanique)',
    subtitle: 'Énergie totale transférée au poumon par minute',
    color: Color(0xFFF59E0B),
    icon: Icons.bolt_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'Le Mechanical Power regroupe en un seul indice l\'ensemble des '
        'déterminants de la lésion pulmonaire induite par la ventilation '
        '(Vt, pression, débit, FR, PEEP). Il quantifie l\'énergie totale '
        'transférée au système respiratoire par unité de temps.',
    physiology:
        'Intègre le travail élastique (Vt × driving pressure) et résistif '
        '(débit × résistance), répété à chaque cycle et multiplié par la FR — '
        'la FR et le Vt sont les déterminants les plus puissants du Mechanical Power.',
    clinicalGoal: 'Limiter l\'énergie totale délivrée au poumon pour réduire le risque de lésion pulmonaire induite par la ventilation (VILI).',
    normalValues: 'Seuil de vigilance validé : ≥ 17-20 J/min associé à une surmortalité en réanimation',
    howToCalculate:
        'Formule simplifiée (mode contrôlé) : MP (J/min) = 0,098 × FR × Vt(L) × '
        '[Ppic − 0,5 × Driving Pressure] — estimée ici à partir des réglages cibles calculés',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Un Mechanical Power élevé est associé de façon indépendante à une surmortalité chez le patient de réanimation, y compris hors SDRA.',
    whyBullets: ['Synthétise en un seul chiffre le risque global de VILI', 'Utile pour arbitrer entre stratégies Vt/FR/PEEP'],
    recommendedValueLabel: 'ESTIMATION (à partir des réglages calculés)',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'J/min',
    recommendedValueNote: 'Objectif : rester sous le seuil de vigilance de 17 J/min',
    benefits: [PhysiologicalEffect('Vision synthétique et quantifiée du risque de lésion induite par la ventilation')],
    risks: [PhysiologicalEffect('Mechanical Power élevé (≥ 17 J/min) → association indépendante à la mortalité (Serpa Neto 2018)')],
    whenToIncrease: ['Non applicable — l\'objectif est toujours de le minimiser à échanges gazeux équivalents'],
    whenToDecrease: [
      'Réduire le Vt vers 6 mL/kg PBW en priorité',
      'Limiter la FR au strict nécessaire pour la cible de CO₂',
      'Optimiser la PEEP pour limiter la driving pressure',
      'Limiter le débit inspiratoire de crête si possible',
    ],
    commonErrors: [
      'Augmenter la FR pour compenser une réduction de Vt sans recalculer le Mechanical Power',
      'Considérer uniquement le Vt et ignorer la contribution de la FR',
    ],
    specialCases: [
      'SDRA : cible de Mechanical Power particulièrement surveillée',
      'Ventilation prolongée : effet cumulatif à surveiller sur la durée',
    ],
    practicalTips: ['La FR et le Vt ont l\'impact le plus important sur le Mechanical Power — à optimiser en priorité avant la PEEP ou le débit'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Mechanical Power ≥ 17 J/min', 'Réévaluer prioritairement Vt et FR'),
      AdjustmentTableRow('Mechanical Power élevé malgré Vt/FR optimisés', 'Réévaluer la PEEP et le débit inspiratoire'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.bolt_rounded, title: 'Recalcul à chaque changement de réglage', subtitle: 'Vt, FR, PEEP, pressions'),
    ],
    footerNote: 'Source : Gattinoni et al. Intensive Care Med 2016 ; Serpa Neto et al. Intensive Care Med 2018',
    sources: [
      'Gattinoni L, et al. "Ventilator-related causes of lung injury: the mechanical power." Intensive Care Med. 2016;42(10):1567-1575.',
      'Serpa Neto A, et al. "Mechanical power of ventilation is associated with mortality in critically ill patients." Intensive Care Med. 2018;44(11):1914-1922.',
      'ESICM ARDS Guidelines',
    ],
  ),
};
