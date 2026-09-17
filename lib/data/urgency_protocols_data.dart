// ===========================
//  lib/data/urgency_protocols_data.dart
//  VERSION 2.0 — Protocoles d'URGENCE enrichis et vérifiés
//
//  SOURCES OFFICIELLES :
//  • AHA/ACC ACLS Guidelines 2020
//    https://cpr.heart.org/en/resuscitation-science/cpr-and-ecc-guidelines
//  • ERC Guidelines 2021
//    https://www.erc.edu/guidelines
//  • ATLS 10th Edition (American College of Surgeons) 2018
//    https://www.facs.org/quality-programs/trauma/atls/
//  • WAO Anaphylaxis Guidelines 2020
//    https://www.worldallergy.org/UserFiles/file/WAO-Anaphylaxis-Guidelines.pdf
//  • SFAR Recommandations Anaphylaxie Peropératoire 2011
//    https://sfar.org/recommandations/
//  • EAST Guidelines Trauma Hemorrhage 2019
//    https://www.east.org/education/practice-management-guidelines
//  • Neurocritical Care Society EME Guidelines 2012
//    https://www.neurocriticalcare.org/resources/guidelines
//  • Miller's Anesthesia 9th Ed. (2019)
//  • UpToDate 2024 — https://www.uptodate.com
// ===========================

import '../models/emergency_drug.dart';

const List<EmergencyProtocol> urgencyProtocols = [
  // ══════════════════════════════════════════════════════════════
  //  ARRÊT CARDIAQUE — ACLS / RCP
  //  Source : AHA ACLS Guidelines 2020
  //  https://cpr.heart.org/en/resuscitation-science/cpr-and-ecc-guidelines
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'cardiac_arrest',
    title: 'Arrêt Cardiaque',
    subtitle: 'ACLS / RCP — AHA 2020',
    emoji: '🫀',
    colorKey: 'red',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Confirmer l\'arrêt cardiaque',
        detail: 'Absence de pouls carotidien + absence de respiration normale (≤10 sec). Appeler à l\'aide + déclencher alerte réanimation + noter l\'heure.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'RCP immédiate — Haute qualité',
        detail: 'Compressions thoraciques : 100–120/min, profondeur 5–6 cm, recoil complet. Ratio 30:2 sans voie aérienne avancée. Minimiser les interruptions (<10 sec). Relève toutes les 2 min.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Défibrillation précoce',
        detail: 'Analyse du rythme dès arrivée du DAE/défibrillateur. Rythme choquable (FV/TV sans pouls) : 1 choc biphasique 200 J (ou max appareil). Reprendre RCP immédiatement après choc sans vérification du pouls.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Adrénaline IV/IO',
        detail: 'Asystolie/AESP : adrénaline 1 mg IV/IO dès accès vasculaire. FV/TV : adrénaline 1 mg IV/IO après 2e choc inefficace. Répéter q3–5 min. Pas de voie IV : IO huméral ou tibial.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Amiodarone ou Lidocaïne',
        detail: 'FV/TV réfractaire après 3e choc : Amiodarone 300 mg IV/IO bolus. 2e dose : 150 mg IV/IO. Alternative : Lidocaïne 1–1.5 mg/kg IV/IO puis 0.5–0.75 mg/kg q5–10 min (max 3 mg/kg).',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Voie aérienne avancée',
        detail: 'Intubation oro-trachéale ou dispositif supra-glottique (i-gel, LMA). Une fois en place : 10 ventilations/min sans pause des compressions. Confirmer par capnographie (ETCO₂ cible ≥10 mmHg).',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Causes réversibles — 4H / 4T',
        detail: '4H : Hypoxie → O₂ 100%. Hypovolémie → remplissage rapide. Hypothermie → réchauffer. Hypo/Hyperkaliémie → corriger (Ca²⁺, bicarbonate). | 4T : Tamponnade → péricardocentèse. Toxiques → antidotes. Thrombose coronaire → thrombolyse/PCI. Tension PTX → exsufflation.',
      ),
      ProtocolStep(
        stepNumber: 8,
        title: 'Soins post-réanimation (ROSC)',
        detail: 'PAS cible ≥90 mmHg. SpO₂ 94–98% (éviter hyperoxie). PaCO₂ 35–45 mmHg. Hypothermie thérapeutique 32–36°C si coma persistant. ECG 12 dérivations — coronarographie si suspicion SCA.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Adrénaline',
        category: EmergencyCategory.cardiacArrest,
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '1 mg IV/IO',
        route: 'IV/IO',
        notes: 'Répéter q3–5 min pendant RCP. FV/TV après 2e choc. Asystolie/AESP dès accès IV.',
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
        route: 'IV/IO',
        notes: 'FV/TV réfractaire après 3e choc. 2e dose : 150 mg IV/IO.',
        canRepeat: true,
        repeatInterval: '150 mg 2e dose',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Lidocaïne',
        category: EmergencyCategory.cardiacArrest,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 1.0,
        doseUnit: 'mg/kg',
        fixedDose: '1–1.5 mg/kg IV/IO',
        route: 'IV/IO',
        notes: 'Alternative amiodarone si indisponible. Max 3 mg/kg total. Puis 2 mg/min en perfusion.',
        canRepeat: true,
        repeatInterval: '0.5–0.75 mg/kg q5–10 min',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Bicarbonate de Sodium',
        category: EmergencyCategory.cardiacArrest,
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 1.0,
        doseUnit: 'mEq/kg',
        fixedDose: '1 mEq/kg IV',
        route: 'IV lent',
        notes: 'Acidose sévère documentée (pH<7.1) ou hyperkaliémie. Pas en routine.',
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
        notes: 'Torsades de pointes / FV associée à hypomagnésémie.',
        canRepeat: false,
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Gluconate de Calcium',
        category: EmergencyCategory.cardiacArrest,
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'g',
        fixedDose: '1 g IV',
        route: 'IV lent (5 min)',
        notes: 'Hyperkaliémie avec anomalies ECG ou hypocalcémie. Protection membranaire.',
        canRepeat: true,
        repeatInterval: 'q10 min si ECG non normalisé',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  SRI — INTUBATION EN SÉQUENCE RAPIDE
  //  Source : Miller's Anesthesia 9th Ed. + SFAR SRI 2017
  //  https://sfar.org/recommandations/
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'rsi',
    title: 'Intubation SRI',
    subtitle: 'Séquence Rapide d\'Intubation — Miller\'s + SFAR 2017',
    emoji: '🫁',
    colorKey: 'orange',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Préparation SOAPME',
        detail: 'S = Succion (aspiration fonctionnelle). O = Oxygen (O₂ 15L/min). A = Airway (laryngoscope, sondes 7.0-8.0, mandrin, LMA de secours, Bougie). P = Pharmacology (induction + curare). M = Monitors (SpO₂, ETCO₂, ECG, PNI). E = Equipment (seringues, voies IV, capnographe).',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Préoxygénation optimale',
        detail: 'Masque haute concentration O₂ 100% pendant 3 min (8 respirations à capacité vitale si urgence). VNI ou OHD si SpO₂ <95% malgré MHC. Position assise à 20–30° si non traumatisé. Cible SpO₂ ≥95% avant laryngoscopie.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Prétraitement (optionnel, 3 min avant)',
        detail: 'HTIC : Lidocaïne 1.5 mg/kg IV 90 sec avant — atténue ↑PIC lors de laryngoscopie. Pédiatrie <8 ans : Atropine 0.02 mg/kg IV (min 0.1 mg) — prévention bradycardie vagale. Instable : éviter tout prétraitement hypotensif.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Induction — Hypnotique',
        detail: 'Instable hémodynamique (PAM<65, choc) : Kétamine 1.5 mg/kg IV. Patient stable : Propofol 1.5–2 mg/kg IV. HTIC, état épileptique : Propofol ou Thiopental 3–5 mg/kg IV. IC sévère, réserve CV réduite : Étomidate 0.3 mg/kg IV (dose unique). Injection simultanée avec curare.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Curare — SRI',
        detail: 'Rocuronium 1.2 mg/kg IV : délai 60 sec, durée 60–90 min. Antidote : Sugammadex 16 mg/kg disponible OBLIGATOIREMENT. Succinylcholine 1.5 mg/kg IV : délai 45 sec, durée 10–12 min — CI formelles (hyperkaliémie, brûlures, crush). Attendre 60 sec complets avant laryngoscopie.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Laryngoscopie et intubation',
        detail: 'Laryngoscopie directe (Macintosh lame 3–4) ou vidéolaryngoscope (Glidescope, C-MAC). Sonde 7.0-8.0 mm H (femme 7.0-7.5 ; homme 7.5-8.0). Mandrin : utiliser si visibilité limitée. Gonflage manchon à 20–30 cmH₂O. Ne pas appliquer la pression cricoïde si elle gêne la vue.',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Confirmation et sécurisation',
        detail: 'Capnographie = SEULE méthode fiable (ETCO₂ ≥35 mmHg = position trachéale confirmée). Auscultation bilatérale et epigastrique. Rx thorax en postopératoire (profondeur sonde). Fixer la sonde. Initier ventilation : VT 6–8 ml/kg, FR 12–16/min, PEEP 5 cmH₂O.',
      ),
      ProtocolStep(
        stepNumber: 8,
        title: 'Plan B — Voies aériennes difficiles',
        detail: 'Échec 1ère tentative : appeler à l\'aide immédiatement. 2ème tentative avec optimisation (BURP, mandrin, lame différente, vidéolaryngoscope). Échec 2ème : LMA i-gel ou LMA Fastrach + ventilation. CICV : Sugammadex 16 mg/kg si rocuronium. Cricothyrotomie chirurgicale si CICV persistant.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Kétamine',
        category: EmergencyCategory.intubation,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 1.5,
        doseUnit: 'mg/kg',
        fixedDose: '1.5 mg/kg IV',
        route: 'IV en 60 sec',
        notes: '1ère ligne si instabilité hémodynamique (choc, trauma, bronchospasme). Stimulant CV.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Rocuronium',
        category: EmergencyCategory.intubation,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 1.2,
        doseUnit: 'mg/kg',
        fixedDose: '1.2 mg/kg IV',
        route: 'IV bolus',
        notes: 'SRI : délai 60 sec. Antidote : Sugammadex 16 mg/kg OBLIGATOIREMENT disponible.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Sugammadex',
        category: EmergencyCategory.reversal,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 16.0,
        doseUnit: 'mg/kg',
        fixedDose: '16 mg/kg IV',
        route: 'IV bolus rapide',
        notes: 'CICV après rocuronium — inverser complètement en <3 min. DOIT être disponible avant tout SRI au rocuronium.',
        maxDose: 200,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Propofol',
        category: EmergencyCategory.intubation,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 1.5,
        doseUnit: 'mg/kg',
        fixedDose: '1.5–2 mg/kg IV',
        route: 'IV en 30–60 sec',
        notes: 'Patient stable hémodynamiquement. Réduire à 1 mg/kg si >55 ans ou instable.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Succinylcholine',
        category: EmergencyCategory.intubation,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 1.5,
        doseUnit: 'mg/kg',
        fixedDose: '1.5 mg/kg IV',
        route: 'IV bolus',
        notes: 'Délai 45 sec, durée 10 min. CI : hyperkaliémie, brûlures >48h, crush, myopathies.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Étomidate',
        category: EmergencyCategory.intubation,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.3,
        doseUnit: 'mg/kg',
        fixedDose: '0.3 mg/kg IV',
        route: 'IV en 30–60 sec',
        notes: 'Réserve CV réduite. Dose UNIQUE — suppression surrénalienne. Prémédication fentanyl.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Lidocaïne (prétraitement)',
        category: EmergencyCategory.intubation,
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 1.5,
        doseUnit: 'mg/kg',
        fixedDose: '1.5 mg/kg IV',
        route: 'IV en 60 sec',
        notes: 'Optionnel — HTIC. Administrer 90 sec avant laryngoscopie. Atténue montée PIC.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  ANAPHYLAXIE
  //  Source : WAO Anaphylaxis Guidelines 2020
  //  https://www.worldallergy.org/UserFiles/file/WAO-Anaphylaxis-Guidelines.pdf
  //  SFAR Recommandations 2011
  //  https://sfar.org/recommandations/
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'anaphylaxis',
    title: 'Anaphylaxie',
    subtitle: 'WAO 2020 / SFAR 2011 — Réaction sévère',
    emoji: '⚠️',
    colorKey: 'red',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître et appeler à l\'aide',
        detail: 'Critères : apparition rapide de ≥2 signes : urticaire/œdème + dyspnée/bronchospasme + hypotension/syncope. En peropératoire : bronchospasme + hypotension + rash = anaphylaxie jusqu\'à preuve du contraire. Appeler immédiatement renfort.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Adrénaline IM — 1ère ligne ABSOLUE',
        detail: 'ADRÉNALINE 0.5 mg IM face antérolatérale de la cuisse (adulte). Ne PAS retarder au profit d\'un accès IV. Répéter q5–15 min si pas d\'amélioration. Enfant : 0.01 mg/kg IM (max 0.5 mg). Peropératoire avec accès IV : adrénaline 0.1–0.2 mg IV lent titré.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Position et O₂',
        detail: 'Allonger + surélever les jambes si hypotension (sauf dyspnée sévère). O₂ haut débit 15 L/min masque haute concentration. Si arrêt cardiaque : RCP immédiate.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Arrêter l\'agent déclenchant',
        detail: 'Peropératoire : stopper l\'injection de tout médicament suspect. Identifier l\'agent potentiel (dernier médicament injecté, latex, colloïde, antibiotique). Conserver les flacons pour bilan allergologique ultérieur.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Remplissage vasculaire',
        detail: 'NaCl 0.9% ou Ringer Lactate 500–1000 ml IV rapide (10 min) si hypotension persistante. Répéter selon la réponse. Éviter les colloïdes (risque d\'aggravation allergique). Total jusqu\'à 2–4 L si nécessaire.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Traitement de 2ème ligne',
        detail: 'Après adrénaline et remplissage stables : Chlorphénamine 10 mg IV (anti-H1) + Hydrocortisone 200 mg IV (corticoïde). Ne JAMAIS administrer antihistaminiques ou corticoïdes en 1ère ligne (retardent la récupération).',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Surveillance 24h minimum',
        detail: 'Hospitalisation systématique 24h (réaction biphasique dans 5-20% des cas, jusqu\'à 72h). Monitoring continu FC/PA/SpO₂. Prescription adrénaline auto-injectable (EpiPen) à la sortie. Référer en allergologie.',
      ),
      ProtocolStep(
        stepNumber: 8,
        title: 'Bilan allergologique',
        detail: 'Prélèvement tryptase sérique : immédiatement (taux basal), puis 1h, 6h, 24h après réaction. Conserver les ampoules des médicaments suspects. Référer au centre d\'allergologie dans les 4–6 semaines pour tests cutanés.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Adrénaline',
        category: EmergencyCategory.anaphylaxis,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.01,
        doseUnit: 'mg/kg',
        fixedDose: '0.5 mg IM',
        route: 'IM cuisse antérolatérale',
        notes: '1ÈRE LIGNE ABSOLUE — ne jamais retarder. Répéter q5–15 min. IV peropératoire : 0.1–0.2 mg titré.',
        canRepeat: true,
        repeatInterval: 'q5–15 min si insuffisant',
        maxDose: 0.5,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'NaCl 0.9%',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.critical,
        doseUnit: 'ml',
        fixedDose: '500–1000 ml IV',
        route: 'IV rapide (10 min)',
        notes: 'Remplissage vasculaire en hypotension. Éviter colloïdes. Répéter selon réponse.',
        canRepeat: true,
        repeatInterval: 'Répéter jusqu\'à 2–4L selon réponse',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Chlorphénamine',
        category: EmergencyCategory.anaphylaxis,
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '10 mg IV',
        route: 'IV lent (5 min)',
        notes: 'Anti-H1 — 2ème ligne APRÈS adrénaline. Jamais en 1ère intention.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Hydrocortisone',
        category: EmergencyCategory.anaphylaxis,
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '200 mg IV',
        route: 'IV lent',
        notes: 'Prévention réaction biphasique — 2ème ligne. Effet différé (4–6h). Jamais en 1ère intention.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Salbutamol',
        category: EmergencyCategory.anaphylaxis,
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '2.5–5 mg',
        route: 'Nébulisé',
        notes: 'Bronchospasme persistant après adrénaline. En complément, pas en remplacement de l\'adrénaline.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  ÉTAT DE MAL ÉPILEPTIQUE (EME)
  //  Source : Neurocritical Care Society Guidelines 2012
  //  https://www.neurocriticalcare.org/resources/guidelines
  //  Epilepsia 2015;56(10):1515-23
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'status_epilepticus',
    title: 'État de Mal Épileptique',
    subtitle: 'NCS Guidelines 2012 — Convulsions > 5 min',
    emoji: '🧠',
    colorKey: 'red',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Phase 0 (0–5 min) — Stabilisation',
        detail: 'Position latérale de sécurité. O₂ haut débit 15 L/min. VVP ≥2. Glycémie capillaire (hypoglycémie = cause traitable). ECG. Bilan sanguin : NFS, ionogramme, créatinine, taux d\'antiépileptiques, alcoolémie. Thiamine 100 mg IV AVANT G50% si malnutrition suspectée.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Phase 1 — BZD (0–20 min)',
        detail: 'AVEC accès IV : Lorazépam 0.1 mg/kg IV (max 4 mg) en 2 min. Répéter 1 fois après 5 min si convulsions persistent. SANS accès IV : Midazolam 0.2 mg/kg IM ou intranasal (max 10 mg). Diazépam 0.2–0.5 mg/kg rectal (max 20 mg) si pas d\'autre accès.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Phase 2 — Antiépileptique 2ème ligne (20–40 min)',
        detail: 'Échec BZD (EME établi) : Valproate de Sodium 30–40 mg/kg IV en 10 min (max 3000 mg) — 1ère intention en l\'absence de CI (grossesse, maladie hépatique). OU Lévétiracétam 60 mg/kg IV en 15 min (max 4500 mg). OU Phénobarbital 15–20 mg/kg IV lent (max 50 mg/min) avec monitoring TA.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Phase 3 — EME Réfractaire (>40 min)',
        detail: 'Intubation oro-trachéale (SRI) + ventilation mécanique. Monitoring EEG continu OBLIGATOIRE. Options d\'anesthésie générale : Propofol 2 mg/kg bolus puis 2–10 mg/kg/h. OU Midazolam 0.2 mg/kg bolus puis 0.05–2 mg/kg/h. OU Thiopental 3–5 mg/kg bolus puis 3–10 mg/kg/h.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Phase 4 — EME Super-Réfractaire (>24h)',
        detail: 'Malgré anesthésie générale : Kétamine 1.5–4.5 mg/kg bolus puis 1.2–7.5 mg/kg/h. OU Isoflurane inhalé (SIMU). Traitement de la cause sous-jacente (encéphalite, hypocalcémie, etc). Immunothérapie si encéphalite auto-immune suspectée. Hypothermie thérapeutique discutée.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Lorazépam',
        category: EmergencyCategory.seizure,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.1,
        doseUnit: 'mg/kg',
        fixedDose: '4 mg IV',
        route: 'IV en 2 min',
        notes: '1ère ligne avec accès IV. Répéter 1x après 5 min. Max 8 mg total.',
        canRepeat: true,
        repeatInterval: '1x après 5 min si convulsions persistent',
        maxDose: 8.0,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Midazolam',
        category: EmergencyCategory.seizure,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.2,
        doseUnit: 'mg/kg',
        fixedDose: '10 mg IM/IN',
        route: 'IM ou Intranasal',
        notes: 'Alternative lorazépam sans accès IV. IM face externe cuisse. IN : 5 mg/narine.',
        maxDose: 10.0,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Valproate de Sodium',
        category: EmergencyCategory.seizure,
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 30.0,
        doseUnit: 'mg/kg',
        fixedDose: '30–40 mg/kg IV',
        route: 'IV en 10 min',
        notes: '2ème ligne (EME établi). Max 3000 mg. CI : grossesse, IHC, mitochondriopathie.',
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
        notes: '2ème ligne alternative valproate. Max 4500 mg. Peu d\'interactions. Sûr en grossesse.',
        maxDose: 4500,
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Propofol (EME réfractaire)',
        category: EmergencyCategory.seizure,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 2.0,
        doseUnit: 'mg/kg',
        fixedDose: '2 mg/kg bolus IV',
        route: 'IV puis perfusion',
        notes: 'EME réfractaire avec intubation. Puis 2–10 mg/kg/h. SPIR si >4 mg/kg/h >48h.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Thiopental (EME réfractaire)',
        category: EmergencyCategory.seizure,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 3.0,
        doseUnit: 'mg/kg',
        fixedDose: '3–5 mg/kg IV bolus',
        route: 'IV puis perfusion',
        notes: 'EME réfractaire résistant au propofol. Puis 3–10 mg/kg/h. Monitoring EEG burst-suppression.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  HYPERTHERMIE MALIGNE
  //  Source : MHAUS (Malignant Hyperthermia Association USA)
  //  https://www.mhaus.org/healthcare-professionals/mhaus-recommendations/
  //  BJA 2018;121(3):505-517
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'malignant_hyperthermia',
    title: 'Hyperthermie Maligne',
    subtitle: 'MHAUS Protocol — Urgence anesthésique rare',
    emoji: '🌡️',
    colorKey: 'red',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître et alerter',
        detail: 'Signes précoces : ETCO₂ ↑↑ inexpliqué (signe le + précoce), SpO₂ ↓, tachycardie, rigidité musculaire, T°>38.8°C. Appeler à l\'aide IMMÉDIATEMENT. Arrêter l\'halogéné et la succinylcholine. Appeler le hotline MHAUS : +1-800-644-9737 (USA).',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Arrêter les agents déclenchants',
        detail: 'Stopper IMMÉDIATEMENT les halogénés (sevo, iso, des, halo). Arrêter la succinylcholine si en cours. Passer à un circuit propre (non contaminé par les halogénés). Hyperventilation 100% O₂ : FR 2–3x normale, VM ×2, pour éliminer le CO₂.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Dantrolène — TRAITEMENT SPÉCIFIQUE',
        detail: 'Dantrolène 2.5 mg/kg IV BOLUS IMMÉDIAT. Répéter 2.5 mg/kg q5 min jusqu\'à résolution (ETCO₂ normal, T°↓, rigidité ↓). Dose totale typique : 10 mg/kg. Max rapporté : 30 mg/kg. DOIT être disponible dans TOUTE salle d\'opération (minimum 36 flacons de 20 mg).',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Refroidissement actif',
        detail: 'Cible T°<38.5°C. Glace sur aine, aisselles, cou. Lavage gastrique eau froide si sonde en place. Liquides IV froids (NaCl 0.9% 15 ml/kg à 4°C). ARRÊTER le refroidissement à 38.5°C (risque de rebond hypothermie).',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Traiter les complications',
        detail: 'Hyperkaliémie : bicarbonate + insuline/G50% + calcium. Arythmies : amiodarone (éviter vérapamil, diltiazem = potentialisent hyperkaliémie). Myoglobinurie : NaCl 0.9% 500 ml/h pour urines claires, furosémide si oligurie. CIVD : PFC + plaquettes.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Surveillance 24–48h et suivi',
        detail: 'Dantrolène 1 mg/kg IV q6h pendant 24–48h (prévention récidive). Dosage CK toutes les 6h jusqu\'à normalisation. Bilan myoglobinurie. Prévenir la famille (maladie génétique autosomique dominante). Référer au centre HM pour test in vitro CHCT.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Dantrolène',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 2.5,
        doseUnit: 'mg/kg',
        fixedDose: '2.5 mg/kg IV bolus',
        route: 'IV bolus RAPIDE',
        notes: 'TRAITEMENT SPÉCIFIQUE ET UNIQUE. Répéter q5 min jusqu\'à résolution. Max 10–30 mg/kg. Dissoudre dans eau stérile chaude.',
        canRepeat: true,
        repeatInterval: 'q5 min jusqu\'à ETCO₂ normal et T°<38.5°C',
        maxDose: 500,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Bicarbonate de Sodium',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 1.0,
        doseUnit: 'mEq/kg',
        fixedDose: '1 mEq/kg IV',
        route: 'IV',
        notes: 'Acidose métabolique sévère et hyperkaliémie. Répéter selon pH.',
        canRepeat: true,
        repeatInterval: 'Selon pH et kaliémie',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Furosémide',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 1.0,
        doseUnit: 'mg/kg',
        fixedDose: '40–80 mg IV',
        route: 'IV',
        notes: 'Myoglobinurie + oligurie — forcer la diurèse. Cible diurèse ≥1 ml/kg/h.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  PNEUMOTHORAX COMPRESSIF (TENSION PTX)
  //  Source : ATLS 10th Ed. + ERC Guidelines 2021
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'tension_pneumothorax',
    title: 'Pneumothorax Compressif',
    subtitle: 'ATLS 10th Ed. — Urgence vitale immédiate',
    emoji: '💨',
    colorKey: 'red',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître — Diagnostic clinique',
        detail: 'Triade : détresse respiratoire aiguë + hypotension + déviation trachéale controlatérale (tardive). Signes complémentaires : jugulaires distendues, absence de MV unilatéral, SpO₂ effondrée, tachycardie. Pas de temps pour Rx — diagnostic CLINIQUE uniquement.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Décompression en urgence — Exsufflation à l\'aiguille',
        detail: '2ème espace intercostal ligne médioclaviculaire (technique ATLS). OU 4–5ème EIC ligne axillaire antérieure (accès plus fiable selon études récentes). Aiguille 14G minimum. Succès = sifflement d\'air + amélioration clinique immédiate. Sinon : drain thoracique immédiatement.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Drain thoracique définitif',
        detail: '4–5ème EIC ligne axillaire moyenne (triangle de sécurité). Drain 28–32F. Raccorder au bocal à bulle. Vérifier dépression et oscillations. Rx thorax de contrôle après pose. L\'exsufflation à l\'aiguille est transitoire — le drain est définitif.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Stabilisation',
        detail: 'O₂ 100% haut débit. Remplissage vasculaire NaCl ou Ringer si hypotension. Si arrêt cardiaque : RCP + décompression bilatérale simultanée sans délai. Ventilation mécanique : éviter la PEEP jusqu\'à drain posé.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'O₂ — Haut débit',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'L/min',
        fixedDose: '15 L/min MHC',
        route: 'Inhalé',
        notes: '100% O₂ haut débit. Accélère la résorption du pneumothorax.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'NaCl 0.9%',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: '500 ml IV',
        route: 'IV rapide',
        notes: 'Remplissage si hypotension persistante après décompression.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  BRADYCARDIE INSTABLE
  //  Source : AHA ACLS Bradycardia Algorithm 2020
  //  https://cpr.heart.org
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'bradycardia',
    title: 'Bradycardie Instable',
    subtitle: 'AHA ACLS 2020 — Algorithme Bradycardie',
    emoji: '💓',
    colorKey: 'orange',
    source: 'AHA ACLS Guidelines 2020',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Identifier l\'instabilité',
        detail: 'FC <50/min ET signes d\'instabilité : hypotension, altération de conscience, signes de choc, douleur thoracique ischémique, insuffisance cardiaque aiguë. ECG 12 dérivations : identifier le type de bloc (BAV 1er/2e Mobitz I-II/3e degré). Rechercher cause : IDM inférieur, hyperkaliémie, intoxication (bêtabloquants, inhibiteurs calciques, digoxine), hypothyroïdie, hypothermie.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Atropine — 1ère ligne',
        detail: 'Atropine 1 mg IV bolus, répéter q3–5 min (max 3 mg total = 0.04 mg/kg — bloc vagal complet). Inefficace si BAV de haut degré (Mobitz II, BAV 3° à QRS large) — passer directement à l\'étape suivante sans retarder.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Entraînement électrosystolique externe',
        detail: 'Si atropine inefficace ou BAV de haut degré d\'emblée : pacing transcutané immédiat. Sédation/analgésie si patient conscient (le pacing est douloureux). Réglage : fréquence 60–80/min, intensité croissante jusqu\'à capture électrique ET mécanique (pouls palpable).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Catécholamines en alternative/attente',
        detail: 'Dopamine 5–20 mcg/kg/min IVSE OU Adrénaline 2–10 mcg/min IVSE si pacing indisponible ou en pont vers le pacing. Titrer selon FC et PA.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Traiter la cause spécifique',
        detail: 'Hyperkaliémie : gluconate de calcium + insuline-glucose. Intoxication bêtabloquants : glucagon 3–10 mg IV. Intoxication inhibiteurs calciques : calcium IV + insuline haute dose euglycémique. Digoxine : anticorps anti-digoxine (Digibind) si toxicité sévère.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Pacing transveineux et avis cardiologique',
        detail: 'Si bradycardie persistante nécessitant pacing prolongé : pose de sonde d\'entraînement électrosystolique transveineux. Avis cardiologique urgent pour pacemaker définitif si BAV 3e degré, Mobitz II, ou bradycardie symptomatique persistante sans cause réversible.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Atropine',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '1 mg IV',
        route: 'IV bolus',
        notes: 'Répéter q3–5 min, max 3 mg total. Inefficace en BAV de haut degré — ne pas retarder le pacing.',
        canRepeat: true,
        repeatInterval: 'q3–5 min (max 3 mg)',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Dopamine',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 10.0,
        doseUnit: 'mcg/kg/min',
        fixedDose: '5–20 mcg/kg/min',
        route: 'IVSE',
        notes: 'Alternative/pont si atropine et pacing indisponibles ou inefficaces.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Adrénaline',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mcg/min',
        fixedDose: '2–10 mcg/min',
        route: 'IVSE',
        notes: 'Alternative à la dopamine. Titrer selon FC/PA.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Glucagon',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '3–10 mg IV',
        route: 'IV lent',
        notes: 'Si intoxication aux bêtabloquants suspectée/confirmée.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  TACHYCARDIE INSTABLE
  //  Source : AHA ACLS Tachycardia Algorithm 2020
  //  https://cpr.heart.org
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'unstable_tachycardia',
    title: 'Tachycardie Instable',
    subtitle: 'AHA ACLS 2020 — Algorithme Tachycardie',
    emoji: '💓',
    colorKey: 'orange',
    source: 'AHA ACLS Guidelines 2020',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Identifier l\'instabilité et le rythme',
        detail: 'FC généralement >150/min ET signes d\'instabilité : hypotension, altération de conscience, signes de choc, douleur thoracique ischémique, insuffisance cardiaque aiguë. ECG : QRS fin (SVT, FA/flutter) vs QRS large (TV, SVT avec aberrance, WPW). Instabilité = cardioversion électrique synchronisée immédiate, ne pas retarder pour caractériser le rythme.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Cardioversion électrique synchronisée',
        detail: 'Sédation brève si patient conscient (étomidate/kétamine + fentanyl selon disponibilité, sans retarder le choc si extrême urgence). QRS fin régulier : 50–100 J. QRS fin irrégulier (FA) : 120–200 J biphasique. QRS large régulier : 100 J. QRS large irrégulier (polymorphe) : traiter comme FV — défibrillation non synchronisée.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Si stable — Manœuvres vagales et adénosine (QRS fin régulier)',
        detail: 'Manœuvre de Valsalva modifiée ou massage sino-carotidien (après exclusion souffle carotidien). Adénosine 6 mg IV rapide en bolus flash suivi de 20 ml NaCl, si inefficace : 12 mg IV. Efficace sur les tachycardies par réentrée nodale. CI : asthme sévère, WPW avec FA (risque de FV).',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'FA/Flutter stable — Contrôle de fréquence',
        detail: 'Bêtabloquant (esmolol 0.5 mg/kg IV puis 50–200 mcg/kg/min) ou inhibiteur calcique (diltiazem 0.25 mg/kg IV en 2 min puis 5–15 mg/h) si FEVG préservée. Digoxine ou amiodarone si FEVG altérée. Anticoagulation à discuter selon score CHA₂DS₂-VASc et durée de FA.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'TV monomorphe stable — Antiarythmiques',
        detail: 'Amiodarone 150 mg IV en 10 min puis 1 mg/min x6h. Alternative : procaïnamide 20–50 mg/min IV (CI si QT long/insuffisance cardiaque sévère). Avis cardiologique pour ablation si récidivante.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Cas particuliers',
        detail: 'WPW avec FA (QRS large irrégulier, très rapide) : CI aux bloqueurs du nœud AV (adénosine, bêtabloquants, inhibiteurs calciques, digoxine — risque de FV). Traiter par procaïnamide ou cardioversion électrique. Torsades de pointes : sulfate de magnésium 2 g IV + correction électrolytique (K⁺, Mg²⁺), arrêt des médicaments allongeant le QT.',
        isCritical: true,
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Adénosine',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '6 mg IV flash',
        route: 'IV bolus rapide + flush NaCl',
        notes: 'QRS fin régulier stable. 2e dose 12 mg si inefficace. CI : asthme sévère, WPW+FA.',
        canRepeat: true,
        repeatInterval: '12 mg si inefficace après 1–2 min',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Esmolol',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 0.5,
        doseUnit: 'mg/kg',
        fixedDose: '0.5 mg/kg IV puis 50–200 mcg/kg/min',
        route: 'IV bolus puis IVSE',
        notes: 'Contrôle de fréquence FA/flutter si FEVG préservée. Demi-vie courte (9 min).',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Amiodarone',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '150 mg IV en 10 min',
        route: 'IV puis IVSE 1 mg/min x6h',
        notes: 'TV monomorphe stable ou FA si FEVG altérée.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Sulfate de Magnésium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'g',
        fixedDose: '2 g IV',
        route: 'IV en 1–2 min',
        notes: 'Torsades de pointes. Associer correction K⁺/Mg²⁺ et arrêt des médicaments allongeant le QT.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  TAMPONNADE CARDIAQUE
  //  Source : ESC Guidelines Pericardial Diseases 2015
  //  https://www.escardio.org/Guidelines
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'cardiac_tamponade',
    title: 'Tamponnade Cardiaque',
    subtitle: 'ESC 2015 — Compression Péricardique Aiguë',
    emoji: '🫀',
    colorKey: 'red',
    source: 'ESC Guidelines Pericardial Diseases 2015',
    evidenceLevel: EvidenceLevel.c,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître la triade de Beck et confirmer',
        detail: 'Triade de Beck : hypotension, turgescence jugulaire, assourdissement des bruits du cœur (souvent incomplète). Pouls paradoxal (chute PAS >10 mmHg à l\'inspiration). Tachycardie compensatrice. Confirmation par échocardiographie au lit : épanchement péricardique + collapsus diastolique VD/OD + variation respiratoire du flux mitral/tricuspide.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Optimisation hémodynamique en attendant le drainage',
        detail: 'Remplissage vasculaire prudent (cristalloïdes 250–500 ml) pour maintenir la précharge — mesure temporisatrice uniquement. Éviter la ventilation en pression positive si possible (réduit le retour veineux et peut précipiter le collapsus). Éviter les vasodilatateurs et diurétiques.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Péricardiocentèse en urgence',
        detail: 'Geste salvateur si tamponnade avec instabilité hémodynamique. Sous guidage échographique de préférence (voie sous-xiphoïdienne). Retrait de faibles volumes (50–100 ml) suffit souvent à améliorer significativement l\'hémodynamique. Envoyer le liquide pour analyse étiologique (cytologie, bactériologie, biochimie).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Traitement chirurgical si indiqué',
        detail: 'Fenêtre péricardique chirurgicale ou drainage chirurgical si : tamponnade post-traumatique (hémopéricarde), dissection aortique, post-chirurgie cardiaque, épanchement cloisonné/coagulé non ponctionnable, récidive après péricardiocentèse. Dissection aortique avec tamponnade = chirurgie immédiate, péricardiocentèse à éviter si possible (risque d\'aggravation du saignement).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Traiter la cause',
        detail: 'Néoplasique : drainage prolongé + traitement oncologique. Infectieuse : antibiothérapie/antituberculeux adaptée. Post-IDM (syndrome de Dressler) : anti-inflammatoire. Urémique : dialyse. Post-traumatique/iatrogène : réparation chirurgicale de la brèche.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Surveillance post-drainage',
        detail: 'Surveillance hémodynamique rapprochée — risque de récidive. Drain péricardique laissé en place selon débit. Échocardiographie de contrôle. Surveillance du syndrome de décompression péricardique (œdème pulmonaire aigu rare mais décrit après drainage rapide).',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Cristalloïdes (remplissage temporisateur)',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: '250–500 ml',
        route: 'IV',
        notes: 'Mesure temporisatrice en attente du drainage. N\'est pas un traitement définitif.',
        isFirstLine: true,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  EMBOLIE PULMONAIRE MASSIVE
  //  Source : ESC Pulmonary Embolism Guidelines 2019
  //  https://www.escardio.org/Guidelines
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'massive_pe',
    title: 'Embolie Pulmonaire Massive',
    subtitle: 'ESC 2019 — EP à Haut Risque (Choc/Hypotension)',
    emoji: '🫁',
    colorKey: 'red',
    source: 'ESC Pulmonary Embolism Guidelines 2019',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Identifier l\'EP à haut risque',
        detail: 'PAS <90 mmHg ou chute PAS ≥40 mmHg >15 min, ou nécessité de vasopresseurs, ou arrêt cardiaque avec suspicion EP. Signes : dyspnée brutale, douleur thoracique, syncope, tachycardie, signes de cœur droit aigu. Angio-TDM thoracique en urgence si stabilisable, sinon échocardiographie au lit (dilatation/dysfonction VD) suffit à indiquer la thrombolyse en situation de choc.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Stabilisation hémodynamique et respiratoire',
        detail: 'O₂ pour SpO₂ ≥90%. Remplissage prudent et limité (250–500 ml) — un remplissage excessif aggrave la dysfonction VD par surdistension. Noradrénaline si hypotension persistante malgré remplissage prudent (0.05–0.5 mcg/kg/min). Éviter l\'intubation si possible (la ventilation en pression positive aggrave la précharge VD) — si nécessaire, induction prudente évitant l\'hypotension.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Anticoagulation immédiate',
        detail: 'Héparine non fractionnée IV : bolus 80 UI/kg puis 18 UI/kg/h IVSE (préférée si thrombolyse envisagée — réversible, demi-vie courte). Débuter dès la suspicion diagnostique forte, sans attendre la confirmation si haut risque hémodynamique.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Thrombolyse systémique',
        detail: 'Indiquée en 1ère intention si EP à haut risque (choc/hypotension) sans contre-indication majeure. Altéplase 100 mg IV en 2h (ou 0.6 mg/kg max 50 mg en 15 min si arrêt cardiaque imminent). CI absolues : hémorragie intracrânienne, AVC ischémique <3 mois, saignement actif, chirurgie majeure récente <10j, traumatisme crânien récent.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Alternatives si thrombolyse contre-indiquée',
        detail: 'Embolectomie chirurgicale sous CEC en urgence si centre disponible. Thrombolyse dirigée par cathéter (dose réduite, risque hémorragique moindre) ou thrombectomie percutanée. ECMO veino-artérielle en pont vers un traitement définitif si choc réfractaire.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Surveillance et relais',
        detail: 'Surveillance hémodynamique et respiratoire rapprochée en réanimation. Échocardiographie de contrôle (évolution fonction VD). Relais anticoagulation orale à distance de la phase aiguë selon contexte (AOD ou AVK). Recherche et traitement de la cause (bilan de thrombophilie si indiqué, filtre cave si récidive sous anticoagulation efficace ou CI formelle à l\'anticoagulation).',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Héparine Non Fractionnée',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 80.0,
        doseUnit: 'UI/kg',
        fixedDose: '80 UI/kg IV bolus puis 18 UI/kg/h',
        route: 'IV bolus puis IVSE',
        notes: 'Préférée si thrombolyse envisagée. Adapter selon TCA (cible 1.5–2.5x témoin).',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Altéplase (rtPA)',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '100 mg IV en 2h',
        route: 'IV (0.6 mg/kg max 50 mg en 15 min si péri-arrêt)',
        notes: 'EP à haut risque sans CI majeure. Vérifier CI absolues avant administration.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Noradrénaline',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 0.05,
        doseUnit: 'mcg/kg/min',
        fixedDose: '0.05–0.5 mcg/kg/min',
        route: 'IVSE voie centrale',
        notes: 'Si hypotension persistante malgré remplissage prudent. Titrer pour PAM ≥65 mmHg.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  AVC ISCHÉMIQUE
  //  Source : AHA/ASA Acute Ischemic Stroke Guidelines 2019/2023
  //  https://www.ahajournals.org/doi/10.1161/STR.0000000000000211
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'ischemic_stroke',
    title: 'AVC Ischémique',
    subtitle: 'AHA/ASA 2019/2023 — Accident Vasculaire Cérébral Ischémique',
    emoji: '🧠',
    colorKey: 'red',
    source: 'AHA/ASA Guidelines 2019/2023',
    evidenceLevel: EvidenceLevel.a,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaissance et heure de début — FAST',
        detail: 'FAST : Face (asymétrie faciale), Arm (déficit moteur), Speech (troubles du langage), Time (heure exacte du début — dernière heure vue asymptomatique si découverte au réveil). NIHSS pour quantifier la sévérité. Glycémie capillaire immédiate (hypoglycémie = principal diagnostic différentiel réversible).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Imagerie cérébrale en urgence',
        detail: 'TDM cérébrale sans injection en urgence absolue (<20 min de l\'arrivée) pour éliminer une hémorragie. Angio-TDM des troncs supra-aortiques si éligible à la thrombectomie (recherche d\'occlusion proximale). Objectif porte-imagerie <20 min, porte-thrombolyse <60 min (door-to-needle).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Thrombolyse IV — Fenêtre 0-4h30',
        detail: 'Altéplase (rtPA) 0.9 mg/kg IV (max 90 mg), 10% en bolus puis 90% en 1h, si <4h30 du début des symptômes et absence de CI. Ténectéplase 0.25 mg/kg (max 25 mg) bolus unique = alternative validée. Vérifier CI : hémorragie intracrânienne, chirurgie majeure récente, INR >1.7, plaquettes <100 000, PAS >185 ou PAD >110 mmHg non contrôlée.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Thrombectomie mécanique',
        detail: 'Indiquée si occlusion de gros vaisseau (carotide interne, M1) jusqu\'à 24h du début des symptômes selon critères d\'imagerie de pénombre (mismatch clinique/radiologique, DAWN/DEFUSE-3). Peut être associée à la thrombolyse IV (bridging) si les 2 sont indiquées. Ne pas retarder la thrombolyse IV pour organiser la thrombectomie.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Contrôle tensionnel',
        detail: 'Avant thrombolyse : PA <185/110 mmHg (labétalol 10–20 mg IV ou nicardipine IVSE). Après thrombolyse : PA <180/105 mmHg pendant 24h. Sans thrombolyse : permissif jusqu\'à 220/120 mmHg (ne pas traiter sauf complication associée — dissection, IDM, insuffisance cardiaque), éviter les baisses brutales qui aggravent l\'ischémie de pénombre.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Antithrombotiques (hors fenêtre thrombolyse/après 24h)',
        detail: 'Aspirine 160–300 mg PO/SNG dans les 24–48h (à distance de 24h si thrombolyse effectuée — imagerie de contrôle avant). Anticoagulation curative différée si FA (délai selon taille de l\'infarctus — règle du "1-3-6-12 jours").',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Surveillance et mesures générales',
        detail: 'Surveillance neurologique répétée (NIHSS), glycémie (cible 1.4–1.8 g/L, éviter hypo/hyperglycémie), température (traiter fièvre >37.5°C), SpO₂ >94%. Unité neurovasculaire (UNV). Dépistage précoce des troubles de déglutition avant toute alimentation orale.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Altéplase (rtPA)',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.9,
        doseUnit: 'mg/kg',
        fixedDose: '0.9 mg/kg IV (max 90 mg)',
        route: 'IV : 10% bolus puis 90% en 1h',
        notes: 'Fenêtre <4h30. Vérifier CI absolues et relatives avant administration. PA <185/110 avant injection.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Ténectéplase',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.25,
        doseUnit: 'mg/kg',
        fixedDose: '0.25 mg/kg (max 25 mg)',
        route: 'IV bolus unique',
        notes: 'Alternative à l\'altéplase, notamment si transfert vers centre de thrombectomie prévu.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Labétalol',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '10–20 mg IV',
        route: 'IV en 1–2 min',
        notes: 'Contrôle tensionnel avant/après thrombolyse. Répéter si besoin, max 300 mg/j.',
        canRepeat: true,
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Aspirine',
        urgency: EmergencyUrgency.moderate,
        doseUnit: 'mg',
        fixedDose: '160–300 mg PO/SNG',
        route: 'PO/SNG',
        notes: 'Dans les 24–48h. Différer 24h si thrombolyse effectuée.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  AVC HÉMORRAGIQUE
  //  Source : AHA/ASA Spontaneous ICH Guidelines 2022
  //  https://www.ahajournals.org/doi/10.1161/STR.0000000000000407
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'hemorrhagic_stroke',
    title: 'AVC Hémorragique',
    subtitle: 'AHA/ASA 2022 — Hémorragie Intracérébrale Spontanée',
    emoji: '🧠',
    colorKey: 'red',
    source: 'AHA/ASA ICH Guidelines 2022',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Diagnostic et évaluation initiale',
        detail: 'TDM cérébrale sans injection en urgence — diagnostic de certitude. Score NIHSS et score ICH (âge, volume hématome, GCS, localisation, extension intraventriculaire) pour le pronostic. Rechercher cause : HTA chronique (localisation profonde typique), angiopathie amyloïde (sujet âgé, localisation lobaire), malformation vasculaire, anticoagulants/antiagrégants, tumeur.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Contrôle tensionnel intensif',
        detail: 'PAS cible <140 mmHg si PAS initiale 150–220 mmHg (essai INTERACT2/ATACH-2 — réduction rapide et sûre). Nicardipine IVSE 5 mg/h titrable (max 15 mg/h) ou labétalol IV. Éviter les baisses trop rapides ou trop importantes (<130 mmHg) — risque d\'hypoperfusion périlésionnelle.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Inversion urgente de l\'anticoagulation',
        detail: 'AVK : concentré de complexe prothrombinique (CCP) 25–50 UI/kg IV + vitamine K 10 mg IV, cible INR <1.3, en urgence absolue (<1h). AOD anti-Xa (rivaroxaban, apixaban) : andexanet alfa ou CCP 4 facteurs si indisponible. Dabigatran : idarucizumab 5 g IV. Héparine : protamine. Ne jamais retarder l\'inversion pour d\'autres examens.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Prise en charge de l\'hypertension intracrânienne',
        detail: 'Tête surélevée à 30°, tête droite (favoriser retour veineux). Si signes d\'engagement (mydriase, dégradation GCS) : mannitol 20% 0.5–1 g/kg IV ou sérum salé hypertonique 3% 150–250 ml, hyperventilation transitoire modérée (PaCO₂ 30–35 mmHg) en mesure de sauvetage. Avis neurochirurgical urgent.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Indications chirurgicales',
        detail: 'Craniectomie décompressive/évacuation : hématome cérébelleux >3 cm avec compression du tronc/hydrocéphalie (urgence chirurgicale formelle), hématome lobaire volumineux avec effet de masse et détérioration clinique. Dérivation ventriculaire externe si hydrocéphalie obstructive/hémorragie intraventriculaire massive. Avis neurochirurgical systématique.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Prévention des complications et surveillance',
        detail: 'Surveillance neurologique rapprochée (GCS, pupilles) en unité neurovasculaire/réanimation. Prévention convulsions : traiter si crise clinique (pas de prophylaxie systématique). Glycémie 1.4–1.8 g/L. Normothermie. Prévention thromboembolique par compression pneumatique intermittente précocement ; héparine prophylactique différée (24–48h) selon stabilité de l\'hématome au TDM de contrôle.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Nicardipine',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg/h',
        fixedDose: '5 mg/h IVSE (titrable, max 15 mg/h)',
        route: 'IVSE',
        notes: 'Cible PAS <140 mmHg. Titrer q5–15 min selon réponse.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Concentré de Complexe Prothrombinique (CCP)',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 25.0,
        doseUnit: 'UI/kg',
        fixedDose: '25–50 UI/kg IV',
        route: 'IV rapide',
        notes: 'Si sous AVK (+ vitamine K 10 mg IV) ou AOD anti-Xa si andexanet indisponible. Ne pas retarder.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Mannitol 20%',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.75,
        doseUnit: 'g/kg',
        fixedDose: '0.5–1 g/kg IV',
        route: 'IV en 15–20 min',
        notes: 'Si signes d\'engagement cérébral. Mesure de sauvetage transitoire en attendant la neurochirurgie.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Idarucizumab',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '5 g IV',
        route: 'IV (2 x 2.5 g)',
        notes: 'Antidote spécifique du dabigatran.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  ACIDOCÉTOSE DIABÉTIQUE
  //  Source : ADA Consensus Report — Hyperglycemic Crises 2024
  //  https://diabetesjournals.org/care
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'dka',
    title: 'Acidocétose Diabétique',
    subtitle: 'ADA 2024 — Crise Hyperglycémique Cétosique',
    emoji: '🩸',
    colorKey: 'orange',
    source: 'ADA Consensus Report 2024',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Critères diagnostiques',
        detail: 'Glycémie >2.5 g/L (>13.9 mmol/L), pH artériel <7.30, bicarbonates <18 mEq/L, cétonémie/cétonurie positive, trou anionique >12. Sévérité : légère (pH 7.25–7.30), modérée (pH 7.00–7.24), sévère (pH <7.00 ou troubles de conscience). Rechercher facteur déclenchant : infection, arrêt insuline, IDM, corticoïdes, inhibiteurs SGLT2.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Réhydratation IV — Priorité absolue',
        detail: 'NaCl 0.9% 15–20 ml/kg (1–1.5 L) en 1ère heure. Puis NaCl 0.45% ou 0.9% selon natrémie corrigée à 250–500 ml/h. Objectif : correction du déficit hydrique estimé (~5–8 L) sur 24–48h. Passer à G5%+NaCl 0.45% quand glycémie <2.5 g/L (250 mg/dL) pour éviter l\'hypoglycémie tout en poursuivant l\'insuline.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Correction de la kaliémie AVANT l\'insuline',
        detail: 'Si K⁺ <3.3 mmol/L : NE PAS débuter l\'insuline — supplémenter KCl 20–30 mEq/h jusqu\'à K⁺ >3.3 (risque d\'arythmie fatale, l\'insuline fait entrer le K⁺ dans les cellules). Si K⁺ 3.3–5.3 : KCl 20–30 mEq/L de perfusion + débuter insuline. Si K⁺ >5.3 : pas de supplémentation initiale, surveiller q2h.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Insulinothérapie IV continue',
        detail: 'Insuline rapide IVSE 0.1 UI/kg/h (pas de bolus initial nécessaire selon ADA 2024, sauf si retard prévisible à la mise en route). Objectif : baisse glycémie de 0.5–0.75 g/L/h. Ne jamais arrêter l\'insuline IV avant résolution de l\'acidocétose (trou anionique normalisé, bicarbonates ≥15, pH >7.3) — chevaucher avec insuline SC 1–2h avant l\'arrêt de l\'IVSE.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Bicarbonates — Exception, pas systématique',
        detail: 'Réservés au pH <6.9 avec instabilité hémodynamique : bicarbonate de sodium 100 mEq dans 400 ml eau + 20 mEq KCl en 2h. Pas d\'indication si pH ≥6.9 (résolution spontanée avec réhydratation + insuline, risque d\'alcalose de rebond et d\'aggravation de l\'hypokaliémie).',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Surveillance et critères de résolution',
        detail: 'Glycémie capillaire horaire. Ionogramme, gaz du sang, trou anionique q2–4h. Résolution : glycémie <2 g/L + 2 des critères suivants : bicarbonates ≥15 mEq/L, pH veineux >7.3, trou anionique ≤12. Relais insuline SC dès résolution avec chevauchement, traiter le facteur déclenchant.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'NaCl 0.9%',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 15.0,
        doseUnit: 'ml/kg',
        fixedDose: '15–20 ml/kg (1–1.5 L) en 1h',
        route: 'IV',
        notes: '1ère mesure prioritaire avant l\'insuline. Adapter le débit selon natrémie corrigée ensuite.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Insuline Rapide IVSE',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.1,
        doseUnit: 'UI/kg/h',
        fixedDose: '0.1 UI/kg/h',
        route: 'IVSE',
        notes: 'Débuter seulement si K⁺ >3.3 mmol/L. Ne jamais interrompre avant résolution biologique complète.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Chlorure de Potassium',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mEq/h',
        fixedDose: '20–30 mEq/h',
        route: 'IV dans perfusion',
        notes: 'Si K⁺ <5.3 mmol/L. Impératif avant/avec l\'insuline si K⁺ <3.3.',
        isFirstLine: true,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  SYNDROME HYPERGLYCÉMIQUE HYPEROSMOLAIRE
  //  Source : ADA Consensus Report — Hyperglycemic Crises 2024
  //  https://diabetesjournals.org/care
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'hhs',
    title: 'Syndrome Hyperosmolaire',
    subtitle: 'ADA 2024 — État Hyperglycémique Hyperosmolaire',
    emoji: '🩸',
    colorKey: 'orange',
    source: 'ADA Consensus Report 2024',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Critères diagnostiques',
        detail: 'Glycémie >6 g/L (>33.3 mmol/L), osmolalité plasmatique effective >320 mOsm/kg, pH >7.30, bicarbonates >18 mEq/L, cétonémie absente/minime, troubles de conscience fréquents (corrélés au degré d\'hyperosmolarité). Terrain typique : sujet âgé, diabète type 2, déshydratation profonde, facteur déclenchant (infection, AVC, IDM, déshydratation).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Réhydratation IV massive — Priorité absolue',
        detail: 'Déficit hydrique majeur (8–12 L en moyenne). NaCl 0.9% 15–20 ml/kg en 1ère heure puis 250–500 ml/h selon natrémie corrigée et état hémodynamique. Correction progressive sur 24–48h pour éviter l\'œdème cérébral par correction trop rapide de l\'osmolalité (baisse cible <3 mOsm/kg/h).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Correction de la kaliémie AVANT l\'insuline',
        detail: 'Identique à l\'acidocétose : si K⁺ <3.3 mmol/L, différer l\'insuline et supplémenter KCl 20–30 mEq/h d\'abord. Si K⁺ 3.3–5.3 : KCl associé à l\'insuline. Surveillance rapprochée — les besoins potassiques sont souvent majeurs dans le SHH.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Insulinothérapie prudente et retardée',
        detail: 'Débuter APRÈS que la réhydratation ait commencé à faire baisser la glycémie (la réhydratation seule baisse souvent significativement la glycémie). Insuline rapide IVSE 0.05–0.1 UI/kg/h (dose souvent plus faible que dans l\'acidocétose). Objectif : baisse glycémie 0.5–0.75 g/L/h — une baisse trop rapide favorise l\'œdème cérébral.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Surveillance neurologique rapprochée',
        detail: 'Réévaluation clinique horaire (GCS) — risque d\'œdème cérébral si correction trop rapide de la glycémie/osmolalité, surtout chez le sujet âgé. Osmolalité plasmatique calculée q2–4h. En cas de dégradation neurologique brutale : suspecter œdème cérébral, ralentir la correction, discuter mannitol.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Rechercher et traiter la cause, prévenir les complications',
        detail: 'Bilan infectieux systématique (hémocultures, ECBU, radio thorax). Prévention thromboembolique systématique (risque thrombotique élevé lié à l\'hyperosmolarité — HBPM prophylactique). Surveillance rénale (IRA fonctionnelle fréquente). Relais insuline SC à distance de la résolution biologique.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'NaCl 0.9%',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 15.0,
        doseUnit: 'ml/kg',
        fixedDose: '15–20 ml/kg en 1h',
        route: 'IV',
        notes: 'Réhydratation prioritaire. Correction progressive sur 24–48h — éviter la correction trop rapide.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Insuline Rapide IVSE',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 0.05,
        doseUnit: 'UI/kg/h',
        fixedDose: '0.05–0.1 UI/kg/h',
        route: 'IVSE',
        notes: 'Débuter après le début de la réhydratation, jamais si K⁺ <3.3 mmol/L. Dose plus faible que dans l\'acidocétose.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Chlorure de Potassium',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mEq/h',
        fixedDose: '20–30 mEq/h',
        route: 'IV dans perfusion',
        notes: 'Besoins souvent majeurs. Surveillance rapprochée de la kaliémie.',
        isFirstLine: true,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  PRÉ-ÉCLAMPSIE SÉVÈRE / ÉCLAMPSIE
  //  Source : ACOG Practice Bulletin — Preeclampsia 2020
  //  SFAR-CNGOF Recommandations Pré-éclampsie 2022
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'eclampsia',
    title: 'Pré-éclampsie Sévère / Éclampsie',
    subtitle: 'ACOG 2020 / SFAR-CNGOF 2022 — Urgence Obstétricale Vitale',
    emoji: '🤰',
    colorKey: 'red',
    source: 'ACOG 2020 ; SFAR-CNGOF 2022',
    evidenceLevel: EvidenceLevel.a,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Critères de sévérité',
        detail: 'Pré-éclampsie sévère : PAS ≥160 ou PAD ≥110 mmHg + protéinurie, OU signes de gravité (céphalées rebelles, troubles visuels, douleur épigastrique/HCD, œdème pulmonaire, thrombopénie <100 000, cytolyse hépatique, créatinine élevée, RCIU sévère). Éclampsie = survenue de convulsions tonico-cloniques généralisées chez une patiente pré-éclamptique. Peut survenir en pré, per ou post-partum (jusqu\'à 6 semaines).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Sulfate de magnésium — Prévention et traitement des convulsions',
        detail: 'Dose de charge : 4 g IV en 15–20 min. Dose d\'entretien : 1 g/h IVSE pendant 24h après l\'accouchement ou la dernière convulsion. Si convulsion sous traitement : bolus additionnel 2 g IV. Surveiller : réflexes ostéotendineux (abolition = signe de surdosage), FR (>12/min), diurèse (>25 ml/h). Antidote : gluconate de calcium 1 g IV si signes de toxicité (dépression respiratoire).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Contrôle tensionnel urgent',
        detail: 'Si PAS ≥160 ou PAD ≥110 mmHg : Labétalol 20 mg IV puis 40–80 mg q10 min (max 300 mg) OU Nicardipine IVSE 1–2 mg/h titrable OU Nifédipine 10 mg PO/SL. Objectif : PAS 140–150 / PAD 90–100 mmHg (éviter la baisse brutale — risque d\'hypoperfusion placentaire).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Prise en charge de la crise convulsive éclamptique',
        detail: 'Protection des voies aériennes, position latérale de sécurité, O₂ haut débit. Sulfate de magnésium en 1ère intention (supérieur aux benzodiazépines et à la phénytoïne dans l\'éclampsie — essai MAGPIE). Benzodiazépine (diazépam 10 mg IV) uniquement si convulsion persistante malgré MgSO₄ ou en attendant sa mise en route.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Décision d\'extraction fœtale',
        detail: 'L\'accouchement est le seul traitement curatif définitif. Stabiliser la mère AVANT l\'extraction (contrôle tensionnel, MgSO₄ en cours) — ne pas extraire en urgence sur une patiente instable. Voie d\'accouchement selon terme, présentation, état maternofœtal. Corticothérapie de maturation pulmonaire fœtale si <34 SA et extraction différable de 24–48h.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Surveillance post-partum et complications',
        detail: 'Poursuite MgSO₄ 24h post-partum ou post-convulsion. Surveillance biologique répétée (NFS-plaquettes, bilan hépatique, créatinine) — risque de syndrome HELLP associé. Surveillance de la diurèse (risque IRA). Le risque de convulsion persiste jusqu\'à 6 semaines post-partum — éducation de la patiente sur les signes d\'alerte.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Sulfate de Magnésium',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '4 g IV puis 1 g/h IVSE',
        route: 'IV bolus 15–20 min puis IVSE',
        notes: 'Surveiller ROT, FR, diurèse. Antidote : gluconate de calcium 1 g IV si toxicité. Poursuivre 24h post-partum.',
        canRepeat: true,
        repeatInterval: '2 g IV si convulsion sous traitement',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Labétalol',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '20 mg IV',
        route: 'IV puis 40–80 mg q10 min',
        notes: 'Max 300 mg. Objectif PAS 140–150/PAD 90–100 mmHg — pas de baisse brutale.',
        canRepeat: true,
        repeatInterval: 'q10 min (max 300 mg)',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Nicardipine',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg/h',
        fixedDose: '1–2 mg/h IVSE',
        route: 'IVSE',
        notes: 'Alternative au labétalol. Titrer selon PA.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  SYNDROME HELLP
  //  Source : SFAR-CNGOF 2022 ; ACOG Practice Bulletin 2020
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'hellp_syndrome',
    title: 'Syndrome HELLP',
    subtitle: 'SFAR-CNGOF 2022 — Hémolyse, Cytolyse Hépatique, Thrombopénie',
    emoji: '🤰',
    colorKey: 'red',
    source: 'SFAR-CNGOF 2022 ; ACOG 2020',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Critères diagnostiques (classification de Tennessee/Mississippi)',
        detail: 'Hemolysis : schizocytes, LDH >600 UI/L, bilirubine >1.2 mg/dL, haptoglobine effondrée. Elevated Liver enzymes : ASAT/ALAT >70 UI/L (classe I : >70, classe III seuil variable). Low Platelets : <100 000/mm³ (classe I <50 000 = sévère, classe II 50–100 000, classe III 100–150 000). Souvent associé à une pré-éclampsie mais peut survenir isolément (10–20% sans HTA/protéinurie significative). Douleur épigastrique/HCD = signe d\'alerte majeur.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Bilan de gravité et complications',
        detail: 'Rechercher : hématome sous-capsulaire hépatique/rupture hépatique (échographie/TDM abdominale si douleur HCD intense), CIVD (TP, fibrinogène, D-dimères), insuffisance rénale aiguë, œdème pulmonaire, décollement placentaire (hémorragie, contracture utérine). NFS-plaquettes, bilan hépatique et de coagulation répétés q6–12h.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Sulfate de magnésium — Prévention convulsions',
        detail: 'Indiqué systématiquement (prévention de l\'éclampsie) même en l\'absence d\'HTA sévère associée : 4 g IV en 15–20 min puis 1 g/h IVSE. Cf. protocole éclampsie pour surveillance et antidote.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Contrôle tensionnel si HTA associée',
        detail: 'Identique au protocole pré-éclampsie sévère : labétalol IV ou nicardipine IVSE si PAS ≥160 ou PAD ≥110 mmHg.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Correction de la coagulopathie avant geste',
        detail: 'Transfusion plaquettaire si <50 000/mm³ ET geste invasif prévu (césarienne, anesthésie périmédullaire contre-indiquée si <70–80 000). PFC/fibrinogène si CIVD associée. Anesthésie générale à privilégier si thrombopénie sévère et extraction urgente nécessaire.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Extraction fœtale — Traitement définitif',
        detail: 'L\'accouchement reste le traitement curatif, à réaliser après stabilisation maternelle initiale (24–48h de corticothérapie pour maturation pulmonaire si <34 SA et état maternofœtal le permettant, sinon extraction immédiate si instabilité). Corticothérapie à haute dose (dexaméthasone) parfois utilisée pour accélérer la récupération biologique maternelle post-partum — bénéfice débattu.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Surveillance post-partum intensive',
        detail: 'Le nadir plaquettaire et la aggravation biologique surviennent souvent 24–48h post-partum avant amélioration — surveillance rapprochée impérative en réanimation/soins intensifs. Surveillance de la fonction hépatique (risque de rupture hématome sous-capsulaire), rénale, et de l\'hémostase jusqu\'à normalisation.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Sulfate de Magnésium',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '4 g IV puis 1 g/h IVSE',
        route: 'IV bolus puis IVSE',
        notes: 'Prévention systématique de l\'éclampsie. Surveiller ROT, FR, diurèse.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Culots Plaquettaires',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'CP',
        fixedDose: '1 CPA ou 4–6 CP standard',
        route: 'Transfusion IV',
        notes: 'Si <50 000/mm³ et geste invasif prévu. Cible >50 000 avant césarienne, >70–80 000 avant périmédullaire.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Labétalol',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '20 mg IV',
        route: 'IV puis 40–80 mg q10 min',
        notes: 'Si HTA sévère associée (PAS ≥160/PAD ≥110). Max 300 mg.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  COMA MYXŒDÉMATEUX
  //  Source : American Thyroid Association / European Thyroid Association 2014
  //  https://www.liebertpub.com/doi/10.1089/thy.2014.0028
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'myxedema_coma',
    title: 'Coma Myxœdémateux',
    subtitle: 'ATA/ETA 2014 — Décompensation Hypothyroïdienne Sévère',
    emoji: '🌡️',
    colorKey: 'blue',
    source: 'ATA/ETA Guidelines 2014',
    evidenceLevel: EvidenceLevel.c,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaissance — Score diagnostique',
        detail: 'Hypothermie (souvent <35°C), troubles de conscience allant de la confusion au coma, bradycardie, hypoventilation avec hypercapnie, hyponatrémie, hypoglycémie. Facteur déclenchant fréquent : infection, froid, sédatifs/opiacés, AVC, arrêt du traitement substitutif. Mortalité élevée (25–60%) — urgence vitale à traiter avant confirmation biologique complète (TSH, T4 libre, cortisol).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Support ventilatoire et hémodynamique',
        detail: 'Intubation précoce si hypoventilation/hypercapnie sévère ou troubles de conscience marqués — seuil bas d\'intubation recommandé. Remplissage prudent si hypotension (risque de décompensation cardiaque sur cardiomyopathie hypothyroïdienne sous-jacente). Réchauffement passif progressif (couvertures) — éviter le réchauffement actif rapide qui peut provoquer une vasodilatation et un collapsus.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Hydrocortisone AVANT les hormones thyroïdiennes',
        detail: 'Hydrocortisone 100 mg IV bolus puis 50 mg q6h, à administrer SYSTÉMATIQUEMENT avant ou en même temps que la lévothyroxine — risque de précipiter une insuffisance surrénalienne aiguë si hormones thyroïdiennes données seules (insuffisance surrénalienne relative fréquemment associée).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Hormonothérapie substitutive IV',
        detail: 'Lévothyroxine (T4) 200–400 mcg IV dose de charge puis 50–100 mcg/j IV. Certains protocoles associent liothyronine (T3) 5–20 mcg IV en dose de charge puis 2.5–10 mcg q8h (action plus rapide) — à discuter avec endocrinologue, risque accru d\'événements cardiaques avec T3.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Correction des troubles métaboliques',
        detail: 'Hyponatrémie : restriction hydrique + sérum salé hypertonique si sévère/symptomatique (correction prudente, <8 mEq/L/24h). Hypoglycémie : G30% IV puis G10% IVSE. Réchauffement passif si hypothermie (couvertures, pas de réchauffement actif agressif).',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Traiter le facteur déclenchant',
        detail: 'Antibiothérapie empirique large spectre si infection suspectée (souvent masquée par l\'absence de fièvre malgré l\'infection). Éviter tout sédatif/opiacé (sensibilité accrue, risque de dépression respiratoire majorée). Surveillance en réanimation.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Hydrocortisone',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '100 mg IV puis 50 mg q6h',
        route: 'IV',
        notes: 'À donner AVANT ou avec la lévothyroxine — jamais après seule. Prévient l\'insuffisance surrénalienne aiguë.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Lévothyroxine (T4)',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mcg',
        fixedDose: '200–400 mcg IV puis 50–100 mcg/j',
        route: 'IV',
        notes: 'Dose de charge unique puis entretien quotidien. Toujours après hydrocortisone.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Glucose 30% (G30%)',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: '30 ml IV',
        route: 'IV bolus puis G10% IVSE',
        notes: 'Si hypoglycémie associée.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  INTOXICATIONS AIGUËS FRÉQUENTES
  //  Source : ANSM/Centres Antipoison ; ACMT/AACT Position Statements
  //  https://www.centres-antipoison.net
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'acute_poisoning',
    title: 'Intoxications Aiguës Fréquentes',
    subtitle: 'Centres Antipoison / ACMT — Toxiques Courants et Antidotes',
    emoji: '☠️',
    colorKey: 'orange',
    source: 'Centres Antipoison ; ACMT/AACT Position Statements',
    evidenceLevel: EvidenceLevel.c,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Approche générale — Stabilisation',
        detail: 'ABCDE systématique en priorité, avant identification du toxique. Contacter le centre antipoison local pour conduite spécifique. Identifier : substance, quantité, heure de prise, voie, co-ingestions, symptômes associés. Glycémie capillaire systématique. ECG systématique (QT, QRS — nombreux toxiques cardiotropes).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Décontamination digestive',
        detail: 'Charbon activé 1 g/kg PO/SNG (max 50 g) si ingestion <1–2h ET toxique adsorbable ET voies aériennes protégées (CI si trouble de conscience sans protection des VAS, caustiques, hydrocarbures). Pas de lavage gastrique en routine (bénéfice non démontré, risques). Décision au cas par cas avec le centre antipoison.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Intoxication aux opiacés',
        detail: 'Triade : myosis, dépression respiratoire, coma. Naloxone 0.4–2 mg IV/IM/IN, répéter q2–3 min jusqu\'à FR >10/min (titration prudente pour éviter syndrome de sevrage brutal). Durée d\'action naloxone (30–90 min) souvent < durée d\'action de l\'opiacé — surveillance prolongée et réinjection/perfusion souvent nécessaire.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Intoxication aux benzodiazépines',
        detail: 'Sédation, dépression respiratoire modérée (rarement isolément létale sauf co-ingestion). Flumazénil 0.2 mg IV puis 0.1 mg/min jusqu\'à réveil (max 1 mg) — usage prudent et réservé, CI si co-ingestion tricyclique/proconvulsivant connue ou suspectée (risque de convulsions par levée de l\'effet protecteur GABAergique).',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Intoxication au paracétamol',
        detail: 'N-acétylcystéine (NAC) selon nomogramme de Rumack-Matthew (paracétamolémie à H4 post-ingestion). Protocole IV : 150 mg/kg en 1h, puis 50 mg/kg en 4h, puis 100 mg/kg en 16h (ou protocole à 2 sacs plus récent). Débuter avant même le résultat si ingestion massive ou horaire incertain >8h et suspicion forte.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Intoxication aux tricycliques / cardiotropes',
        detail: 'QRS >100 ms = signe de gravité → Bicarbonate de sodium 8.4% 1–2 mEq/kg IV bolus, répéter pour QRS <100 ms (cible pH 7.45–7.55). Convulsions : benzodiazépines. Ne PAS utiliser antiarythmiques de classe Ia/Ic (aggravent le blocage sodique). Émulsion lipidique 20% (bolus 1.5 ml/kg puis perfusion) si toxicité cardiovasculaire sévère réfractaire aux mesures standard.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Intoxication aux stimulants (cocaïne, amphétamines)',
        detail: 'Agitation, tachycardie, HTA, hyperthermie, risque SCA/convulsions/hémorragie cérébrale. Benzodiazépines en 1ère ligne pour l\'agitation, l\'HTA et la tachycardie (diazépam/midazolam titré). Éviter les bêtabloquants purs (risque de vasospasme coronaire par activité alpha non contrée). Refroidissement actif si hyperthermie.',
      ),
      ProtocolStep(
        stepNumber: 8,
        title: 'Surveillance et orientation',
        detail: 'Surveillance cardiorespiratoire et neurologique prolongée adaptée à la cinétique du toxique. Avis psychiatrique systématique si intoxication volontaire. Contacter le centre antipoison pour toute situation atypique, toxique rare, ou polyintoxication.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Naloxone',
        category: EmergencyCategory.reversal,
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '0.4–2 mg IV/IM/IN',
        route: 'IV/IM/IN',
        notes: 'Titration prudente pour éviter sevrage brutal. Répéter/perfusion si opiacé longue durée.',
        canRepeat: true,
        repeatInterval: 'q2–3 min',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'N-Acétylcystéine',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 150.0,
        doseUnit: 'mg/kg',
        fixedDose: '150 mg/kg en 1h puis 50 mg/kg en 4h puis 100 mg/kg en 16h',
        route: 'IV',
        notes: 'Selon nomogramme de Rumack-Matthew. Débuter précocement en cas de doute.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Bicarbonate de Sodium',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 1.5,
        doseUnit: 'mEq/kg',
        fixedDose: '1–2 mEq/kg IV bolus',
        route: 'IV, répéter selon QRS',
        notes: 'Intoxication tricyclique avec QRS >100 ms. Cible pH 7.45–7.55.',
        canRepeat: true,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Flumazénil',
        category: EmergencyCategory.reversal,
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '0.2 mg IV',
        route: 'IV puis 0.1 mg/min',
        notes: 'Max 1 mg. CI si co-ingestion proconvulsivante suspectée (tricycliques).',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Émulsion Lipidique 20%',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 1.5,
        doseUnit: 'ml/kg',
        fixedDose: '1.5 ml/kg bolus puis perfusion',
        route: 'IV',
        notes: 'Toxicité cardiovasculaire sévère réfractaire (anesthésiques locaux, tricycliques, bêtabloquants, inhibiteurs calciques).',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  CRISE THYROÏDIENNE (TEMPÊTE THYROÏDIENNE)
  //  Source : American Thyroid Association Guidelines 2016
  //  https://www.liebertpub.com/doi/10.1089/thy.2016.0171
  //  Thyroid 2016;26(9):1343-421
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'thyroid_storm',
    title: 'Crise Thyroïdienne',
    subtitle: 'ATA Guidelines 2016 — Tempête Thyroïdienne',
    emoji: '🌡️',
    colorKey: 'orange',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître — Score de Burch-Wartofsky',
        detail: 'Critères : fièvre ≥38.5°C, tachycardie >100/min, agitation/confusion/coma, insuffisance cardiaque, dysfonction hépatique, facteur déclenchant (chirurgie, infection, grossesse, IDR, stop antithyroïdiens). Score BWS ≥45 = tempête thyroïdienne certaine. Bilan : TSH, T3, T4 libre, NFS, bilan hépatique.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Bloquer la synthèse des hormones thyroïdiennes',
        detail: 'Propylthiouracile (PTU) 500–1000 mg PO/SNG en dose de charge puis 250 mg q4h. OU Méthimazole 60–80 mg/j. PTU préféré car bloque aussi la conversion T4→T3. APRÈS le PTU (délai ≥1h) : Lugol (solution iodo-iodurée) 5–10 gouttes q8h PO — bloque la libération des hormones stockées.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Bêtabloquants — Contrôle cardiovasculaire',
        detail: 'Propranolol 1–2 mg IV q10 min (max 6–10 mg) ou 60–80 mg PO q4h. Cible FC <100/min. Bloque aussi la conversion T4→T3. Esmolol en IVSE si IV nécessaire (0.25–0.5 mg/kg bolus puis 50–200 mcg/kg/min). CI : asthme, BAV. Alternative : diltiazem si bêtabloquants CI.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Hydrocortisone — Corticothérapie',
        detail: 'Hydrocortisone 100 mg IV q8h (ou dexaméthasone 2 mg q6h). Double intérêt : traitement d\'une éventuelle insuffisance surrénalienne relative ET inhibition de la conversion T4→T3 périphérique.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Mesures de soutien',
        detail: 'Réhydratation IV (pertes sudorales + fièvre). Refroidissement actif : paracétamol IV (ÉVITER l\'aspirine = déplace T4 de sa protéine porteuse → aggrave l\'hyperthyroïdie). Thiamine 100 mg IV si carences suspectées. Anticoagulation si FA. Sédation si agitation.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Propranolol',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '1–2 mg IV',
        route: 'IV lent q10 min ou PO q4h',
        notes: '1ère ligne CV. Bloque aussi T4→T3. Cible FC <100. CI : asthme, BAV, IC décompensée.',
        canRepeat: true,
        repeatInterval: 'q10 min IV (max 10 mg) ou q4h PO',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Hydrocortisone',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '100 mg IV',
        route: 'IV q8h',
        notes: 'Inhibe la conversion T4→T3 périphérique + traitement insuffisance surrénalienne relative.',
        canRepeat: true,
        repeatInterval: 'q8h',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Paracétamol',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '1000 mg IV',
        route: 'IV en 15 min q6h',
        notes: 'Antipyrexie. ÉVITER l\'aspirine (déplace T4 = aggravation).',
        canRepeat: true,
        repeatInterval: 'q6h',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  HYPOGLYCÉMIE SÉVÈRE
  //  Source : ADA Standards of Care 2024
  //  https://diabetesjournals.org/care/issue/47/Supplement_1
  //  Endocrine Society Guidelines 2009
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'severe_hypoglycemia',
    title: 'Hypoglycémie Sévère',
    subtitle: 'ADA Standards 2024 — Glycémie < 0.5 g/L + symptômes',
    emoji: '🍬',
    colorKey: 'orange',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Confirmer et classer la sévérité',
        detail: 'Légère : patient conscient, peut avaler → 15 g glucose PO (3 sucres, 150 ml jus). Modérée : confusion, agitation, pas d\'autonomie. Sévère : perte de conscience, convulsions, incapacité à s\'auto-traiter. Confirmer par glycémie capillaire. Seuil critique : <0.5 g/L.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Resucrage IV immédiat',
        detail: 'G30% 30 ml IV (= 9 g glucose) puis G10% IVSE 100 ml/h. OU G50% 15–25 ml IV puis G10% IVSE. Glycémie cible : 1–1.8 g/L. Réévaluer glycémie à 15 min, puis q30 min pendant 2h. ATTENTION : si suspicion de Wernicke (alcoolique, dénutri) → Thiamine 100 mg IV AVANT glucose.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Glucagon IM si pas d\'accès IV',
        detail: 'Glucagon 1 mg IM (ou SC) si pas d\'accès IV. Délai d\'action 10–15 min. Inefficace si déplétion glycogène hépatique (alcoolisme chronique, malnutrition, hépatopathie sévère). Après reprise de conscience : glucides PO complexes.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Traiter la cause et prévenir la récidive',
        detail: 'Identifier la cause : insuline ou sulfonylurée en excès, jeûne prolongé, insuffisance surrénalienne, insuffisance hépatique. Perfusion G10% ou G5% continue si hypoglycémie récurrente (sulfonylurée longue durée). Surveillance glycémique q1h pendant au moins 24h. Adapter le traitement diabétique.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Glucose 30% (G30%)',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'ml',
        fixedDose: '30 ml IV',
        route: 'IV bolus puis G10% IVSE',
        notes: '= 9 g glucose. Puis G10% 100 ml/h de fond. Cible glycémie 1–1.8 g/L. Contrôle à 15 min.',
        canRepeat: true,
        repeatInterval: 'Si glycémie <0.7 g/L à 15 min',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Glucagon',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '1 mg IM',
        route: 'IM ou SC',
        notes: 'Si pas d\'accès IV. Délai 10–15 min. Inefficace en dénutrition/alcoolisme/IHC. Puis glucides PO dès conscience.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Thiamine (Vitamine B1)',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '100 mg IV',
        route: 'IV lent (10 min)',
        notes: 'AVANT glucose si alcoolisme ou dénutrition — prévenir encéphalopathie de Wernicke.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  EXACERBATION AIGUË DE BPCO
  //  Source : GOLD COPD Guidelines 2024
  //  https://goldcopd.org/2024-gold-report/
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'copd_exacerbation',
    title: 'Exacerbation Aiguë de BPCO',
    subtitle: 'GOLD 2024 — Décompensation Respiratoire',
    emoji: '🫁',
    colorKey: 'blue',
    source: 'GOLD COPD Guidelines 2024',
    evidenceLevel: EvidenceLevel.a,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Évaluation de la sévérité',
        detail: 'Dyspnée aggravée, majoration des expectorations/purulence, FR, usage muscles accessoires, respiration paradoxale. Gazométrie artérielle : PaCO₂ >45 mmHg = hypercapnie, pH <7.35 = acidose respiratoire décompensée. Rechercher facteur déclenchant : infection, PNO, EP, IC.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Oxygénothérapie contrôlée',
        detail: 'Cible SpO₂ 88–92% (PAS >94% — risque d\'hypercapnie induite par hyperoxie). Débuter à 1–2 L/min lunettes ou Venturi 24–28%. Recontrôler gazométrie à 30–60 min.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Bronchodilatateurs — Nébulisation',
        detail: 'Salbutamol 2.5–5 mg nébulisé + Ipratropium 0.5 mg nébulisé, association q20 min x3 puis q4–6h. Nébuliser à l\'air comprimé si hypercapnie sévère (pas O₂ pur — favorise majoration PaCO₂).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Corticostéroïdes systémiques',
        detail: 'Prednisolone 40 mg PO/j x5 jours (ou méthylprednisolone 40 mg IV si voie orale impossible). Réduit durée d\'hospitalisation et risque de rechute (niveau A GOLD 2024). Ne pas dépasser 5–7 jours.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Antibiothérapie si critères d\'Anthonisen',
        detail: 'Indiquée si ≥2 critères : majoration dyspnée + volume expectorations + purulence. Amoxicilline-acide clavulanique ou macrolide 5–7 jours. Si ventilation mécanique nécessaire : antibiothérapie systématique.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'VNI si acidose respiratoire',
        detail: 'Indication formelle : pH 7.25–7.35 avec hypercapnie. BiPAP : IPAP 12–20 cmH₂O, EPAP 4–6 cmH₂O, ajuster pour VT 6–8 ml/kg. Réduit mortalité et intubation de 50% (Cochrane). Échec VNI (pH <7.25, épuisement, coma) → intubation.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Ventilation invasive si échec VNI',
        detail: 'Réglages : VT 6–8 ml/kg, FR basse 8–12/min (éviter auto-PEEP), temps expiratoire prolongé (I:E 1:3–1:4), PEEP externe 70–85% de l\'auto-PEEP mesurée. Surveiller hyperinflation dynamique et hypotension au branchement.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Salbutamol',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '2.5–5 mg nébulisé',
        route: 'Nébulisation (air comprimé si hypercapnie)',
        notes: 'q20 min x3 puis q4–6h. Associer ipratropium. Surveiller tachycardie, tremblements, hypokaliémie.',
        canRepeat: true,
        repeatInterval: 'q20 min x3 puis q4–6h',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Ipratropium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '0.5 mg nébulisé',
        route: 'Nébulisation',
        notes: 'Associé au salbutamol. Effet synergique sur bronchodilatation.',
        canRepeat: true,
        repeatInterval: 'q4–6h',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Prednisolone',
        urgency: EmergencyUrgency.moderate,
        doseUnit: 'mg',
        fixedDose: '40 mg PO/j',
        route: 'PO ou IV (méthylprednisolone si PO impossible)',
        notes: 'Durée 5 jours (GOLD 2024, niveau A). Ne pas prolonger au-delà de 7 jours.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Amoxicilline-Acide Clavulanique',
        urgency: EmergencyUrgency.moderate,
        doseUnit: 'g',
        fixedDose: '1 g x3/j PO',
        route: 'PO ou IV',
        notes: 'Si ≥2 critères d\'Anthonisen. Durée 5–7 jours. Adapter selon écologie locale.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  ASTHME AIGU GRAVE
  //  Source : GINA Global Strategy for Asthma Management 2024
  //  https://ginasthma.org/2024-gina-main-report/
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'severe_asthma',
    title: 'Asthme Aigu Grave',
    subtitle: 'GINA 2024 — Crise d\'Asthme Sévère',
    emoji: '🫁',
    colorKey: 'blue',
    source: 'GINA Global Strategy 2024',
    evidenceLevel: EvidenceLevel.a,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître les signes de gravité',
        detail: 'Critique/pré-arrêt : silence auscultatoire, cyanose, bradycardie, épuisement, confusion, coma, PEF <33% théorique. Sévère : FR >25/min, FC >110/min, PEF 33–50%, incapacité à finir une phrase, usage muscles accessoires. Gazométrie : normo/hypercapnie = signe d\'alarme majeur (asthmatique s\'épuise et hyperventile normalement).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Oxygénothérapie',
        detail: 'O₂ pour SpO₂ cible 93–95%. Masque haute concentration si besoin 10–15 L/min. Ne pas restreindre l\'O₂ contrairement à la BPCO (l\'hypercapnie ici est un signe de gravité, pas la norme).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Bêta-2-agonistes à haute dose répétés',
        detail: 'Salbutamol nébulisé 5 mg, en continu ou q20 min pendant la 1ère heure. Forme sévère : nébulisation continue 10–15 mg/h. Voie IV (salbutamol IVSE 5–20 mcg/min) si nébulisation inefficace ou impossible (ventilation mécanique).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Ipratropium associé',
        detail: 'Bromure d\'ipratropium 0.5 mg nébulisé associé au salbutamol q20 min x3 dans les formes sévères — réduit le taux d\'hospitalisation (niveau A).',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Corticostéroïdes systémiques précoces',
        detail: 'Prednisolone 40–50 mg PO ou méthylprednisolone 60–80 mg IV dès la prise en charge (délai d\'action 4–6h, à ne pas retarder). Durée 5–7 jours sans décroissance nécessaire.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Sulfate de magnésium IV',
        detail: 'Si réponse insuffisante aux bronchodilatateurs après 1h : MgSO₄ 2 g IV en 20 min (dose unique). Bronchodilatation additionnelle par relaxation du muscle lisse bronchique. Surveiller hypotension.',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Escalade — Ventilation',
        detail: 'Signes d\'épuisement, silence auscultatoire, troubles de conscience, hypercapnie progressive → intubation par un opérateur expérimenté (risque de collapsus périintubation). Ventilation à hypoventilation contrôlée : VT 6–8 ml/kg, FR basse, I:E long, PEEP 0 initialement, tolérer hypercapnie permissive (pH >7.2).',
        isCritical: true,
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Salbutamol',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '5 mg nébulisé',
        route: 'Nébulisation continue ou q20 min',
        notes: 'Forme critique : nébulisation continue 10–15 mg/h ou IVSE 5–20 mcg/min. Surveiller kaliémie, FC, lactates.',
        canRepeat: true,
        repeatInterval: 'q20 min x3 puis continu si sévère',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Ipratropium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '0.5 mg nébulisé',
        route: 'Nébulisation',
        notes: 'Associé au salbutamol q20 min x3 dans les 1ères heures.',
        canRepeat: true,
        repeatInterval: 'q20 min x3',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Méthylprednisolone',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '60–80 mg IV',
        route: 'IV',
        notes: 'Ne pas retarder — délai d\'action 4–6h. Alternative : prednisolone 40–50 mg PO si voie orale possible.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Sulfate de Magnésium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'g',
        fixedDose: '2 g IV',
        route: 'IV en 20 min',
        notes: 'Si réponse insuffisante après 1h de traitement standard. Dose unique. Surveiller hypotension et ROT.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  HYPERKALIÉMIE MENAÇANTE
  //  Source : KDIGO / European Resuscitation Council 2021
  //  https://kdigo.org  •  Resuscitation 2021;161:152-219
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'hyperkalemia',
    title: 'Hyperkaliémie Menaçante',
    subtitle: 'ERC 2021 / KDIGO — Trouble Ionique Vital',
    emoji: '⚡',
    colorKey: 'orange',
    source: 'ERC Guidelines 2021 ; KDIGO',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Confirmer et évaluer la gravité',
        detail: 'K⁺ >6.5 mmol/L ou anomalies ECG = menaçante quel que soit le taux : ondes T amples pointues, QRS élargi, disparition onde P, aspect sinusoïdal (pré-FV/asystolie). ECG 12 dérivations immédiat. Rechercher cause : IRA, IEC/ARA2, épargneurs K⁺, rhabdomyolyse, syndrome de lyse tumorale, acidose.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Stabilisation membranaire — Calcium',
        detail: 'Gluconate de calcium 10% 10 ml (1 g) IV en 5–10 min si anomalies ECG. Action en 1–3 min, durée 30–60 min. Répéter si ECG non normalisé à 5 min. Chlorure de calcium si voie centrale disponible (3x plus concentré en Ca²⁺). Ne baisse PAS la kaliémie — protège uniquement le myocarde.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Transfert intracellulaire — Insuline-Glucose',
        detail: 'Insuline rapide 10 UI + Glucose 25 g (G30% 100 ml) IV en 15–30 min. Effet en 15–30 min, durée 4–6h, baisse K⁺ de 0.6–1.0 mmol/L. Surveiller glycémie capillaire q30 min pendant 4h (risque hypoglycémie retardée).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Salbutamol nébulisé — Transfert additionnel',
        detail: 'Salbutamol 10–20 mg nébulisé (dose élevée, 4x dose asthme). Effet additif à l\'insuline, baisse K⁺ de 0.5–1.0 mmol/L en 15–30 min. Surveiller tachycardie. Inefficace si bêtabloquant en cours.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Correction de l\'acidose si présente',
        detail: 'Bicarbonate de sodium 8.4% 50 ml IV en 5 min si acidose métabolique sévère associée (pH <7.2). Effet retardé (15–30 min) et modeste — traitement adjuvant seulement, pas en 1ère intention isolée.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Élimination du potassium',
        detail: 'Diurétiques de l\'anse (furosémide 40–80 mg IV) si fonction rénale préservée + volémie correcte. Résines échangeuses d\'ions (patiromer, sodium zirconium cyclosilicate) en relais, action lente (heures). Épuration extra-rénale en urgence si IRA anurique, hyperkaliémie réfractaire ou menaçante persistante malgré traitement médical.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Surveillance et réévaluation',
        detail: 'ECG scope continu. Ionogramme à 1h, 2h, 4h, 6h. Répéter le protocole calcium/insuline-glucose si persistance des anomalies ECG. Traiter la cause sous-jacente (arrêt médicaments hyperkaliémiants, correction IRA).',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Gluconate de Calcium 10%',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '1 g (10 ml) IV',
        route: 'IV en 5–10 min',
        notes: 'Si anomalies ECG. Répéter à 5 min si ECG persistant anormal. Ne baisse pas le K⁺ — protection myocardique uniquement.',
        canRepeat: true,
        repeatInterval: 'q5–10 min si ECG non amélioré',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Insuline Rapide + Glucose',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'UI',
        fixedDose: '10 UI + G30% 100 ml IV',
        route: 'IV en 15–30 min',
        notes: 'Surveiller glycémie q30 min x4h (hypoglycémie retardée fréquente). Baisse K⁺ 0.6–1.0 mmol/L.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Salbutamol',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '10–20 mg nébulisé',
        route: 'Nébulisation (dose élevée)',
        notes: 'Additif à l\'insuline-glucose. Inefficace sous bêtabloquant. Surveiller tachycardie.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Furosémide',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '40–80 mg IV',
        route: 'IV bolus',
        notes: 'Si fonction rénale préservée et volémie adaptée. Favorise élimination urinaire du K⁺.',
        isFirstLine: false,
      ),
    ],
  ),
];