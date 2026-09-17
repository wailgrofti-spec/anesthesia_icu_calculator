// ============================================================================
//  lib/models/drug.dart
//  VERSION 3.0 — Sources médicales inline sur chaque concept pharmacologique
//
//  AUDIT MÉDICAL v3.0 :
//  Chaque enum, extension et règle pharmacologique est sourcé.
//  Les catégories, métabolismes et stratégies de poids sont tracés.
//
//  Sources référencées :
//  [M9]   Miller's Anesthesia, 9th ed. — Gropper MA et al., Elsevier 2020.
//  [STO]  Stoelting's Pharmacology & Physiology in Anesthetic Practice, 5th ed.
//         Flood P et al., LWW 2015.
//  [GG]   Goodman & Gilman's Pharmacological Basis of Therapeutics, 13th ed.
//         Brunton LL et al., McGraw-Hill 2018.
//  [SFAR] SFAR — Recommandations formalisées d'experts, anesthésie-réanimation.
//  [VID]  Vidal — Base de données médicamenteuse, édition 2024.
//  [ANSM] ANSM — Résumés des Caractéristiques du Produit (RCP) officiels.
//  [UPDT] UpToDate — Drug information monographs (Lexicomp), 2024.
//  [MART] Martindale: The Complete Drug Reference, 39th ed.
//  [EASL] EASL Clinical Practice Guidelines — liver disease. J Hepatol. 2023.
//  [KDIGO] KDIGO Clinical Practice Guidelines for CKD. 2023.
// ============================================================================

import 'package:flutter/material.dart';

// ============================================================================
//  ENUMS
// ============================================================================

// ── Phase clinique ────────────────────────────────────────────
// Workflow anesthésie-réanimation standard [M9 §1 ; SFAR].
// Phase 1 = agents actifs peropératoires
// Phase 2 = adjuvants et logistique
enum Phase { phase1, phase2 }

extension PhaseLabel on Phase {
  String get label {
    switch (this) {
      case Phase.phase1: return 'Phase 1 — Anesthésie / Réanimation';
      case Phase.phase2: return 'Phase 2 — Adjuvants / Logistique';
    }
  }
}

// ── Catégorie pharmacologique ─────────────────────────────────
//
// Classification basée sur le mécanisme d'action principal [M9 §14–§30 ; STO] :
//
// sedation    → Hypnotiques/Anesthésiques généraux (propofol, kétamine,
//               midazolam, thiopental). Mécanismes : GABA-A, NMDA, récepteurs
//               volatiles. [M9 §22–§24 ; STO §2–§5]
//
// analgesia   → Opioïdes (morphine, fentanyl, rémifentanil, sufentanil)
//               et antalgiques (kétorolac, paracétamol IV). [M9 §29–§30 ; STO §7]
//
// nmb         → Curares : dépolarisants (succinylcholine) et non dépolarisants
//               (rocuronium, vécuronium, atracurium, cisatracurium). [M9 §28 ; STO §11]
//
// vasoactive  → Vasopresseurs (noradrénaline, adrénaline, vasopressine)
//               et inotropes (dobutamine, milrinone, levosimendan). [M9 §35 ; STO §14]
//
// antibiotic  → Antibiotiques de prophylaxie et traitement péri-opératoire.
//               [SFAR — Antibioprophylaxie 2017 ; M9 §86]
//
// fluid       → Solutions de remplissage vasculaire : cristalloïdes (NaCl 0.9%,
//               Ringer Lactate) et colloïdes (HEA, albumine). [M9 §51 ; SFAR 2019]
//
// other       → Antidotes, antihypertenseurs, antihistaminiques, dantrolène, etc.

enum DrugCategory {
  sedation,    // [M9 §22–§24] Hypnotiques / Anesthésiques généraux
  analgesia,   // [M9 §29–§30] Opioïdes et antalgiques
  nmb,         // [M9 §28]     Curares (NMB agents)
  vasoactive,  // [M9 §35]     Vasopresseurs / Inotropes
  antibiotic,  // [M9 §86]     Antibiotiques péri-opératoires
  fluid,       // [M9 §51]     Solutions de remplissage
  other,       // Catégorie résiduelle
}

// ── Unités de dose ────────────────────────────────────────────
//
// Couvre l'ensemble des modalités de dosage en anesthésie [M9 §26 ; ANSM] :
//   Bolus  : mg/kg, mcg/kg (administration unique en IV directe)
//   Perf.  : mg/kg/h, mcg/kg/h, mcg/kg/min (SAP / AIVOC)
//   Soluté : ml/kg/h, ml/kg (volume de remplissage)
//   Fixe   : unités indépendantes du poids (ex : UI insuline, unités vasopressine)

enum DoseUnit {
  mgPerKg,      // mg/kg      → bolus IV direct [M9 §26]
  mcgPerKg,     // mcg/kg     → bolus (opioïdes puissants) [M9 §29]
  mgPerKgH,     // mg/kg/h    → perfusion continue SAP [M9 §26]
  mcgPerKgMin,  // mcg/kg/min → vasopresseurs (noradrénaline, dopamine) [M9 §35]
  mcgPerKgH,    // mcg/kg/h   → perfusion continue (dexmédétomidine) [M9 §24]
  mlPerKgH,     // ml/kg/h    → solutés de remplissage [M9 §51]
  mlPerKg,      // ml/kg      → bolus soluté [M9 §51]
  unitsFixed,   // Unités fixes — UI insuline, vasopressine, ocytocine [ANSM]
}

// ── Voie de métabolisme ───────────────────────────────────────
//
// Détermine les ajustements de dose en cas d'insuffisance hépatique ou rénale.
// Source : [M9 §26 ; GG §2–§4 ; EASL 2023 ; KDIGO 2023]
//
// hepatique   → CYP450 (principalement CYP3A4) :
//               propofol, midazolam, fentanyl, vécuronium, lidocaïne [GG]
//               → Ajustement si Child-Pugh B/C [EASL 2023]
//
// renal       → Élimination rénale prédominante :
//               morphine-6-glucuronide, atracurium (métabolites), aminosides [GG]
//               → Ajustement si DFG < 30 ml/min [KDIGO 2023]
//
// plasmatique → Hydrolyse par pseudo-cholinestérases / estérases plasmatiques :
//               rémifentanil (demi-vie 3 min), succinylcholine, mivacurium,
//               esmolol, cisatracurium (Hofmann + estérases) [M9 §28 ; GG]
//               → Pas d'ajustement IR/IH (indépendant organes)
//
// biliaire    → Excrétion biliaire prédominante :
//               vécuronium (40%), pancuronium [M9 §28]
//               → Ajustement si cholestase / cirrhose sévère [EASL 2023]
//
// mixte       → Voies hépatique + rénale :
//               fentanyl (CYP3A4 + rein partiel), morphine (hépato-rénal) [GG]
//               → Ajustement si les deux défaillances

enum Metabolisme {
  hepatique,   // CYP450 (CYP3A4 +++) [GG §2] — propofol, midazolam, vécuronium
  renal,       // Élimination rénale  [GG §3] — morphine-6G, gabapentine
  plasmatique, // Estérases plasma    [GG §4] — rémifentanil, succinylcholine
  biliaire,    // Excrétion biliaire  [M9 §28] — vécuronium, pancuronium
  mixte,       // Hépato-rénal        [GG §2-3] — fentanyl, morphine
  inconnu,
}

/// Niveau d'urgence clinique — affichage UI.
enum UrgenceLevel { normal, caution, contraindicated }

// ── Risque grossesse / allaitement (antibiotiques) ─────────────
//
// Classification qualitative utilisée pour les antibiotiques, faute de
// classe FDA A/B/C/D/X officiellement retirée en 2015 [FDA PLLR 2015].
// Sources : [CRAT — Centre de Référence sur les Agents Tératogènes,
// lecrat.fr] ; [EASL/SPILF] ; [ANSM RCP de chaque molécule].
enum RisqueGrossesse {
  compatible,             // Utilisable à tous les termes [CRAT]
  prudence,               // Utilisable si besoin, données rassurantes mais partielles
  eviterSaufNecessite,    // Éviter sauf si bénéfice > risque documenté
  contreIndique,          // CI à un ou plusieurs trimestres [CRAT ; ANSM RCP]
  donneesInsuffisantes,   // Données humaines insuffisantes — prudence par défaut
}

enum RisqueAllaitement {
  compatible,
  prudence,
  eviter,
  contreIndique,
  donneesInsuffisantes,
}

extension RisqueGrossesseLabel on RisqueGrossesse {
  String get label {
    switch (this) {
      case RisqueGrossesse.compatible:           return 'Compatible';
      case RisqueGrossesse.prudence:              return 'Utilisable avec prudence';
      case RisqueGrossesse.eviterSaufNecessite:   return 'À éviter sauf nécessité';
      case RisqueGrossesse.contreIndique:         return 'Contre-indiqué';
      case RisqueGrossesse.donneesInsuffisantes:  return 'Données insuffisantes';
    }
  }
}

extension RisqueAllaitementLabel on RisqueAllaitement {
  String get label {
    switch (this) {
      case RisqueAllaitement.compatible:          return 'Compatible';
      case RisqueAllaitement.prudence:            return 'Utilisable avec prudence';
      case RisqueAllaitement.eviter:              return 'À éviter';
      case RisqueAllaitement.contreIndique:       return 'Contre-indiqué';
      case RisqueAllaitement.donneesInsuffisantes:return 'Données insuffisantes';
    }
  }
}

// ============================================================================
//  SPECTRE BACTÉRIEN & PROFIL ANTIBIOTIQUE
// ============================================================================
//
// Sources : [SPILF — Spilf.fr, référentiels par pathologie] ;
// [EUCAST — European Committee on Antimicrobial Susceptibility Testing] ;
// [SFAR — Antibioprophylaxie en chirurgie, actualisation 2017-2018] ;
// [Sanford Guide to Antimicrobial Therapy, éd. courante].
//
// NOTE : le spectre est une orientation clinique générale (couverture
// "habituelle" de la molécule). Il ne remplace jamais un antibiogramme.

/// Couverture bactérienne indicative d'un antibiotique.
/// Chaque champ = couverture "utile en pratique courante" (pas exhaustif).
class AntibioticSpectrum {
  final bool gramPositif;
  final bool gramNegatif;
  final bool anaerobies;
  final bool pseudomonas;
  final bool mrsa;         // Staphylococcus aureus résistant à la méticilline
  final bool enterococcus;
  final bool esbl;         // Couverture des entérobactéries BLSE

  const AntibioticSpectrum({
    this.gramPositif  = false,
    this.gramNegatif  = false,
    this.anaerobies   = false,
    this.pseudomonas  = false,
    this.mrsa         = false,
    this.enterococcus = false,
    this.esbl         = false,
  });
}

/// Profil clinique complet d'un antibiotique — complète [Drug] pour la
/// catégorie [DrugCategory.antibiotic]. Champ optionnel : ne s'applique
/// qu'aux antibiotiques, laissant [Drug] inchangé pour les autres classes.
///
/// Sources : [SPILF] [EUCAST] [SFAR Antibioprophylaxie 2017-2018]
/// [CRAT — lecrat.fr] [KDIGO 2023] [EASL 2023] [ANSM RCP].
class AntibioticProfile {
  // ── Spectre & usage ───────────────────────────────────────
  final AntibioticSpectrum spectre;
  final List<String> infectionsTraitees;      // Infections cibles en pratique
  final bool utiliseEnProphylaxieChirurgicale;
  final String? protocoleProphylaxie;         // Ex : dose, timing, réinjection

  // ── Sécurité spécifique ───────────────────────────────────
  final List<String> allergiesCroisees;

  final RisqueGrossesse grossesse;
  final String? grossesseDetail;
  final RisqueAllaitement allaitement;
  final String? allaitementDetail;

  // ── Pharmacocinétique / ajustements d'organe ──────────────
  final String demiVie;              // Ex : '1.5–2 h (fonction rénale normale)'
  final String eliminationVoie;      // Ex : 'Rénale 90% forme inchangée'
  final String ajustementRenal;      // Texte : conduite à tenir selon DFG/ClCr
  final String ajustementHepatique;  // Texte : conduite à tenir selon Child-Pugh

  // ── Posologie journalière (complète bolus/infusion de Drug) ─
  final double? doseAdulteMinMgKgJour;
  final double? doseAdulteMaxMgKgJour;
  final int?    nombrePrisesParJour;
  final double? doseMaxParJourG;     // Plafond absolu, en grammes/jour

  // ── Stabilité / surveillance ──────────────────────────────
  final String? stabiliteApresDilutionDetail; // Complète Drug.conservationH
  final List<String> surveillanceBiologique;  // Distinct de Drug.surveillance (clinique)
  final String? remarques;

  const AntibioticProfile({
    this.spectre = const AntibioticSpectrum(),
    this.infectionsTraitees = const [],
    this.utiliseEnProphylaxieChirurgicale = false,
    this.protocoleProphylaxie,
    this.allergiesCroisees = const [],
    this.grossesse = RisqueGrossesse.donneesInsuffisantes,
    this.grossesseDetail,
    this.allaitement = RisqueAllaitement.donneesInsuffisantes,
    this.allaitementDetail,
    required this.demiVie,
    required this.eliminationVoie,
    required this.ajustementRenal,
    required this.ajustementHepatique,
    this.doseAdulteMinMgKgJour,
    this.doseAdulteMaxMgKgJour,
    this.nombrePrisesParJour,
    this.doseMaxParJourG,
    this.stabiliteApresDilutionDetail,
    this.surveillanceBiologique = const [],
    this.remarques,
  });
}

// ============================================================================
//  OPIOÏDES — PROFIL PHARMACOLOGIQUE DÉTAILLÉ
// ============================================================================
//
// Complète [Drug] pour la catégorie DrugCategory.analgesia (sous-ensemble
// opioïde et antagonistes). Suit le même principe que [AntibioticProfile] /
// [FluidProfile] : champ optionnel, ne modifie/ne casse rien pour les
// médicaments non-opioïdes (paracétamol, AINS, etc. restent avec
// opioidProfile == null).
//
// Sources : [M9 §29-30] ; [STO §7] ; [GG §20] ; [ANSM RCP] ; [UPDT 2024] ;
// [SFAR — Douleur postopératoire, RFE 2016] ; [EAPC — Opioid conversion
// ratios, guide 2012 (Caraceni et al.)] ; [WHO Analgesic Ladder] ;
// [ANSM — Répertoire des équivalences morphiniques, 2021].
//
// NOTE MÉDICALE : les facteurs d'équivalence morphinique (OME — Oral
// Morphine Equivalent) varient selon les sources et le contexte clinique
// (douleur aiguë vs chronique, rotation d'opioïdes). Les valeurs indiquées
// sont des ORDRES DE GRANDEUR consensuels utilisés pour une rotation
// prudente — elles ne remplacent JAMAIS un avis spécialisé douleur/
// pharmacologie clinique pour une rotation réelle chez un patient.

/// Classe pharmacologique vis-à-vis des récepteurs opioïdes. [GG §20]
enum OpioidClass {
  agonistePur,          // morphine, fentanyl, sufentanil, rémifentanil, oxycodone...
  agonisteFaible,       // tramadol, codéine, dihydrocodéine (faible affinité μ)
  agonistePartiel,      // buprénorphine
  agonisteAntagoniste,  // nalbuphine (agoniste κ / antagoniste μ)
  antagoniste,          // naloxone, naltrexone
}

extension OpioidClassLabel on OpioidClass {
  String get label {
    switch (this) {
      case OpioidClass.agonistePur:         return 'Agoniste pur';
      case OpioidClass.agonisteFaible:      return 'Agoniste faible';
      case OpioidClass.agonistePartiel:     return 'Agoniste partiel';
      case OpioidClass.agonisteAntagoniste: return 'Agoniste-antagoniste';
      case OpioidClass.antagoniste:         return 'Antagoniste';
    }
  }
}

/// Affinité/effet qualitatif sur un récepteur opioïde donné. [GG §20 ; STO §7]
enum RecepteurEffet { aucun, antagoniste, partiel, faible, modere, fort }

extension RecepteurEffetLabel on RecepteurEffet {
  String get label {
    switch (this) {
      case RecepteurEffet.aucun:       return 'Aucun effet';
      case RecepteurEffet.antagoniste: return 'Antagoniste';
      case RecepteurEffet.partiel:     return 'Agoniste partiel';
      case RecepteurEffet.faible:      return 'Agoniste faible';
      case RecepteurEffet.modere:      return 'Agoniste modéré';
      case RecepteurEffet.fort:        return 'Agoniste fort';
    }
  }
}

/// Profil d'activité sur les trois récepteurs opioïdes classiques μ/κ/δ.
/// [GG §20 ; STO §7 ; M9 §29]
class OpioidReceptorProfile {
  final RecepteurEffet mu;     // Récepteur μ (mu) — analgésie, dépression respi
  final RecepteurEffet kappa;  // Récepteur κ (kappa) — analgésie spinale, dysphorie
  final RecepteurEffet delta;  // Récepteur δ (delta) — rôle mineur clinique

  const OpioidReceptorProfile({
    required this.mu,
    this.kappa = RecepteurEffet.aucun,
    this.delta = RecepteurEffet.aucun,
  });
}

/// Niveau de risque qualitatif — réutilisé pour tous les risques cliniques
/// affichés par opioïde (dépression respiratoire, hypotension, prurit...).
/// [ANSM RCP ; UPDT 2024 ; M9 §29-30]
enum RiskLevel { nul, faible, modere, eleve, nonDocumente }

extension RiskLevelLabel on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.nul:          return 'Nul / négligeable';
      case RiskLevel.faible:       return 'Faible';
      case RiskLevel.modere:       return 'Modéré';
      case RiskLevel.eleve:        return 'Élevé';
      case RiskLevel.nonDocumente: return 'Non documenté';
    }
  }

  String get emoji {
    switch (this) {
      case RiskLevel.nul:          return '⚪';
      case RiskLevel.faible:       return '🟢';
      case RiskLevel.modere:       return '🟡';
      case RiskLevel.eleve:        return '🔴';
      case RiskLevel.nonDocumente: return '❓';
    }
  }
}

/// Protocole d'Analgésie Contrôlée par le Patient (PCA/PCEA), lorsque la
/// molécule est utilisée sous ce mode. [SFAR RFE Douleur Postop 2016]
class PcaProtocol {
  final double  bolusDoseMg;         // Dose bolus déclenchée par le patient
  final int     lockoutMinutes;      // Période réfractaire (verrouillage)
  final double? doseMaxHoraireMg;    // Plafond horaire (limite de sécurité)
  final double? debitContinuMgH;     // Débit de fond optionnel (souvent déconseillé hors contexte spécifique)
  final String? notes;

  const PcaProtocol({
    required this.bolusDoseMg,
    required this.lockoutMinutes,
    this.doseMaxHoraireMg,
    this.debitContinuMgH,
    this.notes,
  });
}

/// Profil clinique complet d'un opioïde (ou antagoniste opioïde) — complète
/// [Drug] pour la catégorie [DrugCategory.analgesia], sur le même principe
/// que [AntibioticProfile] pour les antibiotiques et [FluidProfile] pour les
/// solutés. Champ optionnel : laisse [Drug] inchangé pour les non-opioïdes
/// (paracétamol, AINS).
///
/// Sources : [M9 §29-30][STO §7][GG §20][ANSM RCP][UPDT 2024][SFAR 2016]
/// [EAPC 2012][KDIGO 2023][EASL 2023].
class OpioidProfile {
  // ── Classification / pharmacodynamie ──────────────────────
  final OpioidClass classe;
  final OpioidReceptorProfile recepteurs;

  // ── Puissance / équivalence morphinique ───────────────────
  final double? facteurOMEVsMorphineOrale;
  final String equivalenceMorphiniqueDetail;
  final String puissanceRelative;

  // ── Pharmacocinétique complémentaire ──────────────────────
  final String  demiVie;
  final String? picActionDelai;
  final String  eliminationDetail;

  // ── Risques cliniques qualitatifs ──────────────────────────
  final RiskLevel depressionRespiratoire;
  final RiskLevel hypotension;
  final RiskLevel rigiditeThoracique;
  final RiskLevel nauseeVomissement;
  final RiskLevel prurit;
  final RiskLevel retentionUrinaire;
  final RiskLevel dependance;
  final RiskLevel syndromeSevrage;

  // ── Antidote / surdosage ──────────────────────────────────
  final String? antidoteRecommande;
  final String  conduiteSurdosage;

  // ── PCA (si applicable) ────────────────────────────────────
  final PcaProtocol? pca;

  // ── Dépendance / sevrage (opioïdes chroniques) ─────────────
  final String? sevrageDelaiApparition;
  final String? sevrageSymptomes;

  const OpioidProfile({
    required this.classe,
    required this.recepteurs,
    this.facteurOMEVsMorphineOrale,
    required this.equivalenceMorphiniqueDetail,
    required this.puissanceRelative,
    required this.demiVie,
    this.picActionDelai,
    required this.eliminationDetail,
    this.depressionRespiratoire = RiskLevel.nonDocumente,
    this.hypotension            = RiskLevel.nonDocumente,
    this.rigiditeThoracique      = RiskLevel.nul,
    this.nauseeVomissement       = RiskLevel.nonDocumente,
    this.prurit                  = RiskLevel.nonDocumente,
    this.retentionUrinaire       = RiskLevel.nonDocumente,
    this.dependance              = RiskLevel.nonDocumente,
    this.syndromeSevrage         = RiskLevel.nonDocumente,
    this.antidoteRecommande,
    required this.conduiteSurdosage,
    this.pca,
    this.sevrageDelaiApparition,
    this.sevrageSymptomes,
  });

  bool get aUnePca => pca != null;
  bool get estAntagoniste => classe == OpioidClass.antagoniste;
}

// ============================================================================
//  SOLUTÉS DE REMPLISSAGE — PROFIL DÉTAILLÉ
// ============================================================================
//
// Sources : [M9 §51] ; [SFAR — Remplissage vasculaire péri-opératoire 2019
// (SFAR/SFMU)] ; [ESICM — Fluid therapy guidelines 2014] ; [Surviving Sepsis
// Campaign 2021] ; [KDIGO 2023] ; [ANSM RCP officiels de chaque soluté] ;
// [Marino's The ICU Book, 4th ed.] ; [Miller's Anesthesia 9th ed. Ch.51].
//
// NOTE MÉDICALE : les valeurs de composition/osmolarité varient légèrement
// selon le fabricant (ex : Ringer Acétate, Isolyte). Quand une valeur n'a pas
// pu être vérifiée avec certitude sur une source de référence, le champ est
// laissé à `null` plutôt que rempli arbitrairement — voir commentaire sur
// chaque instance dans fluids_data.dart.

/// Type de soluté — utilisé pour le regroupement/filtre dans l'écran.
enum FluidType {
  cristalloide,               // NaCl, Ringer, Plasma-Lyte, glucosés isotoniques
  colloide,                   // Albumine
  solutionGlucosee,           // Glucose 5/10/20/30/50%
  solutionHypertonique,       // NaCl 3%/7.5%, bicarbonate 4.2%/8.4%, glucose >10%
  solutionTamponnee,          // Bicarbonate, Plasma-Lyte, Ringer (lactate/acétate)
  produitOsmotique,           // Mannitol
  correcteurHydroElectrolytique, // Bicarbonate de sodium
}

extension FluidTypeLabel on FluidType {
  String get label {
    switch (this) {
      case FluidType.cristalloide:                 return 'Cristalloïde';
      case FluidType.colloide:                     return 'Colloïde';
      case FluidType.solutionGlucosee:             return 'Solution Glucosée';
      case FluidType.solutionHypertonique:         return 'Solution Hypertonique';
      case FluidType.solutionTamponnee:            return 'Solution Tamponnée';
      case FluidType.produitOsmotique:             return 'Produit Osmotique';
      case FluidType.correcteurHydroElectrolytique:return 'Correcteur Hydro-Électrolytique';
    }
  }
}

/// Tonicité par rapport au plasma (≈285–295 mOsm/L). [M9 §51]
enum Tonicite { hypotonique, isotonique, hypertonique }

extension ToniciteLabel on Tonicite {
  String get label {
    switch (this) {
      case Tonicite.hypotonique:  return 'Hypotonique';
      case Tonicite.isotonique:   return 'Isotonique';
      case Tonicite.hypertonique: return 'Hypertonique';
    }
  }
}

/// Statut d'utilisation clinique dans un contexte donné (choc, pathologie,
/// terrain...). Réutilisé pour la matrice "utilisation clinique" de chaque
/// soluté. [SFAR 2019][ESICM 2014][KDIGO 2023]
enum FluidUsageStatus { recommande, prudence, contreIndique, nonDocumente }

extension FluidUsageStatusLabel on FluidUsageStatus {
  String get emoji {
    switch (this) {
      case FluidUsageStatus.recommande:     return '✅';
      case FluidUsageStatus.prudence:       return '⚠️';
      case FluidUsageStatus.contreIndique:  return '❌';
      case FluidUsageStatus.nonDocumente:   return '❓';
    }
  }
  String get label {
    switch (this) {
      case FluidUsageStatus.recommande:     return 'Recommandé';
      case FluidUsageStatus.prudence:       return 'Prudence';
      case FluidUsageStatus.contreIndique:  return 'Contre-indiqué';
      case FluidUsageStatus.nonDocumente:   return 'Non documenté';
    }
  }
}

/// Une entrée de la matrice d'utilisation clinique (situation → statut).
class FluidClinicalUse {
  final String situation;             // ex : 'choc_septique', 'brules'
  final FluidUsageStatus status;
  final String explication;           // justification clinique affichée
  final String? source;

  const FluidClinicalUse({
    required this.situation,
    required this.status,
    required this.explication,
    this.source,
  });
}

/// Composition ionique/molaire d'un soluté, en mmol/L (sauf glucose et
/// calories, précisés séparément). Un champ à `null` = électrolyte absent
/// (0 par défaut pour les calculs) SAUF mention contraire dans les
/// commentaires de fluids_data.dart. [ANSM RCP]
class FluidComposition {
  final double? sodiumMmolL;
  final double? potassiumMmolL;
  final double? calciumMmolL;
  final double? magnesiumMmolL;
  final double? chlorureMmolL;
  final double? lactateMmolL;
  final double? acetateMmolL;
  final double? gluconateMmolL;
  final double? glucoseGL;          // g/L
  final double? bicarbonateMmolL;

  const FluidComposition({
    this.sodiumMmolL,
    this.potassiumMmolL,
    this.calciumMmolL,
    this.magnesiumMmolL,
    this.chlorureMmolL,
    this.lactateMmolL,
    this.acetateMmolL,
    this.gluconateMmolL,
    this.glucoseGL,
    this.bicarbonateMmolL,
  });
}

/// Profil clinique complet d'un soluté de remplissage — complète [Drug] pour
/// la catégorie [DrugCategory.fluid], sur le même principe que
/// [AntibioticProfile] pour les antibiotiques. Laisse [Drug] inchangé pour
/// les autres classes de médicaments.
///
/// Sources : [SFAR 2019][ESICM 2014][KDIGO 2023][ANSM RCP][Marino's ICU Book].
class FluidProfile {
  // ── Classification ────────────────────────────────────────
  final FluidType type;
  final FluidComposition composition;
  final double? osmolariteMOsmL;      // mOsm/L théorique (calculée ou RCP)
  final Tonicite tonicite;
  final String? phRange;              // ex : '4.5–7.0' — texte, variable/RCP
  final double? caloriesKcalL;        // kcal/L — solutions glucosées

  // ── Informations cliniques ─────────────────────────────────
  final String mecanisme;
  final List<String> avantages;
  final List<String> inconvenients;
  final List<String> contreIndications;
  final List<String> precautions;
  final List<String> effetsIndesirables;
  final List<String> interactions;
  final List<String> compatibilites;
  final List<String> incompatibilites;

  // ── Utilisation clinique par situation ─────────────────────
  // Clé libre (ex: 'choc_septique', 'brules', 'pediatrie') — voir
  // fluids_data.dart pour la liste des clés utilisées et leur affichage.
  final List<FluidClinicalUse> usagesCliniques;

  // ── Présentation / logistique ──────────────────────────────
  final String? presentation;
  final List<String> volumesDisponiblesMl;
  final bool? compatibleProduitsSanguins;
  final String? compatibiliteProduitsSanguinsDetail;
  final String? stabilite;
  final String? conservation;
  final String voieAdministration;
  final String? tempsMaxPerfusion;
  final List<String> surveillanceClinique;
  final List<String> surveillanceBiologique;

  const FluidProfile({
    required this.type,
    required this.composition,
    this.osmolariteMOsmL,
    required this.tonicite,
    this.phRange,
    this.caloriesKcalL,
    required this.mecanisme,
    this.avantages = const [],
    this.inconvenients = const [],
    this.contreIndications = const [],
    this.precautions = const [],
    this.effetsIndesirables = const [],
    this.interactions = const [],
    this.compatibilites = const [],
    this.incompatibilites = const [],
    this.usagesCliniques = const [],
    this.presentation,
    this.volumesDisponiblesMl = const [],
    this.compatibleProduitsSanguins,
    this.compatibiliteProduitsSanguinsDetail,
    this.stabilite,
    this.conservation,
    required this.voieAdministration,
    this.tempsMaxPerfusion,
    this.surveillanceClinique = const [],
    this.surveillanceBiologique = const [],
  });

  FluidUsageStatus statusFor(String situation) {
    for (final u in usagesCliniques) {
      if (u.situation == situation) return u.status;
    }
    return FluidUsageStatus.nonDocumente;
  }

  FluidClinicalUse? useFor(String situation) {
    for (final u in usagesCliniques) {
      if (u.situation == situation) return u;
    }
    return null;
  }
}

// ============================================================================
//  CURARES (BLOQUEURS NEUROMUSCULAIRES) — PROFIL DÉTAILLÉ
// ============================================================================
//
// Complète [Drug] pour la catégorie DrugCategory.nmb (dépolarisants,
// non-dépolarisants, et antagonistes/décurarisants). Même principe que
// [OpioidProfile] / [AntibioticProfile] / [FluidProfile] : champ optionnel,
// ne modifie rien pour les médicaments hors curares.
//
// Sources : [M9 §19-21] Miller's Anesthesia 9e ed. ; [STO §11-12] Stoelting's
// Pharmacology & Physiology 5e ed. ; [GG §11] Goodman & Gilman 13e ed. ;
// [ANSM RCP] ; [SFAR — Curarisation en anesthésie 2018 (RFE)] ; [Naguib et
// al., Anesth Analg 2018 — neuromuscular monitoring] ; [MHRA/AAGBI —
// Malignant Hyperthermia guidance].

/// Classe pharmacologique du bloqueur neuromusculaire. [GG §11]
enum CurareClass {
  depolarisant,                    // succinylcholine — seul représentant clinique
  nonDepolarisantAminosteroide,    // rocuronium, vécuronium, pancuronium
  nonDepolarisantBenzylisoquinoline, // atracurium, cisatracurium, mivacurium
  antagonisteAnticholinesterasique, // néostigmine (+ atropine/glycopyrrolate)
  antagonisteSpecifique,           // sugammadex (encapsulation sélective aminostéroïdes)
}

extension CurareClassLabel on CurareClass {
  String get label {
    switch (this) {
      case CurareClass.depolarisant:
        return 'Dépolarisant';
      case CurareClass.nonDepolarisantAminosteroide:
        return 'Non-dépolarisant (aminostéroïde)';
      case CurareClass.nonDepolarisantBenzylisoquinoline:
        return 'Non-dépolarisant (benzylisoquinoline)';
      case CurareClass.antagonisteAnticholinesterasique:
        return 'Antagoniste anticholinestérasique';
      case CurareClass.antagonisteSpecifique:
        return 'Antagoniste spécifique (encapsulation)';
    }
  }
}

/// Profil clinique complet d'un curare ou d'un agent de décurarisation —
/// complète [Drug] pour la catégorie [DrugCategory.nmb]. [M9 §19-21]
class CurareProfile {
  // ── Classification ──────────────────────────────────────────
  final CurareClass classe;

  // ── Puissance / cinétique ────────────────────────────────────
  final String? doseED95;           // Dose efficace 95% (ex : '0.3 mg/kg')
  final String delaiInstallation;   // Onset (ex : '60–90 sec')
  final String dureeCliniqueAction; // Durée d'action clinique (25% récupération)
  final String? indexRecuperation;  // T25–75% (ex : '10–15 min')
  final String eliminationDetail;

  // ── Risques cliniques qualitatifs (réutilise RiskLevel des opioïdes) ──
  final RiskLevel histaminoLiberation;
  final RiskLevel effetCardiovasculaire; // Tachycardie/bradycardie/instabilité
  final RiskLevel risqueHyperkaliemie;   // Surtout succinylcholine
  final RiskLevel risqueBronchospasme;

  // ── Sécurité spécifique ────────────────────────────────────────
  final bool declencheHyperthermieMaligne; // true pour succinylcholine
  final bool utiliseEnISR;                 // Induction en séquence rapide
  final String? antidoteSpecifique;        // Ex : 'Sugammadex' (rocuronium/vécuronium)
  final String  conduiteCurarisationResiduelle; // Prise en charge bloc résiduel

  // ── Monitorage ──────────────────────────────────────────────
  final String monitorageRecommande; // Ex : 'TOF obligatoire (train-of-four)'

  const CurareProfile({
    required this.classe,
    this.doseED95,
    required this.delaiInstallation,
    required this.dureeCliniqueAction,
    this.indexRecuperation,
    required this.eliminationDetail,
    this.histaminoLiberation = RiskLevel.nonDocumente,
    this.effetCardiovasculaire = RiskLevel.nonDocumente,
    this.risqueHyperkaliemie = RiskLevel.nul,
    this.risqueBronchospasme = RiskLevel.nonDocumente,
    this.declencheHyperthermieMaligne = false,
    this.utiliseEnISR = false,
    this.antidoteSpecifique,
    required this.conduiteCurarisationResiduelle,
    required this.monitorageRecommande,
  });

  bool get estDepolarisant => classe == CurareClass.depolarisant;
  bool get estAntagoniste =>
      classe == CurareClass.antagonisteAnticholinesterasique ||
      classe == CurareClass.antagonisteSpecifique;
}

// ============================================================================
//  EXTENSIONS
// ============================================================================

extension DrugCategoryExtension on DrugCategory {

  String get label {
    switch (this) {
      case DrugCategory.sedation:   return 'Sédation / Induction';
      case DrugCategory.analgesia:  return 'Analgésie';
      case DrugCategory.nmb:        return 'Curares';
      case DrugCategory.vasoactive: return 'Vasopresseurs / Inotropes';
      case DrugCategory.antibiotic: return 'Antibiotiques';
      case DrugCategory.fluid:      return 'Solutions de Remplissage';
      case DrugCategory.other:      return 'Autres';
    }
  }

  // Phase clinique dérivée de la catégorie [M9 §1]
  Phase get phase {
    switch (this) {
      case DrugCategory.sedation:
      case DrugCategory.analgesia:
      case DrugCategory.nmb:
      case DrugCategory.vasoactive:
        return Phase.phase1;
      case DrugCategory.antibiotic:
      case DrugCategory.fluid:
      case DrugCategory.other:
        return Phase.phase2;
    }
  }

  IconData get icon {
    switch (this) {
      case DrugCategory.sedation:   return Icons.bedtime_outlined;
      case DrugCategory.analgesia:  return Icons.healing_outlined;
      case DrugCategory.nmb:        return Icons.flash_off_outlined;
      case DrugCategory.vasoactive: return Icons.favorite_border;
      case DrugCategory.antibiotic: return Icons.biotech_outlined;
      case DrugCategory.fluid:      return Icons.water_drop_outlined;
      case DrugCategory.other:      return Icons.medication_outlined;
    }
  }

  /// Couleur sémantique de la catégorie — cohérente avec l'UI médicale.
  Color get color {
    switch (this) {
      case DrugCategory.sedation:   return const Color(0xFF6C63FF); // Violet
      case DrugCategory.analgesia:  return const Color(0xFFEF4444); // Rouge
      case DrugCategory.nmb:        return const Color(0xFF8B5CF6); // Pourpre
      case DrugCategory.vasoactive: return const Color(0xFFEC4899); // Rose
      case DrugCategory.antibiotic: return const Color(0xFF10B981); // Vert
      case DrugCategory.fluid:      return const Color(0xFF3B82F6); // Bleu
      case DrugCategory.other:      return const Color(0xFF6B7280); // Gris
    }
  }
}

extension MetabolismeLabel on Metabolisme {
  String get label {
    switch (this) {
      case Metabolisme.hepatique:   return 'Hépatique (CYP3A4)';
      case Metabolisme.renal:       return 'Rénal';
      case Metabolisme.plasmatique: return 'Plasmatique (estérases)';
      case Metabolisme.biliaire:    return 'Biliaire';
      case Metabolisme.mixte:       return 'Mixte (hépato-rénal)';
      case Metabolisme.inconnu:     return 'Inconnu';
    }
  }

  /// Vrai si une insuffisance hépatique impose un ajustement. [EASL 2023]
  bool get sensibleInsuffisanceHepatique =>
      this == Metabolisme.hepatique ||
      this == Metabolisme.biliaire  ||
      this == Metabolisme.mixte;

  /// Vrai si une insuffisance rénale impose un ajustement. [KDIGO 2023]
  bool get sensibleInsuffisanceRenale =>
      this == Metabolisme.renal ||
      this == Metabolisme.mixte;

  /// Source principale de la voie métabolique.
  String get source {
    switch (this) {
      case Metabolisme.hepatique:   return '[GG §2] — CYP3A4 / CYP450';
      case Metabolisme.renal:       return '[GG §3] — Filtration glomérulaire / tubulaire';
      case Metabolisme.plasmatique: return '[GG §4] — Pseudo-cholinestérases / estérases';
      case Metabolisme.biliaire:    return '[M9 §28] — Excrétion biliaire / cycle entéro-hépatique';
      case Metabolisme.mixte:       return '[GG §2-3] — Voies multiples';
      case Metabolisme.inconnu:     return 'Non documenté';
    }
  }
}

// ============================================================================
//  DOSERANGE
// ============================================================================

// ── Rationnel des unités et calculs ──────────────────────────
//
// Les doses en anesthésie sont quasi-universellement pondérales [M9 §26].
// Exception : certains antibiotiques (dose fixe ou selon DFG [KDIGO 2023]).
//
// Plafond absolu (maxAbsoluteDose) [ANSM ; UPDT 2024] :
//   Ex : morphine bolus → max 15 mg indépendant du poids
//   Ex : adrénaline → max 0.5 mg/dose en anaphylaxie
//
// Conversion ml/h pour SAP [M9 §26 ; SFAR] :
//   débit_ml_h = (dose_mg_kg_h × poids) / concentration_mg_ml
//   Concentration de référence à préparer selon protocole service.

/// Plage de dose (min–max) avec calcul pondéral et conversion SAP.
///
/// Sources : [M9 §26 ; STO §1 ; ANSM RCP de chaque médicament].
class DoseRange {
  final double   min;
  final double   max;
  final DoseUnit unit;
  final String   label;

  /// Plafond de dose absolu (indépendant du poids). [ANSM ; UPDT 2024]
  final double? maxAbsoluteDose;

  const DoseRange({
    required this.min,
    required this.max,
    required this.unit,
    required this.label,
    this.maxAbsoluteDose,
  }) : assert(min >= 0, 'min ≥ 0'),
       assert(max >= min, 'max ≥ min');

  // ── Calculs pondéraux ──────────────────────────────────────

  double calcMin(double weightKg) => min * weightKg;

  /// Calcul du max avec plafond absolu si défini. [ANSM ; UPDT 2024]
  double calcMax(double weightKg) {
    final raw = max * weightKg;
    return maxAbsoluteDose != null ? raw.clamp(0.0, maxAbsoluteDose!) : raw;
  }

  /// Retourne (min, max) calculés pour un poids donné.
  ({double min, double max}) calcForWeight(double weightKg) => (
    min: calcMin(weightKg),
    max: calcMax(weightKg),
  );

  // ── Unité résultante après calcul pondéral ────────────────
  // Ex : mg/kg × kg = mg ; mcg/kg/min × kg = mcg/min

  String get unitString {
    switch (unit) {
      case DoseUnit.mgPerKg:     return 'mg';       // bolus
      case DoseUnit.mcgPerKg:    return 'mcg';      // bolus opioïde
      case DoseUnit.mgPerKgH:    return 'mg/h';     // perfusion
      case DoseUnit.mcgPerKgH:   return 'mcg/h';    // perfusion
      case DoseUnit.mcgPerKgMin: return 'mcg/min';  // vasopresseur
      case DoseUnit.mlPerKgH:    return 'ml/h';     // soluté
      case DoseUnit.mlPerKg:     return 'ml';       // bolus soluté
      case DoseUnit.unitsFixed:  return 'unités';   // UI, UI/h
    }
  }

  // ── Conversion SAP (seringue auto-pousseuse) ──────────────
  //
  // Formule [M9 §26 ; SFAR Protocoles SAP] :
  //   débit (ml/h) = dose (mg/kg/h) × poids (kg) / concentration (mg/ml)
  //
  // Applicable uniquement aux unités mgPerKgH.
  // La concentration (mg/ml) est définie dans le protocole de service
  // ou dans [Drug.standardConcentrationMgPerMl].

  double? mlPerHourMin(double weightKg, double concentrationMgPerMl) {
    if (unit == DoseUnit.mgPerKgH && concentrationMgPerMl > 0) {
      return (min * weightKg) / concentrationMgPerMl;
    }
    return null;
  }

  double? mlPerHourMax(double weightKg, double concentrationMgPerMl) {
    if (unit == DoseUnit.mgPerKgH && concentrationMgPerMl > 0) {
      return calcMax(weightKg) / concentrationMgPerMl;
    }
    return null;
  }

  // ── copyWith ──────────────────────────────────────────────

  DoseRange copyWith({
    double?   min,
    double?   max,
    DoseUnit? unit,
    String?   label,
    Object?   maxAbsoluteDose = _sentinel,
  }) {
    return DoseRange(
      min:             min             ?? this.min,
      max:             max             ?? this.max,
      unit:            unit            ?? this.unit,
      label:           label           ?? this.label,
      maxAbsoluteDose: maxAbsoluteDose == _sentinel
          ? this.maxAbsoluteDose : maxAbsoluteDose as double?,
    );
  }

  Map<String, dynamic> toMap() => {
    'min':             min,
    'max':             max,
    'unit':            unit.index,
    'label':           label,
    'maxAbsoluteDose': maxAbsoluteDose,
  };

  factory DoseRange.fromMap(Map<String, dynamic> map) => DoseRange(
    min:             (map['min']  as num).toDouble(),
    max:             (map['max']  as num).toDouble(),
    unit:            DoseUnit.values[map['unit'] as int],
    label:           map['label'] as String,
    maxAbsoluteDose: (map['maxAbsoluteDose'] as num?)?.toDouble(),
  );

  // Alias rétrocompatible
  String resultUnit() => unitString;
}

// ============================================================================
//  DRUG  v3.0
// ============================================================================

/// Modèle complet d'un médicament d'anesthésie / réanimation.
///
/// Sources pharmacologiques : [M9][STO][GG][ANSM][UPDT][VID]
///
/// Chaque champ est documenté avec sa source et son impact clinique.
/// Immutable par convention. Utiliser [copyWith] pour les instances modifiées.
class Drug {
  // ── Identité ──────────────────────────────────────────────
  final String       id;          // Identifiant unique technique
  final String       name;        // Nom commercial (ex : 'Diprivan®')
  final String       genericName; // DCI — Dénomination Commune Internationale [ANSM]
  final DrugCategory category;    // Catégorie pharmacologique [M9]
  final String       subCategory; // Sous-groupe (ex : 'Opioïde fort', 'Benzodiazepin')

  // ── Dosage ────────────────────────────────────────────────
  // Toutes les doses sont sourcées dans les RCP [ANSM] et [UPDT 2024].
  final DoseRange bolus;       // Dose bolus IV (induction / titration)
  final DoseRange infusion;    // Perfusion continue (entretien)
  final String    bolusMethod; // Description textuelle du mode bolus
  final String    infusionRate;// Description textuelle du mode perfusion

  // ── Doses Pédiatriques ────────────────────────────────────
  final DoseRange? pediatricBolus;           // Dose bolus enfant
  final DoseRange? pediatricInfusion;        // Perfusion enfant
  final String?    pediatricNotes;           // Précautions spéciales enfant
  final double?    pediatricMaxAbsoluteDose; // Plafond absolu enfant

  // ── Préparation / Compatibilités ──────────────────────────
  // Sources : [ANSM RCP] ; [VID 2024] ; protocoles pharmacie hospitalière
  final String  preparation;
  final double? standardConcentrationMgPerMl; // Concentration SAP standard [SFAR]

  // Compatibilité solvants [ANSM RCP] :
  // compatibiliteSG5    : Glucose 5% — OUI par défaut, sauf exception (ex : aminosides)
  // compatibiliteNaCl09 : NaCl 0.9% — OUI par défaut
  // Attention : propofol compatible NaCl et SG5, mais pas SG10 [ANSM RCP Diprivan]
  final bool compatibiliteSG5;
  final bool compatibiliteNaCl09;

  // photoSensible : ex nimodipine, amiodarone, furosémide → protéger de la lumière [ANSM]
  final bool photoSensible;

  // conservationH : durée de stabilité après dilution (heures) [ANSM ; VID 2024]
  // Ex : propofol 12h ; midazolam 24h ; noradrénaline 24h [VID 2024]
  final int? conservationH;

  // ── Pharmacologie ─────────────────────────────────────────
  // Sources : [M9][STO][GG] pour mécanisme, délais, durées
  final String      mechanism;    // Mécanisme d'action résumé [GG §1]
  final String      onset;        // Délai d'action (IV direct) [M9 §26]
  final String      duration;     // Durée d'action [M9 §26]
  final Metabolisme metabolisme;  // Voie métabolique [GG §2-4]

  // antagoniste : agent de reversal disponible [M9 ; ANSM]
  //   midazolam  → 'Flumazénil' [ANSM RCP]
  //   morphine   → 'Naloxone'   [ANSM RCP]
  //   rocuronium → 'Sugammadex' [ANSM RCP]
  //   succinylch.→ aucun antidote spécifique [M9 §28]
  final String? antagoniste;

  // titration : protocole de titration clinique [SFAR ; UPDT 2024]
  final String? titration;

  // ── Sécurité ──────────────────────────────────────────────
  // Sources : [ANSM RCP] (source primaire réglementaire) ; [UPDT 2024]
  final String       shortWarning;      // Alerte courte — affichée en UI
  final List<String> warnings;          // Mises en garde générales [ANSM]
  final List<String> contreIndications; // CI absolues [ANSM RCP]
  final List<String> precautions;       // Précautions d'emploi [ANSM RCP]
  final List<String> interactions;      // Interactions majeures [ANSM ; GG §5]
  final List<String> surveillance;      // Paramètres à monitorer [M9 ; SFAR]
  final List<String> indications;       // Indications AMM [ANSM RCP]

  // ── Logistique ────────────────────────────────────────────
  // requiresCentralLine : voie centrale obligatoire [M9 §51 ; ANSM]
  // Ex : noradrénaline, dopamine > 3 mcg/kg/min → voie centrale [SFAR 2019]
  final bool requiresCentralLine;

  // ── Profil antibiotique (optionnel) ────────────────────────
  // Renseigné uniquement pour category == DrugCategory.antibiotic.
  // Spectre bactérien, grossesse/allaitement, ajustements d'organe,
  // posologie/jour. Voir [AntibioticProfile]. [SPILF][EUCAST][CRAT]
  final AntibioticProfile? antibioticProfile;

  // ── Profil soluté (optionnel) ──────────────────────────────
  // Renseigné uniquement pour category == DrugCategory.fluid.
  // Composition ionique, osmolarité, tonicité, usages cliniques par
  // situation, logistique. Voir [FluidProfile]. [SFAR 2019][ESICM 2014]
  final FluidProfile? fluidProfile;

  // ── Profil opioïde (optionnel) ─────────────────────────────
  // Renseigné uniquement pour les opioïdes et antagonistes opioïdes
  // (sous-ensemble de category == DrugCategory.analgesia).
  // Récepteurs μ/κ/δ, équivalence morphinique, risques qualitatifs,
  // antidote, PCA. Voir [OpioidProfile]. [M9 §29-30][SFAR 2016][EAPC 2012]
  final OpioidProfile? opioidProfile;

  // ── Profil curare (optionnel) ────────────────────────────────
  // Renseigné uniquement pour les bloqueurs neuromusculaires et agents de
  // décurarisation (category == DrugCategory.nmb).
  // Cinétique (ED95, onset, durée), risques qualitatifs, hyperthermie
  // maligne, antidote spécifique. Voir [CurareProfile]. [M9 §19-21][SFAR 2018]
  final CurareProfile? curareProfile;

  // ── Classe thérapeutique dynamique (data-driven) ───────────
  // Champ LIBRE (String), distinct de [category].
  // [category] reste un enum technique fixe : il ne sert qu'à activer les
  // profils spécialisés (antibioticProfile, fluidProfile, opioidProfile,
  // curareProfile) et le calcul de [phase]. Il ne doit JAMAIS être étendu
  // pour créer de nouvelles catégories d'affichage.
  //
  // [therapeuticClass] est LA source de vérité utilisée par l'écran Doses
  // pour générer les onglets automatiquement. Pour créer une nouvelle
  // catégorie visible dans l'app (ex : "Corticostéroïdes", "Insulines"),
  // il suffit de renseigner cette valeur dans le fichier de données du
  // médicament — aucune modification de l'UI n'est nécessaire.
  //
  // Si non renseigné, [displayClass] retombe sur category.label pour les
  // médicaments legacy (rétrocompatibilité totale, aucune régression).
  final String? therapeuticClass;

  /// Classe thérapeutique effective utilisée pour le regroupement/filtrage
  /// dans l'écran Doses. Source unique de vérité pour l'UI dynamique.
  String get displayClass =>
      (therapeuticClass != null && therapeuticClass!.trim().isNotEmpty)
          ? therapeuticClass!.trim()
          : category.label;

  const Drug({
    required this.id,
    required this.name,
    required this.genericName,
    required this.category,
    required this.subCategory,
    this.therapeuticClass,
    required this.bolus,
    required this.infusion,
    required this.bolusMethod,
    required this.infusionRate,
    this.pediatricBolus,
    this.pediatricInfusion,
    this.pediatricNotes,
    this.pediatricMaxAbsoluteDose,
    required this.preparation,
    this.standardConcentrationMgPerMl,
    this.compatibiliteSG5    = true,
    this.compatibiliteNaCl09 = true,
    this.photoSensible       = false,
    this.conservationH,
    required this.mechanism,
    required this.onset,
    required this.duration,
    this.metabolisme         = Metabolisme.hepatique,
    this.antagoniste,
    this.titration,
    required this.shortWarning,
    this.warnings            = const [],
    this.contreIndications   = const [],
    this.precautions         = const [],
    this.interactions        = const [],
    this.surveillance        = const [],
    required this.indications,
    this.requiresCentralLine = false,
    this.antibioticProfile,
    this.fluidProfile,
    this.opioidProfile,
    this.curareProfile,
  });

  // ── Helpers cliniques ─────────────────────────────────────

  bool get aUnAntagoniste    => antagoniste != null && antagoniste!.isNotEmpty;
  bool get aUneSurveillance  => surveillance.isNotEmpty;
  bool get aDesInteractions  => interactions.isNotEmpty;
  bool get aDesCI            => contreIndications.isNotEmpty;
  bool get aUneTitration     => titration != null && titration!.isNotEmpty;

  /// Médicament à haut risque (LASA ou fort potentiel de surdosage). [M9 §26]
  /// Critère : shortWarning défini OU nombreuses mises en garde.
  bool get isHighAlert => shortWarning.isNotEmpty || warnings.length > 2;

  Phase get phase => category.phase;

  /// Nécessite ajustement si insuffisance hépatique. [EASL 2023]
  bool get sensibleInsuffisanceHepatique =>
      metabolisme.sensibleInsuffisanceHepatique;

  /// Nécessite ajustement si insuffisance rénale. [KDIGO 2023]
  bool get sensibleInsuffisanceRenale =>
      metabolisme.sensibleInsuffisanceRenale;

  /// Vrai si ce médicament dispose d'un profil antibiotique renseigné.
  bool get estAntibiotiqueDocumente =>
      category == DrugCategory.antibiotic && antibioticProfile != null;

  /// Raccourci : utilisé en prophylaxie chirurgicale. [SFAR 2017-2018]
  bool get estProphylaxieChirurgicale =>
      antibioticProfile?.utiliseEnProphylaxieChirurgicale ?? false;

  /// Vrai si ce soluté dispose d'un profil détaillé renseigné.
  bool get estSoluteDocumente =>
      category == DrugCategory.fluid && fluidProfile != null;

  /// Vrai si ce médicament dispose d'un profil opioïde détaillé renseigné.
  bool get estOpioideDocumente =>
      category == DrugCategory.analgesia && opioidProfile != null;

  /// Vrai si ce médicament est un antagoniste opioïde (ex : naloxone).
  bool get estAntagonisteOpioide =>
      opioidProfile?.estAntagoniste ?? false;

  /// Vrai si ce curare dispose d'un profil détaillé renseigné.
  bool get estCurareDocumente =>
      category == DrugCategory.nmb && curareProfile != null;

  /// Vrai si cet agent est un antagoniste/décurarisant (ex : sugammadex,
  /// néostigmine).
  bool get estAntagonisteCurare =>
      curareProfile?.estAntagoniste ?? false;

  // ── copyWith complet ──────────────────────────────────────

  Drug copyWith({
    String?       id,
    String?       name,
    String?       genericName,
    DrugCategory? category,
    String?       subCategory,
    Object?       therapeuticClass = _sentinel,
    DoseRange?    bolus,
    DoseRange?    infusion,
    String?       bolusMethod,
    String?       infusionRate,
    Object?       pediatricBolus = _sentinel,
    Object?       pediatricInfusion = _sentinel,
    Object?       pediatricNotes = _sentinel,
    Object?       pediatricMaxAbsoluteDose = _sentinel,
    String?       preparation,
    Object?       standardConcentrationMgPerMl = _sentinel,
    bool?         compatibiliteSG5,
    bool?         compatibiliteNaCl09,
    bool?         photoSensible,
    Object?       conservationH  = _sentinel,
    String?       mechanism,
    String?       onset,
    String?       duration,
    Metabolisme?  metabolisme,
    Object?       antagoniste    = _sentinel,
    Object?       titration      = _sentinel,
    String?       shortWarning,
    List<String>? warnings,
    List<String>? contreIndications,
    List<String>? precautions,
    List<String>? interactions,
    List<String>? surveillance,
    List<String>? indications,
    bool?         requiresCentralLine,
    Object?       antibioticProfile = _sentinel,
    Object?       fluidProfile = _sentinel,
    Object?       opioidProfile = _sentinel,
    Object?       curareProfile = _sentinel,
  }) {
    return Drug(
      id:              id              ?? this.id,
      name:            name            ?? this.name,
      genericName:     genericName     ?? this.genericName,
      category:        category        ?? this.category,
      subCategory:     subCategory     ?? this.subCategory,
      therapeuticClass: therapeuticClass == _sentinel
          ? this.therapeuticClass : therapeuticClass as String?,
      bolus:           bolus           ?? this.bolus,
      infusion:        infusion        ?? this.infusion,
      bolusMethod:     bolusMethod     ?? this.bolusMethod,
      infusionRate:    infusionRate    ?? this.infusionRate,
      pediatricBolus:  pediatricBolus == _sentinel ? this.pediatricBolus : pediatricBolus as DoseRange?,
      pediatricInfusion: pediatricInfusion == _sentinel ? this.pediatricInfusion : pediatricInfusion as DoseRange?,
      pediatricNotes:  pediatricNotes == _sentinel ? this.pediatricNotes : pediatricNotes as String?,
      pediatricMaxAbsoluteDose: pediatricMaxAbsoluteDose == _sentinel ? this.pediatricMaxAbsoluteDose : pediatricMaxAbsoluteDose as double?,
      preparation:     preparation     ?? this.preparation,
      standardConcentrationMgPerMl: standardConcentrationMgPerMl == _sentinel
          ? this.standardConcentrationMgPerMl : standardConcentrationMgPerMl as double?,
      compatibiliteSG5:    compatibiliteSG5    ?? this.compatibiliteSG5,
      compatibiliteNaCl09: compatibiliteNaCl09 ?? this.compatibiliteNaCl09,
      photoSensible:       photoSensible       ?? this.photoSensible,
      conservationH: conservationH == _sentinel
          ? this.conservationH : conservationH as int?,
      mechanism:     mechanism     ?? this.mechanism,
      onset:         onset         ?? this.onset,
      duration:      duration      ?? this.duration,
      metabolisme:   metabolisme   ?? this.metabolisme,
      antagoniste: antagoniste == _sentinel
          ? this.antagoniste : antagoniste as String?,
      titration: titration == _sentinel
          ? this.titration : titration as String?,
      shortWarning:        shortWarning        ?? this.shortWarning,
      warnings:            warnings            ?? this.warnings,
      contreIndications:   contreIndications   ?? this.contreIndications,
      precautions:         precautions         ?? this.precautions,
      interactions:        interactions        ?? this.interactions,
      surveillance:        surveillance        ?? this.surveillance,
      indications:         indications         ?? this.indications,
      requiresCentralLine: requiresCentralLine ?? this.requiresCentralLine,
      antibioticProfile: antibioticProfile == _sentinel
          ? this.antibioticProfile : antibioticProfile as AntibioticProfile?,
      fluidProfile: fluidProfile == _sentinel
          ? this.fluidProfile : fluidProfile as FluidProfile?,
      opioidProfile: opioidProfile == _sentinel
          ? this.opioidProfile : opioidProfile as OpioidProfile?,
      curareProfile: curareProfile == _sentinel
          ? this.curareProfile : curareProfile as CurareProfile?,
    );
  }

  // ── Equatable ─────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Drug && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Drug($id: $name [$category / ${metabolisme.label}])';
}

// ── Sentinelle pour copyWith nullable ────────────────────────
const _Sentinel _sentinel = _Sentinel();
class _Sentinel { const _Sentinel(); }