// ============================================================================
//  lib/models/pathologie.dart
//  VERSION 3.0 — Sources médicales inline sur chaque classification
//
//  AUDIT MÉDICAL v3.0 :
//  Chaque catégorie, sévérité et ajustement est sourcé vers les guidelines
//  internationaux en vigueur (2022–2024).
//
//  Sources référencées :
//  [M9]   Miller's Anesthesia, 9th ed. — Gropper MA et al., Elsevier 2020.
//  [SFAR] SFAR — Recommandations formalisées d'experts (RFE), diverses années.
//  [ESC]  ESC/ESA Guidelines on non-cardiac surgery. Eur Heart J. 2022.
//  [KDIGO] KDIGO Clinical Practice Guidelines for AKI & CKD. KDIGO 2023.
//  [EASL] EASL Clinical Practice Guidelines — liver disease. J Hepatol. 2023.
//  [ANSM] ANSM — Résumés des Caractéristiques du Produit (RCP) officiels.
//  [UPDT] UpToDate — Drug prescribing in renal/hepatic failure. 2024.
//  [WHO]  WHO — Classification des maladies. CIM-11. 2022.
//  [ESA]  ESA — Guidelines Obstetric Anaesthesia. Eur J Anaesthesiol. 2023.
//  [GINA] GINA — Global Strategy for Asthma Management and Prevention. 2023.
// ============================================================================

import 'package:flutter/foundation.dart';

// ============================================================================
//  ENUMS
// ============================================================================

// ── Catégorie pathologique ────────────────────────────────────
//
// Classification alignée sur la CIM-11 (OMS 2022) [WHO] et les domaines
// d'impact pharmacologique en anesthésie-réanimation [M9 §14–§30].
//
// Impact sur l'anesthésie :
//   neurologique    → MAC réduit, morphiniques prudence [M9 §14]
//   hepatique       → métabolisme CYP450 altéré → accumulation [EASL 2023]
//   renal           → élimination rénale diminuée → accumulation [KDIGO 2023]
//   cardiovasculaire → stabilité hémodynamique compromise [ESC 2022]
//   respiratoire    → oxygénation / ventilation complexifiée [GINA 2023]
//   metabolique     → insulinorésistance, dysélectrolytémies [M9 §26]
//   obstetrique     → pharmacologie foeto-placentaire [ESA 2023]
//   allergique      → risque anaphylaxie / réactions croisées [SFAR 2019]
//   infectieux      → sepsis, immunosuppression, interactions ATB [M9 §86]
//   autre           → catégorie résiduelle

enum CategoriePathologie {
  neurologique,    // [M9 §14] — hypertension intracrânienne, épilepsie...
  hepatique,       // [EASL 2023] — cirrhose, insuffisance hépato-cellulaire
  renal,           // [KDIGO 2023] — AKI, MRC stades 1–5, dialyse
  cardiovasculaire,// [ESC 2022] — coronaropathie, IC, valvulopathies, HTA
  respiratoire,    // [GINA 2023] — BPCO, asthme, HTAP, SDRA
  metabolique,     // [M9 §26]   — diabète, obésité, dysthyroïdies
  obstetrique,     // [ESA 2023] — grossesse (T1/T2/T3), prééclampsie
  allergique,      // [SFAR 2019]— allergie latex, atopie, anaphylaxie
  infectieux,      // [M9 §86]   — infectieux général résiduel (UTI, sepsis néonatal...)
  autre,           // Catégorie résiduelle [WHO CIM-11] — vide depuis la réorganisation v4.0

  // ── AJOUTS v4.0 — Réorganisation Infectieux/Autre (ordre = ajout en fin, ──
  // ── ne JAMAIS réordonner : categorie.index est utilisé pour la persistance) ──
  infectieuxRespiratoire,   // Pneumonie, tuberculose, COVID-19, grippe, coqueluche
  infectieuxDigestif,       // GEA, hépatites B/C, cholécystite, appendicite
  orlInfectieux,            // Otites, sinusite, angine, pharyngite, amygdalite
  dermatologieInfectieuse,  // Gale, impétigo, cellulite, zona, herpès, érysipèle
  neuroInfectieux,          // Méningite, encéphalite
  ist,                      // VIH, syphilis, gonorrhée, chlamydia
  infectieuxPediatrique,    // Rougeole, varicelle, oreillons, rubéole, scarlatine
  maladiesTropicales,       // Paludisme, brucellose, leishmaniose, rage, tétanos
  infectieuxObstetrical,    // Mastite, endométrite
  gastroEnterologie,        // RGO, ulcère, colique hépatique, pancréatite, SII...
  urologie,                 // Colique néphrétique, hématurie, rétention urinaire
  dermatologie,             // Eczéma, psoriasis, acné, dermatophytie
  ophtalmologie,            // Glaucome aigu, cataracte, décollement rétine...
  rhumatologieOrthopedie,   // Arthrose, PR, goutte, lombalgie, fracture...
  psychiatrie,              // Dépression, troubles anxieux/panique/bipolaire...
  hematologie,              // Anémie, drépanocytose, thalassémie, leucémie...
  toxicologie,              // Intoxications médicamenteuse/CO, envenimations
  traumatologieUrgences,    // Brûlure, vertige, malaise, douleur abdo aiguë...
  neonatologie,             // Prématurité
  gynecologie,              // Kyste ovarien, fibrome utérin
}

extension CategoriePathologieLabel on CategoriePathologie {
  String get label {
    switch (this) {
      case CategoriePathologie.neurologique:     return 'Neurologique';
      case CategoriePathologie.hepatique:        return 'Hépatique';
      case CategoriePathologie.renal:            return 'Rénal';
      case CategoriePathologie.cardiovasculaire: return 'Cardiovasculaire';
      case CategoriePathologie.respiratoire:     return 'Respiratoire';
      case CategoriePathologie.metabolique:      return 'Métabolique';
      case CategoriePathologie.obstetrique:      return 'Obstétrique';
      case CategoriePathologie.allergique:       return 'Allergique';
      case CategoriePathologie.infectieux:       return 'Infectieux';
      case CategoriePathologie.autre:            return 'Autre';
      case CategoriePathologie.infectieuxRespiratoire:  return 'Infectieux Respiratoire';
      case CategoriePathologie.infectieuxDigestif:      return 'Infectieux Digestif';
      case CategoriePathologie.orlInfectieux:           return 'ORL Infectieux';
      case CategoriePathologie.dermatologieInfectieuse: return 'Dermatologie Infectieuse';
      case CategoriePathologie.neuroInfectieux:         return 'Neuro-Infectieux';
      case CategoriePathologie.ist:                     return 'IST';
      case CategoriePathologie.infectieuxPediatrique:   return 'Infectieux Pédiatrique';
      case CategoriePathologie.maladiesTropicales:      return 'Maladies Tropicales';
      case CategoriePathologie.infectieuxObstetrical:   return 'Infectieux Obstétrical';
      case CategoriePathologie.gastroEnterologie:       return 'Gastro-entérologie';
      case CategoriePathologie.urologie:                return 'Urologie';
      case CategoriePathologie.dermatologie:            return 'Dermatologie';
      case CategoriePathologie.ophtalmologie:           return 'Ophtalmologie';
      case CategoriePathologie.rhumatologieOrthopedie:  return 'Rhumatologie / Orthopédie';
      case CategoriePathologie.psychiatrie:             return 'Psychiatrie';
      case CategoriePathologie.hematologie:             return 'Hématologie';
      case CategoriePathologie.toxicologie:             return 'Toxicologie';
      case CategoriePathologie.traumatologieUrgences:   return 'Traumatologie / Urgences';
      case CategoriePathologie.neonatologie:            return 'Néonatologie';
      case CategoriePathologie.gynecologie:             return 'Gynécologie';
    }
  }

  String get emoji {
    switch (this) {
      case CategoriePathologie.neurologique:     return '🧠';
      case CategoriePathologie.hepatique:        return '🫀';
      case CategoriePathologie.renal:            return '🫘';
      case CategoriePathologie.cardiovasculaire: return '❤️';
      case CategoriePathologie.respiratoire:     return '🫁';
      case CategoriePathologie.metabolique:      return '⚗️';
      case CategoriePathologie.obstetrique:      return '🤱';
      case CategoriePathologie.allergique:       return '⚠️';
      case CategoriePathologie.infectieux:       return '🦠';
      case CategoriePathologie.autre:            return '🏥';
      case CategoriePathologie.infectieuxRespiratoire:  return '🫁';
      case CategoriePathologie.infectieuxDigestif:      return '🍽️';
      case CategoriePathologie.orlInfectieux:           return '👂';
      case CategoriePathologie.dermatologieInfectieuse: return '🧴';
      case CategoriePathologie.neuroInfectieux:         return '🧠';
      case CategoriePathologie.ist:                     return '🧬';
      case CategoriePathologie.infectieuxPediatrique:   return '👶';
      case CategoriePathologie.maladiesTropicales:      return '🌍';
      case CategoriePathologie.infectieuxObstetrical:   return '🤰';
      case CategoriePathologie.gastroEnterologie:       return '🍽️';
      case CategoriePathologie.urologie:                return '🚰';
      case CategoriePathologie.dermatologie:            return '🧴';
      case CategoriePathologie.ophtalmologie:           return '👁️';
      case CategoriePathologie.rhumatologieOrthopedie:  return '🦴';
      case CategoriePathologie.psychiatrie:             return '🧠';
      case CategoriePathologie.hematologie:             return '🩸';
      case CategoriePathologie.toxicologie:             return '☣️';
      case CategoriePathologie.traumatologieUrgences:   return '🚑';
      case CategoriePathologie.neonatologie:            return '👶';
      case CategoriePathologie.gynecologie:             return '🤰';
    }
  }

  /// Impact principal sur la pharmacocinétique/pharmacodynamie.
  /// Utilisé pour orienter les services (DrugFilterService, etc.) [M9 §26].
  String get impactPK {
    switch (this) {
      case CategoriePathologie.hepatique:
        return 'Métabolisme CYP450 réduit — risque accumulation [EASL 2023]';
      case CategoriePathologie.renal:
        return 'Élimination rénale diminuée — ajuster doses [KDIGO 2023]';
      case CategoriePathologie.cardiovasculaire:
        return 'Débit cardiaque variable — distribution modifiée [ESC 2022]';
      case CategoriePathologie.obstetrique:
        return 'Volume distribution ↑, albumine ↓, passage placentaire [ESA 2023]';
      case CategoriePathologie.metabolique:
        return 'Volume distribution ↑ (obésité), sensibilité insuline ↓ [M9 §26]';
      case CategoriePathologie.neurologique:
        return 'Barrière hémato-encéphalique — MAC réduit [M9 §14]';
      default:
        return 'Pas d\'impact PK spécifique documenté';
    }
  }
}

// ── Sévérité de la pathologie ─────────────────────────────────
//
// Alignée sur les scores de sévérité validés :
//   mild     → atteinte légère, peu ou pas d'ajustement
//              Ex : MRC stade 1-2 (DFG 60-89) [KDIGO 2023]
//              Ex : Child-Pugh A (5–6 pts)     [EASL 2023]
//   moderate → atteinte modérée, ajustements nécessaires
//              Ex : MRC stade 3 (DFG 30-59)   [KDIGO 2023]
//              Ex : Child-Pugh B (7–9 pts)     [EASL 2023]
//   severe   → atteinte sévère, CI possibles, précautions majeures
//              Ex : MRC stade 4-5 (DFG < 30)  [KDIGO 2023]
//              Ex : Child-Pugh C (10–15 pts)   [EASL 2023]

enum SeveritePathologie {
  mild,     // [KDIGO] stade 1-2 / [EASL] Child-Pugh A
  moderate, // [KDIGO] stade 3   / [EASL] Child-Pugh B
  severe,   // [KDIGO] stade 4-5 / [EASL] Child-Pugh C
}

extension SeveriteLabel on SeveritePathologie {
  String get label {
    switch (this) {
      case SeveritePathologie.mild:     return 'Légère';
      case SeveritePathologie.moderate: return 'Modérée';
      case SeveritePathologie.severe:   return 'Sévère';
    }
  }

  /// Recommandation générale d'ajustement selon sévérité. [UPDT 2024]
  String get recommandationGenerale {
    switch (this) {
      case SeveritePathologie.mild:
        return 'Peu ou pas d\'ajustement — surveillance habituelle';
      case SeveritePathologie.moderate:
        return 'Réduire les doses ou espacer les intervalles — '
            'surveillance renforcée des signes toxiques';
      case SeveritePathologie.severe:
        return 'Précautions majeures — certains médicaments contre-indiqués. '
            'Contacter pharmacologue si doute. [UPDT 2024]';
    }
  }
}

// ── Niveau de risque (badge automatique) ──────────────────────
//
// Dérivé de la sévérité clinique et du nombre de contre-indications /
// précautions médicamenteuses associées à la pathologie. Purement indicatif
// pour l'UI (section 6 du cahier des charges écran Pathologies) — ne
// remplace pas le jugement clinique.

enum NiveauRisque {
  faible,     // 🟢 — atteinte légère, pas de restriction médicamenteuse connue
  prudence,   // 🟡 — atteinte modérée ou quelques précautions
  attention,  // 🟠 — atteinte sévère ou plusieurs contre-indications
  eleve,      // 🔴 — atteinte sévère ET contre-indications/précautions multiples
}

extension NiveauRisqueLabel on NiveauRisque {
  String get emoji {
    switch (this) {
      case NiveauRisque.faible:    return '🟢';
      case NiveauRisque.prudence:  return '🟡';
      case NiveauRisque.attention: return '🟠';
      case NiveauRisque.eleve:     return '🔴';
    }
  }

  String get label {
    switch (this) {
      case NiveauRisque.faible:    return 'Risque faible';
      case NiveauRisque.prudence:  return 'Prudence';
      case NiveauRisque.attention: return 'Attention';
      case NiveauRisque.eleve:     return 'Risque élevé';
    }
  }
}

// ============================================================================
//  DOSEAJUSTEE
// ============================================================================

// ── Facteurs d'ajustement de référence ───────────────────────
//
// Basés sur [UPDT 2024] et les RCP officiels [ANSM] :
//
// Insuffisance rénale (DFG < 30 ml/min) [KDIGO 2023 ; UPDT 2024] :
//   Morphine      → facteur 0.5 (M6G accumule) [ANSM RCP]
//   Midazolam     → facteur 0.75 (métabolites actifs) [ANSM RCP]
//   Gabapentine   → facteur 0.25–0.5 selon DFG [UPDT 2024]
//
// Insuffisance hépatique Child-Pugh C [EASL 2023 ; UPDT 2024] :
//   Propofol      → facteur 0.75 (Vd augmenté, clairance réduite) [UPDT]
//   Midazolam     → facteur 0.5 (CYP3A4 très réduit) [ANSM RCP]
//   Fentanyl      → facteur 0.75 (liaison protéines ↓) [UPDT 2024]
//
// Le [facteur] est appliqué à la dose standard calculée au poids.
// facteur = 1.0 → dose inchangée
// facteur = 0.5 → réduction de 50%

/// Ajustement de dose lié à une pathologie pour un médicament spécifique.
///
/// Sources : [ANSM] RCP officiels ; [UPDT 2024] ; [KDIGO 2023] ; [EASL 2023].
@immutable
class DoseAjustee {
  /// Identifiant du médicament (correspond à [Drug.id]).
  final String drugId;

  /// Facteur multiplicatif appliqué à la dose standard.
  /// Doit être > 0. Ex : 0.5 = réduction de 50%. [UPDT 2024]
  final double facteur;

  /// Justification clinique sourcée de l'ajustement.
  final String note;

  const DoseAjustee({
    required this.drugId,
    required this.facteur,
    required this.note,
  }) : assert(facteur > 0, 'Le facteur doit être > 0');

  bool get estReduit    => facteur < 1.0;
  bool get estAugmente  => facteur > 1.0;
  bool get estInchange  => facteur == 1.0;

  double get pourcentageVariation => (facteur - 1.0) * 100.0;

  String get variationLabel {
    if (estInchange)  return 'Dose standard';
    if (estReduit)    return 'Réduction ${(-pourcentageVariation).toStringAsFixed(0)}%';
    return 'Augmentation ${pourcentageVariation.toStringAsFixed(0)}%';
  }

  Map<String, dynamic> toMap() => {
    'drugId':  drugId,
    'facteur': facteur,
    'note':    note,
  };

  factory DoseAjustee.fromMap(Map<String, dynamic> map) => DoseAjustee(
    drugId:  map['drugId']  as String,
    facteur: (map['facteur'] as num).toDouble(),
    note:    map['note']    as String,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseAjustee && drugId == other.drugId;

  @override
  int get hashCode => drugId.hashCode;

  @override
  String toString() => 'DoseAjustee($drugId × $facteur — $variationLabel)';
}

// ============================================================================
//  PATHOLOGIE
// ============================================================================

/// Modèle immutable d'une pathologie avec ses implications pharmacologiques.
///
/// Conçu pour s'intégrer avec [PathologyRulesService] et [DrugFilterService].
/// Toutes les listes sont const [] par défaut (zéro allocation inutile).
@immutable
class Pathologie {
  // ── Identité ──────────────────────────────────────────────
  final String              id;
  final String              nom;
  final String              description;
  final CategoriePathologie categorie;

  // Sévérité alignée KDIGO/Child-Pugh/GINA selon la catégorie [UPDT 2024]
  final SeveritePathologie  severite;

  // ── Informations cliniques ─────────────────────────────────

  /// Alertes affichées immédiatement à la sélection.
  /// Ex : "Risque anaphylaxie aux curares — prémédication recommandée" [SFAR 2019]
  final List<String> alertes;

  /// Recommandations générales de prise en charge péri-opératoire.
  /// Sources selon catégorie : [ESC 2022], [EASL 2023], [KDIGO 2023], [ESA 2023]
  final List<String> recommandations;

  /// Consignes spécifiques à la phase péri-opératoire (induction / entretien / réveil).
  /// Ex : "Intubation en séquence rapide si gastroparésie" [M9 §26]
  final List<String> consignes;

  /// Médicaments favorisés dans ce contexte — ex : cisatracurium si IR [KDIGO 2023]
  final List<String> droguesFavorisees;

  /// Contre-indications médicamenteuses liées à la pathologie.
  /// Ex : AINS contre-indiqués si MRC stade ≥ 3 [KDIGO 2023]
  final List<String> contreIndications;

  /// Ajustements de dose par médicament — facteurs issus de [UPDT 2024][ANSM]
  final List<DoseAjustee> dosesAjustees;

  // ── Fiche clinique détaillée (BottomSheet "Info", section 7) ──────────

  /// Physiopathologie résumée — base de la fiche détaillée.
  final String physiopathologie;

  /// Conséquences anesthésiques spécifiques (distinct des [recommandations]
  /// générales de prise en charge péri-opératoire).
  final List<String> consequencesAnesthesiques;

  /// Examens complémentaires péri-opératoires recommandés.
  final List<String> examensRecommandes;

  /// Médicaments à utiliser avec prudence — plus souple qu'une contre-
  /// indication formelle ([contreIndications]).
  final List<String> medicamentsAEviter;

  /// Interactions médicamenteuses notables liées à cette pathologie.
  final List<String> interactions;

  /// Éléments de surveillance péri-opératoire spécifiques.
  final List<String> surveillance;

  /// Recommandations de ventilation mécanique, le cas échéant.
  final String ventilation;

  /// Objectifs hémodynamiques cibles (PAM, FC, remplissage...).
  final String objectifsHemodynamiques;

  /// Objectifs respiratoires cibles (SpO2, EtCO2, PEEP...).
  final String objectifsRespiratoires;

  /// Objectifs neurologiques cibles (PIC, PPC, glycémie...).
  final String objectifsNeurologiques;

  /// Objectifs métaboliques cibles (glycémie, ionogramme...).
  final String objectifsMetaboliques;

  /// Références bibliographiques de la fiche (affichées en pied de fiche).
  final List<String> references;

  /// Mots-clés / synonymes utilisés par la recherche instantanée
  /// (section 14) — non affichés directement à l'écran.
  final List<String> motsCles;

  // ── État UI ───────────────────────────────────────────────
  final bool estSelectionnee;

  const Pathologie({
    required this.id,
    required this.nom,
    required this.description,
    required this.categorie,
    this.severite                = SeveritePathologie.moderate,
    this.alertes                 = const [],
    this.recommandations         = const [],
    this.consignes               = const [],
    this.droguesFavorisees       = const [],
    this.contreIndications       = const [],
    this.dosesAjustees           = const [],
    this.physiopathologie        = '',
    this.consequencesAnesthesiques = const [],
    this.examensRecommandes      = const [],
    this.medicamentsAEviter      = const [],
    this.interactions            = const [],
    this.surveillance            = const [],
    this.ventilation             = '',
    this.objectifsHemodynamiques = '',
    this.objectifsRespiratoires  = '',
    this.objectifsNeurologiques  = '',
    this.objectifsMetaboliques   = '',
    this.references              = const [],
    this.motsCles                 = const [],
    this.estSelectionnee         = false,
  });

  // ── Labels & helpers d'affichage ──────────────────────────

  String get labelCategorie  => categorie.label;
  String get labelSeverite   => severite.label;
  String get emojiCategorie  => categorie.emoji;
  String get impactPK        => categorie.impactPK;
  String get recommandationGeneraleSeverite => severite.recommandationGenerale;

  // ── Helpers booléens ──────────────────────────────────────

  bool get aDesAlertes     => alertes.isNotEmpty;
  bool get aDesRecos       => recommandations.isNotEmpty;
  bool get aDesConsignes   => consignes.isNotEmpty;
  bool get aDesContrindics => contreIndications.isNotEmpty;
  bool get aDesAjustements => dosesAjustees.isNotEmpty;
  bool get estSevere       => severite == SeveritePathologie.severe;

  /// La fiche détaillée (BottomSheet Info) a-t-elle du contenu à afficher ?
  bool get aUneFicheDetaillee =>
      physiopathologie.isNotEmpty ||
      consequencesAnesthesiques.isNotEmpty ||
      examensRecommandes.isNotEmpty ||
      medicamentsAEviter.isNotEmpty ||
      interactions.isNotEmpty ||
      surveillance.isNotEmpty ||
      ventilation.isNotEmpty ||
      references.isNotEmpty;

  // ── Niveau de risque automatique (section 6) ──────────────
  //
  // Heuristique indicative combinant sévérité clinique et nombre de
  // restrictions médicamenteuses (CI formelles + précautions). Ne remplace
  // pas un jugement clinique individualisé.
  NiveauRisque get niveauRisque {
    final restrictions = contreIndications.length + medicamentsAEviter.length;
    switch (severite) {
      case SeveritePathologie.severe:
        return restrictions > 0 ? NiveauRisque.eleve : NiveauRisque.attention;
      case SeveritePathologie.moderate:
        return restrictions > 0 ? NiveauRisque.attention : NiveauRisque.prudence;
      case SeveritePathologie.mild:
        return restrictions > 0 ? NiveauRisque.prudence : NiveauRisque.faible;
    }
  }

  // ── Recherche instantanée (section 14) ────────────────────
  //
  // Recherche par nom, description, catégorie et mots-clés/synonymes.
  bool correspondARecherche(String requete) {
    final q = requete.trim().toLowerCase();
    if (q.isEmpty) return true;
    return nom.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q) ||
        labelCategorie.toLowerCase().contains(q) ||
        motsCles.any((m) => m.toLowerCase().contains(q));
  }

  // ── Helpers catégorie ─────────────────────────────────────
  // Utilisés par PathologyRulesService pour filtrer les médicaments

  /// Pathologie hépatique → impact sur métabolisme CYP450. [EASL 2023]
  bool get affectsHepar        => categorie == CategoriePathologie.hepatique;

  /// Pathologie rénale → impact sur élimination rénale. [KDIGO 2023]
  bool get affectsRenal        => categorie == CategoriePathologie.renal;

  /// Pathologie neurologique → impact MAC, sédation. [M9 §14]
  bool get affectsNeurological => categorie == CategoriePathologie.neurologique;

  /// Grossesse → pharmacologie foeto-placentaire. [ESA 2023]
  bool get affectsObstetrique  => categorie == CategoriePathologie.obstetrique;

  /// Allergie → risque anaphylaxie / réactions croisées. [SFAR 2019]
  bool get affectsAllergique   => categorie == CategoriePathologie.allergique;

  // ── Accès aux ajustements de dose ────────────────────────

  /// Retourne l'ajustement pour un médicament donné, ou null.
  DoseAjustee? ajustementPour(String drugId) {
    try {
      return dosesAjustees.firstWhere((d) => d.drugId == drugId);
    } catch (_) {
      return null;
    }
  }

  bool aUnAjustementPour(String drugId) => ajustementPour(drugId) != null;

  // ── copyWith complet ──────────────────────────────────────

  Pathologie copyWith({
    String?              id,
    String?              nom,
    String?              description,
    CategoriePathologie? categorie,
    SeveritePathologie?  severite,
    List<String>?        alertes,
    List<String>?        recommandations,
    List<String>?        consignes,
    List<String>?        droguesFavorisees,
    List<String>?        contreIndications,
    List<DoseAjustee>?   dosesAjustees,
    String?              physiopathologie,
    List<String>?        consequencesAnesthesiques,
    List<String>?        examensRecommandes,
    List<String>?        medicamentsAEviter,
    List<String>?        interactions,
    List<String>?        surveillance,
    String?              ventilation,
    String?              objectifsHemodynamiques,
    String?              objectifsRespiratoires,
    String?              objectifsNeurologiques,
    String?              objectifsMetaboliques,
    List<String>?        references,
    List<String>?        motsCles,
    bool?                estSelectionnee,
  }) {
    return Pathologie(
      id:                id                ?? this.id,
      nom:               nom               ?? this.nom,
      description:       description       ?? this.description,
      categorie:         categorie         ?? this.categorie,
      severite:          severite          ?? this.severite,
      alertes:           alertes           ?? this.alertes,
      recommandations:   recommandations   ?? this.recommandations,
      consignes:         consignes         ?? this.consignes,
      droguesFavorisees: droguesFavorisees ?? this.droguesFavorisees,
      contreIndications: contreIndications ?? this.contreIndications,
      dosesAjustees:     dosesAjustees     ?? this.dosesAjustees,
      physiopathologie:  physiopathologie  ?? this.physiopathologie,
      consequencesAnesthesiques:
          consequencesAnesthesiques ?? this.consequencesAnesthesiques,
      examensRecommandes:      examensRecommandes      ?? this.examensRecommandes,
      medicamentsAEviter:      medicamentsAEviter      ?? this.medicamentsAEviter,
      interactions:            interactions            ?? this.interactions,
      surveillance:            surveillance            ?? this.surveillance,
      ventilation:             ventilation             ?? this.ventilation,
      objectifsHemodynamiques: objectifsHemodynamiques ?? this.objectifsHemodynamiques,
      objectifsRespiratoires:  objectifsRespiratoires  ?? this.objectifsRespiratoires,
      objectifsNeurologiques:  objectifsNeurologiques  ?? this.objectifsNeurologiques,
      objectifsMetaboliques:   objectifsMetaboliques   ?? this.objectifsMetaboliques,
      references:              references              ?? this.references,
      motsCles:                motsCles                ?? this.motsCles,
      estSelectionnee:   estSelectionnee   ?? this.estSelectionnee,
    );
  }

  /// Alias francophone de [copyWith] — utilisé par [AppProvider].
  Pathologie copierAvec({
    String?              id,
    String?              nom,
    String?              description,
    CategoriePathologie? categorie,
    SeveritePathologie?  severite,
    List<String>?        alertes,
    List<String>?        recommandations,
    List<String>?        consignes,
    List<String>?        droguesFavorisees,
    List<String>?        contreIndications,
    List<DoseAjustee>?   dosesAjustees,
    String?              physiopathologie,
    List<String>?        consequencesAnesthesiques,
    List<String>?        examensRecommandes,
    List<String>?        medicamentsAEviter,
    List<String>?        interactions,
    List<String>?        surveillance,
    String?              ventilation,
    String?              objectifsHemodynamiques,
    String?              objectifsRespiratoires,
    String?              objectifsNeurologiques,
    String?              objectifsMetaboliques,
    List<String>?        references,
    List<String>?        motsCles,
    bool?                estSelectionnee,
  }) => copyWith(
    id:                id,
    nom:               nom,
    description:       description,
    categorie:         categorie,
    severite:          severite,
    alertes:           alertes,
    recommandations:   recommandations,
    consignes:         consignes,
    droguesFavorisees: droguesFavorisees,
    contreIndications: contreIndications,
    dosesAjustees:     dosesAjustees,
    physiopathologie:  physiopathologie,
    consequencesAnesthesiques: consequencesAnesthesiques,
    examensRecommandes:      examensRecommandes,
    medicamentsAEviter:      medicamentsAEviter,
    interactions:            interactions,
    surveillance:            surveillance,
    ventilation:             ventilation,
    objectifsHemodynamiques: objectifsHemodynamiques,
    objectifsRespiratoires:  objectifsRespiratoires,
    objectifsNeurologiques:  objectifsNeurologiques,
    objectifsMetaboliques:   objectifsMetaboliques,
    references:              references,
    motsCles:                motsCles,
    estSelectionnee:   estSelectionnee,
  );


  // ── Sérialisation ─────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'id':                id,
    'nom':               nom,
    'description':       description,
    'categorie':         categorie.index,
    'severite':          severite.index,
    'alertes':           alertes,
    'recommandations':   recommandations,
    'consignes':         consignes,
    'droguesFavorisees': droguesFavorisees,
    'contreIndications': contreIndications,
    'dosesAjustees':     dosesAjustees.map((d) => d.toMap()).toList(),
    'physiopathologie':        physiopathologie,
    'consequencesAnesthesiques': consequencesAnesthesiques,
    'examensRecommandes':      examensRecommandes,
    'medicamentsAEviter':      medicamentsAEviter,
    'interactions':            interactions,
    'surveillance':            surveillance,
    'ventilation':             ventilation,
    'objectifsHemodynamiques': objectifsHemodynamiques,
    'objectifsRespiratoires':  objectifsRespiratoires,
    'objectifsNeurologiques':  objectifsNeurologiques,
    'objectifsMetaboliques':   objectifsMetaboliques,
    'references':              references,
    'motsCles':                motsCles,
    'estSelectionnee':   estSelectionnee,
  };

  factory Pathologie.fromMap(Map<String, dynamic> map) => Pathologie(
    id:                map['id']          as String,
    nom:               map['nom']         as String,
    description:       map['description'] as String,
    categorie:         CategoriePathologie.values[map['categorie'] as int],
    severite:          SeveritePathologie.values[map['severite']   as int? ?? 1],
    alertes:           List<String>.from(map['alertes']           ?? []),
    recommandations:   List<String>.from(map['recommandations']   ?? []),
    consignes:         List<String>.from(map['consignes']         ?? []),
    droguesFavorisees: List<String>.from(map['droguesFavorisees'] ?? []),
    contreIndications: List<String>.from(map['contreIndications'] ?? []),
    dosesAjustees: (map['dosesAjustees'] as List<dynamic>? ?? [])
        .map((e) => DoseAjustee.fromMap(e as Map<String, dynamic>))
        .toList(),
    physiopathologie:        map['physiopathologie']        as String? ?? '',
    consequencesAnesthesiques:
        List<String>.from(map['consequencesAnesthesiques'] ?? []),
    examensRecommandes: List<String>.from(map['examensRecommandes'] ?? []),
    medicamentsAEviter: List<String>.from(map['medicamentsAEviter'] ?? []),
    interactions:       List<String>.from(map['interactions']       ?? []),
    surveillance:       List<String>.from(map['surveillance']       ?? []),
    ventilation:             map['ventilation']             as String? ?? '',
    objectifsHemodynamiques: map['objectifsHemodynamiques'] as String? ?? '',
    objectifsRespiratoires:  map['objectifsRespiratoires']  as String? ?? '',
    objectifsNeurologiques:  map['objectifsNeurologiques']  as String? ?? '',
    objectifsMetaboliques:   map['objectifsMetaboliques']   as String? ?? '',
    references:  List<String>.from(map['references'] ?? []),
    motsCles:    List<String>.from(map['motsCles']    ?? []),
    estSelectionnee: map['estSelectionnee'] as bool? ?? false,
  );

  // ── Equatable ─────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pathologie && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Pathologie($id: $nom [$labelCategorie / $labelSeverite])';
}