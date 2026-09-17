// ===========================
//  lib/data/classic_drugs_data.dart
//  VERSION 4.1 — Registre dynamique piloté par les données
//  (architecture "data-driven catalogue" — écran Doses)
//
//  ──────────────────────────────────────────────────────────────────
//  COMMENT AJOUTER UNE NOUVELLE CLASSE THÉRAPEUTIQUE
//  ──────────────────────────────────────────────────────────────────
//  1. Créer un fichier lib/data/drugs/ma_nouvelle_classe_data.dart
//     qui exporte une `const List<Drug> maNouvelleClasseDrugs = [...]`.
//     Chaque Drug() doit préciser :
//       category: DrugCategory.other   (sauf cas technique particulier,
//                 voir note ci-dessous)
//       therapeuticClass: 'Nom Affiché De La Classe'
//  2. L'importer/exporter ci-dessous et l'ajouter à `_registeredDrugLists`.
//  3. C'est tout. L'écran Doses détecte automatiquement la nouvelle
//     classe et crée l'onglet correspondant.
//     - Si cette classe doit apparaître comme un onglet à part entière
//       dans la barre de catégories, aucune autre modification n'est
//       nécessaire.
//     - Si elle doit au contraire être regroupée dans le méta-onglet
//       "Autre" (voir lib/screens/drugs_screen.dart::kAutreTherapeuticClasses),
//       placer son fichier de données dans lib/data/autre/ et ajouter
//       son libellé (`therapeuticClass`) à la liste
//       `kAutreTherapeuticClasses` de l'écran Doses.
//
//  NOTE — DrugCategory vs therapeuticClass :
//  `DrugCategory` (enum dans models/drug.dart) est un type TECHNIQUE figé,
//  utilisé uniquement pour activer des profils spécialisés existants
//  (antibioticProfile, fluidProfile, opioidProfile, curareProfile) et le
//  calcul de la phase clinique. Il ne doit plus être étendu pour créer de
//  nouvelles catégories d'affichage — c'est le rôle de `therapeuticClass`.
//  Si votre nouvelle classe n'a pas de profil spécialisé dédié, utilisez
//  `category: DrugCategory.other` et laissez `therapeuticClass` faire
//  tout le travail de classement dans l'UI.
//
//  Fichiers historiques restés dans lib/data/drugs/ — onglets de premier
//  niveau dans la barre de catégories (non regroupés dans "Autre") :
//    • drugs/opioids_data.dart      → opioidDrugs      (Analgésie)
//    • drugs/hypnotics_data.dart    → hypnoticDrugs     (Sédation / Induction)
//    • drugs/curare_data.dart       → curareDrugs       (Curares)
//    • drugs/vasoactive_data.dart   → vasoactiveDrugs   (Vasopresseurs / Inotropes)
//    • drugs/antibiotics_data.dart  → antibioticDrugs   (Antibiotiques)
//    • drugs/fluids_data.dart       → fluidDrugs        (Remplissage)
//    • drugs/antivenoms_data.dart   → antivenomDrugs    (Sérums / Immunoglobulines)
//
//  Fichiers déplacés dans lib/data/autre/ — regroupés sous le méta-onglet
//  "Autre" de l'écran Doses (voir kAutreTherapeuticClasses dans
//  drugs_screen.dart). Chaque classe garde son propre fichier et son
//  propre therapeuticClass, seul son rattachement à un onglet de premier
//  niveau change :
//    • autre/anesthesiques_locaux.dart          → anesthesiquesLocauxDrugs     (Anesthésiques Locaux)
//    • autre/antidotes_reversion.dart           → antidotesReversionDrugs      (Antidotes / Réversion)
//    • autre/corticosteroides.dart              → corticosteroidDrugs          (Corticostéroïdes)
//    • autre/bronchodilatateurs.dart            → bronchodilatorDrugs          (Bronchodilatateurs)
//    • autre/insulines.dart                     → insulinDrugs                 (Insulines)
//    • autre/antihistaminiques.dart             → antihistamineDrugs           (Antihistaminiques)
//    • autre/antiviraux.dart                    → antiviralDrugs               (Antiviraux)
//    • autre/hematologie.dart                   → hematologyDrugs              (Hématologie)
//    • autre/antiparasitaires_antifongiques.dart→ antiparasiticDrugs           (Antiparasitaires / Antifongiques)
//    • autre/dermatologie_topique.dart          → dermatologyTopicalDrugs      (Dermatologie Topique)
//    • autre/ophtalmologie_locale.dart          → ophthalmologyDrugs           (Ophtalmologie Locale)
//    • autre/orl_local.dart                     → orlLocalDrugs                (ORL Local)
//    • autre/antipaludeens.dart                 → antimalarialDrugs            (Antipaludéens)
//    • autre/antibiotiques_specifiques.dart     → specificAntibioticDrugs      (Antibiotiques Spécifiques)
//    • autre/surfactant_pulmonaire.dart         → pulmonarySurfactantDrugs     (Surfactant Pulmonaire)
//    • autre/hormones_antidiabetiques_oraux.dart→ hormoneDrugs                 (Hormones / Antidiabétiques Oraux)
//    • autre/anti_infectieux_specifiques.dart   → antiinfectieuxSpecifiquesDrugs (Anti-infectieux Spécifiques)
//    • autre/divers_support.dart                → diversSupportifsDrugs        (Divers / Support)
//    • autre/divers_specialises.dart            → gynecoOsteoDigestifDrugs     (Divers Spécialisés)
//
//  `classicDrugs` reste disponible ici (agrégation de toutes les listes)
//  pour ne rien casser dans le reste de l'application : tout code qui
//  faisait déjà `import 'classic_drugs_data.dart'` et utilisait
//  `classicDrugs` continue de fonctionner sans modification. Le contenu
//  et le nombre total de médicaments sont strictement identiques à avant
//  ce déplacement — seul l'emplacement des fichiers source a changé.
//
//  SOURCES OFFICIELLES :
//  • FDA Drug Labels  — https://www.accessdata.fda.gov/scripts/cder/daf/
//  • EMA SmPC         — https://www.ema.europa.eu/en/medicines
//  • SFAR Guidelines  — https://sfar.org/recommandations/
//  • UpToDate 2024    — https://www.uptodate.com
//  • Miller's Anesthesia 9th Ed.
//  • Goodman & Gilman's Pharmacology 13th Ed.
//  • British National Formulary (BNF) — https://bnf.nice.org.uk
// ===========================

import '../models/drug.dart';

import 'drugs/opioids_data.dart';
import 'drugs/hypnotics_data.dart';
import 'drugs/curare_data.dart';
import 'drugs/vasoactive_data.dart';
import 'drugs/antibiotics_data.dart';
import 'drugs/fluids_data.dart';
import 'drugs/antivenoms_data.dart';

import 'autre/anesthesiques_locaux.dart';
import 'autre/antidotes_reversion.dart';
import 'autre/corticosteroides.dart';
import 'autre/bronchodilatateurs.dart';
import 'autre/insulines.dart';
import 'autre/antihistaminiques.dart';
import 'autre/antiviraux.dart';
import 'autre/hematologie.dart';
import 'autre/antiparasitaires_antifongiques.dart';
import 'autre/dermatologie_topique.dart';
import 'autre/ophtalmologie_locale.dart';
import 'autre/orl_local.dart';
import 'autre/antipaludeens.dart';
import 'autre/antibiotiques_specifiques.dart';
import 'autre/surfactant_pulmonaire.dart';
import 'autre/hormones_antidiabetiques_oraux.dart';
import 'autre/anti_infectieux_specifiques.dart';
import 'autre/divers_support.dart';
import 'autre/divers_specialises.dart';

export 'drugs/opioids_data.dart';
export 'drugs/hypnotics_data.dart';
export 'drugs/curare_data.dart';
export 'drugs/vasoactive_data.dart';
export 'drugs/antibiotics_data.dart';
export 'drugs/fluids_data.dart';
export 'drugs/antivenoms_data.dart';

export 'autre/anesthesiques_locaux.dart';
export 'autre/antidotes_reversion.dart';
export 'autre/corticosteroides.dart';
export 'autre/bronchodilatateurs.dart';
export 'autre/insulines.dart';
export 'autre/antihistaminiques.dart';
export 'autre/antiviraux.dart';
export 'autre/hematologie.dart';
export 'autre/antiparasitaires_antifongiques.dart';
export 'autre/dermatologie_topique.dart';
export 'autre/ophtalmologie_locale.dart';
export 'autre/orl_local.dart';
export 'autre/antipaludeens.dart';
export 'autre/antibiotiques_specifiques.dart';
export 'autre/surfactant_pulmonaire.dart';
export 'autre/hormones_antidiabetiques_oraux.dart';
export 'autre/anti_infectieux_specifiques.dart';
export 'autre/divers_support.dart';
export 'autre/divers_specialises.dart';

/// Applique un libellé d'affichage court à toute une liste de médicaments,
/// sans avoir à modifier chaque Drug() individuellement dans son fichier
/// source. Ne touche que l'étiquette affichée (therapeuticClass) ; toutes
/// les autres données du médicament sont conservées à l'identique.
List<Drug> _tagged(List<Drug> list, String label) =>
    [for (final d in list) d.copyWith(therapeuticClass: label)];

/// ── REGISTRE ────────────────────────────────────────────────────────
/// Unique endroit où toutes les listes de médicaments sont assemblées.
/// Ajouter une nouvelle classe = ajouter une ligne ici, rien d'autre.
///
/// Pour les 6 fichiers historiques sans therapeuticClass déclaré dans
/// leurs Drug(), on fixe ici un libellé d'affichage court et stable
/// (indépendant du texte de DrugCategory.label, qui peut être plus
/// long/technique). Toutes les autres listes déclarent déjà leur
/// therapeuticClass directement dans leurs Drug(), donc pas de tag
/// supplémentaire nécessaire ici.
final List<List<Drug>> _registeredDrugLists = [
  _tagged(hypnoticDrugs, 'Hypnotiques'),
  _tagged(opioidDrugs, 'Opioïdes'),
  _tagged(curareDrugs, 'Curares'),
  _tagged(vasoactiveDrugs, 'Vasopresseurs'),
  _tagged(antibioticDrugs, 'Antibiotiques'),
  _tagged(fluidDrugs, 'Remplissage'),
  antivenomDrugs,
  anesthesiquesLocauxDrugs,
  antidotesReversionDrugs,
  corticosteroidDrugs,
  bronchodilatorDrugs,
  insulinDrugs,
  antihistamineDrugs,
  antiviralDrugs,
  hematologyDrugs,
  antiparasiticDrugs,
  dermatologyTopicalDrugs,
  ophthalmologyDrugs,
  orlLocalDrugs,
  antimalarialDrugs,
  specificAntibioticDrugs,
  pulmonarySurfactantDrugs,
  hormoneDrugs,
  antiinfectieuxSpecifiquesDrugs,
  diversSupportifsDrugs,
  gynecoOsteoDigestifDrugs,
];

final List<Drug> classicDrugs = [
  for (final list in _registeredDrugLists) ...list,
];
