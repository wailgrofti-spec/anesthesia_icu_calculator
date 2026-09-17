// ============================================================================
//  lib/data/respiratory_calc_pediatric_data.dart
//  Ajustements pédiatriques appliqués par-dessus les règles adultes de
//  respiratory_calc_data.dart, quand le mode pédiatrique est actif.
//
//  Principe : le Vt (mL/kg) et les logiques FiO2/driving pressure restent
//  les mêmes ratios qu'à l'âge adulte (recommandations transposées à
//  l'enfant par les sociétés savantes), mais la fréquence respiratoire et
//  les pressions doivent être adaptées à l'âge — un nouveau-né et un
//  adolescent n'ont pas du tout les mêmes valeurs physiologiques de base.
//
//  Sources (approximations larges à visée de calculateur clinique, à
//  confirmer avec une référence pédiatrique spécialisée / réanimateur
//  pédiatrique — ne remplace pas un protocole de service) :
//  - PALICC-2 (Pediatric Acute Lung Injury Consensus Conference), Pediatr
//    Crit Care Med 2023 — ventilation protectrice pédiatrique, Pplat cible.
//  - Nichols DG, Rogers Textbook of Pediatric Intensive Care.
//  - SFAR/GFRUP — Recommandations ventilation pédiatrique périopératoire.
// ============================================================================

/// Tranche d'âge pédiatrique utilisée pour adapter FR / pressions.
enum PediatricAgeBand {
  neonate,     // 0 - 28 jours
  infant,      // 1 - 12 mois
  toddler,     // 1 - 5 ans
  child,       // 6 - 12 ans
  adolescent,  // 12 - 18 ans (proche de l'adulte)
}

/// Détermine la tranche d'âge pédiatrique à partir de l'âge en mois.
PediatricAgeBand pediatricAgeBandFromMonths(double ageInMonths) {
  if (ageInMonths <= 1.0) return PediatricAgeBand.neonate; // ~28 jours
  if (ageInMonths < 12.0) return PediatricAgeBand.infant;
  if (ageInMonths < 72.0) return PediatricAgeBand.toddler;   // < 6 ans
  if (ageInMonths < 144.0) return PediatricAgeBand.child;    // < 12 ans
  return PediatricAgeBand.adolescent;
}

/// Bornes FR (fréquence respiratoire, /min) par tranche d'âge — valeurs de
/// réglage ventilateur (plus basses que la FR spontanée physiologique).
class PediatricFrRange {
  final double min;
  final double max;
  const PediatricFrRange(this.min, this.max);
}

const Map<PediatricAgeBand, PediatricFrRange> pediatricFrByAgeBand = {
  PediatricAgeBand.neonate:    PediatricFrRange(30, 40),
  PediatricAgeBand.infant:     PediatricFrRange(25, 35),
  PediatricAgeBand.toddler:    PediatricFrRange(20, 30),
  PediatricAgeBand.child:      PediatricFrRange(16, 24),
  PediatricAgeBand.adolescent: PediatricFrRange(14, 20),
};

/// Pression de plateau max recommandée en pédiatrie — PALICC-2 propose une
/// cible légèrement plus basse qu'ARDSNet adulte (28 vs 30 cmH2O), en
/// particulier pour le SDRA pédiatrique.
const double pediatricPlateauPressureMax = 28.0;

/// PEEP de base pédiatrique (poumons sains) — généralement un peu plus
/// basse qu'à l'âge adulte chez le nourrisson/petit enfant.
class PediatricPeepRange {
  final double min;
  final double max;
  const PediatricPeepRange(this.min, this.max);
}

const Map<PediatricAgeBand, PediatricPeepRange> pediatricPeepByAgeBand = {
  PediatricAgeBand.neonate:    PediatricPeepRange(4, 6),
  PediatricAgeBand.infant:     PediatricPeepRange(4, 6),
  PediatricAgeBand.toddler:    PediatricPeepRange(4, 6),
  PediatricAgeBand.child:      PediatricPeepRange(5, 8),
  PediatricAgeBand.adolescent: PediatricPeepRange(5, 8),
};

extension PediatricAgeBandLabel on PediatricAgeBand {
  String get label {
    switch (this) {
      case PediatricAgeBand.neonate:    return 'Nouveau-né (0-28j)';
      case PediatricAgeBand.infant:     return 'Nourrisson (1-12 mois)';
      case PediatricAgeBand.toddler:    return 'Petit enfant (1-5 ans)';
      case PediatricAgeBand.child:      return 'Enfant (6-12 ans)';
      case PediatricAgeBand.adolescent: return 'Adolescent (12-18 ans)';
    }
  }
}
