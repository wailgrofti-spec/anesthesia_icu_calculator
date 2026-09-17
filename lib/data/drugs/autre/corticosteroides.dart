// ===========================
//  lib/data/autre/corticosteroides.dart
//  Categorie : CORTICOSTEROIDES
//  Issu de l'éclatement de systemic_adjuvants_data.dart (architecture
//  data-driven — voir models/drug.dart::therapeuticClass)
//  2 medicament(s)
// ===========================

import '../../../models/drug.dart';

const List<Drug> corticosteroidDrugs = [

  Drug(
    id: 'dexamethasone',
    name: 'Dexaméthasone',
    genericName: 'Dexaméthasone phosphate sodique',
    category: DrugCategory.other,
    therapeuticClass: 'Corticostéroïdes',
    subCategory: 'Corticostéroïde — Anti-inflammatoire / Antiémétique',
    bolus: DoseRange(min: 0.05, max: 0.15, unit: DoseUnit.mgPerKg, label: 'NVPO / Anti-inflammatoire (dose unique)', maxAbsoluteDose: 10),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.mgPerKgH, label: 'Pas de perfusion continue standard'),
    bolusMethod: 'IV lente (1–2 min) ou IM. Prophylaxie NVPO : 4–8 mg IV à l\'induction (dose la plus fréquente). Œdème laryngé/stridor post-extubation : 0.15–0.6 mg/kg (max 10 mg), répétable q6h.',
    infusionRate: 'Non utilisé en perfusion continue en anesthésie — bolus itératifs si besoin (q6–24h selon indication).',
    preparation: '4 mg/ml (le plus courant) ou 20 mg/5ml. Prêt à l\'emploi ; dilution possible dans NaCl 0.9% ou G5% pour IV lente.',
    standardConcentrationMgPerMl: 4.0,
    shortWarning: 'Hyperglycémie. Immunosuppression. Ne traite PAS l\'urgence anaphylactique aiguë (délai d\'action 1–2h) — adrénaline reste le traitement de 1ère ligne.',
    warnings: [
      'Délai d\'action de plusieurs heures — NE REMPLACE PAS l\'adrénaline en 1ère ligne de l\'anaphylaxie ni le salbutamol dans le bronchospasme aigu',
      'Hyperglycémie dose-dépendante — surveiller la glycémie capillaire chez le diabétique et en peropératoire prolongé',
      'Immunosuppression — prudence en cas d\'infection active ou de sepsis non contrôlé',
      'Insomnie, agitation, plus rarement troubles psychiatriques aigus à fortes doses',
      'Discussion au cas par cas avec le chirurgien ORL en cas de risque hémorragique post-amygdalectomie — bénéfice antiémétique généralement jugé supérieur',
      'Quasi dénué d\'effet minéralocorticoïde (contrairement à l\'hydrocortisone) — peu de rétention hydrosodée',
    ],
    pediatricBolus: DoseRange(min: 0.15, max: 0.6, unit: DoseUnit.mgPerKg, label: 'Laryngite / œdème laryngé enfant', maxAbsoluteDose: 10),
    pediatricNotes: 'Dose de référence en laryngite aiguë sous-glottique (crup) : 0.15–0.6 mg/kg dose unique, 0.15 mg/kg souvent suffisant. Efficace en 2–4h.',
    indications: [
      'Prophylaxie des nausées/vomissements postopératoires (NVPO) — 4–8 mg IV à l\'induction',
      'Œdème laryngé / stridor post-extubation, laryngite aiguë sous-glottique',
      'Adjuvant dans l\'anaphylaxie et le bronchospasme sévère (après adrénaline/salbutamol)',
      'Insuffisance surrénalienne aiguë suspectée avant confirmation biologique (n\'interfère pas avec le dosage du cortisol, contrairement à l\'hydrocortisone)',
      'Œdème cérébral péritumoral, compression médullaire (neurochirurgie)',
      'Prévention de l\'exacerbation d\'asthme/BPCO périopératoire chez le patient à risque',
    ],
    mechanism: 'Agoniste des récepteurs glucocorticoïdes → inhibition de la phospholipase A2 et de la synthèse des prostaglandines/leucotriènes ; puissance glucocorticoïde ~25–30x l\'hydrocortisone',
    onset: '1–2h (effet anti-inflammatoire complet) ; plus précoce sur les NVPO',
    duration: '36–54h (longue durée d\'action biologique)',
  ),

  Drug(
    id: 'hydrocortisone',
    name: 'Hydrocortisone',
    genericName: 'Hémisuccinate d\'hydrocortisone',
    category: DrugCategory.other,
    therapeuticClass: 'Corticostéroïdes',
    subCategory: 'Corticostéroïde — Insuffisance Surrénalienne / Choc Septique',
    bolus: DoseRange(min: 1.0, max: 2.0, unit: DoseUnit.mgPerKg, label: 'Bolus insuffisance surrénalienne aiguë', maxAbsoluteDose: 100),
    infusion: DoseRange(min: 0.08, max: 0.15, unit: DoseUnit.mgPerKgH, label: 'Perfusion continue (choc septique réfractaire)'),
    bolusMethod: 'IV directe ou IM. Insuffisance surrénalienne aiguë : 100 mg IV puis 100 mg/6–8h. Couverture du stress chirurgical chez insuffisant surrénalien connu : 25–100 mg IV à l\'induction selon ampleur du geste.',
    infusionRate: 'Choc septique réfractaire aux vasopresseurs (Surviving Sepsis Campaign) : ≈200 mg/24h en perfusion continue (≈0.1 mg/kg/h pour 70 kg), alternative 50 mg IVD q6h.',
    preparation: 'Poudre à reconstituer 100 mg ou 500 mg. Reconstituer avec le solvant fourni puis diluer dans NaCl 0.9% ou G5% pour perfusion (ex : 100 mg dans 100 ml).',
    standardConcentrationMgPerMl: 1.0,
    shortWarning: 'Interfère avec le dosage du cortisol plasmatique (contrairement à la dexaméthasone). Hyperglycémie, rétention hydrosodée.',
    warnings: [
      'Interfère avec les dosages de cortisol/test au Synacthène — préférer la dexaméthasone si un diagnostic biologique est encore nécessaire',
      'Hyperglycémie, HTA, rétention hydrosodée (effet minéralocorticoïde net, contrairement à la dexaméthasone)',
      'Immunosuppression — prudence en cas d\'infection non contrôlée',
      'Arrêt brutal après traitement prolongé → risque de crise surrénalienne — décroissance progressive',
      'Chez le patient sous corticothérapie chronique, majorer la dose en péri-opératoire (couverture du stress chirurgical) pour éviter une insuffisance surrénalienne aiguë',
    ],
    indications: [
      'Insuffisance surrénalienne aiguë (crise addisonienne) — traitement de référence',
      'Couverture périopératoire du stress chirurgical chez le patient sous corticothérapie chronique',
      'Choc septique réfractaire aux vasopresseurs à dose élevée (recommandations Surviving Sepsis Campaign)',
      'Anaphylaxie réfractaire, en adjuvant après adrénaline',
    ],
    mechanism: 'Agoniste des récepteurs glucocorticoïdes ET minéralocorticoïdes (contrairement à la dexaméthasone) → effet de substitution complet de la fonction surrénalienne',
    onset: '1h (effet hémodynamique dans le choc septique parfois plus rapide, non génomique)',
    duration: '8–12h (durée d\'action biologique courte comparée à la dexaméthasone)',
  ),

];
