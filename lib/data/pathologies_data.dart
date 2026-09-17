// ╔══════════════════════════════════════════════════════════════╗
//  lib/data/pathologies_data.dart
//  VERSION 4.0 — DONNÉES PATHOLOGIES UNIQUEMENT
//
//  ✅ CE FICHIER = seulement les Pathologie(...)
//  ✅ Les règles médicament → DANS drug_pathology_rules.dart
//
//  ─────────────────────────────────────────────────────────────
//  POUR AJOUTER UNE PATHOLOGIE :
//   1. Copier le bloc MODÈLE en bas du fichier
//   2. Remplir chaque champ
//   3. Ajouter les règles médicament dans drug_pathology_rules.dart
//  ─────────────────────────────────────────────────────────────
//
//  STRUCTURE DE CHAQUE PATHOLOGIE :
//  ┌─ id                : identifiant unique snake_case
//  ├─ nom               : nom affiché dans l'app
//  ├─ description       : texte court affiché sous le nom
//  ├─ categorie         : CategoriePathologie.xxx
//  ├─ alertes           : liste rouge ⚠️  — dangers immédiats
//  ├─ recommandations   : liste verte ✅  — agents préférés
//  ├─ consignes         : liste bleue 📋 — gestes pratiques
//  ├─ droguesFavorisees : IDs des médicaments privilégiés ⭐
//  ├─ contreIndications : IDs des médicaments contre-indiqués ❌
//  └─ dosesAjustees     : ajustements de dose ⚠️
//
//  CATÉGORIES DISPONIBLES :
//    neurologique · hepatique · renal · cardiovasculaire
//    respiratoire · metabolique · obstetrique · allergique
//    infectieux · autre
//
//  IDs MÉDICAMENTS DISPONIBLES :
//  ── Hypnotiques ──────────────────────────────────────────────
//    propofol · ketamine · midazolam · etomidate · thiopental
//    dexmedetomidine
//  ── Opioïdes ─────────────────────────────────────────────────
//    fentanyl · remifentanil · sufentanil · morphine
//    tramadol · paracetamol
//  ── AINS ─────────────────────────────────────────────────────
//    ketoprofene
//  ── Curares ──────────────────────────────────────────────────
//    rocuronium · succinylcholine · cisatracurium · atracurium
//    sugammadex · neostigmine
//  ── Vasopresseurs ────────────────────────────────────────────
//    noradrenaline · adrenaline · ephedrine · dobutamine
//  ── Antibiotiques ────────────────────────────────────────────
//    cefazolin · clindamycin · vancomycin · metronidazole
//  ── Divers ───────────────────────────────────────────────────
//    lidocaine · atropine · nacl_09 · ringer_lactate · albumin_20
// ╚══════════════════════════════════════════════════════════════╝

import '../models/pathologie.dart';

// ══════════════════════════════════════════════════════════════
//  LISTE DES PATHOLOGIES
// ══════════════════════════════════════════════════════════════

const List<Pathologie> pathologiesData = [

  // ╔══════════════════════════════════╗
  // ║       NEUROLOGIQUE               ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'hic',
    nom: 'Hypertension Intracrânienne (HIC)',
    description: 'PIC élevée — risque d\'engagement cérébral',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Kétamine ABSOLUMENT CONTRE-INDIQUÉE — augmente la PIC et le CMRO₂',
      'Éviter toute hypotension (PAM cible ≥80 mmHg) — risque ischémie cérébrale',
      'Éviter l\'hypercapnie — hyperventilation modérée (PaCO₂ 35–40 mmHg)',
      'Succinylcholine : augmentation transitoire PIC acceptable en SRI si estomac plein',
    ],
    recommandations: [
      'Propofol ou thiopental pour l\'induction — réduisent la PIC et le CMRO₂',
      'Fentanyl pour l\'analgésie — stable hémodynamiquement',
      'Rémifentanil en neurochirurgie — réveil rapide pour bilan neurologique',
      'Lidocaïne 1.5 mg/kg IV 90 sec avant intubation — atténue la montée PIC',
      'Position tête à 30° — drainage veineux cérébral',
    ],
    consignes: [
      'Maintenir PaCO₂ 35–40 mmHg (hyperventilation modérée)',
      'PAM cible ≥ 80 mmHg (pression de perfusion cérébrale ≥ 60 mmHg)',
      'Position tête à 30°, dans l\'axe, sans compression jugulaire',
      'Osmothérapie : mannitol 0.5–1 g/kg IV ou NaCl 3% si œdème cérébral',
      'Éviter PEEP élevée (↑PIC par ↑pression veineuse centrale)',
    ],
    droguesFavorisees: ['propofol', 'thiopental', 'fentanyl', 'remifentanil', 'rocuronium', 'mannitol_20', 'nacl_hypertonique_3'],
    contreIndications: ['ketamine'],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'succinylcholine',
        facteur: 1.0,
        note: 'Acceptable en SRI avec prémédication lidocaïne 1.5 mg/kg IV',
      ),
    ],
  ),

  Pathologie(
    id: 'epilepsie',
    nom: 'Épilepsie / État de Mal Épileptique',
    description: 'Crises récurrentes ou EME — risque de récidive peropératoire',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Étomidate : myoclonies importantes pouvant mimer des crises — éviter',
      'Kétamine : peut abaisser le seuil épileptique à doses sub-dissociatives',
      'Halogénés : peuvent favoriser activité épileptiforme (surtout sévoflurane)',
      'Antiépileptiques (phénytoïne, carbamazépine) : accélèrent métabolisme des curares et opioïdes',
    ],
    recommandations: [
      'Propofol : activité antiépileptique — 1ère ligne induction et EME réfractaire',
      'Midazolam : BZD de référence EME — 1ère ligne IV ou IM',
      'Thiopental : EME réfractaire aux BZD — avec monitoring EEG continu',
      'Continuer le traitement antiépileptique habituel le matin de la chirurgie',
    ],
    consignes: [
      'Continuer les antiépileptiques le matin (avec petite gorgée d\'eau)',
      'Monitoring EEG peropératoire en chirurgie neurologique ou EME',
      'Éviter les stimulations intenses sans analgésie adéquate',
      'Antiépileptiques IV disponibles : valproate 30 mg/kg, lévétiracétam 60 mg/kg',
    ],
    droguesFavorisees: ['propofol', 'midazolam', 'thiopental', 'fentanyl'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 1.3,
        note: 'Induction enzymatique par antiépileptiques — augmenter la dose de 30%',
      ),
      DoseAjustee(
        drugId: 'fentanyl',
        facteur: 1.2,
        note: 'Métabolisme accéléré par inducteurs CYP3A4 (carbamazépine, phénytoïne)',
      ),
    ],
  ),

  // ╔══════════════════════════════════╗
  // ║       HÉPATIQUE                  ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'insuffisance_hepatique',
    nom: 'Insuffisance Hépatique',
    description: 'Fonction hépatique altérée — modifications pharmacocinétiques majeures',
    categorie: CategoriePathologie.hepatique,
    alertes: [
      'Étomidate CONTRE-INDIQUÉ — accumulation et suppression surrénalienne aggravée',
      'Sufentanil CONTRE-INDIQUÉ — accumulation sévère et imprévisible',
      'Midazolam : sédation prolongée et imprévisible — durée x3 à x6 en cirrhose',
      'Morphine : accumulation M6G — sédation prolongée',
      'Rocuronium : durée d\'action prolongée (élimination biliaire)',
      'Coagulopathie fréquente — surveiller TP/INR avant tout geste invasif',
    ],
    recommandations: [
      'Propofol : métabolisme extra-hépatique — agent de choix en IHC',
      'Rémifentanil : dégradation par estérases — indépendant du foie',
      'Cisatracurium : dégradation de Hofmann — curare idéal en IHC',
      'Atracurium : alternative si cisatracurium indisponible',
      'Fentanyl : acceptable en IHC modérée avec titration',
    ],
    consignes: [
      'Monitorage TOF obligatoire — durée d\'action imprévisible des curares',
      'Éviter hypotension (PAM <65 mmHg) — risque syndrome hépato-rénal',
      'Surveiller la glycémie (hypoglycémie fréquente en IHC sévère)',
      'Correction coagulopathie avant chirurgie (FFP, vitamine K, fibrinogène)',
      'Réduire les doses de tous les médicaments à métabolisme hépatique',
    ],
    droguesFavorisees: ['propofol', 'remifentanil', 'cisatracurium', 'atracurium'],
    contreIndications: ['etomidate', 'sufentanil'],
    dosesAjustees: [
      DoseAjustee(drugId: 'midazolam',  facteur: 0.5, note: 'Réduire de 50% — t½ x3–6 en cirrhose'),
      DoseAjustee(drugId: 'morphine',   facteur: 0.5, note: 'Réduire de 50% — préférer fentanyl'),
      DoseAjustee(drugId: 'fentanyl',   facteur: 0.7, note: 'Réduire de 30% en IHC sévère'),
      DoseAjustee(drugId: 'rocuronium', facteur: 0.7, note: 'Réduire ou substituer par cisatracurium'),
    ],
  ),

  // ╔══════════════════════════════════╗
  // ║       RÉNAL                      ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'insuffisance_renale',
    nom: 'Insuffisance Rénale Chronique',
    description: 'DFG < 60 mL/min — risque d\'accumulation médicamenteuse',
    categorie: CategoriePathologie.renal,
    alertes: [
      'Morphine CONTRE-INDIQUÉE — accumulation M6G → dépression respiratoire prolongée',
      'Succinylcholine CONTRE-INDIQUÉE en IRC (hyperkaliémie chronique)',
      'Midazolam : métabolite actif s\'accumule si DFG<30',
      'Rocuronium : durée légèrement prolongée — monitorage TOF',
      'Antibiotiques (céfazoline, vancomycine) : adapter les doses au DFG',
      'Contrôler la kaliémie AVANT induction',
    ],
    recommandations: [
      'Propofol : métabolisme non rénal — sécurisé tous stades IRC',
      'Fentanyl : métabolites inactifs — opioïde de référence en IRC',
      'Rémifentanil : idéal — dégradation par estérases indépendante du rein',
      'Cisatracurium : dégradation de Hofmann — aucune accumulation même en anurie',
      'Rocuronium : acceptable avec monitoring TOF strict',
    ],
    consignes: [
      'Contrôler la kaliémie avant l\'induction — traiter si K⁺ >5.5 mEq/L',
      'Adapter les doses antibiotiques selon le DFG',
      'Monitorage TOF obligatoire pour les curares',
      'Surveiller la diurèse horaire et le bilan hydrique',
      'Éviter les AINS et les produits de contraste iodés (néphrotoxicité)',
    ],
    droguesFavorisees: ['propofol', 'fentanyl', 'remifentanil', 'cisatracurium'],
    contreIndications: ['morphine', 'succinylcholine'],
    dosesAjustees: [
      DoseAjustee(drugId: 'midazolam', facteur: 0.7, note: 'Réduire de 30% si DFG<30'),
      DoseAjustee(drugId: 'ketamine',  facteur: 0.7, note: 'Réduire de 30% en IRC sévère'),
      DoseAjustee(drugId: 'cefazolin', facteur: 0.5, note: 'Ajuster selon DFG — espacer les doses'),
    ],
  ),

  // ╔══════════════════════════════════╗
  // ║       CARDIOVASCULAIRE           ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'insuffisance_cardiaque',
    nom: 'Insuffisance Cardiaque',
    description: 'Réserve cardiaque réduite — risque d\'hypotension et de décompensation',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Thiopental CONTRE-INDIQUÉ — dépression myocardique directe sévère',
      'Propofol : hypotension sévère en IC — réduire la dose et titrer très lentement',
      'Risque de décompensation aiguë à l\'induction (stress hémodynamique)',
      'Dexmédétomidine : bradycardie et hypotension aggravées si FE très basse',
    ],
    recommandations: [
      'Étomidate : agent d\'induction le plus stable hémodynamiquement — 1ère ligne IC sévère',
      'Kétamine : stimulant cardiovasculaire — utile en IC avec instabilité',
      'Fentanyl : bien toléré hémodynamiquement — analgésie de référence',
      'Noradrénaline prête avant induction',
      'Réduire TOUTES les doses d\'induction de 30–50%',
    ],
    consignes: [
      'Vasopresseur (noradrénaline) prêt AVANT induction',
      'Réduire toutes les doses d\'induction de 30–50%',
      'Titrer très lentement les agents (bolus fractionnés)',
      'Monitorage invasif (PA sanglante, PVC si disponible)',
      'Cible PAM ≥65 mmHg — corriger immédiatement toute hypotension',
    ],
    droguesFavorisees: ['etomidate', 'ketamine', 'fentanyl', 'noradrenaline'],
    contreIndications: ['thiopental'],
    dosesAjustees: [
      DoseAjustee(drugId: 'propofol',        facteur: 0.5, note: 'Réduire de 50% max — titrer 0.5 mg/kg q30 sec'),
      DoseAjustee(drugId: 'midazolam',       facteur: 0.5, note: 'Réduire de 50%'),
      DoseAjustee(drugId: 'dexmedetomidine', facteur: 0.5, note: 'Éviter la charge — démarrer à 0.2 mcg/kg/h'),
    ],
  ),

  Pathologie(
    id: 'hypertension',
    nom: 'Hypertension Artérielle',
    description: 'HTA traitée ou non contrôlée — risque de poussée hypertensive peropératoire',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Kétamine CONTRE-INDIQUÉE en HTA non contrôlée — effet sympathomimétique (↑PA +15–25%)',
      'Éphédrine : risque de poussée hypertensive sévère — CI si PA non contrôlée',
      'Laryngoscopie et intubation : pic hypertensif fréquent — prétraiter systématiquement',
      'Arrêt brutal bêtabloquants/IEC avant chirurgie = risque rebond hypertensif',
    ],
    recommandations: [
      'Propofol : réduit la PA à l\'induction — agent de choix en HTA',
      'Fentanyl 2–3 mcg/kg IV avant laryngoscopie — atténue la réponse hypertensive',
      'Rémifentanil en TIVA : contrôle précis de la réponse au stress chirurgical',
      'Lidocaïne 1.5 mg/kg IV 90 sec avant intubation — réduit le pic tensionnel',
      'Dexmédétomidine : α2-agoniste — réduit le tonus sympathique',
      'Continuer les antihypertenseurs le matin de la chirurgie (sauf IEC/ARA2)',
    ],
    consignes: [
      'Objectif peropératoire : variation PA < ±20% de la PA de base du patient',
      'Continuer bêtabloquants et inhibiteurs calciques le matin',
      'IEC/ARA2 : arrêt 24h avant si possible (risque hypotension réfractaire)',
      'Monitoring invasif si PAS >180 mmHg ou chirurgie majeure',
      'Prétraitement avant laryngoscopie : fentanyl 2 mcg/kg + lidocaïne 1.5 mg/kg IV',
      'Poussée per-op : nicardipine 1–2 mg IV bolus ou urapidil 25 mg IV',
    ],
    droguesFavorisees: [
      'propofol', 'thiopental', 'fentanyl', 'remifentanil',
      'lidocaine', 'dexmedetomidine', 'rocuronium', 'cisatracurium',
    ],
    contreIndications: ['ketamine', 'ephedrine'],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'fentanyl',
        facteur: 1.2,
        note: 'Augmenter à 2–3 mcg/kg avant laryngoscopie pour atténuer le pic tensionnel',
      ),
      DoseAjustee(
        drugId: 'dexmedetomidine',
        facteur: 1.0,
        note: 'Éviter la dose de charge rapide (HTA paradoxale) — démarrer à 0.4–0.7 mcg/kg/h',
      ),
      DoseAjustee(
        drugId: 'noradrenaline',
        facteur: 0.5,
        note: 'Patient hypertendu répond plus fortement — doses réduites nécessaires',
      ),
    ],
  ),

  Pathologie(
    id: 'choc_hemorragique',
    nom: 'Choc Hémorragique',
    description: 'Instabilité hémodynamique sévère — hypovolémie critique',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Propofol ABSOLUMENT CONTRE-INDIQUÉ — collapsus cardiovasculaire fatal',
      'Thiopental ABSOLUMENT CONTRE-INDIQUÉ — dépression CV majeure',
      'Réduire toutes les doses d\'induction au minimum vital',
      'Risque d\'arrêt cardiaque à l\'induction si hypovolémie non corrigée',
    ],
    recommandations: [
      'Kétamine : seul agent d\'induction sûr en choc (stimulant CV) — 0.5–1 mg/kg',
      'Étomidate : alternative si kétamine CI — 0.1–0.2 mg/kg',
      'Remplissage vasculaire AVANT induction si possible (250–500 ml cristalloïde)',
      'Noradrénaline en vasopresseur dès la salle d\'urgence',
      'Acide tranexamique 1 g IV < 3h du traumatisme',
    ],
    consignes: [
      'Contrôle du saignement AVANT induction si possible (garrot, compression)',
      'Remplissage vasculaire rapide avant induction (Ringer Lactate)',
      'Transfusion massive en ratio 1:1:1 (CGR:PFC:Plaquettes)',
      'Objectif PAM ≥50–65 mmHg (hypotension permissive si pas de TCE)',
      'Cible hémoglobine ≥7–8 g/dL',
      'Éviter l\'hypothermie, l\'acidose, la coagulopathie (triade létale)',
    ],
    droguesFavorisees: ['ketamine', 'etomidate', 'noradrenaline', 'rocuronium', 'ringer_lactate'],
    contreIndications: ['propofol', 'thiopental'],
    dosesAjustees: [
      DoseAjustee(drugId: 'ketamine',  facteur: 0.5,  note: 'Réduire à 0.5–1 mg/kg IV (choc profond)'),
      DoseAjustee(drugId: 'etomidate', facteur: 0.5,  note: 'Réduire à 0.1–0.15 mg/kg IV'),
      DoseAjustee(drugId: 'midazolam', facteur: 0.25, note: 'Max 1 mg IV — seulement pour amnésie'),
    ],
  ),

  // ╔══════════════════════════════════╗
  // ║       RESPIRATOIRE               ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'asthme_bronchospasme',
    nom: 'Asthme / Bronchospasme',
    description: 'Hyperréactivité bronchique — risque de bronchospasme sévère peropératoire',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Morphine CONTRE-INDIQUÉE — histamino-libération → bronchospasme sévère',
      'Atracurium CONTRE-INDIQUÉ — histamino-libération importante',
      'Thiopental : laryngospasme et bronchospasme fréquents — éviter',
      'L\'intubation trachéale est le geste le plus à risque — toujours prémédiquer',
    ],
    recommandations: [
      'Kétamine : bronchodilatateur puissant — 1ère ligne pour SRI en crise d\'asthme',
      'Propofol : propriétés bronchodilatatrices — induction de choix hors SRI',
      'Rocuronium ou Cisatracurium : pas d\'histamino-libération — curares de choix',
      'Lidocaïne 1.5 mg/kg IV 3 min avant intubation — atténue le bronchospasme réflexe',
    ],
    consignes: [
      'Prémédication bronchodilatatrice : salbutamol 2.5 mg nébulisé',
      'Lidocaïne 1.5 mg/kg IV 3 min avant laryngoscopie',
      'Ventilation : I:E=1:3, débit inspiratoire élevé, fréquence basse 12–14/min',
      'PEEP minimale — risque de piégeage gazeux (auto-PEEP)',
      'Éviter intubation nasotrachéale (stimulation plus importante)',
    ],
    droguesFavorisees: ['ketamine', 'propofol', 'rocuronium', 'cisatracurium', 'lidocaine', 'salbutamol', 'ipratropium', 'dexamethasone'],
    contreIndications: ['morphine', 'atracurium'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'bpco',
    nom: 'BPCO',
    description: 'Obstruction chronique irréversible — risque de rétention CO₂ et sevrage difficile',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Morphine : dépression respiratoire prolongée — risque d\'hypercapnie décompensée',
      'Midazolam : dépression respiratoire — dose minimale',
      'Atracurium : histamino-libération modérée — préférer cisatracurium',
      'Risque de sevrage difficile du respirateur',
    ],
    recommandations: [
      'Dexmédétomidine : aucune dépression respiratoire — sédation idéale en BPCO',
      'Kétamine : maintient les réflexes des voies aériennes et bronchodilate',
      'Rémifentanil : contrôle précis — réveil rapide sans accumulation',
      'Cisatracurium : pas d\'histamino-libération — curare de choix',
    ],
    consignes: [
      'Ventilation : VT 6–8 ml/kg, FR 10–14/min, I:E = 1:2 à 1:3',
      'Surveiller l\'auto-PEEP (piégeage) — PEEP extérieure = 0 à commencer',
      'Extubation précoce (VNI postopératoire si critères)',
      'Critères d\'extubation stricts : VE <12 L/min, FR <25/min, P0.1 <4 cmH₂O',
      'Bronchodilatateurs en nébulisation pré et postopératoire',
    ],
    droguesFavorisees: ['dexmedetomidine', 'ketamine', 'remifentanil', 'cisatracurium', 'ipratropium', 'salbutamol'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(drugId: 'morphine',  facteur: 0.6, note: 'Réduire de 40% — surveiller SaO₂ et PaCO₂'),
      DoseAjustee(drugId: 'midazolam', facteur: 0.7, note: 'Dose minimale — surveiller la capnographie'),
    ],
  ),

  Pathologie(
    id: 'syndrome_obese',
    nom: 'Obésité Morbide (IMC ≥40)',
    description: 'Modifications pharmacocinétiques importantes — risque respiratoire élevé',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'SAS (syndrome d\'apnée du sommeil) associé fréquemment — risque obstruction',
      'Intubation difficile possible (score STOP-BANG, Mallampati)',
      'Désaturation rapide à l\'induction — préoxygénation en position assise OBLIGATOIRE',
      'SPIR plus fréquent avec propofol à dose non ajustée (accumulation lipidique)',
    ],
    recommandations: [
      'Calculer toutes les doses sur le poids corporel idéal (PCI) sauf exceptions',
      'Succinylcholine et rocuronium : dose sur poids réel',
      'Propofol induction : sur PCI — entretien : sur poids réel',
      'Prémédication anti-SAS : CPAP préopératoire si SAS connu',
    ],
    consignes: [
      'Préoxygénation en position assise (30–45°) — 8 resp CV ou 3 min O₂ 100%',
      'Position RAMPE pour laryngoscopie',
      'Toujours préparer un accès aux voies aériennes difficiles (vidéolaryngoscope)',
      'Extubation assise, réveil complet (TOF >0.9)',
    ],
    droguesFavorisees: ['propofol', 'remifentanil', 'rocuronium', 'sugammadex'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(drugId: 'propofol',   facteur: 0.8, note: 'Induction sur PCI. Entretien sur poids réel'),
      DoseAjustee(drugId: 'fentanyl',   facteur: 0.8, note: 'Sur poids corporel idéal (PCI)'),
      DoseAjustee(drugId: 'rocuronium', facteur: 1.0, note: 'Sur poids réel'),
    ],
  ),

  // ╔══════════════════════════════════╗
  // ║       MÉTABOLIQUE                ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'hyperkaliemie',
    nom: 'Hyperkaliémie',
    description: 'K⁺ élevé — risque d\'arrêt cardiaque lors de l\'induction',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Succinylcholine ABSOLUMENT CONTRE-INDIQUÉE — ↑K⁺ 0.5–1 mEq/L → arrêt cardiaque',
      'ECG avant induction obligatoire (onde T pointue, QRS large = risque immédiat)',
      'K⁺ > 6.5 mEq/L avec anomalies ECG = URGENCE — traiter avant chirurgie élective',
    ],
    recommandations: [
      'Rocuronium ou Cisatracurium uniquement — pas d\'effet sur K⁺',
      'Gluconate de Calcium 1 g IV si anomalies ECG — protection membranaire',
      'Insuline 10U + G30% 100 ml IV — ↓K⁺ de 0.5–1 mEq/L en 30 min',
      'ECG en continu pendant l\'induction',
    ],
    consignes: [
      'Contrôler la kaliémie < 6 mEq/L avant chirurgie élective',
      'ECG monitorage continu pendant toute l\'induction',
      'Calcium IV prêt (1 g gluconate de calcium)',
      'Défibrillateur disponible en salle',
      'Corriger l\'acidose métabolique associée',
    ],
    droguesFavorisees: ['rocuronium', 'cisatracurium', 'propofol', 'fentanyl', 'bicarbonate_84', 'nacl_09', 'insuline_rapide', 'salbutamol'],
    contreIndications: ['succinylcholine', 'ringer_lactate'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'porphyrie',
    nom: 'Porphyrie Aiguë',
    description: 'Maladie enzymatique rare — certains agents déclenchent des crises potentiellement mortelles',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Thiopental CONTRE-INDICATION ABSOLUE — déclenche crise aiguë potentiellement fatale',
      'Midazolam NON SÛR — inducteur CYP hépatique',
      'Consulter la base Porphyria South Africa (PASA) avant TOUT médicament',
      'Porter un bracelet médical — informer tous les soignants',
    ],
    recommandations: [
      'Propofol : agent d\'induction de choix — sûr dans la majorité des porphyries',
      'Fentanyl et rémifentanil : opioïdes de référence — considérés sûrs',
      'Rocuronium et succinylcholine : considérés sûrs',
      'Consulter la liste PASA (pasa.org.za) pour chaque médicament',
    ],
    consignes: [
      'Consulter impérativement la liste PASA avant tout agent anesthésique',
      'Éviter le jeûne prolongé — perfusion glucose IV continue (G10%)',
      'Surveiller les urines (coloration rouge-brun = crise en cours)',
      'Hémine IV disponible (traitement de la crise aiguë)',
    ],
    droguesFavorisees: ['propofol', 'fentanyl', 'remifentanil', 'rocuronium', 'succinylcholine'],
    contreIndications: ['thiopental', 'midazolam'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'diabete',
    nom: 'Diabète',
    description: 'Diabète type 1 ou type 2 — déséquilibre glycémique peropératoire, risque infectieux augmenté',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Kétamine et adrénaline : hyperglycémie dose-dépendante — surveiller',
      'Halogénés : inhibent la sécrétion d\'insuline — légère hyperglycémie',
      'Cible glycémique peropératoire : 1.4–1.8 g/L (pas de normoglycémie stricte)',
    ],
    recommandations: [
      'Propofol : pas d\'effet sur la glycémie — préférable',
      'Dexmédétomidine : réduction du stress chirurgical — améliore le contrôle glycémique',
      'Continuer insuline basale le matin (50–80% de la dose)',
      'Monitoring glycémique horaire peropératoire',
    ],
    consignes: [
      'Glycémie cible peropératoire : 1.4–1.8 g/L',
      'Mesure glycémique : avant induction, puis toutes les heures',
      'Insuline IV si glycémie > 1.8 g/L (protocole hospitalier)',
      'G10% IV si glycémie < 0.8 g/L',
      'Metformine à arrêter 48h avant si IRC associée',
    ],
    droguesFavorisees: ['propofol', 'dexmedetomidine', 'fentanyl', 'insuline_rapide'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       OBSTÉTRIQUE                ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'grossesse',
    nom: 'Grossesse',
    description: 'Modifications pharmacocinétiques et risque fœtal — estomac plein après 14 SA',
    categorie: CategoriePathologie.obstetrique,
    alertes: [
      'Estomac plein systématique après 14–16 SA — SRI OBLIGATOIRE pour AG',
      'AINS (kétoprofène) CONTRE-INDIQUÉS au 3ème trimestre — fermeture canal artériel',
      'Décubitus latéral gauche obligatoire après 20 SA (compression cave)',
      'Désaturation rapide (demi-vie O₂ 3–4 min) — préoxygénation prolongée',
    ],
    recommandations: [
      'SRI : succinylcholine 1.5 mg/kg ou rocuronium 1.2 mg/kg + sugammadex disponible',
      'Propofol : induction de référence en AG obstétricale',
      'Pression cricoïde (Sellick) pendant la laryngoscopie',
      'Naloxone néonatale (0.01 mg/kg IM) disponible si opioïdes proches de l\'extraction',
    ],
    consignes: [
      'Préoxygénation optimale : 3 min O₂ 100% ou 8 respirations CV',
      'Position : décubitus dorsal + coin sous fesse droite (15°) après 20 SA',
      'Antiacide H2 ou IPP la veille et le matin de la chirurgie',
      'Éviter hypotension maternelle (< 90 mmHg PAS) — ischémie utéro-placentaire',
    ],
    droguesFavorisees: ['succinylcholine', 'propofol', 'rocuronium'],
    contreIndications: ['ketoprofene'],
    dosesAjustees: [
      DoseAjustee(drugId: 'fentanyl', facteur: 0.8, note: 'Réduire — naloxone néonatale prête'),
      DoseAjustee(drugId: 'ketamine', facteur: 0.6, note: 'Max 0.5–1 mg/kg — tonus utérin possible à forte dose'),
      DoseAjustee(drugId: 'propofol', facteur: 0.9, note: 'Légèrement réduit — passage placentaire'),
    ],
  ),

  // ╔══════════════════════════════════╗
  // ║       ALLERGIQUE                 ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'allergie_oeuf_soja',
    nom: 'Allergie Œuf / Soja',
    description: 'Propofol contre-indiqué — risque d\'anaphylaxie sévère',
    categorie: CategoriePathologie.allergique,
    alertes: [
      'Propofol ABSOLUMENT CONTRE-INDIQUÉ — lécithine d\'œuf + huile de soja',
      'Consulter le bilan allergologique complet avant toute anesthésie',
      'Certaines préparations de soja (lipides IV) aussi concernées',
    ],
    recommandations: [
      'Étomidate : alternative de 1ère ligne — pas de lécithine ni de soja',
      'Thiopental : alternative si étomidate indisponible',
      'Kétamine : alternative valide',
      'Adrénaline et matériel de réanimation disponibles AVANT induction',
    ],
    consignes: [
      'Déclarer l\'allergie dans le dossier et au bracelet d\'identification',
      'Adrénaline 0.5 mg IM et corticoïdes disponibles immédiatement',
      'Éviter les lipides IV à base de soja (nutrition parentérale)',
      'Test cutané préopératoire si doute sur le type d\'allergie',
    ],
    droguesFavorisees: ['etomidate', 'thiopental', 'ketamine', 'fentanyl'],
    contreIndications: ['propofol'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'allergie_penicilline',
    nom: 'Allergie aux Pénicillines',
    description: 'Prophylaxie chirurgicale adaptée — céfazoline selon type d\'allergie',
    categorie: CategoriePathologie.allergique,
    alertes: [
      'Céfazoline : CI si anaphylaxie pénicilline — allergie croisée <1%',
      'Documenter le TYPE d\'allergie (rash bénin vs anaphylaxie) dans le dossier',
    ],
    recommandations: [
      'Clindamycine 900 mg IV : prophylaxie alternative validée',
      'Vancomycine 15 mg/kg IV : alternative si risque SARM',
      'Céfazoline acceptable si allergie pénicilline mineure (rash simple)',
    ],
    consignes: [
      'Préciser le type d\'allergie dans le dossier préopératoire',
      'Bilan allergologique si allergie pénicilline ancienne ou douteuse',
    ],
    droguesFavorisees: ['clindamycin', 'vancomycin'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'cefazolin',
        facteur: 1.0,
        note: 'CI si anaphylaxie pénicilline — acceptable si allergie mineure (rash)',
      ),
    ],
  ),

  Pathologie(
    id: 'allergie_latex',
    nom: 'Allergie au Latex',
    description: 'Réaction croisée avec certains aliments — environnement latex-free obligatoire',
    categorie: CategoriePathologie.allergique,
    alertes: [
      'ENVIRONNEMENT LATEX-FREE OBLIGATOIRE — 1ère chirurgie de la journée si possible',
      'Réactions croisées alimentaires : avocat, banane, kiwi, châtaigne',
      'Adrénaline disponible en salle AVANT induction',
      'Informer TOUT le personnel de la salle d\'opération',
    ],
    recommandations: [
      'Matériel latex-free certifié (gants, sondes, masques)',
      'Prémédication antiallergique discutée (données insuffisantes)',
      'Adrénaline 0.5 mg IM prête dès l\'entrée du patient en salle',
    ],
    consignes: [
      'Mentionner l\'allergie sur le bracelet patient et le dossier',
      'Vérifier que tout le matériel est latex-free (y compris bouchons de flacons)',
      'Informer la SSPI et l\'unité de soins postopératoire',
      'Patient programmé en 1ère position si possible',
    ],
    droguesFavorisees: ['propofol', 'fentanyl', 'rocuronium', 'cisatracurium'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       CARDIOVASCULAIRE (AJOUTS)  ║
  // ╚══════════════════════════════════╝
  //  NOTE : Hypertension Artérielle ('hypertension') et Insuffisance
  //  Cardiaque ('insuffisance_cardiaque') existent déjà plus haut —
  //  non dupliquées ici.

  Pathologie(
    id: 'sca_infarctus',
    nom: 'Syndrome Coronarien Aigu (Infarctus)',
    description: 'Ischémie myocardique aiguë — risque de réinfarcissement périopératoire',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Chirurgie élective contre-indiquée <60 jours après un IDM — risque de réinfarcissement [ESC 2022]',
      'Arrêt prématuré de la bithérapie antiplaquettaire — risque de thrombose de stent [ESC 2022]',
      'Kétamine : prudence — effet sympathomimétique augmente la consommation myocardique en O₂',
      'Éviter tachycardie et hypotension — déséquilibre de la balance apport/demande en O₂ myocardique',
    ],
    recommandations: [
      'Étomidate pour l\'induction — stabilité hémodynamique maximale [M9]',
      'Sufentanil ou fentanyl à dose adaptée — émousse la réponse sympathique à l\'intubation',
      'Esmolol ou labétalol titrés — contrôle de la fréquence cardiaque peropératoire',
      'Maintenir bêta-bloquant et statine en périopératoire (ne pas interrompre)',
    ],
    consignes: [
      'ECG 12 dérivations et troponine préopératoires systématiques',
      'Concertation cardiologue/chirurgien sur le délai chirurgie-stent [ESC 2022]',
      'Monitorage ECG continu dérivation V5 peropératoire',
      'Troponine de contrôle à J1-J2 postopératoire si chirurgie à risque intermédiaire/élevé',
    ],
    droguesFavorisees: ['etomidate', 'sufentanil', 'fentanyl', 'esmolol', 'labetalol'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'ketamine',
        facteur: 0.5,
        note: 'Limiter la dose — effet sympathomimétique majore le travail myocardique [M9]',
      ),
    ],
  ),

  Pathologie(
    id: 'angor_stable',
    nom: 'Angor Stable',
    description: 'Coronaropathie stable — ischémie déclenchée par l\'effort ou le stress',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Tachycardie peropératoire mal tolérée — raccourcit le temps de perfusion coronaire diastolique',
      'Hypotension prolongée : risque d\'ischémie sous-endocardique',
      'Éviter les variations tensionnelles brutales — maintenir la PAM ±20% de la valeur de base',
    ],
    recommandations: [
      'Poursuite des dérivés nitrés et bêta-bloquants jusqu\'au matin de la chirurgie',
      'Anesthésie stable : étomidate ou propofol titré à l\'induction',
      'Nitroglycérine disponible en cas d\'épisode angineux peropératoire',
    ],
    consignes: [
      'ECG préopératoire et évaluation de la classe fonctionnelle (CCS)',
      'Trinitrine sublinguale/IV disponible en salle',
      'Surveillance du segment ST peropératoire si monitorage disponible',
    ],
    droguesFavorisees: ['etomidate', 'propofol', 'fentanyl', 'nitroglycerine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'fibrillation_auriculaire',
    nom: 'Fibrillation Auriculaire',
    description: 'Arythmie supraventriculaire — risque de dégradation hémodynamique si cadence rapide',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Risque de dégradation hémodynamique si cadence ventriculaire rapide non contrôlée',
      'Anticoagulation orale (AVK/AOD) souvent en cours — évaluer le relais périopératoire',
      'Cardioversion électrique à considérer si instabilité hémodynamique aiguë',
    ],
    recommandations: [
      'Esmolol IV titré pour ralentir la cadence ventriculaire en peropératoire',
      'Digoxine ou amiodarone poursuivies si traitement de fond',
      'Éviter les agents à fort potentiel proarythmogène à forte dose',
    ],
    consignes: [
      'Vérifier le dernier INR ou la dernière prise d\'anticoagulant oral direct',
      'Monitorage ECG continu — fréquence cardiaque cible <110/min',
      'Normaliser kaliémie et magnésémie avant l\'induction',
    ],
    droguesFavorisees: ['etomidate', 'fentanyl', 'esmolol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'tachycardie_supraventriculaire',
    nom: 'Tachycardie Supraventriculaire',
    description: 'Trouble du rythme paroxystique — souvent déclenché par douleur ou hypovolémie',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Kétamine : effet sympathomimétique peut précipiter une récidive de tachycardie',
      'Atropine : effet vagolytique tachycardisant — à éviter en dehors d\'une bradycardie symptomatique',
      'Douleur et hypovolémie sont des facteurs déclenchants à corriger en priorité',
    ],
    recommandations: [
      'Analgésie profonde et normovolémie — préviennent la récidive',
      'Manœuvres vagales en 1ère intention si épisode aigu peropératoire',
      'Esmolol pour contrôle de fréquence si échec des manœuvres vagales',
    ],
    consignes: [
      'Maintenir normovolémie et analgésie adéquate en peropératoire',
      'ECG 12 dérivations préopératoire pour caractériser le trouble du rythme',
      'Défibrillateur/cardioverteur disponible en salle',
    ],
    droguesFavorisees: ['fentanyl', 'esmolol'],
    contreIndications: ['atropine'],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'ketamine',
        facteur: 0.5,
        note: 'Limiter la dose — risque de précipiter une récidive de tachycardie',
      ),
    ],
  ),

  Pathologie(
    id: 'bradycardie',
    nom: 'Bradycardie',
    description: 'Fréquence cardiaque basse — souvent iatrogène ou sur trouble conductif',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Halogénés et opioïdes à forte dose majorent la bradycardie',
      'Succinylcholine : risque de bradycardie sévère, surtout en cas de réinjection ou chez l\'enfant',
      'Bêta-bloquants et digoxine de fond majorent le risque peropératoire',
    ],
    recommandations: [
      'Atropine ou éphédrine disponibles en cas de bradycardie symptomatique',
      'Kétamine : effet chronotrope positif peut être utile en cas de bradycardie à l\'induction',
      'Pacing externe disponible si bloc auriculo-ventriculaire de haut degré connu',
    ],
    consignes: [
      'ECG préopératoire — rechercher un bloc auriculo-ventriculaire de haut degré',
      'Électrodes de stimulation externe posées si bradycardie symptomatique connue',
      'Prudence lors des stimulations vagales (laryngoscopie, traction péritonéale)',
    ],
    droguesFavorisees: ['ketamine', 'atropine', 'ephedrine', 'glycopyrrolate'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'succinylcholine',
        facteur: 1.0,
        note: 'Prémédication par atropine à discuter avant réinjection — risque de bradycardie sévère [M9]',
      ),
    ],
  ),

  Pathologie(
    id: 'avc_ischemique',
    nom: 'AVC Ischémique',
    description: 'Autorégulation cérébrale altérée en zone de pénombre — éviter toute hypotension',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Autorégulation cérébrale altérée en zone de pénombre — éviter toute hypotension [M9 §14]',
      'Succinylcholine : risque d\'hyperkaliémie si déficit moteur >24-72h — préférer un curare non dépolarisant',
      'Hyperglycémie et hyperthermie aggravent les lésions ischémiques — à corriger',
    ],
    recommandations: [
      'Maintenir la PAM dans les valeurs hautes de la normale (éviter toute chute)',
      'Propofol ou étomidate pour l\'induction — stabilité hémodynamique',
      'Normocapnie stricte (PaCO₂ 35–40 mmHg) et normoglycémie',
    ],
    consignes: [
      'PAM cible individualisée — éviter toute baisse >20% de la valeur de base',
      'Glycémie capillaire répétée — cible 140–180 mg/dL',
      'Rocuronium préféré à la succinylcholine si délai >24h post-AVC',
    ],
    droguesFavorisees: ['propofol', 'etomidate', 'fentanyl', 'rocuronium'],
    contreIndications: ['succinylcholine'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'avc_hemorragique',
    nom: 'AVC Hémorragique',
    description: 'Hémorragie intracrânienne — contrôle tensionnel strict, risque de resaignement',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Contrôle tensionnel strict — PAS cible <140 mmHg en phase aiguë [AHA/ASA]',
      'Kétamine contre-indiquée — risque d\'augmentation de la PIC et de resaignement',
      'Coagulopathie ou anticoagulants à corriger avant tout geste invasif',
    ],
    recommandations: [
      'Propofol ou thiopental pour l\'induction — réduisent la PIC et permettent un contrôle fin de la PAM',
      'Labétalol ou nicardipine IV pour le contrôle tensionnel peropératoire',
      'Rémifentanil — titration fine, réveil rapide pour évaluation neurologique',
    ],
    consignes: [
      'PAS cible <140 mmHg (ou selon protocole neurochirurgical local)',
      'Bilan de coagulation et réversion des anticoagulants avant craniotomie',
      'Osmothérapie disponible (mannitol, NaCl 3%) si signes d\'engagement',
    ],
    droguesFavorisees: ['propofol', 'thiopental', 'remifentanil', 'nicardipine', 'labetalol', 'mannitol_20', 'nacl_hypertonique_3'],
    contreIndications: ['ketamine'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'aomi',
    nom: 'Artériopathie Oblitérante des Membres Inférieurs',
    description: 'Athérosclérose périphérique — comorbidités cardiovasculaires fréquemment associées',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Athérosclérose diffuse fréquente — rechercher une coronaropathie et une sténose carotidienne associées',
      'Hypotension peropératoire mal tolérée — risque d\'ischémie distale et de thrombose de pontage',
      'Terrain tabagique et diabétique fréquent — comorbidités à évaluer',
    ],
    recommandations: [
      'Maintenir une PAM stable, proche des valeurs de base du patient',
      'Anesthésie locorégionale à privilégier si chirurgie vasculaire périphérique (selon protocole)',
      'Poursuite de l\'antiagrégant plaquettaire en périopératoire sauf avis chirurgical contraire',
    ],
    consignes: [
      'Bilan cardiovasculaire préopératoire complet (ECG, échographie cardiaque si signes d\'appel) [ESC 2022]',
      'Éviter les points de compression prolongés (protection des zones à risque ischémique)',
      'Surveillance des pouls distaux en post-opératoire',
    ],
    droguesFavorisees: ['etomidate', 'fentanyl'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       PNEUMOLOGIE (AJOUTS)       ║
  // ╚══════════════════════════════════╝
  //  NOTE : Asthme/Bronchospasme ('asthme_bronchospasme') et BPCO ('bpco')
  //  existent déjà plus haut — "Exacerbation d'asthme" couverte par
  //  'asthme_bronchospasme' (même prise en charge anesthésique) — non dupliquées.

  Pathologie(
    id: 'pneumonie_communautaire',
    nom: 'Pneumonie Communautaire',
    description: 'Infection pulmonaire aiguë — risque de désaturation et de sepsis périopératoire',
    categorie: CategoriePathologie.infectieuxRespiratoire,
    alertes: [
      'Hypoxémie et risque de sepsis — évaluer la gravité (score CURB-65/PSI) avant l\'anesthésie',
      'Report de la chirurgie élective recommandé jusqu\'à résolution clinique si possible',
      'Risque majoré de désaturation et de bronchospasme peropératoires',
    ],
    recommandations: [
      'Optimisation respiratoire préopératoire (kinésithérapie, oxygénothérapie)',
      'Anesthésie locorégionale à privilégier si possible — évite la ventilation mécanique',
      'Antibiothérapie adaptée poursuivie en périopératoire',
    ],
    consignes: [
      'Radiographie thoracique et bilan infectieux (CRP, PCT) préopératoires',
      'SpO2 cible ≥94% — oxygénothérapie disponible',
      'Surveillance postopératoire rapprochée (risque de détresse respiratoire)',
    ],
    droguesFavorisees: ['propofol', 'fentanyl'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'tuberculose_pulmonaire',
    nom: 'Tuberculose Pulmonaire',
    description: 'Infection mycobactérienne — risque de transmission et interactions médicamenteuses',
    categorie: CategoriePathologie.infectieuxRespiratoire,
    alertes: [
      'Risque de transmission — précautions air (masque FFP2, salle à pression négative si possible)',
      'Interactions médicamenteuses avec la rifampicine — inducteur enzymatique puissant',
      'Atteinte pulmonaire séquellaire possible — évaluer la fonction respiratoire',
    ],
    recommandations: [
      'Poursuivre le traitement antituberculeux le matin de la chirurgie',
      'Programmer en fin de programme opératoire si tuberculose active',
      'Adapter les doses des agents métabolisés par le CYP450 (rifampicine inductrice)',
    ],
    consignes: [
      'Vérifier le statut contagieux (BK crachats) avant chirurgie élective',
      'Masque FFP2 pour toute l\'équipe si tuberculose active/bacillifère',
      'Bilan hépatique (hépatotoxicité des antituberculeux)',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 1.3,
        note: 'Induction enzymatique par la rifampicine — augmenter la dose de 30%',
      ),
      DoseAjustee(
        drugId: 'fentanyl',
        facteur: 1.2,
        note: 'Métabolisme accéléré par la rifampicine (inducteur CYP3A4)',
      ),
    ],
  ),

  Pathologie(
    id: 'bronchite_aigue',
    nom: 'Bronchite Aiguë',
    description: 'Inflammation bronchique transitoire — hyperréactivité des voies aériennes',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Hyperréactivité bronchique transitoire — risque de bronchospasme peropératoire majoré',
      'Toux productive — risque de laryngospasme à l\'induction ou à l\'extubation',
    ],
    recommandations: [
      'Reporter la chirurgie élective si possible jusqu\'à résolution des symptômes (2-3 semaines)',
      'Propofol préféré — effet bronchodilatateur relatif',
      'Éviter la manipulation des voies aériennes en cas d\'hyperréactivité marquée',
    ],
    consignes: [
      'Auscultation pulmonaire préopératoire',
      'Bronchodilatateurs disponibles en salle',
      'Extubation en anesthésie profonde ou réveil complet — éviter le stade intermédiaire',
    ],
    droguesFavorisees: ['propofol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'bronchiolite',
    nom: 'Bronchiolite',
    description: 'Infection virale des voies aériennes basses du nourrisson — risque de désaturation',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Nourrisson à haut risque de désaturation et d\'apnée périopératoire',
      'Hyperréactivité bronchique — risque de bronchospasme et de laryngospasme',
      'Reporter toute chirurgie élective en phase aiguë',
    ],
    recommandations: [
      'Kétamine : effet bronchodilatateur, intéressant si bronchospasme associé',
      'Sévoflurane pour l\'induction — bien toléré chez le nourrisson',
      'Surveillance SpO2 continue peropératoire et postopératoire prolongée',
    ],
    consignes: [
      'Reporter la chirurgie élective jusqu\'à guérison clinique (2-4 semaines)',
      'Monitorage apnées/SpO2 en SSPI prolongé chez le nourrisson à risque',
      'Aspiration des sécrétions disponible',
    ],
    droguesFavorisees: ['ketamine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'embolie_pulmonaire',
    nom: 'Embolie Pulmonaire',
    description: 'Obstruction vasculaire pulmonaire — risque de choc obstructif et d\'arrêt cardiaque',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Risque de choc obstructif et d\'arrêt cardiaque si embolie massive',
      'Anticoagulation curative en cours — risque hémorragique à évaluer avant tout geste invasif',
      'Éviter toute manœuvre augmentant les résistances vasculaires pulmonaires (hypoxie, hypercapnie, acidose)',
    ],
    recommandations: [
      'Noradrénaline en 1ère ligne si choc — maintient la perfusion coronaire du ventricule droit',
      'Étomidate pour l\'induction si instabilité hémodynamique — stabilité maximale',
      'Éviter le protoxyde d\'azote — majore les résistances vasculaires pulmonaires',
    ],
    consignes: [
      'Angioscanner thoracique ou échographie cardiaque — évaluer le retentissement sur le VD',
      'Discuter thrombolyse ou embolectomie en cas d\'instabilité hémodynamique',
      'Éviter l\'hypoxie, l\'hypercapnie et l\'acidose — majorent les résistances vasculaires pulmonaires',
    ],
    droguesFavorisees: ['etomidate', 'noradrenaline', 'epoprostenol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'pneumothorax',
    nom: 'Pneumothorax',
    description: 'Épanchement gazeux pleural — risque de compression si non drainé',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Protoxyde d\'azote formellement contre-indiqué — risque d\'expansion et de pneumothorax compressif',
      'Ventilation en pression positive à risque avant drainage — surveiller un pneumothorax compressif',
      'Drainage thoracique préalable recommandé avant toute anesthésie générale si pneumothorax non drainé',
    ],
    recommandations: [
      'Drainage thoracique avant l\'induction si pneumothorax significatif ou sous tension',
      'Ventilation à basse pression, éviter la PEEP élevée avant drainage',
      'Anesthésie locorégionale à privilégier si seul un drainage est nécessaire',
    ],
    consignes: [
      'Radiographie ou échographie pulmonaire de contrôle avant l\'induction',
      'Matériel de drainage thoracique immédiatement disponible en salle',
      'Surveillance clinique et SpO2 rapprochée en peropératoire',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'covid19',
    nom: 'COVID-19',
    description: 'Infection à SARS-CoV-2 — risque respiratoire et thromboembolique périopératoire',
    categorie: CategoriePathologie.infectieuxRespiratoire,
    alertes: [
      'Précautions gouttelettes/air — masque FFP2 pour toute intubation (geste aérosolisant)',
      'Risque de désaturation rapide et de syndrome de détresse respiratoire aiguë',
      'État prothrombotique — risque thromboembolique périopératoire majoré',
    ],
    recommandations: [
      'Reporter la chirurgie élective ≥7 semaines après infection si possible selon sévérité [APSF/ASA]',
      'Induction en séquence rapide avec préoxygénation prolongée — limiter la ventilation au masque',
      'Thromboprophylaxie systématique périopératoire',
    ],
    consignes: [
      'Salle dédiée / pression négative si disponible pour geste aérosolisant',
      'Équipe réduite au bloc, EPI complet (FFP2, visière)',
      'Bilan de coagulation et D-dimères si signes thromboemboliques',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'grippe',
    nom: 'Grippe',
    description: 'Infection virale saisonnière — reporter la chirurgie élective en phase aiguë',
    categorie: CategoriePathologie.infectieuxRespiratoire,
    alertes: [
      'Fièvre et myalgies — reporter la chirurgie élective jusqu\'à guérison clinique',
      'Risque de surinfection bactérienne pulmonaire',
      'Hyperréactivité bronchique transitoire possible',
    ],
    recommandations: [
      'Reporter la chirurgie élective jusqu\'à résolution des symptômes (7-10 jours)',
      'Antiviraux poursuivis si en cours de traitement (oseltamivir)',
    ],
    consignes: [
      'Précautions gouttelettes standard',
      'Auscultation pulmonaire préopératoire — éliminer une surinfection',
    ],
    droguesFavorisees: ['oseltamivir'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'coqueluche',
    nom: 'Coqueluche',
    description: 'Infection bactérienne à toux quinteuse — risque respiratoire chez le nourrisson',
    categorie: CategoriePathologie.infectieuxRespiratoire,
    alertes: [
      'Toux quinteuse paroxystique — risque de laryngospasme et de vomissements à l\'induction',
      'Nourrisson à haut risque d\'apnée et de désaturation périopératoire',
      'Contagiosité élevée — précautions gouttelettes obligatoires',
    ],
    recommandations: [
      'Reporter la chirurgie élective jusqu\'à la fin de la phase quinteuse (3-4 semaines)',
      'Kétamine : effet bronchodilatateur, intéressant en cas de bronchospasme associé',
      'Surveillance SpO2 continue prolongée en postopératoire chez le nourrisson',
    ],
    consignes: [
      'Isolement gouttelettes — masque chirurgical pour le personnel',
      'Antibiothérapie (macrolide) réduisant la contagiosité si débutée précocement',
      'Aspiration des sécrétions disponible en salle',
    ],
    droguesFavorisees: ['ketamine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       ENDOCRINOLOGIE (AJOUTS)    ║
  // ╚══════════════════════════════════╝
  //  NOTE : Diabète type 1 et type 2 sont couverts par la pathologie
  //  générique 'diabete' déjà existante — Obésité est couverte par
  //  'syndrome_obese' déjà existante — non dupliquées.

  Pathologie(
    id: 'acidocetose_diabetique',
    nom: 'Acidocétose Diabétique',
    description: 'Urgence métabolique — hypovolémie, acidose et troubles ioniques sévères',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Urgence métabolique — hypovolémie sévère, acidose, kaliémie instable',
      'Kaliémie trompeuse à l\'admission — chute rapide sous insuline, risque d\'hypokaliémie sévère',
      'Gastroparésie fréquente — estomac plein fonctionnel, induction en séquence rapide',
    ],
    recommandations: [
      'Corriger l\'hypovolémie et les troubles ioniques AVANT toute chirurgie non vitale',
      'Insulinothérapie IV continue à la seringue électrique, réévaluation horaire',
      'Étomidate pour l\'induction si instabilité hémodynamique',
    ],
    consignes: [
      'Différer toute chirurgie élective jusqu\'à correction de l\'acidocétose',
      'Ionogramme et gaz du sang toutes les 1-2h pendant la correction',
      'Recharge potassique dès que la kaliémie <5.0 mmol/L et diurèse présente',
    ],
    droguesFavorisees: ['etomidate', 'fentanyl', 'nacl_09', 'glucose_10', 'insuline_rapide'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'syndrome_hyperosmolaire',
    nom: 'Syndrome Hyperosmolaire',
    description: 'Déshydratation majeure et hyperosmolarité extrême — terrain souvent âgé',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Déshydratation majeure — hypovolémie sévère souvent sous-estimée',
      'Hyperosmolarité extrême — correction trop rapide : risque d\'œdème cérébral',
      'Terrain âgé fréquent — comorbidités cardiovasculaires associées',
    ],
    recommandations: [
      'Réhydratation progressive AVANT toute chirurgie non vitale',
      'Correction glycémique lente — éviter une baisse >100 mg/dL/h',
      'Étomidate pour l\'induction — stabilité hémodynamique chez le patient hypovolémique',
    ],
    consignes: [
      'Différer la chirurgie élective jusqu\'à stabilisation hémodynamique et métabolique',
      'Surveillance neurologique répétée pendant la correction (risque d\'œdème cérébral)',
      'Osmolarité plasmatique et ionogramme répétés',
    ],
    droguesFavorisees: ['etomidate', 'nacl_09', 'insuline_rapide'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'hypoglycemie_severe',
    nom: 'Hypoglycémie Sévère',
    description: 'Glycémie basse menaçante — signes cliniques masqués sous anesthésie',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Risque de lésion neurologique si hypoglycémie prolongée non corrigée',
      'Signes cliniques masqués sous anesthésie générale — surveillance glycémique obligatoire',
      'Bêta-bloquants : masquent les signes adrénergiques d\'alerte',
    ],
    recommandations: [
      'Corriger immédiatement par soluté glucosé IV avant toute induction non urgente',
      'Monitoring glycémique rapproché en peropératoire',
    ],
    consignes: [
      'Glycémie capillaire avant l\'induction obligatoire',
      'Solutés glucosés hypertoniques disponibles en salle',
      'Différer la chirurgie élective en cas d\'hypoglycémie non corrigée',
    ],
    droguesFavorisees: ['glucose_30'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'hypothyroidie',
    nom: 'Hypothyroïdie',
    description: 'Ralentissement métabolique — sensibilité accrue aux agents dépresseurs',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Sensibilité accrue aux agents dépresseurs — réveil retardé possible',
      'Risque de coma myxœdémateux si hypothyroïdie sévère non traitée',
      'Bradycardie et hypotension fréquentes — réponse aux catécholamines diminuée',
    ],
    recommandations: [
      'Poursuivre la lévothyroxine le matin de la chirurgie',
      'Réduire les doses d\'hypnotiques et d\'opioïdes — sensibilité accrue',
      'Réchauffement actif — hypothermie plus fréquente et moins bien tolérée',
    ],
    consignes: [
      'Bilan thyroïdien préopératoire (TSH, T4L) si hypothyroïdie non équilibrée',
      'Réveil prolongé à anticiper — surveillance SSPI adaptée',
      'Réchauffement actif peropératoire systématique',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'propofol',
        facteur: 0.8,
        note: 'Sensibilité accrue — réduire la dose d\'induction et d\'entretien',
      ),
      DoseAjustee(
        drugId: 'fentanyl',
        facteur: 0.8,
        note: 'Sensibilité accrue aux opioïdes — réduire la dose',
      ),
    ],
  ),

  Pathologie(
    id: 'hyperthyroidie',
    nom: 'Hyperthyroïdie',
    description: 'Hypermétabolisme — risque de crise thyréotoxique périopératoire',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Risque de crise thyréotoxique peropératoire — tachycardie, hyperthermie, agitation',
      'Kétamine et éphédrine : effet sympathomimétique — risque de précipiter une crise thyréotoxique',
      'Atropine : effet tachycardisant à éviter si hyperthyroïdie non contrôlée',
    ],
    recommandations: [
      'Différer la chirurgie élective jusqu\'à euthyroïdie biologique si possible',
      'Esmolol pour contrôle de la fréquence cardiaque',
      'Propofol préféré — stabilité hémodynamique, pas d\'effet sympathomimétique',
    ],
    consignes: [
      'Bilan thyroïdien préopératoire (TSH, T4L, T3L)',
      'Traitement antithyroïdien poursuivi jusqu\'au matin de la chirurgie',
      'Surveillance température et fréquence cardiaque rapprochée (crise thyréotoxique)',
    ],
    droguesFavorisees: ['propofol', 'esmolol'],
    contreIndications: ['atropine'],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'ketamine',
        facteur: 0.5,
        note: 'Limiter la dose — effet sympathomimétique, risque de crise thyréotoxique',
      ),
    ],
  ),

  Pathologie(
    id: 'goitre',
    nom: 'Goitre',
    description: 'Augmentation du volume thyroïdien — risque de compression/déviation trachéale',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Compression trachéale possible — évaluer le risque d\'intubation difficile (imagerie cervicale)',
      'Déviation trachéale — vidéolaryngoscope et matériel d\'intubation difficile disponibles',
      'Extubation à risque — œdème ou trachéomalacie post-chirurgie thyroïdienne',
    ],
    recommandations: [
      'Évaluation ORL/imagerie préopératoire si goitre volumineux ou plongeant',
      'Intubation vigile ou sous fibroscopie si compression trachéale sévère',
      'Matériel d\'intubation difficile systématiquement disponible',
    ],
    consignes: [
      'TDM cervico-thoracique si goitre plongeant ou compressif',
      'Extubation en présence d\'un chariot de réintubation immédiat',
      'Surveillance rapprochée post-thyroïdectomie (hématome compressif, hypocalcémie)',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'syndrome_metabolique',
    nom: 'Syndrome Métabolique',
    description: 'Association obésité/HTA/diabète/dyslipidémie — risque cardiovasculaire cumulé',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Association fréquente obésité/HTA/diabète/dyslipidémie — risque cardiovasculaire cumulé',
      'Risque de SAS associé — évaluer avant anesthésie (score STOP-BANG)',
      'Risque accru de complications cardiovasculaires périopératoires',
    ],
    recommandations: [
      'Bilan cardiovasculaire préopératoire complet si facteurs de risque multiples',
      'Adapter les doses au poids réel/idéal selon l\'agent (cf. obésité)',
      'Monitorage glycémique peropératoire',
    ],
    consignes: [
      'Évaluation multidisciplinaire préopératoire si facteurs de risque cumulés',
      'Prévention thromboembolique systématique (risque accru)',
      'Surveillance glycémique et tensionnelle peropératoire',
    ],
    droguesFavorisees: ['metformine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       GASTRO-ENTÉROLOGIE (AJOUTS)║
  // ╚══════════════════════════════════╝
  //  NOTE : Cirrhose est couverte par 'insuffisance_hepatique' déjà
  //  existante (pharmacocinétique de la cirrhose déjà détaillée) —
  //  non dupliquée.

  Pathologie(
    id: 'gastro_enterite_aigue',
    nom: 'Gastro-entérite Aiguë',
    description: 'Infection digestive aiguë — déshydratation et estomac plein fonctionnel',
    categorie: CategoriePathologie.infectieuxDigestif,
    alertes: [
      'Déshydratation et troubles hydroélectrolytiques fréquents, surtout enfant et sujet âgé',
      'Estomac plein fonctionnel — vomissements/diarrhée récents, risque d\'inhalation',
      'Hypokaliémie possible — surveiller avant curarisation',
    ],
    recommandations: [
      'Réhydratation IV avant toute chirurgie non urgente',
      'Induction en séquence rapide si estomac plein suspecté',
    ],
    consignes: [
      'Ionogramme sanguin si diarrhée/vomissements profus',
      'Différer la chirurgie élective jusqu\'à réhydratation complète',
    ],
    droguesFavorisees: ['ringer_lactate'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'deshydratation',
    nom: 'Déshydratation',
    description: 'Hypovolémie relative — risque d\'hypotension majorée à l\'induction',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Hypovolémie relative — risque d\'hypotension majorée à l\'induction',
      'Fonction rénale à surveiller — risque d\'insuffisance rénale fonctionnelle',
      'Troubles ioniques associés (natrémie, kaliémie) à corriger',
    ],
    recommandations: [
      'Réhydratation IV préopératoire avant toute chirurgie non urgente',
      'Réduire les doses d\'induction — sensibilité accrue à l\'hypotension',
      'Éphédrine ou noradrénaline disponibles en cas d\'hypotension à l\'induction',
    ],
    consignes: [
      'Ionogramme et fonction rénale avant chirurgie élective si déshydratation significative',
      'Remplissage vasculaire titré selon la tolérance hémodynamique',
    ],
    droguesFavorisees: ['ephedrine', 'nacl_09'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'propofol',
        facteur: 0.8,
        note: 'Réduire la dose d\'induction — risque d\'hypotension majoré par l\'hypovolémie',
      ),
    ],
  ),

  Pathologie(
    id: 'rgo',
    nom: 'Reflux Gastro-Œsophagien (RGO)',
    description: 'Risque d\'inhalation bronchique à l\'induction si sévère ou non contrôlé',
    categorie: CategoriePathologie.gastroEnterologie,
    alertes: [
      'Risque d\'inhalation bronchique à l\'induction — considérer comme estomac plein si RGO sévère',
      'Hernie hiatale associée fréquente',
    ],
    recommandations: [
      'Induction en séquence rapide si RGO sévère ou symptomatique le jour de la chirurgie',
      'Poursuivre les IPP le matin de la chirurgie',
      'Prokinétique et anti-H2/IPP en prémédication à discuter',
    ],
    consignes: [
      'Jeûne strict respecté, évaluer le risque d\'estomac plein',
      'Position proclive à l\'induction et au réveil',
    ],
    droguesFavorisees: ['omeprazole'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'ulcere_gastroduodenal',
    nom: 'Ulcère Gastro-Duodénal',
    description: 'Risque hémorragique digestif — AINS et corticoïdes majorent le risque',
    categorie: CategoriePathologie.gastroEnterologie,
    alertes: [
      'Risque hémorragique digestif — vérifier hémoglobine si saignement actif ou récent',
      'AINS et corticoïdes majorent le risque de perforation ou de saignement',
      'Anémie chronique possible — bilan préopératoire recommandé',
    ],
    recommandations: [
      'Éviter les AINS en périopératoire — préférer paracétamol et opioïdes',
      'IPP poursuivis en périopératoire',
    ],
    consignes: [
      'NFS préopératoire si suspicion de saignement chronique',
      'Surveillance des signes de saignement digestif en postopératoire',
    ],
    droguesFavorisees: ['paracetamol'],
    contreIndications: ['ketoprofene'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'hemorragie_digestive',
    nom: 'Hémorragie Digestive',
    description: 'Hypovolémie aiguë et estomac plein — urgence hémodynamique et digestive',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Hypovolémie aiguë — risque de collapsus à l\'induction, réduire les doses d\'induction',
      'Estomac plein — sang digéré et caillots, induction en séquence rapide',
      'Propofol et thiopental : prudence extrême — risque de collapsus si hypovolémie non corrigée',
    ],
    recommandations: [
      'Remplissage vasculaire et transfusion avant l\'induction si possible',
      'Étomidate ou kétamine pour l\'induction — meilleure tolérance hémodynamique',
      'Noradrénaline disponible en cas de collapsus peropératoire',
    ],
    consignes: [
      'Groupe sanguin, RAI et culots globulaires disponibles avant l\'induction',
      'Voies veineuses de gros calibre, monitorage invasif si instabilité',
      'Sonde nasogastrique de vidange à discuter avant l\'induction',
    ],
    droguesFavorisees: ['etomidate', 'ketamine', 'noradrenaline', 'nacl_09'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'propofol',
        facteur: 0.5,
        note: 'Réduire fortement la dose — risque de collapsus si hypovolémie non corrigée',
      ),
    ],
  ),

  Pathologie(
    id: 'hepatite_b',
    nom: 'Hépatite B',
    description: 'Infection virale hépatique — risque de transmission, atteinte hépatique variable',
    categorie: CategoriePathologie.infectieuxDigestif,
    alertes: [
      'Risque de transmission par exposition sang/liquides biologiques — précautions renforcées',
      'Atteinte hépatique variable — évaluer la fonction hépatique si hépatite active ou chronique évoluée',
      'Coagulopathie possible si atteinte hépatique significative',
    ],
    recommandations: [
      'Bilan hépatique et de coagulation préopératoire si hépatite active',
      'Se référer à la pathologie \'Insuffisance Hépatique\' si cirrhose associée',
    ],
    consignes: [
      'Précautions standard renforcées (AES) — matériel à usage unique privilégié',
      'Déclaration AES en cas d\'exposition accidentelle du personnel',
    ],
    droguesFavorisees: ['entecavir'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'hepatite_c',
    nom: 'Hépatite C',
    description: 'Infection virale hépatique — évolution fréquente vers la cirrhose',
    categorie: CategoriePathologie.infectieuxDigestif,
    alertes: [
      'Risque de transmission par exposition sang/liquides biologiques — précautions renforcées',
      'Évolution fréquente vers la cirrhose — évaluer la fonction hépatique si hépatopathie évoluée',
    ],
    recommandations: [
      'Bilan hépatique et de coagulation préopératoire si hépatopathie évoluée',
      'Se référer à la pathologie \'Insuffisance Hépatique\' si cirrhose associée',
    ],
    consignes: [
      'Précautions standard renforcées (AES) — matériel à usage unique privilégié',
    ],
    droguesFavorisees: ['sofosbuvir_velpatasvir'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'ascite',
    nom: 'Ascite',
    description: 'Épanchement liquidien péritonéal — estomac plein fonctionnel, syndrome restrictif',
    categorie: CategoriePathologie.hepatique,
    alertes: [
      'Distension abdominale — considérer comme estomac plein si ascite volumineuse',
      'Syndrome restrictif respiratoire — réduction de la capacité résiduelle fonctionnelle',
      'Risque d\'hypotension lors d\'une ponction de grand volume — évacuation prudente',
    ],
    recommandations: [
      'Induction en séquence rapide si ascite volumineuse (effet estomac plein)',
      'Albumine humaine si ponction d\'ascite >5L (prévention du syndrome post-ponction)',
      'Se référer à la pathologie \'Insuffisance Hépatique\' pour les ajustements pharmacocinétiques',
    ],
    consignes: [
      'Position proclive à l\'induction',
      'Surveillance hémodynamique rapprochée en cas de ponction évacuatrice',
    ],
    droguesFavorisees: ['albumin_20'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'cholecystite',
    nom: 'Cholécystite',
    description: 'Infection/inflammation vésiculaire aiguë — risque de sepsis biliaire',
    categorie: CategoriePathologie.infectieuxDigestif,
    alertes: [
      'Sepsis biliaire possible — évaluer les critères de gravité avant l\'anesthésie',
      'Douleur importante — analgésie multimodale nécessaire',
      'Terrain souvent associé : obésité, diabète — évaluer les comorbidités',
    ],
    recommandations: [
      'Antibiothérapie débutée avant le geste si signes de sepsis',
      'Analgésie multimodale — opioïdes titrés associés au paracétamol',
    ],
    consignes: [
      'Bilan biologique (NFS, CRP, bilan hépatique) préopératoire',
      'Surveillance postopératoire des signes de sepsis persistant',
    ],
    droguesFavorisees: ['fentanyl', 'paracetamol', 'metronidazole'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'colique_hepatique',
    nom: 'Colique Hépatique',
    description: 'Douleur biliaire aiguë — analgésie rapide et efficace nécessaire',
    categorie: CategoriePathologie.gastroEnterologie,
    alertes: [
      'Douleur intense — analgésie rapide et efficace nécessaire',
      'Morphine : effet théorique de spasme du sphincter d\'Oddi — débattu, titration prudente',
    ],
    recommandations: [
      'Analgésie multimodale : paracétamol, antispasmodique et opioïde titré',
      'AINS efficaces si fonction rénale normale et absence de contre-indication',
    ],
    consignes: [
      'Échographie abdominale pour confirmer le diagnostic',
      'Surveillance de la résolution des douleurs sous traitement',
    ],
    droguesFavorisees: ['fentanyl', 'paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'pancreatite_aigue',
    nom: 'Pancréatite Aiguë',
    description: 'Troisième secteur majeur — hypovolémie sévère et risque de sepsis/SDRA',
    categorie: CategoriePathologie.gastroEnterologie,
    alertes: [
      'Troisième secteur majeur — hypovolémie sévère souvent sous-estimée',
      'Hypocalcémie fréquente — surveiller avant curarisation',
      'Risque d\'évolution vers un SDRA ou un sepsis sévère (forme nécrosante)',
    ],
    recommandations: [
      'Remplissage vasculaire guidé — corriger l\'hypovolémie avant chirurgie non vitale',
      'Analgésie multimodale — douleur intense caractéristique',
      'Surveillance calcémie et glycémie répétées',
    ],
    consignes: [
      'Score de gravité (Ranson/APACHE II) à l\'admission',
      'Bilan biologique répété (calcémie, glycémie, CRP, lipase)',
      'Surveillance en unité de soins continus si forme sévère',
    ],
    droguesFavorisees: ['fentanyl'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'appendicite_aigue',
    nom: 'Appendicite Aiguë',
    description: 'Urgence chirurgicale digestive — estomac plein, risque septique si compliquée',
    categorie: CategoriePathologie.infectieuxDigestif,
    alertes: [
      'Estomac plein fréquent — chirurgie en urgence, induction en séquence rapide',
      'Risque de sepsis si appendicite compliquée (péritonite, abcès)',
    ],
    recommandations: [
      'Induction en séquence rapide systématique (chirurgie urgente)',
      'Antibiothérapie préopératoire si signes de complication',
    ],
    consignes: [
      'Bilan biologique (NFS, CRP) et imagerie préopératoires',
      'Surveillance postopératoire des signes de sepsis',
    ],
    droguesFavorisees: ['metronidazole'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'syndrome_intestin_irritable',
    nom: 'Syndrome de l\'Intestin Irritable',
    description: 'Trouble fonctionnel digestif — pas de retentissement anesthésique spécifique démontré',
    categorie: CategoriePathologie.gastroEnterologie,
    alertes: [
      'Pas de retentissement anesthésique spécifique démontré — trouble fonctionnel digestif',
      'Anxiété périopératoire parfois majorée — impact sur la douleur perçue',
    ],
    recommandations: [
      'Prise en charge anesthésique standard',
      'Anxiolyse préopératoire à discuter si anxiété marquée',
    ],
    consignes: [
      'Aucune précaution spécifique supplémentaire nécessaire',
    ],
    droguesFavorisees: ['phloroglucinol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'constipation_chronique',
    nom: 'Constipation Chronique',
    description: 'Risque d\'aggravation par les opioïdes — attention à l\'iléus postopératoire',
    categorie: CategoriePathologie.gastroEnterologie,
    alertes: [
      'Opioïdes aggravent la constipation — risque d\'iléus postopératoire',
      'Distension abdominale chronique possible — évaluer avant chirurgie abdominale',
    ],
    recommandations: [
      'Analgésie multimodale — épargne opioïde si possible',
      'Laxatifs poursuivis en périopératoire',
    ],
    consignes: [
      'Reprise du transit à surveiller en postopératoire',
      'Mobilisation précoce recommandée',
    ],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       NÉPHROLOGIE (AJOUTS)       ║
  // ╚══════════════════════════════════╝
  //  NOTE : Maladie Rénale Chronique est couverte par 'insuffisance_renale'
  //  déjà existante — non dupliquée.

  Pathologie(
    id: 'infection_urinaire',
    nom: 'Infection Urinaire',
    description: 'Infection des voies urinaires basses — risque de progression si non traitée',
    categorie: CategoriePathologie.infectieux,
    alertes: [
      'Risque de progression vers pyélonéphrite ou sepsis si non traitée',
      'Antibiothérapie à vérifier avant tout geste invasif urologique',
    ],
    recommandations: [
      'Antibiothérapie adaptée à l\'ECBU avant chirurgie urologique programmée',
      'Prise en charge anesthésique standard si infection basse non compliquée',
    ],
    consignes: [
      'ECBU préopératoire si chirurgie urologique programmée',
      'Surveillance des signes de sepsis en périopératoire',
    ],
    droguesFavorisees: ['fosfomycine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'pyelonephrite',
    nom: 'Pyélonéphrite',
    description: 'Infection rénale haute — risque de sepsis à évaluer avant l\'anesthésie',
    categorie: CategoriePathologie.infectieux,
    alertes: [
      'Risque de sepsis, voire choc septique — évaluer la gravité avant l\'anesthésie',
      'Douleur et fièvre — hydratation et antalgie à optimiser avant l\'induction',
    ],
    recommandations: [
      'Antibiothérapie débutée avant le geste si signes de gravité',
      'Remplissage vasculaire et optimisation hémodynamique préopératoire si sepsis',
    ],
    consignes: [
      'Bilan biologique (NFS, CRP, hémocultures) et imagerie si signes de gravité',
      'Surveillance hémodynamique rapprochée en cas de sepsis associé',
    ],
    droguesFavorisees: ['noradrenaline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'colique_nephretique',
    nom: 'Colique Néphrétique',
    description: 'Douleur lombaire aiguë d\'origine urétérale — analgésie rapide nécessaire',
    categorie: CategoriePathologie.urologie,
    alertes: [
      'Douleur intense — analgésie rapide et efficace nécessaire',
      'AINS efficaces en 1ère intention si fonction rénale normale',
    ],
    recommandations: [
      'AINS (kétoprofène) en 1ère intention si absence de contre-indication',
      'Analgésie multimodale : paracétamol et opioïde titré si AINS insuffisant',
    ],
    consignes: [
      'Imagerie (échographie/TDM) pour rechercher un obstacle et évaluer la fonction rénale',
      'Surveillance de la diurèse et de la fonction rénale',
    ],
    droguesFavorisees: ['ketoprofene', 'paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'insuffisance_renale_aigue',
    nom: 'Insuffisance Rénale Aiguë',
    description: 'Dysfonction rénale évolutive — éviter tout néphrotoxique supplémentaire',
    categorie: CategoriePathologie.renal,
    alertes: [
      'Fonction rénale évolutive — réévaluer le DFG régulièrement, distinct de l\'IRC stable',
      'Éviter tout nouvel agent néphrotoxique (AINS, produits de contraste iodés, aminosides)',
      'Troubles ioniques aigus (hyperkaliémie) à corriger avant l\'induction',
      'Succinylcholine : prudence — risque d\'hyperkaliémie si oligo-anurie',
    ],
    recommandations: [
      'Optimisation volémique guidée — éviter hypovolémie et surcharge',
      'Propofol, fentanyl, cisatracurium : métabolisme non ou peu rénal — privilégier',
      'Se référer à la pathologie \'Insuffisance Rénale Chronique\' en cas d\'oligurie/anurie prolongée',
    ],
    consignes: [
      'Ionogramme et kaliémie avant l\'induction — traiter si K⁺ >5.5 mEq/L',
      'Éviter tout néphrotoxique supplémentaire (AINS, produit de contraste, aminoside)',
      'Surveillance stricte de la diurèse horaire',
    ],
    droguesFavorisees: ['propofol', 'fentanyl', 'cisatracurium', 'nacl_09'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'succinylcholine',
        facteur: 1.0,
        note: 'Prudence si oligo-anurie — risque d\'hyperkaliémie, vérifier la kaliémie avant utilisation',
      ),
    ],
  ),

  Pathologie(
    id: 'syndrome_nephrotique',
    nom: 'Syndrome Néphrotique',
    description: 'Hypoalbuminémie et état d\'hypercoagulabilité — protéinurie massive',
    categorie: CategoriePathologie.renal,
    alertes: [
      'Hypoalbuminémie — modification de la fraction libre des médicaments fortement liés aux protéines',
      'État d\'hypercoagulabilité — risque thromboembolique accru',
      'Œdèmes et épanchements — évaluer le retentissement respiratoire (épanchement pleural)',
    ],
    recommandations: [
      'Adapter les doses des agents fortement liés à l\'albumine (fraction libre augmentée)',
      'Thromboprophylaxie systématique périopératoire',
      'Corriger l\'hypovolémie efficace malgré les œdèmes (remplissage prudent guidé)',
    ],
    consignes: [
      'Bilan albuminémie et protéinurie préopératoire',
      'Prévention thromboembolique systématique',
      'Surveillance respiratoire si épanchement pleural associé',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'midazolam',
        facteur: 0.8,
        note: 'Hypoalbuminémie — fraction libre augmentée, réduire la dose',
      ),
    ],
  ),

  Pathologie(
    id: 'hematurie',
    nom: 'Hématurie',
    description: 'Présence de sang dans les urines — rechercher la cause sous-jacente',
    categorie: CategoriePathologie.urologie,
    alertes: [
      'Rechercher une cause sous-jacente (tumorale, lithiasique, infectieuse) avant chirurgie programmée',
      'Anémie possible si hématurie chronique ou abondante — bilan préopératoire recommandé',
    ],
    recommandations: [
      'NFS préopératoire si hématurie significative ou chronique',
      'Prise en charge anesthésique standard sinon',
    ],
    consignes: [
      'Bilan étiologique (imagerie, cytologie) selon le contexte',
      'Surveillance de la coloration des urines en périopératoire si sondage',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'retention_urinaire',
    nom: 'Rétention Urinaire',
    description: 'Distension vésicale — risque de globe vésical postopératoire',
    categorie: CategoriePathologie.urologie,
    alertes: [
      'Distension vésicale — inconfort et risque de globe vésical postopératoire, surtout sous rachianesthésie',
      'Opioïdes et anesthésie locorégionale majorent le risque de rétention postopératoire',
    ],
    recommandations: [
      'Sondage vésical évacuateur préopératoire si globe vésical constitué',
      'Limiter les opioïdes et anticholinergiques en cas de rétention connue',
    ],
    consignes: [
      'Surveillance de la diurèse et bladder scan en postopératoire',
      'Sondage évacuateur disponible en SSPI si besoin',
    ],
    droguesFavorisees: ['tamsulosine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       NEUROLOGIE (AJOUTS)        ║
  // ╚══════════════════════════════════╝
  //  NOTE : Épilepsie est couverte par 'epilepsie' déjà existante —
  //  non dupliquée.

  Pathologie(
    id: 'crise_convulsive_febrile',
    nom: 'Crise Convulsive Fébrile',
    description: 'Convulsion liée à la fièvre chez l\'enfant — contrôle thermique nécessaire',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Risque de récidive convulsive en cas d\'hyperthermie peropératoire — contrôle thermique strict',
      'Étomidate : myoclonies pouvant mimer une crise — prudence',
    ],
    recommandations: [
      'Contrôle rigoureux de la température peropératoire (antipyrétiques, refroidissement)',
      'Propofol : activité antiépileptique — préféré à l\'induction',
    ],
    consignes: [
      'Antipyrétiques disponibles en salle',
      'Surveillance neurologique postopératoire si antécédent de convulsions fébriles compliquées',
    ],
    droguesFavorisees: ['propofol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'meningite',
    nom: 'Méningite',
    description: 'Infection méningée — risque d\'HTIC associée et de sepsis',
    categorie: CategoriePathologie.neuroInfectieux,
    alertes: [
      'Risque d\'hypertension intracrânienne associée — éviter la kétamine si signes d\'engagement',
      'Sepsis possible — évaluer les critères de gravité avant l\'anesthésie',
      'Coagulation à vérifier avant toute ponction lombaire ou anesthésie périmédullaire',
    ],
    recommandations: [
      'Antibiothérapie débutée en urgence avant tout geste non vital',
      'Se référer à la pathologie \'HIC\' si signes d\'hypertension intracrânienne associés',
      'Étomidate ou propofol pour l\'induction — stabilité hémodynamique',
    ],
    consignes: [
      'Bilan biologique (NFS, CRP, hémocultures, PL si indiquée) en urgence',
      'Surveillance neurologique rapprochée (score de Glasgow)',
    ],
    droguesFavorisees: ['propofol', 'etomidate', 'dexamethasone'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'encephalite',
    nom: 'Encéphalite',
    description: 'Inflammation cérébrale — risque convulsif et de troubles de la conscience',
    categorie: CategoriePathologie.neuroInfectieux,
    alertes: [
      'Risque convulsif et d\'hypertension intracrânienne associés',
      'Troubles de la conscience — évaluation neurologique préopératoire indispensable',
    ],
    recommandations: [
      'Propofol préféré — activité antiépileptique et réduction de la PIC',
      'Se référer aux pathologies \'HIC\' et \'Épilepsie\' selon les signes associés',
    ],
    consignes: [
      'Imagerie cérébrale et bilan infectieux (PL, sérologies) en urgence',
      'Surveillance neurologique rapprochée (score de Glasgow)',
    ],
    droguesFavorisees: ['propofol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'migraine',
    nom: 'Migraine',
    description: 'Céphalée primaire récurrente — pas de contre-indication anesthésique spécifique',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Pas de contre-indication anesthésique spécifique en dehors de la crise',
      'Triptans : éviter l\'association avec certains vasoconstricteurs (risque vasospastique théorique)',
    ],
    recommandations: [
      'Prise en charge anesthésique standard',
      'Antiémétiques prophylactiques recommandés (nausées postopératoires plus fréquentes)',
    ],
    consignes: [
      'Poursuivre le traitement de fond habituel le jour de la chirurgie',
    ],
    droguesFavorisees: ['ketoprofene'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'cephalee_tension',
    nom: 'Céphalée de Tension',
    description: 'Céphalée primaire fréquente — sans retentissement anesthésique spécifique',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Pas de retentissement anesthésique spécifique démontré',
    ],
    recommandations: [
      'Prise en charge anesthésique standard',
      'Antalgiques simples (paracétamol) efficaces habituellement',
    ],
    consignes: [
      'Aucune précaution spécifique supplémentaire nécessaire',
    ],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'nevralgie_faciale',
    nom: 'Névralgie Faciale',
    description: 'Douleur neuropathique du trijumeau — traitement par carbamazépine fréquent',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Carbamazépine fréquemment utilisée — inducteur enzymatique, accélère le métabolisme de certains agents',
    ],
    recommandations: [
      'Poursuivre le traitement de fond (carbamazépine) jusqu\'au matin de la chirurgie',
      'Adapter les doses des agents métabolisés par le CYP450',
    ],
    consignes: [
      'Vérifier le traitement en cours et ses interactions médicamenteuses',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 1.3,
        note: 'Induction enzymatique par la carbamazépine — augmenter la dose de 30%',
      ),
    ],
  ),

  Pathologie(
    id: 'guillain_barre',
    nom: 'Syndrome de Guillain-Barré',
    description: 'Polyradiculonévrite aiguë — dysautonomie et risque respiratoire',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Succinylcholine FORMELLEMENT CONTRE-INDIQUÉE — risque d\'hyperkaliémie sévère (dénervation)',
      'Dysautonomie fréquente — labilité tensionnelle et risque d\'arythmies peropératoires',
      'Atteinte des muscles respiratoires possible — évaluer la capacité vitale avant l\'anesthésie',
    ],
    recommandations: [
      'Curare non dépolarisant à dose réduite — sensibilité accrue possible',
      'Monitorage hémodynamique rapproché (dysautonomie)',
      'Évaluer la fonction respiratoire (CV, force musculaire) avant toute chirurgie',
    ],
    consignes: [
      'Explorations fonctionnelles respiratoires si atteinte respiratoire suspectée',
      'Surveillance postopératoire prolongée en unité de soins continus si forme sévère',
    ],
    droguesFavorisees: [],
    contreIndications: ['succinylcholine'],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 0.7,
        note: 'Sensibilité accrue aux curares non dépolarisants — réduire la dose et monitorer le TOF',
      ),
    ],
  ),

  Pathologie(
    id: 'parkinson',
    nom: 'Maladie de Parkinson',
    description: 'Syndrome extrapyramidal — sensibilité aux antagonistes dopaminergiques',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Métoclopramide et halopéridol CONTRE-INDIQUÉS — antagonistes dopaminergiques, aggravent les symptômes',
      'Interruption brutale de la lévodopa : risque de syndrome parkinsonien aigu ou de syndrome malin des neuroleptiques',
      'Dysautonomie possible — labilité tensionnelle',
    ],
    recommandations: [
      'Poursuivre le traitement dopaminergique jusqu\'au matin de la chirurgie, reprise la plus précoce possible',
      'Propofol : pas d\'aggravation des symptômes — bien toléré',
      'Ondansétron préféré comme antiémétique (pas d\'effet dopaminergique)',
    ],
    consignes: [
      'Ne jamais interrompre le traitement dopaminergique sans avis neurologique',
      'Reprise du traitement per os dès que possible en postopératoire (sonde nasogastrique si besoin)',
    ],
    droguesFavorisees: ['propofol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'alzheimer',
    nom: 'Maladie d\'Alzheimer',
    description: 'Démence neurodégénérative — risque élevé de délirium postopératoire',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Risque élevé de délirium postopératoire — évaluation cognitive préopératoire recommandée',
      'Anticholinergiques à éviter — aggravent les troubles cognitifs (atropine, scopolamine)',
      'Sensibilité accrue aux benzodiazépines — risque de confusion postopératoire',
    ],
    recommandations: [
      'Éviter la prémédication par benzodiazépines si possible',
      'Anesthésie la plus légère possible compatible avec la chirurgie',
      'Analgésie multimodale — éviter les opioïdes à forte dose (majorent le délirium)',
    ],
    consignes: [
      'Évaluation cognitive préopératoire (MMSE) si possible',
      'Prévention du délirium postopératoire (réorientation précoce, présence d\'un proche)',
    ],
    droguesFavorisees: ['glycopyrrolate'],
    contreIndications: ['atropine'],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'midazolam',
        facteur: 0.5,
        note: 'Sensibilité accrue — réduire fortement ou éviter, risque de délirium postopératoire',
      ),
    ],
  ),

  // ╔══════════════════════════════════╗
  // ║       INFECTIOLOGIE (AJOUTS)     ║
  // ╚══════════════════════════════════╝
  //  NOTE : Tuberculose ('tuberculose_pulmonaire'), Coqueluche
  //  ('coqueluche') et Méningite bactérienne ('meningite') existent
  //  déjà (lots précédents) — non dupliquées.

  Pathologie(
    id: 'rougeole',
    nom: 'Rougeole',
    description: 'Infection virale très contagieuse — précautions air',
    categorie: CategoriePathologie.infectieuxPediatrique,
    alertes: [
      'Contagiosité très élevée — précautions air (masque FFP2, salle dédiée si possible)',
      'Complications possibles (pneumonie, encéphalite) — reporter la chirurgie élective en phase aiguë',
    ],
    recommandations: [
      'Reporter la chirurgie élective jusqu\'à résolution clinique',
      'Prise en charge anesthésique standard sinon',
    ],
    consignes: [
      'Isolement air — masque FFP2 pour le personnel non immunisé',
    ],
    droguesFavorisees: ['vitamine_a'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'varicelle',
    nom: 'Varicelle',
    description: 'Infection virale cutanée très contagieuse — lésions vésiculeuses',
    categorie: CategoriePathologie.infectieuxPediatrique,
    alertes: [
      'Contagiosité élevée jusqu\'à la phase de croûtes — précautions air et contact',
      'Éviter toute anesthésie locorégionale au niveau d\'une lésion cutanée active',
    ],
    recommandations: [
      'Reporter la chirurgie élective jusqu\'à la phase de croûtes sèches',
    ],
    consignes: [
      'Isolement air et contact — masque FFP2 pour le personnel non immunisé',
    ],
    droguesFavorisees: ['aciclovir'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'oreillons',
    nom: 'Oreillons',
    description: 'Infection virale des glandes salivaires — peu de retentissement anesthésique',
    categorie: CategoriePathologie.infectieuxPediatrique,
    alertes: [
      'Peu de retentissement anesthésique spécifique — fièvre à contrôler',
    ],
    recommandations: [
      'Prise en charge anesthésique standard',
      'Reporter la chirurgie élective en phase fébrile aiguë',
    ],
    consignes: [
      'Isolement gouttelettes standard',
    ],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'rubeole',
    nom: 'Rubéole',
    description: 'Infection virale bénigne — attention particulière si grossesse associée',
    categorie: CategoriePathologie.infectieuxPediatrique,
    alertes: [
      'Peu de retentissement anesthésique spécifique chez l\'adulte',
      'Tératogène en cas de grossesse — prudence pour le personnel/entourage non immunisé',
    ],
    recommandations: [
      'Prise en charge anesthésique standard',
    ],
    consignes: [
      'Isolement gouttelettes — vérifier le statut immunitaire du personnel enceinte',
    ],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'paludisme',
    nom: 'Paludisme',
    description: 'Parasitose sanguine — anémie, hypoglycémie et risque de neuropaludisme',
    categorie: CategoriePathologie.maladiesTropicales,
    alertes: [
      'Anémie hémolytique fréquente — NFS préopératoire recommandée',
      'Hypoglycémie fréquente, notamment sous quinine — surveillance glycémique',
      'Neuropaludisme : troubles de conscience et risque convulsif (forme grave)',
      'Allongement du QT possible sous quinine/méfloquine — prudence avec les agents allongeant le QT',
    ],
    recommandations: [
      'NFS et glycémie préopératoires systématiques',
      'ECG si traitement par quinine ou méfloquine en cours',
    ],
    consignes: [
      'Différer la chirurgie élective en phase aiguë',
      'Surveillance glycémique rapprochée sous quinine',
    ],
    droguesFavorisees: ['artemether_lumefantrine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'brucellose',
    nom: 'Brucellose',
    description: 'Zoonose bactérienne — atteinte ostéoarticulaire ou hépatique possible',
    categorie: CategoriePathologie.maladiesTropicales,
    alertes: [
      'Peu de retentissement anesthésique spécifique',
      'Atteinte hépatique ou ostéoarticulaire possible en cas d\'évolution chronique',
    ],
    recommandations: [
      'Bilan hépatique préopératoire si atteinte hépatique évoquée',
    ],
    consignes: [
      'Précautions standard',
    ],
    droguesFavorisees: ['doxycycline', 'rifampicine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'leishmaniose',
    nom: 'Leishmaniose',
    description: 'Parasitose — forme viscérale avec pancytopénie et splénomégalie possibles',
    categorie: CategoriePathologie.maladiesTropicales,
    alertes: [
      'Forme viscérale : pancytopénie, splénomégalie et hypoalbuminémie possibles',
    ],
    recommandations: [
      'NFS et bilan hépatique préopératoires si forme viscérale',
    ],
    consignes: [
      'Précautions standard',
    ],
    droguesFavorisees: ['amphotericine_b_liposomale'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'rage',
    nom: 'Rage',
    description: 'Encéphalite virale mortelle une fois symptomatique — soins de confort',
    categorie: CategoriePathologie.maladiesTropicales,
    alertes: [
      'Pathologie mortelle une fois symptomatique — prise en charge principalement palliative',
      'Contagiosité par la salive — précautions contact/gouttelettes strictes',
    ],
    recommandations: [
      'Soins de confort et sédation adaptée aux symptômes',
    ],
    consignes: [
      'Isolement contact strict, protection renforcée du personnel',
    ],
    droguesFavorisees: ['immunoglobuline_antirabique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'tetanos',
    nom: 'Tétanos',
    description: 'Toxine bactérienne — spasmes musculaires généralisés, risque respiratoire',
    categorie: CategoriePathologie.maladiesTropicales,
    alertes: [
      'Spasmes musculaires généralisés (trismus, opisthotonos) — risque de laryngospasme et de détresse respiratoire',
      'Succinylcholine : prudence — risque de rhabdomyolyse et d\'hyperkaliémie si spasmes prolongés',
      'Dysautonomie possible dans les formes sévères — labilité tensionnelle',
    ],
    recommandations: [
      'Benzodiazépines à forte dose pour contrôler les spasmes',
      'Curarisation non dépolarisante si spasmes réfractaires ou détresse respiratoire',
      'Environnement calme, peu stimulant — réduit le déclenchement des spasmes',
    ],
    consignes: [
      'Sérothérapie et vaccination antitétanique à vérifier/administrer',
      'Surveillance en unité de soins continus si forme généralisée',
    ],
    droguesFavorisees: ['midazolam', 'rocuronium', 'glycopyrrolate'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'vih',
    nom: 'VIH',
    description: 'Infection rétrovirale chronique — interactions ARV et immunodépression variable',
    categorie: CategoriePathologie.ist,
    alertes: [
      'Interactions médicamenteuses avec les antirétroviraux (inhibiteurs du CYP450) — vérifier le traitement en cours',
      'Immunodépression variable selon le taux de CD4 — évaluer le risque infectieux périopératoire',
      'Précautions standard renforcées (AES) systématiques',
    ],
    recommandations: [
      'Poursuivre le traitement antirétroviral en périopératoire (éviter toute interruption)',
      'Vérifier les interactions médicamenteuses avec le traitement ARV en cours',
    ],
    consignes: [
      'Bilan immunovirologique récent (CD4, charge virale) si disponible',
      'Précautions standard renforcées (AES) — matériel à usage unique privilégié',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'syphilis',
    nom: 'Syphilis',
    description: 'Infection sexuellement transmissible — atteinte tardive possible (neuro/cardiovasculaire)',
    categorie: CategoriePathologie.ist,
    alertes: [
      'Peu de retentissement anesthésique aux stades précoces',
      'Neurosyphilis ou aortite possibles aux stades tardifs non traités',
    ],
    recommandations: [
      'Bilan cardiovasculaire/neurologique si stade tardif suspecté',
    ],
    consignes: [
      'Précautions standard',
    ],
    droguesFavorisees: ['benzathine_penicilline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'gonorrhee',
    nom: 'Gonorrhée',
    description: 'Infection sexuellement transmissible bactérienne — peu de retentissement anesthésique',
    categorie: CategoriePathologie.ist,
    alertes: [
      'Peu de retentissement anesthésique spécifique',
    ],
    recommandations: [
      'Prise en charge anesthésique standard',
    ],
    consignes: [
      'Précautions standard',
    ],
    droguesFavorisees: ['ceftriaxone'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'chlamydia',
    nom: 'Chlamydia',
    description: 'Infection sexuellement transmissible bactérienne — peu de retentissement anesthésique',
    categorie: CategoriePathologie.ist,
    alertes: [
      'Peu de retentissement anesthésique spécifique',
    ],
    recommandations: [
      'Prise en charge anesthésique standard',
    ],
    consignes: [
      'Précautions standard',
    ],
    droguesFavorisees: ['azithromycine', 'doxycycline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       DERMATOLOGIE (AJOUTS)      ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'eczema',
    nom: 'Eczéma',
    description: 'Dermatite inflammatoire chronique — précautions cutanées pour les adhésifs',
    categorie: CategoriePathologie.dermatologie,
    alertes: [
      'Peau fragile — précautions pour les électrodes et pansements adhésifs',
    ],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Adhésifs hypoallergéniques si peau très réactive'],
    droguesFavorisees: ['betamethasone_topique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'psoriasis',
    nom: 'Psoriasis',
    description: 'Dermatose inflammatoire chronique — parfois sous immunosuppresseurs',
    categorie: CategoriePathologie.dermatologie,
    alertes: [
      'Phénomène de Koebner — éviter les traumatismes cutanés inutiles (électrodes, adhésifs)',
      'Immunosuppresseurs de fond possibles (méthotrexate, biothérapies) — risque infectieux à évaluer',
    ],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Vérifier le traitement de fond si biothérapie/immunosuppresseur en cours'],
    droguesFavorisees: ['betamethasone_topique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'acne',
    nom: 'Acné',
    description: 'Dermatose fréquente — peu de retentissement anesthésique',
    categorie: CategoriePathologie.dermatologie,
    alertes: ['Peu de retentissement anesthésique spécifique'],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['tretinoine_topique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'gale',
    nom: 'Gale',
    description: 'Ectoparasitose contagieuse — précautions contact strictes',
    categorie: CategoriePathologie.dermatologieInfectieuse,
    alertes: ['Contagiosité par contact direct — précautions contact strictes pour le personnel'],
    recommandations: ['Traitement scabicide avant chirurgie élective si possible'],
    consignes: ['Isolement contact — matériel dédié si possible'],
    droguesFavorisees: ['permethrine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'impetigo',
    nom: 'Impétigo',
    description: 'Infection cutanée bactérienne contagieuse — précautions contact',
    categorie: CategoriePathologie.dermatologieInfectieuse,
    alertes: [
      'Contagiosité élevée par contact — précautions contact',
      'Éviter toute anesthésie locorégionale au niveau d\'une lésion active',
    ],
    recommandations: ['Antibiothérapie locale/générale débutée avant chirurgie élective si possible'],
    consignes: ['Isolement contact — matériel dédié si possible'],
    droguesFavorisees: ['amoxicilline_clavulanate'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'cellulite_infectieuse',
    nom: 'Cellulite Infectieuse',
    description: 'Infection cutanée profonde — risque septique, éviter l\'ALR au site infecté',
    categorie: CategoriePathologie.dermatologieInfectieuse,
    alertes: [
      'Risque d\'évolution vers un sepsis — évaluer les critères de gravité',
      'Anesthésie locorégionale CONTRE-INDIQUÉE au site infecté — risque de dissémination',
    ],
    recommandations: [
      'Antibiothérapie débutée avant le geste si signes de gravité',
      'Anesthésie générale préférée si le site infecté empêche l\'ALR prévue',
    ],
    consignes: ['Bilan biologique (NFS, CRP) si signes de gravité'],
    droguesFavorisees: ['amoxicilline_clavulanate'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'zona',
    nom: 'Zona',
    description: 'Réactivation du virus varicelle-zona — éviter l\'ALR sur le dermatome atteint',
    categorie: CategoriePathologie.dermatologieInfectieuse,
    alertes: [
      'Anesthésie périmédullaire/locorégionale CONTRE-INDIQUÉE sur le dermatome en phase active',
      'Douleurs post-zostériennes possibles — évaluation antalgique spécifique',
    ],
    recommandations: [
      'Antiviraux poursuivis en périopératoire si traitement en cours',
      'Analgésie adaptée en cas de douleurs neuropathiques associées',
    ],
    consignes: ['Isolement contact si lésions actives non croûtées'],
    droguesFavorisees: ['aciclovir'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'herpes',
    nom: 'Herpès',
    description: 'Infection virale récurrente — éviter l\'ALR au site de lésion active',
    categorie: CategoriePathologie.dermatologieInfectieuse,
    alertes: [
      'Anesthésie locorégionale à éviter au niveau d\'une lésion herpétique active',
    ],
    recommandations: ['Antiviraux poursuivis si traitement en cours'],
    consignes: ['Isolement contact si lésions actives'],
    droguesFavorisees: ['aciclovir'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'dermatophytie',
    nom: 'Dermatophytie',
    description: 'Mycose cutanée superficielle — peu de retentissement anesthésique',
    categorie: CategoriePathologie.dermatologie,
    alertes: ['Peu de retentissement anesthésique — éviter l\'ALR sur une lésion active étendue'],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['terbinafine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'urticaire',
    nom: 'Urticaire',
    description: 'Manifestation allergique cutanée — rechercher un facteur déclenchant',
    categorie: CategoriePathologie.allergique,
    alertes: [
      'Rechercher un allergène déclenchant (médicament, latex, aliment) avant l\'anesthésie',
      'Risque de progression vers une réaction anaphylactique si allergène non identifié et réexposition',
    ],
    recommandations: [
      'Antihistaminique en prémédication si urticaire chronique connue',
      'Éviter les histamino-libérateurs (morphine, atracurium à forte dose)',
    ],
    consignes: ['Interrogatoire allergologique préopératoire soigneux'],
    droguesFavorisees: ['dexchlorpheniramine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'erysipele',
    nom: 'Érysipèle',
    description: 'Infection cutanée bactérienne — risque septique, éviter l\'ALR au site infecté',
    categorie: CategoriePathologie.dermatologieInfectieuse,
    alertes: [
      'Risque d\'évolution vers un sepsis — évaluer les critères de gravité',
      'Anesthésie locorégionale CONTRE-INDIQUÉE au site infecté',
    ],
    recommandations: ['Antibiothérapie débutée avant le geste si signes de gravité'],
    consignes: ['Bilan biologique (NFS, CRP) si signes de gravité'],
    droguesFavorisees: ['amoxicilline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       ORL (AJOUTS)               ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'otite_moyenne_aigue',
    nom: 'Otite Moyenne Aiguë',
    description: 'Infection de l\'oreille moyenne — peu de retentissement anesthésique',
    categorie: CategoriePathologie.orlInfectieux,
    alertes: ['Peu de retentissement anesthésique spécifique'],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Antibiothérapie poursuivie si en cours'],
    droguesFavorisees: ['amoxicilline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'otite_externe',
    nom: 'Otite Externe',
    description: 'Infection du conduit auditif externe — peu de retentissement anesthésique',
    categorie: CategoriePathologie.orlInfectieux,
    alertes: ['Peu de retentissement anesthésique spécifique'],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['gouttes_auriculaires_ab_corticoide'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'sinusite',
    nom: 'Sinusite',
    description: 'Infection des sinus paranasaux — attention à l\'intubation nasale',
    categorie: CategoriePathologie.orlInfectieux,
    alertes: ['Éviter l\'intubation nasotrachéale en phase infectieuse aiguë (risque de dissémination)'],
    recommandations: ['Antibiothérapie poursuivie si en cours'],
    consignes: ['Préférer la voie orotrachéale si intubation nécessaire'],
    droguesFavorisees: ['amoxicilline_clavulanate'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'rhinite_allergique',
    nom: 'Rhinite Allergique',
    description: 'Inflammation nasale allergique chronique — peu de retentissement anesthésique',
    categorie: CategoriePathologie.allergique,
    alertes: ['Peu de retentissement anesthésique — rechercher un terrain atopique associé (asthme)'],
    recommandations: ['Antihistaminique poursuivi si traitement de fond'],
    consignes: ['Rechercher un asthme associé (terrain atopique)'],
    droguesFavorisees: ['dexchlorpheniramine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'angine_bacterienne',
    nom: 'Angine Bactérienne',
    description: 'Infection pharyngée bactérienne — risque d\'abcès et de compromission des voies aériennes',
    categorie: CategoriePathologie.orlInfectieux,
    alertes: [
      'Risque d\'évolution vers un phlegmon ou un abcès périamygdalien — évaluer la liberté des voies aériennes',
      'Trismus ou dysphagie sévère — signe d\'alerte pour une intubation potentiellement difficile',
    ],
    recommandations: [
      'Antibiothérapie poursuivie en périopératoire',
      'Matériel d\'intubation difficile disponible si signes de compromission des voies aériennes',
    ],
    consignes: ['Évaluation clinique des voies aériennes supérieures avant toute anesthésie générale'],
    droguesFavorisees: ['amoxicilline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'pharyngite_virale',
    nom: 'Pharyngite Virale',
    description: 'Infection virale pharyngée — peu de retentissement anesthésique',
    categorie: CategoriePathologie.orlInfectieux,
    alertes: ['Peu de retentissement anesthésique spécifique'],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'amygdalite',
    nom: 'Amygdalite',
    description: 'Inflammation amygdalienne — risque de compromission des voies aériennes si volumineuse',
    categorie: CategoriePathologie.orlInfectieux,
    alertes: [
      'Hypertrophie amygdalienne volumineuse — risque d\'intubation difficile et de SAOS associé',
    ],
    recommandations: [
      'Matériel d\'intubation difficile disponible si hypertrophie sévère',
      'Évaluer un SAOS associé, surtout chez l\'enfant',
    ],
    consignes: ['Évaluation des voies aériennes supérieures avant l\'anesthésie'],
    droguesFavorisees: ['amoxicilline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'laryngite',
    nom: 'Laryngite',
    description: 'Inflammation laryngée — risque d\'œdème des voies aériennes, surtout chez l\'enfant',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Œdème laryngé possible — risque de majoration après intubation (laryngite sous-glottique/croup chez l\'enfant)',
      'Toux aboyante, stridor — évaluer la sévérité avant toute anesthésie élective',
    ],
    recommandations: [
      'Reporter la chirurgie élective si stridor ou détresse respiratoire',
      'Corticoïdes et aérosols d\'adrénaline disponibles si laryngite sous-glottique sévère',
    ],
    consignes: ['Surveillance respiratoire rapprochée en post-extubation'],
    droguesFavorisees: ['dexamethasone'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'corps_etranger_orl',
    nom: 'Corps Étranger ORL',
    description: 'Obstruction des voies aériennes/digestives supérieures — urgence potentielle',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Risque d\'obstruction complète des voies aériennes — évaluer la stabilité respiratoire avant l\'induction',
      'Estomac plein habituel (urgence) — induction en séquence rapide sauf si corps étranger obstructif',
      'Éviter la ventilation en pression positive si corps étranger laryngo-trachéal (risque d\'enclavement)',
    ],
    recommandations: [
      'Induction au masque en ventilation spontanée si risque d\'obstruction complète',
      'Extraction en urgence par endoscopie si signes de détresse respiratoire',
    ],
    consignes: ['Matériel d\'extraction et de voies aériennes difficiles immédiatement disponible'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       OPHTALMOLOGIE (AJOUTS)     ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'conjonctivite',
    nom: 'Conjonctivite',
    description: 'Inflammation conjonctivale — peu de retentissement anesthésique',
    categorie: CategoriePathologie.infectieux,
    alertes: ['Peu de retentissement anesthésique spécifique'],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Précautions contact standard si origine infectieuse'],
    droguesFavorisees: ['collyre_antibiotique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'keratite',
    nom: 'Kératite',
    description: 'Inflammation cornéenne — protection oculaire peropératoire renforcée',
    categorie: CategoriePathologie.infectieux,
    alertes: ['Protection oculaire renforcée peropératoire — risque de majoration de la kératite'],
    recommandations: ['Traitement local poursuivi en périopératoire'],
    consignes: ['Occlusion palpébrale soigneuse peropératoire'],
    droguesFavorisees: ['collyre_antibiotique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'glaucome_aigu',
    nom: 'Glaucome Aigu',
    description: 'Élévation aiguë de la pression intraoculaire — urgence ophtalmologique',
    categorie: CategoriePathologie.ophtalmologie,
    alertes: [
      'Succinylcholine CONTRE-INDIQUÉE — augmente la pression intraoculaire (PIO)',
      'Atropine et anticholinergiques : prudence — effet mydriatique, risque de majorer un angle fermé',
      'Éviter toute manœuvre augmentant la PIO (toux, hypertension, hypercapnie)',
    ],
    recommandations: [
      'Curare non dépolarisant préféré à l\'induction',
      'Propofol : effet favorable sur la PIO (diminution)',
      'Prévention des nausées/vomissements — évite l\'augmentation de la PIO par les efforts de vomissement',
    ],
    consignes: [
      'Traitement hypotonisant oculaire poursuivi en périopératoire',
      'Éviter toute hypertension ou hypercapnie peropératoire',
    ],
    droguesFavorisees: ['propofol', 'rocuronium'],
    contreIndications: ['succinylcholine', 'atropine'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'cataracte',
    nom: 'Cataracte',
    description: 'Opacification du cristallin — chirurgie fréquemment sous anesthésie locale',
    categorie: CategoriePathologie.ophtalmologie,
    alertes: [
      'Souvent réalisée sous anesthésie locale/topique — évaluer la coopération du patient',
      'Éviter toute augmentation de la PIO (toux, effort) en peropératoire',
    ],
    recommandations: ['Anesthésie topique ou loco-régionale péribulbaire selon le contexte'],
    consignes: ['Immobilité du patient nécessaire pendant le geste — évaluer la faisabilité sous AL'],
    droguesFavorisees: ['collyre_mydriatique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'decollement_retine',
    nom: 'Décollement de Rétine',
    description: 'Urgence ophtalmologique — chirurgie utilisant parfois un tamponnement gazeux intraoculaire',
    categorie: CategoriePathologie.ophtalmologie,
    alertes: [
      'Protoxyde d\'azote FORMELLEMENT CONTRE-INDIQUÉ si tamponnement gazeux intraoculaire (SF6/C3F8) — risque d\'expansion de la bulle et de cécité',
      'Cette contre-indication persiste plusieurs semaines après une chirurgie antérieure avec gaz intraoculaire (jusqu\'à 3 mois pour le C3F8)',
      'Éviter toute manœuvre augmentant la PIO (toux, effort, hypertension)',
    ],
    recommandations: [
      'Vérifier systématiquement l\'antécédent de tamponnement gazeux avant toute anesthésie ultérieure',
      'Anesthésie loco-régionale péribulbaire à privilégier si possible',
    ],
    consignes: ['Interroger systématiquement sur une chirurgie oculaire récente avec injection de gaz'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'corps_etranger_oculaire',
    nom: 'Corps Étranger Oculaire',
    description: 'Traumatisme oculaire ouvert possible — éviter toute élévation de la PIO',
    categorie: CategoriePathologie.ophtalmologie,
    alertes: [
      'Globe oculaire ouvert possible — succinylcholine CONTRE-INDIQUÉE (augmente la PIO, risque d\'extrusion du contenu oculaire)',
      'Éviter toute toux, effort ou pression sur le globe (masque facial, laryngoscopie brutale)',
      'Estomac plein fréquent (contexte traumatique) — dilemme induction séquence rapide/PIO à discuter',
    ],
    recommandations: [
      'Curare non dépolarisant à délai d\'action rapide (rocuronium) préféré si séquence rapide nécessaire',
      'Propofol pour l\'induction — effet favorable sur la PIO',
      'Antiémétiques prophylactiques systématiques',
    ],
    consignes: ['Protection du globe oculaire jusqu\'à la prise en charge chirurgicale'],
    droguesFavorisees: ['propofol', 'rocuronium'],
    contreIndications: ['succinylcholine'],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║   RHUMATOLOGIE / ORTHOPÉDIE (AJOUTS) ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'arthrose',
    nom: 'Arthrose',
    description: 'Dégénérescence articulaire chronique — analgésie adaptée, mobilité limitée',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: ['Mobilité articulaire limitée — évaluer le positionnement peropératoire (rachis cervical notamment)'],
    recommandations: ['Analgésie multimodale adaptée', 'Précautions de positionnement si arthrose cervicale sévère'],
    consignes: ['Évaluer l\'amplitude d\'ouverture buccale et de mobilité cervicale avant l\'anesthésie'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'polyarthrite_rhumatoide',
    nom: 'Polyarthrite Rhumatoïde',
    description: 'Maladie auto-immune articulaire — risque d\'instabilité cervicale et d\'intubation difficile',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: [
      'Instabilité atlanto-axoïdienne possible — risque de lésion médullaire lors de la laryngoscopie',
      'Atteinte temporo-mandibulaire fréquente — risque d\'ouverture buccale limitée (intubation difficile)',
      'Corticothérapie et immunosuppresseurs de fond — risque infectieux et insuffisance surrénalienne fonctionnelle',
    ],
    recommandations: [
      'Radiographie cervicale (clichés dynamiques) si suspicion d\'instabilité atlanto-axoïdienne',
      'Intubation vigile ou fibroscopique si instabilité cervicale ou ouverture buccale limitée',
      'Matériel d\'intubation difficile systématiquement disponible',
      'Hémisuccinate d\'hydrocortisone à discuter si corticothérapie prolongée (couverture du stress chirurgical)',
    ],
    consignes: [
      'Évaluation de la mobilité cervicale et de l\'ouverture buccale en préopératoire',
      'Positionnement prudent en peropératoire (minerve cervicale à discuter si instabilité sévère)',
    ],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'goutte',
    nom: 'Goutte',
    description: 'Arthropathie microcristalline — crises douloureuses, interactions médicamenteuses',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: [
      'Crise de goutte peropératoire possible en cas de jeûne prolongé ou de déshydratation',
      'AINS et colchicine : prudence si insuffisance rénale associée (fréquente sur ce terrain)',
    ],
    recommandations: [
      'Hydratation adéquate périopératoire — prévient le déclenchement d\'une crise',
      'Colchicine ou AINS à faible dose en cas de crise, selon la fonction rénale',
    ],
    consignes: ['Vérifier la fonction rénale avant prescription d\'AINS'],
    droguesFavorisees: ['ketoprofene'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'lombalgie',
    nom: 'Lombalgie',
    description: 'Douleur lombaire commune — analgésie multimodale, positionnement adapté',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: ['Positionnement peropératoire à adapter — éviter l\'hyperextension lombaire prolongée'],
    recommandations: ['Analgésie multimodale adaptée', 'Coussins de soutien lombaire en décubitus dorsal prolongé'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'sciatique',
    nom: 'Sciatique',
    description: 'Douleur radiculaire du membre inférieur — analgésie multimodale',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: ['Positionnement peropératoire à adapter en cas de radiculalgie sévère'],
    recommandations: ['Analgésie multimodale — antalgiques neuropathiques si composante chronique'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'cervicalgie',
    nom: 'Cervicalgie',
    description: 'Douleur cervicale commune — évaluer la mobilité avant intubation',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: ['Évaluer la mobilité cervicale avant toute laryngoscopie directe — risque d\'intubation difficile si limitation sévère'],
    recommandations: ['Vidéolaryngoscope à disposition si mobilité cervicale limitée'],
    consignes: ['Positionnement prudent en peropératoire'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'fracture',
    nom: 'Fracture',
    description: 'Traumatisme osseux — risque d\'embolie graisseuse, douleur intense, estomac plein si urgence',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: [
      'Risque de syndrome d\'embolie graisseuse (fractures des os longs/bassin) — surveiller détresse respiratoire J1-J3',
      'Estomac plein fréquent (contexte traumatique/urgence) — induction en séquence rapide',
      'Douleur intense — analgésie précoce et efficace nécessaire',
      'Rechercher des lésions associées en contexte de polytraumatisme',
    ],
    recommandations: [
      'Analgésie multimodale précoce (bloc régional si possible)',
      'Immobilisation adéquate avant tout transport/mobilisation',
      'Surveillance respiratoire rapprochée si fracture des os longs (embolie graisseuse)',
    ],
    consignes: ['Bilan radiologique complet', 'Surveillance neurovasculaire du membre atteint'],
    droguesFavorisees: ['fentanyl'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'entorse',
    nom: 'Entorse',
    description: 'Lésion ligamentaire — analgésie standard, peu de retentissement anesthésique',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: ['Peu de retentissement anesthésique spécifique'],
    recommandations: ['Analgésie multimodale standard'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'luxation',
    nom: 'Luxation',
    description: 'Déplacement articulaire — sédation ou anesthésie brève pour réduction',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: ['Réduction souvent réalisée sous sédation procédurale — évaluer le jeûne préalable'],
    recommandations: ['Sédation procédurale titrée (kétamine ou propofol) pour la réduction'],
    consignes: ['Surveillance neurovasculaire du membre atteint avant/après réduction'],
    droguesFavorisees: ['ketamine', 'propofol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'tendinite',
    nom: 'Tendinite',
    description: 'Inflammation tendineuse — peu de retentissement anesthésique',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: ['Peu de retentissement anesthésique spécifique'],
    recommandations: ['Analgésie multimodale standard'],
    consignes: ['Aucune précaution spécifique supplémentaire nécessaire'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'osteoporose',
    nom: 'Ostéoporose',
    description: 'Fragilité osseuse — risque de fracture au positionnement, syndrome de ciment osseux',
    categorie: CategoriePathologie.rhumatologieOrthopedie,
    alertes: [
      'Fragilité osseuse — manipulations et positionnement à réaliser avec prudence extrême',
      'Risque de fracture peropératoire lors de la mobilisation ou de l\'installation',
      'Syndrome d\'implantation du ciment osseux (BCIS) possible en chirurgie prothétique — hypotension, hypoxie',
    ],
    recommandations: [
      'Mobilisation et installation douces, en évitant les leviers articulaires forcés',
      'Surveillance hémodynamique rapprochée lors de la pose de ciment osseux',
    ],
    consignes: ['Coussinage renforcé de tous les points d\'appui'],
    droguesFavorisees: ['acide_zoledronique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       PSYCHIATRIE (AJOUTS)       ║
  // ╚══════════════════════════════════╝

  Pathologie(
    id: 'depression',
    nom: 'Dépression',
    description: 'Trouble de l\'humeur — interactions médicamenteuses avec les antidépresseurs',
    categorie: CategoriePathologie.psychiatrie,
    alertes: [
      'IMAO : interactions sévères avec la péthidine et les sympathomimétiques indirects (éphédrine) — risque de syndrome sérotoninergique/crise hypertensive',
      'ISRS/IRSNa : risque de syndrome sérotoninergique en association avec le tramadol ou le fentanyl à forte dose',
      'Antidépresseurs tricycliques : risque arythmogène, potentialisation des catécholamines',
    ],
    recommandations: [
      'Poursuivre le traitement antidépresseur habituel (ne pas interrompre brutalement)',
      'Éviter la péthidine et le tramadol si IMAO en cours',
      'Privilégier l\'éphédrine avec prudence ou la phényléphrine en cas d\'hypotension sous IMAO',
    ],
    consignes: ['Vérifier le traitement antidépresseur en cours et ses interactions'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'trouble_anxieux',
    nom: 'Trouble Anxieux',
    description: 'Anxiété chronique — prémédication anxiolytique bénéfique',
    categorie: CategoriePathologie.psychiatrie,
    alertes: ['Anxiété périopératoire majorée — impact possible sur la douleur perçue et la consommation d\'analgésiques'],
    recommandations: ['Prémédication anxiolytique à discuter (benzodiazépine à faible dose)', 'Communication rassurante renforcée'],
    consignes: ['Poursuivre le traitement anxiolytique de fond habituel'],
    droguesFavorisees: ['midazolam'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'trouble_panique',
    nom: 'Trouble Panique',
    description: 'Attaques de panique récurrentes — prémédication anxiolytique et réassurance',
    categorie: CategoriePathologie.psychiatrie,
    alertes: ['Risque de crise de panique périopératoire — symptômes pouvant mimer une urgence cardiorespiratoire'],
    recommandations: ['Prémédication anxiolytique à discuter', 'Environnement calme et rassurant en préopératoire'],
    consignes: ['Poursuivre le traitement de fond habituel'],
    droguesFavorisees: ['midazolam'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'trouble_bipolaire',
    nom: 'Trouble Bipolaire',
    description: 'Trouble de l\'humeur — interactions du lithium avec les curares et diurétiques',
    categorie: CategoriePathologie.psychiatrie,
    alertes: [
      'Lithium : potentialise et prolonge l\'effet des curares non dépolarisants',
      'Lithium : marge thérapeutique étroite — AINS et diurétiques augmentent la lithiémie (toxicité)',
      'Interruption brutale du traitement thymorégulateur : risque de décompensation de l\'humeur',
    ],
    recommandations: [
      'Poursuivre le lithium en périopératoire sauf avis psychiatrique contraire',
      'Réduire les doses de curares non dépolarisants et monitorer le TOF',
      'Éviter les AINS chez le patient sous lithium',
    ],
    consignes: ['Vérifier la lithiémie récente si disponible'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 0.7,
        note: 'Potentialisation par le lithium — réduire la dose et monitorer le TOF',
      ),
    ],
  ),

  Pathologie(
    id: 'schizophrenie',
    nom: 'Schizophrénie',
    description: 'Trouble psychotique chronique — interactions des antipsychotiques, allongement du QT',
    categorie: CategoriePathologie.psychiatrie,
    alertes: [
      'Antipsychotiques : allongement du QT possible — prudence avec les agents allongeant le QT',
      'Risque de syndrome malin des neuroleptiques — surveillance thermique peropératoire',
      'Clozapine : risque d\'agranulocytose — vérifier la NFS si traitement en cours',
    ],
    recommandations: [
      'Poursuivre le traitement antipsychotique habituel (éviter toute interruption brutale)',
      'ECG préopératoire si traitement antipsychotique à risque d\'allongement du QT',
      'Éviter les antiémétiques dopaminergiques en cas de traitement par clozapine',
    ],
    consignes: ['Surveillance thermique peropératoire', 'NFS récente si traitement par clozapine'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'insomnie',
    nom: 'Insomnie',
    description: 'Trouble du sommeil chronique — tolérance possible aux sédatifs',
    categorie: CategoriePathologie.psychiatrie,
    alertes: ['Tolérance possible aux benzodiazépines/hypnotiques en cas d\'usage chronique — besoins majorés'],
    recommandations: ['Adapter les doses de prémédication en cas de traitement hypnotique chronique'],
    consignes: ['Poursuivre le traitement hypnotique habituel si non contre-indiqué'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║   GYNÉCOLOGIE / OBSTÉTRIQUE (AJOUTS) ║
  // ╚══════════════════════════════════╝
  //  NOTE : Grossesse Normale est couverte par 'grossesse' déjà
  //  existante — non dupliquée.

  Pathologie(
    id: 'preeclampsie',
    nom: 'Pré-éclampsie',
    description: 'HTA gravidique avec protéinurie — risque maternel et fœtal majeur',
    categorie: CategoriePathologie.obstetrique,
    alertes: [
      'Magnésium sulfate en cours — potentialise et prolonge les curares non dépolarisants',
      'Thrombopénie et coagulopathie possibles — vérifier avant toute anesthésie périmédullaire',
      'HTA sévère — contrôle tensionnel avant l\'induction (risque d\'AVC hémorragique maternel)',
      'Œdème des voies aériennes fréquent — intubation potentiellement difficile',
    ],
    recommandations: [
      'Labétalol ou nicardipine pour le contrôle tensionnel',
      'Anesthésie périmédullaire précoce si plaquettes >75-100 000/mm³ et absence de coagulopathie',
      'Réduire la dose de curares non dépolarisants (potentialisation par le magnésium)',
    ],
    consignes: [
      'Bilan de coagulation et plaquettes avant toute anesthésie périmédullaire',
      'Surveillance stricte de la PA et de la protéinurie',
      'Matériel d\'intubation difficile disponible (œdème des voies aériennes)',
    ],
    droguesFavorisees: ['labetalol', 'nicardipine'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 0.7,
        note: 'Potentialisation par le sulfate de magnésium — réduire la dose et monitorer le TOF',
      ),
    ],
  ),

  Pathologie(
    id: 'eclampsie',
    nom: 'Éclampsie',
    description: 'Convulsions généralisées sur pré-éclampsie — urgence materno-fœtale',
    categorie: CategoriePathologie.obstetrique,
    alertes: [
      'Urgence vitale materno-fœtale — convulsions généralisées',
      'Magnésium sulfate : traitement de référence — potentialise les curares non dépolarisants',
      'Coagulopathie et thrombopénie possibles — anesthésie périmédullaire souvent contre-indiquée en urgence',
    ],
    recommandations: [
      'Sulfate de magnésium IV — traitement et prévention des récidives convulsives',
      'Anesthésie générale souvent nécessaire en urgence (troubles de conscience, coagulopathie)',
      'Contrôle tensionnel agressif (labétalol, nicardipine)',
    ],
    consignes: [
      'Extraction fœtale en urgence si état maternel ou fœtal préoccupant',
      'Surveillance neurologique et tensionnelle rapprochée en post-partum immédiat',
    ],
    droguesFavorisees: ['labetalol', 'nicardipine'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 0.7,
        note: 'Potentialisation par le sulfate de magnésium — réduire la dose et monitorer le TOF',
      ),
    ],
  ),

  Pathologie(
    id: 'grossesse_extra_uterine',
    nom: 'Grossesse Extra-Utérine',
    description: 'Nidation ectopique — risque de rupture tubaire et d\'hémorragie interne massive',
    categorie: CategoriePathologie.obstetrique,
    alertes: [
      'Risque de rupture tubaire et d\'hémorragie interne massive — urgence chirurgicale potentielle',
      'Estomac plein — induction en séquence rapide',
      'Hypovolémie possible si rupture — évaluer l\'état hémodynamique avant l\'induction',
    ],
    recommandations: [
      'Étomidate ou kétamine pour l\'induction si instabilité hémodynamique',
      'Groupe sanguin, RAI et culots globulaires disponibles avant l\'intervention',
    ],
    consignes: [
      'Bilan hémodynamique et échographie en urgence',
      'Voies veineuses de gros calibre si suspicion de rupture',
    ],
    droguesFavorisees: ['etomidate', 'ketamine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'menace_accouchement_premature',
    nom: 'Menace d\'Accouchement Prématuré',
    description: 'Risque d\'accouchement avant terme — tocolytiques en cours',
    categorie: CategoriePathologie.obstetrique,
    alertes: [
      'Tocolytiques en cours (inhibiteurs calciques, bêta-mimétiques) — interactions hémodynamiques possibles',
      'Corticothérapie de maturation pulmonaire fœtale fréquente — vérifier le contexte',
      'Estomac plein après 14-16 SA — SRI si anesthésie générale nécessaire',
    ],
    recommandations: [
      'Prise en charge anesthésique standard de la grossesse (se référer à \'Grossesse\')',
      'Vérifier les traitements tocolytiques en cours et leurs interactions',
    ],
    consignes: [
      'Décubitus latéral gauche après 20 SA',
      'Monitorage du rythme cardiaque fœtal si disponible',
    ],
    droguesFavorisees: ['nifedipine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'hemorragie_postpartum',
    nom: 'Hémorragie du Postpartum',
    description: 'Urgence obstétricale vitale — hypovolémie aiguë majeure',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Urgence vitale — hypovolémie aiguë majeure, transfusion massive possible',
      'Ergométrine CONTRE-INDIQUÉE si HTA/prééclampsie associée — risque de crise hypertensive',
      'Propofol et thiopental : prudence extrême — risque de collapsus si hypovolémie non corrigée',
    ],
    recommandations: [
      'Oxytocine en 1ère intention pour l\'atonie utérine',
      'Remplissage vasculaire et transfusion précoce (protocole transfusion massive si besoin)',
      'Étomidate ou kétamine pour l\'induction si anesthésie générale nécessaire',
    ],
    consignes: [
      'Activation du protocole hémorragie du post-partum local',
      'Culots globulaires, PFC et fibrinogène disponibles en urgence',
      'Surveillance hémodynamique invasive si instabilité',
    ],
    droguesFavorisees: ['etomidate', 'ketamine', 'noradrenaline', 'ringer_lactate'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'propofol',
        facteur: 0.5,
        note: 'Réduire fortement la dose — risque de collapsus si hypovolémie non corrigée',
      ),
    ],
  ),

  Pathologie(
    id: 'mastite',
    nom: 'Mastite',
    description: 'Infection mammaire — évaluer les critères de gravité avant l\'anesthésie',
    categorie: CategoriePathologie.infectieuxObstetrical,
    alertes: ['Infection mammaire — évaluer les critères de gravité (abcès, sepsis) avant l\'anesthésie'],
    recommandations: [
      'Antibiothérapie poursuivie en périopératoire',
      'Analgésie multimodale — douleur locale souvent importante',
    ],
    consignes: ['Poursuite de l\'allaitement à évaluer selon les molécules utilisées'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'endometrite',
    nom: 'Endométrite',
    description: 'Infection utérine post-partum ou post-abortum — risque de sepsis',
    categorie: CategoriePathologie.infectieuxObstetrical,
    alertes: ['Risque de sepsis post-partum ou post-abortum — évaluer les critères de gravité'],
    recommandations: [
      'Antibiothérapie débutée avant tout geste si signes de gravité',
      'Remplissage vasculaire si signes de sepsis',
    ],
    consignes: ['Bilan biologique (NFS, CRP, hémocultures) si signes de gravité'],
    droguesFavorisees: ['noradrenaline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'kyste_ovarien',
    nom: 'Kyste Ovarien',
    description: 'Formation kystique ovarienne — risque de torsion ou de rupture',
    categorie: CategoriePathologie.gynecologie,
    alertes: [
      'Risque de torsion ou de rupture — douleur aiguë, possible hémopéritoine',
      'Estomac plein si chirurgie en urgence',
    ],
    recommandations: [
      'Induction en séquence rapide si chirurgie en urgence (torsion, rupture)',
      'Analgésie multimodale',
    ],
    consignes: ['Échographie pelvienne pour caractériser le kyste'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'fibrome_uterin',
    nom: 'Fibrome Utérin',
    description: 'Tumeur bénigne utérine — anémie chronique possible, compression vasculaire si volumineux',
    categorie: CategoriePathologie.gynecologie,
    alertes: [
      'Anémie chronique possible si ménorragies associées — bilan préopératoire recommandé',
      'Volumineux fibromes : compression vasculaire (veine cave) possible en décubitus dorsal',
    ],
    recommandations: [
      'NFS préopératoire — corriger une anémie chronique si présente',
      'Décubitus latéral gauche partiel si compression cave suspectée',
    ],
    consignes: ['Groupe sanguin et RAI si risque hémorragique per-chirurgical élevé'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'sopk',
    nom: 'Syndrome des Ovaires Polykystiques',
    description: 'Trouble endocrinien fréquent — insulinorésistance et comorbidités métaboliques',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Association fréquente avec obésité, insulinorésistance et diabète — évaluer les comorbidités',
      'Risque cardiovasculaire cumulé (syndrome métabolique associé)',
    ],
    recommandations: [
      'Bilan métabolique préopératoire si comorbidités associées (se référer à \'Syndrome Métabolique\')',
      'Adapter les doses au poids réel/idéal selon l\'agent si obésité associée',
    ],
    consignes: ['Glycémie préopératoire si insulinorésistance connue'],
    droguesFavorisees: ['metformine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       URGENCES (AJOUTS)          ║
  // ╚══════════════════════════════════╝
  //  NOTE : Choc Hypovolémique est couvert par 'choc_hemorragique'
  //  déjà existante (principes hémodynamiques identiques) — non dupliqué.

  Pathologie(
    id: 'choc_septique',
    nom: 'Choc Septique',
    description: 'Défaillance circulatoire d\'origine infectieuse — vasoplégie et hypovolémie relative',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Vasoplégie majeure — réduire fortement les doses d\'induction (agents vasodilatateurs mal tolérés)',
      'Propofol et thiopental : prudence extrême — risque de collapsus cardiovasculaire',
      'Acidose et coagulopathie fréquentes — bilan biologique urgent',
    ],
    recommandations: [
      'Noradrénaline en 1ère ligne pour le support hémodynamique',
      'Étomidate ou kétamine pour l\'induction — meilleure tolérance hémodynamique',
      'Remplissage vasculaire guidé associé aux vasopresseurs',
    ],
    consignes: [
      'Antibiothérapie probabiliste dans l\'heure suivant le diagnostic',
      'Lactates, hémocultures et bilan infectieux en urgence',
      'Monitorage hémodynamique invasif',
    ],
    droguesFavorisees: ['etomidate', 'ketamine', 'noradrenaline', 'ringer_lactate', 'hydrocortisone'],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'propofol',
        facteur: 0.3,
        note: 'Réduire très fortement la dose ou éviter — risque de collapsus majeur',
      ),
    ],
  ),

  Pathologie(
    id: 'choc_cardiogenique',
    nom: 'Choc Cardiogénique',
    description: 'Défaillance de la pompe cardiaque — bas débit sévère',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Tout agent inotrope négatif mal toléré — propofol et thiopental à éviter ou réduire fortement',
      'Marge hémodynamique très étroite — titration extrêmement prudente de tous les agents',
    ],
    recommandations: [
      'Étomidate pour l\'induction — stabilité hémodynamique maximale',
      'Dobutamine ou milrinone pour le support inotrope',
      'Noradrénaline si composante vasoplégique associée',
    ],
    consignes: [
      'Échocardiographie pour évaluer la fonction ventriculaire',
      'Monitorage hémodynamique invasif systématique',
    ],
    droguesFavorisees: ['etomidate', 'dobutamine', 'milrinone'],
    contreIndications: ['propofol', 'thiopental'],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'choc_anaphylactique',
    nom: 'Choc Anaphylactique',
    description: 'Réaction allergique sévère peropératoire — urgence vitale immédiate',
    categorie: CategoriePathologie.allergique,
    alertes: [
      'Urgence vitale — adrénaline IMMÉDIATE en 1ère intention (titration IV en contexte peropératoire)',
      'Arrêter immédiatement l\'exposition à l\'agent suspecté (curare, latex, antibiotique, chlorhexidine)',
      'Curares : cause la plus fréquente d\'anaphylaxie peropératoire — suspecter en priorité',
    ],
    recommandations: [
      'Adrénaline titrée IV — bolus répétés selon la sévérité',
      'Remplissage vasculaire massif (vasoplégie et fuite capillaire)',
      'Arrêt de tous les agents administrés récemment, maintien des seuls agents indispensables',
    ],
    consignes: [
      'Bilan allergologique à distance (tryptase à H+1-2, puis tests cutanés à 4-6 semaines)',
      'Déclaration de pharmacovigilance systématique',
      'Consultation d\'allergo-anesthésie avant toute anesthésie ultérieure',
    ],
    droguesFavorisees: ['adrenaline', 'dexchlorpheniramine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'polytraumatisme',
    nom: 'Polytraumatisme',
    description: 'Lésions multiples engageant le pronostic vital — hypovolémie, estomac plein',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Estomac plein systématique — induction en séquence rapide',
      'Hypovolémie hémorragique fréquente — réduire les doses d\'induction',
      'Suspicion de traumatisme rachidien jusqu\'à preuve du contraire — immobilisation cervicale',
      'Succinylcholine : prudence si délai >24-48h ou brûlures/écrasements étendus (hyperkaliémie)',
    ],
    recommandations: [
      'Étomidate ou kétamine pour l\'induction — meilleure tolérance hémodynamique',
      'Stabilisation en ligne du rachis cervical lors de l\'intubation',
      'Transfusion précoce et acide tranexamique si hémorragie active',
    ],
    consignes: [
      'Bilan lésionnel complet (imagerie corps entier selon protocole)',
      'Réévaluation hémodynamique répétée (ABCDE)',
      'Groupe sanguin, RAI et culots disponibles en urgence',
    ],
    droguesFavorisees: ['etomidate', 'ketamine', 'ringer_lactate'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'brulure',
    nom: 'Brûlure',
    description: 'Lésion thermique étendue — hyperkaliémie sous succinylcholine, résistance aux curares',
    categorie: CategoriePathologie.traumatologieUrgences,
    alertes: [
      'Succinylcholine CONTRE-INDIQUÉE après les 24 premières heures — risque d\'hyperkaliémie sévère (persiste jusqu\'à 1-2 ans)',
      'Résistance aux curares non dépolarisants — up-régulation des récepteurs nicotiniques',
      'Pertes hydriques majeures — remplissage vasculaire majeur selon la surface brûlée',
      'Œdème des voies aériennes si brûlure faciale/inhalation — intubation précoce à discuter',
    ],
    recommandations: [
      'Rocuronium à dose augmentée si curarisation nécessaire après 24h (résistance)',
      'Remplissage vasculaire guidé selon la surface cutanée brûlée (formule de Parkland ou équivalent)',
      'Analgésie multimodale à forte dose — douleur majeure et tolérance rapide aux opioïdes',
    ],
    consignes: [
      'Évaluation précoce des voies aériennes si brûlure de la face/du cou',
      'Réchauffement actif systématique (pertes thermiques majeures)',
      'Surveillance de la kaliémie avant toute utilisation de succinylcholine',
    ],
    droguesFavorisees: ['ringer_lactate'],
    contreIndications: ['succinylcholine'],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'rocuronium',
        facteur: 1.5,
        note: 'Résistance aux curares non dépolarisants après 24h — augmenter la dose de 50%',
      ),
    ],
  ),

  Pathologie(
    id: 'intoxication_medicamenteuse',
    nom: 'Intoxication Médicamenteuse',
    description: 'Ingestion toxique — évaluer la molécule en cause et l\'état de conscience',
    categorie: CategoriePathologie.toxicologie,
    alertes: [
      'Estomac plein systématique — induction en séquence rapide si anesthésie nécessaire',
      'Interactions potentielles avec le toxique en cause — identifier la molécule ingérée',
      'Troubles de conscience possibles — protection des voies aériennes à évaluer',
    ],
    recommandations: [
      'Antidote spécifique si disponible et identifié',
      'Réduire les doses d\'agents dépresseurs si toxique lui-même dépresseur du SNC',
    ],
    consignes: [
      'Identifier la molécule et la dose ingérée avec l\'entourage/dossier médical',
      'ECG et bilan toxicologique si disponible',
    ],
    droguesFavorisees: ['naloxone'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'intoxication_co',
    nom: 'Intoxication au Monoxyde de Carbone',
    description: 'Hypoxie tissulaire malgré une SpO2 normale — oxygénothérapie à haute concentration',
    categorie: CategoriePathologie.toxicologie,
    alertes: [
      'SpO2 faussement normale — le saturomètre ne différencie pas HbCO et HbO2',
      'Hypoxie tissulaire sévère possible malgré une SpO2 normale',
      'Protoxyde d\'azote à éviter — n\'améliore pas l\'oxygénation tissulaire dans ce contexte',
    ],
    recommandations: [
      'Oxygénothérapie à FiO2 100% dès la suspicion diagnostique',
      'Oxygénothérapie hyperbare à discuter selon la sévérité et le contexte (grossesse, troubles de conscience)',
    ],
    consignes: [
      'Dosage de la carboxyhémoglobine (HbCO) en urgence',
      'ECG (risque d\'ischémie myocardique associée)',
    ],
    droguesFavorisees: ['oxygene_medical'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'morsure_chien',
    nom: 'Morsure de Chien',
    description: 'Plaie traumatique et infectieuse — risque rabique et tétanique à évaluer',
    categorie: CategoriePathologie.infectieux,
    alertes: [
      'Risque infectieux élevé — plaie souillée, flore polymicrobienne',
      'Statut vaccinal antitétanique et risque rabique à évaluer systématiquement',
    ],
    recommandations: [
      'Antibioprophylaxie adaptée (amoxicilline-acide clavulanique habituellement)',
      'Parage chirurgical de la plaie sous anesthésie adaptée',
    ],
    consignes: [
      'Vérifier le statut vaccinal antitétanique',
      'Évaluer le risque rabique selon le contexte épidémiologique local',
    ],
    droguesFavorisees: ['amoxicilline_clavulanate'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'piqure_scorpion',
    nom: 'Piqûre de Scorpion',
    description: 'Envenimation — orage sympathique possible dans les formes sévères',
    categorie: CategoriePathologie.toxicologie,
    alertes: [
      'Orage sympathique possible dans les formes sévères — tachycardie, HTA, œdème pulmonaire',
      'Douleur locale intense — analgésie rapide nécessaire',
      'Formes graves surtout chez l\'enfant — surveillance rapprochée',
    ],
    recommandations: [
      'Sérum antivenimeux spécifique si disponible et forme sévère',
      'Analgésie multimodale pour la douleur locale',
      'Support hémodynamique si orage sympathique sévère',
    ],
    consignes: [
      'Surveillance cardiorespiratoire rapprochée dans les 6-12h suivant la piqûre',
      'ECG si signes de gravité',
    ],
    droguesFavorisees: ['serum_antiscorpionique'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'envenimation_serpent',
    nom: 'Envenimation par Serpent',
    description: 'Morsure venimeuse — risque de coagulopathie et de syndrome des loges',
    categorie: CategoriePathologie.toxicologie,
    alertes: [
      'Coagulopathie possible — vérifier le bilan de coagulation avant tout geste invasif',
      'Risque de syndrome des loges au niveau du membre atteint — surveillance neurovasculaire',
      'Éviter les injections intramusculaires (risque hémorragique local si coagulopathie)',
    ],
    recommandations: [
      'Sérum antivenimeux spécifique si disponible et indiqué',
      'Analgésie multimodale — éviter la voie intramusculaire',
    ],
    consignes: [
      'Bilan de coagulation répété',
      'Surveillance neurovasculaire du membre atteint (syndrome des loges)',
      'Vaccination antitétanique à vérifier',
    ],
    droguesFavorisees: ['serum_antivenimeux_polyvalent'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       HÉMATOLOGIE (AJOUTS)       ║
  // ╚══════════════════════════════════╝
  //  NOTE : classées en 'autre' (catégorie résiduelle) plutôt que dans
  //  une nouvelle catégorie 'hematologique' dédiée, pour éviter de
  //  casser les switch exhaustifs de pathologie.dart / ecran_pathologies.dart
  //  (voir mon message précédent sur ce point).

  Pathologie(
    id: 'anemie_ferriprive',
    nom: 'Anémie Ferriprive',
    description: 'Carence martiale — réserve cardiaque limitée, tolérance à l\'hypoxémie réduite',
    categorie: CategoriePathologie.hematologie,
    alertes: [
      'Anémie chronique — tolérance à l\'hypoxémie réduite, réserve cardiaque limitée',
      'Réserves martiales à corriger avant chirurgie élective si possible (fer, EPO)',
    ],
    recommandations: [
      'NFS préopératoire systématique — évaluer le seuil transfusionnel selon le contexte',
      'Optimisation préopératoire du fer si délai suffisant avant chirurgie programmée',
    ],
    consignes: ['Seuil transfusionnel à discuter selon la tolérance clinique et le type de chirurgie'],
    droguesFavorisees: ['fer_carboxymaltose'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'drepanocytose',
    nom: 'Drépanocytose',
    description: 'Hémoglobinopathie — risque de crise vaso-occlusive sur hypoxie/froid/déshydratation/acidose',
    categorie: CategoriePathologie.hematologie,
    alertes: [
      'Hypoxie, hypothermie, déshydratation et acidose déclenchent les crises vaso-occlusives — à éviter absolument',
      'Garrot pneumatique déconseillé — favorise la stase et la falciformation locale',
      'Anémie chronique — évaluer le seuil transfusionnel préopératoire',
    ],
    recommandations: [
      'Oxygénothérapie généreuse peropératoire — maintenir une SpO2 élevée',
      'Réchauffement actif systématique, hydratation IV généreuse périopératoire',
      'Transfusion préopératoire à discuter selon le type de chirurgie et le taux d\'HbS',
    ],
    consignes: [
      'Éviter tout garrot pneumatique si possible',
      'Normothermie stricte peropératoire',
      'Surveillance postopératoire prolongée (risque de crise vaso-occlusive différée)',
    ],
    droguesFavorisees: ['hydroxyuree'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'thalassemie',
    nom: 'Thalassémie',
    description: 'Hémoglobinopathie — anémie chronique, surcharge en fer si transfusions itératives',
    categorie: CategoriePathologie.hematologie,
    alertes: [
      'Anémie chronique, parfois sévère selon la forme (majeure/intermédiaire)',
      'Surcharge en fer possible si transfusions itératives — évaluer la fonction cardiaque et hépatique',
    ],
    recommandations: [
      'NFS et bilan martial préopératoires',
      'Évaluation cardiaque (IRM cardiaque T2*) si surcharge en fer suspectée et chirurgie majeure',
    ],
    consignes: ['Seuil transfusionnel à discuter selon la forme et le contexte chirurgical'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'purpura_thrombopenique',
    nom: 'Purpura Thrombopénique',
    description: 'Thrombopénie — risque hémorragique, contre-indication fréquente à l\'ALR périmédullaire',
    categorie: CategoriePathologie.hematologie,
    alertes: [
      'Thrombopénie — risque hémorragique, anesthésie périmédullaire souvent contre-indiquée si plaquettes basses',
      'Corticothérapie ou immunosuppresseurs de fond possibles',
    ],
    recommandations: [
      'Numération plaquettaire récente indispensable avant toute anesthésie périmédullaire',
      'Transfusion plaquettaire à discuter selon le seuil et le geste prévu',
    ],
    consignes: [
      'Vérifier le taux de plaquettes le jour de la chirurgie',
      'Privilégier l\'anesthésie générale si plaquettes <50 000/mm³ et geste à risque hémorragique',
    ],
    droguesFavorisees: ['dexamethasone'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'leucemie_aigue',
    nom: 'Leucémie Aiguë',
    description: 'Hémopathie maligne — pancytopénie, risque infectieux et hémorragique combinés',
    categorie: CategoriePathologie.hematologie,
    alertes: [
      'Pancytopénie fréquente — risque infectieux, hémorragique et anémique combiné',
      'Chimiothérapie récente — toxicités d\'organe possibles (cardiaque, hépatique, rénale) selon les molécules',
      'Immunodépression sévère — précautions d\'asepsie renforcées',
    ],
    recommandations: [
      'NFS avec plaquettes et bilan de coagulation systématiques avant tout geste',
      'Transfusion (culots, plaquettes) à discuter selon les seuils et le geste prévu',
      'Antibioprophylaxie renforcée si neutropénie sévère',
    ],
    consignes: [
      'Bilan préopératoire complet incluant fonction cardiaque si chimiothérapie cardiotoxique reçue',
      'Isolement protecteur si neutropénie sévère',
    ],
    droguesFavorisees: ['piperacilline_tazobactam'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'lymphome',
    nom: 'Lymphome',
    description: 'Hémopathie maligne — risque de compression médiastinale par adénopathies volumineuses',
    categorie: CategoriePathologie.hematologie,
    alertes: [
      'Adénopathies volumineuses — risque de compression des voies aériennes (médiastin) ou vasculaire',
      'Chimiothérapie associée — toxicités d\'organe possibles selon les molécules (cardiaque, pulmonaire)',
    ],
    recommandations: [
      'TDM thoracique préopératoire si masse médiastinale suspectée — évaluer le risque de compression',
      'Maintien de la ventilation spontanée à l\'induction si compression trachéale sévère suspectée',
    ],
    consignes: [
      'Évaluation cardiopulmonaire préopératoire si chimiothérapie cardio/pneumotoxique reçue',
      'Position semi-assise à l\'induction si masse médiastinale volumineuse',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║       PÉDIATRIE (AJOUTS)         ║
  // ╚══════════════════════════════════╝
  //  NOTE : la grande majorité des items pédiatriques de la liste
  //  (bronchiolite, GEA, déshydratation, otite, pneumonie, asthme,
  //  convulsion fébrile, RGO, rougeole, varicelle, coqueluche, angine,
  //  sinusite, appendicite, anémie ferriprive...) sont déjà couverts
  //  par les pathologies génériques ajoutées dans les lots précédents,
  //  dont les alertes mentionnent déjà les spécificités pédiatriques.
  //  Seuls les items réellement nouveaux sont ajoutés ci-dessous.

  Pathologie(
    id: 'ictere_neonatal',
    nom: 'Ictère Néonatal',
    description: 'Hyperbilirubinémie du nouveau-né — risque d\'ictère nucléaire si sévère',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Hyperbilirubinémie sévère — risque d\'ictère nucléaire (kernictère) si taux élevé non traité',
      'Certains médicaments déplacent la bilirubine de l\'albumine — vérifier avant utilisation',
      'Prématurité associée fréquente — immaturité hépatique et rénale à considérer',
    ],
    recommandations: [
      'Photothérapie poursuivie si en cours, y compris en périopératoire si possible',
      'Éviter les médicaments à forte liaison protéique déplaçant la bilirubine',
    ],
    consignes: [
      'Bilirubinémie de contrôle avant et après la chirurgie',
      'Réchauffement actif — hypothermie fréquente chez le nouveau-né',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'detresse_respiratoire_neonatale',
    nom: 'Détresse Respiratoire Néonatale',
    description: 'Immaturité pulmonaire — réserve respiratoire très limitée',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Immaturité pulmonaire fréquente chez le prématuré — surfactant parfois nécessaire',
      'Réserve respiratoire très limitée — désaturation rapide à l\'induction',
      'Risque de pneumothorax sous ventilation en pression positive (poumons immatures)',
    ],
    recommandations: [
      'Ventilation protectrice, pressions d\'insufflation limitées',
      'Surfactant exogène disponible si détresse sévère du prématuré',
    ],
    consignes: [
      'Radiographie thoracique de référence avant tout geste',
      'Environnement thermique neutre (incubateur/table radiante)',
    ],
    droguesFavorisees: ['poractant_alfa'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'sepsis_neonatal',
    nom: 'Sepsis Néonatal',
    description: 'Infection systémique du nouveau-né — présentation atypique, choc rapide',
    categorie: CategoriePathologie.infectieux,
    alertes: [
      'Présentation clinique souvent atypique chez le nouveau-né — signes frustes',
      'Risque de choc septique rapide — réserve hémodynamique très limitée',
      'Immaturité immunitaire — risque de dissémination rapide',
    ],
    recommandations: [
      'Antibiothérapie probabiliste débutée en urgence sans retarder la prise en charge',
      'Remplissage vasculaire prudent et titré (petits volumes répétés)',
    ],
    consignes: [
      'Bilan infectieux complet (NFS, CRP, hémocultures, PL selon contexte)',
      'Surveillance thermique et glycémique rapprochée',
    ],
    droguesFavorisees: ['glucose_10'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'prematurite',
    nom: 'Prématurité',
    description: 'Naissance avant terme — immaturité multi-organique, risque d\'apnées',
    categorie: CategoriePathologie.neonatologie,
    alertes: [
      'Immaturité multi-organique (hépatique, rénale, respiratoire, thermique)',
      'Risque d\'apnées périopératoires — surveillance prolongée nécessaire, surtout si âge post-conceptionnel <60 semaines',
      'Persistance du canal artériel possible — retentissement hémodynamique à évaluer',
    ],
    recommandations: [
      'Doses adaptées au poids et à l\'âge post-conceptionnel — métabolisme immature',
      'Réchauffement actif systématique',
    ],
    consignes: [
      'Monitorage apnées/bradycardies en postopératoire (apnées différées possibles)',
      'Glycémie et température surveillées étroitement',
    ],
    droguesFavorisees: ['glucose_10'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'asphyxie_neonatale',
    nom: 'Asphyxie Néonatale',
    description: 'Hypoxo-ischémie périnatale — dysfonction multiviscérale possible',
    categorie: CategoriePathologie.neurologique,
    alertes: [
      'Risque d\'encéphalopathie hypoxo-ischémique — évaluation neurologique répétée',
      'Hypothermie thérapeutique parfois en cours — métabolisme ralenti',
      'Dysfonction multiviscérale possible (rénale, hépatique, cardiaque) post-asphyxie',
    ],
    recommandations: [
      'Réduire les doses si hypothermie thérapeutique en cours (métabolisme ralenti)',
      'Surveillance neurologique et multiviscérale rapprochée',
    ],
    consignes: [
      'Score d\'Apgar et gaz du sang au cordon si disponibles',
      'Bilan multiorganique (fonction rénale, hépatique, cardiaque)',
    ],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [
      DoseAjustee(
        drugId: 'fentanyl',
        facteur: 0.7,
        note: 'Métabolisme ralenti sous hypothermie thérapeutique — réduire la dose',
      ),
    ],
  ),

  Pathologie(
    id: 'scarlatine',
    nom: 'Scarlatine',
    description: 'Infection streptococcique — rechercher des complications post-streptococciques',
    categorie: CategoriePathologie.infectieuxPediatrique,
    alertes: ['Infection à streptocoque — rechercher des complications (glomérulonéphrite, RAA) si non traitée'],
    recommandations: ['Antibiothérapie poursuivie en périopératoire'],
    consignes: ['Isolement gouttelettes jusqu\'à 24h après le début de l\'antibiothérapie'],
    droguesFavorisees: ['amoxicilline'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'allergie_alimentaire',
    nom: 'Allergie Alimentaire',
    description: 'Risque de réaction anaphylactique — vérifier l\'absence de l\'allergène dans les produits utilisés',
    categorie: CategoriePathologie.allergique,
    alertes: [
      'Risque de réaction anaphylactique en cas d\'exposition — vérifier l\'absence de l\'allergène dans les produits utilisés',
      'Terrain atopique souvent associé (asthme, eczéma)',
    ],
    recommandations: [
      'Vérifier la composition des médicaments et dispositifs utilisés (excipients)',
      'Adrénaline immédiatement disponible en salle',
    ],
    consignes: ['Interrogatoire allergologique précis (allergène, sévérité des réactions antérieures)'],
    droguesFavorisees: ['adrenaline', 'dexchlorpheniramine'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'retard_croissance_malnutrition',
    nom: 'Retard de Croissance / Malnutrition',
    description: 'Dénutrition de l\'enfant — hypoglycémie, hypoprotidémie et risque infectieux accrus',
    categorie: CategoriePathologie.metabolique,
    alertes: [
      'Hypoglycémie et hypoprotidémie fréquentes — risque accru de complications périopératoires',
      'Immunodépression relative — risque infectieux périopératoire majoré',
      'Doses médicamenteuses à adapter au poids réel, souvent inférieur à l\'âge',
    ],
    recommandations: [
      'Glycémie préopératoire systématique — prévention de l\'hypoglycémie peropératoire',
      'Adapter les doses au poids réel de l\'enfant',
    ],
    consignes: [
      'Bilan nutritionnel et biologique (albumine, glycémie) préopératoire',
      'Réchauffement actif — hypothermie plus fréquente',
    ],
    droguesFavorisees: ['glucose_10'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  // ╔══════════════════════════════════╗
  // ║  SYMPTÔMES ET SYNDROMES FRÉQUENTS (AJOUTS) ║
  // ╚══════════════════════════════════╝
  //  NOTE : Déshydratation, Convulsion, Hématémèse, Méléna, Anaphylaxie
  //  et Sepsis sont déjà couverts par 'deshydratation', 'epilepsie'/
  //  'crise_convulsive_febrile', 'hemorragie_digestive',
  //  'choc_anaphylactique' et 'choc_septique' — non dupliqués.

  Pathologie(
    id: 'fievre_origine_inconnue',
    nom: 'Fièvre d\'Origine Inconnue',
    description: 'Fièvre prolongée sans cause identifiée — bilan étiologique avant chirurgie élective',
    categorie: CategoriePathologie.infectieux,
    alertes: ['Cause non identifiée — écarter une cause infectieuse active avant toute chirurgie élective'],
    recommandations: ['Bilan étiologique complet avant chirurgie programmée non urgente'],
    consignes: ['Différer la chirurgie élective tant que la cause n\'est pas identifiée si possible'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'syncope',
    nom: 'Syncope',
    description: 'Perte de connaissance brève — écarter une cause cardiaque avant l\'anesthésie',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: ['Écarter une cause cardiaque (trouble du rythme, valvulopathie) avant toute anesthésie élective'],
    recommandations: ['Bilan cardiologique (ECG, échocardiographie) si syncope non expliquée ou récidivante'],
    consignes: ['ECG préopératoire systématique'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'vertige',
    nom: 'Vertige',
    description: 'Sensation de trouble de l\'équilibre — peu de retentissement anesthésique spécifique',
    categorie: CategoriePathologie.traumatologieUrgences,
    alertes: ['Peu de retentissement anesthésique spécifique — rechercher la cause sous-jacente'],
    recommandations: ['Prise en charge anesthésique standard'],
    consignes: ['Antiémétiques prophylactiques recommandés (nausées associées fréquentes)'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'malaise',
    nom: 'Malaise',
    description: 'Symptôme non spécifique — rechercher une cause cardiovasculaire, métabolique ou neurologique',
    categorie: CategoriePathologie.traumatologieUrgences,
    alertes: ['Symptôme non spécifique — rechercher une cause sous-jacente avant chirurgie élective'],
    recommandations: ['Bilan étiologique orienté selon le contexte clinique'],
    consignes: ['Différer la chirurgie élective tant que la cause n\'est pas écartée si suspicion de gravité'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'douleur_thoracique',
    nom: 'Douleur Thoracique',
    description: 'Symptôme d\'alerte — écarter un syndrome coronarien aigu avant toute anesthésie élective',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: ['Écarter un syndrome coronarien aigu (se référer à \'SCA/Infarctus\') avant toute chirurgie élective'],
    recommandations: ['ECG et troponine si douleur récente ou non caractérisée'],
    consignes: ['Différer la chirurgie élective tant que la cause n\'est pas écartée'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'dyspnee',
    nom: 'Dyspnée',
    description: 'Symptôme d\'alerte respiratoire ou cardiaque — bilan étiologique avant anesthésie',
    categorie: CategoriePathologie.respiratoire,
    alertes: ['Rechercher une cause cardiaque ou respiratoire sous-jacente avant toute chirurgie élective'],
    recommandations: ['Bilan cardiorespiratoire orienté (radiographie thoracique, échocardiographie selon contexte)'],
    consignes: ['SpO2 et fréquence respiratoire de référence avant l\'induction'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'douleur_abdominale_aigue',
    nom: 'Douleur Abdominale Aiguë',
    description: 'Symptôme d\'alerte chirurgical — rechercher une cause nécessitant une prise en charge urgente',
    categorie: CategoriePathologie.traumatologieUrgences,
    alertes: [
      'Rechercher une cause chirurgicale urgente (se référer à \'Appendicite\', \'Pancréatite\', \'Cholécystite\')',
      'Estomac plein probable si contexte aigu — induction en séquence rapide si chirurgie en urgence',
    ],
    recommandations: ['Imagerie et bilan biologique orientés selon la localisation et le contexte'],
    consignes: ['Induction en séquence rapide si chirurgie urgente nécessaire'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'fievre_enfant',
    nom: 'Fièvre chez l\'Enfant',
    description: 'Hyperthermie de l\'enfant — risque de convulsion fébrile, contrôle thermique nécessaire',
    categorie: CategoriePathologie.infectieux,
    alertes: [
      'Risque de convulsion fébrile chez le jeune enfant (se référer à \'Crise Convulsive Fébrile\')',
      'Différer la chirurgie élective en phase fébrile aiguë',
    ],
    recommandations: ['Antipyrétiques préopératoires si fièvre significative', 'Contrôle thermique peropératoire'],
    consignes: ['Différer la chirurgie élective jusqu\'à résolution de la fièvre si possible'],
    droguesFavorisees: ['paracetamol'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'polyurie_polydipsie',
    nom: 'Polyurie-Polydipsie',
    description: 'Symptôme évocateur de diabète ou de diabète insipide — bilan métabolique nécessaire',
    categorie: CategoriePathologie.metabolique,
    alertes: ['Évoque un diabète sucré ou un diabète insipide — bilan glycémique et ionique nécessaire'],
    recommandations: ['Glycémie et ionogramme préopératoires', 'Se référer à \'Diabète\' si glycémie confirmée élevée'],
    consignes: ['Bilan étiologique avant chirurgie élective si symptôme non exploré'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'amaigrissement_inexplique',
    nom: 'Amaigrissement Inexpliqué',
    description: 'Perte de poids non volontaire — rechercher une cause organique sous-jacente',
    categorie: CategoriePathologie.traumatologieUrgences,
    alertes: ['Rechercher une cause organique sous-jacente (néoplasique, endocrinienne, infectieuse) avant chirurgie élective'],
    recommandations: ['Bilan nutritionnel et étiologique préopératoire'],
    consignes: ['Évaluation de l\'état nutritionnel (albumine, poids) avant chirurgie majeure'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'adenopathie',
    nom: 'Adénopathie',
    description: 'Augmentation de volume ganglionnaire — évaluer un risque de compression si cervicale/médiastinale',
    categorie: CategoriePathologie.traumatologieUrgences,
    alertes: ['Adénopathie cervicale ou médiastinale volumineuse — évaluer un risque de compression des voies aériennes'],
    recommandations: ['Imagerie cervico-thoracique si adénopathie volumineuse ou suspecte'],
    consignes: ['Évaluation des voies aériennes avant toute anesthésie générale si localisation cervicale'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'oedemes',
    nom: 'Œdèmes',
    description: 'Rétention hydrosodée — rechercher une cause cardiaque, rénale ou hépatique',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: ['Rechercher une cause cardiaque, rénale ou hépatique sous-jacente (se référer aux pathologies correspondantes)'],
    recommandations: ['Bilan cardiorénal et hépatique orienté selon le contexte'],
    consignes: ['Bilan ionique et fonction rénale avant chirurgie élective si œdèmes significatifs'],
    droguesFavorisees: ['furosemide'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'hemoptysie',
    nom: 'Hémoptysie',
    description: 'Saignement d\'origine bronchopulmonaire — risque d\'inondation alvéolaire',
    categorie: CategoriePathologie.respiratoire,
    alertes: [
      'Risque d\'inondation alvéolaire et d\'asphyxie si hémoptysie massive',
      'Isolement pulmonaire (sonde à double lumière) à discuter si hémoptysie massive active',
    ],
    recommandations: ['Imagerie thoracique et bronchoscopie pour localiser la source du saignement'],
    consignes: ['Positionnement en décubitus latéral, poumon sain au-dessus, si origine latéralisée connue'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'rectorragie',
    nom: 'Rectorragie',
    description: 'Saignement digestif bas — évaluer l\'hypovolémie, principes proches de l\'hémorragie digestive',
    categorie: CategoriePathologie.cardiovasculaire,
    alertes: [
      'Hypovolémie possible si saignement abondant — réduire les doses d\'induction si instabilité',
      'Se référer à la pathologie \'Hémorragie Digestive\' pour les principes de prise en charge hémodynamique',
    ],
    recommandations: ['Groupe sanguin, RAI et culots globulaires disponibles si saignement abondant'],
    consignes: ['NFS et bilan de coagulation si saignement significatif'],
    droguesFavorisees: ['nacl_09'],
    contreIndications: [],
    dosesAjustees: [],
  ),

  Pathologie(
    id: 'syndrome_inflammatoire',
    nom: 'Syndrome Inflammatoire',
    description: 'Élévation des marqueurs inflammatoires — rechercher la cause sous-jacente',
    categorie: CategoriePathologie.infectieux,
    alertes: ['Rechercher une cause infectieuse, tumorale ou auto-immune sous-jacente avant chirurgie élective'],
    recommandations: ['Bilan étiologique orienté selon le contexte clinique'],
    consignes: ['Différer la chirurgie élective tant que la cause n\'est pas identifiée si possible'],
    droguesFavorisees: [],
    contreIndications: [],
    dosesAjustees: [],
  ),

]; // ← NE PAS SUPPRIMER

// ══════════════════════════════════════════════════════════════
//  FONCTION REQUISE PAR AppProvider
// ══════════════════════════════════════════════════════════════

List<Pathologie> construirePathologies() =>
    pathologiesData.map((p) => p.copyWith(estSelectionnee: false)).toList();


// ══════════════════════════════════════════════════════════════
//  📋 MODÈLE — COPIER CE BLOC POUR AJOUTER UNE PATHOLOGIE
// ══════════════════════════════════════════════════════════════
//
//  ÉTAPE 1 : Coller ce bloc DANS la liste pathologiesData ci-dessus
//  ÉTAPE 2 : Remplir chaque champ
//  ÉTAPE 3 : Ajouter les règles dans drug_pathology_rules.dart
//            (copier le bloc MODÈLE de ce fichier aussi)
//
// ─────────────────────────────────────────────────────────────
//
//  Pathologie(
//    id: 'mon_id_unique',               // snake_case, UNIQUE dans toute la liste
//    nom: 'Nom Affiché',
//    description: 'Description courte (1 ligne)',
//    categorie: CategoriePathologie.xxx, // voir liste en haut du fichier
//    alertes: [
//      'Danger 1 — texte rouge ⚠️',
//      'Danger 2',
//    ],
//    recommandations: [
//      'Agent préféré 1 — texte vert ✅',
//      'Agent préféré 2',
//    ],
//    consignes: [
//      'Geste pratique 1 — texte bleu 📋',
//      'Geste pratique 2',
//    ],
//    droguesFavorisees: ['propofol', 'fentanyl'],    // IDs — voir liste en haut
//    contreIndications: ['ketamine', 'morphine'],    // IDs — voir liste en haut
//    dosesAjustees: [
//      DoseAjustee(
//        drugId: 'rocuronium',
//        facteur: 0.7,   // 0.7 = réduire de 30%  |  1.3 = augmenter de 30%
//        note: 'Explication de l\'ajustement de dose',
//      ),
//    ],
//  ),
//
// ══════════════════════════════════════════════════════════════