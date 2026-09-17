// ============================================================================
//  lib/screens/courses_screen.dart
//  Medical Courses Screen — Academic Resources
// ============================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/ar_logo.dart';
import '../utils/theme.dart';

// ===========================================================
//  MODELS
// ===========================================================

@immutable
class Subject {
  final String       name;
  final IconData     icon;
  final List<String> links;
  const Subject({required this.name, required this.icon, required this.links});
}

@immutable
class Semester {
  final String        id;
  final String        label;
  final Color         accent;
  final Color         accentLight;
  final List<Subject> subjects;
  const Semester({
    required this.id,
    required this.label,
    required this.accent,
    required this.accentLight,
    required this.subjects,
  });
}

// ===========================================================
//  SEMESTERS DATA
// ===========================================================

final List<Semester> allSemesters = [
  Semester(
    id: 'S1', label: 'Semestre 1',
    accent: const Color(0xFF0F4C81), accentLight: const Color(0xFFEFF6FF),
    subjects: [
      Subject(name: 'Anatomie',      icon: Icons.biotech_outlined,         links: ['', '']),
      Subject(name: 'Physiologie',   icon: Icons.favorite_border,          links: ['']),
      Subject(name: 'Histologie',    icon: Icons.science_outlined,         links: ['', '']),
      Subject(name: 'Biochimie',     icon: Icons.science_outlined,         links: ['']),
      Subject(name: 'Biophysique',   icon: Icons.waves_outlined,           links: ['']),
      Subject(name: 'Embryologie',   icon: Icons.egg_alt_outlined,         links: ['']),
    ],
  ),
  Semester(
    id: 'S2', label: 'Semestre 2',
    accent: const Color(0xFF1F7AE0), accentLight: const Color(0xFFEFF6FF),
    subjects: [
      Subject(name: 'Anatomie',      icon: Icons.biotech_outlined,         links: ['', '']),
      Subject(name: 'Physiologie',   icon: Icons.favorite_border,          links: ['']),
      Subject(name: 'Histologie',    icon: Icons.science_outlined,         links: ['']),
      Subject(name: 'Biochimie',     icon: Icons.science_outlined,         links: ['', '']),
      Subject(name: 'Immunologie',   icon: Icons.shield_outlined,          links: ['']),
      Subject(name: 'Génétique',     icon: Icons.code_outlined,            links: ['']),
    ],
  ),
  Semester(
    id: 'S3', label: 'Semestre 3',
    accent: const Color(0xFF16A34A), accentLight: const Color(0xFFDCFCE7),
    subjects: [
      Subject(name: 'Sémiologie médicale',     icon: Icons.monitor_heart_outlined,   links: ['']),
      Subject(name: 'Sémiologie chirurgicale', icon: Icons.local_hospital_outlined,  links: ['']),
      Subject(name: 'Pharmacologie',           icon: Icons.medication_outlined,      links: ['', '']),
      Subject(name: 'Microbiologie',           icon: Icons.bug_report_outlined,      links: ['']),
      Subject(name: 'Pathologie générale',     icon: Icons.health_and_safety_outlined, links: ['']),
      Subject(name: 'Neurologie',              icon: Icons.psychology_outlined,      links: ['']),
    ],
  ),
  Semester(
    id: 'S4', label: 'Semestre 4',
    accent: const Color(0xFF8B5CF6), accentLight: const Color(0xFFF5F3FF),
    subjects: [
      Subject(name: 'Cardiologie',         icon: Icons.favorite_border,              links: ['', '']),
      Subject(name: 'Pneumologie',         icon: Icons.air_outlined,                 links: ['']),
      Subject(name: 'Gastro-entérologie',  icon: Icons.medical_services_outlined,    links: ['']),
      Subject(name: 'Néphrologie',         icon: Icons.water_drop_outlined,          links: ['']),
      Subject(name: 'Endocrinologie',      icon: Icons.monitor_outlined,             links: ['', '']),
      Subject(name: 'Hématologie',         icon: Icons.bloodtype_outlined,           links: ['']),
    ],
  ),
  Semester(
    id: 'S5', label: 'Semestre 5',
    accent: const Color(0xFFF59E0B), accentLight: const Color(0xFFFEF3C7),
    subjects: [
      Subject(name: 'Chirurgie générale',  icon: Icons.local_hospital_outlined,      links: ['']),
      Subject(name: 'Obstétrique',         icon: Icons.child_care_outlined,          links: ['', '']),
      Subject(name: 'Pédiatrie',           icon: Icons.child_friendly_outlined,      links: ['']),
      Subject(name: 'Dermatologie',        icon: Icons.face_outlined,                links: ['']),
      Subject(name: 'Ophtalmologie',       icon: Icons.visibility_outlined,          links: ['', '']),
      Subject(name: 'ORL',                 icon: Icons.hearing_outlined,             links: ['']),
    ],
  ),
  Semester(
    id: 'S6', label: 'Semestre 6',
    accent: const Color(0xFF0D9488), accentLight: const Color(0xFFCCFBF1),
    subjects: [
      Subject(name: 'Médecine interne',    icon: Icons.person_outline,               links: ['', '']),
      Subject(name: 'Psychiatrie',         icon: Icons.psychology_outlined,          links: ['']),
      Subject(name: 'Médecine légale',     icon: Icons.gavel_outlined,               links: ['']),
      Subject(name: 'Santé publique',      icon: Icons.public_outlined,              links: ['', '']),
      Subject(name: 'Rhumatologie',        icon: Icons.accessibility_new_outlined,   links: ['']),
      Subject(name: 'Urgences',            icon: Icons.emergency_outlined,           links: ['', '']),
    ],
  ),
];

// ===========================================================
//  COURS SCREEN
// ===========================================================

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _query = '';

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lien non disponible pour l\'instant.')),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible d\'ouvrir $url');
    }
  }

  List<Semester> get _filtered {
    if (_query.isEmpty) return allSemesters;
    final q = _query.toLowerCase();
    return allSemesters
        .map((sem) => Semester(
              id: sem.id, label: sem.label,
              accent: sem.accent, accentLight: sem.accentLight,
              subjects: sem.subjects
                  .where((s) => s.name.toLowerCase().contains(q))
                  .toList(),
            ))
        .where((sem) =>
            sem.subjects.isNotEmpty ||
            sem.id.toLowerCase().contains(q) ||
            sem.label.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = context.backgroundColor;
    final cardBg = context.surfaceColor;
    final textP = context.textColor;
    final textS = context.textMutedColor;
    final borderC = context.borderColor;
    final inputBg = dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  bottom: BorderSide(
                    color: borderC,
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge icône
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: dark
                          ? const Color(0xFF1E1B4B)
                          : const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Color(0xFF8B5CF6),
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
                          'Cours médicaux',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: textP,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ressources académiques de référence',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: textS,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Barre de recherche compacte
                  SizedBox(
                    width: 200,
                    child: _CompactSearchBar(
                      query: _query,
                      isDark: dark,
                      onChanged: (v) => setState(() => _query = v),
                      onClear: () => setState(() => _query = ''),
                    ),
                  ),
                ],
              ),
            ),
            // ── Liste semestres ──────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SemesterCard(
                    semester: _filtered[i],
                    onLaunch: _openUrl,
                    initiallyExpanded: i == 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Carte Semestre ────────────────────────────────────────────
class _SemesterCard extends StatefulWidget {
  final Semester semester;
  final Future<void> Function(String) onLaunch;
  final bool initiallyExpanded;
  const _SemesterCard({
    required this.semester,
    required this.onLaunch,
    this.initiallyExpanded = false,
  });
  @override
  State<_SemesterCard> createState() => _SemesterCardState();
}

class _SemesterCardState extends State<_SemesterCard>
    with SingleTickerProviderStateMixin {
  late bool _open;
  late AnimationController _ctrl;
  late Animation<double> _rot;

  @override
  void initState() {
    super.initState();
    _open = widget.initiallyExpanded;
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _rot = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    if (_open) _ctrl.value = 1.0;
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final sem = widget.semester;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = context.cardColor;
    final borderC = context.borderColor;
    final textP = context.textColor;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.card,
        border: Border.all(color: borderC, width: 0.8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            child: Container(
              color: _open ? sem.accentLight.withOpacity(dark ? 0.08 : 0.4) : null,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: sem.accentLight.withOpacity(dark ? 0.15 : 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(sem.id,
                        style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w800,
                          color: dark ? const Color(0xFF38BDF8) : sem.accent,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sem.id,
                            style: TextStyle(
                              fontSize: 15.5, fontWeight: FontWeight.w800,
                              color: textP,
                            )),
                        Text(sem.label,
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600,
                              color: dark ? const Color(0xFF38BDF8) : sem.accent,
                            )),
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: _rot,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: textP.withOpacity(0.4), size: 22),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: sem.subjects.map((s) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _SubjectCard(
                      subject: s, semester: sem, onLaunch: widget.onLaunch),
                )).toList(),
              ),
            ),
            crossFadeState: _open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

// ── Carte Matière ─────────────────────────────────────────────
class _SubjectCard extends StatefulWidget {
  final Subject  subject;
  final Semester semester;
  final Future<void> Function(String) onLaunch;
  const _SubjectCard({
    required this.subject,
    required this.semester,
    required this.onLaunch,
  });
  @override
  State<_SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<_SubjectCard>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _rot;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _rot = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final sem   = widget.semester;
    final sub   = widget.subject;
    final count = sub.links.where((l) => l.isNotEmpty).length;
    final dark  = Theme.of(context).brightness == Brightness.dark;

    final subCardBg = dark ? const Color(0xFF1E293B) : const Color(0xFFFAFAFA);
    final textP = context.textColor;
    final textS = context.textMutedColor;
    final borderC = context.borderColor;

    return Container(
      decoration: BoxDecoration(
        color: subCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: borderC, width: 0.8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: sem.accentLight.withOpacity(dark ? 0.15 : 1.0),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(sub.icon, color: dark ? const Color(0xFF38BDF8) : sem.accent, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sub.name,
                            style: TextStyle(
                              fontSize: 13.5, fontWeight: FontWeight.w700,
                              color: textP,
                            )),
                        Text(
                          count == 0
                              ? '0 cours disponible'
                              : '$count cours disponible${count > 1 ? 's' : ''}',
                          style: TextStyle(
                              fontSize: 11, color: textS),
                        ),
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: _rot,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: count == 0
                            ? borderC
                            : textS,
                        size: 20),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Column(
                children: List.generate(sub.links.length, (i) {
                  final url = sub.links[i];
                  final linkBg = dark ? const Color(0xFF0F172A) : Colors.white;

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: InkWell(
                      onTap: () => widget.onLaunch(url),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: linkBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: borderC,
                              width: 0.8),
                        ),
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Row(
                          children: [
                            Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                  Icons.insert_drive_file_outlined,
                                  color: Color(0xFF1F7AE0), size: 14),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cours ${i + 1}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: textP,
                                      )),
                                  Text(
                                    url.isEmpty ? 'Lien à venir' : url,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: textS),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.open_in_new_rounded,
                                      color: Color(0xFF1F7AE0), size: 13),
                                  SizedBox(width: 4),
                                  Text('Ouvrir',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F7AE0),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            crossFadeState: _open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  SEARCH BAR — style identique à Emergency
// ════════════════════════════════════════════════════════════════════════════
class _CompactSearchBar extends StatefulWidget {
  final String query;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const _CompactSearchBar({
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
  final TextEditingController _controller = TextEditingController();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query;
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void didUpdateWidget(_CompactSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final fieldBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final txtP    = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final txtHint = isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8);
    const accentColor = Color(0xFF8B5CF6);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final hasText = _controller.text.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focused
                  ? accentColor.withOpacity(0.35)
                  : borderColor,
              width: _focused ? 1.4 : 1,
            ),
            boxShadow: _focused
                ? [BoxShadow(
                    color: accentColor.withOpacity(0.08),
                    blurRadius: 0,
                    spreadRadius: 4,
                  )]
                : [],
          ),
          child: Row(children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, size: 19,
                color: _focused || hasText ? accentColor : txtHint),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                onChanged: widget.onChanged,
                style: TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600, color: txtP),
                cursorColor: accentColor,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(
                      fontSize: 13.5, color: txtHint, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            if (hasText)
              GestureDetector(
                onTap: () {
                  _controller.clear();
                  widget.onClear();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 28, height: 28,
                  margin: const EdgeInsets.only(right: 9),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F3F7),
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
    );
  }
}