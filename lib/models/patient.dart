import 'dart:math' as math;

enum Sex { male, female }

extension SexExtension on Sex {
  String get label {
    switch (this) {
      case Sex.male:
        return 'H';
      case Sex.female:
        return 'F';
    }
  }
}

/// Unité de saisie de l'âge.
/// En mode pédiatrique, on autorise mois/jours pour les nourrissons
/// (ex : "15 jours" ou "6 mois") en plus des années décimales (ex : "0.5" ans).
enum AgeUnit { years, months, days }

extension AgeUnitExtension on AgeUnit {
  String get label {
    switch (this) {
      case AgeUnit.years:
        return 'ans';
      case AgeUnit.months:
        return 'mois';
      case AgeUnit.days:
        return 'jours';
    }
  }

  String get shortLabel {
    switch (this) {
      case AgeUnit.years:
        return 'A';
      case AgeUnit.months:
        return 'M';
      case AgeUnit.days:
        return 'J';
    }
  }
}

class Patient {
  final double? weight;
  final double? height;

  /// Valeur brute saisie par l'utilisateur, exprimée dans [ageUnit].
  /// Ex : 15 jours  -> ageValue = 15,  ageUnit = AgeUnit.days
  ///      6 mois    -> ageValue = 6,   ageUnit = AgeUnit.months
  ///      0.5 ans   -> ageValue = 0.5, ageUnit = AgeUnit.years
  final double? ageValue;
  final AgeUnit ageUnit;
  final Sex? sex;

  const Patient({
    this.weight,
    this.height,
    this.ageValue,
    this.ageUnit = AgeUnit.years,
    this.sex,
  });

  // ══════════════════════════════════════════════════════════
  //  CONVERSIONS D'ÂGE (canoniques, en double)
  // ══════════════════════════════════════════════════════════

  double? get ageInDays {
    if (ageValue == null) return null;
    switch (ageUnit) {
      case AgeUnit.years:
        return ageValue! * 365.25;
      case AgeUnit.months:
        return ageValue! * 30.4375;
      case AgeUnit.days:
        return ageValue!;
    }
  }

  double? get ageInMonths {
    if (ageValue == null) return null;
    switch (ageUnit) {
      case AgeUnit.years:
        return ageValue! * 12.0;
      case AgeUnit.months:
        return ageValue!;
      case AgeUnit.days:
        return ageValue! / 30.4375;
    }
  }

  double? get ageInYears {
    if (ageValue == null) return null;
    switch (ageUnit) {
      case AgeUnit.years:
        return ageValue!;
      case AgeUnit.months:
        return ageValue! / 12.0;
      case AgeUnit.days:
        return ageValue! / 365.25;
    }
  }

  /// Âge entier en années (arrondi au sol) — conservé pour compatibilité
  /// avec le code existant qui utilisait `int? age`.
  int? get age => ageInYears?.floor();

  bool get isNeonate => ageInDays != null && ageInDays! <= 28;
  bool get isInfant => ageInYears != null && ageInYears! < 1;
  bool get isChild => ageInYears != null && ageInYears! < 18;
  bool get isElderly => ageInYears != null && ageInYears! >= 65;

  /// Affichage de l'âge dans son unité de saisie d'origine.
  /// Ex : "15 jours", "6 mois", "1.5 ans", "45 ans"
  String get ageDisplay {
    if (ageValue == null) return '—';
    final v = ageValue!;
    final vStr =
        (v == v.roundToDouble()) ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    return '$vStr ${ageUnit.label}';
  }

  bool get isComplete =>
      weight != null && height != null && ageValue != null && sex != null;

  bool get hasHeight => height != null;
  bool get hasSex => sex != null;
  bool get hasWeight => weight != null;
  bool get hasAge => ageValue != null;

  double? get bmi {
    if (weight == null || height == null || height == 0) return null;
    final hMeters = height! / 100;
    return weight! / (hMeters * hMeters);
  }

  String get bmiCategory {
    final b = bmi;
    if (b == null) return '';
    if (b < 18.5) return 'Dénutrition';
    if (b < 25.0) return 'Normal';
    if (b < 30.0) return 'Surpoids';
    if (b < 35.0) return 'Obésité modérée';
    if (b < 40.0) return 'Obésité sévère';
    return 'Obésité morbide';
  }

  /// Libellé IMC à afficher — [bmiCategory] (Surpoids/Obésité/Dénutrition)
  /// n'est valide que chez l'adulte (≥ 18 ans). Chez l'enfant, la lecture du
  /// BMI nécessite les courbes IMC-pour-âge de l'OMS (percentiles), pas les
  /// seuils fixes adultes — on affiche donc une mention neutre plutôt qu'un
  /// faux diagnostic ("Obésité" à un chiffre qui serait normal à cet âge).
  String get bmiCategoryDisplay {
    if (bmi == null) return '';
    if (ageInYears != null && ageInYears! < 18) {
      return 'À interpréter selon courbe IMC/âge (OMS)';
    }
    return bmiCategory;
  }

  /// Poids idéal (Devine, 1974) — valide uniquement à partir de 152.4 cm,
  /// la formule d'origine ARDSNet/Devine n'ayant été validée que chez l'adulte.
  /// En dessous de cette taille (essentiellement les enfants), on utilise le
  /// poids réel comme référence — c'est la pratique clinique standard en
  /// pédiatrie : la ventilation protectrice pédiatrique se dose sur le poids
  /// réel, pas sur un "poids idéal" théorique (concept propre à l'adulte).
  double? get computedIbw {
    if (height == null || sex == null) return null;
    if (height! < 152.4) return weight;
    if (sex == Sex.male) {
      return 50.0 + 0.91 * (height! - 152.4);
    } else {
      return 45.5 + 0.91 * (height! - 152.4);
    }
  }

  /// `true` si [computedIbw] retombe sur le poids réel (taille < 152.4 cm) —
  /// utile pour afficher une note explicative dans l'UI plutôt qu'un
  /// résultat "Poids idéal" incohérent (ex : négatif) chez l'enfant.
  bool get ibwUsesActualWeight => height != null && height! < 152.4;

  double? get lbw {
    if (weight == null || height == null || sex == null) return null;
    // Formule de Boer
    if (sex == Sex.male) {
      return (0.407 * weight!) + (0.267 * height!) - 19.2;
    } else {
      return (0.252 * weight!) + (0.473 * height!) - 48.3;
    }
  }

  /// `true` si l'IBW/LBW ne sont pas applicables — aucune des formules
  /// adultes (Devine, Boer...) n'est validée avant 8 ans. En dessous de ce
  /// seuil, l'UI doit afficher "Non applicable" plutôt qu'un chiffre.
  bool get ibwLbwNotApplicable => ageInYears != null && ageInYears! < 8;

  /// Poids idéal "clinique" à afficher au patient — `null` si non
  /// applicable (< 8 ans). Distinct de [computedIbw], qui reste utilisé en
  /// interne comme poids de référence pour le calcul ventilatoire (PBW),
  /// où un repli sur le poids réel est acceptable même en dessous de 8 ans.
  double? get clinicalIbw => ibwLbwNotApplicable ? null : computedIbw;

  /// Poids maigre "clinique" à afficher au patient — `null` si non
  /// applicable (< 8 ans).
  double? get clinicalLbw => ibwLbwNotApplicable ? null : lbw;

  double? get bsa {
    if (weight == null || height == null) return null;
    // Formule de Mosteller
    return math.sqrt((height! * weight!) / 3600.0);
  }

  /// Vérifie la cohérence poids/âge.
  /// < 1 an  : estimation mensuelle (poids naissance ~3.3 kg + ~0.6 kg/mois).
  /// 1-17 ans: estimation grossière conservée de la version précédente.
  /// Ces formules restent des estimations larges destinées à repérer une
  /// erreur de saisie grossière, pas une courbe de croissance médicale.
  bool get isWeightCoherentForAge {
    if (weight == null || ageInYears == null) return true;

    final years = ageInYears!;
    final months = ageInMonths!;

    if (years < 1) {
      final estimated = 3.3 + (months * 0.6);
      return weight! >= (estimated * 0.5) && weight! <= (estimated * 1.8);
    }

    if (years < 18) {
      final estimated = (years * 3) + 7; // ex: 5 ans -> 22 kg
      return weight! >= (estimated * 0.4) && weight! <= (estimated * 2.5);
    }

    return true;
  }

  String? get weightAgeWarning {
    if (isWeightCoherentForAge) return null;
    return 'Le poids renseigné semble incohérent par rapport à l\'âge.';
  }

  Patient copyWith({
    double? weight,
    double? height,
    double? ageValue,
    AgeUnit? ageUnit,
    Sex? sex,
    bool clearAge = false,
  }) {
    return Patient(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      ageValue: clearAge ? null : (ageValue ?? this.ageValue),
      ageUnit: ageUnit ?? this.ageUnit,
      sex: sex ?? this.sex,
    );
  }
}
