// ===========================
//  lib/data/insufficiency_protocols_data.dart
//  VERSION 2.0 — Protocoles d'INSUFFISANCE enrichis et vérifiés
//
//  SOURCES OFFICIELLES :
//  • ESC Heart Failure Guidelines 2021
//    https://www.escardio.org/Guidelines/Clinical-Practice-Guidelines/Acute-and-Chronic-Heart-Failure
//  • ATS/ERS/ESICM ARDS Definition & Management 2012/2017
//    https://www.atsjournals.org/doi/full/10.1164/rccm.201202-0291OC
//  • KDIGO AKI Clinical Practice Guidelines 2012
//    https://kdigo.org/guidelines/acute-kidney-injury/
//  • EASL Clinical Practice Guidelines — Liver Failure 2017
//    https://www.journal-of-hepatology.eu/article/S0168-8278(17)30185-6/fulltext
//  • Endocrine Society Clinical Practice Guidelines — Adrenal Insufficiency 2016
//    https://academic.oup.com/jcem/article/101/2/364/2810571
//  • Surviving Sepsis Campaign Guidelines 2021
//    https://www.sccm.org/SurvivingSepsisCampaign/Guidelines/Adult-Patients
//  • GOLD COPD Guidelines 2024
//    https://goldcopd.org/2024-gold-report/
//  • Miller's Anesthesia 9th Ed. (2019)
//  • UpToDate 2024 — https://www.uptodate.com
// ===========================

import '../models/emergency_drug.dart';

const List<EmergencyProtocol> insufficiencyProtocols = [
  // ══════════════════════════════════════════════════════════════
  //  INSUFFISANCE CARDIAQUE AIGUË / OAP CARDIOGÉNIQUE
  //  Source : ESC Heart Failure Guidelines 2021
  //  https://www.escardio.org/Guidelines/Clinical-Practice-Guidelines
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'heart_failure',
    title: 'Insuffisance Cardiaque Aiguë',
    subtitle: 'ESC HF Guidelines 2021 — OAP Cardiogénique',
    emoji: '🫀',
    colorKey: 'blue',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Évaluation initiale et classification',
        detail: 'Score KILLIP ou profil hémodynamique : chaud/sec (compensé), chaud/humide (congestion), froid/sec (hypovolémie), froid/humide (choc cardiogénique). Cible traitement = profil chaud/sec. ECG 12 dérivations immédiat (SCA?). Troponine, BNP/NT-proBNP, bilan rénal.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Position et O₂',
        detail: 'Position assise, jambes pendantes (réduit le retour veineux). O₂ : cible SpO₂ 94–98%. VNI (CPAP 5–10 cmH₂O ou BiPAP) si PaO₂/FiO₂ <250 ou FR >25/min — réduit intubation de 40% (méta-analyse Cochrane 2019). Intubation si insuffisance VNI, épuisement respiratoire, GCS ↓.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Diurétiques IV — Décongestion',
        detail: 'Furosémide IV : si naïf de diurétiques → 40 mg IV bolus. Si sous furosémide PO → dose IV = dose PO quotidienne (max 200 mg bolus). Évaluer réponse à 2h : diurèse >200 ml/h = répondeur. Si répondeur insuffisant : doubler la dose ou IVSE 5–20 mg/h. Objectif : perte poids 1–2 kg/j.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Vasodilatateurs IV',
        detail: 'Nitroglycérine IV si PAS ≥110 mmHg et pas de sténose aortique sévère. Départ : 0.25 mcg/kg/min, titrer q5 min jusqu\'à amélioration clinique ou PAS 90 mmHg. Objectif : réduction pré et postcharge, amélioration débit cardiaque. Nitroprussiate si crise hypertensive associée.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Inotropes si choc cardiogénique',
        detail: 'Dobutamine 2–20 mcg/kg/min IVSE si hypoperfusion (PAS<90, marbrures, oligurie, lactates>2). Noradrénaline si PAM <65 mmHg malgré dobutamine (éviter si possible — augmente postcharge). Milrinone 0.375–0.75 mcg/kg/min si FE très basse et bêtabloqué. Levosimendan dans certaines indications.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Traiter la cause sous-jacente',
        detail: 'SCA : reperfusion coronaire en urgence (PCI < 2h si STEMI). FA rapide : cardioversion si instable, ou digoxine/amiodarone pour ralentir. HTA maligne : labétalol IV + nicardipine IV. EP massive : thrombolyse. Tamponnade : péricardocentèse. Valvulopathie aiguë : chirurgie en urgence.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Furosémide',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 1.0,
        doseUnit: 'mg/kg',
        fixedDose: '40–200 mg IV',
        route: 'IV bolus ou IVSE',
        notes: 'Départ 40 mg si naïf. Si sous diurétiques : dose IV = dose PO. Évaluer diurèse à 2h. IVSE 5–20 mg/h si bolus insuffisant.',
        canRepeat: true,
        repeatInterval: 'q2–6h si diurèse insuffisante',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Nitroglycérine',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 0.25,
        doseUnit: 'mcg/kg/min',
        fixedDose: '0.25–5 mcg/kg/min',
        route: 'IVSE',
        notes: 'Si PAS ≥110 mmHg. Titrer pour PAS cible 100–110 mmHg. CI : PDE5i dans les 24–48h, hypotension, sténose aortique sévère.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Dobutamine',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 5.0,
        doseUnit: 'mcg/kg/min',
        fixedDose: '2–20 mcg/kg/min',
        route: 'IVSE voie centrale',
        notes: 'Choc cardiogénique uniquement. Départ 2 mcg/kg/min. Risque tachyarythmies >10 mcg/kg/min.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Noradrénaline',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 0.05,
        doseUnit: 'mcg/kg/min',
        fixedDose: '0.05–0.5 mcg/kg/min',
        route: 'IVSE voie centrale',
        notes: 'PAM <65 mmHg réfractaire à dobutamine seule. Augmente postcharge — utiliser à dose minimale.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Morphine',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '2–4 mg IV',
        route: 'IV lent',
        notes: 'Usage controversé (données ESC 2021 défavorables en routine). Réserver à l\'anxiété et dyspnée sévère réfractaire uniquement.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  INSUFFISANCE RESPIRATOIRE AIGUË / SDRA
  //  Source : ARDS Berlin Definition 2012 + ATS/ERS/ESICM Guidelines
  //  https://www.atsjournals.org/doi/full/10.1164/rccm.201202-0291OC
  //  PROSEVA Trial (NEJM 2013) — Prone positioning
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'respiratory_failure',
    title: 'Insuffisance Respiratoire Aiguë',
    subtitle: 'Berlin 2012 / PROSEVA NEJM 2013 — IRA / SDRA',
    emoji: '🫁',
    colorKey: 'blue',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Évaluation et libération des VAS',
        detail: 'Score de sévérité : FR, SpO₂, rapport PaO₂/FiO₂, tirage, cyanose. SDRA : PaO₂/FiO₂ <300 mmHg sous PEEP ≥5 cmH₂O, opacités bilatérales, origine non cardiaque. Aspiration oro/nasopharyngée si sécrétions. Subluxation mandibulaire + canule de Guedel si inconscient.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'O₂ et VNI si PaO₂/FiO₂ ≥150',
        detail: 'O₂ masque haute concentration 12–15 L/min (cible SpO₂ 92–96%). VNI (CPAP 8–12 cmH₂O ou BiPAP AI 8–15 cmH₂O + PEEP 5–10 cmH₂O) si : OAP cardiogénique, exacerbation BPCO, immunodéprimé. Réévaluer à 1h : amélioration → continuer, stagnation → intuber. OHD 40–60 L/min si disponible.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Intubation et ventilation protectrice',
        detail: 'Critères d\'intubation : SpO₂ <90% sous VNI max, FR >40/min, épuisement, troubles conscience. Ventilation protectrice SDRA : VT 6 ml/kg PCI (poids corporel idéal), FR 16–24/min, PEEP 5–15 cmH₂O (table ARDS network), FiO₂ min pour SpO₂ 92–96%, Pression plateau ≤30 cmH₂O.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Curarisation en SDRA sévère',
        detail: 'SDRA sévère (PaO₂/FiO₂ <150) : cisatracurium 37.5 mg bolus puis 37.5 mg/h (0.375 mg/kg/h) IVSE pendant 48h. Amélioration PaO₂/FiO₂ et mortalité (ACURASYS trial, NEJM 2010). Ne pas utiliser la néostigmine pour réversibilité — laisser récupérer spontanément.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Décubitus ventral (Prone Positioning)',
        detail: 'Indication : PaO₂/FiO₂ <150 sous FiO₂ ≥60% + PEEP ≥5. Sessions de 16h minimum (PROSEVA : 16h/j réduit mortalité 32.8% → 16%). Complications : extubation accidentelle, escarres faciales, œdème facial. Contre-indications : fracture instable, hypertension intracrânienne, voie veineuse non sécurisée.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Traiter la cause sous-jacente',
        detail: 'Pneumonie : antibiothérapie probabiliste (Pipéracilline-Tazobactam 4.5 g q6h ± amikacine si sepsis sévère). OAP cardiogénique : diurétiques + vasodilatateurs. Inhalation : lavage bronchique. Embolie pulmonaire massive : thrombolyse ou embolectomie. Noyade : PEEP élevée, surfactant discuté.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Salbutamol',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '2.5–5 mg',
        route: 'Nébulisé q4–6h',
        notes: 'Bronchospasme associé (asthme, BPCO). Prudence si tachycardie sévère.',
        canRepeat: true,
        repeatInterval: 'q4–6h ou q20 min si crise sévère',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Ipratropium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mcg',
        fixedDose: '500 mcg nébulisé',
        route: 'Nébulisé q6–8h',
        notes: 'Associer au salbutamol en BPCO exacerbée ou asthme sévère.',
        canRepeat: true,
        repeatInterval: 'q6–8h',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Cisatracurium (SDRA)',
        category: EmergencyCategory.intubation,
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 0.375,
        doseUnit: 'mg/kg/h',
        fixedDose: '37.5 mg bolus + 37.5 mg/h',
        route: 'IVSE pendant 48h',
        notes: 'SDRA sévère (PaO₂/FiO₂ <150). Pas d\'accumulation (Hofmann). Monitoring TOF.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Hydrocortisone',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '200 mg/24h IVSE',
        route: 'IVSE ou 50 mg q6h',
        notes: 'SDRA réfractaire après 7j OU si choc septique associé. Réduire progressivement.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Sulfate de Magnésium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'g',
        fixedDose: '2 g IV sur 20 min',
        route: 'IV lent',
        notes: 'Bronchospasme sévère réfractaire aux β2-agonistes (asthme aigu grave).',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  INSUFFISANCE RÉNALE AIGUË (IRA) / HYPERKALIÉMIE
  //  Source : KDIGO AKI Guidelines 2012
  //  https://kdigo.org/guidelines/acute-kidney-injury/
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'renal_failure',
    title: 'Insuffisance Rénale Aiguë',
    subtitle: 'KDIGO 2012 — IRA / Hyperkaliémie menaçante',
    emoji: '🫘',
    colorKey: 'blue',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Diagnostiquer et stader l\'IRA',
        detail: 'KDIGO : IRA = ↑créatinine ≥0.3 mg/dL en 48h OU ≥1.5x valeur de base en 7j OU diurèse <0.5 ml/kg/h pendant ≥6h. Stade 1: créatinine x1.5–1.9 base. Stade 2: x2–2.9. Stade 3: x3 ou ≥4 mg/dL ou EER. Bilan étiologique : pré-rénale (hypoperfusion), rénale (NTA, GN), post-rénale (obstacle).',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Sonde vésicale et bilan entrées/sorties',
        detail: 'Pose sonde urinaire (levée obstacle + monitorage diurèse). Objectif : diurèse ≥0.5 ml/kg/h. Bilan strictement entrées/sorties toutes les 4h. Corriger l\'hypovolémie si pré-rénale (levée jambe passive → si ΔPA >10% = précharge-dépendant → remplissage 250–500 ml cristalloïde).',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Traiter l\'hyperkaliémie menaçante',
        detail: 'K⁺ ≥5.5 mEq/L + anomalies ECG (onde T pointue, QRS ≥0.12s, PR allongé, FA lente) = URGENCE. 1. Gluconate calcium 1 g IV en 3 min (protection membranaire immédiate, durée 30 min). 2. Insuline 10 U + G50% 50 ml IV (↓K⁺ 0.5–1 mEq/L en 30 min). 3. Bicarbonate 50 mEq IV si pH<7.2. 4. Salbutamol 10–20 mg nébulisé. 5. Dialyse si réfractaire.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Éviter les néphrotoxiques',
        detail: 'ARRÊTER : AINS (ibuprofène, kétoprofène, indométacine), IEC/ARA2, aminosides, produits de contraste iodés hyperosmolaires, metformine, tacrolimus/ciclosporine. Ajuster TOUTES les doses médicamenteuses selon DFG actuel (calculer). Éviter les fluides contenant du potassium (Ringer Lactate si K⁺ déjà élevé).',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Remplissage vasculaire guidé',
        detail: 'Remplissage NaCl 0.9% ou PlasmaLyte si pré-rénale. Test de levée passive des jambes. Éviter le suremplissage (aggrave les IRA parenchymateuses). Furosémide UNIQUEMENT si surcharge avérée cliniquement (ne prévient pas la dialyse, peut masquer une oligurie). PAM cible ≥65 mmHg (80 si HTA chronique).',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Indications épuration extra-rénale (EER)',
        detail: 'Indications urgentes (AEIOU) : Acidose pH<7.1 réfractaire, Electrolytes (K⁺>6.5 réfractaire), Intoxication urémique (péricardite, encéphalopathie), Overload (surcharge pulmonaire réfractaire), Urée >150 mg/dL + symptômes. Contacter la néphro-réanimation. HDF ou HD continue selon instabilité.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Gluconate de Calcium',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '1–2 g IV',
        route: 'IV en 3–5 min',
        notes: 'Hyperkaliémie ≥5.5 + anomalies ECG. Protection membranaire immédiate. Durée 30–60 min seulement.',
        canRepeat: true,
        repeatInterval: 'q30 min si ECG non normalisé',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Insuline + G50%',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'U',
        fixedDose: '10 U insuline + 50 ml G50%',
        route: 'IV sur 15 min',
        notes: 'Réduit K⁺ de 0.5–1 mEq/L en 15–30 min. Durée d\'action 4–6h. Surveiller glycémie.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Salbutamol (IV/nébulisé)',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '10–20 mg nébulisé',
        route: 'Nébulisé ou IV',
        notes: 'Réduit K⁺ de 0.5–1 mEq/L supplémentaire. En complément insuline. Non efficace chez dialysés.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Bicarbonate de Sodium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mEq/kg',
        fixedDose: '50–100 mEq IV',
        route: 'IV lent (30 min)',
        notes: 'Si pH<7.2 + acidose métabolique. Effet modeste sur K⁺. CI si surcharge sodique ou alcalose.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Furosémide',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 1.0,
        doseUnit: 'mg/kg',
        fixedDose: '40–200 mg IV',
        route: 'IV',
        notes: 'Surcharge volémique avérée UNIQUEMENT. Ne prévient pas la dialyse (KDIGO 2012).',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  INSUFFISANCE HÉPATIQUE AIGUË / ENCÉPHALOPATHIE
  //  Source : EASL Guidelines Liver Failure 2017
  //  https://www.journal-of-hepatology.eu/guidelines
  //  American Association for Study of Liver Diseases (AASLD)
  //  https://www.aasld.org/publications/practice-guidelines
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'liver_failure',
    title: 'Insuffisance Hépatique Aiguë',
    subtitle: 'EASL 2017 / AASLD — Encéphalopathie hépatique',
    emoji: '🫔',
    colorKey: 'blue',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Évaluer la sévérité',
        detail: 'Score de West Haven (0–4) pour l\'encéphalopathie. Grade III-IV (GCS ≤12) = indication d\'intubation. Score MELD (Bilirubin, Créatinine, INR) pour pronostic. Bilan : NFS, TP/INR, facteur V (marqueur pronostique IHC aiguë), bilirubin, NH₃, glycémie, lactatémie. Contacter précocement un centre de transplantation hépatique.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Protection des voies aériennes',
        detail: 'Grade III–IV : intubation SYSTÉMATIQUE (inhaler le vomissement = mortalité majeure). SRI avec propofol 1.5 mg/kg (éviter étomidate et succinylcholine — risque hyperkaliémie). Attention : coagulopathie → risque saignement laryngoscopie, ne pas forcer. Éviter les sédatifs à longue durée (accumulation IHC).',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Hémorragie digestive haute (varices œsophagiennes)',
        detail: 'Terlipressine 1 mg IV q4–6h (ou octréotide 50 mcg bolus puis 50 mcg/h IVSE). Endoscopie urgente dans les 12h (ligature de varices ou sclérose). Antibioprophylaxie : céftriaxone 1 g/j IV (réduit mortalité). Prévention PBE chez tous les cirrhotiques hospitalisés pour hémorragie.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Réduire l\'ammoniémie',
        detail: 'Lactulose PO/SNG 30 ml q2h jusqu\'à 2–3 selles/j, puis q8h. Rifaximine 550 mg PO q12h (réduit récidive encéphalopathie — ACCESS trial). Éviter les protéines alimentaires n\'est PLUS recommandé (données EASL 2017 contre). L-ornithine L-aspartate IV discuté.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Coagulopathie',
        detail: 'Ne pas corriger l\'INR si pas de saignement actif (reflet de la synthèse hépatique, pas du risque hémorragique réel). Saignement actif ou geste invasif prévu : FFP 10–15 ml/kg IV. Plaquettes si <50 000/mm³ et geste invasif. Fibrinogène si <1.5 g/L. Vitamine K 10 mg IV lent si carence possible.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Traiter la cause et prévenir les complications',
        detail: 'Paracétamol (surdosage) : N-acétylcystéine 150 mg/kg sur 60 min puis 12.5 mg/kg/h x4h puis 6.25 mg/kg/h x16h. Infection : hémocultures + cultures ascite (ponction diagnostique) + ATB large spectre. Syndrome hépato-rénal : terlipressine + albumine 1 g/kg/j. PBE : céftriaxone 2 g/j + albumine.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Terlipressine',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '1–2 mg IV',
        route: 'IV lent q4–6h',
        notes: 'Hémorragie variqueuse et syndrome hépato-rénal. Précaution : coronaropathie, AOMI.',
        canRepeat: true,
        repeatInterval: 'q4–6h pendant 5 jours max',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Octréotide',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mcg',
        fixedDose: '50 mcg bolus IV',
        route: 'IV puis IVSE 50 mcg/h',
        notes: 'Alternative à la terlipressine. Bolus 50 mcg puis 50 mcg/h IVSE pendant 5 jours.',
        canRepeat: false,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Ceftriaxone',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'g',
        fixedDose: '1–2 g/j IV',
        route: 'IV en 30 min',
        notes: 'Antibioprophylaxie systématique cirrhotique hospitalisé pour hémorragie. ATB curatif si infection (PBE, IU, pneumonie).',
        canRepeat: true,
        repeatInterval: 'Toutes les 24h pendant 5–7 jours',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Albumine Humaine 20%',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 1.0,
        doseUnit: 'g/kg',
        fixedDose: '1–1.5 g/kg/j IV',
        route: 'IV sur 4–6h',
        notes: 'SHR : 1 g/kg J1 + terlipressine. PBE : 1.5 g/kg J1 puis 1 g/kg J3. Ascite >5L : 8 g/L retiré.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'N-Acétylcystéine (NAC)',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 150.0,
        doseUnit: 'mg/kg',
        fixedDose: '150 mg/kg sur 1h',
        route: 'IV (protocole 3 sachets)',
        notes: 'SURDOSAGE PARACÉTAMOL uniquement. Protocole : 150 mg/kg/1h → 12.5 mg/kg/4h → 6.25 mg/kg/16h.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Lactulose',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: '30 ml q2–8h',
        route: 'PO / SNG ou lavement',
        notes: 'Cible 2–3 selles molles/j. Titrer la dose. Lavement 300 ml dans 700 ml eau si coma.',
        canRepeat: true,
        repeatInterval: 'Adapter pour 2–3 selles/j',
        isFirstLine: true,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  INSUFFISANCE SURRÉNALIENNE AIGUË — CRISE ADDISONIENNE
  //  Source : Endocrine Society Clinical Practice Guidelines 2016
  //  https://academic.oup.com/jcem/article/101/2/364/2810571
  //  SFAR Recommandations Corticothérapie en réanimation 2017
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'adrenal_insufficiency',
    title: 'Insuffisance Surrénalienne Aiguë',
    subtitle: 'Endocrine Society 2016 — Crise Addisonienne',
    emoji: '🦴',
    colorKey: 'blue',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître et traiter en urgence',
        detail: 'Clinique : hypotension profonde réfractaire + nausées/vomissements + douleur abdominale + confusion/coma. Terrain : corticothérapie chronique (arrêt brutal), maladie d\'Addison connue, stress aigu (chirurgie, infection, traumatisme). Prélever cortisol + ACTH AVANT le traitement mais NE PAS RETARDER l\'hydrocortisone.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Hydrocortisone IV — URGENCE VITALE',
        detail: 'Hydrocortisone 100 mg IV bolus IMMÉDIAT (ne pas attendre le bilan biologique). Puis hydrocortisone 200 mg/24h IVSE (ou 50 mg q6h IV) pendant 24–48h. À doses ≥100 mg/j, l\'hydrocortisone couvre l\'activité minéralocorticoïde — pas de fludrocortisone nécessaire en phase aiguë. Décroissance progressive sur 2–3 jours.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Remplissage vasculaire agressif',
        detail: 'NaCl 0.9% 1 L en 30–60 min (correction de l\'hypovolémie + hyponatrémie). Puis 1–2 L supplémentaires sur 4–6h selon la réponse. ÉVITER le Ringer Lactate (contient du potassium = hyperkaliémie déjà présente). Objectif : PAM ≥65 mmHg, diurèse ≥0.5 ml/kg/h.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Corriger l\'hypoglycémie',
        detail: 'Glycémie cible ≥0.7 g/L. Si glycémie <0.7 g/L : G50% 50 ml IV. Puis G10% IVSE de fond. Monitoring glycémique q1–2h les premières 24h. L\'hypoglycémie est fréquente (déficit en cortisol supprime la gluconéogenèse).',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Identifier et traiter le facteur déclenchant',
        detail: 'Infection : hémocultures + bilan infectieux + ATB large spectre si sepsis. Chirurgie ou traumatisme : "stress dose" d\'hydrocortisone. Arrêt brutal corticoïdes : reprendre et décroître progressivement. Déficit ACTH hypophysaire : bilan hypothalamo-hypophysaire (IRM, autres déficits).',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Éducation et prévention des récidives',
        detail: 'Carte d\'urgence médicale et bracelet d\'identification obligatoires. "Sick day rules" : doubler la dose d\'hydrocortisone PO si maladie intercurrente, tripler si vomissements ou fièvre >38.5°C, passer à l\'IV/IM si impossibilité PO. Stylo d\'urgence : Hydrocortisone 100 mg IM auto-injectable. Carte rédigée par endocrinologue.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Hydrocortisone',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'mg',
        fixedDose: '100 mg IV bolus',
        route: 'IV bolus puis IVSE',
        notes: 'URGENCE VITALE — administrer IMMÉDIATEMENT. Puis 200 mg/24h IVSE. Couvre activité minéralocorticoïde à ces doses.',
        canRepeat: true,
        repeatInterval: '50 mg q6h ou 200 mg/24h IVSE',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'NaCl 0.9%',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'ml',
        fixedDose: '1000 ml IV',
        route: 'IV rapide (30–60 min)',
        notes: 'Hypotension + déshydratation. Éviter Ringer Lactate (K⁺). Puis 1–2 L/6h selon réponse.',
        canRepeat: true,
        repeatInterval: 'Répéter selon réponse hémodynamique',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Glucose 50% (G50%)',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: '50 ml IV',
        route: 'IV lent',
        notes: 'Hypoglycémie <0.7 g/L. Puis G10% IVSE. Monitoring glycémique q1h.',
        canRepeat: true,
        repeatInterval: 'Si glycémie <0.7 g/L',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Fludrocortisone',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mcg',
        fixedDose: '100 mcg/j PO',
        route: 'Per Os (après stabilisation)',
        notes: 'Reprendre la minéralocorticothérapie quand dose hydrocortisone ≤50 mg/j (en dessous le remplacement MC n\'est plus assuré).',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  CHOC SEPTIQUE — SEPSIS-3
  //  Source : Surviving Sepsis Campaign Guidelines 2021
  //  https://www.sccm.org/SurvivingSepsisCampaign/Guidelines
  //  NEJM 2017 (SMART trial), NEJM 2014 (ARISE, ProCESS, ProMISe)
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'septic_shock',
    title: 'Choc Septique',
    subtitle: 'Surviving Sepsis 2021 — Sepsis-3 / Bundle 1h',
    emoji: '🦠',
    colorKey: 'orange',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Reconnaître — Critères Sepsis-3',
        detail: 'SEPSIS : infection présumée + dysfonction d\'organe (SOFA ≥2 points). CHOC SEPTIQUE : sepsis + vasopresseurs pour PAM ≥65 mmHg + lactates >2 mmol/L malgré remplissage. Score qSOFA bedside : FR ≥22, confusion, PAS ≤100 mmHg (≥2 critères = sepsis probable).',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Bundle 1h — Hémocultures et ATB < 1h',
        detail: '1. Hémocultures (2 paires aéro+anaéro) AVANT ATB si <45 min. 2. Procalcitonine, lactates, NFS, ionogramme, bilan rénal/hépatique. 3. ATB large spectre IV dans la 1ère heure (Piperacilline-Tazobactam 4.5 g IV + amikacine 25 mg/kg si sepsis sévère). Chaque heure de délai ATB ↑ mortalité de 7%.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Remplissage vasculaire guidé',
        detail: 'Cristalloïde balancé (Ringer Lactate ou PlasmaLyte) 30 ml/kg IV dans les 3h. RÉÉVALUER après chaque bolus de 250–500 ml (levée passive jambes, delta PP, VVP). Arrêter le remplissage si PAM ≥65, lactates <2 mmol/L, diurèse >0.5 ml/kg/h. SMART trial (NEJM 2018) : Ringer Lactate > NaCl 0.9%.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Vasopresseurs si PAM < 65 mmHg',
        detail: 'Noradrénaline en 1ère ligne (SCCM 2021) : 0.01–0.5 mcg/kg/min IVSE voie centrale. Objectif PAM ≥65 mmHg (≥80 si HTA chronique ou TCE). Vasopressine 0.03–0.04 U/min si noradrénaline ≥0.25 mcg/kg/min (épargne la noradrénaline). Dobutamine si bas débit cardiaque associé.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Contrôle de la source dans les 6–12h',
        detail: 'Identifier et contrôler le foyer infectieux : drainage abcès, ablation corps étranger infecté, laparotomie si péritonite, ablation cathéter central infecté. Chirurgie ou drainage interventionnel dans les 6–12h si identifié. Réévaluer et désescalader les ATB à 48–72h selon les cultures.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Corticothérapie et glycémie',
        detail: 'Hydrocortisone 200 mg/24h IVSE si noradrénaline ≥0.25 mcg/kg/min après remplissage (ADRENAL trial, APROCCHSS trial). Glycémie cible 1.4–1.8 g/L (insuline IV si >1.8 g/L). Éviter normoglycémie stricte (↑ hypoglycémies = ↑ mortalité — NICE-SUGAR trial, NEJM 2009).',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Noradrénaline',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.05,
        doseUnit: 'mcg/kg/min',
        fixedDose: '0.05–0.5 mcg/kg/min',
        route: 'IVSE voie centrale',
        notes: '1ÈRE LIGNE vasopresseur (SCCM 2021). Cible PAM ≥65 mmHg. Augmenter si PAM insuffisante.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Pipéracilline-Tazobactam',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '4.5 g IV q6h',
        route: 'IV en 3–4h (perfusion prolongée)',
        notes: 'ATB large spectre empirique. Perfusion prolongée (3–4h) améliore le temps au-dessus de la CMI. Ajuster selon cultures à 48–72h.',
        canRepeat: true,
        repeatInterval: 'q6h (ajuster selon DFG)',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Amikacine',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 25.0,
        doseUnit: 'mg/kg',
        fixedDose: '25–30 mg/kg/j IV',
        route: 'IV en 30 min (dose unique journalière)',
        notes: 'Dose unique journalière (pharmacodynamique concentration-dépendant). Surveiller taux résiduel J3 (<2.5 mg/L). Arrêter après 48–72h si pas de BGN résistant.',
        maxDose: 2000,
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Vasopressine',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'U/min',
        fixedDose: '0.03–0.04 U/min',
        route: 'IVSE voie centrale',
        notes: 'Adjuvant noradrénaline ≥0.25 mcg/kg/min. DOSE FIXE — ne pas dépasser 0.04 U/min.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Hydrocortisone',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'mg',
        fixedDose: '200 mg/24h IVSE',
        route: 'IVSE ou 50 mg q6h',
        notes: 'Si noradrénaline ≥0.25 mcg/kg/min persistant (ADRENAL 2018 + APROCCHSS 2018). Décroissance progressive.',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Dobutamine',
        urgency: EmergencyUrgency.urgent,
        dosePerKg: 5.0,
        doseUnit: 'mcg/kg/min',
        fixedDose: '2–20 mcg/kg/min',
        route: 'IVSE',
        notes: 'Si bas débit cardiaque associé (index cardiaque <2.2 L/min/m²). Associer à noradrénaline.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  ENCÉPHALOPATHIE HÉPATIQUE
  //  Source : EASL-AASLD Clinical Practice Guidelines 2014/2023
  //  https://www.journal-of-hepatology.eu
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'hepatic_encephalopathy',
    title: 'Encéphalopathie Hépatique',
    subtitle: 'EASL-AASLD 2023 — Trouble Neurologique d\'Origine Hépatique',
    emoji: '🧠',
    colorKey: 'orange',
    source: 'EASL-AASLD Guidelines 2023',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Classification de West Haven et évaluation',
        detail: 'Grade I : confusion légère, inversion sommeil. Grade II : léthargie, désorientation, astérixis. Grade III : somnolence marquée, confusion sévère mais réveillable. Grade IV : coma. Grade III–IV = urgence vitale (risque d\'inhalation, engagement cérébral si insuffisance hépatique aiguë). GCS, glycémie capillaire, ammoniémie (valeur indicative, pas de seuil diagnostique formel).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Protection des voies aériennes',
        detail: 'Grade III–IV avec GCS ≤8 ou réflexes de protection abolis → intubation orotrachéale systématique avant tout geste (risque majeur d\'inhalation). Position latérale de sécurité si grade II en attendant.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Identifier et traiter le facteur déclenchant',
        detail: 'Rechercher systématiquement : infection (PBS, pneumonie, ITU — ECBU, ponction d\'ascite, hémocultures), hémorragie digestive (toucher rectal, hématémèse), déshydratation/diurétiques excessifs, constipation, prise de sédatifs/opiacés, désordres électrolytiques (hyponatrémie, hypokaliémie), insuffisance rénale. Le traitement du facteur déclenchant est prioritaire sur le traitement symptomatique.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Lactulose — 1ère ligne',
        detail: 'Lactulose 20–30 g (30–45 ml) PO/SNG toutes les 1–2h jusqu\'à obtention de 2–3 selles molles/j, puis titrer pour maintenir ce rythme (généralement 15–30 ml x2–4/j). Lavement lactulose (300 ml dans 700 ml eau) si voie orale impossible ou grade III–IV. Objectif : réduction production/absorption d\'ammoniac par acidification colique.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Rifaximine en association',
        detail: 'Rifaximine 550 mg PO x2/j en association au lactulose si réponse insuffisante ou prévention des récidives. Réduit le risque de récidive et d\'hospitalisation (RCT NEJM 2010). Non recommandée en monothérapie de l\'épisode aigu.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Mesures associées',
        detail: 'Éviter la restriction protéique prolongée (aggrave le catabolisme — apport protéique 1.2–1.5 g/kg/j recommandé, végétal/laitier préférentiel). Correction des troubles électrolytiques. Arrêt des sédatifs et diurétiques en excès. Éviter les benzodiazépines (aggravent l\'encéphalopathie) — privilégier halopéridol si agitation sévère.',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Surveillance et évaluation du pronostic',
        detail: 'Réévaluation clinique q4–6h (grade de West Haven). Si insuffisance hépatique aiguë (pas de cirrhose sous-jacente) avec grade III–IV : contacter centre de transplantation hépatique en urgence, surveillance pression intracrânienne à discuter. Bilan hépatique complet, TP/INR, ammoniémie de suivi.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Lactulose',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: '20–30 g (30–45 ml) PO/SNG',
        route: 'PO/SNG ou lavement si grade III–IV',
        notes: 'q1–2h jusqu\'à 2–3 selles molles/j puis titrer. Lavement 300 ml/700 ml eau si voie orale impossible.',
        canRepeat: true,
        repeatInterval: 'q1–2h puis titration selon selles',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Rifaximine',
        urgency: EmergencyUrgency.moderate,
        doseUnit: 'mg',
        fixedDose: '550 mg PO x2/j',
        route: 'PO',
        notes: 'En association au lactulose. Prévention des récidives (NEJM 2010).',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Halopéridol',
        urgency: EmergencyUrgency.moderate,
        doseUnit: 'mg',
        fixedDose: '2.5–5 mg IM/IV',
        route: 'IM ou IV lent',
        notes: 'Si agitation sévère. Préférer aux benzodiazépines qui aggravent l\'encéphalopathie.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  CHOC CARDIOGÉNIQUE
  //  Source : ESC Acute and Advanced Heart Failure Guidelines 2021
  //  https://www.escardio.org/Guidelines
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'cardiogenic_shock',
    title: 'Choc Cardiogénique',
    subtitle: 'ESC 2021 — Défaillance de Pompe Cardiaque',
    emoji: '💔',
    colorKey: 'red',
    source: 'ESC Heart Failure Guidelines 2021',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Diagnostic et critères',
        detail: 'PAS <90 mmHg >30 min (ou support aminergique pour la maintenir) + signes d\'hypoperfusion : marbrures, extrémités froides, oligurie <0.5 ml/kg/h, confusion, lactates >2 mmol/L. Index cardiaque <2.2 L/min/m² si monitorage disponible. ECG, échocardiographie au lit immédiate (cause et fonction VG/VD).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Monitorage invasif',
        detail: 'Voie artérielle pour PA invasive continue. Voie veineuse centrale. Sonde urinaire (diurèse horaire). Échocardiographie répétée. Envisager cathéter artère pulmonaire ou monitorage débit cardiaque continu (PICCO) en réanimation.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Optimisation volémique prudente',
        detail: 'Remplissage prudent 200–250 ml cristalloïdes en 10–15 min UNIQUEMENT si absence de signes de surcharge (pas de crépitants, pas d\'OAP) — réévaluer après chaque bolus. Si signes de congestion : ne pas remplir, diurétiques si stable hémodynamiquement.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Support inotrope et vasopresseur',
        detail: 'Noradrénaline en 1ère ligne si PAM <65 mmHg (0.05–0.5 mcg/kg/min) — préférée à la dopamine (moins d\'arythmies, SOAP II trial). Dobutamine 2–20 mcg/kg/min associée si bas débit persistant malgré remplissage/vasopresseur. Éviter les fortes doses combinées prolongées — passer à l\'assistance mécanique si échec.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Traiter la cause',
        detail: 'SCA/IDM : revascularisation en urgence (angioplastie primaire <2h, discuter fibrinolyse si délai). Arythmie : cardioversion/antiarythmiques. Valvulopathie aiguë (rupture cordage, endocardite) : chirurgie urgente. Myocardite fulminante : discuter assistance circulatoire précoce.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Assistance circulatoire mécanique',
        detail: 'Si choc réfractaire malgré inotropes/vasopresseurs à doses optimisées : ECMO veino-artérielle, ballon de contre-pulsion intra-aortique, ou Impella selon disponibilité et centre. Discussion pluridisciplinaire précoce avec centre expert (avant défaillance multiviscérale installée).',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Surveillance et titration',
        detail: 'Lactates q2–4h (clairance = marqueur pronostique). Diurèse horaire. PAM cible ≥65 mmHg. Réévaluation échographique répétée. Éviter la surcharge iatrogène — bilan entrées/sorties strict.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Noradrénaline',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.05,
        doseUnit: 'mcg/kg/min',
        fixedDose: '0.05–0.5 mcg/kg/min',
        route: 'IVSE voie centrale',
        notes: '1ère ligne (SOAP II). Titrer pour PAM ≥65 mmHg. Voie centrale de préférence.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Dobutamine',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 5.0,
        doseUnit: 'mcg/kg/min',
        fixedDose: '2–20 mcg/kg/min',
        route: 'IVSE voie centrale',
        notes: 'Associée à noradrénaline si bas débit persistant. Risque tachyarythmies à fortes doses.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Cristalloïdes (test de remplissage)',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: '200–250 ml en 10–15 min',
        route: 'IV',
        notes: 'Uniquement si absence de signes de surcharge. Réévaluer après chaque bolus.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  CHOC HYPOVOLÉMIQUE
  //  Source : ATLS 10th Ed. 2018 ; ESAIC Peri-op Bleeding Guidelines 2023
  //  https://www.facs.org/quality-programs/trauma/atls/
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'hypovolemic_shock',
    title: 'Choc Hypovolémique',
    subtitle: 'ATLS 10th Ed. — Déplétion Volémique Sévère',
    emoji: '💧',
    colorKey: 'red',
    source: 'ATLS 10th Ed. 2018',
    evidenceLevel: EvidenceLevel.b,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Classification ATLS de la perte volémique',
        detail: 'Classe I (<15%) : FC normale. Classe II (15–30%) : tachycardie, tachypnée, PA pincée. Classe III (30–40%) : hypotension, confusion, oligurie. Classe IV (>40%) : PA imprenable, obnubilation, anurie — pré-arrêt. Identifier la cause : hémorragie (extériorisée/interne), pertes digestives (vomissements, diarrhées), brûlures, 3e secteur.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Accès vasculaire et bilan',
        detail: '2 voies veineuses périphériques de gros calibre (14–16G). Bilan : NFS, groupe/RAI, ionogramme, lactates, gazométrie. Si origine hémorragique suspectée → activer protocole transfusion massive (voir protocole Hémorragie).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Remplissage vasculaire initial',
        detail: 'Cristalloïdes isotoniques (Ringer lactate/NaCl 0.9%) 500 ml–1L en bolus rapide (<15 min), répéter selon réponse hémodynamique. Objectif transitoire : PAS 80–90 mmHg si origine hémorragique non contrôlée (hypotension permissive) ; PAM ≥65 mmHg si cause non hémorragique ou hémorragie contrôlée.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Contrôle de la source',
        detail: 'Hémorragie extériorisée : compression directe, garrot si membre. Hémorragie interne : imagerie ciblée (FAST écho, TDM si stable), chirurgie/radiologie interventionnelle en urgence si instable. Pertes digestives : traitement étiologique (antiémétiques, antidiarrhéiques selon cause).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Vasopresseurs si remplissage insuffisant',
        detail: 'Noradrénaline 0.05–0.5 mcg/kg/min si hypotension persistante malgré remplissage adéquat et contrôle de la source — ne jamais utiliser en 1ère intention pour masquer une hypovolémie non corrigée.',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Surveillance de la réponse',
        detail: 'Réévaluation continue : PA, FC, diurèse (cible >0.5 ml/kg/h), état de conscience, lactates (clairance à 2h = marqueur pronostique majeur), coloration cutanée. Répondeur transitoire ou non-répondeur = poursuite hémorragie active → escalade diagnostique/thérapeutique urgente.',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Prévenir la triade létale',
        detail: 'Réchauffement actif (couvertures chauffantes, perfusions réchauffées) — prévenir hypothermie. Correction acidose par contrôle de la source et perfusion adéquate (pas de bicarbonate systématique). Correction coagulopathie : transfusion précoce si hémorragie (voir protocole dédié), éviter dilution excessive par cristalloïdes.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Ringer Lactate',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'ml',
        fixedDose: '500 ml–1L bolus',
        route: 'IV rapide (<15 min)',
        notes: 'Cristalloïde de 1ère ligne. Répéter selon réponse. Éviter surcharge si origine non hémorragique.',
        canRepeat: true,
        repeatInterval: 'Selon réponse hémodynamique',
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
        notes: 'Uniquement après remplissage adéquat et contrôle de la source. Ne masque pas une hypovolémie non corrigée.',
        isFirstLine: false,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  DÉFAILLANCE MULTIVISCÉRALE (SDMV)
  //  Source : SCCM/ESICM MODS Consensus ; Surviving Sepsis Campaign 2021
  //  https://www.sccm.org/SurvivingSepsisCampaign
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'mods',
    title: 'Défaillance Multiviscérale',
    subtitle: 'SCCM/ESICM — Syndrome de Défaillance Multiviscérale (SDMV)',
    emoji: '⚠️',
    colorKey: 'red',
    source: 'SCCM/ESICM Consensus ; Surviving Sepsis Campaign 2021',
    evidenceLevel: EvidenceLevel.c,
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Identification et scoring',
        detail: 'Score SOFA (Sequential Organ Failure Assessment) : ≥2 points d\'aggravation = dysfonction organique. Évaluation systématique des 6 systèmes : respiratoire (PaO₂/FiO₂), cardiovasculaire (PAM/vasopresseurs), hépatique (bilirubine), coagulation (plaquettes), rénal (créatinine/diurèse), neurologique (GCS). Identifier la cause déclenchante (sepsis le plus fréquent, mais aussi polytraumatisme, pancréatite sévère, choc prolongé).',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Contrôle de la source et de la cause',
        detail: 'Priorité absolue : identifier et traiter la cause déclenchante (foyer infectieux à drainer, hémorragie à contrôler, ischémie à revasculariser). Sans contrôle de la cause, aucun support d\'organe ne permettra la récupération.',
        isCritical: true,
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Support hémodynamique',
        detail: 'Remplissage vasculaire guidé (cristalloïdes), objectif PAM ≥65 mmHg. Noradrénaline en 1ère ligne si hypotension persistante. Monitorage hémodynamique avancé (échocardiographie répétée, lactates) pour guider la thérapeutique et éviter la surcharge.',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Support respiratoire',
        detail: 'Oxygénothérapie/VNI/ventilation invasive selon sévérité (voir protocole SDRA si applicable). Ventilation protectrice systématique (VT 6 ml/kg PCI) en cas de ventilation mécanique — prévient l\'aggravation de la défaillance multiviscérale par lésion pulmonaire induite par le ventilateur.',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Support rénal',
        detail: 'Optimisation volémique et hémodynamique en 1ère intention (prévention). Épuration extra-rénale si critères : hyperkaliémie menaçante réfractaire, acidose métabolique sévère réfractaire, surcharge hydrosodée réfractaire aux diurétiques, urémie symptomatique, anurie prolongée. Éviter les néphrotoxiques (produits de contraste, AINS, aminosides si possible).',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Support hépatique et hématologique',
        detail: 'Pas de suppléance hépatique artificielle en routine (MARS/dialyse à l\'albumine réservée à des indications spécifiques en centre expert). Correction de la coagulopathie guidée par la clinique et biologie (transfusion plaquettaire/PFC seulement si saignement actif ou geste invasif prévu — pas de correction prophylactique systématique).',
      ),
      ProtocolStep(
        stepNumber: 7,
        title: 'Mesures transversales de réanimation',
        detail: 'Nutrition entérale précoce (<48h) si tolérée. Prévention thromboembolique et des ulcères de stress. Contrôle glycémique (cible 1.4–1.8 g/L, éviter hypoglycémie). Sédation minimale/analgésie adaptée, réveil quotidien si sous ventilation. Réévaluation quotidienne du SOFA pour suivre l\'évolution et guider le pronostic.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Noradrénaline',
        category: EmergencyCategory.vasopressors,
        urgency: EmergencyUrgency.critical,
        dosePerKg: 0.05,
        doseUnit: 'mcg/kg/min',
        fixedDose: '0.05–0.5 mcg/kg/min',
        route: 'IVSE voie centrale',
        notes: '1ère ligne si hypotension persistante malgré remplissage. Titrer pour PAM ≥65 mmHg.',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Cristalloïdes',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'ml',
        fixedDose: 'Guidé par la réponse hémodynamique',
        route: 'IV',
        notes: 'Remplissage titré — éviter la surcharge qui aggrave les défaillances d\'organes.',
        isFirstLine: true,
      ),
    ],
  ),
  // ══════════════════════════════════════════════════════════════
  //  CHOC HÉMORRAGIQUE
  //  Source : ATLS 10th Ed. 2018 + EAST Guidelines 2019
  //  https://www.facs.org/quality-programs/trauma/atls/
  //  https://www.east.org/education/practice-management-guidelines
  // ══════════════════════════════════════════════════════════════
  EmergencyProtocol(
    id: 'hemorrhagic_shock',
    title: 'Choc Hémorragique',
    subtitle: 'ATLS 10th Ed. / Damage Control Resuscitation',
    emoji: '🩸',
    colorKey: 'red',
    steps: [
      ProtocolStep(
        stepNumber: 1,
        title: 'Contrôle immédiat du saignement',
        detail: 'Compression directe prolongée (10 min minimum). Garrot tourniquet si extrémité : noter l\'heure de pose. Packing hémostatique (gaze imprégnée chitosane ou TXA) si plaie non compressible. Pelvi-binding si fracture du bassin. Hémostase chirurgicale en urgence si saignement interne.',
      ),
      ProtocolStep(
        stepNumber: 2,
        title: 'Accès vasculaire et bilan',
        detail: '2 voies périphériques ≥16G ou IO si impossible. Prélèvements : NFS, coagulation (TP, TCA, fibrinogène, TEG/ROTEM si disponible), groupe sanguin RAI, lactates. Bilan FAST écho si trauma abdominal.',
      ),
      ProtocolStep(
        stepNumber: 3,
        title: 'Acide Tranexamique < 3 heures',
        detail: 'TXA (Acide Tranexamique) 1 g IV en 10 min dès que possible. Puis 1 g IV sur 8h. EFFICACITÉ MAXIMALE si administré dans les 3h du traumatisme (CRASH-2 trial). Au-delà de 3h : possible effet délétère (ne pas administrer).',
      ),
      ProtocolStep(
        stepNumber: 4,
        title: 'Transfusion massive — Damage Control',
        detail: 'Ratio cible CGR : PFC : Plaquettes = 1:1:1 (PROPPR trial). Commander le protocole transfusion massive (PTM). Réchauffer TOUS les produits sanguins (perfuseur chauffant). Objectif Hb ≥7–8 g/dL (>8 si coronaropathie). Fibrinogène ≥1.5 g/L (sinon Clottafact 2–4 g IV).',
      ),
      ProtocolStep(
        stepNumber: 5,
        title: 'Hypotension permissive',
        detail: 'Cible PAS 80–90 mmHg (PAM 50–65 mmHg) JUSQU\'AU CONTRÔLE CHIRURGICAL du saignement. EXCEPTION : traumatisme crânien associé → PAM ≥80 mmHg obligatoire. Noradrénaline si vasoplégie persistante. Éviter surcharge hydrique (aggrave la coagulopathie de dilution).',
      ),
      ProtocolStep(
        stepNumber: 6,
        title: 'Prévenir la triade létale',
        detail: 'Hypothermie (T°<35°C) : couverture chauffante, réchauffer liquides IV. Acidose (pH<7.2) : bicarbonate si pH<7.1 + corriger la cause. Coagulopathie (fibrinogène<1.5 g/L) : fibrinogène IV, PFC, plaquettes. TEG/ROTEM guide la transfusion ciblée.',
      ),
    ],
    drugs: [
      EmergencyDrug(
        name: 'Acide Tranexamique (TXA)',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '1 g IV en 10 min',
        route: 'IV',
        notes: 'Administrer dans les 3h du traumatisme (CRASH-2 trial). Puis 1 g sur 8h. Delà 3h : ne pas donner.',
        canRepeat: false,
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'Fibrinogène (Clottafact)',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'g',
        fixedDose: '2–4 g IV',
        route: 'IV en 10–15 min',
        notes: 'Si fibrinogène <1.5 g/L (TEG/ROTEM ou dosage). Objectif fibrinogène >2 g/L.',
        canRepeat: true,
        repeatInterval: 'Si fibrinogène <1.5 g/L persistant',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'CGR (Culots Globulaires)',
        urgency: EmergencyUrgency.critical,
        doseUnit: 'unité',
        fixedDose: '2–4 unités IV',
        route: 'IV rapide',
        notes: 'Réchauffer impérativement. Ratio 1:1:1 avec PFC et plaquettes. Objectif Hb ≥7 g/dL.',
        canRepeat: true,
        repeatInterval: 'Selon Hb et saignement',
        isFirstLine: true,
      ),
      EmergencyDrug(
        name: 'PFC (Plasma Frais Congelé)',
        urgency: EmergencyUrgency.critical,
        dosePerKg: 10.0,
        doseUnit: 'ml/kg',
        fixedDose: '10–15 ml/kg IV',
        route: 'IV',
        notes: 'Ratio 1:1 avec CGR en PTM. Objectif TP>40%. Réchauffer avant administration.',
        canRepeat: true,
        repeatInterval: 'Si TP<40% persistant',
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
        notes: 'Vasoplégie réfractaire. Objectif PAM 50–65 mmHg (80 mmHg si TCE associé).',
        isFirstLine: false,
      ),
      EmergencyDrug(
        name: 'Gluconate de Calcium',
        urgency: EmergencyUrgency.urgent,
        doseUnit: 'g',
        fixedDose: '1–2 g IV',
        route: 'IV en 5 min',
        notes: 'Hypocalcémie par transfusion massive (chélation par citrate). Après 4+ CGR.',
        canRepeat: true,
        repeatInterval: 'q4 CGR ou si Ca²⁺ ionisé <1 mmol/L',
        isFirstLine: false,
      ),
    ],
  ),
];