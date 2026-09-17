// ===========================
//  lib/data/autre/insulines.dart
//  Categorie : INSULINES
//  Issu de l'éclatement de systemic_adjuvants_data.dart (architecture
//  data-driven — voir models/drug.dart::therapeuticClass)
//  1 medicament(s)
// ===========================

import '../../../models/drug.dart';

const List<Drug> insulinDrugs = [

  Drug(
    id: 'insuline_rapide',
    name: 'Insuline Rapide',
    genericName: 'Insuline humaine rapide / analogue rapide (Actrapid®, NovoRapid®...)',
    category: DrugCategory.other,
    therapeuticClass: 'Insulines',
    subCategory: 'Hormone — Contrôle Glycémique',
    bolus: DoseRange(min: 10.0, max: 10.0, unit: DoseUnit.unitsFixed, label: 'Hyperkaliémie aiguë — dose fixe (UI), avec apport glucosé'),
    infusion: DoseRange(min: 0.05, max: 0.1, unit: DoseUnit.unitsFixed, label: 'Perfusion continue IVSE — UI/kg/h (acidocétose, contrôle glycémique)'),
    bolusMethod: 'Hyperkaliémie menaçante : 10 UI insuline rapide IV directe associée SYSTÉMATIQUEMENT à 30 g de glucose (G30% 100 ml) pour prévenir l\'hypoglycémie — effet en 15–30 min, durée 4–6h.',
    infusionRate: 'Acidocétose diabétique / hyperglycémie sévère : 0.05–0.1 UI/kg/h IVSE (SAP dédiée), sans bolus initial selon les recommandations actuelles. Objectif : baisse glycémique ≤4–5 mmol/l/h (éviter l\'œdème cérébral, surtout chez l\'enfant).',
    preparation: '100 UI/ml (flacon standard). Pour SAP : diluer à 1 UI/ml (50 UI dans 50 ml NaCl 0.9%) — voie et seringue dédiées exclusivement à l\'insuline ; purger la tubulure avant branchement (adsorption au plastique).',
    shortWarning: 'HYPOGLYCÉMIE = urgence vitale. Toujours associer un apport glucosé au bolus. Surveillance glycémique capillaire horaire sous perfusion.',
    warnings: [
      'Risque d\'hypoglycémie sévère — surveillance glycémique capillaire horaire obligatoire sous perfusion continue, resucrage immédiat si <0.7 g/l (3.9 mmol/l)',
      'Hypokaliémie induite (entrée intracellulaire du K⁺ avec le glucose) — surveiller la kaliémie, notamment en association au traitement de l\'hyperkaliémie',
      'Adsorption au plastique de la tubulure — purger avec 20–50 ml de solution avant de brancher au patient pour saturer les sites d\'adsorption',
      'Ne jamais administrer de bolus IV sans apport glucosé simultané en dehors de l\'hyperglycémie symptomatique isolée',
      'Voie IV strictement dédiée (aucun autre médicament dans la même tubulure) — risque d\'erreur de dose gravissime, double vérification recommandée',
    ],
    indications: [
      'Hyperkaliémie menaçante (adjuvant du gluconate de calcium et de la ventilation/bicarbonate)',
      'Acidocétose diabétique et syndrome hyperosmolaire (protocole associé à la réhydratation)',
      'Contrôle glycémique périopératoire chez le patient diabétique (protocole insuline-glucose)',
      'Hyperglycémie de stress en réanimation (objectif habituel 1.4–1.8 g/l, éviter l\'hypoglycémie)',
    ],
    mechanism: 'Liaison au récepteur insulinique → translocation des transporteurs GLUT4, entrée cellulaire du glucose et du potassium, inhibition de la lipolyse/cétogenèse',
    onset: '10–30 min IV',
    duration: '4–6h (insuline rapide humaine) ; plus courte pour les analogues rapides (3–5h)',
  ),

];
