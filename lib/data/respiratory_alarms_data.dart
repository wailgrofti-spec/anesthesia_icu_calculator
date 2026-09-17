// ============================================================================
//  lib/data/respiratory_alarms_data.dart
//  NOUVEAU — Fiches des alarmes recommandées, en complément des 2 alarmes
//  déjà existantes dans respiratory_detail_data.dart ('alarm_vt' = VT bas,
//  'alarm_pressure' = pression haute). N'ALTÈRE AUCUN FICHIER EXISTANT.
//
//  Section "Alarmes recommandées" complète (10 alarmes au total) :
//   - VT bas               → 'alarm_vt'          (déjà existant)
//   - VT haut               → 'alarm_vt_high'     (nouveau)
//   - Pression haute        → 'alarm_pressure'    (déjà existant)
//   - Pression basse        → 'alarm_pressure_low'(nouveau)
//   - Volume minute bas     → 'alarm_mv_low'      (nouveau)
//   - Volume minute haut    → 'alarm_mv_high'     (nouveau)
//   - Apnée                 → 'alarm_apnea'       (nouveau)
//   - FiO₂ basse            → 'alarm_fio2_low'    (nouveau)
//   - FiO₂ haute            → 'alarm_fio2_high'   (nouveau)
//   - PEEP basse            → 'alarm_peep_low'    (nouveau)
//   - PEEP haute            → 'alarm_peep_high'   (nouveau)
// ============================================================================

import 'package:flutter/material.dart';
import '../models/respiratory_param_detail.dart';

const List<String> _alarmGeneralSources = [
  'AARC Clinical Practice Guidelines — Ventilator alarm management',
  'SCCM/ESICM — Recommandations de sécurité en ventilation mécanique',
  'Hamilton Medical Academy — Alarm settings',
];

final Map<String, RespiratoryParamDetail> respiratoryAlarmDetails = {
  // ══════════════════════════════════════════════════════════
  //  ALARME VT HAUT
  // ══════════════════════════════════════════════════════════
  'alarm_vt_high': const RespiratoryParamDetail(
    title: 'Alarme Volume Courant Haut',
    subtitle: 'Seuil d\'alerte de Vt excessif',
    color: Color(0xFFEF4444),
    icon: Icons.notifications_active_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de Vt haut se déclenche lorsque le volume courant délivré '
        'ou mesuré dépasse le seuil réglé, signalant un risque de '
        'volotrauma ou un dysfonctionnement de trigger (auto-déclenchements répétés).',
    physiology: 'Un Vt excessif majore la surdistension alvéolaire et le risque de volotrauma, en particulier chez le patient à compliance basse.',
    clinicalGoal: 'Prévenir le volotrauma par détection immédiate d\'un Vt délivré excessif.',
    normalValues: 'Seuil usuel : 110-130 % du Vt cible maximal',
    howToCalculate: 'Seuil = Vt cible maximal (calculé) × 1,1 à 1,3',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Un seuil à 110-130 % du Vt cible détecte un volotrauma naissant sans générer d\'alarmes intempestives lors des variations physiologiques normales.',
    whyBullets: ['Prévention du volotrauma', 'Détection d\'anomalie de trigger en VPC/PSV'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'mL',
    recommendedValueNote: '≈ 110-130 % du Vt cible maximal',
    benefits: [PhysiologicalEffect('Détection précoce d\'un volotrauma ou d\'un Vt délivré excessif en VPC/PSV')],
    risks: [PhysiologicalEffect('Seuil trop bas → alarmes intempestives lors de la toux ou de mouvements')],
    whenToIncrease: ['Patient tousse fréquemment sans risque de surdistension avéré'],
    whenToDecrease: ['Compliance pulmonaire basse (SDRA) — sécuriser davantage contre la surdistension'],
    commonErrors: ['Ne pas recalculer le seuil après changement de mode (VCV → VPC)'],
    specialCases: ['VPC/PSV : le Vt obtenu peut varier avec la mécanique respiratoire — surveillance renforcée nécessaire'],
    practicalTips: ['Toujours revérifier ce seuil après tout changement de profil clinique ou de mode ventilatoire'],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Alarmes répétées sans cause retrouvée', 'Vérifier la mécanique respiratoire (compliance, résistance)'),
      AdjustmentTableRow('Changement de Vt cible', 'Recalculer systématiquement le seuil d\'alarme'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.air_rounded, title: 'Vt délivré/mesuré', subtitle: 'Comparer au Vt cible à chaque cycle'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME PRESSION BASSE
  // ══════════════════════════════════════════════════════════
  'alarm_pressure_low': const RespiratoryParamDetail(
    title: 'Alarme Pression Basse',
    subtitle: 'Seuil d\'alerte de débranchement / fuite majeure',
    color: Color(0xFFEF4444),
    icon: Icons.report_gmailerrorred_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de pression basse se déclenche lorsque la pression dans '
        'les voies aériennes reste anormalement basse durant l\'inspiration, '
        'signalant un débranchement, une fuite majeure du circuit ou '
        'de la sonde d\'intubation, ou un ballonnet dégonflé.',
    physiology: 'Une chute de pression sans cause volontaire traduit une perte d\'étanchéité du circuit patient-ventilateur.',
    clinicalGoal: 'Détecter en quelques secondes une perte d\'assistance ventilatoire effective.',
    normalValues: 'Seuil usuel : 3-5 cmH₂O sous la PEEP réglée',
    howToCalculate: 'Seuil = PEEP réglée minimale − 3 cmH₂O',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Un débranchement ou une fuite majeure prive rapidement le patient d\'assistance ventilatoire — l\'alarme doit être quasi immédiate.',
    whyBullets: ['Détection immédiate d\'un débranchement', 'Sécurité vitale en cas de fuite majeure'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: '≈ PEEP réglée − 3 cmH₂O',
    benefits: [PhysiologicalEffect('Alarme vitale — détecte un débranchement en quelques secondes')],
    risks: [PhysiologicalEffect('Seuil mal réglé → retard de détection d\'un incident grave')],
    whenToIncrease: ['Non applicable — ne pas réduire la sensibilité de cette alarme de sécurité'],
    whenToDecrease: ['Jamais en routine — alarme de sécurité vitale à ne pas désactiver'],
    commonErrors: ['Désactiver ou rendre insensible cette alarme pour limiter les nuisances sonores'],
    specialCases: ['Ballonnet de sonde d\'intubation à vérifier systématiquement en cas de déclenchement répété'],
    practicalTips: ['Ne jamais couper cette alarme, même temporairement, en dehors d\'une manœuvre contrôlée (aspiration, changement de circuit)'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Déclenchement de l\'alarme', 'Vérifier immédiatement circuit, sonde, ballonnet et connexions'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.link_off_rounded, title: 'Étanchéité du circuit', subtitle: 'Vérifier à chaque alarme, sans délai'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques, SCCM',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME VOLUME MINUTE BAS
  // ══════════════════════════════════════════════════════════
  'alarm_mv_low': const RespiratoryParamDetail(
    title: 'Alarme Volume Minute Bas',
    subtitle: 'Seuil d\'alerte d\'hypoventilation',
    color: Color(0xFFEF4444),
    icon: Icons.trending_down_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de volume minute bas se déclenche lorsque la ventilation '
        'totale par minute chute sous le seuil réglé, signalant une '
        'hypoventilation (fuite, apnées partielles, baisse de l\'effort du patient).',
    physiology: 'Une hypoventilation prolongée entraîne une hypercapnie et une acidose respiratoire.',
    clinicalGoal: 'Détecter une hypoventilation avant l\'apparition d\'une hypercapnie significative.',
    normalValues: 'Seuil usuel : ≈ 70 % du volume minute cible calculé',
    howToCalculate: 'Seuil = Volume minute cible minimal × 0,70',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Particulièrement importante en modes spontanés (PSV, CPAP/PS) où le volume minute dépend directement de l\'effort du patient.',
    whyBullets: ['Essentielle en ventilation spontanée assistée (PSV/CPAP)', 'Détecte fatigue respiratoire ou sur-sédation'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'L/min',
    recommendedValueNote: '≈ 70 % du volume minute cible',
    benefits: [PhysiologicalEffect('Détecte précocement une fatigue respiratoire ou une sur-sédation en mode spontané')],
    risks: [PhysiologicalEffect('Hypoventilation non détectée → hypercapnie, acidose respiratoire')],
    whenToIncrease: ['Patient stable avec variabilité respiratoire physiologique importante (éviter les fausses alarmes)'],
    whenToDecrease: ['Sevrage ventilatoire en cours — sensibilité accrue recommandée'],
    commonErrors: ['Ne pas adapter ce seuil lors du passage d\'un mode contrôlé à un mode spontané (PSV/CPAP)'],
    specialCases: ['PSV/CPAP-PS : alarme particulièrement critique car le volume minute n\'est pas garanti par le ventilateur'],
    practicalTips: ['En sevrage ventilatoire, resserrer ce seuil pour détecter précocement un épuisement respiratoire'],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Hypoventilation en mode spontané', 'Réévaluer le niveau d\'aide inspiratoire et la sédation'),
      AdjustmentTableRow('Fatigue respiratoire suspectée', 'Envisager un support ventilatoire plus assisté'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.monitor_heart, title: 'EtCO₂ / Gaz du sang', subtitle: 'Corréler à la baisse du volume minute'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME VOLUME MINUTE HAUT
  // ══════════════════════════════════════════════════════════
  'alarm_mv_high': const RespiratoryParamDetail(
    title: 'Alarme Volume Minute Haut',
    subtitle: 'Seuil d\'alerte d\'hyperventilation',
    color: Color(0xFFEF4444),
    icon: Icons.trending_up_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de volume minute haut se déclenche lorsque la ventilation '
        'totale par minute dépasse le seuil réglé, signalant une '
        'hyperventilation, une polypnée (douleur, agitation, acidose métabolique) ou une fuite compensée par sur-cyclage.',
    physiology: 'Une hyperventilation prolongée entraîne une hypocapnie et une alcalose respiratoire, avec risque de vasoconstriction cérébrale.',
    clinicalGoal: 'Détecter une hyperventilation avant l\'apparition d\'une hypocapnie significative.',
    normalValues: 'Seuil usuel : ≈ 130 % du volume minute cible calculé',
    howToCalculate: 'Seuil = Volume minute cible maximal × 1,30',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Une hyperventilation peut traduire une douleur, une agitation, une fièvre ou une acidose métabolique compensée — toutes des causes à rechercher.',
    whyBullets: ['Détecte une polypnée d\'origine douloureuse, métabolique ou neurologique', 'Prévention de l\'hypocapnie et de la vasoconstriction cérébrale associée'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'L/min',
    recommendedValueNote: '≈ 130 % du volume minute cible',
    benefits: [PhysiologicalEffect('Oriente rapidement vers une cause douloureuse, métabolique ou neurologique de polypnée')],
    risks: [PhysiologicalEffect('Hyperventilation non détectée → hypocapnie, vasoconstriction cérébrale, alcalose')],
    whenToIncrease: ['Patient en sevrage avec polypnée légère tolérée'],
    whenToDecrease: ['Traumatisme crânien / hypertension intracrânienne — surveillance stricte de la capnie'],
    commonErrors: ['Attribuer systématiquement une polypnée à une cause respiratoire sans rechercher une cause métabolique ou douloureuse'],
    specialCases: ['Acidose métabolique (ex. choc, acido-cétose) : polypnée compensatrice attendue, ne pas freiner sans corriger la cause'],
    practicalTips: ['Toujours rechercher douleur, fièvre, anxiété et acidose métabolique devant une polypnée persistante'],
    adjustmentTitle: 'AJUSTEMENT',
    adjustmentTable: [
      AdjustmentTableRow('Polypnée douloureuse', 'Optimiser l\'analgésie'),
      AdjustmentTableRow('Acidose métabolique suspectée', 'Gaz du sang en urgence, traiter la cause'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.monitor_heart, title: 'EtCO₂ / Gaz du sang', subtitle: 'Rechercher la cause de la polypnée'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME APNÉE
  // ══════════════════════════════════════════════════════════
  'alarm_apnea': const RespiratoryParamDetail(
    title: 'Alarme Apnée',
    subtitle: 'Seuil de détection d\'absence de cycle respiratoire',
    color: Color(0xFFEF4444),
    icon: Icons.pause_circle_outline_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme d\'apnée se déclenche lorsqu\'aucun cycle respiratoire '
        '(spontané ou déclenché) n\'est détecté pendant la durée réglée. '
        'Critique en modes spontanés (PSV, CPAP/PS) où l\'absence de '
        'fréquence de secours peut être fatale.',
    physiology: 'Une apnée prolongée non compensée entraîne rapidement une hypoxémie et une hypercapnie sévères.',
    clinicalGoal: 'Garantir un filet de sécurité (ventilation d\'apnée de secours) en cas d\'absence d\'effort respiratoire du patient.',
    normalValues: 'Seuil usuel : 15-20 secondes chez l\'adulte, plus court chez le nourrisson/petit enfant',
    howToCalculate: 'Seuil fixe validé par la littérature — adapté à l\'âge (réserve respiratoire moindre chez l\'enfant)',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Un seuil de 15-20 s permet de détecter une apnée cliniquement significative sans se déclencher sur une simple variabilité du rythme respiratoire.',
    whyBullets: ['Sécurité vitale en modes spontanés (PSV, CPAP/PS)', 'Déclenche automatiquement une ventilation de secours sur la plupart des ventilateurs'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'secondes',
    recommendedValueNote: '15 s en pédiatrie, 20 s chez l\'adulte',
    benefits: [PhysiologicalEffect('Déclenche la ventilation d\'apnée de secours, évitant une hypoxémie sévère')],
    risks: [PhysiologicalEffect('Seuil trop long chez l\'enfant → délai de sécurité insuffisant compte tenu de sa faible réserve en oxygène')],
    whenToIncrease: ['Non applicable — ne pas allonger sans justification clinique forte, notamment en pédiatrie'],
    whenToDecrease: ['Nouveau-né/nourrisson : raccourcir le seuil compte tenu de la faible réserve respiratoire'],
    commonErrors: ['Utiliser un seuil adulte standard chez le nourrisson/petit enfant'],
    specialCases: ['Modes spontanés (PSV, CPAP/PS) : cette alarme est LA sécurité principale en l\'absence de fréquence de secours'],
    practicalTips: ['Toujours vérifier que la ventilation d\'apnée de secours est activée et correctement réglée en mode PSV/CPAP'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Déclenchement de l\'alarme', 'Vérifier l\'effort respiratoire, la sédation, activer la ventilation de secours'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.pause_circle_outline_rounded, title: 'Effort respiratoire spontané', subtitle: 'Surveillance continue en modes assistés'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques, PALICC-2 (pédiatrie)',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME FIO2 BASSE
  // ══════════════════════════════════════════════════════════
  'alarm_fio2_low': const RespiratoryParamDetail(
    title: 'Alarme FiO₂ Basse',
    subtitle: 'Seuil d\'alerte d\'oxygène insuffisant',
    color: Color(0xFFEF4444),
    icon: Icons.water_drop_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de FiO₂ basse se déclenche lorsque la fraction inspirée '
        'd\'oxygène délivrée chute sous le seuil réglé, signalant un '
        'dysfonctionnement de la source d\'oxygène ou du mélangeur (blender).',
    physiology: 'Une FiO₂ délivrée trop basse expose à une hypoxémie brutale, en particulier chez un patient dépendant d\'un apport en oxygène élevé.',
    clinicalGoal: 'Garantir que la FiO₂ réellement délivrée reste cohérente avec la FiO₂ réglée.',
    normalValues: 'Seuil usuel : FiO₂ réglée − 10 points (ex. 0,4 réglée → alarme < 0,30)',
    howToCalculate: 'Seuil = FiO₂ cible minimale − 0,10',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Détecte une panne de la source d\'oxygène ou du mélangeur avant que l\'hypoxémie ne devienne cliniquement significative.',
    whyBullets: ['Sécurité vitale — détecte une panne de source d\'O₂', 'Complémentaire de la surveillance de la SpO₂'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: '%',
    recommendedValueNote: '≈ FiO₂ réglée − 10 points',
    benefits: [PhysiologicalEffect('Détection rapide d\'une panne de source d\'oxygène ou de mélangeur')],
    risks: [PhysiologicalEffect('Non détectée → hypoxémie sévère, en particulier chez le patient FiO₂-dépendant')],
    whenToIncrease: ['Patient stable avec faible dépendance à l\'oxygène (surveillance moins stricte tolérable)'],
    whenToDecrease: ['SDRA sévère / patient très FiO₂-dépendant — sensibilité accrue recommandée'],
    commonErrors: ['Ne pas vérifier la source d\'oxygène murale/bouteille en cas de déclenchement répété'],
    specialCases: ['Transport intra/inter-hospitalier : vérifier systématiquement l\'autonomie de la source d\'oxygène'],
    practicalTips: ['Toujours corréler à la SpO₂ mesurée avant de conclure à une fausse alarme'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Déclenchement de l\'alarme', 'Vérifier la source d\'O₂, le mélangeur et les connexions du circuit'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.water_drop_outlined, title: 'SpO₂', subtitle: 'Corréler à toute alarme de FiO₂ basse'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME FIO2 HAUTE
  // ══════════════════════════════════════════════════════════
  'alarm_fio2_high': const RespiratoryParamDetail(
    title: 'Alarme FiO₂ Haute',
    subtitle: 'Seuil d\'alerte d\'oxygène excessif',
    color: Color(0xFFEF4444),
    icon: Icons.water_drop_outlined,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de FiO₂ haute se déclenche lorsque la fraction inspirée '
        'd\'oxygène délivrée dépasse le seuil réglé, pouvant traduire un '
        'dysfonctionnement du mélangeur ou une FiO₂ laissée trop haute par erreur.',
    physiology: 'Une hyperoxie prolongée favorise le stress oxydatif, les atélectasies de résorption et, chez le nouveau-né, la rétinopathie du prématuré.',
    clinicalGoal: 'Limiter l\'exposition à l\'hyperoxie une fois la cible de SpO₂ atteinte.',
    normalValues: 'Seuil usuel : FiO₂ réglée + 20 points (ex. 0,6 réglée → alarme > 0,80)',
    howToCalculate: 'Seuil = FiO₂ cible maximale + 0,20',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Alerte sur un sevrage en oxygène non fait alors que la SpO₂ est stable, ou un dysfonctionnement du mélangeur en position haute.',
    whyBullets: ['Prévention de la toxicité de l\'hyperoxie prolongée', 'Rappel de sevrage en FiO₂ dès que la SpO₂ le permet'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: '%',
    recommendedValueNote: '≈ FiO₂ réglée + 20 points',
    benefits: [PhysiologicalEffect('Rappel systématique de sevrage en oxygène dès que la SpO₂ le permet')],
    risks: [PhysiologicalEffect('Hyperoxie prolongée non corrigée → stress oxydatif, atélectasies de résorption')],
    whenToIncrease: ['SDRA sévère nécessitant une FiO₂ élevée prolongée et documentée'],
    whenToDecrease: ['Nouveau-né/prématuré — seuil plus strict pour limiter le risque de rétinopathie'],
    commonErrors: ['Laisser une FiO₂ élevée par défaut sans réévaluation régulière de la SpO₂'],
    specialCases: ['Nouveau-né prématuré : cibler la FiO₂ la plus basse possible pour la SpO₂ visée (risque de rétinopathie)'],
    practicalTips: ['Réévaluer systématiquement la FiO₂ à chaque changement de SpO₂ stable ou de gazométrie'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('SpO₂ stable > 96 % avec FiO₂ élevée', 'Sevrer progressivement la FiO₂'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.water_drop_outlined, title: 'SpO₂ / PaO₂', subtitle: 'Sevrer la FiO₂ dès que la cible est atteinte de façon stable'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME PEEP BASSE
  // ══════════════════════════════════════════════════════════
  'alarm_peep_low': const RespiratoryParamDetail(
    title: 'Alarme PEEP Basse',
    subtitle: 'Seuil d\'alerte de perte de PEEP',
    color: Color(0xFFEF4444),
    icon: Icons.change_history_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de PEEP basse se déclenche lorsque la PEEP réellement '
        'appliquée chute sous le seuil réglé, signalant une fuite du '
        'circuit ou une valve expiratoire défaillante.',
    physiology: 'Une perte de PEEP expose au dérecrutement alvéolaire brutal et à une chute rapide de l\'oxygénation, en particulier chez le patient SDRA/obèse dépendant d\'une PEEP élevée.',
    clinicalGoal: 'Prévenir le dérecrutement alvéolaire lié à une perte non détectée de la PEEP.',
    normalValues: 'Seuil usuel : PEEP réglée − 2 à 3 cmH₂O',
    howToCalculate: 'Seuil = PEEP cible minimale − 2 cmH₂O',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Une perte même modérée de PEEP peut entraîner un dérecrutement rapide chez le patient dépendant d\'une PEEP élevée (SDRA, obésité).',
    whyBullets: ['Prévention du dérecrutement alvéolaire brutal', 'Détecte une fuite ou une valve expiratoire défaillante'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: '≈ PEEP réglée − 2 à 3 cmH₂O',
    benefits: [PhysiologicalEffect('Détection rapide d\'une fuite ou d\'un défaut de la valve expiratoire')],
    risks: [PhysiologicalEffect('Non détectée → dérecrutement alvéolaire, chute rapide de la SpO₂')],
    whenToIncrease: ['PEEP réglée basse (5 cmH₂O) — marge de tolérance proportionnellement plus faible'],
    whenToDecrease: ['SDRA/obésité avec PEEP élevée — sensibilité accrue recommandée'],
    commonErrors: ['Ne pas recalculer ce seuil après une titration de PEEP (tables ARDSNet)'],
    specialCases: ['SDRA sévère et obésité : dépendance marquée à la PEEP, seuil à surveiller de près'],
    practicalTips: ['Recalculer ce seuil à chaque modification de la PEEP cible'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Déclenchement de l\'alarme', 'Vérifier l\'étanchéité du circuit et la valve expiratoire'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.change_history_rounded, title: 'PEEP mesurée', subtitle: 'Comparer en continu à la PEEP réglée'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques, SFAR/SRLF SDRA',
    sources: _alarmGeneralSources,
  ),

  // ══════════════════════════════════════════════════════════
  //  ALARME PEEP HAUTE
  // ══════════════════════════════════════════════════════════
  'alarm_peep_high': const RespiratoryParamDetail(
    title: 'Alarme PEEP Haute',
    subtitle: 'Seuil d\'alerte d\'accumulation de pression expiratoire',
    color: Color(0xFFEF4444),
    icon: Icons.change_history_rounded,
    definitionTitle: 'DÉFINITION',
    definitionText:
        'L\'alarme de PEEP haute se déclenche lorsque la PEEP totale '
        '(réglée + auto-PEEP) dépasse le seuil fixé, signalant une '
        'hyperinflation dynamique ou un dysfonctionnement de la valve expiratoire.',
    physiology: 'Une PEEP totale excessive majore le risque de barotraumatisme et compromet le retour veineux, avec retentissement hémodynamique possible.',
    clinicalGoal: 'Détecter une accumulation de pression expiratoire (auto-PEEP) avant ses conséquences hémodynamiques.',
    normalValues: 'Seuil usuel : PEEP réglée + 3 cmH₂O',
    howToCalculate: 'Seuil = PEEP cible maximale + 3 cmH₂O',
    whyTitle: 'POURQUOI CETTE VALEUR ?',
    whyText: 'Toute PEEP totale dépassant nettement la PEEP réglée doit faire suspecter une auto-PEEP significative à corriger activement.',
    whyBullets: ['Détection précoce de l\'auto-PEEP/hyperinflation dynamique', 'Prévention du retentissement hémodynamique'],
    recommendedValueLabel: 'SEUIL D\'ALERTE',
    recommendedValue: 'Variable',
    recommendedValueBadge: 'cmH₂O',
    recommendedValueNote: '≈ PEEP réglée + 3 cmH₂O',
    benefits: [PhysiologicalEffect('Détecte une auto-PEEP ou un dysfonctionnement de valve avant le retentissement hémodynamique')],
    risks: [PhysiologicalEffect('Non détectée → hypotension par hyperinflation dynamique, barotraumatisme')],
    whenToIncrease: ['Non applicable — alarme de sécurité, à ne pas rendre moins sensible sans raison précise'],
    whenToDecrease: ['BPCO/asthme — patient à haut risque d\'auto-PEEP, seuil plus strict recommandé'],
    commonErrors: ['Attribuer une PEEP totale élevée uniquement à un dysfonctionnement matériel sans rechercher une auto-PEEP clinique'],
    specialCases: ['BPCO/asthme aigu grave : surveillance systématique, risque élevé d\'auto-PEEP'],
    practicalTips: ['Devant un déclenchement, rechercher systématiquement une auto-PEEP avant d\'incriminer le matériel'],
    adjustmentTitle: 'CONDUITE À TENIR',
    adjustmentTable: [
      AdjustmentTableRow('Déclenchement de l\'alarme', 'Rechercher une auto-PEEP (voir fiche dédiée), vérifier la valve expiratoire'),
    ],
    monitoringTitle: 'SURVEILLANCE',
    monitoringPoints: [
      MonitoringPoint(icon: Icons.change_history_rounded, title: 'PEEP totale', subtitle: 'PEEP réglée + auto-PEEP mesurée'),
    ],
    footerNote: 'Source : Pratique standard des ventilateurs de soins critiques, ERS/ATS BPCO',
    sources: _alarmGeneralSources,
  ),
};
