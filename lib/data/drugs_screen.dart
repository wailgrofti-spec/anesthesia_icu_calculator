// ---------------------------------------------------------------------------
//  lib/screens/drugs_screen.dart
//  MODIFIÉ v2 : affichage ⭐ / ⚠️ / ❌ selon pathologies sélectionnées
//               + ajustements de doses contextuels
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drug.dart';
import '../data/drug_database.dart';
import '../data/pathologies_data.dart';
import '../data/drug_pathology_rules.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import '../widgets/common.dart';

// ─── Palette locale ────────────────────────────────────────────────────────
class _DC {
  static const bg           = Color(0xFFF8FAFC);
  static const card         = Color(0xFFFFFFFF);
  static const cardBorder   = Color(0xFFE2E8F0);
  static const inputFill    = Color(0xFFF1F5F9);
  static const accent       = Color(0xFF1F7AE0);
  static const accentLight  = Color(0xFFEFF6FF);
  static const accentText   = Color(0xFF0F4C81);
  static const textPrimary  = Color(0xFF0F172A);
  static const textSecond   = Color(0xFF475569);
  static const textMuted    = Color(0xFF94A3B8);
  static const warnBg       = Color(0xFFFEF3C7);
  static const warnText     = Color(0xFFB45309);
  static const warnBorder   = Color(0xFFFCD34D);
  static const danger       = Color(0xFFEF4444);
  static const dangerBg     = Color(0xFFFEE2E2);
  static const dangerBorder = Color(0xFFFCA5A5);
  static const divider      = Color(0xFFE2E8F0);
  static const success      = Color(0xFF22C55E);
  static const successBg    = Color(0xFFDCFCE7);
  static const successBorder = Color(0xFF86EFAC);

  // dark
  static const darkBg     = Color(0xFF08111F);
  static const darkCard   = Color(0xFF0F172A);
  static const darkInput  = Color(0xFF1E293B);
  static const darkBorder = Color(0xFF334155);
  static const darkText   = Color(0xFFF8FAFC);
  static const darkSub    = Color(0xFF94A3B8);
}
// ──────────────────────────────────────────────────────────────────────────

const double _kHeaderH      = 128.0;
const double _kSearchH      = 38.0;
const double _kChipsH       = 38.0;
const String? _kAll         = null;

// ── Méta-catégorie "Autre" ──────────────────────────────────────────────
// Ces classes thérapeutiques ne sont plus affichées individuellement dans
// la barre de catégories : elles sont regroupées derrière un onglet
// unique "Autre". Pour ajouter/retirer une classe de ce regroupement, il
// suffit de modifier cette liste — aucune autre modification n'est
// nécessaire (le contenu de chaque classe reste piloté par les données,
// voir lib/data/autre/ et lib/data/classic_drugs_data.dart).
const String kAutreLabel = 'Autre';
const List<String> kAutreTherapeuticClasses = [
  'Anesthésiques Locaux',
  'Antidotes / Réversion',
  'Corticostéroïdes',
  'Bronchodilatateurs',
  'Insulines',
  'Antihistaminiques',
  'Antiviraux',
  'Hématologie',
  'Antiparasitaires / Antifongiques',
  'Dermatologie Topique',
  'Ophtalmologie Locale',
  'ORL Local',
  'Antipaludéens',
  'Antibiotiques Spécifiques',
  'Surfactant Pulmonaire',
  'Hormones / Antidiabétiques Oraux',
  'Anti-infectieux Spécifiques',
  'Divers / Support',
  'Divers Spécialisés',
];

class DrugsScreen extends StatefulWidget {
  const DrugsScreen({super.key});
  @override State<DrugsScreen> createState() => _DrugsScreenState();
}

class _DrugsScreenState extends State<DrugsScreen> {
  Drug?   _selected;
  String  _query      = '';
  // Classe thérapeutique active (String libre, plus d'enum figé).
  // null = onglet "Tous". Toute valeur possible est dérivée dynamiquement
  // de DrugDatabase.therapeuticClassesInDataOrder — jamais codée en dur.
  String? _activeClass = _kAll;
  final _search     = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _search.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<Drug> get _filtered {
    var list = DrugDatabase.drugs;
    if (_activeClass == kAutreLabel) {
      // Méta-catégorie : regroupe toutes les classes de kAutreTherapeuticClasses.
      list = list.where((d) => kAutreTherapeuticClasses.contains(d.displayClass)).toList();
    } else if (_activeClass != null) {
      list = list.where((d) => d.displayClass == _activeClass).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((d) =>
        d.name.toLowerCase().contains(q) ||
        d.genericName.toLowerCase().contains(q) ||
        d.subCategory.toLowerCase().contains(q) ||
        d.shortWarning.toLowerCase().contains(q) ||
        d.indications.any((i) => i.toLowerCase().contains(q))).toList();
    }
    return list;
  }

  /// Regroupe les médicaments par classe thérapeutique (String dynamique).
  /// L'ordre des groupes suit l'ordre d'apparition des classes dans les
  /// fichiers de données (lib/data/classic_drugs_data.dart) — une classe
  /// sans médicament n'apparaît simplement jamais dans la map.
  Map<String, List<Drug>> _groupByClass(List<Drug> list) {
    final order = DrugDatabase.therapeuticClassesInDataOrder;
    final map = <String, List<Drug>>{};
    for (final d in list) map.putIfAbsent(d.displayClass, () => []).add(d);
    return {for (final cls in order) if (map.containsKey(cls)) cls: map[cls]!};
  }

  /// Sous-classes de "Autre" réellement présentes dans les données,
  /// dans leur ordre d'apparition (data-driven : une classe sans
  /// médicament n'apparaît simplement jamais).
  List<String> get _autreSubClassesPresent => DrugDatabase
      .therapeuticClassesInDataOrder
      .where(kAutreTherapeuticClasses.contains)
      .toList();

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    // ── Résolution des règles pathologies actuelles ─────────────────────
    final selectedPathologyIds = provider.pathologiesSelectionnees
        .map((p) => p.id)
        .toList();
    final drugRules = provider.resolveRulesForPathologies(selectedPathologyIds);
    final hasPathologies = selectedPathologyIds.isNotEmpty;

    if (_selected != null) {
      return _DetailScreen(
        drug: _selected!,
        isDark: _isDark,
        drugRule: drugRules[_selected!.id],
        onBack: () => setState(() => _selected = null),
      );
    }

    final patient = provider.patient;
    final cardBg  = _isDark ? _DC.darkCard : _DC.card;
    final bgColor = _isDark ? _DC.darkBg   : _DC.bg;

    return Scaffold(
      backgroundColor: bgColor,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(children: [

          // ── Header fixe ───────────────────────────────────────────────
          Container(
            height: _kHeaderH,
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(
                bottom: BorderSide(
                  color: _isDark ? _DC.darkBorder : _DC.divider,
                  width: 1))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(children: [
                    Text('Doses',
                      style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600,
                        color: _isDark ? _DC.darkText : _DC.textPrimary,
                        letterSpacing: -0.2)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: _isDark ? _DC.darkInput : _DC.accentLight,
                        borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.medication_rounded,
                        color: _DC.accent, size: 17)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  child: _CompactSearchBar(
                    controller: _search, query: _query, isDark: _isDark,
                    onChanged: (v) => setState(() => _query = v),
                    onClear: () { _search.clear(); setState(() => _query = ''); },
                  ),
                ),
                SizedBox(
                  height: _kChipsH,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    children: [
                      _CategoryChip(label: 'Tous', active: _activeClass == null,
                        isDark: _isDark, onTap: () => setState(() => _activeClass = null)),
                      // Onglets générés automatiquement à partir des classes
                      // thérapeutiques réellement présentes dans la base —
                      // aucune catégorie codée en dur. Une nouvelle classe
                      // ajoutée dans lib/data/drugs/ apparaît ici sans
                      // modification de ce fichier. Les classes listées dans
                      // kAutreTherapeuticClasses n'apparaissent plus comme
                      // onglets individuels : elles sont regroupées derrière
                      // le chip unique "Autre" ci-dessous.
                      ...DrugDatabase.therapeuticClassesInDataOrder
                        .where((cls) => !kAutreTherapeuticClasses.contains(cls))
                        .map((cls) => _CategoryChip(
                          label: cls, active: _activeClass == cls,
                          isDark: _isDark,
                          onTap: () => setState(() => _activeClass = cls))),
                      // Chip unique "Autre" — reste actif visuellement tant
                      // que l'utilisateur navigue dans l'index "Autre" ou
                      // dans l'un de ses sous-groupes.
                      if (_autreSubClassesPresent.isNotEmpty)
                        _CategoryChip(
                          label: kAutreLabel,
                          active: _activeClass == kAutreLabel ||
                            kAutreTherapeuticClasses.contains(_activeClass),
                          isDark: _isDark,
                          onTap: () => setState(() => _activeClass = kAutreLabel)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Bannière pathologies sélectionnées ────────────────────────
          if (hasPathologies)
            _PathologyBanner(
              selectedIds: selectedPathologyIds,
              isDark: _isDark,
            ),

          // ── Bannière poids manquant ───────────────────────────────────
          if (!patient.isComplete)
            _InfoBanner(isDark: _isDark),

          // ── Liste médicaments ─────────────────────────────────────────
          Expanded(child: _buildDrugList(patient, drugRules, hasPathologies)),
        ]),
      ),
    );
  }

  Widget _buildDrugList(
    dynamic patient,
    Map<String, DrugPathologyRule> drugRules,
    bool hasPathologies,
  ) {
    // Onglet "Autre" sans recherche en cours : afficher l'index des
    // sous-groupes plutôt que la liste à plat des médicaments. Dès qu'une
    // recherche est saisie, on repasse en liste filtrée classique (via
    // _filtered, qui sait déjà interpréter kAutreLabel comme un ensemble
    // de classes) pour ne pas perdre la fonction recherche.
    if (_activeClass == kAutreLabel && _query.isEmpty) {
      return _buildAutreIndex();
    }

    final drugs = _filtered;

    if (drugs.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: _isDark ? _DC.darkInput : _DC.inputFill,
              shape: BoxShape.circle),
            child: const Icon(Icons.search_off_rounded, size: 22, color: _DC.accent)),
          const SizedBox(height: 12),
          Text(
            _query.isNotEmpty
              ? 'Aucun résultat pour "$_query"'
              : 'Aucun médicament dans cette catégorie',
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500,
              color: _isDark ? _DC.darkSub : _DC.textSecond)),
        ],
      ));
    }

    final grouped = _groupByClass(drugs);
    final weight  = patient.weight;

    return ListView(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 100),
      children: grouped.entries.map((entry) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 7),
            child: _DrugSectionTitle(entry.key, isDark: _isDark),
          ),
          ...entry.value.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: _DrugCard(
              drug: d,
              weight: weight,
              isDark: _isDark,
              pathologyRule: hasPathologies ? drugRules[d.id] : null,
              onTap: () => setState(() => _selected = d),
            ),
          )),
        ]);
      }).toList(),
    );
  }

  /// Index des sous-groupes de la méta-catégorie "Autre". Chaque ligne se
  /// comporte exactement comme un chip de catégorie classique : elle
  /// bascule `_activeClass` sur la classe thérapeutique correspondante,
  /// ce qui réutilise telle quelle la liste/le regroupement existants.
  Widget _buildAutreIndex() {
    final subClasses = _autreSubClassesPresent;
    return ListView(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 100),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 7),
          child: _DrugSectionTitle(kAutreLabel, isDark: _isDark),
        ),
        ...subClasses.map((cls) => Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: _AutreGroupTile(
            label: cls,
            count: DrugDatabase.getDrugsByTherapeuticClass(cls).length,
            isDark: _isDark,
            onTap: () => setState(() => _activeClass = cls),
          ),
        )),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  BANNIÈRE — pathologies actives
// ════════════════════════════════════════════════════════════════════════════
class _PathologyBanner extends StatelessWidget {
  final List<String> selectedIds;
  final bool isDark;
  const _PathologyBanner({required this.selectedIds, required this.isDark});

  // mapping id → label court pour affichage
  static const _labels = {
    'hic': 'HIC', 'epilepsie': 'Épilepsie',
    'insuffisance_hepatique': 'Insuff. Hépatique',
    'insuffisance_renale': 'Insuff. Rénale',
    'insuffisance_cardiaque': 'Insuff. Cardiaque',
    'choc_hemorragique': 'Choc Hémorragique',
    'bpco': 'BPCO', 'asthme_bronchospasme': 'Asthme',
    'diabete': 'Diabète', 'hyperkaliemie': 'Hyperkaliémie',
    'porphyrie': 'Porphyrie', 'grossesse': 'Grossesse',
    'allergie_penicilline': 'Allergie Péni.',
    'allergie_oeuf_soja': 'Allergie Œuf/Soja',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1E29) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFBFDBFE))),
      child: Row(children: [
        const Icon(Icons.medical_services_outlined,
          size: 14, color: Color(0xFF1F7AE0)),
        const SizedBox(width: 8),
        Expanded(child: Wrap(
          spacing: 4, runSpacing: 3,
          children: selectedIds.map((id) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1F7AE0).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1F7AE0).withOpacity(0.3))),
            child: Text(
              _labels[id] ?? id,
              style: const TextStyle(
                fontSize: 9.5, fontWeight: FontWeight.w700,
                color: Color(0xFF1F7AE0))),
          )).toList(),
        )),
        const SizedBox(width: 6),
        const Text('Doses ajustées',
          style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w600,
            color: Color(0xFF1F7AE0))),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  CHIP CATÉGORIE
// ════════════════════════════════════════════════════════════════════════════
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active, isDark;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.active,
    required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = active ? _DC.accent : (isDark ? _DC.darkInput : _DC.inputFill);
    final fg = active ? Colors.white : (isDark ? _DC.darkSub : _DC.textSecond);
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(20)),
          child: Text(label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: fg)),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  SEARCH BAR
// ════════════════════════════════════════════════════════════════════════════
class _CompactSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _CompactSearchBar({required this.controller, required this.query,
    required this.isDark, required this.onChanged, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kSearchH,
      decoration: BoxDecoration(
        color: isDark ? _DC.darkInput : _DC.inputFill,
        borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller, onChanged: onChanged,
        style: TextStyle(fontSize: 13.5, color: isDark ? _DC.darkText : _DC.textPrimary),
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: TextStyle(color: isDark ? _DC.darkSub : _DC.textMuted, fontSize: 13.5),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search_rounded,
              color: isDark ? _DC.darkSub : _DC.textSecond, size: 18)),
          prefixIconConstraints: const BoxConstraints(minWidth: 38),
          suffixIcon: query.isNotEmpty
            ? GestureDetector(
                onTap: onClear,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.close_rounded,
                    color: isDark ? _DC.darkSub : _DC.textSecond, size: 16)))
            : null,
          border: InputBorder.none, enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
          isDense: true,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  INFO BANNER (poids manquant)
// ════════════════════════════════════════════════════════════════════════════
class _InfoBanner extends StatelessWidget {
  final bool isDark;
  const _InfoBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1A0D) : _DC.warnBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF3A2F0A) : _DC.warnBorder, width: 1)),
      child: Row(children: [
        Icon(Icons.info_outline_rounded, size: 14,
          color: isDark ? const Color(0xFFD4A853) : _DC.warnText),
        const SizedBox(width: 8),
        Expanded(child: Text(
          'Entrez le poids du patient pour des calculs précis',
          style: TextStyle(fontSize: 12,
            color: isDark ? const Color(0xFFD4A853) : _DC.warnText,
            fontWeight: FontWeight.w500))),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  TITRE DE SECTION
// ════════════════════════════════════════════════════════════════════════════
class _DrugSectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  const _DrugSectionTitle(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 2.5, height: 14,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: _DC.accent, borderRadius: BorderRadius.circular(2))),
      Text(text.toUpperCase(),
        style: TextStyle(
          fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.8,
          color: isDark ? _DC.darkSub : _DC.textSecond)),
    ]);
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  LIGNE SOUS-GROUPE — index de la méta-catégorie "Autre"
// ════════════════════════════════════════════════════════════════════════════
class _AutreGroupTile extends StatelessWidget {
  final String label;
  final int count;
  final bool isDark;
  final VoidCallback onTap;
  const _AutreGroupTile({
    required this.label, required this.count,
    required this.isDark, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg     = isDark ? _DC.darkCard   : _DC.card;
    final cardBorder = isDark ? _DC.darkBorder : _DC.cardBorder;
    final iconBg     = isDark ? _DC.darkInput  : _DC.accentLight;
    final txtM       = isDark ? _DC.darkText   : _DC.textPrimary;
    final txtS       = isDark ? _DC.darkSub    : _DC.textSecond;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        splashColor: _DC.accentLight.withOpacity(0.5),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: cardBorder, width: 1.2)),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(9)),
              child: Icon(_DrugCard._classIcons[label] ?? _DrugCard._defaultIcon,
                size: 18, color: _DC.accent)),
            const SizedBox(width: 11),
            Expanded(child: Text(label,
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: txtM))),
            Text('$count',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: txtS)),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, size: 18,
              color: isDark ? _DC.darkBorder : _DC.cardBorder),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  DRUG CARD — avec badge pathologie ⭐ / ⚠️ / ❌
// ════════════════════════════════════════════════════════════════════════════
class _DrugCard extends StatelessWidget {
  final Drug drug;
  final double? weight;
  final bool isDark;
  final DrugPathologyRule? pathologyRule;
  final VoidCallback onTap;

  const _DrugCard({
    required this.drug, required this.weight, required this.isDark,
    required this.onTap, this.pathologyRule,
  });

  // Icônes optionnelles par classe thérapeutique. Cette table est purement
  // cosmétique : une classe absente de cette map obtient automatiquement
  // l'icône générique par défaut ci-dessous — donc une nouvelle classe
  // ajoutée dans lib/data/drugs/ s'affiche correctement sans qu'il soit
  // nécessaire de modifier ce fichier. On peut éventuellement lui ajouter
  // une entrée ici plus tard pour un rendu plus spécifique, mais ce n'est
  // jamais obligatoire.
  static const Map<String, IconData> _classIcons = {
    'Hypnotiques':          Icons.bedtime_rounded,
    'Opioïdes':             Icons.spa_rounded,
    'Curares':              Icons.electric_bolt_rounded,
    'Vasopresseurs':        Icons.favorite_rounded,
    'Antibiotiques':        Icons.coronavirus_outlined,
    'Remplissage':          Icons.water_drop_outlined,
    'Anesthésiques Locaux': Icons.colorize_rounded,
    'Antidotes / Réversion': Icons.health_and_safety_rounded,
    'Corticostéroïdes':     Icons.shield_rounded,
    'Bronchodilatateurs':   Icons.air_rounded,
    'Insulines':            Icons.bloodtype_rounded,
    'Antihistaminiques':    Icons.sanitizer_rounded,
  };
  static const IconData _defaultIcon = Icons.medication_liquid_rounded;

  IconData get _icon => _classIcons[drug.displayClass] ?? _defaultIcon;

  bool get _isContraindicated =>
      pathologyRule?.status == DrugPathologyStatus.contraindicated;

  bool get _isPreferred =>
      pathologyRule?.status == DrugPathologyStatus.preferred;

  bool get _isCaution =>
      pathologyRule?.status == DrugPathologyStatus.caution;

  String? _computedBolusDose() {
    final w = weight ?? 70.0;
    final d = drug;
    if (d.bolus.max <= 0 || d.bolus.unit == DoseUnit.unitsFixed) return null;
    final mn = d.bolus.calcMin(w);
    final mx = d.bolus.calcMax(w);
    final unit = d.bolus.resultUnit();
    if (mn == mx || mx == 0) return '${mn.toStringAsFixed(0)} $unit';
    return '${mn.toStringAsFixed(0)}–${mx.toStringAsFixed(0)} $unit';
  }

  @override
  Widget build(BuildContext context) {
    // ── Couleurs selon statut pathologie ──────────────────────────────
    Color cardBorderColor;
    Color cardBgColor;
    if (_isContraindicated) {
      cardBorderColor = _DC.danger.withOpacity(0.35);
      cardBgColor     = isDark ? const Color(0xFF1A0E0E) : _DC.dangerBg;
    } else if (_isPreferred) {
      cardBorderColor = _DC.success.withOpacity(0.35);
      cardBgColor     = isDark ? const Color(0xFF0D1F12) : _DC.successBg;
    } else if (_isCaution) {
      cardBorderColor = _DC.warnBorder.withOpacity(0.7);
      cardBgColor     = isDark ? const Color(0xFF1F1A0D) : _DC.warnBg;
    } else {
      cardBorderColor = isDark ? _DC.darkBorder : _DC.cardBorder;
      cardBgColor     = isDark ? _DC.darkCard : _DC.card;
    }

    final iconBg = _isContraindicated
        ? (isDark ? const Color(0xFF2A1515) : _DC.dangerBg)
        : _isPreferred
            ? (isDark ? const Color(0xFF0D2218) : _DC.successBg)
            : (isDark ? _DC.darkInput : _DC.accentLight);
    final iconColor = _isContraindicated
        ? _DC.danger
        : _isPreferred
            ? _DC.success
            : _DC.accent;

    final txtM  = isDark ? _DC.darkText : _DC.textPrimary;
    final txtS  = isDark ? _DC.darkSub  : _DC.textSecond;
    final warnC = isDark ? const Color(0xFFD4A853) : _DC.warnText;

    final doseLabel = _computedBolusDose();
    final hasWeight = weight != null;

    return Material(
      color: cardBgColor,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        splashColor: _DC.accentLight.withOpacity(0.5),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: cardBorderColor, width: 1.2)),
          child: Column(children: [
            Row(children: [

              // Icône catégorie (avec badge statut)
              Stack(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(9)),
                  child: Icon(_icon, size: 18, color: iconColor),
                ),
                if (pathologyRule != null)
                  Positioned(
                    top: -2, right: -2,
                    child: _StatusBadgeIcon(pathologyRule!.status),
                  ),
              ]),

              const SizedBox(width: 11),

              // Nom + info
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(drug.name,
                      style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: _isContraindicated ? _DC.danger : txtM))),
                    if (drug.requiresCentralLine)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _DC.dangerBg, borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: _DC.danger.withOpacity(0.25))),
                        child: const Text('VVC',
                          style: TextStyle(fontSize: 9, color: _DC.danger,
                            fontWeight: FontWeight.w700))),
                  ]),
                  const SizedBox(height: 2),
                  Text(drug.subCategory,
                    style: TextStyle(fontSize: 11.5, color: txtS)),
                  const SizedBox(height: 3),

                  // Affiche le motif pathologie si applicable, sinon l'alerte standard
                  if (pathologyRule != null)
                    Text(pathologyRule!.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _isContraindicated
                            ? _DC.danger
                            : _isPreferred
                                ? _DC.success
                                : warnC))
                  else
                    Text(drug.shortWarning,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11, color: warnC,
                        fontWeight: FontWeight.w400)),
                ],
              )),

              const SizedBox(width: 8),

              // Dose + flèche
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (doseLabel != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _isContraindicated
                            ? _DC.dangerBg
                            : hasWeight
                                ? (isDark ? _DC.darkInput : _DC.accentLight)
                                : (isDark ? const Color(0xFF1F1A0D) : _DC.warnBg),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _isContraindicated
                              ? _DC.dangerBorder
                              : hasWeight
                                  ? (isDark ? _DC.darkBorder : const Color(0xFFBFD5FF))
                                  : (isDark ? const Color(0xFF3A2F0A) : _DC.warnBorder),
                          width: 0.8)),
                      child: Text(doseLabel,
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: _isContraindicated
                              ? _DC.danger
                              : hasWeight
                                  ? _DC.accent
                                  : (isDark ? const Color(0xFFD4A853) : _DC.warnText)))),
                    const SizedBox(height: 4),
                  ],
                  Icon(Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? _DC.darkBorder : _DC.cardBorder),
                ],
              ),
            ]),

            // ── Bandeau contre-indication (sous la ligne principale) ──
            if (_isContraindicated) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _DC.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: _DC.danger.withOpacity(0.25))),
                child: Row(children: [
                  const Icon(Icons.block_rounded, size: 12, color: _DC.danger),
                  const SizedBox(width: 6),
                  Expanded(child: Text(
                    'Contre-indiqué pour ce patient',
                    style: const TextStyle(
                      fontSize: 10.5, color: _DC.danger,
                      fontWeight: FontWeight.w700))),
                ]),
              ),
            ],

            // ── Bandeau ajustement de dose (prudence ou préféré) ──────
            if ((pathologyRule?.doseAdjustment != null) &&
                !_isContraindicated) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _isCaution
                      ? _DC.warnBg
                      : _DC.successBg,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: _isCaution
                        ? _DC.warnBorder.withOpacity(0.5)
                        : _DC.successBorder.withOpacity(0.5))),
                child: Row(children: [
                  Icon(
                    _isCaution
                        ? Icons.tune_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 12,
                    color: _isCaution ? _DC.warnText : _DC.success),
                  const SizedBox(width: 6),
                  Expanded(child: Text(
                    pathologyRule!.doseAdjustment!,
                    style: TextStyle(
                      fontSize: 10.5, fontWeight: FontWeight.w600,
                      color: _isCaution ? _DC.warnText : _DC.success))),
                ]),
              ),
            ],

            // ── Indicateur "Ajusté" ───────────────────────────────────
            if (pathologyRule != null && !_isContraindicated) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('Ajusté',
                    style: TextStyle(
                      fontSize: 9.5, fontWeight: FontWeight.w600,
                      color: _isPreferred ? _DC.success : _DC.warnText)),
                  const SizedBox(width: 2),
                  Icon(
                    _isPreferred
                        ? Icons.check_rounded
                        : Icons.warning_amber_rounded,
                    size: 10,
                    color: _isPreferred ? _DC.success : _DC.warnText),
                ]),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  BADGE ICÔNE (⭐ / ⚠️ / ❌)
// ════════════════════════════════════════════════════════════════════════════
class _StatusBadgeIcon extends StatelessWidget {
  final DrugPathologyStatus status;
  const _StatusBadgeIcon(this.status);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case DrugPathologyStatus.preferred:
        return const Icon(Icons.star_rounded, size: 14, color: Color(0xFFEAB308));
      case DrugPathologyStatus.contraindicated:
        return Container(
          width: 14, height: 14,
          decoration: const BoxDecoration(
            color: _DC.danger, shape: BoxShape.circle),
          child: const Icon(Icons.close_rounded, size: 10, color: Colors.white));
      case DrugPathologyStatus.caution:
        return const Icon(Icons.warning_amber_rounded,
          size: 14, color: Color(0xFFD97706));
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  ÉCRAN DÉTAIL — avec section pathologie en haut
// ════════════════════════════════════════════════════════════════════════════
class _DetailScreen extends StatefulWidget {
  final Drug drug;
  final bool isDark;
  final DrugPathologyRule? drugRule;
  final VoidCallback onBack;
  const _DetailScreen({
    required this.drug, required this.isDark,
    required this.onBack, this.drugRule,
  });
  @override State<_DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<_DetailScreen> {
  bool _showMlH = false;

  bool  get _isDark => widget.isDark;
  Color get _bg     => _isDark ? _DC.darkBg   : _DC.bg;
  Color get _cardBg => _isDark ? _DC.darkCard  : _DC.card;
  Color get _txtM   => _isDark ? _DC.darkText  : _DC.textPrimary;
  Color get _txtS   => _isDark ? _DC.darkSub   : _DC.textSecond;

  bool get _isContraindicated =>
      widget.drugRule?.status == DrugPathologyStatus.contraindicated;
  bool get _isPreferred =>
      widget.drugRule?.status == DrugPathologyStatus.preferred;
  bool get _isCaution =>
      widget.drugRule?.status == DrugPathologyStatus.caution;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final patient = provider.patient;
    final isPediatric = provider.isPediatricMode;
    final w    = patient.weight ?? 70.0;
    final hasW = patient.weight != null;
    final d    = widget.drug;
    final rule = widget.drugRule;

    // Calcul doses — avec facteur d'ajustement si applicable
    double doseFactor = 1.0;
    if (rule?.doseAdjustment != null) {
      // Extraire le facteur depuis le texte (ex: "Réduire de 30–50 %" → 0.65 moyen)
      // Pour la v1, on garde les doses standard et on affiche l'avertissement
      doseFactor = 1.0; // calcul exact possible dans une v2
    }

    final bolusToUse = (isPediatric && d.pediatricBolus != null) ? d.pediatricBolus! : d.bolus;
    final infusionToUse = (isPediatric && d.pediatricInfusion != null) ? d.pediatricInfusion! : d.infusion;

    final bMin = bolusToUse.calcMin(w);
    final bMax = bolusToUse.calcMax(w);
    final iMin = infusionToUse.calcMin(w);
    final iMax = infusionToUse.calcMax(w);

    final conc  = d.standardConcentrationMgPerMl;
    final mlMin = (conc != null && conc > 0) ? infusionToUse.mlPerHourMin(w, conc) : null;
    final mlMax = (conc != null && conc > 0) ? infusionToUse.mlPerHourMax(w, conc) : null;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(child: Column(children: [

        // ── Header détail ────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
          decoration: BoxDecoration(
            color: _cardBg,
            border: Border(
              bottom: BorderSide(
                color: _isDark ? _DC.darkBorder : _DC.divider, width: 1))),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 17, color: _isDark ? _DC.darkText : _DC.textPrimary),
              onPressed: widget.onBack,
              padding: const EdgeInsets.all(8)),
            const SizedBox(width: 2),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(d.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: _txtM))),
                  if (rule != null)
                    _StatusChipDetail(rule.status),
                ],
              ),
              Text(d.genericName,
                style: const TextStyle(fontSize: 12, color: _DC.accent)),
              ],
            )),
            if (d.requiresCentralLine)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _DC.dangerBg, borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _DC.danger.withOpacity(0.25))),
                child: const Text('VVC Requise',
                  style: TextStyle(fontSize: 10.5, color: _DC.danger,
                    fontWeight: FontWeight.w700))),
          ]),
        ),

        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Mécanisme / délai / catégorie ──────────────────────────
              Wrap(spacing: 6, runSpacing: 6, children: [
                _Chip(d.mechanism,
                  bg: _isDark ? _DC.darkInput : _DC.accentLight,
                  fg: _DC.accent),
                _Chip('Délai : ${d.onset}',
                  bg: _isDark ? const Color(0xFF0D2218) : const Color(0xFFE8F8F1),
                  fg: const Color(0xFF15803D)),
                _Chip(d.subCategory,
                  bg: _isDark ? const Color(0xFF1F1A0D) : _DC.warnBg,
                  fg: _isDark ? const Color(0xFFD4A853) : _DC.warnText),
              ]),

              // ── Encadré alerte pathologie ────────────────────────────
              if (rule != null) ...[
                const SizedBox(height: 12),
                _PathologyRuleCard(rule: rule, isDark: _isDark),
              ],

              // ── Notes Pédiatriques ────────────────────────────────
              if (isPediatric && d.pediatricNotes != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _isDark ? const Color(0xFF00363A) : const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF00BCD4), width: 1)),
                  child: Row(children: [
                    const Icon(Icons.child_care_rounded, size: 16, color: Color(0xFF00ACC1)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(d.pediatricNotes!,
                      style: TextStyle(
                        fontSize: 12, color: _isDark ? const Color(0xFFB2EBF2) : const Color(0xFF00838F),
                        fontWeight: FontWeight.w600))),
                  ]),
                ),
              ],

              if (!hasW) ...[
                const SizedBox(height: 10),
                _InfoBanner(isDark: _isDark),
              ],

              const SizedBox(height: 18),
              _DetailSectionTitle('Doses Calculées', isDark: _isDark),
              const SizedBox(height: 8),

              if (_isContraindicated)
                _ContraIndicatedDoseCard(isDark: _isDark)
              else ...[
                if (bolusToUse.max > 0 && bolusToUse.unit != DoseUnit.unitsFixed)
                  _DoseCard(
                    label: '${bolusToUse.label} (Bolus)',
                    amount: '${bMin.toStringAsFixed(1)} – ${bMax.toStringAsFixed(1)}',
                    unit: bolusToUse.resultUnit(),
                    subtitle: '${bolusToUse.min}–${bolusToUse.max} ${bolusToUse.unitString} × ${w.toStringAsFixed(1)} kg',
                    isCaution: !hasW || _isCaution,
                    isDark: _isDark,
                  ),

                if (infusionToUse.max > 0 && infusionToUse.unit != DoseUnit.unitsFixed) ...[
                  const SizedBox(height: 8),
                  _DoseCard(
                    label: '${infusionToUse.label} (Entretien)',
                    amount: '${iMin.toStringAsFixed(2)} – ${iMax.toStringAsFixed(2)}',
                    unit: '${infusionToUse.resultUnit()}/h',
                    subtitle: '${infusionToUse.min}–${infusionToUse.max} ${infusionToUse.unitString}',
                    isCaution: !hasW || _isCaution,
                    isDark: _isDark,
                  ),
                ],

                if (infusionToUse.unit == DoseUnit.unitsFixed) ...[
                  const SizedBox(height: 8),
                  _DoseCard(
                    label: 'Débit de Perfusion',
                    amount: '0.03–0.04',
                    unit: 'unités/min',
                    subtitle: 'Dose fixe — NE PAS titrer au-delà de 0.04 unités/min',
                    isCaution: true, isDark: _isDark),
                ],

                if (mlMin != null && mlMax != null) ...[
                  const SizedBox(height: 8),
                  _MlHCard(
                    conc: conc!, mlMin: mlMin, mlMax: mlMax,
                    preparation: d.preparation,
                    compatSG5: d.compatibiliteSG5,
                    compatNaCl: d.compatibiliteNaCl09,
                    expanded: _showMlH, isDark: _isDark,
                    onToggle: () => setState(() => _showMlH = !_showMlH)),
                ],

                // ── Encadré ajustement dose ──────────────────────────
                if (rule?.doseAdjustment != null) ...[
                  const SizedBox(height: 8),
                  _DoseAdjustmentCard(
                    text: rule!.doseAdjustment!, isDark: _isDark),
                ],
              ],

              const SizedBox(height: 18),
              _DetailSectionTitle('Administration', isDark: _isDark),
              const SizedBox(height: 8),
              _InfoCard(isDark: _isDark, children: [
                _DetailRow('Méthode Bolus', d.bolusMethod, isDark: _isDark),
                _divider(_isDark),
                _DetailRow('Vitesse Entretien', d.infusionRate, isDark: _isDark),
                _divider(_isDark),
                _DetailRow('Préparation', d.preparation,
                  isDark: _isDark, isLast: true),
              ]),

              const SizedBox(height: 18),
              _DetailSectionTitle('Indications', isDark: _isDark),
              const SizedBox(height: 8),
              _InfoCard(isDark: _isDark, children: [
                ...d.indications.asMap().entries.map((e) => Padding(
                  padding: EdgeInsets.only(bottom: e.key < d.indications.length - 1 ? 8 : 0),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 5, height: 5,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: const BoxDecoration(
                        color: _DC.accent, shape: BoxShape.circle)),
                    const SizedBox(width: 9),
                    Expanded(child: Text(e.value,
                      style: TextStyle(fontSize: 13, height: 1.5,
                        color: _isDark ? _DC.darkText : _DC.textPrimary))),
                  ]),
                )),
              ]),

              const SizedBox(height: 18),
              _DetailSectionTitle('Avertissements Cliniques', isDark: _isDark),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: _isDark ? const Color(0xFF1A0E0E) : _DC.dangerBg,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: _isDark ? _DC.danger.withOpacity(0.2) : _DC.dangerBorder,
                    width: 1)),
                child: Column(children: [
                  ...d.warnings.asMap().entries.map((e) => Padding(
                    padding: EdgeInsets.only(bottom: e.key < d.warnings.length - 1 ? 9 : 0),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.warning_amber_rounded,
                          size: 13, color: _DC.danger)),
                      const SizedBox(width: 9),
                      Expanded(child: Text(e.value,
                        style: const TextStyle(
                          fontSize: 12.5, color: _DC.danger, height: 1.4))),
                    ]),
                  )),
                ]),
              ),

              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: _isDark ? _DC.darkInput : _DC.inputFill,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: _isDark ? _DC.darkBorder : _DC.divider)),
                child: Row(children: [
                  Icon(Icons.info_outline_rounded, size: 13,
                    color: _isDark ? _DC.darkSub : _DC.textSecond),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'Usage éducatif uniquement. Toujours vérifier avec les protocoles locaux.',
                    style: TextStyle(fontSize: 11, height: 1.4,
                      color: _isDark ? _DC.darkSub : _DC.textSecond))),
                ]),
              ),
            ],
          ),
        )),
      ])),
    );
  }
}

// ── Carte encadré règle pathologie ─────────────────────────────────────────
class _PathologyRuleCard extends StatelessWidget {
  final DrugPathologyRule rule;
  final bool isDark;
  const _PathologyRuleCard({required this.rule, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color bg, border, txtColor;
    IconData icon;

    switch (rule.status) {
      case DrugPathologyStatus.preferred:
        bg = isDark ? const Color(0xFF0D2218) : _DC.successBg;
        border = _DC.successBorder;
        txtColor = _DC.success;
        icon = Icons.star_rounded;
        break;
      case DrugPathologyStatus.contraindicated:
        bg = isDark ? const Color(0xFF1A0E0E) : _DC.dangerBg;
        border = _DC.dangerBorder;
        txtColor = _DC.danger;
        icon = Icons.block_rounded;
        break;
      case DrugPathologyStatus.caution:
        bg = isDark ? const Color(0xFF1F1A0D) : _DC.warnBg;
        border = _DC.warnBorder;
        txtColor = _DC.warnText;
        icon = Icons.warning_amber_rounded;
        break;
    }

    final title = rule.status == DrugPathologyStatus.preferred
        ? 'Recommandé pour vos pathologies'
        : rule.status == DrugPathologyStatus.contraindicated
            ? 'Contre-indiqué pour ce patient'
            : 'Utiliser avec précaution';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 14, color: txtColor),
          const SizedBox(width: 6),
          Text(title,
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: txtColor)),
        ]),
        const SizedBox(height: 6),
        Text(rule.reason,
          style: TextStyle(fontSize: 12, color: txtColor, height: 1.4)),
        if (rule.doseAdjustment != null) ...[
          const SizedBox(height: 6),
          Row(children: [
            Icon(Icons.tune_rounded, size: 12, color: txtColor),
            const SizedBox(width: 5),
            Expanded(child: Text(rule.doseAdjustment!,
              style: TextStyle(
                fontSize: 11.5, fontWeight: FontWeight.w600,
                color: txtColor))),
          ]),
        ],
      ]),
    );
  }
}

// ── Carte "Contre-indiqué — doses masquées" ────────────────────────────────
class _ContraIndicatedDoseCard extends StatelessWidget {
  final bool isDark;
  const _ContraIndicatedDoseCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A0E0E) : _DC.dangerBg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _DC.dangerBorder)),
      child: Row(children: [
        const Icon(Icons.block_rounded, size: 22, color: _DC.danger),
        const SizedBox(width: 12),
        const Expanded(child: Text(
          'Ce médicament est contre-indiqué pour les pathologies sélectionnées.\n'
          'L\'administration est fortement déconseillée.',
          style: TextStyle(
            fontSize: 12.5, color: _DC.danger, height: 1.5))),
      ]),
    );
  }
}

// ── Carte ajustement de dose ───────────────────────────────────────────────
class _DoseAdjustmentCard extends StatelessWidget {
  final String text;
  final bool isDark;
  const _DoseAdjustmentCard({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1A0D) : _DC.warnBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _DC.warnBorder.withOpacity(0.6))),
      child: Row(children: [
        const Icon(Icons.tune_rounded, size: 14, color: _DC.warnText),
        const SizedBox(width: 8),
        Expanded(child: Text('Ajustement recommandé : $text',
          style: const TextStyle(
            fontSize: 12, color: _DC.warnText,
            fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

// ── Chip statut dans le header détail ─────────────────────────────────────
class _StatusChipDetail extends StatelessWidget {
  final DrugPathologyStatus status;
  const _StatusChipDetail(this.status);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case DrugPathologyStatus.preferred:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _DC.successBg, borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _DC.successBorder)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.star_rounded, size: 11, color: _DC.success),
            SizedBox(width: 3),
            Text('Recommandé', style: TextStyle(
              fontSize: 10, color: _DC.success, fontWeight: FontWeight.w700)),
          ]));
      case DrugPathologyStatus.contraindicated:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _DC.dangerBg, borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _DC.dangerBorder)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.block_rounded, size: 11, color: _DC.danger),
            SizedBox(width: 3),
            Text('Contre-indiqué', style: TextStyle(
              fontSize: 10, color: _DC.danger, fontWeight: FontWeight.w700)),
          ]));
      case DrugPathologyStatus.caution:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _DC.warnBg, borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _DC.warnBorder)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.warning_amber_rounded, size: 11, color: _DC.warnText),
            SizedBox(width: 3),
            Text('Précaution', style: TextStyle(
              fontSize: 10, color: _DC.warnText, fontWeight: FontWeight.w700)),
          ]));
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  WIDGETS UTILITAIRES (inchangés)
// ════════════════════════════════════════════════════════════════════════════

class _Chip extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const _Chip(this.text, {required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600)));
}

class _DetailSectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  const _DetailSectionTitle(this.text, {required this.isDark});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 2.5, height: 14,
      margin: const EdgeInsets.only(right: 7),
      decoration: BoxDecoration(
        color: _DC.accent, borderRadius: BorderRadius.circular(2))),
    Text(text, style: TextStyle(
      fontSize: 12.5, fontWeight: FontWeight.w700,
      color: isDark ? _DC.darkText : _DC.textPrimary)),
  ]);
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _InfoCard({required this.children, required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: isDark ? _DC.darkCard : _DC.card,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: isDark ? _DC.darkBorder : _DC.cardBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children));
}

Widget _divider(bool isDark) => Divider(
  height: 1, color: isDark ? _DC.darkBorder : _DC.divider);

class _DetailRow extends StatelessWidget {
  final String label, value;
  final bool isDark, isLast;
  const _DetailRow(this.label, this.value, {required this.isDark, this.isLast = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          fontSize: 12.5, color: isDark ? _DC.darkSub : _DC.textSecond)),
        Flexible(child: Text(value,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600,
            color: isDark ? _DC.darkText : _DC.textPrimary))),
      ],
    ),
  );
}

class _DoseCard extends StatelessWidget {
  final String label, amount, unit, subtitle;
  final bool isCaution, isDark;
  const _DoseCard({
    required this.label, required this.amount, required this.unit,
    required this.subtitle, required this.isDark, this.isCaution = false,
  });
  @override
  Widget build(BuildContext context) {
    final bg = isCaution
      ? (isDark ? const Color(0xFF1F1A0D) : _DC.warnBg)
      : (isDark ? _DC.darkInput : _DC.accentLight);
    final amtColor = isCaution
      ? (isDark ? const Color(0xFFD4A853) : _DC.warnText)
      : _DC.accent;
    final labelColor = isDark ? _DC.darkSub : _DC.textSecond;
    final subColor   = isDark ? _DC.darkSub : _DC.textSecond;
    final borderColor = isCaution
      ? (isDark ? const Color(0xFF3A2F0A) : _DC.warnBorder)
      : Colors.transparent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(11),
        border: Border.all(color: borderColor, width: 1)),
      child: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(
              fontSize: 11.5, color: labelColor, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            RichText(text: TextSpan(children: [
              TextSpan(text: amount, style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: amtColor)),
              TextSpan(text: ' $unit', style: TextStyle(
                fontSize: 11.5, fontWeight: FontWeight.w600,
                color: amtColor.withOpacity(0.7))),
            ])),
            const SizedBox(height: 3),
            Text(subtitle, style: TextStyle(fontSize: 10.5, color: subColor)),
          ],
        )),
        if (isCaution)
          Icon(Icons.info_outline_rounded, size: 14,
            color: isDark ? const Color(0xFFD4A853) : _DC.warnText),
      ]),
    );
  }
}

class _MlHCard extends StatelessWidget {
  final double conc, mlMin, mlMax;
  final String preparation;
  final bool compatSG5, compatNaCl;
  final bool expanded, isDark;
  final VoidCallback onToggle;
  const _MlHCard({
    required this.conc, required this.mlMin, required this.mlMax,
    required this.preparation, required this.compatSG5, required this.compatNaCl,
    required this.expanded, required this.isDark, required this.onToggle,
  });
  @override
  Widget build(BuildContext context) {
    final bg     = isDark ? _DC.darkCard  : _DC.card;
    final border = isDark ? _DC.darkBorder : _DC.cardBorder;
    return Container(
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(11),
        border: Border.all(color: border)),
      child: Column(children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            child: Row(children: [
              Icon(Icons.speed_rounded, color: _DC.accent, size: 16),
              const SizedBox(width: 9),
              Expanded(child: Text('Débit de Perfusion (ml/h)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: isDark ? _DC.darkText : _DC.textPrimary))),
              Icon(
                expanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
                color: isDark ? _DC.darkSub : _DC.textSecond, size: 18),
            ]),
          ),
        ),
        if (expanded) ...[
          Divider(height: 1, color: isDark ? _DC.darkBorder : _DC.divider),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Standard : ${conc * 1000 < 1 ? (conc * 1000).toStringAsFixed(2) : (conc * 1000).toStringAsFixed(0)} µg/ml',
                style: TextStyle(fontSize: 11.5,
                  color: isDark ? _DC.darkSub : _DC.textSecond)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _MlChip('Débit Min', mlMin, isDark: isDark)),
                const SizedBox(width: 8),
                Expanded(child: _MlChip('Débit Max', mlMax, isDark: isDark)),
              ]),
              const SizedBox(height: 14),
              // ── Dilution & Préparation ──
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161B27) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF2E3347) : const Color(0xFFE5E7EB)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.science_rounded, size: 14, color: _DC.accent),
                    const SizedBox(width: 6),
                    Text('Dilution & Préparation', style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: isDark ? _DC.darkText : _DC.textPrimary,
                    )),
                  ]),
                  const SizedBox(height: 8),
                  Text(preparation, style: TextStyle(
                    fontSize: 11.5, color: isDark ? _DC.darkSub : _DC.textSecond, height: 1.4,
                  )),
                  const SizedBox(height: 8),
                  Row(children: [
                    _CompatChip(label: 'NaCl 0.9%', compatible: compatNaCl, isDark: isDark),
                    const SizedBox(width: 6),
                    _CompatChip(label: 'G5%', compatible: compatSG5, isDark: isDark),
                  ]),
                ]),
              ),
              const SizedBox(height: 7),
              Text(
                'Basé sur la préparation standard — vérifier la concentration réelle',
                style: TextStyle(fontSize: 10,
                  color: isDark ? _DC.darkSub : _DC.textSecond)),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _CompatChip extends StatelessWidget {
  final String label;
  final bool compatible;
  final bool isDark;
  const _CompatChip({required this.label, required this.compatible, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final color = compatible ? _DC.success : _DC.danger;
    final bg = compatible ? (isDark ? const Color(0xFF0D2218) : _DC.successBg) : (isDark ? const Color(0xFF1A0E0E) : _DC.dangerBg);
    final border = compatible ? _DC.successBorder : _DC.dangerBorder;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? border.withOpacity(0.3) : border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(compatible ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}

class _MlChip extends StatelessWidget {
  final String label;
  final double value;
  final bool isDark;
  const _MlChip(this.label, this.value, {required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: isDark ? _DC.darkInput : _DC.accentLight,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isDark ? _DC.darkBorder : const Color(0xFFBFD5FF))),
    child: Column(children: [
      Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600,
        color: isDark ? _DC.darkSub : _DC.textSecond)),
      const SizedBox(height: 4),
      Text('${value.toStringAsFixed(1)} ml/h',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
          color: _DC.accent)),
    ]));
}