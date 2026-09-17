// ============================================================
//  lib/screens/protocols_screen.dart
//  VERSION 2.1 — Fix imports + alias pour éviter conflits
// ============================================================

import 'package:flutter/material.dart';
import '../data/urgency_protocols_data.dart' as urgency;
import '../data/insufficiency_protocols_data.dart' as insufficiency;
import '../models/emergency_drug.dart';

// ── Palette ──────────────────────────────────────────────────
class _C {
  static const bleu        = Color(0xFF1F7AE0);
  static const bleuFond    = Color(0xFFEFF6FF);
  static const bleuBord    = Color(0xFFBFDBFE);
  static const rouge       = Color(0xFFEF4444);
  static const rougeFond   = Color(0xFFFEE2E2);
  static const rougeBord   = Color(0xFFFCA5A5);
  static const orange      = Color(0xFFF59E0B);
  static const orangeFond  = Color(0xFFFEF3C7);
  static const orangeBord  = Color(0xFFFCD34D);
  static const vert        = Color(0xFF22C55E);
  static const vertFond    = Color(0xFFDCFCE7);
  static const vertBord    = Color(0xFF86EFAC);
  static const fondPage    = Color(0xFFF8FAFC);
  static const bordure     = Color(0xFFE2E8F0);
  static const textePrim   = Color(0xFF0F172A);
  static const texteSec    = Color(0xFF475569);
  static const texteMuted  = Color(0xFF94A3B8);
  static const darkBg      = Color(0xFF08111F);

  // ── Palette dédiée au header premium (spec Linear/Vercel/Notion) ──
  static const headerAccent      = Color(0xFFFF4D4F);
  static const headerAccentSoft  = Color(0xFFFFF5F5);
  static const headerGradStart   = Color(0xFFFFF2F2);
  static const headerGradEnd     = Color(0xFFFFE8E8);
  static const headerTitle       = Color(0xFF101828);
  static const headerSubtitle    = Color(0xFF667085);
  static const headerBorder      = Color(0xFFECEFF5);
  static const headerFieldBorder = Color(0xFFE6EAF2);
  static const headerPlaceholder = Color(0xFF98A2B3);
  static const headerDivider     = Color(0xFFF1F3F7);
  static const headerHover       = Color(0xFFF9FAFB);
  static const darkCard    = Color(0xFF0F172A);
  static const darkBorder  = Color(0xFF334155);
  static const darkText    = Color(0xFFF8FAFC);
  static const darkSub     = Color(0xFF94A3B8);
}

// ── Helpers couleur depuis colorKey ──────────────────────────
Color _mainColor(String key) {
  switch (key) {
    case 'red':    return _C.rouge;
    case 'orange': return _C.orange;
    case 'blue':   return _C.bleu;
    case 'green':  return _C.vert;
    default:       return _C.bleu;
  }
}
Color _bgColor(String key) {
  switch (key) {
    case 'red':    return _C.rougeFond;
    case 'orange': return _C.orangeFond;
    case 'blue':   return _C.bleuFond;
    case 'green':  return _C.vertFond;
    default:       return _C.bleuFond;
  }
}
Color _borderColor(String key) {
  switch (key) {
    case 'red':    return _C.rougeBord;
    case 'orange': return _C.orangeBord;
    case 'blue':   return _C.bleuBord;
    case 'green':  return _C.vertBord;
    default:       return _C.bleuBord;
  }
}
IconData _iconForEmoji(String emoji) {
  switch (emoji) {
    case '🫀': return Icons.monitor_heart_rounded;
    case '🫁': return Icons.air_rounded;
    case '⚠️': return Icons.warning_amber_rounded;
    case '🩸': return Icons.water_drop_rounded;
    case '🧠': return Icons.psychology_rounded;
    case '🫘': return Icons.science_rounded;
    case '🫔': return Icons.medical_services_rounded;
    case '🦴': return Icons.medication_rounded;
    case '🦠': return Icons.coronavirus_rounded;
    case '🌡️': return Icons.thermostat_rounded;
    case '🍬': return Icons.local_hospital_rounded;
    case '💨': return Icons.air_rounded;
    default:   return Icons.emergency_rounded;
  }
}

// ============================================================
//  ÉCRAN PRINCIPAL
// ============================================================
class ProtocolsScreen extends StatefulWidget {
  const ProtocolsScreen({super.key});
  @override
  State<ProtocolsScreen> createState() => _ProtocolsScreenState();
}

class _ProtocolsScreenState extends State<ProtocolsScreen> {
  int _onglet = 0;
  EmergencyProtocol? _detail;
  final TextEditingController _searchCtrl = TextEditingController();
  String _recherche = '';

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  // ── Listes locales (pas d'import ambigu) ─────────────────
  List<EmergencyProtocol> get _urgencyList =>
      urgency.urgencyProtocols;
  List<EmergencyProtocol> get _insufficiencyList =>
      insufficiency.insufficiencyProtocols;

  // ── Filtrage par nom (titre + sous-titre) ────────────────
  List<EmergencyProtocol> _filtrer(List<EmergencyProtocol> source) {
    final q = _recherche.trim().toLowerCase();
    if (q.isEmpty) return source;
    return source.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.subtitle.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isDark ? _C.darkBg : _C.fondPage;
    final urgencyFiltered = _filtrer(_urgencyList);
    final insufficiencyFiltered = _filtrer(_insufficiencyList);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: _detail != null
            ? _EcranDetail(
                protocol: _detail!,
                isDark: _isDark,
                onBack: () => setState(() => _detail = null),
              )
            : Column(children: [
                _EnTete(
                  onglet: _onglet,
                  isDark: _isDark,
                  onChanger: (i) => setState(() => _onglet = i),
                  searchCtrl: _searchCtrl,
                  onSearchChanged: (v) => setState(() => _recherche = v),
                  onSearchClear: () => setState(() {
                    _searchCtrl.clear();
                    _recherche = '';
                  }),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: _onglet == 0
                        ? _ListeProtocoles(
                            key: const ValueKey(0),
                            protocoles: urgencyFiltered,
                            isDark: _isDark,
                            recherche: _recherche,
                            onSelect: (p) => setState(() => _detail = p),
                          )
                        : _ListeProtocoles(
                            key: const ValueKey(1),
                            protocoles: insufficiencyFiltered,
                            isDark: _isDark,
                            recherche: _recherche,
                            onSelect: (p) => setState(() => _detail = p),
                          ),
                  ),
                ),
              ]),
      ),
    );
  }
}

// ============================================================
//  EN-TÊTE avec 2 onglets
// ============================================================
class _EnTete extends StatelessWidget {
  final int onglet;
  final bool isDark;
  final ValueChanged<int> onChanger;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  const _EnTete({
    required this.onglet,
    required this.isDark,
    required this.onChanger,
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.onSearchClear,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? _C.darkCard : Colors.white;
    final dividerC = isDark ? _C.darkBorder : _C.headerDivider;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: dividerC, width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 760;

          if (wide) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge icône
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? _C.headerAccent.withValues(alpha: 0.14)
                          : _C.headerAccentSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.emergency_rounded,
                        color: _C.headerAccent, size: 22),
                  ),
                  const SizedBox(width: 10),
                  // Titre + sous-titre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Urgences & Protocoles',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: isDark ? _C.darkText : _C.headerTitle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Protocoles cliniques de référence',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? _C.darkSub : _C.headerSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Onglets
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: isDark ? _C.darkBg.withValues(alpha: 0.4) : _C.fondPage,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(children: [
                      _Onglet(
                        label: 'Urgences',
                        icone: Icons.emergency_rounded,
                        actif: onglet == 0,
                        couleur: _C.headerAccent,
                        couleurFond: _C.headerAccentSoft,
                        isDark: isDark,
                        onTap: () => onChanger(0),
                      ),
                      const SizedBox(width: 6),
                      _Onglet(
                        label: 'Insuffisances/Choc',
                        icone: Icons.medical_services_rounded,
                        actif: onglet == 1,
                        couleur: _C.bleu,
                        couleurFond: _C.bleuFond,
                        isDark: isDark,
                        onTap: () => onChanger(1),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 16),
                  // Barre de recherche compacte
                  SizedBox(
                    width: 200,
                    child: _BarreRecherche(
                      controller: searchCtrl,
                      isDark: isDark,
                      onChanged: onSearchChanged,
                      onClear: onSearchClear,
                    ),
                  ),
                ],
              ),
            );
          }

          // Mode compact/mobile (2 lignes)
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Ligne titre — identique au header Drugs / Pathologies ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge icône
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? _C.headerAccent.withValues(alpha: 0.14)
                          : _C.headerAccentSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.emergency_rounded,
                        color: _C.headerAccent, size: 22),
                  ),
                  const SizedBox(width: 10),
                  // Titre + sous-titre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Urgences & Protocoles',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: isDark ? _C.darkText : _C.headerTitle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Protocoles cliniques de référence',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? _C.darkSub : _C.headerSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Barre de recherche compacte
                  SizedBox(
                    width: 160,
                    child: _BarreRecherche(
                      controller: searchCtrl,
                      isDark: isDark,
                      onChanged: onSearchChanged,
                      onClear: onSearchClear,
                    ),
                  ),
                ],
              ),
            ),
            // ── Onglets ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? _C.darkBg.withValues(alpha: 0.4) : _C.fondPage,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(5),
                child: Row(children: [
                  _Onglet(
                    label: 'Urgences',
                    icone: Icons.emergency_rounded,
                    actif: onglet == 0,
                    couleur: _C.headerAccent,
                    couleurFond: _C.headerAccentSoft,
                    isDark: isDark,
                    onTap: () => onChanger(0),
                  ),
                  const SizedBox(width: 6),
                  _Onglet(
                    label: 'Insuffisances/Choc',
                    icone: Icons.medical_services_rounded,
                    actif: onglet == 1,
                    couleur: _C.bleu,
                    couleurFond: _C.bleuFond,
                    isDark: isDark,
                    onTap: () => onChanger(1),
                  ),
                ]),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

// ── Bloc icône + titre + sous-titre ──────────────────────────
class _TitreBloc extends StatelessWidget {
  final bool isDark;
  const _TitreBloc({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  colors: [_C.headerGradStart, _C.headerGradEnd],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
          color: isDark ? _C.headerAccent.withValues(alpha: 0.14) : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.emergency_rounded, color: _C.headerAccent, size: 26),
      ),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Urgences & Protocoles',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: isDark ? _C.darkText : _C.headerTitle,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Protocoles cliniques de référence',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: isDark ? _C.darkSub : _C.headerSubtitle,
          ),
        ),
      ]),
    ]);
  }
}

// ============================================================
//  BARRE DE RECHERCHE
// ============================================================
class _BarreRecherche extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final double maxWidth;
  const _BarreRecherche({
    required this.controller,
    required this.isDark,
    required this.onChanged,
    required this.onClear,
    this.maxWidth = double.infinity,
  });

  @override
  State<_BarreRecherche> createState() => _BarreRechercheState();
}

class _BarreRechercheState extends State<_BarreRecherche> {
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
    final isDark = widget.isDark;
    final fieldBg = isDark ? const Color(0xFF16233A) : Colors.white;
    final borderC = _focused
        ? _C.headerAccentSoft
        : (isDark ? _C.darkBorder : _C.headerFieldBorder);
    final txtP    = isDark ? _C.darkText : _C.headerTitle;
    final txtHint = isDark ? _C.darkSub  : _C.headerPlaceholder;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final hasText = widget.controller.text.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 46,
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _focused
                    ? _C.headerAccent.withValues(alpha: 0.35)
                    : borderC,
                width: _focused ? 1.4 : 1,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: _C.headerAccent.withValues(alpha: 0.08),
                        blurRadius: 0,
                        spreadRadius: 4,
                      ),
                    ]
                  : [],
            ),
            child: Row(children: [
              const SizedBox(width: 14),
              Icon(Icons.search_rounded, size: 19,
                  color: _focused || hasText ? _C.headerAccent : txtHint),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  onChanged: widget.onChanged,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: txtP),
                  cursorColor: _C.headerAccent,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Rechercher un protocole…',
                    hintStyle: TextStyle(fontSize: 13.5, color: txtHint, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              if (hasText)
                GestureDetector(
                  onTap: widget.onClear,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 28, height: 28,
                    margin: const EdgeInsets.only(right: 9),
                    decoration: BoxDecoration(
                      color: isDark ? _C.darkBorder : const Color(0xFFF1F3F7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 14, color: txtP),
                  ),
                )
              else
                const SizedBox(width: 14),
            ]),
          );
        },
      ),
    );
  }
}

class _Onglet extends StatelessWidget {
  final String label;
  final IconData icone;
  final bool actif;
  final Color couleur;
  final Color couleurFond;
  final bool isDark;
  final VoidCallback onTap;
  const _Onglet({
    required this.label, required this.icone, required this.actif,
    required this.couleur, required this.couleurFond,
    required this.isDark, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: actif
                  ? (isDark ? couleur.withValues(alpha: 0.14) : couleurFond)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(icone, size: 16,
                    color: actif ? couleur : (isDark ? _C.darkSub : _C.texteMuted)),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: actif ? FontWeight.w700 : FontWeight.w500,
                      color: actif ? couleur : (isDark ? _C.darkSub : _C.texteMuted),
                    )),
                ),
              ]),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: actif ? 40 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: couleur,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  LISTE DES PROTOCOLES
// ============================================================
class _ListeProtocoles extends StatelessWidget {
  final List<EmergencyProtocol> protocoles;
  final bool isDark;
  final String recherche;
  final void Function(EmergencyProtocol) onSelect;
  const _ListeProtocoles({
    super.key, required this.protocoles,
    required this.isDark, required this.recherche, required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom + 90;

    if (protocoles.isEmpty) {
      return _AucunResultat(isDark: isDark, recherche: recherche);
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(14, 14, 14, bottomPad),
      itemCount: protocoles.length,
      itemBuilder: (_, i) => _CarteProtocole(
        protocol: protocoles[i],
        isDark: isDark,
        onTap: () => onSelect(protocoles[i]),
        delay: Duration(milliseconds: 18 * i),
      ),
    );
  }
}

// ── État vide (aucun résultat de recherche) ──────────────────
class _AucunResultat extends StatelessWidget {
  final bool isDark;
  final String recherche;
  const _AucunResultat({required this.isDark, required this.recherche});

  @override
  Widget build(BuildContext context) {
    final txtP = isDark ? _C.darkText : _C.textePrim;
    final txtS = isDark ? _C.darkSub  : _C.texteMuted;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: isDark ? _C.darkBorder : const Color(0xFFF0F0F8),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded, size: 30, color: txtS),
          ),
          const SizedBox(height: 14),
          Text('Aucun protocole trouvé',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: txtP)),
          const SizedBox(height: 4),
          Text('Aucun résultat pour « $recherche »',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: txtS)),
        ]),
      ),
    );
  }
}

// ── Carte protocole (nom uniquement — détail complet au tap) ──
class _CarteProtocole extends StatefulWidget {
  final EmergencyProtocol protocol;
  final bool isDark;
  final VoidCallback onTap;
  final Duration delay;
  const _CarteProtocole({
    required this.protocol, required this.isDark, required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  State<_CarteProtocole> createState() => _CarteProtocoleState();
}

class _CarteProtocoleState extends State<_CarteProtocole> with TickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressAnim;
  late final AnimationController _entryCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100),
    );
    _pressAnim = Tween<double>(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));

    _entryCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 320),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    final capped = widget.delay > const Duration(milliseconds: 240)
        ? const Duration(milliseconds: 240)
        : widget.delay;
    Future.delayed(capped, () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p      = widget.protocol;
    final isDark = widget.isDark;
    final color  = _mainColor(p.colorKey);
    final bg     = _bgColor(p.colorKey);
    final bord   = _borderColor(p.colorKey);
    final cardBg = isDark ? _C.darkCard : Colors.white;
    final txtP   = isDark ? _C.darkText : _C.textePrim;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: AnimatedBuilder(
          animation: _pressAnim,
          builder: (_, child) => Transform.scale(scale: _pressAnim.value, child: child),
          child: GestureDetector(
            onTapDown: (_) => _pressCtrl.forward(),
            onTapUp: (_) => _pressCtrl.reverse(),
            onTapCancel: () => _pressCtrl.reverse(),
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? _C.darkBorder : _C.bordure),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8, offset: const Offset(0, 2)),
                      ],
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? color.withValues(alpha: 0.15)
                        : bg,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: bord),
                  ),
                  child: Icon(_iconForEmoji(p.emoji), color: color, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p.title,
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: txtP)),
                    const SizedBox(height: 2),
                    Text(p.subtitle,
                        style: TextStyle(fontSize: 11.5,
                            color: isDark ? _C.darkSub : color.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w500),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                )),
                const SizedBox(width: 8),
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: isDark ? color.withValues(alpha: 0.12) : bg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      size: 12, color: color),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  ÉCRAN DÉTAIL PROTOCOLE
// ============================================================
class _EcranDetail extends StatelessWidget {
  final EmergencyProtocol protocol;
  final bool isDark;
  final VoidCallback onBack;
  const _EcranDetail({
    required this.protocol, required this.isDark, required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final p       = protocol;
    final color   = _mainColor(p.colorKey);
    final bg      = _bgColor(p.colorKey);
    final bord    = _borderColor(p.colorKey);
    final pageBg  = isDark ? _C.darkBg   : _C.fondPage;
    final cardBg  = isDark ? _C.darkCard : Colors.white;
    final txtP    = isDark ? _C.darkText : _C.textePrim;
    final txtS    = isDark ? _C.darkSub  : _C.texteSec;
    final divBord = isDark ? _C.darkBorder : _C.bordure;
    final bottomPad = MediaQuery.of(context).padding.bottom + 20;

    return Scaffold(
      backgroundColor: pageBg,
      body: Column(children: [
        // Header
        Container(
          color: cardBg,
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 17, color: txtP),
              onPressed: onBack,
            ),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: bord),
              ),
              child: Icon(_iconForEmoji(p.emoji), color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title, style: TextStyle(fontSize: 14,
                  fontWeight: FontWeight.w700, color: txtP)),
              Text(p.subtitle, style: TextStyle(fontSize: 11,
                  color: color, fontWeight: FontWeight.w600)),
            ])),
          ]),
        ),

        Expanded(child: ListView(
          padding: EdgeInsets.fromLTRB(14, 14, 14, bottomPad),
          children: [

            // ÉTAPES
            _TitreSection('Étapes du protocole', color: color, isDark: isDark),
            const SizedBox(height: 8),
            ...p.steps.map((step) => Container(
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: divBord),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('${step.stepNumber}',
                      style: TextStyle(fontSize: 12,
                          fontWeight: FontWeight.w800, color: color))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(step.title, style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700, color: txtP)),
                  const SizedBox(height: 3),
                  Text(step.detail, style: TextStyle(fontSize: 12,
                      color: txtS, height: 1.4)),
                ])),
              ]),
            )),

            const SizedBox(height: 14),

            // MÉDICAMENTS
            _TitreSection('Médicaments', color: color, isDark: isDark),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: divBord),
              ),
              child: Column(children: p.drugs.asMap().entries.map((e) {
                final i = e.key;
                final d = e.value;
                return Container(
                  padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                  decoration: BoxDecoration(
                    border: i < p.drugs.length - 1
                        ? Border(bottom: BorderSide(color: divBord))
                        : null,
                  ),
                  child: Row(children: [
                    Container(
                      width: 8, height: 8,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: d.isFirstLine ? color : _C.texteMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(d.name, style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w700, color: txtP)),
                        if (d.isFirstLine) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('1ère ligne',
                                style: TextStyle(fontSize: 9.5,
                                    color: color, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 2),
                      Text('${d.fixedDose}  ·  ${d.route}',
                          style: TextStyle(fontSize: 11.5, color: txtS)),
                      if (d.notes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(d.notes,
                              style: TextStyle(fontSize: 11,
                                  color: color.withValues(alpha: 0.75),
                                  fontStyle: FontStyle.italic)),
                        ),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: bord),
                      ),
                      child: Text(d.fixedDose,
                          style: TextStyle(fontSize: 11,
                              fontWeight: FontWeight.w700, color: color)),
                    ),
                  ]),
                );
              }).toList()),
            ),

            const SizedBox(height: 14),

            // Disclaimer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? _C.darkBorder : const Color(0xFFF0F0F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, size: 14, color: txtS),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Usage éducatif uniquement. Toujours vérifier avec les protocoles locaux.',
                  style: TextStyle(fontSize: 11, color: txtS, height: 1.4),
                )),
              ]),
            ),
          ],
        )),
      ]),
    );
  }
}

// ── Widget titre de section ───────────────────────────────────
class _TitreSection extends StatelessWidget {
  final String text;
  final Color color;
  final bool isDark;
  const _TitreSection(this.text, {required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 3, height: 15,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(2)),
      ),
      Text(text, style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: isDark ? _C.darkText : _C.textePrim)),
    ]);
  }
}