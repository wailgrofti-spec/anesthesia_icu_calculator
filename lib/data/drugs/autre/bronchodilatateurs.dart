// ===========================
//  lib/data/autre/bronchodilatateurs.dart
//  Categorie : BRONCHODILATATEURS
//  Issu de l'éclatement de systemic_adjuvants_data.dart (architecture
//  data-driven — voir models/drug.dart::therapeuticClass)
//  2 medicament(s)
// ===========================

import '../../../models/drug.dart';

const List<Drug> bronchodilatorDrugs = [

  Drug(
    id: 'salbutamol',
    name: 'Salbutamol',
    genericName: 'Salbutamol (Albutérol)',
    category: DrugCategory.other,
    therapeuticClass: 'Bronchodilatateurs',
    subCategory: 'Bêta-2 Agoniste — Bronchodilatateur',
    bolus: DoseRange(min: 2.5, max: 5.0, unit: DoseUnit.unitsFixed, label: 'Nébulisation — dose fixe non pondérale (mg)'),
    infusion: DoseRange(min: 1.0, max: 5.0, unit: DoseUnit.mcgPerKgMin, label: 'IV continue — bronchospasme réfractaire (réa)'),
    bolusMethod: 'Nébulisation : 2.5–5 mg dans 2–4 ml NaCl 0.9%, répétable toutes les 20 min si besoin (jusqu\'à 3 doses en 1h en situation aiguë). IV directe (asthme aigu grave réfractaire, réanimation uniquement) : 100–200 mcg IV lente sur 5 min.',
    infusionRate: 'Bronchospasme réfractaire en réanimation : 1–5 mcg/kg/min IVSE, sous monitorage cardiaque continu (tachycardie, hypokaliémie).',
    preparation: 'Nébulisation : ampoules unidoses 2.5 mg/2.5ml ou 5 mg/2.5ml, prêtes à l\'emploi. IV : diluer 5 mg dans 500 ml G5% (10 mcg/ml) pour perfusion continue.',
    standardConcentrationMgPerMl: 0.01,
    shortWarning: 'Tachycardie, hypokaliémie (surtout en IV/perfusion). Tremblements fréquents et attendus. Surveiller la kaliémie si doses répétées.',
    warnings: [
      'Tachycardie et palpitations quasi systématiques — prudence en coronaropathie/arythmie',
      'Hypokaliémie dose-dépendante par entrée intracellulaire du potassium — surveiller la kaliémie si doses répétées ou perfusion IV',
      'Tremblements des extrémités fréquents (effet β2 périphérique) — ne pas confondre avec une aggravation clinique',
      'Hyperglycémie possible à fortes doses',
      'Voie IV réservée à l\'asthme aigu grave réfractaire à la nébulisation, sous surveillance rapprochée en réanimation',
    ],
    pediatricBolus: DoseRange(min: 2.5, max: 2.5, unit: DoseUnit.unitsFixed, label: 'Nébulisation enfant <6 ans (mg)'),
    pediatricNotes: 'Dose de nébulisation identique dès 2.5 mg chez le nourrisson/enfant (dose non pondérale). Chambre d\'inhalation possible en alternative si peu sévère.',
    indications: [
      'Bronchospasme peropératoire (laryngospasme avec composante bronchique, intubation chez l\'asthmatique)',
      'Exacerbation aiguë d\'asthme ou de BPCO',
      'Prémédication chez l\'asthmatique/BPCO avant chirurgie à risque',
      'Hyperkaliémie aiguë (effet adjuvant, favorise l\'entrée intracellulaire du K⁺)',
    ],
    mechanism: 'Agoniste sélectif des récepteurs β2-adrénergiques bronchiques → relâchement du muscle lisse bronchique via ↑AMPc',
    onset: '5 min (nébulisation) ; <5 min (IV)',
    duration: '3–6h (nébulisation)',
  ),

  Drug(
    id: 'ipratropium',
    name: 'Ipratropium',
    genericName: 'Bromure d\'Ipratropium',
    category: DrugCategory.other,
    therapeuticClass: 'Bronchodilatateurs',
    subCategory: 'Anticholinergique Inhalé — Bronchodilatateur',
    bolus: DoseRange(min: 0.5, max: 0.5, unit: DoseUnit.unitsFixed, label: 'Nébulisation adulte — dose fixe non pondérale (mg)'),
    infusion: DoseRange(min: 0.0, max: 0.0, unit: DoseUnit.unitsFixed, label: 'Pas de perfusion — usage inhalé exclusif'),
    bolusMethod: 'Nébulisation : 0.5 mg (500 mcg) dans 2–4 ml, souvent associé au salbutamol dans la même cupule (synergie démontrée). Répétable toutes les 20–30 min en situation aiguë.',
    infusionRate: 'Non applicable — voie inhalée uniquement, aucune forme IV disponible.',
    preparation: 'Ampoules unidoses 250 mcg/2ml ou 500 mcg/2ml, prêtes à l\'emploi pour nébulisation. Compatible en mélange avec le salbutamol dans la même cupule de nébuliseur.',
    standardConcentrationMgPerMl: 0.25,
    shortWarning: 'Sécheresse buccale, rétention urinaire possible. Éviter le contact oculaire (mydriase, risque de glaucome aigu par angle fermé).',
    warnings: [
      'Prudence si glaucome à angle fermé — éviter la projection du nébulisat dans les yeux (privilégier l\'embout buccal au masque si possible)',
      'Rétention urinaire possible, notamment chez l\'homme âgé avec hypertrophie prostatique',
      'Sécheresse buccale ; moins d\'effets systémiques que le salbutamol (faible absorption systémique)',
      'CI relative : allergie à l\'atropine ou dérivés',
      'Effet bronchodilatateur plus lent que le salbutamol — toujours associer au β2-agoniste dans le bronchospasme aigu, ne pas utiliser seul',
    ],
    pediatricBolus: DoseRange(min: 0.25, max: 0.25, unit: DoseUnit.unitsFixed, label: 'Nébulisation enfant (mg)'),
    pediatricNotes: 'Dose pédiatrique : 250 mcg/nébulisation, associé au salbutamol dans les protocoles d\'asthme aigu grave de l\'enfant.',
    indications: [
      'Bronchospasme aigu sévère, en association au salbutamol (effet synergique démontré)',
      'Exacerbation de BPCO (composante anticholinergique souvent marquée)',
      'Alternative/complément si la tachycardie limite la dose de salbutamol utilisable',
    ],
    mechanism: 'Antagoniste compétitif des récepteurs muscariniques M3 bronchiques → bronchodilatation par blocage du tonus vagal cholinergique',
    onset: '15 min',
    duration: '3–6h',
  ),

];
