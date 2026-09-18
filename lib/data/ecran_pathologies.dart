// lib/screens/ecran_pathologies.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pathologie.dart';
import '../providers/app_provider.dart';

// ─── Palette de couleurs locales — design premium Apple / Linear / Stripe ────
class _C {
  static const bleu         = Color(0xFF2F80ED);
  static const bleuFond     = Color(0xFFEDF5FF);
  static const bleuFondSoft = Color(0xFFF8FBFF);
  static const bleuBord     = Color(0xFFBFDBFE);
  static const bleuDark     = Color(0xFF0F4C81);
  static const vert         = Color(0xFF22C55E);
  static const vertFond     = Color(0xFFDCFCE7);
  static const vertBord     = Color(0xFF86EFAC);
  static const vertDark     = Color(0xFF15803D);
  static const rouge        = Color(0xFFEF4444);
  static const rougeFond    = Color(0xFFFEE2E2);
  static const rougeBord    = Color(0xFFFCA5A5);
  static const rougeDark    = Color(0xFFB91C1C);
  static const indigo       = Color(0xFF0F4C81);
  static const indigoFond   = Color(0xFFEFF6FF);
  static const indigoBord   = Color(0xFFBFDBFE);
  static const indigoDark   = Color(0xFF0F172A);
  static const violet       = Color(0xFF8B5CF6);
  static const fondPage     = Color(0xFFF8FAFC);
  static const textePrim    = Color(0xFF111827);
  static const texteSec     = Color(0xFF667085);
  static const texteMuted   = Color(0xFF98A2B3);
  static const bordure      = Color(0xFFE8ECF4);
  static const bordClaire   = Color(0xFFCBD5E1);
  static const cardShadow   = Color(0x0F0F172A);

  // ── Palette Dark Mode ──────────────────────────────────────────
  static const darkBg     = Color(0xFF08111F);
  static const darkCard   = Color(0xFF0F172A);
  static const darkInput  = Color(0xFF16233A);
  static const darkBorder = Color(0xFF334155);
  static const darkText   = Color(0xFFF8FAFC);
  static const darkSub    = Color(0xFF94A3B8);
  static const darkMuted  = Color(0xFF64748B);
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ÉCRAN PRINCIPAL — 2 phases
// ═══════════════════════════════════════════════════════════════════════════════
class EcranPathologies extends StatefulWidget {
  const EcranPathologies({super.key});
  @override
  State<EcranPathologies> createState() => _EcranPathologiesState();
}

class _EcranPathologiesState extends State<EcranPathologies> {
  int _phase = 0;
  final _rechercheCtrl = TextEditingController();
  String _requete = '';

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void dispose() {
    _rechercheCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark;
    final bg = isDark ? _C.darkBg : _C.fondPage;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Consumer<AppProvider>(
          builder: (ctx, prov, _) {
            final parCategorie  = prov.pathologiesParCategorie;
            final selectionnees = prov.pathologiesSelectionnees;

            return Column(
              children: [
                _EnTetePhases(
                  phase: _phase,
                  nbSelectionnees: selectionnees.length,
                  rechercheController: _rechercheCtrl,
                  requete: _requete,
                  isDark: isDark,
                  onRechercheChanged: (v) => setState(() => _requete = v),
                  onChangerPhase: (p) {
                    if (p == 1 && selectionnees.isEmpty) return;
                    setState(() => _phase = p);
                  },
                  onReinitialiser: () {
                    prov.reinitialiserPathologies();
                    setState(() => _phase = 0);
                  },
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: _phase == 0
                        ? _PhaseSelection(
                            key: const ValueKey(0),
                            parCategorie: parCategorie,
                            selectionnees: selectionnees,
                            requete: _requete,
                            isDark: isDark,
                            onToggle: prov.basculerPathologie,
                            onReinitialiser: prov.reinitialiserPathologies,
                            onSuivant: selectionnees.isNotEmpty
                                ? () => setState(() => _phase = 1)
                                : null,
                          )
                        : _PhaseResultats(
                            key: const ValueKey(1),
                            selectionnees: selectionnees,
                            preferes: prov.drugsPreferesIds,
                            contreIndiques: prov.drugsContreindiqueIds,
                            isDark: isDark,
                            onRetour: () => setState(() => _phase = 0),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  EN-TÊTE COMMUN — barre 2 étapes
// ═══════════════════════════════════════════════════════════════════════════════
class _EnTetePhases extends StatelessWidget {
  final int phase;
  final int nbSelectionnees;
  final TextEditingController rechercheController;
  final String requete;
  final bool isDark;
  final ValueChanged<String> onRechercheChanged;
  final ValueChanged<int> onChangerPhase;
  final VoidCallback onReinitialiser;

  const _EnTetePhases({
    required this.phase,
    required this.nbSelectionnees,
    required this.rechercheController,
    required this.requete,
    required this.isDark,
    required this.onRechercheChanged,
    required this.onChangerPhase,
    required this.onReinitialiser,
  });

  @override
  Widget build(BuildContext context) {
    // Barre de recherche compacte (uniquement en phase Sélection)
    final champRecherche = phase == 0
        ? SizedBox(
            width: 160,
            child: _CompactSearchBar(
              controller: rechercheController,
              query: requete,
              isDark: isDark,
              onChanged: onRechercheChanged,
              onClear: () {
                rechercheController.clear();
                onRechercheChanged('');
              },
            ),
          )
        : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? _C.darkCard : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? _C.darkBorder : _C.bordure,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ligne 1 : badge + titre/sous-titre + recherche — identique au header Emergency ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge icône — identique au header Drugs
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? _C.darkInput : _C.bleuFond,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.medical_information_rounded,
                    color: _C.bleu,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                // Titre + sous-titre
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pathologies',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: isDark ? _C.darkText : _C.textePrim,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Parcourez et sélectionnez une catégorie de pathologie',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? _C.darkSub : _C.texteSec,
                        ),
                      ),
                    ],
                  ),
                ),
                // Barre de recherche compacte
                if (champRecherche != null) ...[
                  const SizedBox(width: 10),
                  champRecherche,
                ],
              ],
            ),
          ),
          // ── Ligne 2 : stepper (+ bouton reset) ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                _StepperPremium(
                  phase: phase,
                  nbSelectionnees: nbSelectionnees,
                  isDark: isDark,
                  onChangerPhase: onChangerPhase,
                ),
                if (phase == 1) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onReinitialiser,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? _C.darkInput : _C.fondPage,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? _C.darkBorder : _C.bordure,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(Icons.refresh_rounded, size: 15, color: _C.bleu),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Barre de recherche compacte (header) — style identique à Emergency ──────
class _CompactSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String query;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _CompactSearchBar({
    required this.controller,
    required this.query,
    required this.isDark,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_CompactSearchBar> createState() => _CompactSearchBarState();
}

class _CompactSearchBarState extends State<_CompactSearchBar> {
  final FocusNode _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final hasText = widget.controller.text.isNotEmpty;
        final isDark = widget.isDark;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          decoration: BoxDecoration(
            color: isDark ? _C.darkInput : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focused
                  ? _C.bleu.withOpacity(isDark ? 0.60 : 0.35)
                  : (isDark ? _C.darkBorder : _C.bordure),
              width: _focused ? 1.4 : 1,
            ),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: _C.bleu.withOpacity(isDark ? 0.16 : 0.08),
                      blurRadius: 0,
                      spreadRadius: 4,
                    )
                  ]
                : [],
          ),
          child: Row(children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded,
                size: 19,
                color: _focused || hasText
                    ? _C.bleu
                    : (isDark ? _C.darkSub : _C.texteMuted)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                onChanged: widget.onChanged,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? _C.darkText : _C.textePrim,
                ),
                cursorColor: _C.bleu,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? _C.darkSub : _C.texteMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (hasText)
              GestureDetector(
                onTap: widget.onClear,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 9),
                  decoration: BoxDecoration(
                    color: isDark ? _C.darkBorder : const Color(0xFFF1F3F7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: isDark ? _C.darkText : _C.textePrim,
                  ),
                ),
              )
            else
              const SizedBox(width: 14),
          ]),
        );
      },
    );
  }
}

// ─── Stepper premium (style Apple) — 2 étapes reliées par un connecteur ──────
class _StepperPremium extends StatelessWidget {
  final int phase;
  final int nbSelectionnees;
  final bool isDark;
  final ValueChanged<int> onChangerPhase;

  const _StepperPremium({
    required this.phase,
    required this.nbSelectionnees,
    required this.isDark,
    required this.onChangerPhase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? _C.darkInput : _C.fondPage,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: isDark ? _C.darkBorder : _C.bordure),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _PiluleEtape(
          numero: 1,
          titre: 'Sélection',
          actif: phase == 0,
          isDark: isDark,
          onTap: () => onChangerPhase(0),
        ),
        Container(
          width: 20,
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          color: isDark ? _C.darkBorder : _C.bordClaire,
        ),
        _PiluleEtape(
          numero: 2,
          titre: 'Résultats',
          actif: phase == 1,
          isDark: isDark,
          badge: nbSelectionnees > 0 ? nbSelectionnees : null,
          onTap: nbSelectionnees > 0 ? () => onChangerPhase(1) : null,
        ),
      ]),
    );
  }
}

class _PiluleEtape extends StatelessWidget {
  final int numero;
  final String titre;
  final bool actif;
  final bool isDark;
  final int? badge;
  final VoidCallback? onTap;

  const _PiluleEtape({
    required this.numero,
    required this.titre,
    required this.actif,
    required this.isDark,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null && !actif;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: actif ? _C.bleu : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: actif
                  ? Colors.white.withOpacity(0.22)
                  : (isDark ? _C.darkCard : _C.bleuFond),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$numero',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: actif
                      ? Colors.white
                      : (disabled
                          ? (isDark ? _C.darkMuted : _C.texteMuted)
                          : (isDark ? const Color(0xFF38BDF8) : _C.bleu)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            titre,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: actif
                  ? Colors.white
                  : (disabled
                      ? (isDark ? _C.darkMuted : _C.texteMuted)
                      : (isDark ? _C.darkSub : _C.texteSec)),
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: actif ? Colors.white.withOpacity(0.30) : _C.bleu,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  HELPERS CATÉGORIE — icône & couleur, partagés par toutes les vues
// ═══════════════════════════════════════════════════════════════════════════════
IconData iconeCategorie(CategoriePathologie c) {
  switch (c) {
    case CategoriePathologie.respiratoire:     return Icons.air;
    case CategoriePathologie.cardiovasculaire: return Icons.favorite_rounded;
    case CategoriePathologie.neurologique:     return Icons.psychology_rounded;
    case CategoriePathologie.metabolique:      return Icons.science_rounded;
    case CategoriePathologie.renal:            return Icons.water_drop_rounded;
    case CategoriePathologie.hepatique:        return Icons.medical_services_rounded;
    case CategoriePathologie.infectieux:       return Icons.coronavirus_rounded;
    case CategoriePathologie.allergique:       return Icons.warning_amber_rounded;
    case CategoriePathologie.obstetrique:      return Icons.child_care_rounded;
    case CategoriePathologie.autre:            return Icons.more_horiz_rounded;
    case CategoriePathologie.infectieuxRespiratoire:  return Icons.coronavirus_rounded;
    case CategoriePathologie.infectieuxDigestif:      return Icons.restaurant_rounded;
    case CategoriePathologie.orlInfectieux:           return Icons.hearing_rounded;
    case CategoriePathologie.dermatologieInfectieuse: return Icons.healing_rounded;
    case CategoriePathologie.neuroInfectieux:         return Icons.sick_rounded;
    case CategoriePathologie.ist:                     return Icons.shield_rounded;
    case CategoriePathologie.infectieuxPediatrique:   return Icons.child_friendly_rounded;
    case CategoriePathologie.maladiesTropicales:      return Icons.public_rounded;
    case CategoriePathologie.infectieuxObstetrical:   return Icons.pregnant_woman_rounded;
    case CategoriePathologie.gastroEnterologie:       return Icons.restaurant_menu_rounded;
    case CategoriePathologie.urologie:                return Icons.opacity_rounded;
    case CategoriePathologie.dermatologie:            return Icons.face_rounded;
    case CategoriePathologie.ophtalmologie:           return Icons.visibility_rounded;
    case CategoriePathologie.rhumatologieOrthopedie:  return Icons.accessibility_new_rounded;
    case CategoriePathologie.psychiatrie:             return Icons.self_improvement_rounded;
    case CategoriePathologie.hematologie:             return Icons.bloodtype_rounded;
    case CategoriePathologie.toxicologie:             return Icons.dangerous_rounded;
    case CategoriePathologie.traumatologieUrgences:   return Icons.local_hospital_rounded;
    case CategoriePathologie.neonatologie:            return Icons.child_care_rounded;
    case CategoriePathologie.gynecologie:             return Icons.female_rounded;
  }
}

Color couleurCategorie(CategoriePathologie c) {
  switch (c) {
    case CategoriePathologie.respiratoire:     return const Color(0xFF1565C0);
    case CategoriePathologie.cardiovasculaire: return const Color(0xFFE53935);
    case CategoriePathologie.neurologique:     return const Color(0xFF7B1FA2);
    case CategoriePathologie.metabolique:      return const Color(0xFFF57F17);
    case CategoriePathologie.renal:            return const Color(0xFF0288D1);
    case CategoriePathologie.hepatique:        return const Color(0xFFF57C00);
    case CategoriePathologie.infectieux:       return const Color(0xFFD32F2F);
    case CategoriePathologie.allergique:       return const Color(0xFFE65100);
    case CategoriePathologie.obstetrique:      return const Color(0xFFE91E63);
    case CategoriePathologie.autre:            return _C.texteSec;
    case CategoriePathologie.infectieuxRespiratoire:  return const Color(0xFF00838F);
    case CategoriePathologie.infectieuxDigestif:      return const Color(0xFF6D4C41);
    case CategoriePathologie.orlInfectieux:           return const Color(0xFF00ACC1);
    case CategoriePathologie.dermatologieInfectieuse: return const Color(0xFFAD1457);
    case CategoriePathologie.neuroInfectieux:         return const Color(0xFF5E35B1);
    case CategoriePathologie.ist:                     return const Color(0xFFC2185B);
    case CategoriePathologie.infectieuxPediatrique:   return const Color(0xFFFF7043);
    case CategoriePathologie.maladiesTropicales:      return const Color(0xFF2E7D32);
    case CategoriePathologie.infectieuxObstetrical:   return const Color(0xFFD81B60);
    case CategoriePathologie.gastroEnterologie:       return const Color(0xFF795548);
    case CategoriePathologie.urologie:                return const Color(0xFF0097A7);
    case CategoriePathologie.dermatologie:            return const Color(0xFFEC407A);
    case CategoriePathologie.ophtalmologie:           return const Color(0xFF3949AB);
    case CategoriePathologie.rhumatologieOrthopedie:  return const Color(0xFF8D6E63);
    case CategoriePathologie.psychiatrie:             return const Color(0xFF7E57C2);
    case CategoriePathologie.hematologie:             return const Color(0xFFC62828);
    case CategoriePathologie.toxicologie:             return const Color(0xFF9E9D24);
    case CategoriePathologie.traumatologieUrgences:   return const Color(0xFFB71C1C);
    case CategoriePathologie.neonatologie:            return const Color(0xFF4FC3F7);
    case CategoriePathologie.gynecologie:             return const Color(0xFFF06292);
  }
}

/// Ouvre la fiche détaillée (BottomSheet Info, section 7) pour une pathologie.
void ouvrirFicheInfo(BuildContext context, Pathologie pathologie, Color couleur) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FicheDetailSheet(pathologie: pathologie, couleur: couleur),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  FIL D'ARIANE COMMUN — chips avec icône home
// ═══════════════════════════════════════════════════════════════════════════════
class _FilAriane extends StatelessWidget {
  final List<Pathologie> selectionnees;
  final bool showHome;
  final bool isDark;

  const _FilAriane({
    required this.selectionnees,
    this.showHome = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: isDark ? _C.darkCard : Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          if (showHome) ...[
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: isDark ? _C.darkInput : _C.bleuFond,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.home_rounded, size: 15, color: _C.bleu),
            ),
            const SizedBox(width: 6),
          ] else ...[
            const Icon(Icons.tune_rounded, size: 15, color: _C.bleu),
            const SizedBox(width: 6),
          ],
          ...selectionnees.asMap().entries.expand((e) {
            final i = e.key;
            final p = e.value;
            return [
              _ChipBreadcrumb(nom: p.nom, isDark: isDark),
              if (i < selectionnees.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.chevron_right_rounded, size: 16, color: isDark ? _C.darkBorder : _C.bleuBord),
                ),
            ];
          }),
        ]),
      ),
    );
  }
}

class _ChipBreadcrumb extends StatelessWidget {
  final String nom;
  final bool isDark;
  const _ChipBreadcrumb({required this.nom, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? _C.darkInput : _C.bleuFond,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? _C.darkBorder : _C.bleuBord),
      ),
      child: Text(
        nom,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? const Color(0xFF93C5FD) : _C.bleuDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PHASE 1 — SÉLECTION
// ═══════════════════════════════════════════════════════════════════════════════
class _PhaseSelection extends StatelessWidget {
  final Map<CategoriePathologie, List<Pathologie>> parCategorie;
  final List<Pathologie> selectionnees;
  final String requete;
  final bool isDark;
  final void Function(String) onToggle;
  final VoidCallback onReinitialiser;
  final VoidCallback? onSuivant;

  const _PhaseSelection({
    super.key,
    required this.parCategorie,
    required this.selectionnees,
    required this.requete,
    required this.isDark,
    required this.onToggle,
    required this.onReinitialiser,
    required this.onSuivant,
  });

  @override
  Widget build(BuildContext context) {
    // Padding bottom = navbar height + marge
    final bottomPad = MediaQuery.of(context).padding.bottom + 90;
    final enRecherche = requete.trim().isNotEmpty;

    // ── Recherche instantanée (section 14) — nom, description, catégorie, mots-clés ──
    // La saisie est désormais pilotée par la barre de recherche du header
    // (_EnTetePhases) ; cet écran ne fait qu'appliquer le filtre reçu.
    final resultats = <Pathologie>[];
    if (enRecherche) {
      for (final liste in parCategorie.values) {
        resultats.addAll(liste.where((p) => p.correspondARecherche(requete)));
      }
    }

    return Container(
      color: isDark ? _C.darkBg : _C.fondPage,
      child: Column(children: [
        if (!enRecherche && selectionnees.isNotEmpty)
          _FilAriane(selectionnees: selectionnees, showHome: false, isDark: isDark),
        Expanded(
          child: enRecherche
              ? _ResultatsRecherche(
                  requete: requete,
                  resultats: resultats,
                  onToggle: onToggle,
                  bottomPad: bottomPad,
                  isDark: isDark,
                )
              : ListView(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, bottomPad),
                  children: [
                    ...((){
                          // ── Ordre clinique personnalisé ──
                          const ordreCliniqueCustom = [
                            CategoriePathologie.cardiovasculaire,
                            CategoriePathologie.hepatique,
                            CategoriePathologie.metabolique,
                            CategoriePathologie.respiratoire,
                            CategoriePathologie.neurologique,
                            CategoriePathologie.renal,
                            CategoriePathologie.traumatologieUrgences,
                            CategoriePathologie.urologie,
                          ];
                          int priorite(CategoriePathologie c) {
                            final idx = ordreCliniqueCustom.indexOf(c);
                            return idx == -1 ? 9999 : idx;
                          }
                          final entries = parCategorie.entries.toList()
                            ..sort((a, b) {
                              final pa = priorite(a.key);
                              final pb = priorite(b.key);
                              if (pa != pb) return pa.compareTo(pb);
                              return a.value.first.labelCategorie
                                  .toLowerCase()
                                  .compareTo(b.value.first.labelCategorie.toLowerCase());
                            });
                          return entries;
                        }())
                        .map((e) => _CarteCategorie(
                              categorie: e.key,
                              // ── Tri alphabétique A→Z des pathologies dans la catégorie ──
                              pathologies: [...e.value]..sort((a, b) =>
                                  a.nom.toLowerCase().compareTo(b.nom.toLowerCase())),
                              isDark: isDark,
                              onToggle: onToggle,
                            )),
                    if (selectionnees.length >= 2) ...[
                      const SizedBox(height: 4),
                      _CarteEssentiel(selectionnees: selectionnees, isDark: isDark),
                    ],
                    // ── Bouton juste sous la dernière carte ──
                    const SizedBox(height: 12),
                    _BoutonSuivant(
                      onTap: onSuivant,
                      nbSelectionnees: selectionnees.length,
                      isDark: isDark,
                    ),
                  ],
                ),
        ),
        if (enRecherche)
          Padding(
            padding: EdgeInsets.fromLTRB(
              14, 8, 14, MediaQuery.of(context).padding.bottom + 14,
            ),
            child: _BoutonSuivant(
              onTap: onSuivant,
              nbSelectionnees: selectionnees.length,
              isDark: isDark,
            ),
          ),
      ]),
    );
  }
}

// ─── Résultats de recherche — liste aplatie, groupée par catégorie ───────────
class _ResultatsRecherche extends StatelessWidget {
  final String requete;
  final List<Pathologie> resultats;
  final void Function(String) onToggle;
  final double bottomPad;
  final bool isDark;

  const _ResultatsRecherche({
    required this.requete,
    required this.resultats,
    required this.onToggle,
    required this.bottomPad,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (resultats.isEmpty) {
      return ListView(
        padding: EdgeInsets.fromLTRB(28, 60, 28, bottomPad),
        children: [
          Icon(Icons.search_off_rounded, size: 42, color: isDark ? _C.darkSub : _C.texteMuted),
          const SizedBox(height: 12),
          Text(
            'Aucune pathologie ne correspond à « $requete »',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? _C.darkSub : _C.texteMuted),
          ),
        ],
      );
    }

    final Map<CategoriePathologie, List<Pathologie>> parCat = {};
    for (final p in resultats) {
      parCat.putIfAbsent(p.categorie, () => []).add(p);
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 6, 20, bottomPad),
      children: [
        Text(
          '${resultats.length} résultat${resultats.length > 1 ? "s" : ""}',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? _C.darkSub : _C.texteMuted),
        ),
        const SizedBox(height: 8),
        ...parCat.entries.expand((e) {
          final c = couleurCategorie(e.key);
          return [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6, left: 2),
              child: Row(children: [
                Icon(iconeCategorie(e.key), size: 15, color: c),
                const SizedBox(width: 6),
                Text(
                  e.key.label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: c),
                ),
              ]),
            ),
            ...e.value.map((p) => _LignePathologie(
                  pathologie: p,
                  onToggle: onToggle,
                  couleur: c,
                  isDark: isDark,
                )),
          ];
        }),
      ],
    );
  }
}

class _BoutonSuivant extends StatelessWidget {
  final VoidCallback? onTap;
  final int nbSelectionnees;
  final bool isDark;
  const _BoutonSuivant({
    required this.onTap,
    required this.nbSelectionnees,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final actif = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: actif
              ? const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)],
                )
              : null,
          color: actif ? null : (isDark ? _C.darkCard : _C.bordure),
          borderRadius: BorderRadius.circular(16),
          border: !actif && isDark ? Border.all(color: _C.darkBorder) : null,
          boxShadow: actif
              ? [
                  BoxShadow(
                    color: _C.bleu.withOpacity(0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            actif
                ? 'Voir les résultats ($nbSelectionnees pathologie${nbSelectionnees > 1 ? "s" : ""})'
                : 'Sélectionnez au moins une pathologie',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: actif ? Colors.white : (isDark ? _C.darkSub : _C.texteMuted),
            ),
          ),
          if (actif) ...[
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ]),
      ),
    );
  }
}

// ─── Carte catégorie (accordéon) ─────────────────────────────────────────────
class _CarteCategorie extends StatefulWidget {
  final CategoriePathologie categorie;
  final List<Pathologie> pathologies;
  final bool isDark;
  final void Function(String) onToggle;

  const _CarteCategorie({
    required this.categorie,
    required this.pathologies,
    required this.isDark,
    required this.onToggle,
  });

  @override
  State<_CarteCategorie> createState() => _CarteCategorieState();
}

class _CarteCategorieState extends State<_CarteCategorie> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.pathologies.any((p) => p.estSelectionnee);
  }

  IconData get _icone => iconeCategorie(widget.categorie);

  Color get _couleur => couleurCategorie(widget.categorie);

  @override
  Widget build(BuildContext context) {
    final nbSel = widget.pathologies.where((p) => p.estSelectionnee).length;
    final c = _couleur;
    final isDark = widget.isDark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? _C.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: nbSel > 0
              ? c.withOpacity(isDark ? 0.60 : 0.35)
              : (isDark ? _C.darkBorder : _C.bordure),
          width: nbSel > 0 ? 1.5 : 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: _C.cardShadow,
                  blurRadius: _expanded ? 18 : 10,
                  offset: Offset(0, _expanded ? 6 : 3),
                ),
              ],
      ),
      child: Column(children: [
        // ── En-tête cliquable — carte compacte, badge pastel, chevron ──
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(children: [
                // Badge pastel compact
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: c.withOpacity(isDark ? 0.18 : 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_icone, color: c, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.pathologies.first.labelCategorie,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? _C.darkText : _C.textePrim,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nbSel > 0
                            ? '$nbSel sélectionnée${nbSel > 1 ? "s" : ""}'
                            : '${widget.pathologies.length} pathologie${widget.pathologies.length > 1 ? "s" : ""} disponible${widget.pathologies.length > 1 ? "s" : ""}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: nbSel > 0 ? FontWeight.w700 : FontWeight.w500,
                          color: nbSel > 0 ? c : (isDark ? _C.darkSub : _C.texteMuted),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _expanded ? c : (isDark ? _C.darkSub : _C.texteMuted),
                    size: 20,
                  ),
                ),
              ]),
            ),
          ),
        ),

        // ── Liste déroulante ──
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(children: [
            Divider(height: 1, color: isDark ? _C.darkBorder : _C.bordure, indent: 20, endIndent: 20),
            const SizedBox(height: 4),
            ...widget.pathologies.map(
              (p) => _LignePathologie(
                pathologie: p,
                onToggle: widget.onToggle,
                couleur: c,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 10),
          ]),
          secondChild: const SizedBox.shrink(),
        ),
      ]),
    );
  }
}

class _LignePathologie extends StatelessWidget {
  final Pathologie pathologie;
  final void Function(String) onToggle;
  final Color couleur;
  final bool isDark;
  const _LignePathologie({
    required this.pathologie,
    required this.onToggle,
    required this.couleur,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sel = pathologie.estSelectionnee;
    return GestureDetector(
      onTap: () => onToggle(pathologie.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: sel
              ? couleur.withOpacity(isDark ? 0.20 : 0.07)
              : (isDark ? _C.darkInput : const Color(0xFFF8F8FC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: sel
                ? couleur.withOpacity(isDark ? 0.65 : 0.45)
                : (isDark ? _C.darkBorder.withOpacity(0.5) : Colors.transparent),
            width: 1.5,
          ),
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: sel ? couleur : Colors.transparent,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: sel ? couleur : (isDark ? _C.darkBorder : _C.bordClaire),
                width: 1.8,
              ),
            ),
            child: sel
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                pathologie.nom,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  color: sel
                      ? (isDark ? _C.darkText : _C.textePrim)
                      : (isDark ? const Color(0xFFCBD5E1) : _C.texteSec),
                ),
              ),
              if (pathologie.description.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  pathologie.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? _C.darkSub : _C.texteMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ]),
          ),
          // ── Badge de risque automatique (section 6) ──
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Tooltip(
              message: pathologie.niveauRisque.label,
              child: Text(pathologie.niveauRisque.emoji, style: const TextStyle(fontSize: 13)),
            ),
          ),
          if (pathologie.contreIndications.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.warning_amber_rounded, color: Color(0xFFEF9F27), size: 17),
            ),
          // ── Bouton Information → BottomSheet fiche détaillée (section 7) ──
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
              icon: Icon(Icons.info_outline_rounded, size: 18, color: isDark ? _C.darkSub : _C.texteMuted),
              onPressed: () => ouvrirFicheInfo(context, pathologie, couleur),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PHASE 2 — RÉSULTATS
// ═══════════════════════════════════════════════════════════════════════════════
class _PhaseResultats extends StatelessWidget {
  final List<Pathologie> selectionnees;
  final Set<String> preferes;
  final Set<String> contreIndiques;
  final bool isDark;
  final VoidCallback onRetour;

  const _PhaseResultats({
    super.key,
    required this.selectionnees,
    required this.preferes,
    required this.contreIndiques,
    required this.isDark,
    required this.onRetour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? _C.darkBg : _C.fondPage,
      child: Column(children: [
        // Fil d'ariane avec icône home
        _FilAriane(selectionnees: selectionnees, showHome: true, isDark: isDark),
        // Contenu scrollable
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
            children: [
              _PanneauAlertes(selectionnees: selectionnees, isDark: isDark),
              const SizedBox(height: 10),
              _PanneauRecommandations(selectionnees: selectionnees, isDark: isDark),
              const SizedBox(height: 10),
              _PanneauConsignes(selectionnees: selectionnees, isDark: isDark),
              const SizedBox(height: 10),
              _PanneauImpactDrugs(preferes: preferes, contreIndiques: contreIndiques, isDark: isDark),
              const SizedBox(height: 10),
              _CarteEssentiel(selectionnees: selectionnees, isDark: isDark),
            ],
          ),
        ),
      ]),
    );
  }
}

// ─── Widget générique panneau accordéon ──────────────────────────────────────
class _PanneauAccordeon extends StatefulWidget {
  final String titre;
  final IconData icone;
  final Color couleurFond;
  final Color couleurBord;
  final Color couleurIcone;
  final Color couleurTitre;
  final Color couleurFondIcone;
  final String labelBadge;
  final List<Widget> items;
  final bool isDark;

  const _PanneauAccordeon({
    required this.titre,
    required this.icone,
    required this.couleurFond,
    required this.couleurBord,
    required this.couleurIcone,
    required this.couleurTitre,
    required this.couleurFondIcone,
    required this.labelBadge,
    required this.items,
    required this.isDark,
  });

  @override
  State<_PanneauAccordeon> createState() => _PanneauAccordeonState();
}

class _PanneauAccordeonState extends State<_PanneauAccordeon> {
  // ── Fermé par défaut à l'ouverture — l'utilisateur ouvre ce qu'il souhaite ──
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? _C.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? widget.couleurBord.withOpacity(0.5) : widget.couleurBord,
          width: 1.5,
        ),
      ),
      child: Column(children: [
        // ── Header ──
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
            decoration: BoxDecoration(
              color: isDark
                  ? widget.couleurIcone.withOpacity(0.12)
                  : widget.couleurFond,
              borderRadius: _expanded
                  ? const BorderRadius.vertical(top: Radius.circular(15))
                  : BorderRadius.circular(15),
            ),
            child: Row(children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: isDark
                      ? widget.couleurIcone.withOpacity(0.20)
                      : widget.couleurFondIcone,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(widget.icone, color: widget.couleurIcone, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.titre,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? widget.couleurIcone : widget.couleurTitre,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? widget.couleurIcone.withOpacity(0.20)
                      : widget.couleurFondIcone,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  widget.labelBadge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? widget.couleurIcone : widget.couleurTitre,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: widget.couleurIcone,
                  size: 22,
                ),
              ),
            ]),
          ),
        ),
        // ── Items ──
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(children: widget.items),
          secondChild: const SizedBox.shrink(),
        ),
      ]),
    );
  }
}

// ─── Panneau Alertes ──────────────────────────────────────────────────────────
class _PanneauAlertes extends StatelessWidget {
  final List<Pathologie> selectionnees;
  final bool isDark;
  const _PanneauAlertes({required this.selectionnees, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = <_RowAlerte>[];
    for (final p in selectionnees) {
      for (final a in p.alertes) {
        items.add(_RowAlerte(pathologie: p.nom, texte: a, isDark: isDark));
      }
    }
    if (items.isEmpty) return const SizedBox.shrink();

    return _PanneauAccordeon(
      titre: 'ALERTES & PRÉCAUTIONS',
      icone: Icons.warning_amber_rounded,
      couleurFond: const Color(0xFFFFF1F2),
      couleurBord: _C.rougeBord,
      couleurIcone: _C.rouge,
      couleurTitre: const Color(0xFFC62828),
      couleurFondIcone: const Color(0xFFFFE4E6),
      labelBadge: '${items.length} alerte${items.length > 1 ? "s" : ""}',
      isDark: isDark,
      items: items,
    );
  }
}

class _RowAlerte extends StatelessWidget {
  final String pathologie;
  final String texte;
  final bool isDark;
  const _RowAlerte({required this.pathologie, required this.texte, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? _C.darkBorder : const Color(0xFFF5F5FA),
            ),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF5350), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? _C.darkSub : _C.texteSec,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '[$pathologie] ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isDark ? _C.darkText : _C.textePrim,
                    ),
                  ),
                  TextSpan(text: texte),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, size: 18, color: isDark ? _C.darkBorder : _C.bordClaire),
        ]),
      ),
    );
  }
}

// ─── Panneau Recommandations ──────────────────────────────────────────────────
class _PanneauRecommandations extends StatelessWidget {
  final List<Pathologie> selectionnees;
  final bool isDark;
  const _PanneauRecommandations({required this.selectionnees, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = <_RowReco>[];
    for (final p in selectionnees) {
      for (final r in p.recommandations) {
        items.add(_RowReco(pathologie: p.nom, texte: r, isDark: isDark));
      }
    }
    if (items.isEmpty) return const SizedBox.shrink();

    return _PanneauAccordeon(
      titre: 'RECOMMANDATIONS',
      icone: Icons.check_circle_outline_rounded,
      couleurFond: const Color(0xFFF0FDF4),
      couleurBord: _C.vertBord,
      couleurIcone: _C.vert,
      couleurTitre: const Color(0xFF15803D),
      couleurFondIcone: const Color(0xFFDCFCE7),
      labelBadge: '${items.length} recommandation${items.length > 1 ? "s" : ""}',
      isDark: isDark,
      items: items,
    );
  }
}

class _RowReco extends StatelessWidget {
  final String pathologie;
  final String texte;
  final bool isDark;
  const _RowReco({required this.pathologie, required this.texte, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? _C.darkBorder : const Color(0xFFF5F5FA),
            ),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? _C.darkSub : _C.texteSec,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '[$pathologie] ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isDark ? _C.darkText : _C.textePrim,
                    ),
                  ),
                  TextSpan(text: texte),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, size: 18, color: isDark ? _C.darkBorder : _C.bordClaire),
        ]),
      ),
    );
  }
}

// ─── Panneau Consignes — grille 3×2 : icône gauche + texte + flèche droite ───
class _PanneauConsignes extends StatelessWidget {
  final List<Pathologie> selectionnees;
  final bool isDark;
  const _PanneauConsignes({required this.selectionnees, required this.isDark});

  static IconData _iconeConsigne(String texte) {
    final t = texte.toLowerCase();
    if (t.contains('paco') || t.contains('co2'))        return Icons.co2_rounded;
    if (t.contains('ventil') || t.contains('expirat'))  return Icons.air_rounded;
    if (t.contains('hypoten') || t.contains('pression')) return Icons.monitor_heart_outlined;
    if (t.contains('tête') || t.contains('position'))   return Icons.face_rounded;
    if (t.contains('prémédic') || t.contains('broncho')) return Icons.medication_liquid_rounded;
    if (t.contains('lidocaïne') || t.contains('intubation')) return Icons.vaccines_rounded;
    if (t.contains('glucose') || t.contains('glycémie')) return Icons.science_rounded;
    return Icons.medical_information_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final consignes = <String>[];
    for (final p in selectionnees) consignes.addAll(p.consignes);
    if (consignes.isEmpty) return const SizedBox.shrink();

    // Découpe en lignes de 3 cellules
    final List<List<String>> lignes = [];
    for (int i = 0; i < consignes.length; i += 3) {
      lignes.add(consignes.sublist(i, i + 3 > consignes.length ? consignes.length : i + 3));
    }

    return _PanneauAccordeon(
      titre: 'CONSIGNES PRATIQUES',
      icone: Icons.assignment_outlined,
      couleurFond: const Color(0xFFEEF2FF),
      couleurBord: _C.indigoBord,
      couleurIcone: _C.indigo,
      couleurTitre: _C.indigoDark,
      couleurFondIcone: const Color(0xFFE0E7FF),
      labelBadge: '${consignes.length} consigne${consignes.length > 1 ? "s" : ""}',
      isDark: isDark,
      items: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            children: lignes.asMap().entries.map((entry) {
              final isLast = entry.key == lignes.length - 1;
              return Column(children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: entry.value.asMap().entries.map((e) {
                      final isLastInRow = e.key == entry.value.length - 1;
                      return Expanded(
                        child: Row(children: [
                          Expanded(
                            child: _CelluleConsigne(
                              texte: e.value,
                              icone: _iconeConsigne(e.value),
                              isDark: isDark,
                            ),
                          ),
                          if (!isLastInRow)
                            Container(width: 1, color: isDark ? _C.darkBorder : const Color(0xFFE0E7FF)),
                        ]),
                      );
                    }).toList(),
                  ),
                ),
                if (!isLast) Container(height: 1, color: isDark ? _C.darkBorder : const Color(0xFFE0E7FF)),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CelluleConsigne extends StatelessWidget {
  final String texte;
  final IconData icone;
  final bool isDark;
  const _CelluleConsigne({required this.texte, required this.icone, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icône circulaire
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: isDark ? _C.darkInput : const Color(0xFFEEF2FF),
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? _C.darkBorder : _C.indigoBord),
              ),
              child: Icon(icone, color: isDark ? const Color(0xFF38BDF8) : _C.indigo, size: 18),
            ),
            const SizedBox(width: 8),
            // Texte
            Expanded(
              child: Text(
                texte,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? _C.darkText : _C.indigoDark,
                  height: 1.35,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Flèche
            Icon(Icons.chevron_right_rounded, size: 16, color: isDark ? _C.darkBorder : _C.indigoBord),
          ],
        ),
      ),
    );
  }
}

// ─── Impact sur les médicaments ───────────────────────────────────────────────
class _PanneauImpactDrugs extends StatelessWidget {
  final Set<String> preferes;
  final Set<String> contreIndiques;
  final bool isDark;
  const _PanneauImpactDrugs({
    required this.preferes,
    required this.contreIndiques,
    required this.isDark,
  });

  static const Map<String, String> _noms = {
    'propofol': 'Propofol', 'ketamine': 'Kétamine', 'midazolam': 'Midazolam',
    'etomidate': 'Étomidate', 'thiopental': 'Thiopental',
    'dexmedetomidine': 'Dexmédétomidine', 'fentanyl': 'Fentanyl',
    'remifentanil': 'Rémifentanil', 'sufentanil': 'Sufentanil',
    'morphine': 'Morphine', 'rocuronium': 'Rocuronium',
    'atracurium': 'Atracurium', 'cisatracurium': 'Cisatracurium',
    'succinylcholine': 'Succinylcholine', 'noradrenaline': 'Noradrénaline',
    'adrenaline': 'Adrénaline', 'lidocaine': 'Lidocaïne',
    'cefazolin': 'Céfazoline', 'vancomycin': 'Vancomycine',
    'clindamycin': 'Clindamycine',
  };

  Widget _chip(String id, bool pref) {
    final bg = pref
        ? (isDark ? const Color(0xFF0F2618) : _C.vertFond)
        : (isDark ? const Color(0xFF2A1416) : _C.rougeFond);
    final bord = pref
        ? (isDark ? const Color(0xFF1E5230) : _C.vertBord)
        : (isDark ? const Color(0xFF5C1D24) : _C.rougeBord);
    final color = pref
        ? (isDark ? const Color(0xFF86EFAC) : _C.vertDark)
        : (isDark ? const Color(0xFFFCA5A5) : _C.rougeDark);
    return Container(
      margin: const EdgeInsets.only(right: 7, bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bord, width: 1.5),
      ),
      child: Text(
        _noms[id] ?? id,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (preferes.isEmpty && contreIndiques.isEmpty) return const SizedBox.shrink();

    // ── Fusion intelligente / détection de conflit (section 12) ──
    // Un médicament privilégié par une pathologie mais contre-indiqué par une
    // autre est un conflit : la contre-indication est toujours prioritaire.
    final conflits = preferes.intersection(contreIndiques);
    final preferesEffectifs = preferes.difference(conflits);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? _C.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? _C.darkBorder : _C.bordure),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: isDark ? _C.darkInput : _C.bleuFond,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.medical_services_outlined, color: _C.bleu, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'IMPACT SUR LES MÉDICAMENTS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFF38BDF8) : _C.bleu,
                letterSpacing: 0.3,
              ),
            ),
          ]),
        ),
        Divider(height: 1, color: isDark ? _C.darkBorder : _C.bordure),
        if (conflits.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A1416) : _C.rougeFond,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? const Color(0xFF5C1D24) : _C.rougeBord),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.report_gmailerrorred_rounded, color: _C.rouge, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Conflit détecté pour ${conflits.map((id) => _noms[id] ?? id).join(", ")} : '
                    'privilégié par une pathologie mais contre-indiqué par une autre. '
                    'La contre-indication est prioritaire.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? const Color(0xFFFCA5A5) : _C.rougeDark,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        // Corps — 2 colonnes
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Colonne privilégiés
            if (preferesEffectifs.isNotEmpty)
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.star_rounded, color: _C.vert, size: 13),
                    const SizedBox(width: 4),
                    const Text(
                      'PRIVILÉGIÉS',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _C.vert, letterSpacing: 0.4),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Wrap(children: preferesEffectifs.map((id) => _chip(id, true)).toList()),
                ]),
              ),
            if (preferesEffectifs.isNotEmpty && contreIndiques.isNotEmpty)
              const SizedBox(width: 12),
            // Colonne contre-indiqués
            if (contreIndiques.isNotEmpty)
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.cancel_rounded, color: _C.rouge, size: 13),
                    const SizedBox(width: 4),
                    const Text(
                      'CONTRE-INDIQUÉS',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _C.rouge, letterSpacing: 0.4),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Wrap(children: contreIndiques.map((id) => _chip(id, false)).toList()),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }
}

// ─── Carte Pensez à l'essentiel ───────────────────────────────────────────────
class _CarteEssentiel extends StatelessWidget {
  final List<Pathologie> selectionnees;
  final bool isDark;
  const _CarteEssentiel({required this.selectionnees, required this.isDark});

  String get _texte {
    final noms = selectionnees.map((p) => p.nom).join(' et ');
    return 'Équilibrer $noms : privilégier sédation stable, analgésie efficace et ventilation protectrice.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF16233A), const Color(0xFF1E1B4B)]
              : [_C.bleuFond, const Color(0xFFEDE9FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? _C.darkBorder : _C.bleuBord,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: _C.bleu,
            borderRadius: BorderRadius.circular(23),
          ),
          child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "PENSEZ À L'ESSENTIEL",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFF93C5FD) : _C.bleuDark,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _texte,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF7C72D8),
                height: 1.5,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  FICHE DÉTAILLÉE — BottomSheet Info (section 7)
// ═══════════════════════════════════════════════════════════════════════════════
class _FicheDetailSheet extends StatelessWidget {
  final Pathologie pathologie;
  final Color couleur;
  const _FicheDetailSheet({required this.pathologie, required this.couleur});

  @override
  Widget build(BuildContext context) {
    final p = pathologie;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? _C.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(children: [
            const SizedBox(height: 10),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: isDark ? _C.darkBorder : _C.bordClaire,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // ── En-tête ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: couleur.withOpacity(isDark ? 0.20 : 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(iconeCategorie(p.categorie), color: couleur, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      p.nom,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? _C.darkText : _C.textePrim,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(p.niveauRisque.emoji, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        p.niveauRisque.label,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: couleur),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '· Sévérité ${p.labelSeverite.toLowerCase()}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? _C.darkSub : _C.texteMuted,
                        ),
                      ),
                    ]),
                  ]),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: isDark ? _C.darkSub : _C.texteMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ]),
            ),
            Divider(height: 1, color: isDark ? _C.darkBorder : _C.bordure),
            // ── Corps scrollable ──
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  if (p.description.isNotEmpty)
                    _SectionFiche(
                      titre: 'Définition',
                      icone: Icons.description_outlined,
                      couleur: couleur,
                      texte: p.description,
                      isDark: isDark,
                    ),
                  if (p.physiopathologie.isNotEmpty)
                    _SectionFiche(
                      titre: 'Physiopathologie',
                      icone: Icons.biotech_rounded,
                      couleur: couleur,
                      texte: p.physiopathologie,
                      isDark: isDark,
                    ),
                  if (p.consequencesAnesthesiques.isNotEmpty)
                    _SectionFiche(
                      titre: 'Conséquences anesthésiques',
                      icone: Icons.medical_information_rounded,
                      couleur: couleur,
                      items: p.consequencesAnesthesiques,
                      isDark: isDark,
                    ),
                  if (p.alertes.isNotEmpty)
                    _SectionFiche(
                      titre: 'Risques peropératoires',
                      icone: Icons.warning_amber_rounded,
                      couleur: _C.rouge,
                      items: p.alertes,
                      isDark: isDark,
                    ),
                  if (p.surveillance.isNotEmpty)
                    _SectionFiche(
                      titre: 'Surveillance',
                      icone: Icons.monitor_heart_outlined,
                      couleur: couleur,
                      items: p.surveillance,
                      isDark: isDark,
                    ),
                  if (p.examensRecommandes.isNotEmpty)
                    _SectionFiche(
                      titre: 'Examens recommandés',
                      icone: Icons.science_outlined,
                      couleur: couleur,
                      items: p.examensRecommandes,
                      isDark: isDark,
                    ),
                  if (p.contreIndications.isNotEmpty)
                    _SectionFiche(
                      titre: 'Médicaments contre-indiqués',
                      icone: Icons.cancel_rounded,
                      couleur: _C.rouge,
                      items: p.contreIndications,
                      isDark: isDark,
                    ),
                  if (p.medicamentsAEviter.isNotEmpty)
                    _SectionFiche(
                      titre: 'Médicaments à utiliser avec prudence',
                      icone: Icons.error_outline_rounded,
                      couleur: const Color(0xFFF57C00),
                      items: p.medicamentsAEviter,
                      isDark: isDark,
                    ),
                  if (p.droguesFavorisees.isNotEmpty)
                    _SectionFiche(
                      titre: 'Médicaments recommandés',
                      icone: Icons.check_circle_outline_rounded,
                      couleur: _C.vert,
                      items: p.droguesFavorisees,
                      isDark: isDark,
                    ),
                  if (p.interactions.isNotEmpty)
                    _SectionFiche(
                      titre: 'Interactions',
                      icone: Icons.compare_arrows_rounded,
                      couleur: couleur,
                      items: p.interactions,
                      isDark: isDark,
                    ),
                  if (p.consignes.isNotEmpty)
                    _SectionFiche(
                      titre: 'Précautions',
                      icone: Icons.assignment_outlined,
                      couleur: couleur,
                      items: p.consignes,
                      isDark: isDark,
                    ),
                  if (p.references.isNotEmpty)
                    _SectionFiche(
                      titre: 'Bibliographie',
                      icone: Icons.menu_book_outlined,
                      couleur: isDark ? _C.darkSub : _C.texteSec,
                      items: p.references,
                      petit: true,
                      isDark: isDark,
                    ),
                  if (!p.aUneFicheDetaillee && p.description.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Aucune fiche détaillée n\'est encore renseignée pour cette pathologie.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? _C.darkSub : _C.texteMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}

/// Section générique de la fiche : titre + icône + soit un paragraphe
/// ([texte]), soit une liste à puces ([items]).
class _SectionFiche extends StatelessWidget {
  final String titre;
  final IconData icone;
  final Color couleur;
  final String? texte;
  final List<String>? items;
  final bool petit;
  final bool isDark;

  const _SectionFiche({
    required this.titre,
    required this.icone,
    required this.couleur,
    this.texte,
    this.items,
    this.petit = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icone, size: 16, color: couleur),
          const SizedBox(width: 6),
          Text(
            titre,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: couleur,
              letterSpacing: 0.2,
            ),
          ),
        ]),
        const SizedBox(height: 7),
        if (texte != null)
          Text(
            texte!,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFFCBD5E1) : _C.texteSec,
              height: 1.45,
            ),
          ),
        if (items != null)
          ...items!.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t,
                      style: TextStyle(
                        fontSize: petit ? 11 : 12.5,
                        color: isDark ? const Color(0xFFCBD5E1) : _C.texteSec,
                        height: 1.4,
                        fontStyle: petit ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                ]),
              )),
      ]),
    );
  }
}