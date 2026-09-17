// ===========================
//  lib/data/emergency_drugs_data.dart
//  VERSION 2.0 — Médicaments d'urgence enrichis et vérifiés
//
//  SOURCES OFFICIELLES :
//  • AHA/ACC ACLS Guidelines 2020
//    https://cpr.heart.org/en/resuscitation-science/cpr-and-ecc-guidelines
//  • ERC Guidelines 2021
//    https://www.erc.edu/guidelines
//  • Surviving Sepsis Campaign 2021
//    https://www.sccm.org/SurvivingSepsisCampaign/Guidelines
//  • WAO Anaphylaxis Guidelines 2020
//    https://www.worldallergy.org/UserFiles/file/WAO-Anaphylaxis-Guidelines.pdf
//  • MHAUS Malignant Hyperthermia Protocol
//    https://www.mhaus.org/healthcare-professionals/mhaus-recommendations/
//  • Neurocritical Care Society EME Guidelines 2012
//    https://www.neurocriticalcare.org/resources/guidelines
//  • SFAR Recommandations 2020
//    https://sfar.org/recommandations/
//  • UpToDate 2024 — https://www.uptodate.com
//  • Miller's Anesthesia 9th Ed. (2019)
//  • FDA Drug Labels — https://www.accessdata.fda.gov/scripts/cder/daf/
// ===========================

import '../models/emergency_drug.dart';

const List<EmergencyDrug> emergencyDrugsData = [

  // ══════════════════════════════════════════════════════════════
  //  ARRÊT CARDIAQUE
  //  Source : AHA ACLS 2020 + ERC 2021
  //  https://cpr.heart.org/en/resuscitation-science/cpr-and-ecc-guidelines
  // ══════════════════════════════════════════════════════════════

  EmergencyDrug(
    name: 'Adrénaline (ACR)',
    category: EmergencyCategory.cardiacArrest,
    urgency: EmergencyUrgency.critical,
    doseUnit: 'mg',
    fixedDose: '1 mg IV/IO',
    route: 'IV/IO',
    notes: 'AHA 2020 : q3–5 min pendant RCP. FV/TV après 2e choc. Asystolie/AESP dès accès vasculaire. Si pas IV : IO huméral ou tibial.',
    canRepeat: true,
    repeatInterval: 'q3–5 min',
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Amiodarone',
    category: EmergencyCategory.cardiacArrest,
    urgency: EmergencyUrgency.critical,
    doseUnit: 'mg',
    fixedDose: '300 mg IV/IO',
    route: 'IV/IO bolus',
    notes: 'FV/TV réfractaire après 3e choc (AHA 2020). 2e dose : 150 mg IV. Diluer dans G5% 20 ml.',
    canRepeat: true,
    repeatInterval: '2e dose 150 mg si FV persist.',
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Lidocaïne (ACR)',
    category: EmergencyCategory.cardiacArrest,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 1.0,
    doseUnit: 'mg/kg',
    fixedDose: '1–1.5 mg/kg IV/IO',
    route: 'IV/IO',
    notes: 'Alternative amiodarone si indisponible (AHA 2020). Max 3 mg/kg total. Puis perfusion 2 mg/min.',
    canRepeat: true,
    repeatInterval: '0.5–0.75 mg/kg q5–10 min (max 3 mg/kg)',
    maxDose: 300,
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Atropine',
    category: EmergencyCategory.cardiacArrest,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.02,
    doseUnit: 'mg/kg',
    fixedDose: '0.5–1 mg IV',
    route: 'IV',
    notes: 'Bradycardie symptomatique. Min 0.5 mg (bradycardie paradoxale si <0.5 mg). Max 3 mg total. Pédiatrie : 0.02 mg/kg.',
    canRepeat: true,
    repeatInterval: 'q3–5 min (max 3 mg total)',
    maxDose: 3.0,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Bicarbonate de Sodium',
    category: EmergencyCategory.cardiacArrest,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 1.0,
    doseUnit: 'mEq/kg',
    fixedDose: '50 mEq (50 ml NaHCO₃ 8.4%) IV',
    route: 'IV lent',
    notes: 'AHA 2020 : pas en routine. Indications : acidose sévère documentée pH<7.1, hyperkaliémie menaçante, intoxication tricycliques. Rincer la voie IV avant et après.',
    canRepeat: false,
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Sulfate de Magnésium',
    category: EmergencyCategory.cardiacArrest,
    urgency: EmergencyUrgency.urgent,
    doseUnit: 'g',
    fixedDose: '1–2 g IV',
    route: 'IV en 1–2 min',
    notes: 'Torsades de pointes. FV associée à hypomagnésémie. Pré-éclampsie. Grossesse : 4 g IV sur 20 min.',
    canRepeat: false,
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Gluconate de Calcium',
    category: EmergencyCategory.cardiacArrest,
    urgency: EmergencyUrgency.urgent,
    doseUnit: 'g',
    fixedDose: '1–2 g IV',
    route: 'IV en 3–5 min',
    notes: 'Hyperkaliémie avec anomalies ECG + hypocalcémie + overdose bloqueurs calciques. Durée protection membranaire : 30–60 min.',
    canRepeat: true,
    repeatInterval: 'q30 min si ECG non normalisé',
    isFirstLine: false,
  ),

  // ══════════════════════════════════════════════════════════════
  //  INTUBATION / SRI
  //  Source : Miller's Anesthesia 9th Ed. + SFAR SRI 2017
  //  https://sfar.org/recommandations/
  // ══════════════════════════════════════════════════════════════

  EmergencyDrug(
    name: 'Kétamine (SRI)',
    category: EmergencyCategory.intubation,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 1.5,
    doseUnit: 'mg/kg',
    fixedDose: '1.5 mg/kg IV',
    route: 'IV en 60 sec',
    notes: '1ère ligne si instabilité hémodynamique, choc, bronchospasme, trauma (Miller\'s 9th). Délai 45–60 sec. CI : HIC non contrôlée.',
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Propofol (SRI)',
    category: EmergencyCategory.intubation,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 1.5,
    doseUnit: 'mg/kg',
    fixedDose: '1.5–2 mg/kg IV',
    route: 'IV en 30–60 sec',
    notes: 'Patient stable hémodynamiquement. Réduire 1 mg/kg si >55 ans. CI : allergie huile de soja/lécithine œuf.',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Étomidate (SRI)',
    category: EmergencyCategory.intubation,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.3,
    doseUnit: 'mg/kg',
    fixedDose: '0.3 mg/kg IV',
    route: 'IV en 30–60 sec',
    notes: 'Réserve CV réduite (IC, coronaropathie). Dose UNIQUE uniquement. Suppression surrénalienne 6–12h.',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Rocuronium (SRI)',
    category: EmergencyCategory.intubation,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 1.2,
    doseUnit: 'mg/kg',
    fixedDose: '1.2 mg/kg IV',
    route: 'IV bolus',
    notes: 'Délai 60 sec. Durée 60–90 min. ANTIDOTE : Sugammadex 16 mg/kg OBLIGATOIREMENT disponible avant SRI. CI : allergie sugammadex.',
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Succinylcholine (SRI)',
    category: EmergencyCategory.intubation,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 1.5,
    doseUnit: 'mg/kg',
    fixedDose: '1.5 mg/kg IV',
    route: 'IV bolus',
    notes: 'Délai 45 sec, durée 10 min. CI absolues : hyperkaliémie, brûlures >48h, crush, myopathies, déficit pseudocholinestérase, HM.',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Lidocaïne (Prétraitement SRI)',
    category: EmergencyCategory.intubation,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 1.5,
    doseUnit: 'mg/kg',
    fixedDose: '1.5 mg/kg IV',
    route: 'IV en 60 sec',
    notes: 'OPTIONNEL — HTIC : administrer 90 sec avant laryngoscopie. Atténue montée PIC. Antiarythmique secondaire.',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Sugammadex (CICV)',
    category: EmergencyCategory.intubation,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 16.0,
    doseUnit: 'mg/kg',
    fixedDose: '16 mg/kg IV',
    route: 'IV bolus rapide',
    notes: 'CICV après rocuronium : inverser complètement en <3 min. Doit être disponible AVANT tout SRI. Inversion modérée : 2 mg/kg. Inversion profonde : 4 mg/kg.',
    maxDose: 200,
    isFirstLine: true,
  ),

  // ══════════════════════════════════════════════════════════════
  //  ANAPHYLAXIE
  //  Source : WAO 2020 + SFAR 2011
  //  https://www.worldallergy.org/UserFiles/file/WAO-Anaphylaxis-Guidelines.pdf
  // ══════════════════════════════════════════════════════════════

  EmergencyDrug(
    name: 'Adrénaline (Anaphylaxie)',
    category: EmergencyCategory.anaphylaxis,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.01,
    doseUnit: 'mg/kg',
    fixedDose: '0.5 mg IM',
    route: 'IM cuisse antérolatérale',
    notes: '1ÈRE LIGNE ABSOLUE — WAO 2020. Ne JAMAIS retarder pour accès IV. Répéter q5–15 min. Péri-opératoire IV : 0.1–0.2 mg titré.',
    canRepeat: true,
    repeatInterval: 'q5–15 min si insuffisant',
    maxDose: 0.5,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Chlorphénamine',
    category: EmergencyCategory.anaphylaxis,
    urgency: EmergencyUrgency.urgent,
    doseUnit: 'mg',
    fixedDose: '10 mg IV',
    route: 'IV lent (5 min)',
    notes: 'Anti-H1 — 2ème ligne APRÈS adrénaline et stabilisation. Ne jamais en 1ère intention (WAO 2020).',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Hydrocortisone (Anaphylaxie)',
    category: EmergencyCategory.anaphylaxis,
    urgency: EmergencyUrgency.urgent,
    doseUnit: 'mg',
    fixedDose: '200 mg IV',
    route: 'IV lent',
    notes: 'Prévention réaction biphasique — 2ème ligne. Effet différé 4–6h. Jamais en 1ère intention. Salbutamol nébulisé si bronchospasme persistant.',
    isFirstLine: false,
  ),

  // ══════════════════════════════════════════════════════════════
  //  VASOPRESSEURS
  //  Source : Surviving Sepsis Campaign 2021 + SCCM Guidelines
  //  https://www.sccm.org/SurvivingSepsisCampaign/Guidelines
  // ══════════════════════════════════════════════════════════════

  EmergencyDrug(
    name: 'Noradrénaline',
    category: EmergencyCategory.vasopressors,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 0.05,
    doseUnit: 'mcg/kg/min',
    fixedDose: '0.05–0.5 mcg/kg/min',
    route: 'IVSE voie centrale préférentielle',
    notes: '1ÈRE LIGNE choc septique (SCCM 2021). Diluer G5% uniquement. Voie centrale idéalement. VVP temporaire possible à faible dose.',
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Vasopressine',
    category: EmergencyCategory.vasopressors,
    urgency: EmergencyUrgency.urgent,
    doseUnit: 'U/min',
    fixedDose: '0.03–0.04 U/min',
    route: 'IVSE voie centrale',
    notes: 'Adjuvant noradrénaline ≥0.25 mcg/kg/min (SSC 2021). DOSE FIXE — ne pas titrer au-delà de 0.04 U/min (ischémie mésentérique).',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Dobutamine',
    category: EmergencyCategory.vasopressors,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 5.0,
    doseUnit: 'mcg/kg/min',
    fixedDose: '2–20 mcg/kg/min',
    route: 'IVSE voie centrale',
    notes: 'Choc cardiogénique (ESC 2021). Associer à noradrénaline si PAM <65. Tachyarythmies >10 mcg/kg/min.',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Phényléphrine',
    category: EmergencyCategory.vasopressors,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 1.0,
    doseUnit: 'mcg/kg/min',
    fixedDose: '0.5–5 mcg/kg/min',
    route: 'IVSE ou bolus IV 50–200 mcg',
    notes: 'Agoniste α1 pur — pas de tachycardie. Rachianesthésie obstétricale (préféré à l\'éphédrine si FC normale). Bolus 50–200 mcg IV si accès rapide.',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Éphédrine',
    category: EmergencyCategory.vasopressors,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 0.1,
    doseUnit: 'mg/kg',
    fixedDose: '3–12 mg IV bolus',
    route: 'IV bolus',
    notes: 'Hypotension peranesthésique légère à modérée. Tachyphylaxie après 2–3 doses. Passer à noradrénaline si inefficace.',
    canRepeat: true,
    repeatInterval: 'q3–5 min (max 3 répétitions)',
    maxDose: 50,
    isFirstLine: false,
  ),

  // ══════════════════════════════════════════════════════════════
  //  ANTIDOTES / ANTAGONISTES / REVERSAL AGENTS
  //  Source : FDA + UpToDate 2024 + Miller's 9th Ed.
  // ══════════════════════════════════════════════════════════════

  EmergencyDrug(
    name: 'Sugammadex',
    category: EmergencyCategory.reversal,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 16.0,
    doseUnit: 'mg/kg',
    fixedDose: '2–16 mg/kg IV',
    route: 'IV bolus rapide (10 sec)',
    notes: 'CICV rocuronium : 16 mg/kg. Bloc profond (PTC 1–2) : 4 mg/kg. Bloc modéré (TOF T2) : 2 mg/kg. Inversion complète <3 min.',
    maxDose: 200,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Naloxone',
    category: EmergencyCategory.reversal,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.01,
    doseUnit: 'mg/kg',
    fixedDose: '0.04–0.4 mg IV',
    route: 'IV/IM/SC/IN',
    notes: 'Titration par 0.04 mg IV q2–3 min (FR>12/min, SaO₂ >92%). Éviter dose pleine (0.4 mg) = syndrome de sevrage brutal + douleur aiguë. Max 10 mg total. Durée d\'action <1h < opioïde — surveiller récidive.',
    canRepeat: true,
    repeatInterval: 'q2–3 min (titration)',
    maxDose: 10.0,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Flumazénil',
    category: EmergencyCategory.reversal,
    urgency: EmergencyUrgency.urgent,
    doseUnit: 'mg',
    fixedDose: '0.2 mg IV',
    route: 'IV en 15 sec',
    notes: 'Antagoniste BZD. Répéter 0.2 mg q1 min (max 1 mg). CI : épilepsie sous BZD, BZD au long cours (crise convulsive de sevrage). Durée action 30–60 min < BZD → récidive sédation possible.',
    canRepeat: true,
    repeatInterval: 'q1 min (max 1 mg total puis perfusion 0.1 mg/h)',
    maxDose: 1.0,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Intralipide 20%',
    category: EmergencyCategory.reversal,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 1.5,
    doseUnit: 'ml/kg',
    fixedDose: '1.5 ml/kg bolus IV',
    route: 'IV bolus rapide puis IVSE',
    notes: 'LAST (toxicité systémique anesthésiques locaux) — ASRA guidelines. Bolus 1.5 ml/kg en 1 min, répéter x2 si inefficace. Puis IVSE 0.25 ml/kg/min x10 min. Max 10 ml/kg. DOIT être disponible dans tout bloc d\'ALR.',
    canRepeat: true,
    repeatInterval: '1.5 ml/kg à 5 min si inefficace (max 3 bolus)',
    maxDose: 500,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Néostigmine',
    category: EmergencyCategory.reversal,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 0.04,
    doseUnit: 'mg/kg',
    fixedDose: '2.5–5 mg IV',
    route: 'IV lent',
    notes: 'Antagoniste non spécifique (atracurium, cisatracurium). TOUJOURS associer glycopyrrolate 0.01 mg/kg ou atropine 0.02 mg/kg. Efficace seulement si TOF ≥10% (au moins 1 réponse/4). Max 5 mg.',
    maxDose: 5.0,
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'N-Acétylcystéine (NAC)',
    category: EmergencyCategory.reversal,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 150.0,
    doseUnit: 'mg/kg',
    fixedDose: '150 mg/kg sur 1h',
    route: 'IV (protocole 3 poches)',
    notes: 'Surdosage paracétamol. Protocole : Poche 1 : 150 mg/kg/60 min. Poche 2 : 12.5 mg/kg/4h. Poche 3 : 6.25 mg/kg/16h. Efficace si <8–10h du surdosage. Contacter toxicologie.',
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Dantrolène',
    category: EmergencyCategory.reversal,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 2.5,
    doseUnit: 'mg/kg',
    fixedDose: '2.5 mg/kg IV bolus',
    route: 'IV bolus IMMÉDIAT',
    notes: 'HYPERTHERMIE MALIGNE (MHAUS protocol). Répéter q5 min jusqu\'à résolution. Dose typique 10 mg/kg. Max 30 mg/kg. Dissoudre dans 60 ml eau stérile chaude (peu soluble). 36 flacons obligatoires en bloc opératoire.',
    canRepeat: true,
    repeatInterval: 'q5 min jusqu\'à ETCO₂ normal et T°<38.5°C',
    maxDose: 1500,
    isFirstLine: true,
  ),

  // ══════════════════════════════════════════════════════════════
  //  CONVULSIONS / ÉTAT DE MAL ÉPILEPTIQUE
  //  Source : NCS Guidelines 2012 + Epilepsia 2015
  //  https://www.neurocriticalcare.org/resources/guidelines
  // ══════════════════════════════════════════════════════════════

  EmergencyDrug(
    name: 'Lorazépam',
    category: EmergencyCategory.seizure,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.1,
    doseUnit: 'mg/kg',
    fixedDose: '4 mg IV',
    route: 'IV en 2 min',
    notes: '1ÈRE LIGNE EME avec accès IV (NCS 2012). Répéter 1x à 5 min. Max 8 mg. Réfrigération requise.',
    canRepeat: true,
    repeatInterval: '1x à 5 min si convulsions persistent',
    maxDose: 8.0,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Midazolam (EME sans IV)',
    category: EmergencyCategory.seizure,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.2,
    doseUnit: 'mg/kg',
    fixedDose: '10 mg IM ou IN',
    route: 'IM face externe cuisse ou IN',
    notes: 'Sans accès IV (RAMPART trial, NEJM 2012 : IM > lorazépam IV). IN : 5 mg/narine. Délai d\'action 5 min.',
    maxDose: 10.0,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Diazépam',
    category: EmergencyCategory.seizure,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.15,
    doseUnit: 'mg/kg',
    fixedDose: '10 mg IV ou 10–20 mg rectal',
    route: 'IV ou rectal',
    notes: 'Alternative lorazépam. Rectal si pas d\'IV et pas de midazolam IM. Accumulation en usage répété.',
    canRepeat: true,
    repeatInterval: 'q5–10 min (max 30 mg)',
    maxDose: 30.0,
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Valproate de Sodium',
    category: EmergencyCategory.seizure,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 30.0,
    doseUnit: 'mg/kg',
    fixedDose: '30–40 mg/kg IV',
    route: 'IV en 10 min',
    notes: '2ème ligne EME établi. Max 3000 mg. CI : grossesse (tératogène), IHC, mitochondriopathie. Préférable au phénobarbital en 1ère 2ème ligne.',
    maxDose: 3000,
    isFirstLine: true,
  ),
  EmergencyDrug(
    name: 'Lévétiracétam',
    category: EmergencyCategory.seizure,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 60.0,
    doseUnit: 'mg/kg',
    fixedDose: '60 mg/kg IV',
    route: 'IV en 15 min',
    notes: '2ème ligne alternative valproate. Max 4500 mg. Peu d\'interactions. Sûr grossesse. Ajuster dose si IRC.',
    maxDose: 4500,
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Phénytoïne',
    category: EmergencyCategory.seizure,
    urgency: EmergencyUrgency.urgent,
    dosePerKg: 20.0,
    doseUnit: 'mg/kg',
    fixedDose: '20 mg/kg IV lent',
    route: 'IV lent (max 50 mg/min)',
    notes: '2ème ligne alternative. Monitoring ECG OBLIGATOIRE (arythmies à injection rapide). Diluer dans NaCl 0.9% uniquement (précipite en G5%). Fenêtre thérapeutique étroite.',
    isFirstLine: false,
  ),
  EmergencyDrug(
    name: 'Midazolam (EME réfractaire IVSE)',
    category: EmergencyCategory.seizure,
    urgency: EmergencyUrgency.critical,
    dosePerKg: 0.2,
    doseUnit: 'mg/kg',
    fixedDose: '0.2 mg/kg IV bolus',
    route: 'IV/IM/IN puis IVSE',
    notes: 'EME réfractaire avec intubation. Puis IVSE 0.05–2 mg/kg/h. Monitoring EEG burst-suppression cible.',
    isFirstLine: false,
  ),
];