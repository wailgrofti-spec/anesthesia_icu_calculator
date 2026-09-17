// lib/screens/ecran_doses_avec_pathologies.dart
// ─────────────────────────────────────────────────────────────────────────────
// Écran Doses MODIFIÉ — intègre les marqueurs de pathologie
//
// Modifications par rapport à l'original :
// 1) Les médicaments PRÉFÉRÉS affichent une étoile ★ dorée
// 2) Les médicaments CONTRE-INDIQUÉS affichent ⚠ rouge + fond rouge léger
// 3) Les ajustements de dose apparaissent dans un bandeau coloré
// 4) Un bandeau "Pathologies actives" affiché si sélections en cours
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/couleurs.dart';
import '../models/drug.dart';
import '../models/pathologie.dart';
import '../providers/fournisseur_app.dart';
import '../widgets/widgets_partages.dart';

class EcranDosesAvecPathologies extends StatefulWidget {
  const EcranDosesAvecPathologies({super.key});

  @override
  State<EcranDosesAvecPathologies> createState() => _EcranDosesAvecPathologiesState();
}

class _EcranDosesAvecPathologiesState extends State<EcranDosesAvecPathologies> {
  String _recherche = '';
  DrugCategory? _categorieFiltre;

  @override
  Widget build(BuildContext context) {
    return Consumer<FournisseurApp>(
      builder: (ctx, prov, _) {
        final pathologiesActives = prov.pathologiesSelectionnees;
        final prefereIds = prov.drugsPreferesIds;
        final contreindiqueIds = prov.drugsContreindiqueIds;

        // Filtrage des médicaments
        var drugs = prov.medicaments.where((d) {
          final matchRecherche = _recherche.isEmpty ||
              d.name.toLowerCase().contains(_recherche.toLowerCase()) ||
              d.genericName.toLowerCase().contains(_recherche.toLowerCase());
          final matchCategorie = _categorieFiltre == null || d.category == _categorieFiltre;
          return matchRecherche && matchCategorie;
        }).toList();

        // Trier : préférés en premier
        drugs.sort((a, b) {
          final aP = prefereIds.contains(a.id) ? 0 : (contreindiqueIds.contains(a.id) ? 2 : 1);
          final bP = prefereIds.contains(b.id) ? 0 : (contreindiqueIds.contains(b.id) ? 2 : 1);
          return aP.compareTo(bP);
        });

        // Grouper par catégorie
        final parCategorie = <DrugCategory, List<Drug>>{};
        for (final d in drugs) {
          parCategorie.putIfAbsent(d.category, () => []).add(d);
        }

        return Column(
          children: [
            // Barre recherche
            _BarreRecherche(
              onChanged: (v) => setState(() => _recherche = v),
            ),

            // Filtres catégories
            _FiltreCategoriesScroll(
              selectionne: _categorieFiltre,
              onSelectionner: (c) => setState(() => _categorieFiltre = c),
            ),

            // Bandeau pathologies actives
            if (pathologiesActives.isNotEmpty)
              _BandeauPathologiesActives(pathologies: pathologiesActives),

            // Bannière poids
            const BanniereAvertissement(),

            // Liste médicaments
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  ...parCategorie.entries.map((entry) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _EntêteSection(categorie: entry.key),
                          ...entry.value.map((drug) => _CarteDrugAvecPathologie(
                                drug: drug,
                                estPrefere: prefereIds.contains(drug.id),
                                estContrindique: contreindiqueIds.contains(drug.id),
                                ajustements: prov.getAjustementsPourDrug(drug.id),
                                poids: prov.poids,
                              )),
                        ],
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BANDEAU PATHOLOGIES ACTIVES
// ─────────────────────────────────────────────────────────────────────────────

class _BandeauPathologiesActives extends StatelessWidget {
  final List<Pathologie> pathologies;
  const _BandeauPathologiesActives({required this.pathologies});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CouleursMedicales.violet.withOpacity(0.15),
            CouleursMedicales.bleu.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CouleursMedicales.violet.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.medical_information_outlined,
              color: CouleursMedicales.violet, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 2,
              children: [
                const Text(
                  'Actif : ',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: CouleursMedicales.violet),
                ),
                ...pathologies.map(
                  (p) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: CouleursMedicales.violet.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      p.nom,
                      style: const TextStyle(
                          fontSize: 9, color: CouleursMedicales.violet),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CARTE DRUG AVEC MARQUEURS PATHOLOGIE
// ─────────────────────────────────────────────────────────────────────────────

class _CarteDrugAvecPathologie extends StatelessWidget {
  final Drug drug;
  final bool estPrefere;
  final bool estContrindique;
  final List<DoseAjustee> ajustements;
  final double? poids;

  const _CarteDrugAvecPathologie({
    required this.drug,
    required this.estPrefere,
    required this.estContrindique,
    required this.ajustements,
    this.poids,
  });

  Color get _bordureColor {
    if (estContrindique) return CouleursMedicales.rouge.withOpacity(0.5);
    if (estPrefere) return const Color(0xFFFFD700).withOpacity(0.5);
    return CouleursMedicales.bordure;
  }

  Color get _fondColor {
    if (estContrindique) return CouleursMedicales.rouge.withOpacity(0.05);
    if (estPrefere) return const Color(0xFFFFD700).withOpacity(0.04);
    return CouleursMedicales.fondSecondaire;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation vers le détail du médicament
        // Navigator.push(context, ...);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _fondColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _bordureColor, width: estPrefere || estContrindique ? 1.5 : 1),
        ),
        child: Column(
          children: [
            // Ligne principale
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Icône catégorie
                  _IconeCategorie(categorie: drug.category),
                  const SizedBox(width: 10),

                  // Nom + sous-catégorie + warning
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              drug.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: estContrindique
                                    ? CouleursMedicales.rouge
                                    : CouleursMedicales.textePrimaire,
                              ),
                            ),
                            if (estPrefere) ...[
                              const SizedBox(width: 5),
                              const Text(
                                '★',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFFFFD700)),
                              ),
                            ],
                            if (estContrindique) ...[
                              const SizedBox(width: 5),
                              const Icon(Icons.block,
                                  size: 14, color: CouleursMedicales.rouge),
                            ],
                          ],
                        ),
                        Text(
                          drug.subCategory,
                          style: const TextStyle(
                              fontSize: 10,
                              color: CouleursMedicales.texteMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          drug.shortWarning,
                          style: const TextStyle(
                            fontSize: 10,
                            color: CouleursMedicales.ambre,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Dose (calculée si poids disponible)
                  _BadgeDose(drug: drug, poids: poids),

                  const Icon(Icons.chevron_right,
                      color: CouleursMedicales.texteMuted, size: 16),
                ],
              ),
            ),

            // Bandeau ajustements pathologie
            if (ajustements.isNotEmpty)
              _BandeauAjustements(ajustements: ajustements, poids: poids),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BANDEAU AJUSTEMENTS DE DOSE
// ─────────────────────────────────────────────────────────────────────────────

class _BandeauAjustements extends StatelessWidget {
  final List<DoseAjustee> ajustements;
  final double? poids;

  const _BandeauAjustements({required this.ajustements, this.poids});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: CouleursMedicales.violet.withOpacity(0.08),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
        border: Border(
          top: BorderSide(color: CouleursMedicales.violet.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ajustements.map((aj) {
          Color couleur;
          if (aj.estContrIndique) couleur = CouleursMedicales.rouge;
          else if (aj.estPrefere) couleur = CouleursMedicales.vert;
          else couleur = CouleursMedicales.ambre;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      aj.estContrIndique
                          ? Icons.block
                          : aj.estPrefere
                              ? Icons.star
                              : Icons.warning_amber_rounded,
                      color: couleur,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        aj.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: couleur,
                        ),
                      ),
                    ),
                  ],
                ),
                if (aj.noteSpeciale != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 2),
                    child: Text(
                      aj.noteSpeciale!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: CouleursMedicales.texteSecondaire,
                        height: 1.3,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BADGE DOSE
// ─────────────────────────────────────────────────────────────────────────────

class _BadgeDose extends StatelessWidget {
  final Drug drug;
  final double? poids;

  const _BadgeDose({required this.drug, this.poids});

  String get _texte {
    if (poids != null && drug.bolus.min > 0) {
      final min = (drug.bolus.min * poids!).toStringAsFixed(0);
      final max = (drug.bolus.max * poids!).toStringAsFixed(0);
      return '$min–$max ${drug.bolus.unit.label}';
    }
    if (drug.bolus.min > 0) {
      return '${drug.bolus.min}–${drug.bolus.max} ${drug.bolus.unit.shortLabel}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (_texte.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: CouleursMedicales.bleu.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CouleursMedicales.bleu.withOpacity(0.3)),
      ),
      child: Text(
        _texte,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: CouleursMedicales.bleu,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ICÔNE CATÉGORIE
// ─────────────────────────────────────────────────────────────────────────────

class _IconeCategorie extends StatelessWidget {
  final DrugCategory categorie;
  const _IconeCategorie({required this.categorie});

  IconData get _icone {
    switch (categorie) {
      case DrugCategory.sedation:    return Icons.bedtime;
      case DrugCategory.analgesia:   return Icons.water_drop;
      case DrugCategory.nmb:         return Icons.hardware;
      case DrugCategory.vasoactive:  return Icons.favorite;
      case DrugCategory.antibiotic:  return Icons.science;
      case DrugCategory.fluid:       return Icons.opacity;
      case DrugCategory.other:       return Icons.medication;
    }
  }

  Color get _couleur {
    switch (categorie) {
      case DrugCategory.sedation:    return CouleursMedicales.bleu;
      case DrugCategory.analgesia:   return CouleursMedicales.violet;
      case DrugCategory.nmb:         return CouleursMedicales.ambre;
      case DrugCategory.vasoactive:  return CouleursMedicales.rouge;
      case DrugCategory.antibiotic:  return CouleursMedicales.vert;
      case DrugCategory.fluid:       return const Color(0xFF4FC3F7);
      case DrugCategory.other:       return CouleursMedicales.texteMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: _couleur.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(_icone, color: _couleur, size: 20),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  EN-TÊTE SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _EntêteSection extends StatelessWidget {
  final DrugCategory categorie;
  const _EntêteSection({required this.categorie});

  String get _label {
    switch (categorie) {
      case DrugCategory.sedation:    return 'SÉDATION / INDUCTION';
      case DrugCategory.analgesia:   return 'ANALGÉSIE';
      case DrugCategory.nmb:         return 'CURARES';
      case DrugCategory.vasoactive:  return 'VASOACTIFS';
      case DrugCategory.antibiotic:  return 'ANTIBIOTIQUES';
      case DrugCategory.fluid:       return 'REMPLISSAGE';
      case DrugCategory.other:       return 'AUTRES';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: CouleursMedicales.bleu,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: CouleursMedicales.texteMuted,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BARRE RECHERCHE
// ─────────────────────────────────────────────────────────────────────────────

class _BarreRecherche extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _BarreRecherche({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      decoration: BoxDecoration(
        color: CouleursMedicales.fondSecondaire,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CouleursMedicales.bordure),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: CouleursMedicales.textePrimaire),
        decoration: const InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: TextStyle(color: CouleursMedicales.texteMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: CouleursMedicales.texteMuted, size: 18),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILTRES CATÉGORIES
// ─────────────────────────────────────────────────────────────────────────────

class _FiltreCategoriesScroll extends StatelessWidget {
  final DrugCategory? selectionne;
  final ValueChanged<DrugCategory?> onSelectionner;

  const _FiltreCategoriesScroll({
    required this.selectionne,
    required this.onSelectionner,
  });

  static const _categories = [
    (null, 'Tous'),
    (DrugCategory.sedation, 'Hypnotiques'),
    (DrugCategory.analgesia, 'Opioïdes'),
    (DrugCategory.nmb, 'Curares'),
    (DrugCategory.vasoactive, 'Vasopresseurs'),
    (DrugCategory.antibiotic, 'Antibiotiques'),
    (DrugCategory.fluid, 'Remplissage'),
    (DrugCategory.other, 'Autre'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (ctx, i) {
          final (cat, label) = _categories[i];
          final sel = selectionne == cat;
          return GestureDetector(
            onTap: () => onSelectionner(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: sel ? CouleursMedicales.bleu : CouleursMedicales.fondSecondaire,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? CouleursMedicales.bleu : CouleursMedicales.bordure,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: sel ? Colors.white : CouleursMedicales.texteSecondaire,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
