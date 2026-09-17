// ============================================================================
//  lib/data/respiratory_profile_detail_data.dart
//
//  Contenu pédagogique SPÉCIFIQUE À CHAQUE PROFIL PATHOLOGIQUE pour chaque
//  paramètre ventilatoire. Affiché sur la page de détail (2ᵉ écran) quand
//  un profil autre que "Ventilation protectrice" est actif.
//
//  Architecture :
//  ┌─────────────────────────────────────────────────────────────┐
//  │  Map<VentilationProfile,                                    │
//  │      Map<String /* paramId */, ProfileParamNote>>           │
//  │                                                             │
//  │  ProfileParamNote = { value, badge, note,                   │
//  │                        adjustmentRows, monitoringPoints,    │
//  │                        footerSource }                       │
//  └─────────────────────────────────────────────────────────────┘
//
//  Utilisation côté UI (detail screen) :
//    final note = respiratoryProfileDetails[activeProfile]?[paramId];
//    if (note != null) { /* afficher la section profil */ }
//
//  Sources (référencement complet fourni séparément) :
//  ─ BPCO    : ERS/ATS COPD Guidelines ; Nunn's Applied Respiratory
//              Physiology 8ᵉ éd. ; SFAR RFE 2019
//  ─ SDRA    : ARDSNet NEJM 2000 ; Amato et al. NEJM 2015 ;
//              ESICM ARDS Guidelines 2023 ; SFAR/SRLF Reco SDRA
//  ─ Obésité : SFAR Ventilation périopératoire du patient obèse 2019 ;
//              Pelosi et al. Anesthesiology 2019
//  ─ Post-op : SFAR RFE Ventilation périopératoire 2019 ;
//              Futier et al. NEJM 2013 (IMPROVE trial)
// ============================================================================

import 'package:flutter/material.dart';
import '../models/respiratory_params.dart';
import '../models/respiratory_param_detail.dart'; // réutilise AdjustmentTableRow / MonitoringPoint

// ---------------------------------------------------------------------------
//  Données
// ---------------------------------------------------------------------------
final Map<VentilationProfile, Map<String, ProfileParamNote>>
    respiratoryProfileDetails = {
  // ══════════════════════════════════════════════════════════════════════════
  //  BPCO — Éviter l'hyperinflation dynamique / auto-PEEP
  //  [ERS/ATS COPD Guidelines ; Nunn's Applied Respiratory Physiology]
  // ══════════════════════════════════════════════════════════════════════════
  VentilationProfile.copd: {
    // ── Vt ──────────────────────────────────────────────────────────────────
    'vt': const ProfileParamNote(
      recommendedValue: '6 - 8',
      recommendedValueBadge: 'mL/kg PBW',
      contextNote:
          'Identique à la ventilation protectrice standard. La priorité est '
          'd\'allonger le temps expiratoire plutôt que de réduire le Vt.',
      adjustmentRows: [
        AdjustmentTableRow('Hypercapnie permissive tolérée',
            'Accepter une PaCO₂ 45-60 mmHg (pH > 7.25) avant d\'augmenter le Vt'),
        AdjustmentTableRow('Pressions élevées (auto-PEEP)',
            'Réduire la FR en priorité plutôt que le Vt'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.show_chart,
          title: 'Courbe de débit expiratoire',
          subtitle: 'Vérifier le retour à zéro avant le cycle suivant',
        ),
        MonitoringPoint(
          icon: Icons.monitor_heart,
          title: 'Gaz du sang artériels',
          subtitle: 'Tolérer une hypercapnie modérée si pH > 7.25',
        ),
      ],
      footerSource:
          'Source : ERS/ATS COPD Guidelines ; Nunn\'s Applied Respiratory Physiology 8ᵉ éd.',
    ),

    // ── FR ──────────────────────────────────────────────────────────────────
    'fr': const ProfileParamNote(
      recommendedValue: '10 - 12',
      recommendedValueBadge: '/min',
      contextNote:
          'La FR doit être réduite pour prolonger le temps expiratoire et '
          'permettre une vidange complète chez le patient obstructif.',
      adjustmentRows: [
        AdjustmentTableRow('Auto-PEEP détectée',
            'Diminuer la FR par paliers de 2/min jusqu\'à retour à zéro du débit'),
        AdjustmentTableRow('Hypercapnie sévère (pH < 7.20)',
            'Augmenter prudemment la FR tout en surveillant l\'auto-PEEP'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.bubble_chart_outlined,
          title: 'EtCO₂',
          subtitle: 'Objectif : normocapnie ou légère hypercapnie tolérée',
        ),
        MonitoringPoint(
          icon: Icons.show_chart,
          title: 'Débit expiratoire',
          subtitle: 'Doit revenir à zéro avant chaque nouvelle insufflation',
        ),
      ],
      footerSource:
          'Source : ERS/ATS COPD Guidelines ; SFAR RFE Ventilation périopératoire 2019',
    ),

    // ── PEEP ────────────────────────────────────────────────────────────────
    'peep': const ProfileParamNote(
      recommendedValue: '0 - 5',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'La PEEP extrinsèque doit être maintenue basse (≤ 5 cmH₂O) pour '
          'ne pas majorer l\'hyperinflation dynamique. Titrer en dessous de '
          '80 % de l\'auto-PEEP intrinsèque mesurée.',
      adjustmentRows: [
        AdjustmentTableRow('Auto-PEEP intrinsèque mesurée',
            'Fixer la PEEP extrinsèque à 50-80 % de l\'auto-PEEPi pour faciliter le trigger'),
        AdjustmentTableRow('Hypoxémie malgré PEEP 5 cmH₂O',
            'Augmenter la FiO₂ en priorité avant d\'augmenter la PEEP'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.change_history_rounded,
          title: 'Mesure de l\'auto-PEEP',
          subtitle: 'Pause expiratoire de 2-3 s (occlusion téléexpiratoire)',
        ),
        MonitoringPoint(
          icon: Icons.favorite,
          title: 'Hémodynamique',
          subtitle: 'Surveiller la PAM (risque d\'hyperinflation → ↓ retour veineux)',
        ),
      ],
      footerSource:
          'Source : Nunn\'s Applied Respiratory Physiology 8ᵉ éd. ; SFAR RFE 2019',
    ),

    // ── FiO₂ ────────────────────────────────────────────────────────────────
    'fio2': const ProfileParamNote(
      recommendedValue: '0.30 - 0.50',
      recommendedValueBadge: 'fraction',
      contextNote:
          'Cibler une SpO₂ de 88-92 % chez le patient BPCO hypercapnique '
          'chronique pour éviter l\'hyperoxie et la dépression du drive '
          'hypoxique (si patient en ventilation spontanée).',
      adjustmentRows: [
        AdjustmentTableRow('SpO₂ < 88 %',
            'Augmenter la FiO₂ par paliers de 0.05'),
        AdjustmentTableRow('SpO₂ > 92 % en stable',
            'Réduire la FiO₂ pour cibler 88-92 %'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.water_drop_outlined,
          title: 'SpO₂ cible BPCO',
          subtitle: '88-92 % (vs 92-96 % standard)',
        ),
      ],
      footerSource:
          'Source : ERS/ATS COPD Guidelines ; SFAR RFE 2019',
    ),

    // ── I:E ─────────────────────────────────────────────────────────────────
    'ie': const ProfileParamNote(
      recommendedValue: '1:3',
      recommendedValueBadge: 'Obstruction',
      contextNote:
          'Le rapport I:E doit être allongé (1:3 voire 1:4) pour permettre '
          'une vidange pulmonaire complète chez le patient obstructif.',
      adjustmentRows: [
        AdjustmentTableRow('Auto-PEEP persistante malgré 1:3',
            'Allonger à 1:4 si tolérance hémodynamique'),
        AdjustmentTableRow('Asthme aigu grave associé',
            'Rapport 1:4 voire plus, sous sédation profonde'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.show_chart,
          title: 'Débit expiratoire',
          subtitle: 'Retour à zéro obligatoire avant le cycle suivant',
        ),
      ],
      footerSource:
          'Source : ERS/ATS COPD Guidelines ; Nunn\'s Applied Respiratory Physiology 8ᵉ éd.',
    ),

    // ── Pplat ───────────────────────────────────────────────────────────────
    'pplat': const ProfileParamNote(
      recommendedValue: '≤ 30',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'La limite de 30 cmH₂O reste valide. Attention : chez le patient '
          'BPCO, la pression de crête peut être très élevée (résistances ↑) '
          'alors que la Pplat reste acceptable.',
      adjustmentRows: [
        AdjustmentTableRow('Pplat > 30 cmH₂O malgré Vt bas',
            'Suspecter une auto-PEEP élevée ou une bronchospasme'),
        AdjustmentTableRow('Ppic très élevée, Pplat normale',
            'Problème de résistances (sécrétions, bronchospasme) — non barotraumatique'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.compress_rounded,
          title: 'Gradient Ppic – Pplat',
          subtitle: 'Gradient élevé = résistances ↑ (bronchospasme, sécrétions)',
        ),
      ],
      footerSource:
          'Source : Nunn\'s Applied Respiratory Physiology 8ᵉ éd. ; SFAR RFE 2019',
    ),

    // ── Driving pressure ────────────────────────────────────────────────────
    'driving': const ProfileParamNote(
      recommendedValue: '< 15',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'Objectif identique. Chez le BPCO, la driving pressure doit être '
          'calculée en tenant compte de l\'auto-PEEP totale '
          '(PEEP extrinsèque + auto-PEEPi).',
      adjustmentRows: [
        AdjustmentTableRow('Driving pressure > 15 cmH₂O',
            'Optimiser la PEEP extrinsèque et réduire l\'auto-PEEPi'),
        AdjustmentTableRow('Compliance basse malgré PEEP optimisée',
            'Suspecter une hyperinflation dynamique résiduelle'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.compare_arrows_rounded,
          title: 'PEEP totale (extr. + intrinsèque)',
          subtitle: 'Recalculer la driving pressure avec la PEEP totale',
        ),
      ],
      footerSource:
          'Source : Amato et al. NEJM 2015 ; ERS/ATS COPD Guidelines',
    ),

    // ── Trigger ─────────────────────────────────────────────────────────────
    'trigger': const ProfileParamNote(
      recommendedValue: '1 - 3 L/min',
      recommendedValueBadge: 'ou -1 à -2 cmH₂O',
      contextNote:
          'En présence d\'auto-PEEP, le patient doit d\'abord contrebalancer '
          'la pression intrinsèque avant de déclencher le ventilateur. '
          'La PEEP extrinsèque permet de réduire ce travail.',
      adjustmentRows: [
        AdjustmentTableRow('Efforts inefficaces (auto-PEEP > PEEP extr.)',
            'Augmenter la PEEP extrinsèque pour faciliter le trigger'),
        AdjustmentTableRow('Auto-déclenchement',
            'Diminuer la sensibilité du trigger'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.touch_app_outlined,
          title: 'Efforts inefficaces',
          subtitle: 'Courbe de débit : synchronisation patient-ventilateur',
        ),
      ],
      footerSource:
          'Source : SFAR RFE 2019 ; Nunn\'s Applied Respiratory Physiology',
    ),
  },

  // ══════════════════════════════════════════════════════════════════════════
  //  SDRA — Protection pulmonaire renforcée
  //  [ARDSNet NEJM 2000 ; Amato NEJM 2015 ; ESICM 2023 ; SFAR/SRLF SDRA]
  // ══════════════════════════════════════════════════════════════════════════
  VentilationProfile.ards: {
    // ── Vt ──────────────────────────────────────────────────────────────────
    'vt': const ProfileParamNote(
      recommendedValue: '6',
      recommendedValueBadge: 'mL/kg PBW',
      contextNote:
          'Dans le SDRA, le Vt est limité à 6 mL/kg PBW (voire 4-6 mL/kg '
          'si driving pressure > 15 cmH₂O). Ne jamais dépasser 8 mL/kg '
          'sauf indication exceptionnelle.',
      adjustmentRows: [
        AdjustmentTableRow('Driving pressure > 15 cmH₂O',
            'Réduire le Vt par paliers de 1 mL/kg jusqu\'à 4 mL/kg minimum'),
        AdjustmentTableRow('Hypercapnie sévère (pH < 7.20)',
            'Envisager une épuration extracorporelle de CO₂ (ECCO₂R) avant d\'augmenter le Vt'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.monitor_heart,
          title: 'Gaz du sang artériels',
          subtitle: 'pH > 7.20 requis pour tolérer l\'hypercapnie permissive',
        ),
        MonitoringPoint(
          icon: Icons.compare_arrows_rounded,
          title: 'Driving pressure',
          subtitle: 'Recalculer après chaque modification du Vt ou de la PEEP',
        ),
      ],
      footerSource:
          'Source : ARDSNet NEJM 2000 ; Amato et al. NEJM 2015 ; ESICM ARDS Guidelines 2023',
    ),

    // ── FR ──────────────────────────────────────────────────────────────────
    'fr': const ProfileParamNote(
      recommendedValue: '20 - 30',
      recommendedValueBadge: '/min',
      contextNote:
          'La FR élevée compense la réduction du Vt pour maintenir un volume '
          'minute suffisant. Elle doit être titrée selon la PaCO₂ et le pH, '
          'sans dépasser 35/min (risque d\'auto-PEEP).',
      adjustmentRows: [
        AdjustmentTableRow('pH < 7.20 (hypercapnie sévère)',
            'Augmenter la FR jusqu\'à 35/min max, puis discuter ECCO₂R'),
        AdjustmentTableRow('Auto-PEEP détectée (FR > 30/min)',
            'Réduire légèrement la FR et augmenter la PEEP en compensation'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.bubble_chart_outlined,
          title: 'pH artériel',
          subtitle: 'Objectif : pH > 7.20 (hypercapnie permissive tolérée)',
        ),
        MonitoringPoint(
          icon: Icons.show_chart,
          title: 'Débit expiratoire',
          subtitle: 'Surveiller l\'auto-PEEP si FR > 28/min',
        ),
      ],
      footerSource:
          'Source : ARDSNet NEJM 2000 ; ESICM ARDS Guidelines 2023',
    ),

    // ── PEEP ────────────────────────────────────────────────────────────────
    'peep': const ProfileParamNote(
      recommendedValue: '8 - 15',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'La PEEP doit être titrée selon les tables ARDSNet (haute ou basse '
          'PEEP) ou selon la méthode de la compliance optimale. '
          'Une PEEP ≥ 10 cmH₂O est souvent requise dans le SDRA modéré à sévère.',
      adjustmentRows: [
        AdjustmentTableRow('SDRA modéré (PaO₂/FiO₂ 100-200)',
            'PEEP 8-12 cmH₂O selon table haute PEEP ARDSNet'),
        AdjustmentTableRow('SDRA sévère (PaO₂/FiO₂ < 100)',
            'PEEP 12-15 cmH₂O, discuter décubitus ventral ≥ 16h/jour'),
        AdjustmentTableRow('Instabilité hémodynamique',
            'Réduire la PEEP prudemment, remplissage vasculaire si besoin'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.water_drop_outlined,
          title: 'PaO₂/FiO₂ (rapport de Berlin)',
          subtitle: 'Guide la sévérité et le niveau de PEEP requis',
        ),
        MonitoringPoint(
          icon: Icons.favorite,
          title: 'Hémodynamique',
          subtitle: 'PAM, débit cardiaque — PEEP élevée ↓ retour veineux',
        ),
      ],
      footerSource:
          'Source : ARDSNet NEJM 2000 ; ESICM ARDS Guidelines 2023 ; SFAR/SRLF Reco SDRA',
    ),

    // ── FiO₂ ────────────────────────────────────────────────────────────────
    'fio2': const ProfileParamNote(
      recommendedValue: '0.50 - 1.0',
      recommendedValueBadge: 'fraction',
      contextNote:
          'La FiO₂ doit être ajustée selon les tables ARDSNet '
          '(combinaison FiO₂/PEEP). Cibler une SpO₂ de 88-95 % ou '
          'une PaO₂ de 55-80 mmHg.',
      adjustmentRows: [
        AdjustmentTableRow('SpO₂ < 88 %',
            'Augmenter FiO₂ et/ou PEEP selon table ARDSNet haute PEEP'),
        AdjustmentTableRow('FiO₂ > 0.6 prolongée',
            'Priorité à l\'optimisation de la PEEP pour réduire la FiO₂'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.water_drop_outlined,
          title: 'PaO₂ / SpO₂',
          subtitle: 'Objectif PaO₂ 55-80 mmHg ou SpO₂ 88-95 %',
        ),
        MonitoringPoint(
          icon: Icons.change_history_rounded,
          title: 'Table ARDSNet FiO₂/PEEP',
          subtitle: 'Utiliser la table haute PEEP si SDRA sévère',
        ),
      ],
      footerSource:
          'Source : ARDSNet NEJM 2000 ; ESICM ARDS Guidelines 2023',
    ),

    // ── Pplat ───────────────────────────────────────────────────────────────
    'pplat': const ProfileParamNote(
      recommendedValue: '≤ 30',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'La Pplat ≤ 30 cmH₂O est un objectif absolu dans le SDRA. '
          'Certains experts recommandent même de viser ≤ 28 cmH₂O pour '
          'maximiser la protection pulmonaire.',
      adjustmentRows: [
        AdjustmentTableRow('Pplat > 30 cmH₂O',
            'Réduire le Vt par paliers de 1 mL/kg (minimum 4 mL/kg)'),
        AdjustmentTableRow('Pplat inchangée malgré Vt ↓',
            'Optimiser la curarisation (48h) et la PEEP ; discuter décubitus ventral'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.compress_rounded,
          title: 'Pause inspiratoire',
          subtitle: 'Mesurer la Pplat toutes les 4-6h ou après chaque réglage',
        ),
      ],
      footerSource:
          'Source : ARDSNet NEJM 2000 ; SFAR/SRLF Reco SDRA',
    ),

    // ── Driving pressure ────────────────────────────────────────────────────
    'driving': const ProfileParamNote(
      recommendedValue: '< 15',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'Dans le SDRA, la driving pressure est le prédicteur de mortalité '
          'le plus puissant parmi les paramètres ventilatoires. '
          'Cibler ≤ 13 cmH₂O si possible.',
      adjustmentRows: [
        AdjustmentTableRow('Driving > 15 malgré Vt 6 mL/kg',
            'Optimiser la PEEP pour maximiser la compliance (courbe P-V)'),
        AdjustmentTableRow('Driving > 15 malgré PEEP optimisée',
            'Discuter décubitus ventral, curarisation 48h, VNI adjuvante'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.compare_arrows_rounded,
          title: 'Driving pressure',
          subtitle: 'Recalculer après chaque modification PEEP ou Vt',
        ),
        MonitoringPoint(
          icon: Icons.monitor_heart,
          title: 'Compliance statique',
          subtitle: 'Compliance = Vt / (Pplat − PEEP) — optimiser > 40 mL/cmH₂O',
        ),
      ],
      footerSource:
          'Source : Amato et al. NEJM 2015 ; ESICM ARDS Guidelines 2023',
    ),

    // ── I:E ─────────────────────────────────────────────────────────────────
    'ie': const ProfileParamNote(
      recommendedValue: '1:2',
      recommendedValueBadge: 'Standard',
      contextNote:
          'Le rapport 1:2 est recommandé en première intention. Un I:E inversé '
          '(1:1 ou 2:1) peut être envisagé dans le SDRA sévère réfractaire '
          'pour recruter des alvéoles, mais nécessite une sédation profonde.',
      adjustmentRows: [
        AdjustmentTableRow('Hypoxémie réfractaire SDRA sévère',
            'Discuter I:E inversé (1:1) sous sédation/curarisation'),
        AdjustmentTableRow('Auto-PEEP lors de FR élevée',
            'Réduire le temps inspiratoire pour allonger l\'expiration'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.show_chart,
          title: 'Courbe de débit',
          subtitle: 'I:E inversé nécessite une surveillance continue',
        ),
      ],
      footerSource:
          'Source : ESICM ARDS Guidelines 2023 ; SFAR/SRLF Reco SDRA',
    ),
  },

  // ══════════════════════════════════════════════════════════════════════════
  //  OBÉSITÉ — PEEP plus élevée, Vt sur PBW strict
  //  [SFAR Obèse 2019 ; Pelosi et al. Anesthesiology 2019]
  // ══════════════════════════════════════════════════════════════════════════
  VentilationProfile.obesity: {
    // ── Vt ──────────────────────────────────────════════════════════════────
    'vt': const ProfileParamNote(
      recommendedValue: '6 - 8',
      recommendedValueBadge: 'mL/kg PBW',
      contextNote:
          'Le Vt DOIT être calculé sur le poids idéal (PBW) et non sur le '
          'poids réel. Un Vt calculé sur le poids réel entraînerait un '
          'volotrauma grave chez le patient obèse.',
      adjustmentRows: [
        AdjustmentTableRow('Vt calculé sur poids réel (erreur fréquente)',
            'Recalculer sur PBW impérativement'),
        AdjustmentTableRow('Pplat élevée malgré Vt correct',
            'Vérifier la compliance de paroi (abdomino-thoracique) et optimiser la PEEP'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.monitor_heart,
          title: 'PBW calculé',
          subtitle: 'Hommes : 50 + 0.91×(taille cm−152.4) ; Femmes : 45.5 + 0.91×(taille cm−152.4)',
        ),
        MonitoringPoint(
          icon: Icons.compress_rounded,
          title: 'Pression plateau',
          subtitle: 'Peut être > 30 cmH₂O en raison de la compliance pariétale ↓',
        ),
      ],
      footerSource:
          'Source : SFAR Ventilation périopératoire patient obèse 2019 ; Pelosi et al. Anesthesiology 2019',
    ),

    // ── FR ──────────────────────────────────────────────────────────────────
    'fr': const ProfileParamNote(
      recommendedValue: '14 - 18',
      recommendedValueBadge: '/min',
      contextNote:
          'La FR légèrement augmentée compense la réduction de la CRF et '
          'le risque d\'atélectasie. La ventilation minute doit être titrée '
          'sur l\'EtCO₂ en peropératoire.',
      adjustmentRows: [
        AdjustmentTableRow('Hypercapnie peropératoire',
            'Augmenter la FR par paliers de 2/min, surveiller la Pplat'),
        AdjustmentTableRow('Trendelenburg inversé (position chirurgicale)',
            'Anticiper une amélioration de la compliance → réévaluer la FR'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.bubble_chart_outlined,
          title: 'EtCO₂',
          subtitle: 'Gradient EtCO₂-PaCO₂ souvent augmenté chez l\'obèse',
        ),
      ],
      footerSource:
          'Source : SFAR Ventilation périopératoire patient obèse 2019',
    ),

    // ── PEEP ────────────────────────────────────────────────────────────────
    'peep': const ProfileParamNote(
      recommendedValue: '8 - 12',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'Une PEEP plus élevée est nécessaire pour contrebalancer la '
          'pression abdominale sur le diaphragme, maintenir la CRF et prévenir '
          'les atélectasies de déclive.',
      adjustmentRows: [
        AdjustmentTableRow('Position Trendelenburg (peropératoire)',
            'Augmenter la PEEP jusqu\'à 10-15 cmH₂O'),
        AdjustmentTableRow('Instabilité hémodynamique',
            'Réduire la PEEP progressivement, préserver la volémie'),
        AdjustmentTableRow('IMC > 50 kg/m²',
            'Discuter une PEEP de 12-15 cmH₂O et une spirométrie d\'incitation en postop'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.change_history_rounded,
          title: 'Compliance statique',
          subtitle: 'Optimiser la PEEP pour obtenir la meilleure compliance',
        ),
        MonitoringPoint(
          icon: Icons.favorite,
          title: 'Hémodynamique',
          subtitle: 'PEEP élevée → risque de ↓ retour veineux, surveiller PAM',
        ),
      ],
      footerSource:
          'Source : SFAR Ventilation périopératoire patient obèse 2019 ; Pelosi et al. Anesthesiology 2019',
    ),

    // ── FiO₂ ────────────────────────────────────────────────────────────────
    'fio2': const ProfileParamNote(
      recommendedValue: '0.40 - 0.60',
      recommendedValueBadge: 'fraction',
      contextNote:
          'La FiO₂ standard est similaire à la ventilation protectrice. '
          'La désaturation rapide à l\'induction est le principal risque '
          'chez le patient obèse (préoxygénation rigoureuse indispensable).',
      adjustmentRows: [
        AdjustmentTableRow('Hypoxémie peropératoire',
            'Augmenter la FiO₂ et optimiser la PEEP avant toute autre mesure'),
        AdjustmentTableRow('SpO₂ stable > 96 %',
            'Réduire la FiO₂ à 0.4 pour limiter les atélectasies de résorption'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.water_drop_outlined,
          title: 'SpO₂',
          subtitle: 'Objectif : 92-96 %',
        ),
      ],
      footerSource:
          'Source : SFAR Ventilation périopératoire patient obèse 2019',
    ),

    // ── Pplat ───────────────────────────────────────────────────────────────
    'pplat': const ProfileParamNote(
      recommendedValue: '≤ 30',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'Chez l\'obèse, une Pplat > 30 cmH₂O peut refléter une compliance '
          'de paroi réduite (et non une lésion pulmonaire). '
          'La pression transpulmonaire (Pplat − pression œsophagienne) est '
          'le vrai reflet du stress alvéolaire.',
      adjustmentRows: [
        AdjustmentTableRow('Pplat > 30 malgré Vt correct',
            'Vérifier le contexte chirurgical (Trendelenburg, pneumopéritoine) avant de réduire le Vt'),
        AdjustmentTableRow('Pression transpulmonaire disponible',
            'Titrer la PEEP et le Vt sur la pression transpulmonaire < 25 cmH₂O'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.compress_rounded,
          title: 'Pression œsophagienne (si disponible)',
          subtitle: 'Permet de calculer la vraie compliance pulmonaire',
        ),
      ],
      footerSource:
          'Source : SFAR Ventilation périopératoire patient obèse 2019 ; Pelosi et al. Anesthesiology 2019',
    ),

    // ── I:E ─────────────────────────────────────────────────────────────────
    'ie': const ProfileParamNote(
      recommendedValue: '1:2',
      recommendedValueBadge: 'Standard',
      contextNote:
          'Le rapport 1:2 est conservé. Aucune modification spécifique à '
          'l\'obésité en l\'absence d\'obstruction associée.',
      adjustmentRows: [
        AdjustmentTableRow('Syndrome obésité-hypoventilation (SOH) avec BPCO',
            'Envisager 1:3 si obstruction significative associée'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.show_chart,
          title: 'Débit expiratoire',
          subtitle: 'Standard sauf comorbidité obstructive associée',
        ),
      ],
      footerSource:
          'Source : SFAR Ventilation périopératoire patient obèse 2019',
    ),
  },

  // ══════════════════════════════════════════════════════════════════════════
  //  POST-OPÉRATOIRE — Ventilation protectrice stricte, sevrage précoce
  //  [SFAR RFE 2019 ; Futier et al. NEJM 2013 — IMPROVE trial]
  // ══════════════════════════════════════════════════════════════════════════
  VentilationProfile.postOp: {
    // ── Vt ──────────────────────────────────────────────────────────────────
    'vt': const ProfileParamNote(
      recommendedValue: '6 - 8',
      recommendedValueBadge: 'mL/kg PBW',
      contextNote:
          'Identique à la ventilation protectrice standard. L\'essai IMPROVE '
          '(Futier 2013) a démontré une réduction des complications '
          'pulmonaires postopératoires avec un Vt de 6-8 mL/kg PBW + PEEP 6-8 cmH₂O.',
      adjustmentRows: [
        AdjustmentTableRow('Chirurgie abdominale majeure',
            'Appliquer strictement le protocole IMPROVE : Vt 6-8 mL/kg + PEEP 6-8 cmH₂O'),
        AdjustmentTableRow('Patient en sevrage (VS assistée)',
            'Titrer le support en pression pour maintenir un Vt 6-8 mL/kg sans effort excessif'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.monitor_heart,
          title: 'EtCO₂ peropératoire',
          subtitle: 'Objectif normocapnie (35-45 mmHg)',
        ),
        MonitoringPoint(
          icon: Icons.air_rounded,
          title: 'Vt en VS assistée',
          subtitle: 'Surveiller que le Vt reste < 8 mL/kg en décubitus',
        ),
      ],
      footerSource:
          'Source : Futier et al. NEJM 2013 (IMPROVE) ; SFAR RFE Ventilation périopératoire 2019',
    ),

    // ── FR ──────────────────────────────────────────────────────────────────
    'fr': const ProfileParamNote(
      recommendedValue: '12 - 16',
      recommendedValueBadge: '/min',
      contextNote:
          'La FR est titrée pour maintenir une normocapnie. '
          'En salle de réveil, la fréquence spontanée du patient doit guider '
          'le passage progressif vers la ventilation spontanée.',
      adjustmentRows: [
        AdjustmentTableRow('Frisson / agitation postopératoire (↑ CO₂)',
            'Augmenter transitoirement la FR, réchauffer le patient'),
        AdjustmentTableRow('Bradypnée sous opioïdes',
            'Évaluer le niveau de sédation, antagonisation si FR < 8/min'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.bubble_chart_outlined,
          title: 'EtCO₂ / Gaz du sang',
          subtitle: 'Ajuster la FR pour EtCO₂ 35-45 mmHg',
        ),
      ],
      footerSource:
          'Source : SFAR RFE Ventilation périopératoire 2019',
    ),

    // ── PEEP ────────────────────────────────────────────────────────────────
    'peep': const ProfileParamNote(
      recommendedValue: '5',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'Une PEEP de 5 cmH₂O est recommandée en peropératoire pour toute '
          'chirurgie. Elle est augmentée à 6-8 cmH₂O dans le protocole IMPROVE '
          'pour la chirurgie abdominale majeure.',
      adjustmentRows: [
        AdjustmentTableRow('Chirurgie abdominale majeure (IMPROVE)',
            'PEEP 6-8 cmH₂O associée à des manœuvres de recrutement'),
        AdjustmentTableRow('Thoracoscopie / ventilation unipulmonaire',
            'Envisager PEEP 5-8 cmH₂O sur le poumon ventilé'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.change_history_rounded,
          title: 'SpO₂ peropératoire',
          subtitle: 'La PEEP prévient les atélectasies peropératoires',
        ),
      ],
      footerSource:
          'Source : Futier et al. NEJM 2013 (IMPROVE) ; SFAR RFE Ventilation périopératoire 2019',
    ),

    // ── FiO₂ ────────────────────────────────────────────────────────────────
    'fio2': const ProfileParamNote(
      recommendedValue: '0.40 - 0.60',
      recommendedValueBadge: 'fraction',
      contextNote:
          'Une FiO₂ de 0.8 en peropératoire a été proposée pour réduire '
          'les infections de site opératoire, mais les données actuelles '
          'ne recommandent pas cette pratique systématiquement (SFAR 2019).',
      adjustmentRows: [
        AdjustmentTableRow('Chirurgie colorectale (données contradictoires)',
            'FiO₂ 0.5-0.8 selon les protocoles locaux, à discuter en équipe'),
        AdjustmentTableRow('SpO₂ > 96 % stable',
            'Réduire la FiO₂ vers 0.4 pour limiter les atélectasies de résorption'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.water_drop_outlined,
          title: 'SpO₂',
          subtitle: 'Objectif : 92-96 %',
        ),
      ],
      footerSource:
          'Source : SFAR RFE Ventilation périopératoire 2019',
    ),

    // ── Pplat ───────────────────────────────────────────────────────────────
    'pplat': const ProfileParamNote(
      recommendedValue: '≤ 30',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'La Pplat ≤ 30 cmH₂O est l\'objectif universel en peropératoire. '
          'Elle doit être mesurée régulièrement car la compliance peut changer '
          'selon la position chirurgicale.',
      adjustmentRows: [
        AdjustmentTableRow('Pneumopéritoine (cœlioscopie)',
            'La Pplat peut augmenter transitoirement ; vérifier la Pplat en fin d\'insufflation'),
        AdjustmentTableRow('Pplat > 30 malgré Vt correct',
            'Vérifier la position, le ballonnement abdominal, l\'obstruction de sonde'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.compress_rounded,
          title: 'Pplat peropératoire',
          subtitle: 'Mesurer après chaque changement de position ou insufflation',
        ),
      ],
      footerSource:
          'Source : SFAR RFE Ventilation périopératoire 2019',
    ),

    // ── I:E ─────────────────────────────────────────────────────────────────
    'ie': const ProfileParamNote(
      recommendedValue: '1:2',
      recommendedValueBadge: 'Standard',
      contextNote:
          'Le rapport 1:2 est standard en peropératoire. '
          'Il n\'y a pas de modification recommandée hors comorbidité obstructive.',
      adjustmentRows: [
        AdjustmentTableRow('Comorbidité BPCO associée',
            'Appliquer les recommandations BPCO : rapport 1:3'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.show_chart,
          title: 'Débit expiratoire',
          subtitle: 'Standard peropératoire',
        ),
      ],
      footerSource:
          'Source : SFAR RFE Ventilation périopératoire 2019',
    ),

    // ── Driving pressure ────────────────────────────────────────────────────
    'driving': const ProfileParamNote(
      recommendedValue: '< 15',
      recommendedValueBadge: 'cmH₂O',
      contextNote:
          'Une driving pressure < 15 cmH₂O peropératoire est associée à '
          'une réduction des complications pulmonaires postopératoires. '
          'C\'est un objectif de surveillance validé par les recommandations SFAR 2019.',
      adjustmentRows: [
        AdjustmentTableRow('Driving > 15 malgré Vt 6-8 mL/kg',
            'Optimiser la PEEP (manœuvre de recrutement suivie de décrémentation)'),
        AdjustmentTableRow('Compliance améliorée en cours de chirurgie',
            'Recalculer la driving pressure et réduire la PEEP si possible'),
      ],
      monitoringPoints: [
        MonitoringPoint(
          icon: Icons.compare_arrows_rounded,
          title: 'Driving pressure peropératoire',
          subtitle: 'Recalculer après chaque changement de position ou PEEP',
        ),
      ],
      footerSource:
          'Source : SFAR RFE Ventilation périopératoire 2019 ; Futier et al. NEJM 2013',
    ),
  },
};
