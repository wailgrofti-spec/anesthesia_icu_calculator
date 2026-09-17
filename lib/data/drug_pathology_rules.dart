// ╔══════════════════════════════════════════════════════════════╗
//  lib/data/drug_pathology_rules.dart
//  VERSION 4.0 — RÈGLES MÉDICAMENT ↔ PATHOLOGIE UNIQUEMENT
//
//  ✅ CE FICHIER = seulement les règles DrugPathologyRule(...)
//  ✅ Les Pathologie(...) sont dans pathologies_data.dart
//
//  ─────────────────────────────────────────────────────────────
//  POUR AJOUTER DES RÈGLES À UNE NOUVELLE PATHOLOGIE :
//   1. Créer une nouvelle clé dans pathologyDrugRules
//      ex: 'mon_id_unique': [ ... ]
//   2. Ajouter un DrugPathologyRule(...) par médicament concerné
//   3. L'id doit correspondre EXACTEMENT au champ id de la
//      Pathologie(...) dans pathologies_data.dart
//  ─────────────────────────────────────────────────────────────
//
//  STRUCTURE DE CHAQUE RÈGLE :
//  ┌─ drugId         : ID du médicament (voir liste ci-dessous)
//  ├─ status         : preferred | caution | contraindicated
//  ├─ reason         : explication affichée dans l'app
//  ├─ doseAdjustment : (optionnel) précision sur la dose
//  └─ source         : référence bibliographique
//
//  STATUTS :
//    preferred       → ⭐ Recommandé — bénéfice démontré
//    caution         → ⚠️ Prudence — adapter la dose ou surveiller
//    contraindicated → ❌ Contre-indiqué — risque avéré
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
//  ── Vasopresseurs / Inotropes / Cardiovasculaires ───────────────
//    noradrenaline · adrenaline · ephedrine · dobutamine · atropine
//    phenylephrine · dopamine · vasopressine · milrinone · levosimendan
//    isoprenaline · nitroglycerine · nitroprussiate · nicardipine
//    clevidipine · urapidil · esmolol · labetalol · metoprolol
//    glycopyrrolate · angiotensine2 · terlipressine · bleu_methylene
//    epoprostenol · iloprost · alprostadil
//
//  ⚠️ NOTE VERSION 4.1 : les 21 médicaments ci-dessus (phenylephrine →
//  alprostadil) viennent d'être ajoutés dans classic_drugs_data.dart.
//  Leurs règles de pathologie ci-dessous ne couvrent QUE les pathologies
//  déjà présentes dans ce fichier (hypertension, insuffisance_cardiaque,
//  insuffisance_renale, insuffisance_hepatique, asthme_bronchospasme,
//  bpco, grossesse). Des pathologies citées par l'utilisateur — hypotension,
//  choc_septique, choc_cardiogenique, choc_anaphylactique, bradycardie,
//  tachycardie, arythmies, cardiopathie_ischemique, hypertension_pulmonaire,
//  hyperthyroidie, phéochromocytome — n'existent PAS encore comme clés dans
//  ce fichier / dans pathologies_data.dart (non fourni). Il faut créer ces
//  Pathologie(...) (fichier pathologies_data.dart) AVANT d'ajouter des
//  règles sous ces clés, sous peine de règles orphelines jamais affichées.
//  ── Antibiotiques ────────────────────────────────────────────
//    cefazolin · clindamycin · vancomycin · metronidazole
//  ── Divers ───────────────────────────────────────────────────
//    lidocaine · atropine · nacl_09 · ringer_lactate · albumin_20
//
//  SOURCE PRINCIPALE : Miller's Anesthesia 9th Ed. + SFAR + ESA Guidelines
// ╚══════════════════════════════════════════════════════════════╝

// ══════════════════════════════════════════════════════════════
//  MODÈLE DE DONNÉES
// ══════════════════════════════════════════════════════════════

enum DrugPathologyStatus {
  preferred,        // ⭐ Recommandé — bénéfice démontré
  caution,          // ⚠️ Prudence — adapter la dose ou surveiller
  contraindicated,  // ❌ Contre-indiqué — risque avéré
}

class DrugPathologyRule {
  final String drugId;
  final DrugPathologyStatus status;
  final String reason;
  final String? doseAdjustment;
  final String? source;

  const DrugPathologyRule({
    required this.drugId,
    required this.status,
    required this.reason,
    this.doseAdjustment,
    this.source,
  });
}

// ══════════════════════════════════════════════════════════════
//  TABLE PATHOLOGIE → RÈGLES MÉDICAMENTS
// ══════════════════════════════════════════════════════════════

const Map<String, List<DrugPathologyRule>> pathologyDrugRules = {

  // ╔══════════════════════════════════╗
  // ║       NEUROLOGIQUE               ║
  // ╚══════════════════════════════════╝

  'hic': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Réduit la PIC, le débit sanguin cérébral et le métabolisme cérébral (CMRO₂)',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.57 ; SFAR 2020',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.preferred,
      reason: 'Réduit la PIC et offre une protection cérébrale — 2ème ligne si propofol indisponible',
      source: 'Brain Trauma Foundation Guidelines 4th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique, pas d\'effet sur la PIC aux doses analgésiques usuelles',
      source: 'Neurocritical Care Society Guidelines 2020',
    ),
    DrugPathologyRule(
      drugId: 'remifentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Opioïde de choix en neurochirurgie — réveil rapide facilitant le bilan neurologique',
      source: 'ESA Guidelines Neuroanesthesia 2017',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Augmente la PIC, la PIO et le CMRO₂ — CONTRE-INDIQUÉ en HIC non contrôlée',
      source: 'Miller\'s Anesthesia 9th Ed. ; Brain Trauma Foundation 4th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.caution,
      reason: 'Augmentation transitoire (<1 min) de la PIC — acceptable en SRI si bénéfice > risque',
      doseAdjustment: 'Prétraitement lidocaïne 1.5 mg/kg IV 90 sec avant — atténue la montée PIC',
      source: 'Neurocritical Care 2012;16(1):7-14',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'Acceptable mais accumulation prolongée gêne l\'évaluation neurologique',
      doseAdjustment: 'Préférer propofol pour sédation neurochirurgicale (réveil plus prévisible)',
      source: 'Neurocritical Care Society Guidelines 2020',
    ),
    DrugPathologyRule(
      drugId: 'mannitol_20',
      status: DrugPathologyStatus.preferred,
      reason: "Osmothérapie de référence pour réduire la PIC en urgence",
      doseAdjustment: "0.25–1 g/kg IV sur 20 min",
      source: "Miller's Anesthesia 9th Ed. Ch.57",
    ),
    DrugPathologyRule(
      drugId: 'nacl_hypertonique_3',
      status: DrugPathologyStatus.preferred,
      reason: "Alternative osmothérapique au mannitol — pas d'effet diurétique délétère sur la PAM",
      source: "Miller's Anesthesia 9th Ed. Ch.57",
    ),
    DrugPathologyRule(
      drugId: 'dexamethasone',
      status: DrugPathologyStatus.caution,
      reason: "Utile uniquement si œdème vasogénique péritumoral — sans bénéfice, voire délétère, dans l'œdème cytotoxique post-traumatique",
      source: "Miller's Anesthesia 9th Ed. Ch.57",
    ),
  ],

  'epilepsie': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Activité antiépileptique documentée à doses anesthésiques — 3ème ligne EME réfractaire',
      source: 'Epilepsia 2012;53(2):194-226 (Shorvon et al.)',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.preferred,
      reason: 'Benzodiazépine de référence EME — 1ère ligne IV ou IM selon contexte',
      source: 'Neurology 2012;78(18):1408-18 (RAMPART trial)',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.preferred,
      reason: 'EME réfractaire — efficacité prouvée ; monitoring EEG continu requis',
      source: 'Epilepsia 2012;53(2):194-226',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Données contradictoires — peut abaisser le seuil épileptique en sub-anesthésique',
      source: 'Neurocritical Care 2015;23(3):404-11',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.caution,
      reason: 'Myoclonies importantes pouvant masquer ou mimer des crises épileptiques',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26',
    ),
    DrugPathologyRule(
      drugId: 'imipenem_cilastatine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Abaisse significativement le seuil épileptogène — risque convulsif le plus élevé des carbapénèmes',
      doseAdjustment: 'Préférer le méropénème si un carbapénème est indispensable',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'meropenem',
      status: DrugPathologyStatus.caution,
      reason: 'Risque convulsif plus faible que l\'imipénème mais non nul, surtout si dose non ajustée à la fonction rénale',
      doseAdjustment: 'Vérifier l\'ajustement rénal',
      source: 'Sanford Guide',
    ),
    DrugPathologyRule(
      drugId: 'ciprofloxacine',
      status: DrugPathologyStatus.caution,
      reason: 'Abaisse le seuil épileptogène — interaction possible avec certains antiépileptiques (théophylline notamment)',
      source: 'AAAAI ; Sanford Guide',
    ),
    DrugPathologyRule(
      drugId: 'rifampicine',
      status: DrugPathologyStatus.caution,
      reason: 'Inducteur enzymatique majeur — diminue les concentrations de nombreux antiépileptiques (carbamazépine, phénytoïne, lamotrigine, valproate)',
      doseAdjustment: 'Surveiller les concentrations d\'antiépileptiques et adapter leur dose si traitement prolongé',
      source: 'Epilepsia — interactions médicamenteuses',
    ),
    DrugPathologyRule(
      drugId: 'tramadol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Abaisse le seuil épileptogène de façon dose-dépendante — risque de convulsions, notamment en association aux antidépresseurs/antipsychotiques',
      source: 'Epilepsia 2015 ; ANSM RCP Tramadol',
    ),
    DrugPathologyRule(
      drugId: 'tapentadol',
      status: DrugPathologyStatus.caution,
      reason: 'Seuil convulsivant potentiellement abaissé — risque moindre que le tramadol mais non nul',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'pethidine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Métabolite normépéridine convulsivant, accumulation majorée en cas de doses répétées',
      source: 'Anesthesiology 1998;88(3):797-802',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       HÉPATIQUE                  ║
  // ╚══════════════════════════════════╝

  'insuffisance_hepatique': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolisme majoritairement extra-hépatique (poumons, reins) — sécurisé en IHC',
      source: 'Anesthesiology 2005;103(6):1221-8 ; EASL Guidelines 2018',
    ),
    DrugPathologyRule(
      drugId: 'remifentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Dégradation par estérases plasmatiques — totalement indépendant de la fonction hépatique',
      source: 'BJA 1998;81(3):421-31',
    ),
    DrugPathologyRule(
      drugId: 'cisatracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Dégradation de Hofmann (chimique) — indépendant du foie et du rein',
      source: 'Anesthesiology 1995;83(6):1186-99 ; Miller\'s 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'atracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Élimination de Hofmann — sécurisé en IHC, mais histamino-libération possible',
      source: 'BJA 1983;55(8):761-6',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique (CYP3A4) — t½ prolongé en IHC sévère, titrer',
      doseAdjustment: 'Réduire la dose de 30–50% et espacer les bolus',
      source: 'Clin Pharmacokinet 1994;26(3):201-14',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique exclusif — sédation prolongée et imprévisible en cirrhose',
      doseAdjustment: 'Réduire de 50%, espacer les doses — préférer propofol',
      source: 'Gut 1994;35(9):1322-7',
    ),
    DrugPathologyRule(
      drugId: 'morphine',
      status: DrugPathologyStatus.caution,
      reason: 'Glucuronidation hépatique réduite en IHC — accumulation M6G, sédation prolongée',
      doseAdjustment: 'Réduire de 50% et préférer fentanyl ou rémifentanil',
      source: 'Pain 1992;48(3):311-8',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination biliaire — durée d\'action prolongée en cirrhose Child-Pugh B/C',
      doseAdjustment: 'Réduire la dose ou substituer par cisatracurium',
      source: 'Br J Anaesth 1994;73(4):464-9',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Accumulation et suppression surrénalienne aggravée en IHC — éviter',
      source: 'Crit Care Med 2010;38(6 Suppl):S285-92',
    ),
    DrugPathologyRule(
      drugId: 'sufentanil',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Métabolisme hépatique exclusif — accumulation sévère et imprévisible en IHC',
      source: 'Anesthesiology 1989;71(2):170-8',
    ),
    DrugPathologyRule(
      drugId: 'clevidipine',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolisme par estérases sanguines — indépendant de la fonction hépatique',
      source: 'Anesth Analg 2008;107(1):59-67',
    ),
    DrugPathologyRule(
      drugId: 'terlipressine',
      status: DrugPathologyStatus.preferred,
      reason: 'Indication princeps (syndrome hépatorénal, hémorragie variceale) — usage courant en cirrhose',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'labetalol',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique — demi-vie prolongée en IHC sévère',
      doseAdjustment: 'Titrer prudemment, espacer les réinjections',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'nicardipine',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme CYP3A4 hépatique — accumulation possible en cirrhose Child-Pugh B/C',
      doseAdjustment: 'Réduire la dose de départ et titrer plus lentement',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'levosimendan',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CI en insuffisance hépatique sévère (métabolisme hépatique, données de sécurité insuffisantes)',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'rifampicine',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique et hépatotoxicité propre — risque cumulatif en IHC',
      doseAdjustment: 'Réduire la dose ou éviter en insuffisance hépatocellulaire sévère, surveillance rapprochée du bilan hépatique',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'amoxicilline_clavulanate',
      status: DrugPathologyStatus.caution,
      reason: 'Risque propre d\'hépatite cholestatique — prudence renforcée si atteinte hépatique préexistante',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'tigecycline',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination hépatobiliaire prédominante — ajustement de dose en Child-Pugh C',
      doseAdjustment: 'Child-Pugh C : charge 100mg puis entretien réduit à 25mg q12h',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'clindamycin',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique — réduire la dose en insuffisance hépatique sévère',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'chloramphenicol',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique exclusif (glucuronoconjugaison) — accumulation et toxicité majorée en IHC',
      doseAdjustment: 'Réduire impérativement la dose',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'moxifloxacine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CI en insuffisance hépatique sévère — élimination quasi exclusivement hépatique',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'ceftriaxone',
      status: DrugPathologyStatus.caution,
      reason: 'Double élimination biliaire/rénale — prudence si insuffisance rénale ET hépatique sévères associées',
      doseAdjustment: 'Ne pas dépasser 2 g/j si double atteinte',
      source: 'EASL Clinical Practice Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'alfentanil',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique quasi exclusif (CYP3A4) — clairance réduite en IHC, réduire la dose et espacer les réinjections',
      source: 'BJA 1985;57(11):1103-7',
    ),
    DrugPathologyRule(
      drugId: 'hydromorphone',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique — réduire la dose et espacer les prises en IHC modérée à sévère',
      source: 'Clin Pharmacokinet 2004;43(13):897-905',
    ),
    DrugPathologyRule(
      drugId: 'oxycodone',
      status: DrugPathologyStatus.caution,
      reason: 'Clairance réduite et demi-vie allongée en IHC — réduire la dose initiale et espacer les prises',
      doseAdjustment: 'Réduire la dose initiale de ~50% et allonger l\'intervalle',
      source: 'UpToDate 2024 ; ANSM RCP Oxycodone',
    ),
    DrugPathologyRule(
      drugId: 'methadone',
      status: DrugPathologyStatus.caution,
      reason: 'Allongement supplémentaire d\'une demi-vie déjà longue et variable — risque d\'accumulation accru, avis spécialisé requis',
      source: 'J Pain Symptom Manage 2006',
    ),
    DrugPathologyRule(
      drugId: 'pethidine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Accumulation du métabolite normépéridine (neurotoxique) majorée par la réduction du métabolisme hépatique',
      source: 'Anesthesiology 1998;88(3):797-802',
    ),
    DrugPathologyRule(
      drugId: 'tramadol',
      status: DrugPathologyStatus.caution,
      reason: 'Clairance hépatique réduite (concerne aussi le métabolite actif M1) — réduire la dose et espacer les prises',
      doseAdjustment: 'Espacer les prises à 12h en IHC sévère',
      source: 'ANSM RCP Tramadol',
    ),
    DrugPathologyRule(
      drugId: 'tilidine',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique quasi exclusif (nortilidine) — prudence en IHC',
      source: 'ANSM RCP Tilidine/Naloxone',
    ),
    DrugPathologyRule(
      drugId: 'nalbuphine',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique — réduire la dose en IHC',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'buprenorphine',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique CYP3A4 quasi exclusif — réduire/éviter en IHC sévère, préférer un opioïde à élimination moins hépato-dépendante',
      source: 'EASL 2023 ; ANSM RCP Buprénorphine',
    ),
    DrugPathologyRule(
      drugId: 'codeine',
      status: DrugPathologyStatus.caution,
      reason: 'Conversion en morphine active dépendante du CYP2D6, dont l\'activité peut être modulée par la fonction hépatique — effet imprévisible, prudence',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'dihydrocodeine',
      status: DrugPathologyStatus.caution,
      reason: 'Profil proche de la codéine — métabolisme hépatique partiel CYP2D6, prudence en IHC',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'tapentadol',
      status: DrugPathologyStatus.caution,
      reason: 'Glucuronoconjugaison hépatique principalement — non recommandé en IHC sévère, prudence en IHC modérée',
      source: 'ANSM RCP Tapentadol',
    ),
    DrugPathologyRule(
      drugId: 'naloxone',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique — effet potentiellement modifié mais reste l\'antidote de choix, ne pas différer son administration en cas de surdosage',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'naltrexone',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Hépatotoxicité dose-dépendante décrite — contre-indiquée en IHC aiguë ou sévère, bilan hépatique préalable indispensable',
      source: 'ANSM RCP Naltrexone',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.caution,
      reason: 'Synthèse hépatique des pseudocholinestérases pouvant être réduite en IHC sévère — durée d\'action potentiellement prolongée',
      source: 'M9 §20',
    ),
    DrugPathologyRule(
      drugId: 'sugammadex',
      status: DrugPathologyStatus.preferred,
      reason: 'Non métabolisé par le foie, élimination rénale du complexe — pas d\'ajustement nécessaire en IHC',
      source: 'ANSM RCP Sugammadex',
    ),
    DrugPathologyRule(
      drugId: 'vecuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination principalement biliaire — durée d\'action prolongée en IHC, titrer selon TOF',
      source: 'SFAR RFE Curarisation 2018',
    ),
    DrugPathologyRule(
      drugId: 'pancuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique partiel (3-hydroxypancuronium) — prudence, élimination rénale prédominante néanmoins',
      source: 'M9 §21',
    ),
    DrugPathologyRule(
      drugId: 'mivacurium',
      status: DrugPathologyStatus.caution,
      reason: 'Synthèse hépatique des pseudocholinestérases pouvant être réduite en IHC sévère — durée d\'action potentiellement prolongée',
      source: 'BJA 1995',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       RÉNAL                      ║
  // ╚══════════════════════════════════╝

  'insuffisance_renale': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolisme non rénal (glucuronidation hépatique + extra-hépatique) — sécurisé',
      source: 'KDIGO AKI Guidelines 2012 ; Anesth Analg 2004',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolites inactifs (norfentanyl) — pas d\'accumulation cliniquement significative',
      source: 'Clin Pharmacokinet 1994 ; KDIGO CKD Guidelines 2012',
    ),
    DrugPathologyRule(
      drugId: 'remifentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Dégradation par estérases plasmatiques — complètement indépendant de la fonction rénale',
      source: 'Br J Anaesth 1998;81(3):421-31',
    ),
    DrugPathologyRule(
      drugId: 'cisatracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Dégradation de Hofmann — aucune accumulation en IRC même en anurie',
      source: 'Anesthesiology 1995;83(6):1186-99',
    ),
    DrugPathologyRule(
      drugId: 'morphine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'M6G (métabolite actif) s\'accumule en IRC — dépression respiratoire sévère et prolongée',
      source: 'BMJ 2003;326(7382):207-8 ; Palliative Medicine 2011',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Hyperkaliémie chronique en IRC — risque de fibrillation ventriculaire',
      source: 'Anesthesiology 2006;104(4):661-7 ; Miller\'s 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'α-hydroxy-midazolam (métabolite actif) s\'accumule en IRC — sédation prolongée',
      doseAdjustment: 'Réduire de 30% si DFG<30 — surveiller la sédation',
      source: 'Clin Pharmacokinet 1996;30(1):1-22',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale partielle — durée légèrement prolongée en IRC',
      doseAdjustment: 'Monitorage TOF obligatoire — dose inchangée mais surveiller',
      source: 'BJA 2000;84(6):753-9',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Norketamine (métabolite actif) s\'accumule en IRC sévère',
      doseAdjustment: 'Réduire la dose de 30–50% et espacer les administrations',
      source: 'Clin Pharmacokinet 1981;6(4):260-75',
    ),
    DrugPathologyRule(
      drugId: 'clevidipine',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolisme par estérases sanguines — indépendant de la fonction rénale',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolisme par estérases érythrocytaires — pas d\'accumulation en IRC',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'vasopressine',
      status: DrugPathologyStatus.preferred,
      reason: 'Non-catécholaminergique, épargne les besoins en noradrénaline — pas d\'ajustement rénal',
      source: 'Surviving Sepsis Campaign 2021',
    ),
    DrugPathologyRule(
      drugId: 'milrinone',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale prédominante — accumulation et hypotension prolongée en IRC',
      doseAdjustment: 'Réduire la dose jusqu\'à 50% selon la clairance de la créatinine',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'nitroprussiate',
      status: DrugPathologyStatus.caution,
      reason: 'Accumulation de thiocyanate (métabolite rénal) — risque de toxicité neurologique',
      doseAdjustment: 'Éviter les perfusions prolongées >24–48h, surveiller le thiocyanate',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'metoprolol',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme hépatique mais élimination partiellement rénale des métabolites',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'gentamicine',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale exclusive — néphrotoxicité propre s\'ajoutant à l\'IRC',
      doseAdjustment: 'Espacer l\'intervalle selon la clairance, dosage pic/résiduel indispensable',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'amikacine',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale exclusive — néphrotoxicité propre s\'ajoutant à l\'IRC',
      doseAdjustment: 'Espacer l\'intervalle, TDM indispensable',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'tobramycine',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale exclusive — néphrotoxicité propre s\'ajoutant à l\'IRC',
      doseAdjustment: 'Espacer l\'intervalle, TDM indispensable',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'vancomycin',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale exclusive et néphrotoxicité propre — ajustement majeur nécessaire',
      doseAdjustment: 'Dosage pharmacocinétique (AUC/CMI) impératif, intervalle très variable',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'colistine',
      status: DrugPathologyStatus.caution,
      reason: 'Néphrotoxicité fréquente et ajustement de dose complexe en IRC',
      doseAdjustment: 'Calcul de dose non standardisé — avis pharmacologique/néphrologique obligatoire',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'cefepime',
      status: DrugPathologyStatus.caution,
      reason: 'Neurotoxicité (encéphalopathie, état de mal non convulsif) documentée en cas d\'accumulation rénale',
      doseAdjustment: 'Ajustement impératif et surveillance neurologique rapprochée',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'ceftazidime',
      status: DrugPathologyStatus.caution,
      reason: 'Neurotoxicité (myoclonies, convulsions) en cas d\'accumulation rénale',
      doseAdjustment: 'Ajustement impératif',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'imipenem_cilastatine',
      status: DrugPathologyStatus.caution,
      reason: 'Risque convulsif majoré par l\'accumulation en IRC sévère',
      doseAdjustment: 'À éviter si ClCr<15 sauf hémodialyse',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'nitrofurantoine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Inefficace et toxique par accumulation si ClCr<30–40 ml/min',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'ertapenem',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale prédominante',
      doseAdjustment: 'ClCr<30 : 500 mg/j',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'aztreonam',
      status: DrugPathologyStatus.preferred,
      reason: 'Sans alternative néphrotoxique propre — bon choix Gram négatif en IRC (avec ajustement de dose)',
      doseAdjustment: 'Réduire la dose selon la clairance',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'moxifloxacine',
      status: DrugPathologyStatus.preferred,
      reason: 'Élimination hépatique — aucun ajustement rénal nécessaire, avantageux en IRC',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'ceftriaxone',
      status: DrugPathologyStatus.preferred,
      reason: 'Double élimination biliaire/rénale — pas d\'ajustement systématique nécessaire en IR isolée',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'azithromycine',
      status: DrugPathologyStatus.preferred,
      reason: 'Élimination hépatobiliaire — pas d\'ajustement rénal nécessaire',
      source: 'KDIGO CKD Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'sufentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolites inactifs, élimination pour l\'essentiel indépendante de la fonction rénale',
      source: 'Br J Anaesth 1990',
    ),
    DrugPathologyRule(
      drugId: 'alfentanil',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolites inactifs mais fraction libre potentiellement augmentée par l\'hypoalbuminémie associée à l\'IRC — titrer prudemment',
      source: 'BJA 1985;57(11):1103-7',
    ),
    DrugPathologyRule(
      drugId: 'hydromorphone',
      status: DrugPathologyStatus.caution,
      reason: 'Alternative préférable à la morphine en IRC (métabolite H3G non analgésique) mais accumulation possible en IRC sévère — surveiller la sédation',
      source: 'J Pain Symptom Manage 2010',
    ),
    DrugPathologyRule(
      drugId: 'oxycodone',
      status: DrugPathologyStatus.caution,
      reason: 'Accumulation de la molécule mère et de ses métabolites en IRC — réduire la dose et espacer les prises',
      source: 'ANSM RCP Oxycodone',
    ),
    DrugPathologyRule(
      drugId: 'methadone',
      status: DrugPathologyStatus.preferred,
      reason: 'Élimination majoritairement fécale/biliaire — parmi les opioïdes forts les mieux tolérés en IRC sévère/dialyse, mais titration exclusivement spécialisée du fait de la variabilité cinétique',
      source: 'J Pain Symptom Manage 2004 ; Palliative Medicine',
    ),
    DrugPathologyRule(
      drugId: 'pethidine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Accumulation majeure du métabolite normépéridine en IRC — risque convulsif élevé',
      source: 'Anesthesiology 1998;88(3):797-802',
    ),
    DrugPathologyRule(
      drugId: 'tramadol',
      status: DrugPathologyStatus.caution,
      reason: 'Accumulation de la molécule mère et du métabolite actif M1 — réduire la dose et espacer les prises',
      doseAdjustment: 'Espacer à 12h si DFG<30',
      source: 'ANSM RCP Tramadol',
    ),
    DrugPathologyRule(
      drugId: 'tilidine',
      status: DrugPathologyStatus.caution,
      reason: 'Peu de données spécifiques en IRC — prudence, réduire la dose',
      source: 'Vidal',
    ),
    DrugPathologyRule(
      drugId: 'nalbuphine',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolites éliminés par voie rénale/biliaire — prudence en IRC sévère',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'buprenorphine',
      status: DrugPathologyStatus.preferred,
      reason: 'Élimination essentiellement biliaire/fécale, pas de métabolite actif à élimination rénale significative — bien tolérée en IRC, y compris en dialyse',
      source: 'Nephrol Dial Transplant 2008',
    ),
    DrugPathologyRule(
      drugId: 'codeine',
      status: DrugPathologyStatus.caution,
      reason: 'Accumulation du métabolite morphine et de ses dérivés en IRC — éviter ou réduire fortement en IRC sévère',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'dihydrocodeine',
      status: DrugPathologyStatus.caution,
      reason: 'Profil proche de la codéine — accumulation possible en IRC, prudence',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'tapentadol',
      status: DrugPathologyStatus.caution,
      reason: 'Données limitées en IRC sévère — prudence, pas de recommandation ferme au-delà d\'une IRC modérée',
      source: 'ANSM RCP Tapentadol',
    ),
    DrugPathologyRule(
      drugId: 'naloxone',
      status: DrugPathologyStatus.preferred,
      reason: 'Reste l\'antidote de choix quelle que soit la fonction rénale — ne pas différer son administration en cas de surdosage',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'naltrexone',
      status: DrugPathologyStatus.caution,
      reason: 'Peu de données spécifiques en IRC — prudence',
      source: 'Vidal',
    ),
    DrugPathologyRule(
      drugId: 'atracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Dégradation de Hofmann, indépendante de la fonction rénale — bien toléré en IRC y compris sévère',
      source: 'BJA 1992 ; SFAR RFE Curarisation 2018',
    ),
    DrugPathologyRule(
      drugId: 'sugammadex',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination rénale du complexe sugammadex-curare — élimination ralentie en IRC sévère (DFG<30), risque de récurarisation en cas de doses répétées',
      source: 'ANSM RCP Sugammadex ; Br J Anaesth 2016',
    ),
    DrugPathologyRule(
      drugId: 'vecuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Élimination partiellement rénale (~30%) — durée d\'action légèrement prolongée, titrer selon TOF',
      source: 'SFAR RFE Curarisation 2018',
    ),
    DrugPathologyRule(
      drugId: 'pancuronium',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Élimination essentiellement rénale (~80%) — accumulation majeure et curarisation résiduelle prolongée en IRC',
      source: 'M9 §21 ; SFAR RFE Curarisation 2018',
    ),
    DrugPathologyRule(
      drugId: 'mivacurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Hydrolyse par les cholinestérases plasmatiques, indépendante de la fonction rénale',
      source: 'BJA 1995',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       CARDIOVASCULAIRE           ║
  // ╚══════════════════════════════════╝

  'insuffisance_cardiaque': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Agent d\'induction le plus stable hémodynamiquement — référence IC sévère',
      source: 'ESC Heart Failure Guidelines 2021 ; Anesth Analg 2006',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Stimulant cardiovasculaire indirect (libération catécholamines) — maintient la PA',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.24',
    ),
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Vasopresseur de référence pour maintenir PAM ≥65 mmHg',
      source: 'ESC Heart Failure Guidelines 2021 ; SCCM Guidelines',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Bonne tolérance cardiovasculaire — effet hémodynamique minimal aux doses usuelles',
      source: 'Anesthesiology 1979;50(1):24-8',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Dépression myocardique et vasodilatation — hypotension fréquente et sévère en IC',
      doseAdjustment: 'Réduire de 30–50% (1–1.5 mg/kg), titrer très lentement, vasopresseur prêt',
      source: 'Anesthesiology 1992;77(3):467-74',
    ),
    DrugPathologyRule(
      drugId: 'dexmedetomidine',
      status: DrugPathologyStatus.caution,
      reason: 'Bradycardie et hypotension — risque si FE très basse ou dépendance aux vasopresseurs',
      doseAdjustment: 'Éviter la dose de charge ; démarrer à 0.2 mcg/kg/h',
      source: 'JAMA 2009;301(5):489-99 (MENDS trial)',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Dépression myocardique directe majeure — risque d\'effondrement hémodynamique en IC',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.caution,
      reason: 'Bradycardie vagale possible — acceptable si SRI indiqué',
      doseAdjustment: 'Atropine 0.5 mg IV en prémédication si bradycardie anticipée',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'dobutamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Inotrope de référence en choc cardiogénique et IC aiguë décompensée à bas débit',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'milrinone',
      status: DrugPathologyStatus.preferred,
      reason: 'Inodilatateur utile si résistances vasculaires élevées ou traitement bêtabloquant chronique',
      doseAdjustment: 'Réduire la dose si insuffisance rénale associée',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'levosimendan',
      status: DrugPathologyStatus.preferred,
      reason: 'Inotrope de choix si IC réfractaire aux catécholamines, sans ↑consommation myocardique en O2',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'nitroglycerine',
      status: DrugPathologyStatus.preferred,
      reason: 'Réduction de la précharge — utile en OAP et IC congestive avec PA conservée',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'dopamine',
      status: DrugPathologyStatus.caution,
      reason: 'Alternative 2ème ligne — davantage d\'arythmies que la noradrénaline/dobutamine',
      source: 'Surviving Sepsis Campaign 2021',
    ),
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Bêtabloquant — risque de décompensation aiguë en IC non stabilisée à bas débit',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'metoprolol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CI en décompensation cardiaque aiguë non contrôlée — introduire seulement après stabilisation',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'nitroprussiate',
      status: DrugPathologyStatus.caution,
      reason: 'Utile si post-charge très élevée, mais risque d\'hypotension et de toxicité au cyanure',
      doseAdjustment: 'Titration prudente sous PA invasive continue',
      source: 'ESC Heart Failure Guidelines 2021',
    ),
  ],

  'hypertension': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Vasodilatateur — réduit la PA à l\'induction, agent de choix en HTA',
      source: 'ESC/ESH Hypertension Guidelines 2023 + Miller\'s 9th Ed. Ch.38',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.preferred,
      reason: 'Vasodilatateur et dépresseur myocardique — utile pour contrôler la PA à l\'induction',
      source: 'Stoelting\'s 7th Ed. Ch.5',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Atténue la réponse sympathique à la laryngoscopie — 2–3 mcg/kg avant intubation',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.38 + SFAR 2020',
    ),
    DrugPathologyRule(
      drugId: 'remifentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle précis de la réponse au stress chirurgical en TIVA — idéal en HTA',
      source: 'ESC/ESH 2023 + BJA 2003',
    ),
    DrugPathologyRule(
      drugId: 'dexmedetomidine',
      status: DrugPathologyStatus.preferred,
      reason: 'α2-agoniste — réduit le tonus sympathique, atténue les pics hypertensifs peropératoires',
      source: 'AHA/ACC Hypertension Guidelines 2023 + JAMA 2009',
    ),
    DrugPathologyRule(
      drugId: 'lidocaine',
      status: DrugPathologyStatus.preferred,
      reason: 'Prétraitement 1.5 mg/kg IV 90 sec avant laryngoscopie — réduit le pic tensionnel',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.38',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'effet cardiovasculaire — curare de choix en HTA',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'cisatracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'histamino-libération ni d\'effet cardiovasculaire — alternative sécurisée',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet sympathomimétique : ↑PA +15–25%, ↑FC +20–30% — CONTRE-INDIQUÉ en HTA non contrôlée',
      source: 'ESC/ESH 2023 + Miller\'s 9th Ed. Ch.24',
    ),
    DrugPathologyRule(
      drugId: 'ephedrine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Sympathomimétique indirect — poussée hypertensive sévère si HTA non contrôlée',
      source: 'SFAR 2020 + Miller\'s 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'atracurium',
      status: DrugPathologyStatus.caution,
      reason: 'Histamino-libération à dose élevée → vasodilatation et tachycardie réflexe',
      doseAdjustment: 'Injection lente, dose ≤ 0.4 mg/kg',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.caution,
      reason: 'Patient hypertendu répond plus fortement aux vasopresseurs — doses réduites nécessaires',
      doseAdjustment: 'Démarrer à 0.02–0.05 mcg/kg/min (moitié de la dose habituelle)',
      source: 'ESC/ESH Hypertension Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'adrenaline',
      status: DrugPathologyStatus.caution,
      reason: 'Effet α1 puissant — risque de poussée hypertensive sévère à forte dose',
      doseAdjustment: 'Utiliser à doses minimales — ne pas dépasser 0.05 mcg/kg/min sauf urgence',
      source: 'AHA/ACC 2023',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'Léger effet vasodilatateur — bien toléré mais surveiller l\'hypotension',
      doseAdjustment: 'Dose standard — titrer si patient âgé ou PA mal contrôlée',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'nicardipine',
      status: DrugPathologyStatus.preferred,
      reason: 'Vasodilatateur artériel sélectif — référence des urgences hypertensives péri-opératoires',
      source: 'ESC/ESH Hypertension Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'urapidil',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle tensionnel efficace avec peu de tachycardie réflexe (action centrale 5-HT1A)',
      source: 'ESC/ESH Hypertension Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'labetalol',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle combiné PA/FC — utile si tachycardie associée à l\'HTA',
      source: 'ESC/ESH Hypertension Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle rapide et titrable de la réponse sympathique (laryngoscopie, pics tensionnels)',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.38',
    ),
    DrugPathologyRule(
      drugId: 'nitroprussiate',
      status: DrugPathologyStatus.caution,
      reason: 'Très efficace mais risque de toxicité au cyanure si dose élevée/prolongée — réserver aux urgences réfractaires',
      doseAdjustment: 'Limiter à <4–5 mcg/kg/min en usage prolongé ; surveiller lactates',
      source: 'ESC/ESH Hypertension Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'phenylephrine',
      status: DrugPathologyStatus.caution,
      reason: 'Vasoconstricteur pur — risque de poussée hypertensive si utilisé sans indication précise',
      doseAdjustment: 'Réserver aux hypotensions documentées, dose minimale efficace',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'dopamine',
      status: DrugPathologyStatus.caution,
      reason: 'Effet α dose-dépendant — risque de poussée hypertensive à forte dose',
      source: 'Surviving Sepsis Campaign 2021',
    ),
  ],

  'choc_hemorragique': [
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Stimulant CV indirect — maintient la PA et la FC en phase initiale du choc',
      source: 'Trauma 2012;73(2):385-90 ; TCCC Guidelines 2019',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale à l\'induction — sécurisé en choc',
      source: 'J Trauma 2010;68(4):933-8',
    ),
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Vasopresseur de choix pour maintenir PAM ≥65 mmHg en attendant le contrôle du saignement',
      source: 'ATLS 10th Ed. ; Eastern Association for Surgery of Trauma (EAST)',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Vasodilatation et dépression myocardique → collapsus cardiovasculaire fatal en choc',
      source: 'Miller\'s Anesthesia 9th Ed. ; ATLS 10th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Dépression cardiovasculaire majeure — arrêt cardiaque en hypovolémie sévère',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'Vasodilatation et hypotension aggravée en choc — utiliser seulement si nécessaire',
      doseAdjustment: 'Max 1 mg IV fractionné — utiliser le minimum pour l\'amnésie',
      source: 'TCCC Guidelines 2019',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.caution,
      reason: 'Acceptable en SRI si pas de CI — hyperkaliémie si crush ou brûlures associées',
      source: 'ATLS 10th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.preferred,
      reason: "Cristalloïde de remplissage de référence en attendant les produits sanguins",
      source: "ESA/ESICM Guidelines management of severe bleeding 2023",
    ),
    DrugPathologyRule(
      drugId: 'albumin_4',
      status: DrugPathologyStatus.caution,
      reason: "Alternative colloïdale si cristalloïdes insuffisants — pas de supériorité démontrée en 1ère intention",
      source: "ESA/ESICM Guidelines management of severe bleeding 2023",
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       RESPIRATOIRE               ║
  // ╚══════════════════════════════════╝

  'asthme_bronchospasme': [
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Bronchodilatateur puissant (action sympathomimétique + relaxation directe bronches)',
      source: 'GINA 2023 ; Chest 2014;146(6):1646-53',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Propriétés bronchodilatatrices démontrées — réflexes des voies aériennes atténués',
      source: 'Anesthesiology 1996;84(6):1307-11',
    ),
    DrugPathologyRule(
      drugId: 'dexmedetomidine',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas de dépression respiratoire — sédation sans aggravation du bronchospasme',
      source: 'Respir Med 2016;120:130-7',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'histamino-libération — curare de choix en asthme pour SRI',
      source: 'GINA 2023 ; Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'cisatracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'histamino-libération — alternative au rocuronium pour la curarisation',
      source: 'Anesthesiology 1995;83(6):1186-99',
    ),
    DrugPathologyRule(
      drugId: 'morphine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Histamino-libération dose-dépendante → bronchospasme sévère',
      source: 'GINA 2023 ; Anesthesiology 2003;99(6):1464-70',
    ),
    DrugPathologyRule(
      drugId: 'atracurium',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Histamino-libération importante → bronchospasme et hypotension — CONTRE-INDIQUÉ',
      source: 'BJA 1983;55(8):761-6 ; GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.caution,
      reason: 'Peut déclencher laryngospasme et bronchospasme — éviter si possible',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26',
    ),
    DrugPathologyRule(
      drugId: 'tramadol',
      status: DrugPathologyStatus.caution,
      reason: 'Libération d\'histamine possible — préférer fentanyl',
      source: 'Allergy 2005;60(7):966-8',
    ),
    DrugPathologyRule(
      drugId: 'labetalol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Blocage β2 → bronchospasme sévère possible — CONTRE-INDIQUÉ en asthme non contrôlé',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.caution,
      reason: 'Cardiosélectivité β1 relative — sélectivité perdue à forte dose, risque de bronchospasme',
      doseAdjustment: 'Dose minimale efficace, éviter si asthme sévère non contrôlé',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'metoprolol',
      status: DrugPathologyStatus.caution,
      reason: 'Cardiosélectif β1 mais sélectivité dose-dépendante — prudence en asthme',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'isoprenaline',
      status: DrugPathologyStatus.caution,
      reason: 'Bronchodilatateur (β2) mais tachyarythmogène — réserver aux indications rythmologiques',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Histamino-libération négligeable comparée à la morphine — opioïde de choix chez l\'asthmatique',
      source: 'Anesthesiology 2003;99(6):1464-70',
    ),
    DrugPathologyRule(
      drugId: 'hydromorphone',
      status: DrugPathologyStatus.caution,
      reason: 'Histamino-libération moindre que la morphine mais non nulle — prudence',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'codeine',
      status: DrugPathologyStatus.caution,
      reason: 'Histamino-libération possible comme les autres dérivés phénanthréniques — prudence en asthme sévère',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.caution,
      reason: 'Histamino-libération possible mais généralement modérée — utilisable si ISR nécessaire, surveiller le bronchospasme',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'sugammadex',
      status: DrugPathologyStatus.preferred,
      reason: 'Aucun risque d\'histamino-libération ni de bronchospasme — permet en outre une réversion rapide du rocuronium',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'vecuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Histamino-libération négligeable — profil respiratoire favorable chez l\'asthmatique',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'pancuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Histamino-libération négligeable',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'mivacurium',
      status: DrugPathologyStatus.caution,
      reason: 'Histamino-libération dose- et vitesse-dépendante, comme l\'atracurium — prudence en asthme sévère, injecter lentement',
      source: 'GINA 2023',
    ),
    DrugPathologyRule(
      drugId: 'salbutamol',
      status: DrugPathologyStatus.preferred,
      reason: "Bronchodilatateur de 1ère intention du bronchospasme peropératoire",
      source: "SFAR Prise en charge du bronchospasme peropératoire",
    ),
    DrugPathologyRule(
      drugId: 'ipratropium',
      status: DrugPathologyStatus.preferred,
      reason: "Effet synergique démontré en association au salbutamol",
      source: "GINA Guidelines Asthma 2023",
    ),
    DrugPathologyRule(
      drugId: 'dexamethasone',
      status: DrugPathologyStatus.preferred,
      reason: "Adjuvant anti-inflammatoire après contrôle initial par bronchodilatateurs",
      source: "GINA Guidelines Asthma 2023",
    ),
  ],

  'bpco': [
    DrugPathologyRule(
      drugId: 'dexmedetomidine',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas de dépression respiratoire — avantage majeur en BPCO pour sédation ICU',
      source: 'GOLD 2024 ; Lancet Respir Med 2018;6(9):669-76',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Bronchodilatateur — maintient les réflexes des voies aériennes',
      source: 'GOLD 2024 ; Anesth Analg 2010',
    ),
    DrugPathologyRule(
      drugId: 'remifentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Offset ultra-rapide — contrôle précis de la dépression respiratoire peropératoire',
      source: 'BJA 2003;91(3):357-66',
    ),
    DrugPathologyRule(
      drugId: 'morphine',
      status: DrugPathologyStatus.caution,
      reason: 'Dépression respiratoire prolongée — risque élevé d\'hypercapnie en BPCO sévère',
      doseAdjustment: 'Réduire les doses de 30–50%, surveiller la SaO₂ et la PaCO₂',
      source: 'GOLD 2024 Guidelines',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'Dépression respiratoire — peut aggraver l\'hypercapnie chronique',
      doseAdjustment: 'Dose minimale, surveiller la capnographie',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'atracurium',
      status: DrugPathologyStatus.caution,
      reason: 'Histamino-libération modérée — éviter en BPCO sévère, préférer cisatracurium',
      source: 'GOLD 2024 ; BJA 1983',
    ),
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.caution,
      reason: 'Cardiosélectif et ultra-court — préférable aux bêtabloquants non sélectifs si indication cardiaque impérative',
      doseAdjustment: 'Dose minimale efficace, arrêt rapide possible si bronchospasme',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'labetalol',
      status: DrugPathologyStatus.caution,
      reason: 'Effet β2 pouvant aggraver l\'obstruction bronchique en BPCO sévère',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Profil respiratoire mieux contrôlable que la morphine en titration IV — alternative recommandée',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'hydromorphone',
      status: DrugPathologyStatus.caution,
      reason: 'Dépression respiratoire dose-dépendante comme tous les agonistes purs — réduire les doses et surveiller la SaO2/PaCO2',
      doseAdjustment: 'Réduire les doses de 30–50%',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'oxycodone',
      status: DrugPathologyStatus.caution,
      reason: 'Dépression respiratoire dose-dépendante — réduire les doses et surveiller la SaO2/PaCO2',
      doseAdjustment: 'Réduire les doses de 30–50%',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'buprenorphine',
      status: DrugPathologyStatus.caution,
      reason: 'Effet plafond respiratoire théoriquement rassurant mais antagonisation par la naloxone partielle en cas de dépression sévère — prudence',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'nalbuphine',
      status: DrugPathologyStatus.caution,
      reason: 'Effet plafond respiratoire (agoniste-antagoniste) — profil possiblement plus sûr que les agonistes purs mais données spécifiques BPCO limitées',
      source: 'UpToDate 2024',
    ),
    DrugPathologyRule(
      drugId: 'naloxone',
      status: DrugPathologyStatus.preferred,
      reason: 'Antidote de référence en cas de dépression respiratoire induite par les opioïdes chez le patient BPCO',
      source: 'GOLD 2024',
    ),
    DrugPathologyRule(
      drugId: 'ipratropium',
      status: DrugPathologyStatus.preferred,
      reason: "Composante anticholinergique souvent prédominante dans la BPCO",
      source: "GOLD Guidelines COPD 2024",
    ),
    DrugPathologyRule(
      drugId: 'salbutamol',
      status: DrugPathologyStatus.preferred,
      reason: "Bronchodilatateur de 1ère intention de l'exacerbation",
      source: "GOLD Guidelines COPD 2024",
    ),
    DrugPathologyRule(
      drugId: 'dexamethasone',
      status: DrugPathologyStatus.caution,
      reason: "Discuté en cas d'exacerbation sévère — bénéfice moindre que dans l'asthme",
      source: "GOLD Guidelines COPD 2024",
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       MÉTABOLIQUE                ║
  // ╚══════════════════════════════════╝

  'hyperkaliemie': [
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Aucun effet sur le K⁺ — curare de choix en hyperkaliémie (SRI avec sugammadex dispo)',
      source: 'Anesthesiology 2006;104(4):661-7 ; Miller\'s 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'cisatracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas de libération de K⁺ — alternative sécurisée en hyperkaliémie',
      source: 'KDIGO AKI Guidelines 2012',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'effet sur la kaliémie — hypnotique sécurisé',
      source: 'Miller\'s Anesthesia 9th Ed.',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CONTRE-INDICATION ABSOLUE — ↑K⁺ de 0.5–1 mEq/L → fibrillation ventriculaire/asystolie',
      source: 'Anesthesiology 2006;104(4):661-7 ; FDA Black Box Warning',
    ),
    DrugPathologyRule(
      drugId: 'atracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'effet dépolarisant, alternative sûre à la succinylcholine en cas d\'hyperkaliémie',
      source: 'M9 §20-21',
    ),
    DrugPathologyRule(
      drugId: 'vecuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'effet dépolarisant, alternative sûre à la succinylcholine en cas d\'hyperkaliémie',
      source: 'M9 §20-21',
    ),
    DrugPathologyRule(
      drugId: 'pancuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Alternative non dépolarisante à la succinylcholine, mais durée d\'action longue à anticiper',
      source: 'M9 §20-21',
    ),
    DrugPathologyRule(
      drugId: 'mivacurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'effet dépolarisant, alternative sûre à la succinylcholine en cas d\'hyperkaliémie',
      source: 'M9 §20-21',
    ),
    DrugPathologyRule(
      drugId: 'bicarbonate_84',
      status: DrugPathologyStatus.preferred,
      reason: "Correction de l'acidose associée et stabilisation membranaire transitoire",
      doseAdjustment: "1–2 mEq/kg IV sur 5 min si acidose sévère associée",
      source: "KDIGO Clinical Practice Guidelines 2023",
    ),
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.preferred,
      reason: "Soluté de remplissage sans potassium — sécuritaire en hyperkaliémie",
      source: "KDIGO Clinical Practice Guidelines 2023",
    ),
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.contraindicated,
      reason: "Contient du potassium (4 mEq/L) — risque d'aggravation de l'hyperkaliémie",
      source: "KDIGO Clinical Practice Guidelines 2023",
    ),
    DrugPathologyRule(
      drugId: 'insuline_rapide',
      status: DrugPathologyStatus.preferred,
      reason: "Fait entrer le potassium en intracellulaire — toujours associée à un apport glucosé",
      doseAdjustment: "10 UI IV + 30g glucose (G30% 100ml)",
      source: "KDIGO Clinical Practice Guidelines 2023",
    ),
    DrugPathologyRule(
      drugId: 'salbutamol',
      status: DrugPathologyStatus.preferred,
      reason: "Adjuvant — favorise l'entrée intracellulaire du potassium (effet additif à l'insuline)",
      source: "KDIGO Clinical Practice Guidelines 2023",
    ),
  ],

  'porphyrie': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Agent de choix en porphyrie — sûr dans la majorité des types de porphyrie',
      source: 'Porphyria South Africa (PASA) Drug List 2023 ; BJA 2003',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Opioïde de référence en porphyrie — considéré sûr',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'remifentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Considéré sûr — dégradation par estérases sans induction hépatique CYP',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Considéré sûr en porphyrie',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.preferred,
      reason: 'Considéré sûr en porphyrie — utilisation acceptable si SRI indiqué',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CONTRE-INDICATION ABSOLUE — déclenche une crise de porphyrie aiguë potentiellement fatale',
      source: 'Porphyria South Africa Drug Safety Database 2023 ; BJA 2003;90(3):391-401',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Considéré non sûr — inducteur CYP hépatique pouvant précipiter une crise',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Données insuffisantes — utilisation avec précaution si pas d\'alternative',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.caution,
      reason: 'Données contradictoires — éviter si alternative disponible',
      source: 'BJA 2003;90(3):391-401',
    ),
    DrugPathologyRule(
      drugId: 'rifampicine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Inducteur enzymatique puissant — considéré non sûr, peut précipiter une crise aiguë',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'cotrimoxazole',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Sulfamides considérés non sûrs en porphyrie aiguë',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'erythromycine',
      status: DrugPathologyStatus.caution,
      reason: 'Considéré probablement non sûr (induction enzymatique) — préférer un autre macrolide si besoin',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'ciprofloxacine',
      status: DrugPathologyStatus.caution,
      reason: 'Fluoroquinolones considérées probablement non sûres — utiliser avec prudence si pas d\'alternative',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'ceftriaxone',
      status: DrugPathologyStatus.preferred,
      reason: 'Céphalosporines généralement considérées sûres en porphyrie',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.preferred,
      reason: 'Pénicillines généralement considérées sûres en porphyrie',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
    DrugPathologyRule(
      drugId: 'gentamicine',
      status: DrugPathologyStatus.preferred,
      reason: 'Aminosides généralement considérés sûrs en porphyrie',
      source: 'Porphyria South Africa Drug Safety Database 2023',
    ),
  ],

  'diabete': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'effet sur la glycémie — sécurisé en diabète',
      source: 'Anesthesiology 2010;113(1):44-56',
    ),
    DrugPathologyRule(
      drugId: 'dexmedetomidine',
      status: DrugPathologyStatus.preferred,
      reason: 'Réduction de la réponse au stress chirurgical — contrôle glycémique amélioré',
      source: 'Anesth Analg 2012;115(5):1102-7',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Stimulation sympathique → hyperglycémie — surveiller la glycémie',
      doseAdjustment: 'Monitoring glycémique toutes les heures peropératoire',
      source: 'Anesthesiology 2011',
    ),
    DrugPathologyRule(
      drugId: 'adrenaline',
      status: DrugPathologyStatus.caution,
      reason: 'Hyperglycémie importante et hypokaliémie dose-dépendantes',
      doseAdjustment: 'Surveiller glycémie et kaliémie toutes les heures',
      source: 'Lancet Diabetes Endocrinol 2015',
    ),
    DrugPathologyRule(
      drugId: 'ciprofloxacine',
      status: DrugPathologyStatus.caution,
      reason: 'Dysglycémie possible (hypo- ou hyperglycémie), notamment chez le patient sous sulfamides hypoglycémiants',
      doseAdjustment: 'Renforcer la surveillance glycémique en début de traitement',
      source: 'FDA Safety Communication — Fluoroquinolones and blood glucose',
    ),
    DrugPathologyRule(
      drugId: 'levofloxacine',
      status: DrugPathologyStatus.caution,
      reason: 'Dysglycémie possible (hypo- ou hyperglycémie) — risque le plus documenté parmi les fluoroquinolones',
      doseAdjustment: 'Renforcer la surveillance glycémique en début de traitement',
      source: 'FDA Safety Communication — Fluoroquinolones and blood glucose',
    ),
    DrugPathologyRule(
      drugId: 'cotrimoxazole',
      status: DrugPathologyStatus.caution,
      reason: 'Potentialise l\'effet des sulfamides hypoglycémiants oraux — risque d\'hypoglycémie',
      doseAdjustment: 'Surveiller la glycémie si sulfamide hypoglycémiant associé',
      source: 'Interactions médicamenteuses — sulfamides',
    ),
    DrugPathologyRule(
      drugId: 'insuline_rapide',
      status: DrugPathologyStatus.preferred,
      reason: "Protocole insuline-glucose de référence pour le contrôle glycémique périopératoire",
      source: "SFAR Prise en charge du patient diabétique 2021",
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       OBSTÉTRIQUE                ║
  // ╚══════════════════════════════════╝

  'grossesse': [
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.preferred,
      reason: 'SRI de référence en AG obstétricale — estomac plein systématique après 14–16 SA',
      source: 'RCOG Green-Top Guideline 2011 ; SFAR Recommandations Obstétrique 2020',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Alternative à la succinylcholine en SRI obstétrical (1.2 mg/kg + sugammadex 16 mg/kg disponible)',
      source: 'Anesthesiology 2015;122(6):1215-20',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Agent d\'induction de référence en AG obstétricale — passage placentaire mais métabolisé rapidement',
      source: 'SFAR 2020 ; BJA 1999;83(3):459-67',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.caution,
      reason: 'Passage placentaire — dépression respiratoire néonatale possible',
      doseAdjustment: 'Limiter avant extraction du fœtus — naloxone néonatale prête',
      source: 'SFAR Obstétrique 2020 ; RCOG',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Augmentation du tonus utérin possible à forte dose (>1.5 mg/kg) en fin de grossesse',
      doseAdjustment: 'Utiliser à dose réduite 0.5–1 mg/kg en obstétrique',
      source: 'Obstet Gynecol 1982;60(4):461-4',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'Passage placentaire — hypotonie néonatale possible',
      doseAdjustment: 'Éviter avant extraction si possible',
      source: 'SFAR 2020',
    ),
    DrugPathologyRule(
      drugId: 'morphine',
      status: DrugPathologyStatus.caution,
      reason: 'Passage placentaire — dépression respiratoire néonatale',
      doseAdjustment: 'Naloxone néonatale (0.01 mg/kg IM) disponible',
      source: 'SFAR 2020 ; RCOG',
    ),
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.caution,
      reason: 'Vasoconstriction utéro-placentaire possible — utiliser la phényléphrine en rachianesthésie',
      doseAdjustment: 'Réserver aux situations d\'urgence maternelle',
      source: 'SFAR Obstétrique 2020 ; Int J Obstet Anesth 2019',
    ),
    DrugPathologyRule(
      drugId: 'ketoprofene',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CI ABSOLUE au 3ème trimestre — fermeture prématurée du canal artériel fœtal',
      source: 'ANSM Mise en garde ; EMEA 2003 ; FDA Cat D',
    ),
    DrugPathologyRule(
      drugId: 'phenylephrine',
      status: DrugPathologyStatus.preferred,
      reason: '1ère ligne hypotension per-rachianesthésie obstétricale — moins d\'acidose fœtale que l\'éphédrine',
      source: 'SFAR Obstétrique 2020 ; Int J Obstet Anesth 2019',
    ),
    DrugPathologyRule(
      drugId: 'ephedrine',
      status: DrugPathologyStatus.caution,
      reason: 'Traverse le placenta — associé à une acidose fœtale plus marquée que la phényléphrine',
      doseAdjustment: 'Préférer la phényléphrine sauf bradycardie maternelle associée',
      source: 'Int J Obstet Anesth 2019',
    ),
    DrugPathologyRule(
      drugId: 'labetalol',
      status: DrugPathologyStatus.preferred,
      reason: '1ère ligne recommandée en prééclampsie/éclampsie et HTA gravidique aiguë',
      source: 'SFAR Obstétrique 2020 ; ACOG Practice Bulletin',
    ),
    DrugPathologyRule(
      drugId: 'urapidil',
      status: DrugPathologyStatus.preferred,
      reason: 'Large usage européen en prééclampsie sévère — peu de tachycardie réflexe',
      source: 'SFAR Obstétrique 2020',
    ),
    DrugPathologyRule(
      drugId: 'nicardipine',
      status: DrugPathologyStatus.preferred,
      reason: 'Utilisée en urgence hypertensive gravidique en alternative au labétalol',
      source: 'ACOG Practice Bulletin',
    ),
    DrugPathologyRule(
      drugId: 'vasopressine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet ocytocique utérin — risque de contractions/accouchement prématuré',
      source: 'ANSM RCP',
    ),
    DrugPathologyRule(
      drugId: 'terlipressine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet ocytocique utérin — CI sauf urgence vitale maternelle sans alternative',
      source: 'ANSM RCP',
    ),
    DrugPathologyRule(
      drugId: 'nitroprussiate',
      status: DrugPathologyStatus.caution,
      reason: 'Risque théorique de toxicité fœtale au cyanure en cas d\'usage prolongé',
      doseAdjustment: 'Réserver aux échecs des autres traitements, durée la plus courte possible',
      source: 'ACOG Practice Bulletin',
    ),
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.preferred,
      reason: 'Pénicilline compatible à tous les termes de la grossesse',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'ceftriaxone',
      status: DrugPathologyStatus.preferred,
      reason: 'Céphalosporine compatible à tous les termes si indication justifiée',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'azithromycine',
      status: DrugPathologyStatus.preferred,
      reason: 'Macrolide de choix en grossesse si un macrolide est nécessaire (préférer à la clarithromycine)',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'clarithromycine',
      status: DrugPathologyStatus.caution,
      reason: 'Données discordantes (malformations cardiaques rapportées dans certaines études) — préférer l\'azithromycine',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'ciprofloxacine',
      status: DrugPathologyStatus.caution,
      reason: 'Toxicité articulaire chez l\'animal — à éviter sauf absence d\'alternative documentée',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'levofloxacine',
      status: DrugPathologyStatus.caution,
      reason: 'Toxicité articulaire chez l\'animal — à éviter sauf absence d\'alternative',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'moxifloxacine',
      status: DrugPathologyStatus.caution,
      reason: 'Toxicité articulaire chez l\'animal — à éviter sauf absence d\'alternative',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'doxycycline',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CI aux 2e/3e trimestres — coloration dentaire et toxicité osseuse fœtale',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'minocycline',
      status: DrugPathologyStatus.contraindicated,
      reason: 'CI aux 2e/3e trimestres — coloration dentaire fœtale',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'tigecycline',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Structure tétracycline-like — toxicité osseuse/dentaire fœtale attendue par analogie de classe',
      source: 'RCP Tigécycline',
    ),
    DrugPathologyRule(
      drugId: 'cotrimoxazole',
      status: DrugPathologyStatus.caution,
      reason: 'Antagoniste de l\'acide folique — éviter au 1er trimestre (risque malformatif) et en fin de grossesse (ictère nucléaire)',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'nitrofurantoine',
      status: DrugPathologyStatus.caution,
      reason: 'Utilisable au 1er/2e trimestre si nécessaire ; CI en fin de grossesse (38–42 SA, hémolyse néonatale)',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'gentamicine',
      status: DrugPathologyStatus.caution,
      reason: 'Ototoxicité fœtale théorique — réserver aux infections sévères sans alternative',
      source: 'CRAT — lecrat.fr',
    ),
    DrugPathologyRule(
      drugId: 'colistine',
      status: DrugPathologyStatus.caution,
      reason: 'Données humaines très limitées — décision au cas par cas si infection vitale sans alternative',
      source: 'RCP Colistine',
    ),
    DrugPathologyRule(
      drugId: 'chloramphenicol',
      status: DrugPathologyStatus.caution,
      reason: 'Risque de toxicité hématologique néonatale (syndrome du bébé gris) en fin de grossesse',
      source: 'CRAT — lecrat.fr',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       ALLERGIQUE                 ║
  // ╚══════════════════════════════════╝

  'allergie_oeuf_soja': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Contient lécithine d\'œuf (2.25 mg/ml) et huile de soja raffinée — CI allergie sévère',
      source: 'FDA Drug Label Propofol ; SFAR Recommandations Allergie Peropératoire 2011',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas de lécithine d\'œuf ni huile de soja — alternative de 1ère ligne si propofol CI',
      source: 'SFAR Recommandations Allergie Peropératoire 2011',
    ),
    DrugPathologyRule(
      drugId: 'thiopental',
      status: DrugPathologyStatus.preferred,
      reason: 'Aucun excipient lipidique — alternative valide si propofol CI',
      source: 'SFAR 2011',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas de contenu lipidique — alternative valide en allergie œuf/soja',
      source: 'SFAR 2011',
    ),
  ],

  'allergie_penicilline': [
    DrugPathologyRule(
      drugId: 'cefazolin',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée <1% entre céphalosporines et pénicillines — acceptable si allergie mineure',
      doseAdjustment: 'CI si anaphylaxie pénicilline — utiliser clindamycine + gentamicine à la place',
      source: 'ASHP/IDSA Surgical Prophylaxis Guidelines 2023 ; AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'clindamycin',
      status: DrugPathologyStatus.preferred,
      reason: 'Prophylaxie chirurgicale alternative validée en allergie sévère aux pénicillines',
      source: 'ASHP/IDSA Surgical Prophylaxis Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'vancomycin',
      status: DrugPathologyStatus.preferred,
      reason: 'Prophylaxie chirurgicale alternative en allergie sévère (staphylocoques/SARM)',
      source: 'ASHP/IDSA Guidelines 2023',
    ),
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Pénicilline — contre-indication directe',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'amoxicilline_clavulanate',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Pénicilline — contre-indication directe',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'ampicilline',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Pénicilline — contre-indication directe',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'oxacilline',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Pénicilline — contre-indication directe',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'piperacilline_tazobactam',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Pénicilline — contre-indication directe',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'cefuroxime',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée <2% — acceptable si allergie mineure (éruption isolée), à éviter si anaphylaxie',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'cefotaxime',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée faible — à éviter si anaphylaxie/réaction sévère documentée',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'ceftriaxone',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée faible — à éviter si anaphylaxie/réaction sévère documentée',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'ceftazidime',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée faible — chaîne latérale partagée avec l\'aztréonam/céfépime, vérifier',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'cefepime',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée faible — chaîne latérale partagée avec la ceftazidime, vérifier',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'imipenem_cilastatine',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée avec les pénicillines réelle mais plus faible qu\'anticipée historiquement',
      source: 'AAAAI 2021 ; J Allergy Clin Immunol Pract',
    ),
    DrugPathologyRule(
      drugId: 'meropenem',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée avec les pénicillines possible mais faible',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'ertapenem',
      status: DrugPathologyStatus.caution,
      reason: 'Allergie croisée avec les pénicillines possible mais faible',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'aztreonam',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas de croisement avec les pénicillines/carbapénèmes — bonne option de repli. Vérifier néanmoins l\'absence d\'allergie spécifique à la ceftazidime (chaîne latérale commune)',
      source: 'AAAAI 2021',
    ),
    DrugPathologyRule(
      drugId: 'teicoplanine',
      status: DrugPathologyStatus.preferred,
      reason: 'Alternative sans β-lactamine — utile en allergie sévère',
      source: 'ASHP/IDSA Guidelines 2023',
    ),
  ],

  'allergie_latex': [
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Réactivité croisée latex-rocuronium décrite (très rare) — surveiller',
      source: 'Allergy 2007;62(7):719-26',
    ),
    DrugPathologyRule(
      drugId: 'atracurium',
      status: DrugPathologyStatus.caution,
      reason: 'Réactivité croisée latex-curare possible — monitoring allergologique recommandé',
      source: 'WAO Guidelines Anaphylaxis 2020',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       CARDIOVASCULAIRE (AJOUTS)  ║
  // ╚══════════════════════════════════╝

  'sca_infarctus': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale à l\'induction — préserve la pression de perfusion coronaire',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20 ; ESC Guidelines non-cardiac surgery 2022',
    ),
    DrugPathologyRule(
      drugId: 'sufentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Émousse la réponse sympathique à l\'intubation — réduit la consommation d\'O₂ myocardique',
      source: 'ESC/ESA Guidelines non-cardiac surgery 2022',
    ),
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle titrable de la fréquence cardiaque peropératoire — demi-vie courte',
      source: 'ESC Guidelines non-cardiac surgery 2022',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Effet sympathomimétique — augmente la fréquence cardiaque et le travail myocardique',
      doseAdjustment: 'Réduire la dose de 50% ou préférer un autre agent',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
  ],

  'angor_stable': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Induction hémodynamiquement stable — évite les pics tensionnels déclenchant l\'angor',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'nitroglycerine',
      status: DrugPathologyStatus.preferred,
      reason: 'Vasodilatateur coronaire — traite l\'épisode angineux peropératoire',
      source: 'ESC Guidelines chronic coronary syndromes 2019',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Vasodilatation et baisse de la PAM possibles — titrer prudemment pour maintenir la perfusion coronaire',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
  ],

  'fibrillation_auriculaire': [
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.preferred,
      reason: 'Ralentit la cadence ventriculaire en peropératoire — titrable, demi-vie courte',
      source: 'ESC Guidelines Atrial Fibrillation 2020',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique à l\'induction chez un patient à réserve cardiaque limitée',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
  ],

  'tachycardie_supraventriculaire': [
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle de fréquence si échec des manœuvres vagales',
      source: 'ACC/AHA/HRS Guidelines Supraventricular Tachycardia 2016',
    ),
    DrugPathologyRule(
      drugId: 'atropine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet vagolytique tachycardisant — risque d\'aggraver ou de précipiter la TSV',
      source: 'ACC/AHA/HRS Guidelines Supraventricular Tachycardia 2016',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Effet sympathomimétique — peut précipiter une récidive de tachycardie',
      doseAdjustment: 'Réduire la dose de 50% ou préférer un autre agent',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
  ],

  'bradycardie': [
    DrugPathologyRule(
      drugId: 'atropine',
      status: DrugPathologyStatus.preferred,
      reason: 'Antagoniste vagal de référence pour la bradycardie symptomatique',
      source: 'ERC Guidelines Peri-arrest arrhythmias 2021',
    ),
    DrugPathologyRule(
      drugId: 'ephedrine',
      status: DrugPathologyStatus.preferred,
      reason: 'Effet chronotrope et vasopresseur — utile en cas de bradycardie avec hypotension',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Effet chronotrope positif — peut être utile à l\'induction en cas de bradycardie',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.caution,
      reason: 'Risque de bradycardie sévère, notamment en cas de réinjection ou chez l\'enfant',
      doseAdjustment: 'Prémédication par atropine à discuter avant réinjection',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.21',
    ),
    DrugPathologyRule(
      drugId: 'glycopyrrolate',
      status: DrugPathologyStatus.preferred,
      reason: "Alternative à l'atropine — moins tachycardisant, pas d'effet central",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'avc_ischemique': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique — évite les chutes de PAM délétères en zone de pénombre ischémique',
      source: 'AHA/ASA Guidelines Acute Ischemic Stroke 2019',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Alternative à profil hémodynamique stable pour l\'induction',
      source: 'AHA/ASA Guidelines Acute Ischemic Stroke 2019',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Curare non dépolarisant préféré — évite le risque d\'hyperkaliémie de la succinylcholine',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.21',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Risque d\'hyperkaliémie sur dénervation motrice si délai >24-72h post-AVC',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.21',
    ),
  ],

  'avc_hemorragique': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Réduit la PIC et permet un contrôle fin de la PAM — limite le risque de resaignement',
      source: 'AHA/ASA Guidelines Spontaneous Intracerebral Hemorrhage 2022',
    ),
    DrugPathologyRule(
      drugId: 'nicardipine',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle tensionnel titrable — cible PAS <140 mmHg en phase aiguë',
      source: 'AHA/ASA Guidelines Spontaneous Intracerebral Hemorrhage 2022',
    ),
    DrugPathologyRule(
      drugId: 'labetalol',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle tensionnel alternatif — bêta-bloquant à effet alpha additionnel',
      source: 'AHA/ASA Guidelines Spontaneous Intracerebral Hemorrhage 2022',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Augmente la PIC — risque de majoration de l\'hémorragie et d\'engagement cérébral',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.57',
    ),
    DrugPathologyRule(
      drugId: 'mannitol_20',
      status: DrugPathologyStatus.preferred,
      reason: "Osmothérapie si signes d'engagement cérébral associés",
      doseAdjustment: "0.25–1 g/kg IV sur 20 min",
      source: "AHA/ASA Guidelines Spontaneous Intracerebral Hemorrhage 2022",
    ),
    DrugPathologyRule(
      drugId: 'nacl_hypertonique_3',
      status: DrugPathologyStatus.preferred,
      reason: "Alternative osmothérapique au mannitol en cas d'instabilité hémodynamique",
      source: "AHA/ASA Guidelines Spontaneous Intracerebral Hemorrhage 2022",
    ),
  ],

  'aomi': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique — préserve la perfusion distale chez un patient athéromateux polyvasculaire',
      source: 'ESC Guidelines Peripheral Arterial Disease 2017',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Vasodilatation et baisse de PAM — risque d\'aggraver l\'ischémie distale',
      source: 'ESC Guidelines Peripheral Arterial Disease 2017',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       PNEUMOLOGIE (AJOUTS)       ║
  // ╚══════════════════════════════════╝

  'pneumonie_communautaire': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'effet histamino-libérateur significatif — bien toléré en contexte infectieux respiratoire',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.19',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.preferred,
      reason: 'Analgésie stable, pas de dépression respiratoire prolongée aux doses adaptées',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.19',
    ),
    DrugPathologyRule(
      drugId: 'linezolide',
      status: DrugPathologyStatus.caution,
      reason: "Réservé à la couverture du SARM en cas de pneumonie sévère à risque",
      source: "IDSA/ATS Guidelines Community-Acquired Pneumonia 2019",
    ),
  ],

  'tuberculose_pulmonaire': [
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Induction enzymatique par la rifampicine — accélère le métabolisme',
      doseAdjustment: 'Augmenter la dose de 30% ; monitorer le train-de-quatre',
      source: 'BJA Education 2018;18(3):73-79',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme accéléré par la rifampicine (inducteur CYP3A4) — effet raccourci',
      doseAdjustment: 'Augmenter la dose de 20% ou titrer selon effet',
      source: 'BJA Education 2018;18(3):73-79',
    ),
  ],

  'bronchite_aigue': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Effet bronchodilatateur relatif — réduit le risque de bronchospasme réflexe',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26',
    ),
  ],

  'bronchiolite': [
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Bronchodilatateur — intéressant en cas de bronchospasme associé chez le nourrisson',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26 (pédiatrie)',
    ),
    DrugPathologyRule(
      drugId: 'salbutamol',
      status: DrugPathologyStatus.caution,
      reason: "Non recommandé en routine chez le nourrisson — bénéfice non démontré, essai thérapeutique au cas par cas uniquement",
      source: "AAP Clinical Practice Guideline Bronchiolitis 2014 ; NICE Guideline NG9",
    ),
  ],

  'embolie_pulmonaire': [
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Maintient la pression artérielle systémique et la perfusion coronaire du ventricule droit',
      source: 'ESC Guidelines Pulmonary Embolism 2019',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale à l\'induction en cas d\'instabilité',
      source: 'ESC Guidelines Pulmonary Embolism 2019',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Vasodilatation et baisse de la précharge — mal tolérées en cas de choc obstructif',
      source: 'ESC Guidelines Pulmonary Embolism 2019',
    ),
    DrugPathologyRule(
      drugId: 'epoprostenol',
      status: DrugPathologyStatus.caution,
      reason: "Vasodilatateur pulmonaire à discuter en cas de défaillance ventriculaire droite sévère",
      source: "ESC Guidelines Pulmonary Embolism 2019",
    ),
    DrugPathologyRule(
      drugId: 'iloprost',
      status: DrugPathologyStatus.caution,
      reason: "Alternative au epoprostenol en cas de défaillance ventriculaire droite",
      source: "ESC Guidelines Pulmonary Embolism 2019",
    ),
  ],

  'pneumothorax': [
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Maintien de la ventilation spontanée possible mais surveiller l\'expansion du pneumothorax',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26',
    ),
  ],

  'covid19': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Induction de choix — permet une séquence rapide avec limitation de la ventilation au masque',
      source: 'APSF/ASA COVID-19 Anesthesia Guidance 2021',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Curarisation rapide et profonde facilitant l\'intubation en séquence rapide (geste aérosolisant)',
      source: 'APSF/ASA COVID-19 Anesthesia Guidance 2021',
    ),
  ],

  'coqueluche': [
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Bronchodilatateur — intéressant en cas de bronchospasme associé chez le nourrisson',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.26 (pédiatrie)',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║   CORRECTIF : LACUNE DÉTECTÉE    ║
  // ╚══════════════════════════════════╝
  //  'syndrome_obese' existait dans pathologies_data.dart sans aucune
  //  règle associée ici — corrigé ci-dessous (cohérent avec les
  //  droguesFavorisees et dosesAjustees déjà définis pour cette pathologie).

  'syndrome_obese': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Induction sur poids corporel idéal (PCI), entretien sur poids réel — évite le surdosage lipidique',
      doseAdjustment: 'Facteur 0.8 sur PCI à l\'induction',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.44',
    ),
    DrugPathologyRule(
      drugId: 'remifentanil',
      status: DrugPathologyStatus.preferred,
      reason: 'Pharmacocinétique peu affectée par l\'obésité — titration sur poids maigre',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.44',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Dose calculée sur le poids réel — bonne prévisibilité chez l\'obèse',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.44',
    ),
    DrugPathologyRule(
      drugId: 'sugammadex',
      status: DrugPathologyStatus.preferred,
      reason: 'Réversion fiable et rapide du bloc neuromusculaire — réduit le risque de curarisation résiduelle',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.44',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.caution,
      reason: 'Risque d\'accumulation si dosé sur le poids réel',
      doseAdjustment: 'Calculer sur le poids corporel idéal (PCI)',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.44',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       ENDOCRINOLOGIE (AJOUTS)    ║
  // ╚══════════════════════════════════╝

  'acidocetose_diabetique': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale chez un patient hypovolémique et acidosique',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.preferred,
      reason: "Soluté de réhydratation initial de référence",
      source: "ADA Standards of Care Diabetes 2024",
    ),
    DrugPathologyRule(
      drugId: 'glucose_10',
      status: DrugPathologyStatus.preferred,
      reason: "Ajouté à l'insulinothérapie dès que la glycémie <250 mg/dL — prévient l'hypoglycémie",
      source: "ADA Standards of Care Diabetes 2024",
    ),
    DrugPathologyRule(
      drugId: 'bicarbonate_84',
      status: DrugPathologyStatus.caution,
      reason: "Réservé aux acidoses sévères (pH<6.9) — non recommandé en routine",
      doseAdjustment: "1 mEq/kg IV uniquement si pH<6.9",
      source: "ADA Standards of Care Diabetes 2024",
    ),
    DrugPathologyRule(
      drugId: 'insuline_rapide',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence — perfusion continue sans bolus initial selon les recommandations actuelles",
      doseAdjustment: "0.05-0.1 UI/kg/h IVSE",
      source: "ADA Standards of Care Diabetes 2024",
    ),
  ],

  'syndrome_hyperosmolaire': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique — préserve la pression de perfusion chez un patient hypovolémique',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.preferred,
      reason: "Réhydratation initiale de référence avant correction glycémique progressive",
      source: "ADA Standards of Care Diabetes 2024",
    ),
    DrugPathologyRule(
      drugId: 'insuline_rapide',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement associé à la réhydratation — introduite après correction volémique initiale",
      source: "ADA Standards of Care Diabetes 2024",
    ),
  ],

  'hypothyroidie': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Sensibilité accrue au métabolisme ralenti — réveil retardé possible',
      doseAdjustment: 'Réduire la dose d\'induction et d\'entretien de 20%',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.35',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.caution,
      reason: 'Sensibilité accrue aux opioïdes — risque de dépression respiratoire prolongée',
      doseAdjustment: 'Réduire la dose de 20%',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.35',
    ),
  ],

  'hyperthyroidie': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique, pas d\'effet sympathomimétique — limite le risque de crise thyréotoxique',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.35',
    ),
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle titrable de la fréquence cardiaque — prévient la décompensation thyréotoxique',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.35',
    ),
    DrugPathologyRule(
      drugId: 'atropine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet tachycardisant — risque de précipiter une crise thyréotoxique',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.35',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Effet sympathomimétique — risque de précipiter une crise thyréotoxique',
      doseAdjustment: 'Réduire la dose de 50% ou préférer un autre agent',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.35',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║   GASTRO-ENTÉROLOGIE (AJOUTS)    ║
  // ╚══════════════════════════════════╝

  'deshydratation': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Risque d\'hypotension majoré chez le patient hypovolémique',
      doseAdjustment: 'Réduire la dose d\'induction de 20% et titrer lentement',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'ephedrine',
      status: DrugPathologyStatus.preferred,
      reason: 'Correction de l\'hypotension induite par l\'hypovolémie relative',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.preferred,
      reason: "Soluté de réhydratation de référence",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'ulcere_gastroduodenal': [
    DrugPathologyRule(
      drugId: 'ketoprofene',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Risque majoré de saignement ou de perforation digestive',
      source: 'ANSM RCP AINS ; SFAR Douleur postopératoire 2016',
    ),
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: 'Analgésique de choix — pas d\'effet gastrotoxique',
      source: 'SFAR Douleur postopératoire 2016',
    ),
  ],

  'hemorragie_digestive': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale chez un patient hypovolémique',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Effet sympathomimétique utile en cas d\'hypovolémie non totalement corrigée',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Support hémodynamique disponible en cas de collapsus peropératoire',
      source: 'ESA/ESICM Guidelines management of severe bleeding 2023',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Risque de collapsus cardiovasculaire si hypovolémie non corrigée',
      doseAdjustment: 'Réduire la dose de 50% ou préférer étomidate/kétamine',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.preferred,
      reason: "Remplissage vasculaire initial en attendant la disponibilité des culots globulaires",
      source: "ESA/ESICM Guidelines management of severe bleeding 2023",
    ),
  ],

  'ascite': [
    DrugPathologyRule(
      drugId: 'albumin_20',
      status: DrugPathologyStatus.preferred,
      reason: 'Prévention du syndrome de dysfonction circulatoire post-ponction de grand volume',
      source: 'EASL Clinical Practice Guidelines Ascites 2023',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       NÉPHROLOGIE (AJOUTS)       ║
  // ╚══════════════════════════════════╝

  'pyelonephrite': [
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Support hémodynamique de 1ère ligne en cas de sepsis associé',
      source: 'Surviving Sepsis Campaign Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'ceftazidime_avibactam',
      status: DrugPathologyStatus.caution,
      reason: "Réservé aux pyélonéphrites compliquées à bactérie multirésistante (BLSE/carbapénémase)",
      source: "SPILF Recommandations Infections Urinaires 2021",
    ),
  ],

  'colique_nephretique': [
    DrugPathologyRule(
      drugId: 'ketoprofene',
      status: DrugPathologyStatus.preferred,
      reason: 'Analgésique de 1ère intention — efficacité démontrée sur la douleur néphrétique',
      source: 'SFAR/SFMU Recommandations colique néphrétique 2019',
    ),
  ],

  'insuffisance_renale_aigue': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Métabolisme hépatique — sécurisé quel que soit le stade d\'IRA',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.51',
    ),
    DrugPathologyRule(
      drugId: 'cisatracurium',
      status: DrugPathologyStatus.preferred,
      reason: 'Dégradation de Hofmann — aucune accumulation même en anurie',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.51',
    ),
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.caution,
      reason: 'Risque d\'hyperkaliémie sévère si oligo-anurie et kaliémie déjà élevée',
      doseAdjustment: 'Vérifier la kaliémie avant utilisation',
      source: 'KDIGO Clinical Practice Guidelines AKI 2023',
    ),
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.preferred,
      reason: "Soluté de remplissage sans potassium — sécuritaire en IRA",
      source: "KDIGO Clinical Practice Guidelines AKI 2023",
    ),
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.caution,
      reason: "Contient du potassium — prudence si oligo-anurie ou hyperkaliémie associée",
      source: "KDIGO Clinical Practice Guidelines AKI 2023",
    ),
    DrugPathologyRule(
      drugId: 'bicarbonate_84',
      status: DrugPathologyStatus.caution,
      reason: "Correction d'une acidose métabolique sévère associée",
      source: "KDIGO Clinical Practice Guidelines AKI 2023",
    ),
  ],

  'syndrome_nephrotique': [
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: 'Hypoalbuminémie — augmentation de la fraction libre active',
      doseAdjustment: 'Réduire la dose de 20%',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.51',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       NEUROLOGIE (AJOUTS)        ║
  // ╚══════════════════════════════════╝

  'crise_convulsive_febrile': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Activité antiépileptique — sécurisant chez l\'enfant à risque convulsif',
      source: 'Epilepsia 2012;53(2):194-226',
    ),
  ],

  'meningite': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique en contexte septique, sans effet significatif sur la PIC',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.57',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.caution,
      reason: 'Prudence si signes d\'hypertension intracrânienne ou d\'engagement associés',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.57',
    ),
    DrugPathologyRule(
      drugId: 'mannitol_20',
      status: DrugPathologyStatus.caution,
      reason: "Osmothérapie à discuter uniquement si signes d'hypertension intracrânienne associés",
      source: "Miller's Anesthesia 9th Ed. Ch.57",
    ),
    DrugPathologyRule(
      drugId: 'dexamethasone',
      status: DrugPathologyStatus.preferred,
      reason: "Adjuvant réduisant les séquelles neurologiques — à administrer avant ou avec la 1ère dose d'antibiotique",
      doseAdjustment: "0.15 mg/kg q6h x 2-4 jours",
      source: "IDSA Guidelines Bacterial Meningitis 2004 (réaffirmées)",
    ),
  ],

  'encephalite': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Activité antiépileptique et réduction de la PIC',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.57',
    ),
  ],

  'nevralgie_faciale': [
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Induction enzymatique par la carbamazépine — durée d\'action raccourcie',
      doseAdjustment: 'Augmenter la dose de 30% ; monitorer le train-de-quatre',
      source: 'BJA Education 2018;18(3):73-79',
    ),
  ],

  'guillain_barre': [
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Risque d\'hyperkaliémie sévère et d\'arrêt cardiaque sur dénervation musculaire',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.21',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Sensibilité accrue aux curares non dépolarisants (récepteurs dénervés)',
      doseAdjustment: 'Réduire la dose de 30% ; monitorage TOF obligatoire',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.21',
    ),
    DrugPathologyRule(
      drugId: 'glycopyrrolate',
      status: DrugPathologyStatus.caution,
      reason: "Gestion de la dysautonomie — préférer aux agents à action centrale",
      source: "Miller's Anesthesia 9th Ed. Ch.38",
    ),
  ],

  'parkinson': [
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Pas d\'aggravation des symptômes extrapyramidaux — bien toléré',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.38',
    ),
  ],

  'alzheimer': [
    DrugPathologyRule(
      drugId: 'atropine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet anticholinergique central — aggrave la confusion et les troubles cognitifs',
      source: 'AGS Beers Criteria 2023',
    ),
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Sensibilité accrue chez le sujet dément — risque élevé de délirium postopératoire',
      doseAdjustment: 'Éviter ou réduire de 50% si utilisation indispensable',
      source: 'AGS Beers Criteria 2023 ; ESA/EBA Guidelines Postoperative Delirium 2017',
    ),
    DrugPathologyRule(
      drugId: 'glycopyrrolate',
      status: DrugPathologyStatus.preferred,
      reason: "Ne traverse pas la barrière hémato-encéphalique — alternative sûre à l'atropine chez le patient dément",
      source: "AGS Beers Criteria 2023",
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       INFECTIOLOGIE (AJOUTS)     ║
  // ╚══════════════════════════════════╝

  'tetanos': [
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle des spasmes musculaires généralisés à forte dose',
      source: 'WHO Guidelines Tetanus Management 2017',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Curarisation non dépolarisante si spasmes réfractaires ou détresse respiratoire',
      source: 'WHO Guidelines Tetanus Management 2017',
    ),
    DrugPathologyRule(
      drugId: 'glycopyrrolate',
      status: DrugPathologyStatus.preferred,
      reason: "Contrôle des sécrétions sans les effets anticholinergiques centraux de l'atropine",
      source: "WHO Guidelines Tetanus Management 2017",
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       OPHTALMOLOGIE (AJOUTS)     ║
  // ╚══════════════════════════════════╝

  'glaucome_aigu': [
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Augmente la pression intraoculaire — risque d\'aggravation du glaucome aigu',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.71',
    ),
    DrugPathologyRule(
      drugId: 'atropine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet mydriatique — risque de précipiter ou d\'aggraver une fermeture de l\'angle irido-cornéen',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.71',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Réduit la pression intraoculaire — agent d\'induction de choix',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.71',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Curare non dépolarisant — pas d\'augmentation de la PIO contrairement à la succinylcholine',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.71',
    ),
    DrugPathologyRule(
      drugId: 'glycopyrrolate',
      status: DrugPathologyStatus.caution,
      reason: "Effet mydriatique moindre que l'atropine mais prudence en angle fermé non traité",
      source: "Miller's Anesthesia 9th Ed. Ch.71",
    ),
    DrugPathologyRule(
      drugId: 'ipratropium',
      status: DrugPathologyStatus.caution,
      reason: "Éviter tout contact oculaire du nébulisat — risque de mydriase et d'aggravation de l'angle fermé",
      source: "BNF ; Miller's Anesthesia 9th Ed. Ch.71",
    ),
  ],

  'corps_etranger_oculaire': [
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Augmente la PIO — risque d\'extrusion du contenu oculaire en cas de globe ouvert',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.71',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.preferred,
      reason: 'Alternative à délai d\'action rapide pour une induction en séquence rapide sans élever la PIO',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.71',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.preferred,
      reason: 'Réduit la PIO — agent d\'induction de choix en cas de traumatisme oculaire ouvert',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.71',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║   RHUMATOLOGIE / PSYCHIATRIE (AJOUTS) ║
  // ╚══════════════════════════════════╝

  'depression': [
    DrugPathologyRule(
      drugId: 'ephedrine',
      status: DrugPathologyStatus.caution,
      reason: 'Interaction avec les IMAO — risque de crise hypertensive (sympathomimétique indirect)',
      doseAdjustment: 'Préférer la phényléphrine si IMAO en cours',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.16',
    ),
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.caution,
      reason: 'Risque de syndrome sérotoninergique en association avec un ISRS/IRSNa à forte dose',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.16',
    ),
  ],

  'trouble_bipolaire': [
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Le lithium potentialise et prolonge le bloc neuromusculaire',
      doseAdjustment: 'Réduire la dose de 30% ; monitorage TOF obligatoire',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.16',
    ),
  ],

  'schizophrenie': [
    DrugPathologyRule(
      drugId: 'esmolol',
      status: DrugPathologyStatus.caution,
      reason: 'Prudence en association avec des antipsychotiques allongeant le QT — surveiller l\'ECG',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.16',
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║  GYNÉCO/OBSTÉTRIQUE + URGENCES (AJOUTS) ║
  // ╚══════════════════════════════════╝

  'preeclampsie': [
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Le sulfate de magnésium potentialise et prolonge le bloc neuromusculaire',
      doseAdjustment: 'Réduire la dose de 30% ; monitorage TOF obligatoire',
      source: 'SFAR/CNGOF Recommandations Pré-éclampsie 2021',
    ),
    DrugPathologyRule(
      drugId: 'labetalol',
      status: DrugPathologyStatus.preferred,
      reason: 'Contrôle tensionnel de référence en pré-éclampsie',
      source: 'SFAR/CNGOF Recommandations Pré-éclampsie 2021',
    ),
  ],

  'eclampsie': [
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Le sulfate de magnésium potentialise et prolonge le bloc neuromusculaire',
      doseAdjustment: 'Réduire la dose de 30% ; monitorage TOF obligatoire',
      source: 'SFAR/CNGOF Recommandations Pré-éclampsie 2021',
    ),
  ],

  'hemorragie_postpartum': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale chez une patiente hypovolémique',
      source: 'CNGOF/SFAR Recommandations HPP 2014',
    ),
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Support hémodynamique en cas de choc hémorragique associé',
      source: 'CNGOF/SFAR Recommandations HPP 2014',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.caution,
      reason: 'Risque de collapsus si hypovolémie non corrigée',
      doseAdjustment: 'Réduire la dose de 50%',
      source: 'CNGOF/SFAR Recommandations HPP 2014',
    ),
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.preferred,
      reason: "Cristalloïde de remplissage initial en attendant les produits sanguins",
      source: "CNGOF/SFAR Recommandations HPP 2014",
    ),
  ],

  'choc_septique': [
    DrugPathologyRule(
      drugId: 'noradrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Vasopresseur de 1ère ligne dans le choc septique',
      source: 'Surviving Sepsis Campaign Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.caution,
      reason: 'Stabilité hémodynamique à l\'induction mais suppression surrénalienne transitoire à surveiller en contexte septique',
      source: 'Surviving Sepsis Campaign Guidelines 2021',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Risque de collapsus cardiovasculaire majeur en contexte de vasoplégie septique',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.preferred,
      reason: "Cristalloïde balancé de 1ère intention — préféré au NaCl 0.9% (moindre acidose hyperchlorémique)",
      source: "Surviving Sepsis Campaign Guidelines 2021",
    ),
    DrugPathologyRule(
      drugId: 'angiotensine2',
      status: DrugPathologyStatus.caution,
      reason: "Vasopresseur de 3ème ligne en cas de choc vasoplégique réfractaire",
      source: "Surviving Sepsis Campaign Guidelines 2021",
    ),
    DrugPathologyRule(
      drugId: 'bleu_methylene',
      status: DrugPathologyStatus.caution,
      reason: "Option en cas de vasoplégie réfractaire aux catécholamines",
      source: "Surviving Sepsis Campaign Guidelines 2021",
    ),
    DrugPathologyRule(
      drugId: 'ceftolozane_tazobactam',
      status: DrugPathologyStatus.caution,
      reason: "Antibiotique à large spectre de réserve en cas de suspicion de bactérie multirésistante",
      source: "Surviving Sepsis Campaign Guidelines 2021",
    ),
    DrugPathologyRule(
      drugId: 'hydrocortisone',
      status: DrugPathologyStatus.preferred,
      reason: "Recommandée en cas de choc réfractaire aux vasopresseurs à dose élevée",
      doseAdjustment: "≈200 mg/24h en perfusion continue ou 50 mg IVD q6h",
      source: "Surviving Sepsis Campaign Guidelines 2021",
    ),
  ],

  'choc_cardiogenique': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale — pas d\'effet inotrope négatif significatif',
      source: 'ESC Guidelines Acute Heart Failure 2021',
    ),
    DrugPathologyRule(
      drugId: 'dobutamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Support inotrope de référence dans le choc cardiogénique',
      source: 'ESC Guidelines Acute Heart Failure 2021',
    ),
    DrugPathologyRule(
      drugId: 'propofol',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Effet inotrope négatif et vasodilatateur — mal toléré en cas de bas débit sévère',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.20',
    ),
    DrugPathologyRule(
      drugId: 'epoprostenol',
      status: DrugPathologyStatus.caution,
      reason: "À discuter en cas de composante de défaillance ventriculaire droite associée",
      source: "ESC Guidelines Acute Heart Failure 2021",
    ),
  ],

  'choc_anaphylactique': [
    DrugPathologyRule(
      drugId: 'adrenaline',
      status: DrugPathologyStatus.preferred,
      reason: 'Traitement de 1ère intention — seul agent recommandé en urgence absolue',
      source: 'SFAR Recommandations Anaphylaxie Peranesthésique 2019',
    ),
    DrugPathologyRule(
      drugId: 'dexchlorpheniramine',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement adjuvant après l'adrénaline — jamais en 1ère ligne, ne traite pas le bronchospasme/l'hypotension",
      source: "SFAR Recommandations Anaphylaxie Peranesthésique 2019",
    ),
    DrugPathologyRule(
      drugId: 'hydrocortisone',
      status: DrugPathologyStatus.caution,
      reason: "Adjuvant en cas d'anaphylaxie réfractaire — délai d'action ne permet pas un effet immédiat",
      source: "SFAR Recommandations Anaphylaxie Peranesthésique 2019",
    ),
  ],

  'polytraumatisme': [
    DrugPathologyRule(
      drugId: 'etomidate',
      status: DrugPathologyStatus.preferred,
      reason: 'Stabilité hémodynamique maximale chez le patient hypovolémique/instable',
      source: 'European Trauma Guidelines 2023 (ESTES)',
    ),
    DrugPathologyRule(
      drugId: 'ketamine',
      status: DrugPathologyStatus.preferred,
      reason: 'Alternative à profil hémodynamique favorable en contexte hypovolémique',
      source: 'European Trauma Guidelines 2023 (ESTES)',
    ),
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.preferred,
      reason: "Cristalloïde de remplissage initial en attendant les produits sanguins",
      source: "European Trauma Guidelines 2023 (ESTES)",
    ),
  ],

  'brulure': [
    DrugPathologyRule(
      drugId: 'succinylcholine',
      status: DrugPathologyStatus.contraindicated,
      reason: 'Risque d\'hyperkaliémie sévère et d\'arrêt cardiaque après les 24 premières heures',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.21',
    ),
    DrugPathologyRule(
      drugId: 'rocuronium',
      status: DrugPathologyStatus.caution,
      reason: 'Résistance aux curares non dépolarisants par up-régulation des récepteurs nicotiniques',
      doseAdjustment: 'Augmenter la dose de 50% après 24h ; monitorage TOF',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.21',
    ),
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.preferred,
      reason: "Soluté de remplissage de référence (formule de Parkland) dans les 24 premières heures",
      source: "ISBI Practice Guidelines for Burn Care 2016",
    ),
    DrugPathologyRule(
      drugId: 'albumin_4',
      status: DrugPathologyStatus.caution,
      reason: "Phase colloïdale à discuter après les 24 premières heures",
      source: "ISBI Practice Guidelines for Burn Care 2016",
    ),
  ],

  // ╔══════════════════════════════════╗
  // ║       PÉDIATRIE (AJOUTS)         ║
  // ╚══════════════════════════════════╝

  'asphyxie_neonatale': [
    DrugPathologyRule(
      drugId: 'fentanyl',
      status: DrugPathologyStatus.caution,
      reason: 'Métabolisme ralenti sous hypothermie thérapeutique — risque d\'accumulation',
      doseAdjustment: 'Réduire la dose de 30% sous hypothermie thérapeutique active',
      source: 'Miller\'s Anesthesia 9th Ed. Ch.44 (pédiatrie néonatale)',
    ),
  ],


  // ╔══════════════════════════════════╗
  // ║   NOUVEAUX LIENS MÉDICAMENTS (33 non liés) ║
  // ╚══════════════════════════════════╝

  'appendicite_aigue': [
    DrugPathologyRule(
      drugId: 'metronidazole',
      status: DrugPathologyStatus.preferred,
      reason: "Couverture anaérobie — associé systématiquement à une bêta-lactamine en cas de perforation/péritonite",
      source: "SFAR/SPILF Antibioprophylaxie/Antibiothérapie Chirurgicale 2023",
    ),
  ],

  'cholecystite': [
    DrugPathologyRule(
      drugId: 'metronidazole',
      status: DrugPathologyStatus.preferred,
      reason: "Couverture anaérobie — associée à une bêta-lactamine en cas de cholécystite compliquée",
      source: "SFAR/SPILF Antibioprophylaxie/Antibiothérapie Chirurgicale 2023",
    ),
  ],

  'hypoglycemie_severe': [
    DrugPathologyRule(
      drugId: 'glucose_30',
      status: DrugPathologyStatus.preferred,
      reason: "Correction rapide de l'hypoglycémie sévère par voie IV",
      doseAdjustment: "1 ml/kg IV (0.3 g/kg), à répéter selon contrôle glycémique",
      source: "ADA Standards of Care Diabetes 2024",
    ),
  ],

  'prematurite': [
    DrugPathologyRule(
      drugId: 'glucose_10',
      status: DrugPathologyStatus.preferred,
      reason: "Prévention de l'hypoglycémie néonatale — apport glucosé de base chez le prématuré",
      source: "Miller's Anesthesia 9th Ed. Ch.44 (pédiatrie néonatale)",
    ),
  ],

  'sepsis_neonatal': [
    DrugPathologyRule(
      drugId: 'glucose_10',
      status: DrugPathologyStatus.preferred,
      reason: "Prévention de l'hypoglycémie associée au sepsis néonatal",
      source: "Miller's Anesthesia 9th Ed. Ch.44 (pédiatrie néonatale)",
    ),
  ],

  'gastro_enterite_aigue': [
    DrugPathologyRule(
      drugId: 'ringer_lactate',
      status: DrugPathologyStatus.preferred,
      reason: "Réhydratation IV de référence en cas de déshydratation significative",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'infection_urinaire': [
    DrugPathologyRule(
      drugId: 'fosfomycine',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de 1ère intention en dose unique pour la cystite aiguë non compliquée",
      source: "SPILF Recommandations Infections Urinaires 2021",
    ),
  ],

  'cellulite_infectieuse': [
    DrugPathologyRule(
      drugId: 'daptomycine',
      status: DrugPathologyStatus.caution,
      reason: "Réservée à la couverture du SARM en cas d'infection cutanée sévère",
      source: "IDSA Guidelines Skin and Soft Tissue Infections 2014",
    ),
    DrugPathologyRule(
      drugId: 'amoxicilline_clavulanate',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention en l'absence de suspicion de SARM",
      source: "IDSA Guidelines Skin and Soft Tissue Infections 2014",
    ),
  ],


  // ╔══════════════════════════════════╗
  // ║   NOUVEAUX LIENS MÉDICAMENTS — VAGUE 2 (ORL/derm/IST/symptomes) ║
  // ╚══════════════════════════════════╝

  'otite_moyenne_aigue': [
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention pour l'otite moyenne aiguë purulente",
      source: "HAS Antibiothérapie Otite Moyenne Aiguë 2021",
    ),
  ],

  'sinusite': [
    DrugPathologyRule(
      drugId: 'amoxicilline_clavulanate',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention pour la sinusite bactérienne aiguë",
      source: "SPILF Recommandations Sinusite 2021",
    ),
  ],

  'angine_bacterienne': [
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention pour l'angine à streptocoque du groupe A",
      source: "HAS Antibiothérapie Angine 2021",
    ),
  ],

  'amygdalite': [
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention si origine streptococcique confirmée",
      source: "HAS Antibiothérapie Angine 2021",
    ),
  ],

  'impetigo': [
    DrugPathologyRule(
      drugId: 'amoxicilline_clavulanate',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention pour l'impétigo bulleux ou étendu",
      source: "SPILF Recommandations Impétigo 2019",
    ),
  ],

  'erysipele': [
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention à forte dose (streptocoque bêta-hémolytique)",
      source: "SPILF Recommandations Érysipèle 2019",
    ),
  ],

  'scarlatine': [
    DrugPathologyRule(
      drugId: 'amoxicilline',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention (infection streptococcique)",
      source: "SPILF Recommandations Scarlatine",
    ),
  ],

  'gonorrhee': [
    DrugPathologyRule(
      drugId: 'ceftriaxone',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention en dose unique",
      source: "CDC STI Treatment Guidelines 2021",
    ),
  ],

  'chlamydia': [
    DrugPathologyRule(
      drugId: 'azithromycine',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiotique de 1ère intention en dose unique",
      source: "CDC STI Treatment Guidelines 2021",
    ),
    DrugPathologyRule(
      drugId: 'doxycycline',
      status: DrugPathologyStatus.preferred,
      reason: "Alternative de 1ère intention (7 jours)",
      source: "CDC STI Treatment Guidelines 2021",
    ),
  ],

  'brucellose': [
    DrugPathologyRule(
      drugId: 'doxycycline',
      status: DrugPathologyStatus.preferred,
      reason: "Association de référence avec la rifampicine, 6 semaines",
      source: "WHO Brucellosis Guidelines",
    ),
    DrugPathologyRule(
      drugId: 'rifampicine',
      status: DrugPathologyStatus.preferred,
      reason: "Association de référence avec la doxycycline, 6 semaines",
      source: "WHO Brucellosis Guidelines",
    ),
  ],

  'morsure_chien': [
    DrugPathologyRule(
      drugId: 'amoxicilline_clavulanate',
      status: DrugPathologyStatus.preferred,
      reason: "Antibioprophylaxie/traitement de référence des plaies de morsure",
      source: "IDSA Guidelines Bite Wound Infections 2014",
    ),
  ],

  'intoxication_medicamenteuse': [
    DrugPathologyRule(
      drugId: 'naloxone',
      status: DrugPathologyStatus.preferred,
      reason: "Antidote spécifique en cas de surdosage aux opioïdes suspecté ou confirmé",
      doseAdjustment: "0.4–2 mg IV, à répéter selon la réponse clinique",
      source: "Miller's Anesthesia 9th Ed. Ch.31",
    ),
  ],

  'allergie_alimentaire': [
    DrugPathologyRule(
      drugId: 'adrenaline',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de 1ère intention en cas de réaction anaphylactique déclenchée",
      source: "SFAR Recommandations Anaphylaxie Peranesthésique 2019",
    ),
    DrugPathologyRule(
      drugId: 'dexchlorpheniramine',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement adjuvant de la réaction allergique, après l'adrénaline si anaphylaxie",
      source: "SFAR Recommandations Anaphylaxie Peranesthésique 2019",
    ),
  ],

  'retard_croissance_malnutrition': [
    DrugPathologyRule(
      drugId: 'glucose_10',
      status: DrugPathologyStatus.preferred,
      reason: "Prévention de l'hypoglycémie peropératoire chez l'enfant dénutri",
      source: "Miller's Anesthesia 9th Ed. Ch.44 (pédiatrie)",
    ),
  ],

  'fievre_enfant': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antipyrétique de 1ère intention chez l'enfant",
      source: "HAS Prise en charge de la fièvre chez l'enfant 2016",
    ),
  ],

  'fievre_origine_inconnue': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antipyrétique symptomatique de 1ère intention",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'arthrose': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antalgique de 1ère intention recommandé",
      source: "SFAR Douleur postopératoire 2016",
    ),
  ],

  'cervicalgie': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antalgique de 1ère intention",
      source: "SFAR Douleur postopératoire 2016",
    ),
  ],

  'entorse': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antalgique de 1ère intention",
      source: "SFAR Douleur postopératoire 2016",
    ),
  ],

  'tendinite': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antalgique de 1ère intention",
      source: "SFAR Douleur postopératoire 2016",
    ),
    DrugPathologyRule(
      drugId: 'ketoprofene',
      status: DrugPathologyStatus.caution,
      reason: "Efficace sur la composante inflammatoire — vérifier la fonction rénale avant utilisation",
      source: "SFAR Douleur postopératoire 2016",
    ),
  ],

  'polyarthrite_rhumatoide': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antalgique de 1ère intention, sans interaction avec le traitement de fond",
      source: "SFAR Douleur postopératoire 2016",
    ),
  ],

  'goutte': [
    DrugPathologyRule(
      drugId: 'ketoprofene',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de la crise si fonction rénale normale et absence de contre-indication",
      source: "SFAR/HAS Prise en charge de la Goutte 2020",
    ),
  ],

  'insomnie': [
    DrugPathologyRule(
      drugId: 'midazolam',
      status: DrugPathologyStatus.caution,
      reason: "Tolérance possible en cas d'usage chronique d'hypnotiques — besoins de prémédication majorés",
      source: "Miller's Anesthesia 9th Ed. Ch.9",
    ),
  ],


  // ╔══════════════════════════════════╗
  // ║   NOUVEAUX LIENS — VAGUE 3 (corticoïdes/bronchodilat/insuline/antihistaminiques) ║
  // ╚══════════════════════════════════╝

  'laryngite': [
    DrugPathologyRule(
      drugId: 'dexamethasone',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence de la laryngite aiguë sous-glottique — réduit l'œdème en 2-4h",
      doseAdjustment: "0.15-0.6 mg/kg dose unique (max 10 mg)",
      source: "SFAR/HAS ; Miller's Anesthesia 9th Ed. Ch.44",
    ),
  ],

  'urticaire': [
    DrugPathologyRule(
      drugId: 'dexchlorpheniramine',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence de la manifestation cutanée allergique",
      source: "EAACI Guideline Urticaria 2022",
    ),
  ],

  'rhinite_allergique': [
    DrugPathologyRule(
      drugId: 'dexchlorpheniramine',
      status: DrugPathologyStatus.preferred,
      reason: "Antihistaminique H1 de référence en prémédication chez le patient atopique",
      source: "EAACI Guideline Allergic Rhinitis",
    ),
  ],


  // ╔══════════════════════════════════╗
  // ║   LIENS SUPPLÉMENTAIRES — CATALOGUE EXISTANT  ║
  // ╚══════════════════════════════════╝

  'purpura_thrombopenique': [
    DrugPathologyRule(
      drugId: 'dexamethasone',
      status: DrugPathologyStatus.preferred,
      reason: "Corticothérapie à forte dose — traitement de 1ère ligne du PTI selon les recommandations actuelles",
      doseAdjustment: "40 mg/j x 4 jours (protocole hématologique, hors dose anesthésie standard)",
      source: "ASH Guidelines Immune Thrombocytopenia 2019",
    ),
  ],

  'migraine': [
    DrugPathologyRule(
      drugId: 'ketoprofene',
      status: DrugPathologyStatus.preferred,
      reason: "AINS de 1ère intention pour le traitement de la crise migraineuse",
      source: "SFEMC Recommandations Migraine",
    ),
  ],

  'kyste_ovarien': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antalgique de 1ère intention",
      source: "SFAR Douleur postopératoire 2016",
    ),
  ],

  'fibrome_uterin': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Antalgique de 1ère intention",
      source: "SFAR Douleur postopératoire 2016",
    ),
  ],

  'douleur_thoracique': [
    DrugPathologyRule(
      drugId: 'nitroglycerine',
      status: DrugPathologyStatus.caution,
      reason: "À discuter uniquement si origine coronarienne suspectée (se référer à 'Angor Stable'/'SCA')",
      source: "ESC Guidelines Chest Pain 2023",
    ),
  ],

  'rectorragie': [
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.preferred,
      reason: "Remplissage vasculaire initial si saignement abondant, principes proches de l'hémorragie digestive",
      source: "ESA/ESICM Guidelines management of severe bleeding 2023",
    ),
  ],

  'hemoptysie': [
    DrugPathologyRule(
      drugId: 'nacl_09',
      status: DrugPathologyStatus.caution,
      reason: "Remplissage prudent si hémoptysie massive avec retentissement hémodynamique",
      source: "Miller's Anesthesia 9th Ed. Ch.26",
    ),
  ],


  // ╔══════════════════════════════════╗
  // ║   VAGUE 5 — NOUVELLES CLASSES CRÉÉES (antiviraux, antivenins, hématologie, dermato, ophtalmo, ORL, antipaludéens, hormones) ║
  // ╚══════════════════════════════════╝

  'zona': [
    DrugPathologyRule(
      drugId: 'aciclovir',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement antiviral de référence, surtout si forme ophtalmique ou terrain immunodéprimé",
      source: "SPILF Recommandations Zona",
    ),
  ],

  'herpes': [
    DrugPathologyRule(
      drugId: 'aciclovir',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement antiviral de référence des formes sévères, disséminées ou chez l'immunodéprimé",
      source: "SPILF Recommandations Infections Herpétiques",
    ),
  ],

  'varicelle': [
    DrugPathologyRule(
      drugId: 'aciclovir',
      status: DrugPathologyStatus.preferred,
      reason: "Indiqué dans les formes compliquées, chez l'adulte ou l'immunodéprimé",
      source: "SPILF Recommandations Varicelle",
    ),
  ],

  'grippe': [
    DrugPathologyRule(
      drugId: 'oseltamivir',
      status: DrugPathologyStatus.preferred,
      reason: "Antiviral de référence si débuté dans les 48h suivant le début des symptômes",
      source: "HAS/SPILF Recommandations Grippe",
    ),
  ],

  'piqure_scorpion': [
    DrugPathologyRule(
      drugId: 'serum_antiscorpionique',
      status: DrugPathologyStatus.preferred,
      reason: "Réservé aux formes sévères avec signes systémiques (grade II-III)",
      source: "Protocoles nationaux envenimation scorpionique",
    ),
  ],

  'envenimation_serpent': [
    DrugPathologyRule(
      drugId: 'serum_antivenimeux_polyvalent',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence en cas de syndrome hémorragique, neurotoxique ou myotoxique systémique",
      source: "WHO Guidelines Snakebite Envenoming 2019",
    ),
  ],

  'rage': [
    DrugPathologyRule(
      drugId: 'immunoglobuline_antirabique',
      status: DrugPathologyStatus.preferred,
      reason: "Immunoprophylaxie post-exposition, associée systématiquement à la vaccination",
      source: "WHO Rabies Guidelines",
    ),
  ],

  'anemie_ferriprive': [
    DrugPathologyRule(
      drugId: 'fer_carboxymaltose',
      status: DrugPathologyStatus.preferred,
      reason: "Optimisation préopératoire dans le cadre du Patient Blood Management",
      source: "SFAR/GIHP Patient Blood Management 2020",
    ),
  ],

  'drepanocytose': [
    DrugPathologyRule(
      drugId: 'hydroxyuree',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de fond réduisant la fréquence des crises vaso-occlusives",
      source: "SFH Recommandations Drépanocytose",
    ),
  ],

  'thalassemie': [
    DrugPathologyRule(
      drugId: 'hydroxyuree',
      status: DrugPathologyStatus.caution,
      reason: "Indication plus limitée — réservée à certaines formes intermédiaires (induction de l'HbF)",
      source: "SFH Recommandations Thalassémie",
    ),
  ],

  'gale': [
    DrugPathologyRule(
      drugId: 'permethrine',
      status: DrugPathologyStatus.preferred,
      reason: "Scabicide topique de référence, 1ère intention",
      source: "SPILF Recommandations Gale",
    ),
  ],

  'dermatophytie': [
    DrugPathologyRule(
      drugId: 'terbinafine',
      status: DrugPathologyStatus.preferred,
      reason: "Antifongique de référence, topique ou oral selon l'étendue",
      source: "Recommandations dermatologiques SFD",
    ),
  ],

  'eczema': [
    DrugPathologyRule(
      drugId: 'betamethasone_topique',
      status: DrugPathologyStatus.preferred,
      reason: "Dermocorticoïde de référence pour les poussées inflammatoires",
      source: "SFD Recommandations Eczéma",
    ),
  ],

  'psoriasis': [
    DrugPathologyRule(
      drugId: 'betamethasone_topique',
      status: DrugPathologyStatus.preferred,
      reason: "Dermocorticoïde de référence pour les formes localisées",
      source: "SFD Recommandations Psoriasis",
    ),
  ],

  'acne': [
    DrugPathologyRule(
      drugId: 'tretinoine_topique',
      status: DrugPathologyStatus.preferred,
      reason: "Rétinoïde topique de référence pour les formes comédoniennes/inflammatoires légères à modérées",
      source: "SFD Recommandations Acné",
    ),
  ],

  'conjonctivite': [
    DrugPathologyRule(
      drugId: 'collyre_antibiotique',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence de la conjonctivite bactérienne",
      source: "SFO Recommandations Conjonctivite",
    ),
  ],

  'keratite': [
    DrugPathologyRule(
      drugId: 'collyre_antibiotique',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement des formes bactériennes légères — avis ophtalmologique urgent si forme sévère",
      source: "SFO Recommandations Kératite",
    ),
  ],

  'cataracte': [
    DrugPathologyRule(
      drugId: 'collyre_mydriatique',
      status: DrugPathologyStatus.preferred,
      reason: "Préparation mydriatique standard avant chirurgie de la cataracte",
      source: "SFO Recommandations Chirurgie Cataracte",
    ),
  ],

  'otite_externe': [
    DrugPathologyRule(
      drugId: 'gouttes_auriculaires_ab_corticoide',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement local de référence de l'otite externe bactérienne",
      source: "HAS Recommandations Otite Externe",
    ),
  ],

  'paludisme': [
    DrugPathologyRule(
      drugId: 'artemether_lumefantrine',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence du paludisme simple — le paludisme grave nécessite l'artésunate IV en centre spécialisé",
      source: "WHO Guidelines Malaria Treatment 2023",
    ),
  ],

  'syphilis': [
    DrugPathologyRule(
      drugId: 'benzathine_penicilline',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence international, tous stades",
      source: "CDC STI Treatment Guidelines 2021",
    ),
  ],

  'detresse_respiratoire_neonatale': [
    DrugPathologyRule(
      drugId: 'poractant_alfa',
      status: DrugPathologyStatus.preferred,
      reason: "Surfactant exogène de référence dans la maladie des membranes hyalines",
      source: "European Consensus Guidelines RDS Management 2023",
    ),
  ],

  'sopk': [
    DrugPathologyRule(
      drugId: 'metformine',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de l'insulinorésistance associée — à arrêter avant chirurgie majeure/contraste iodé",
      source: "ESHRE/ASRM Guidelines PCOS 2023",
    ),
  ],

  'syndrome_metabolique': [
    DrugPathologyRule(
      drugId: 'metformine',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de l'insulinorésistance associée — à arrêter avant chirurgie majeure/contraste iodé",
      source: "ADA Standards of Care Diabetes 2024",
    ),
  ],


  // ╔══════════════════════════════════╗
  // ║   VAGUE 6 — DERNIERS LIENS POUR 100% (nouvelles classes + réutilisation catalogue) ║
  // ╚══════════════════════════════════╝

  'vih': [
    DrugPathologyRule(
      drugId: 'ritonavir',
      status: DrugPathologyStatus.caution,
      reason: "Exemple d'antirétroviral boosté à fort potentiel d'interaction — inhibiteur puissant du CYP3A4 affectant fentanyl/midazolam. Toujours vérifier le traitement ARV réel du patient",
      source: "Miller's Anesthesia 9th Ed. Ch.16 ; Liverpool HIV Drug Interactions",
    ),
  ],

  'leucemie_aigue': [
    DrugPathologyRule(
      drugId: 'piperacilline_tazobactam',
      status: DrugPathologyStatus.preferred,
      reason: "Antibiothérapie probabiliste de référence en cas de neutropénie fébrile",
      source: "IDSA Guidelines Febrile Neutropenia 2011 (réaffirmées)",
    ),
  ],

  'lymphome': [
    DrugPathologyRule(
      drugId: 'piperacilline_tazobactam',
      status: DrugPathologyStatus.caution,
      reason: "Antibiothérapie probabiliste de référence si neutropénie fébrile associée à la chimiothérapie",
      source: "IDSA Guidelines Febrile Neutropenia 2011 (réaffirmées)",
    ),
  ],

  'hepatite_b': [
    DrugPathologyRule(
      drugId: 'entecavir',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement antiviral de référence de l'hépatite B chronique active — ne jamais interrompre brutalement en périopératoire",
      source: "EASL Clinical Practice Guidelines Hepatitis B 2017",
    ),
  ],

  'hepatite_c': [
    DrugPathologyRule(
      drugId: 'sofosbuvir_velpatasvir',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement antiviral à action directe pangénotypique de référence",
      source: "EASL Recommendations on Treatment of Hepatitis C 2023",
    ),
  ],

  'rougeole': [
    DrugPathologyRule(
      drugId: 'vitamine_a',
      status: DrugPathologyStatus.preferred,
      reason: "Supplémentation systématique recommandée par l'OMS chez l'enfant — réduit la morbi-mortalité",
      source: "WHO Guideline Vitamin A Supplementation in Measles",
    ),
  ],

  'oreillons': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement symptomatique de la fièvre et des douleurs — pas de traitement antiviral spécifique",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'rubeole': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement symptomatique — pas de traitement antiviral spécifique",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'pharyngite_virale': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement symptomatique de la douleur et de la fièvre — pas d'antibiotique (origine virale)",
      source: "HAS Antibiothérapie Angine 2021",
    ),
  ],

  'leishmaniose': [
    DrugPathologyRule(
      drugId: 'amphotericine_b_liposomale',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence de la forme viscérale",
      source: "WHO Guidelines Visceral Leishmaniasis",
    ),
  ],

  'vertige': [
    DrugPathologyRule(
      drugId: 'dexchlorpheniramine',
      status: DrugPathologyStatus.caution,
      reason: "Antihistaminique sédatif utile en traitement symptomatique des vertiges d'origine vestibulaire",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'dyspnee': [
    DrugPathologyRule(
      drugId: 'salbutamol',
      status: DrugPathologyStatus.caution,
      reason: "À discuter si composante bronchospastique suspectée associée à la dyspnée",
      source: "GINA Guidelines Asthma 2023",
    ),
  ],

  'douleur_abdominale_aigue': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.caution,
      reason: "Analgésie initiale raisonnable — ne retarde pas le diagnostic chirurgical selon les données actuelles",
      source: "Cochrane Review Analgesia in Acute Abdominal Pain 2011",
    ),
  ],

  'polyurie_polydipsie': [
    DrugPathologyRule(
      drugId: 'insuline_rapide',
      status: DrugPathologyStatus.caution,
      reason: "À discuter uniquement si hyperglycémie confirmée — se référer à 'Diabète'/'Acidocétose Diabétique'",
      source: "ADA Standards of Care Diabetes 2024",
    ),
  ],

  'oedemes': [
    DrugPathologyRule(
      drugId: 'furosemide',
      status: DrugPathologyStatus.preferred,
      reason: "Diurétique de référence selon la cause (cardiaque, rénale, hépatique)",
      source: "ESC Guidelines Heart Failure 2021",
    ),
  ],

  'syndrome_inflammatoire': [
    DrugPathologyRule(
      drugId: 'paracetamol',
      status: DrugPathologyStatus.caution,
      reason: "Traitement symptomatique de la fièvre associée — ne traite pas la cause sous-jacente",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'retention_urinaire': [
    DrugPathologyRule(
      drugId: 'tamsulosine',
      status: DrugPathologyStatus.preferred,
      reason: "Facilite la reprise des mictions après sondage évacuateur si cause prostatique",
      source: "AUA Guideline Benign Prostatic Hyperplasia 2021",
    ),
  ],

  'rgo': [
    DrugPathologyRule(
      drugId: 'omeprazole',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence — également utile en prémédication si RGO sévère avant anesthésie",
      source: "SFAR Recommandations Estomac Plein 2023",
    ),
  ],

  'goitre': [
    DrugPathologyRule(
      drugId: 'levothyroxine',
      status: DrugPathologyStatus.caution,
      reason: "Traitement substitutif si hypothyroïdie associée au goitre",
      source: "ETA Guidelines Management of Goitre",
    ),
  ],

  'ictere_neonatal': [
    DrugPathologyRule(
      drugId: 'immunoglobuline_iv_polyvalente',
      status: DrugPathologyStatus.caution,
      reason: "Réservée aux formes sévères par allo-immunisation Rh/ABO réfractaires à la photothérapie seule",
      source: "AAP Clinical Practice Guideline Hyperbilirubinemia 2022",
    ),
  ],

  'intoxication_co': [
    DrugPathologyRule(
      drugId: 'oxygene_medical',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence de 1ère intention — réduit la demi-vie de l'HbCO de 5h à ~1-1.5h",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'corps_etranger_orl': [
    DrugPathologyRule(
      drugId: 'dexamethasone',
      status: DrugPathologyStatus.caution,
      reason: "Prévention de l'œdème des voies aériennes après extraction endoscopique",
      source: "Miller's Anesthesia 9th Ed. Ch.44",
    ),
  ],

  'osteoporose': [
    DrugPathologyRule(
      drugId: 'acide_zoledronique',
      status: DrugPathologyStatus.preferred,
      reason: "Traitement de référence de l'ostéoporose — administré en ambulatoire, jamais en périopératoire aigu",
      source: "ASBMR/Endocrine Society Guidelines Osteoporosis",
    ),
  ],

  'menace_accouchement_premature': [
    DrugPathologyRule(
      drugId: 'nifedipine',
      status: DrugPathologyStatus.preferred,
      reason: "Tocolytique de 1ère intention avec l'atosiban — jamais associé au sulfate de magnésium",
      source: "CNGOF Recommandations MAP",
    ),
  ],

  'syndrome_intestin_irritable': [
    DrugPathologyRule(
      drugId: 'phloroglucinol',
      status: DrugPathologyStatus.preferred,
      reason: "Antispasmodique symptomatique de la composante douloureuse",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

  'syncope': [
    DrugPathologyRule(
      drugId: 'ephedrine',
      status: DrugPathologyStatus.caution,
      reason: "À discuter uniquement si composante hypotensive documentée — la syncope nécessite avant tout un bilan étiologique",
      source: "Miller's Anesthesia 9th Ed. Ch.20",
    ),
  ],

}; // ← NE PAS SUPPRIMER


// ══════════════════════════════════════════════════════════════
//  📋 MODÈLE — COPIER CE BLOC POUR AJOUTER DES RÈGLES
// ══════════════════════════════════════════════════════════════
//
//  ÉTAPE 1 : Ajouter une nouvelle entrée dans pathologyDrugRules
//  ÉTAPE 2 : L'id DOIT correspondre exactement à la Pathologie
//            définie dans pathologies_data.dart
//  ÉTAPE 3 : Ajouter un DrugPathologyRule par médicament concerné
//
// ─────────────────────────────────────────────────────────────
//
//  'mon_id_unique': [
//
//    // ─── Médicaments recommandés ⭐ ──────────────────────────
//    DrugPathologyRule(
//      drugId: 'propofol',                         // ID médicament
//      status: DrugPathologyStatus.preferred,       // ⭐ recommandé
//      reason: 'Explication affichée dans l\'app',
//      source: 'Référence bibliographique (auteur, revue, année)',
//    ),
//
//    // ─── Médicaments à utiliser avec prudence ⚠️ ────────────
//    DrugPathologyRule(
//      drugId: 'ketamine',
//      status: DrugPathologyStatus.caution,         // ⚠️ prudence
//      reason: 'Explication du risque',
//      doseAdjustment: 'Comment adapter la dose',   // optionnel
//      source: 'Référence bibliographique',
//    ),
//
//    // ─── Médicaments contre-indiqués ❌ ─────────────────────
//    DrugPathologyRule(
//      drugId: 'morphine',
//      status: DrugPathologyStatus.contraindicated, // ❌ contre-indiqué
//      reason: 'Explication de la contre-indication',
//      source: 'Référence bibliographique',
//    ),
//
//  ],
//
// ══════════════════════════════════════════════════════════════
