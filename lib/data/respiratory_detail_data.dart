// ============================================================================
//  lib/data/respiratory_detail_data.dart
//  Contenu pédagogique de chaque paramètre ventilatoire — affiché sur la
//  page de détail (2ème écran, ouverte au clic sur une carte de
//  respiratory_screen.dart).
//
//  Équivalent, pour les paramètres respiratoires, de drug_database.dart
//  pour les médicaments.
//
//  Sources des affirmations médicales (référencement complet — auteurs,
//  DOI, liens — livré séparément dans le document de référence final) :
//  ARDSNet (N Engl J Med. 2000;342(18):1301-8), SFAR (RFE Ventilation
//  périopératoire / SDRA), ATS/ESICM/SCCM 2017, Amato NEJM 2015 (driving
//  pressure), ERS/ATS BPCO, Miller's Anesthesia 9e éd.
// ============================================================================

import 'package:flutter/material.dart';
import '../models/respiratory_param_detail.dart';

/// Dictionnaire des détails de chaque paramètre ventilatoire.
/// Les clés correspondent aux `paramId` utilisés dans `respiratory_screen.dart`.
final Map<String, RespiratoryParamDetail> respiratoryParamDetails = {
  // ══════════════════════════════════════════════════════════
  //  VT — VOLUME COURANT
  // ══════════════════════════════════════════════════════════
  'vt': const RespiratoryParamDetail(
    title: 'Volume Courant (Vt)',
    subtitle: 'Volume d\'air par cycle',
    color: Colors.blue,
    icon: Icons.air_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'Le volume courant est le volume d\'air insufflé à chaque cycle '
        'respiratoire. Il est calculé en fonction du poids prédit (PBW).',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Pour éviter le volotrauma (surdistension) et protéger le poumon sain ou lésé.',
    whyBullets: ['Prévention du SDRA', 'Protection alvéolaire'],
    recommendedValueLabel: 'RECOMMANDATION (PBW)',
    recommendedValue: '6 - 8',
    recommendedValueBadge: 'mL/kg',
    recommendedValueNote: 'Basé sur le poids idéal',
    benefits: [PhysiologicalEffect('Réduction de la mortalité en cas de SDRA (ARDSNet)')],
    risks: [PhysiologicalEffect('Risque d\'hypercapnie permissive si compensation par la FR insuffisante')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Hypercapnie sévère', 'Augmenter le Vt jusqu\'à 8 mL/kg'),
      AdjustmentTableRow('Pressions élevées', 'Baisser le Vt jusqu\'à 4-6 mL/kg'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.monitor_heart, title: 'Gaz du sang', subtitle: 'Surveiller la pCO2 et le pH'),
    ],
    footerNote: 'Source : ARDSNet 2000, Recommandations SFAR',
    sources: [
      'ARDSNet (The Acute Respiratory Distress Syndrome Network). N Engl J Med. 2000;342(18):1301-1308.',
      'SFAR — RFE Ventilation périopératoire 2019.',
      'Miller\'s Anesthesia, 9e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  PPLAT — PRESSION PLATEAU
  // ══════════════════════════════════════════════════════════
  'pplat': const RespiratoryParamDetail(
    title: 'Pression Plateau (Pplat)',
    subtitle: 'Pression alvéolaire de fin d\'inspiration',
    color: Colors.redAccent,
    icon: Icons.compress_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La pression plateau reflète la pression statique dans les alvéoles '
        'à la fin de l\'inspiration. C\'est le meilleur indicateur du risque '
        'de barotrauma.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Le maintien d\'une Pplat ≤ 30 cmH2O protège de la surdistension et du barotrauma.',
    whyBullets: ['Prévention des pneumothorax', 'Protection des capillaires pulmonaires'],
    recommendedValueLabel: 'OBJECTIF',
    recommendedValue: '≤ 30',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: 'Mesurée lors d\'une pause inspiratoire',
    benefits: [PhysiologicalEffect('Diminution du stress et strain pulmonaire')],
    risks: [PhysiologicalEffect('Nécessite souvent une réduction du Vt pouvant causer une hypercapnie')],
    adjustmentTitle: 'AJUSTEMENT SI PPLAT ÉLEVÉE',
    adjustmentTable: [
      AdjustmentTableRow('Pplat > 30 cmH2O', 'Réduire le Volume Courant (Vt) par paliers de 1 mL/kg'),
      AdjustmentTableRow('Rigidité pariétale', 'Optimiser la curarisation / sédation'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.show_chart, title: 'Courbe de pression', subtitle: 'Pause inspiratoire de 0.5s requise'),
    ],
    footerNote: 'Source : ARDSNet 2000, Recommandations SFAR',
    sources: [
      'ARDSNet. N Engl J Med. 2000;342(18):1301-1308.',
      'SFAR/SRLF — Recommandations SDRA.',
      'Tobin MJ. Principles and Practice of Mechanical Ventilation, 3e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  PEEP — PRESSION EXPIRATOIRE POSITIVE
  // ══════════════════════════════════════════════════════════
  'peep': const RespiratoryParamDetail(
    title: 'PEEP (Pression Expiratoire Positive)',
    subtitle: 'Maintien des alvéoles ouvertes',
    color: Colors.green,
    icon: Icons.change_history_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText: 'La PEEP est la pression maintenue dans les voies aériennes à la fin de l\'expiration.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Pour éviter l\'atélectraumatisme (ouverture/fermeture cyclique) et recruter des alvéoles.',
    whyBullets: ['Augmentation de la CRF', 'Amélioration de l\'oxygénation'],
    recommendedValueLabel: 'DÉPART STANDARD',
    recommendedValue: '5',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: 'À titrer selon la FiO2 et la SpO2',
    benefits: [PhysiologicalEffect('Prévention du dérecrutement alvéolaire')],
    risks: [PhysiologicalEffect('Baisse du retour veineux (hypotension)')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Hypoxémie persistante', 'Augmenter la PEEP (tables ARDSNet)'),
      AdjustmentTableRow('Instabilité hémodynamique', 'Diminuer la PEEP prudemment'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.favorite, title: 'Hémodynamique', subtitle: 'Surveiller la tension artérielle (PAM)'),
    ],
    footerNote: 'Source : Recommandations SFAR, Tables ARDSNet',
    sources: [
      'ARDSNet — Tables PEEP/FiO2.',
      'SFAR — RFE Ventilation périopératoire 2019.',
      'ESICM ARDS Guidelines.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  FR — FRÉQUENCE RESPIRATOIRE
  // ══════════════════════════════════════════════════════════
  'fr': const RespiratoryParamDetail(
    title: 'Fréquence Respiratoire (FR)',
    subtitle: 'Nombre de cycles par minute',
    color: Colors.purple,
    icon: Icons.speed_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La fréquence respiratoire réglée sur le ventilateur déterminé, avec '
        'le volume courant, la ventilation minute et donc l\'élimination du CO₂.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Une FR de 12 à 16/min permet de maintenir une normocapnie chez la '
        'majorité des patients, sans générer d\'auto-PEEP par temps expiratoire trop court.',
    whyBullets: ['Maintien de la normocapnie', 'Évite l\'hyperinflation dynamique'],
    recommendedValueLabel: 'RECOMMANDATION STANDARD',
    recommendedValue: '12 - 16',
    recommendedValueBadge: '/min',
    recommendedValueNote: 'Ajuster selon l\'EtCO₂ et la gazométrie',
    benefits: [PhysiologicalEffect('Permet une élimination adéquate du CO₂ sans piégeage gazeux')],
    risks: [PhysiologicalEffect('FR trop élevée → auto-PEEP ; FR trop basse → hypercapnie')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Hypercapnie', 'Augmenter la FR par paliers de 2/min'),
      AdjustmentTableRow('Auto-PEEP / BPCO', 'Diminuer la FR pour allonger le temps expiratoire'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.bubble_chart_outlined, title: 'EtCO₂', subtitle: 'Reflet indirect de la PaCO₂'),
    ],
    footerNote: 'Source : Recommandations SFAR, Ventilation mécanique',
    sources: [
      'SFAR — Ventilation mécanique périopératoire.',
      'Tobin MJ. Principles and Practice of Mechanical Ventilation, 3e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  FIO2 — FRACTION INSPIRÉE D'OXYGÈNE
  // ══════════════════════════════════════════════════════════
  'fio2': const RespiratoryParamDetail(
    title: 'FiO₂ (Fraction Inspirée d\'Oxygène)',
    subtitle: 'Concentration d\'oxygène délivrée',
    color: Colors.cyan,
    icon: Icons.water_drop_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La FiO₂ est la fraction d\'oxygène dans le mélange gazeux délivré au '
        'patient, allant de 0.21 (air ambiant) à 1.0 (oxygène pur).',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Une FiO₂ initiale de 0.4 à 0.6 permet une oxygénation correcte tout '
        'en limitant la toxicité de l\'hyperoxie et les atélectasies de résorption.',
    whyBullets: ['Sécurise la SpO₂ cible', 'Limite la toxicité de l\'hyperoxie'],
    recommendedValueLabel: 'FIO₂ INITIALE',
    recommendedValue: '0.4 - 0.6',
    recommendedValueBadge: 'fraction',
    recommendedValueNote: 'Ajuster pour viser une SpO₂ 92-96 %',
    benefits: [PhysiologicalEffect('Corrige rapidement une hypoxémie modérée')],
    risks: [PhysiologicalEffect('FiO₂ élevée prolongée → atélectasies de résorption, toxicité radicalaire')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('SpO₂ < 92 %', 'Augmenter la FiO₂ par paliers de 0.1'),
      AdjustmentTableRow('SpO₂ > 96 % de façon stable', 'Diminuer la FiO₂ dès que possible'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.water_drop_outlined, title: 'SpO₂ / PaO₂', subtitle: 'Objectif : 92-96 %'),
    ],
    footerNote: 'Source : Recommandations SFAR, ARDSNet',
    sources: [
      'ARDSNet. N Engl J Med. 2000;342(18):1301-1308.',
      'SFAR — RFE Ventilation périopératoire 2019.',
      'Surviving Sepsis Campaign — cibles d\'oxygénation.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  I:E — RAPPORT INSPIRATION/EXPIRATION
  // ══════════════════════════════════════════════════════════
  'ie': const RespiratoryParamDetail(
    title: 'Rapport I:E',
    subtitle: 'Proportion temps inspiratoire / expiratoire',
    color: Colors.amber,
    icon: Icons.swap_horiz_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'Le rapport I:E décrit la proportion entre le temps inspiratoire et '
        'le temps expiratoire au sein d\'un même cycle respiratoire.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Un rapport 1:2 laisse un temps expiratoire suffisant pour une '
        'vidange pulmonaire complète chez la majorité des patients.',
    whyBullets: ['Évite le piégeage gazeux (air trapping)', 'Standard chez le patient sans obstruction'],
    recommendedValueLabel: 'RAPPORT STANDARD',
    recommendedValue: '1:2',
    recommendedValueBadge: 'Standard',
    recommendedValueNote: 'Allonger l\'expiration si obstruction (BPCO, asthme)',
    benefits: [PhysiologicalEffect('Vidange pulmonaire complète, prévention de l\'auto-PEEP')],
    risks: [PhysiologicalEffect('I:E inversé (ex. 2:1) → inconfort, nécessite sédation profonde')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('BPCO / Asthme', 'Allonger le temps expiratoire (1:3 ou plus)'),
      AdjustmentTableRow('SDRA sévère', 'I:E parfois inversé sous surveillance stricte'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.show_chart, title: 'Courbe de débit', subtitle: 'Vérifier le retour à zéro avant le cycle suivant'),
    ],
    footerNote: 'Source : Recommandations SFAR, Ventilation mécanique',
    sources: [
      'SFAR — Ventilation mécanique.',
      'Egan\'s Fundamentals of Respiratory Care.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  DRIVING PRESSURE
  // ══════════════════════════════════════════════════════════
  'driving': const RespiratoryParamDetail(
    title: 'Driving Pressure',
    subtitle: 'Pression motrice (Pplat − PEEP)',
    color: Colors.pink,
    icon: Icons.compare_arrows_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'La driving pressure correspond à la différence entre la pression '
        'plateau et la PEEP. Elle reflète la déformation cyclique réellement '
        'appliquée au parenchyme pulmonaire pour chaque volume courant délivré.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Une driving pressure élevée est associée à une surmortalité '
        'indépendamment du volume courant utilisé, ce qui en fait une cible '
        'de protection pulmonaire à part entière.',
    whyBullets: ['Meilleur reflet du stress pulmonaire que le Vt seul', 'Cible indépendante de protection alvéolaire'],
    recommendedValueLabel: 'OBJECTIF',
    recommendedValue: '< 15',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: 'Idéalement < 13-15 cmH₂O',
    benefits: [PhysiologicalEffect('Réduction de la mortalité associée au SDRA (Amato 2015)')],
    risks: [PhysiologicalEffect('Driving pressure élevée → risque accru de lésion pulmonaire induite par la ventilation')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Driving pressure > 15 cmH₂O', 'Réduire le Vt et/ou optimiser la PEEP'),
      AdjustmentTableRow('Compliance pulmonaire basse', 'Réévaluer le recrutement alvéolaire'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.compress_rounded, title: 'Pplat & PEEP', subtitle: 'Recalculer à chaque changement de réglage'),
    ],
    footerNote: 'Source : Amato et al., N Engl J Med 2015 ; ATS/ESICM/SCCM 2017',
    sources: [
      'Amato MB, et al. "Driving pressure and survival in the acute respiratory distress syndrome." N Engl J Med. 2015;372(8):747-755.',
      'ATS/ESICM/SCCM Clinical Practice Guideline — Mechanical Ventilation in ARDS, 2017.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  VOLUME MINUTE
  // ══════════════════════════════════════════════════════════
  'minute_volume': const RespiratoryParamDetail(
    title: 'Volume Minute',
    subtitle: 'Ventilation totale par minute (Vt × FR)',
    color: Colors.teal,
    icon: Icons.timeline_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'Le volume minute est le produit du volume courant par la fréquence '
        'respiratoire. Il représente le volume total d\'air ventilé chaque minute.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Le volume minute estimé permet de vérifier la cohérence globale du '
        'réglage Vt/FR et d\'anticiper l\'élimination du CO₂.',
    whyBullets: ['Reflet global de la ventilation alvéolaire', 'Outil de vérification croisée Vt/FR'],
    recommendedValueLabel: 'PLAGE ESTIMÉE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'L/min',
    recommendedValueNote: 'Calculé automatiquement à partir du Vt et de la FR',
    benefits: [PhysiologicalEffect('Permet une vérification rapide de la cohérence des réglages')],
    risks: [PhysiologicalEffect('Volume minute insuffisant → hypercapnie ; excessif → alcalose respiratoire')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Hypercapnie', 'Augmenter la FR plutôt que le Vt si Pplat déjà à la limite'),
      AdjustmentTableRow('Hypocapnie / alcalose', 'Diminuer la FR'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.monitor_heart, title: 'EtCO₂ / Gaz du sang', subtitle: 'Corréler au volume minute réglé'),
    ],
    footerNote: 'Source : Recommandations SFAR, Ventilation mécanique',
    sources: [
      'SFAR — Ventilation mécanique.',
      'Marino PL. The ICU Book, 4e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  PRESSION INSPIRATOIRE
  // ══════════════════════════════════════════════════════════
  'insp_pressure': const RespiratoryParamDetail(
    title: 'Pression Inspiratoire',
    subtitle: 'Pression appliquée au-dessus de la PEEP (VPC)',
    color: Colors.lightBlue,
    icon: Icons.arrow_upward_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'En ventilation en pression contrôlée (VPC), la pression inspiratoire '
        'est le niveau de pression appliqué au-dessus de la PEEP pour générer le volume courant cible.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Le niveau de pression inspiratoire doit générer un Vt protecteur '
        'sans dépasser la limite de pression plateau recommandée.',
    whyBullets: ['Génère le Vt cible (6-8 mL/kg)', 'Reste cohérent avec la limite de Pplat'],
    recommendedValueLabel: 'PLAGE INDICATIVE',
    recommendedValue: '12 - 18',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: 'Au-dessus de la PEEP, à ajuster selon le Vt obtenu',
    benefits: [PhysiologicalEffect('Permet un contrôle fin du Vt délivré en VPC')],
    risks: [PhysiologicalEffect('Pression trop élevée → Vt excessif et risque de volotrauma')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Vt obtenu trop élevé', 'Diminuer la pression inspiratoire par paliers de 2 cmH₂O'),
      AdjustmentTableRow('Vt obtenu insuffisant', 'Augmenter prudemment, sous surveillance de la Pplat'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.air_rounded, title: 'Vt délivré', subtitle: 'Vérifier qu\'il reste dans la cible 6-8 mL/kg'),
    ],
    footerNote: 'Source : Recommandations SFAR, Ventilation mécanique',
    sources: [
      'SFAR — Ventilation mécanique périopératoire.',
      'Miller\'s Anesthesia, 9e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  TEMPS INSPIRATOIRE
  // ══════════════════════════════════════════════════════════
  'insp_time': const RespiratoryParamDetail(
    title: 'Temps Inspiratoire',
    subtitle: 'Durée de la phase inspiratoire du cycle',
    color: Colors.deepOrange,
    icon: Icons.timer_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'Le temps inspiratoire est la durée de la phase d\'insufflation au '
        'sein d\'un cycle respiratoire, déterminée par la FR et le rapport I:E choisis.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Un temps inspiratoire cohérent avec le rapport I:E standard (1:2) '
        'assure une insufflation suffisante sans empiéter sur le temps expiratoire.',
    whyBullets: ['Découle directement de la FR et du rapport I:E', 'Doit laisser un temps expiratoire suffisant'],
    recommendedValueLabel: 'VALEUR CALCULÉE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'secondes',
    recommendedValueNote: 'Dépend de la FR réglée et du rapport I:E',
    benefits: [PhysiologicalEffect('Cohérence automatique avec la FR et le rapport I:E réglés')],
    risks: [PhysiologicalEffect('Temps inspiratoire trop long → réduction du temps expiratoire, auto-PEEP')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Auto-PEEP suspectée', 'Raccourcir le temps inspiratoire (revoir I:E)'),
      AdjustmentTableRow('Hypoxémie réfractaire (SDRA sévère)', 'Allongement possible sous surveillance stricte'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.show_chart, title: 'Courbe de débit', subtitle: 'Vérifier le retour à zéro en fin d\'expiration'),
    ],
    footerNote: 'Source : Recommandations SFAR, Ventilation mécanique',
    sources: [
      'SFAR — Ventilation mécanique.',
      'Tobin MJ. Principles and Practice of Mechanical Ventilation, 3e éd.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  DÉBIT INSPIRATOIRE
  // ══════════════════════════════════════════════════════════
  'insp_flow': const RespiratoryParamDetail(
    title: 'Débit Inspiratoire',
    subtitle: 'Vitesse de délivrance du volume courant',
    color: Colors.teal,
    icon: Icons.waves_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'Le débit inspiratoire est la vitesse à laquelle le volume courant '
        'est délivré au patient durant la phase inspiratoire (en ventilation volumétrique).',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Un débit adapté au Vt et au temps inspiratoire visé permet d\'éviter '
        'un temps inspiratoire trop court (pics de pression) ou trop long (inconfort, auto-PEEP).',
    whyBullets: ['Cohérent avec le Vt et le temps inspiratoire calculés', 'Évite les pics de pression inutiles'],
    recommendedValueLabel: 'PLAGE CONSEILLÉE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'L/min',
    recommendedValueNote: 'Calculée à partir du Vt et du temps inspiratoire',
    benefits: [PhysiologicalEffect('Limite les pics de pression de crête inutiles')],
    risks: [PhysiologicalEffect('Débit trop faible → temps inspiratoire prolongé, dysynchronie patient-ventilateur')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Dysynchronie / "air hunger"', 'Augmenter le débit inspiratoire'),
      AdjustmentTableRow('Pic de pression élevé', 'Réduire légèrement le débit ou revoir la forme de la courbe'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.show_chart, title: 'Synchronisation patient-ventilateur', subtitle: 'Observer le confort respiratoire'),
    ],
    footerNote: 'Source : Recommandations SFAR, Ventilation mécanique',
    sources: [
      'SFAR — Ventilation mécanique.',
      'AARC Clinical Practice Guidelines.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  TRIGGER
  // ══════════════════════════════════════════════════════════
  'trigger': const RespiratoryParamDetail(
    title: 'Trigger (Seuil de déclenchement)',
    subtitle: 'Sensibilité de détection de l\'effort du patient',
    color: Colors.teal,
    icon: Icons.touch_app_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'Le trigger est le seuil de débit ou de pression que le patient doit '
        'générer pour déclencher un cycle assisté par le ventilateur.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Un trigger ni trop sensible (auto-déclenchement) ni trop élevé '
        '(travail respiratoire excessif) optimise la synchronisation patient-ventilateur.',
    whyBullets: ['Limite le travail respiratoire imposé au patient', 'Évite l\'auto-déclenchement (fuites, artefacts)'],
    recommendedValueLabel: 'RÉGLAGE STANDARD',
    recommendedValue: '1 - 3 L/min',
    recommendedValueBadge: 'ou -1 à -2 cmH₂O',
    recommendedValueNote: 'Trigger en débit généralement préféré (plus réactif)',
    benefits: [PhysiologicalEffect('Bonne synchronisation patient-ventilateur, confort amélioré')],
    risks: [PhysiologicalEffect('Trigger trop sensible → auto-déclenchement ; trop élevé → travail respiratoire excessif')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Auto-déclenchement (fuites, condensation)', 'Diminuer la sensibilité du trigger'),
      AdjustmentTableRow('Effort important pour déclencher', 'Augmenter la sensibilité du trigger'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.touch_app_outlined, title: 'Synchronisation', subtitle: 'Observer les efforts inefficaces sur la courbe'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques, SFAR',
    sources: [
      'SFAR — Pratique des ventilateurs de soins critiques.',
      'Hamilton Medical Academy — Trigger settings.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME VT BAS
  // ══════════════════════════════════════════════════════════
  'alarm_vt': const RespiratoryParamDetail(
    title: 'Alarme Volume Courant Bas',
    subtitle: 'Seuil d\'alerte de débranchement / fuite',
    color: Colors.red,
    icon: Icons.notifications_active_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de Vt bas se déclenche lorsque le volume courant délivré '
        'ou mesuré devient inférieur au seuil réglé, signalant une fuite, une '
        'débranchement ou une obstruction.',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Un seuil fixé entre 70 et 85 % du Vt minimal cible permet de détecter '
        'rapidement un incident sans générer de fausses alarmes.',
    whyBullets: ['Détection rapide des débranchements et fuites', 'Évite les fausses alarmes liées aux variations physiologiques normales'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'mL',
    recommendedValueNote: '≈ 70-85 % du Vt minimal cible',
    benefits: [PhysiologicalEffect('Permet une intervention rapide en cas d\'incident de circuit')],
    risks: [PhysiologicalEffect('Seuil mal réglé → alarmes intempestives ou détection retardée')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Alarmes répétées sans incident', 'Vérifier le circuit avant de modifier le seuil'),
      AdjustmentTableRow('Changement de Vt cible', 'Recalculer systématiquement le seuil d\'alarme'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.notifications_active_outlined, title: 'Circuit ventilatoire', subtitle: 'Vérifier l\'étanchéité en cas d\'alarme répétée'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques',
    sources: [
      'AARC Clinical Practice Guidelines — Ventilator alarm management.',
      'SCCM — Sécurité en ventilation mécanique.',
    ],
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME PRESSION HAUTE
  // ══════════════════════════════════════════════════════════
  'alarm_pressure': const RespiratoryParamDetail(
    title: 'Alarme Pression Haute',
    subtitle: 'Seuil d\'alerte de surpression des voies aériennes',
    color: Colors.red,
    icon: Icons.report_gmailerrorred_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de pression haute se déclenche lorsque la pression dans '
        'les voies aériennes dépasse le seuil réglé, signalant un risque de '
        'barotraumatisme (obstruction, toux, bronchospasme...).',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText:
        'Un seuil fixé à 35-40 cmH₂O protège contre le barotraumatisme tout '
        'en restant au-dessus des pics de pression normaux attendus.',
    whyBullets: ['Protection contre le barotraumatisme', 'Détection précoce d\'obstruction ou de dysynchronie'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: '35 - 40',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: 'À adapter si Pplat cible déjà élevée (ex. SDRA sévère)',
    benefits: [PhysiologicalEffect('Permet une intervention rapide en cas d\'obstruction ou de toux')],
    risks: [PhysiologicalEffect('Seuil trop bas → alarmes intempestives ; trop haut → retard de détection du barotraumatisme')],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Alarmes répétées (toux, sécrétions)', 'Aspirer les voies aériennes avant de modifier le seuil'),
      AdjustmentTableRow('Pplat cible élevée (SDRA sévère)', 'Réévaluer le seuil en conséquence, sous surveillance stricte'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.compress_rounded, title: 'Pression de crête / plateau', subtitle: 'Différencier obstruction (Ppic) et rigidité (Pplat)'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques, SFAR',
    sources: [
      'SFAR — Pratique des ventilateurs de soins critiques.',
      'AARC Clinical Practice Guidelines.',
    ],
  ),
};
