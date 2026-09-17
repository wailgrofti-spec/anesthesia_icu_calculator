// ============================================================
//  lib/screens/patient_screen.dart
//  Nouvelle structure : Inputs → Cliniques → Calculés → Notes
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/patient.dart';
import '../providers/app_provider.dart';
import '../services/pediatric_validation_service.dart';
import '../utils/theme.dart';
import '../widgets/common.dart';
import '../widgets/ar_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Palette locale ──────────────────────────────────────────────────────────
class _PC {
  static const bg           = Color(0xFFF8FAFC);
  static const card         = Color(0xFFFFFFFF);
  static const inputFill    = Color(0xFFF1F5F9);
  static const accent       = Color(0xFF1F7AE0);
  static const accentLight  = Color(0xFFEFF6FF);
  static const accentMid    = Color(0xFFBFDBFE);
  static const textPrimary  = Color(0xFF0F172A);
  static const textSecond   = Color(0xFF475569);
  static const success      = Color(0xFF22C55E);
  static const warning      = Color(0xFFF59E0B);
  static const danger       = Color(0xFFEF4444);
  static const shadow       = Color(0x0A000000);

  // dark variants
  static const darkBg       = Color(0xFF08111F);
  static const darkCard     = Color(0xFF0F172A);
  static const darkInput    = Color(0xFF1E293B);
  static const darkBorder   = Color(0xFF334155);
  static const darkText     = Color(0xFFF8FAFC);
  static const darkTextSub  = Color(0xFF94A3B8);
}
// ─────────────────────────────────────────────────────────────────────────────

// ═══════════════════════════════════════════════════════════════════════════
//  DONNÉES CLINIQUES (ASA / Mallampati)
// ═══════════════════════════════════════════════════════════════════════════

enum AsaScore { I, II, III, IV }
enum MallampatiScore { I, II, III, IV }

extension AsaExt on AsaScore {
  String get label {
    switch (this) {
      case AsaScore.I:   return 'Bonne santé';
      case AsaScore.II:  return 'Maladie légère';
      case AsaScore.III: return 'Maladie sévère';
      case AsaScore.IV:  return 'Risque vital';
    }
  }
  String get roman {
    switch (this) {
      case AsaScore.I:   return 'I';
      case AsaScore.II:  return 'II';
      case AsaScore.III: return 'III';
      case AsaScore.IV:  return 'IV';
    }
  }
}

extension MallExt on MallampatiScore {
  String get label {
    switch (this) {
      case MallampatiScore.I:   return 'Toute la gorge visible';
      case MallampatiScore.II:  return 'Luette partiellement visible';
      case MallampatiScore.III: return 'Voile du palais et base de la luette visibles';
      case MallampatiScore.IV:  return 'Palais osseux uniquement';
    }
  }
  String get roman {
    switch (this) {
      case MallampatiScore.I:   return 'I';
      case MallampatiScore.II:  return 'II';
      case MallampatiScore.III: return 'III';
      case MallampatiScore.IV:  return 'IV';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  SCREEN PRINCIPAL
// ═══════════════════════════════════════════════════════════════════════════

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});
  @override State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen>
    with SingleTickerProviderStateMixin {

  // ── Controllers inputs ──────────────────────────────────────────────────
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _ageCtrl    = TextEditingController();
  final _jeunCtrl   = TextEditingController();

  Sex?             _sex;
  AgeUnit          _ageUnit = AgeUnit.years;
  AsaScore?        _asa;
  MallampatiScore? _mallampati;
  bool             _init = false;

  // ── Utilisateur ─────────────────────────────────────────────────────────
  String _userPrenom = '';
  String _userGenre  = 'homme';

  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userPrenom = prefs.getString('user_prenom') ?? '';
      _userGenre  = prefs.getString('user_genre')  ?? 'homme';
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_init) {
      final p = context.read<AppProvider>().patient;
      if (p.weight   != null) _weightCtrl.text = p.weight!.toStringAsFixed(1);
      if (p.height   != null) _heightCtrl.text = p.height!.toStringAsFixed(0);
      if (p.ageValue != null) {
        _ageCtrl.text = (p.ageValue! == p.ageValue!.roundToDouble())
            ? p.ageValue!.toStringAsFixed(0)
            : p.ageValue!.toStringAsFixed(1);
      }
      _ageUnit = p.ageUnit;
      _sex  = p.sex;
      _init = true;
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose(); _heightCtrl.dispose();
    _ageCtrl.dispose();    _jeunCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _update() => context.read<AppProvider>().updatePatient(
    weight:   double.tryParse(_weightCtrl.text),
    height:   double.tryParse(_heightCtrl.text),
    ageValue: double.tryParse(_ageCtrl.text.replaceAll(',', '.')),
    ageUnit:  _ageUnit,
    sex:      _sex,
  );

  void _onAgeUnitChanged(AgeUnit newUnit) {
    if (newUnit == _ageUnit) return;
    // Convertit la valeur affichée pour rester cohérente avec la nouvelle unité
    final current = double.tryParse(_ageCtrl.text.replaceAll(',', '.'));
    if (current != null) {
      final tempPatient = Patient(ageValue: current, ageUnit: _ageUnit);
      double converted;
      switch (newUnit) {
        case AgeUnit.years:
          converted = tempPatient.ageInYears!;
          break;
        case AgeUnit.months:
          converted = tempPatient.ageInMonths!;
          break;
        case AgeUnit.days:
          converted = tempPatient.ageInDays!;
          break;
      }
      final rounded = double.parse(converted.toStringAsFixed(1));
      _ageCtrl.text = (rounded == rounded.roundToDouble())
          ? rounded.toStringAsFixed(0)
          : rounded.toStringAsFixed(1);
    }
    setState(() => _ageUnit = newUnit);
    _update();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg      => _isDark ? _PC.darkBg   : _PC.bg;
  Color get _cardBg  => _isDark ? _PC.darkCard  : _PC.card;
  Color get _txtMain => _isDark ? _PC.darkText  : _PC.textPrimary;
  Color get _txtSub  => _isDark ? _PC.darkTextSub : _PC.textSecond;

  // ── BUILD ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final patient  = provider.patient;

    return Scaffold(
      backgroundColor: _bg,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            slivers: [
              _buildHeader(provider, patient),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),

                    // ① INPUT  (Poids / Taille / Âge / Sexe)
                    // La bannière pédiatrique s'affiche toujours en mode
                    // pédiatrique (contexte informatif) ; en mode adulte,
                    // elle n'apparaît que si une valeur saisie est
                    // physiologiquement incohérente (ex : 1 kg pour un
                    // adulte) — on n'ajoute pas de bruit visuel sinon.
                    Builder(builder: (_) {
                      final validation = PediatricValidationService.validateAll(patient);
                      final showBanner = provider.isPediatricMode || !validation.isNormal;
                      if (!showBanner) return const SizedBox.shrink();

                      final bannerColor = validation.isDanger
                          ? _PC.danger
                          : (validation.isWarning ? _PC.warning : const Color(0xFF38BDF8));
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: _isDark ? const Color(0xFF0F1E29) : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: bannerColor, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  provider.isPediatricMode
                                      ? Icons.child_care_rounded
                                      : Icons.fact_check_outlined,
                                  color: const Color(0xFF1F7AE0),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    provider.isPediatricMode
                                        ? 'Mode Pédiatrique Actif : Doses calculées spécifiquement pour l\'enfant.'
                                        : 'Vérification des données patient',
                                    style: TextStyle(
                                      color: _isDark ? const Color(0xFF38BDF8) : const Color(0xFF0F4C81),
                                      fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            if (!validation.isNormal) ...[
                              const SizedBox(height: 6),
                              Text(
                                validation.message,
                                style: TextStyle(
                                  color: bannerColor,
                                  fontSize: 11.5, fontWeight: FontWeight.w600, height: 1.4),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                    _buildInputCard(patient),
                    const SizedBox(height: 18),

                    // ② PARAMÈTRES CLINIQUES (toujours visibles)
                    _SectionTitle('Paramètres cliniques', isDark: _isDark),
                    const SizedBox(height: 10),
                    _buildClinicalCard(),
                    const SizedBox(height: 18),

                    // ③ PARAMÈTRES CALCULÉS ou EMPTY STATE
                    if (patient.isComplete) ...[
                      _SectionTitle('Paramètres calculés', isDark: _isDark),
                      const SizedBox(height: 10),
                      _buildCalculatedGrid(patient),
                      const SizedBox(height: 18),
                    ] else ...[
                      _buildEmptyState(),
                      const SizedBox(height: 18),
                    ],

                    // ④ NOTES CLINIQUES (dynamiques)
                    if (_hasAnyNote(patient)) ...[
                      _SectionTitle('Notes cliniques', isDark: _isDark),
                      const SizedBox(height: 10),
                      _buildClinicalNotes(patient),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  ① HEADER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(AppProvider provider, patient) {
    return SliverAppBar(
      expandedHeight: 110,
      pinned: true,
      backgroundColor: _isDark ? _PC.darkCard : _PC.card,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: _PC.shadow,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 10),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ArLogo(size: 36),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Bonjour, X" si prénom connu
                if (_userPrenom.isNotEmpty) ...[
                  Text('Bonjour,',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2ECDC8),
                      letterSpacing: 0.4)),
                  Text(_userPrenom,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _PC.accent,
                      letterSpacing: -0.2)),
                ] else ...[
                  Text('Données patient',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2ECDC8),
                      letterSpacing: 0.6)),
                  Text('Anesthésie & Réanimation',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _txtMain)),
                ],
              ],
            ),
          ],
        ),
      ),
      actions: [
        _PediatricToggle(
          isPediatric: provider.isPediatricMode,
          onTap: provider.togglePediatricMode,
          isDark: _isDark,
        ),
        _HeaderButton(
          icon: provider.isDarkMode
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          onTap: provider.toggleDarkMode,
          isDark: _isDark,
        ),
        if (patient.isComplete)
          _HeaderButton(
            icon: Icons.refresh_rounded,
            onTap: () {
              _weightCtrl.clear(); _heightCtrl.clear();
              _ageCtrl.clear();    _jeunCtrl.clear();
              setState(() {
                _sex = null; _asa = null; _mallampati = null;
                _ageUnit = AgeUnit.years;
              });
              provider.clearPatient();
            },
            isDark: _isDark,
          ),
        _HeaderButton(
          icon: Icons.help_outline_rounded,
          onTap: () => _showHelp(context),
          isDark: _isDark,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showHelp(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4,
            decoration: BoxDecoration(
              color: _PC.accentMid,
              borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Aide', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(
            'Saisissez le poids, la taille, l\'âge et le sexe. '
            'Les paramètres calculés (IMC, IBW, LBW, BSA) s\'activent immédiatement. '
            'Complétez ensuite le jeûne, le score ASA et Mallampati pour obtenir les notes cliniques.',
            style: TextStyle(fontSize: 14, color: _txtSub, height: 1.5)),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  ① INPUT CARD  (Poids / Taille / Âge / Sexe — une rangée)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildInputCard(patient) {
    final weightField = _PatientInputField(
      label: 'Poids', unit: 'kg',
      controller: _weightCtrl,
      hint: '70',
      icon: Icons.monitor_weight_outlined,
      decimal: true,
      action: TextInputAction.next,
      onChanged: (_) => _update(),
      isDark: _isDark,
    );
    final heightField = _PatientInputField(
      label: 'Taille', unit: 'cm',
      controller: _heightCtrl,
      hint: '170',
      icon: Icons.height_rounded,
      action: TextInputAction.next,
      onChanged: (_) => _update(),
      isDark: _isDark,
    );
    final ageField = _PatientInputField(
      label: 'Âge', unit: _ageUnit.label,
      controller: _ageCtrl,
      hint: _ageUnit == AgeUnit.years ? '45' : (_ageUnit == AgeUnit.months ? '6' : '15'),
      icon: Icons.cake_outlined,
      decimal: true,
      action: TextInputAction.done,
      onChanged: (_) => _update(),
      isDark: _isDark,
    );
    final sexField = _SexSelectorCards(
      value: _sex,
      isDark: _isDark,
      onChanged: (v) { setState(() => _sex = v); _update(); },
    );

    return _SoftCard(
      isDark: _isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Layout responsive ────────────────────────────────────────
          // Sur petits écrans (téléphones), 4 champs sur une seule ligne
          // n'ont pas assez de place (l'icône + le suffixe "kg/cm" écrasent
          // le chiffre saisi). En dessous de 600px de large on passe donc
          // en grille 2x2 ; au-dessus (tablette/desktop) on garde la ligne
          // unique d'origine.
          LayoutBuilder(builder: (context, constraints) {
            final narrow = constraints.maxWidth < 600;
            if (narrow) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: weightField),
                      const SizedBox(width: 10),
                      Expanded(child: heightField),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: ageField),
                      const SizedBox(width: 10),
                      Expanded(child: sexField),
                    ],
                  ),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: weightField),
                const SizedBox(width: 10),
                Expanded(child: heightField),
                const SizedBox(width: 10),
                Expanded(child: ageField),
                const SizedBox(width: 10),
                Expanded(child: sexField),
              ],
            );
          }),

          // Sélecteur d'unité d'âge — toujours visible (permet de saisir
          // en jours/mois/années à tout moment, indépendamment du mode
          // pédiatrique automatique/manuel).
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: _AgeUnitSelector(
              value: _ageUnit,
              isDark: _isDark,
              onChanged: _onAgeUnitChanged,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  PARAMÈTRES CALCULÉS  (4 grandes cartes : IMC / IBW / LBW / BSA)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCalculatedGrid(patient) {
    final bmi = patient.bmi;
    Color bmiColor = _PC.textPrimary;
    final isPediatric = context.watch<AppProvider>().isPediatricMode;
    String bmiClassLabel = patient.bmiCategoryDisplay;
    if (bmi != null) {
      if (isPediatric) {
        bmiColor = _PC.accent; // neutre — pas de jugement adulte chez l'enfant
      } else {
        if (bmi < 18.5)      bmiColor = _PC.warning;
        else if (bmi < 25)   bmiColor = _PC.success;
        else if (bmi < 30)   bmiColor = _PC.warning;
        else                 bmiColor = _PC.danger;
      }
    }

    return Row(children: [
      // IMC
      Expanded(child: _BigMetricCard(
        isDark: _isDark,
        icon: Icons.monitor_weight_outlined,
        label: 'IMC (BMI)',
        value: bmi != null ? bmi.toStringAsFixed(1) : '—',
        unit: 'kg/m²',
        valueColor: bmiColor,
        badge: bmiClassLabel,
        badgeColor: bmiColor,
      )),
      const SizedBox(width: 10),
      // Poids Idéal
      Expanded(child: _BigMetricCard(
        isDark: _isDark,
        icon: Icons.person_outline_rounded,
        label: 'Poids Idéal',
        value: patient.ibwLbwNotApplicable
            ? 'N/A'
            : (patient.clinicalIbw != null
                ? patient.clinicalIbw!.toStringAsFixed(1)
                : '—'),
        unit: patient.ibwLbwNotApplicable ? '' : 'kg',
      )),
      const SizedBox(width: 10),
      // Poids Maigre
      Expanded(child: _BigMetricCard(
        isDark: _isDark,
        icon: Icons.accessibility_new_rounded,
        label: 'Poids Maigre',
        value: patient.ibwLbwNotApplicable
            ? 'N/A'
            : (patient.clinicalLbw != null
                ? patient.clinicalLbw!.clamp(0, 200).toStringAsFixed(1)
                : '—'),
        unit: patient.ibwLbwNotApplicable ? '' : 'kg',
      )),
      const SizedBox(width: 10),
      // Surface Corporelle
      Expanded(child: _BigMetricCard(
        isDark: _isDark,
        icon: Icons.person_rounded,
        label: 'Surface Corporelle',
        value: patient.bsa != null
            ? patient.bsa!.toStringAsFixed(2)
            : '—',
        unit: 'm²',
      )),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  PARAMÈTRES CLINIQUES  (Jeûne / ASA / Mallampati)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildClinicalCard() {
    return _SoftCard(
      isDark: _isDark,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Jeûne ──────────────────────────────────────────────────────
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('(Xh)',
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: _isDark ? _PC.darkTextSub : _PC.textSecond)),
              const SizedBox(height: 8),
              _JeunField(controller: _jeunCtrl, isDark: _isDark,
                  onChanged: (_) => setState(() {})),
            ],
          )),
          const SizedBox(width: 16),
          // ── Score ASA ─────────────────────────────────────────────────
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Score ASA',
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: _isDark ? _PC.darkTextSub : _PC.textSecond)),
              const SizedBox(height: 8),
              Row(children: AsaScore.values.map((s) {
                final active = _asa == s;
                return Expanded(child: Padding(
                  padding: EdgeInsets.only(right: s != AsaScore.IV ? 6 : 0),
                  child: _ScoreButton(
                    label: s.roman,
                    active: active,
                    isDark: _isDark,
                    onTap: () => setState(() => _asa = active ? null : s),
                  ),
                ));
              }).toList()),
              if (_asa != null) ...[
                const SizedBox(height: 6),
                Text(_asa!.label,
                  style: const TextStyle(
                    fontSize: 11, color: _PC.textSecond)),
              ],
            ],
          )),
          const SizedBox(width: 16),
          // ── Score Mallampati ──────────────────────────────────────────
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Score Mallampati',
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: _isDark ? _PC.darkTextSub : _PC.textSecond)),
              const SizedBox(height: 8),
              Row(children: MallampatiScore.values.map((s) {
                final active = _mallampati == s;
                return Expanded(child: Padding(
                  padding: EdgeInsets.only(
                      right: s != MallampatiScore.IV ? 6 : 0),
                  child: _ScoreButton(
                    label: s.roman,
                    active: active,
                    isDark: _isDark,
                    onTap: () =>
                        setState(() => _mallampati = active ? null : s),
                  ),
                ));
              }).toList()),
              if (_mallampati != null) ...[
                const SizedBox(height: 6),
                Text(_mallampati!.label,
                  style: const TextStyle(
                    fontSize: 11, color: _PC.textSecond)),
              ],
            ],
          )),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  NOTES CLINIQUES  (dynamiques)
  // ══════════════════════════════════════════════════════════════════════════

  bool _hasAnyNote(patient) {
    final jeunH = double.tryParse(_jeunCtrl.text);
    return jeunH != null || _asa != null || _mallampati != null ||
        patient.isComplete;
  }

  Widget _buildClinicalNotes(patient) {
    final notes = <_NoteItem>[];
    final jeunH = double.tryParse(_jeunCtrl.text);

    // ── Jeûne ──────────────────────────────────────────────────────────
    if (jeunH != null) {
      if (jeunH >= 6) {
        notes.add(_NoteItem(
          icon: Icons.check_circle_rounded,
          color: _PC.success,
          text: 'Patient correctement à jeun (> 6h). '
              'Risque d\'inhalation gastrique faible.',
        ));
      } else {
        notes.add(_NoteItem(
          icon: Icons.cancel_rounded,
          color: _PC.danger,
          text: 'Jeûne insuffisant (${jeunH.toStringAsFixed(0)}h < 6h). '
              'Risque d\'inhalation gastrique élevé — évaluer l\'urgence.',
        ));
      }
    }

    // ── ASA ────────────────────────────────────────────────────────────
    if (_asa != null) {
      final isWarn = _asa == AsaScore.II;
      final isCrit = _asa == AsaScore.III || _asa == AsaScore.IV;
      notes.add(_NoteItem(
        icon: isCrit
            ? Icons.warning_amber_rounded
            : (isWarn ? Icons.warning_amber_rounded : Icons.check_circle_rounded),
        color: isCrit ? _PC.danger : (isWarn ? _PC.warning : _PC.success),
        text: _asaNoteText(_asa!),
      ));
    }

    // ── Mallampati ─────────────────────────────────────────────────────
    if (_mallampati != null) {
      final difficult = _mallampati == MallampatiScore.III ||
          _mallampati == MallampatiScore.IV;
      notes.add(_NoteItem(
        icon: difficult
            ? Icons.warning_amber_rounded
            : Icons.check_circle_rounded,
        color: difficult ? _PC.warning : _PC.success,
        text: difficult
            ? 'Mallampati ${_mallampati!.roman} : Intubation potentiellement '
              'difficile, préparer le matériel adapté (vidéolaryngoscope, etc.).'
            : 'Mallampati ${_mallampati!.roman} : Intubation facile prévue.',
      ));
    }

    // ── IMC ────────────────────────────────────────────────────────────
    // Les seuils adultes (Surpoids/Obésité) ne s'appliquent qu'à partir de
    // 18 ans — avant, seule une courbe IMC-pour-âge (OMS) est valide.
    if (patient.isComplete) {
      final bmi = patient.bmi!;
      final ageYearsForBmi = patient.ageInYears!;
      final isPediatricPatient = ageYearsForBmi < 18;

      if (isPediatricPatient) {
        notes.add(_NoteItem(
          icon: Icons.info_rounded,
          color: _PC.accent,
          text: 'IMC (${bmi.toStringAsFixed(1)} kg/m²) : à interpréter selon '
              'une courbe IMC-pour-âge (OMS), pas selon les seuils adultes '
              '(Surpoids/Obésité non applicables tels quels chez l\'enfant).',
        ));
      } else if (bmi < 18.5) {
        notes.add(_NoteItem(
          icon: Icons.info_rounded,
          color: _PC.warning,
          text: 'IMC bas (${bmi.toStringAsFixed(1)}) : '
              'Adapter les doses, surveiller la dénutrition.',
        ));
      } else if (bmi < 25) {
        notes.add(_NoteItem(
          icon: Icons.check_circle_rounded,
          color: _PC.success,
          text: 'IMC normal : Pas d\'ajustement particulier requis.',
        ));
      } else if (bmi < 30) {
        notes.add(_NoteItem(
          icon: Icons.warning_amber_rounded,
          color: _PC.warning,
          text: 'Surpoids (IMC ${bmi.toStringAsFixed(1)}) : '
              'Préférer le Poids Idéal pour la majorité des drogues.',
        ));
      } else {
        notes.add(_NoteItem(
          icon: Icons.warning_amber_rounded,
          color: _PC.danger,
          text: 'Patient obèse (IMC ${bmi.toStringAsFixed(1)}) : '
              'Utiliser IBW pour la plupart des drogues. '
              'Succinylcholine : Poids Réel.',
        ));
      }

      // ── Posologie poids ─────────────────────────────────────────────
      if (isPediatricPatient) {
        notes.add(_NoteItem(
          icon: Icons.info_rounded,
          color: _PC.accent,
          text: 'Posologie pédiatrique adaptée au poids réel '
              '(${patient.weight!.toStringAsFixed(1)} kg).'
              '${patient.ibwLbwNotApplicable ? ' IBW/Poids maigre non applicables avant 8 ans — ne pas utiliser.' : ''}',
        ));
      } else {
        notes.add(_NoteItem(
          icon: Icons.info_rounded,
          color: _PC.accent,
          text: 'Posologie adaptée au poids réel '
              '(${patient.weight!.toStringAsFixed(1)} kg) '
              'et au poids maigre '
              '(${patient.clinicalLbw != null ? patient.clinicalLbw!.clamp(0, 200).toStringAsFixed(1) : '—'} kg).',
        ));
      }

      // ── Notes par âge ───────────────────────────────────────────────
      final ageYears = patient.ageInYears!;
      final provider = context.read<AppProvider>();

      // Alerte de cohérence poids/taille/âge — pertinente en pédiatrie
      // comme chez l'adulte (ex : poids incompatible avec un adulte).
      final dosageValidation = PediatricValidationService.validateAll(patient);
      if (!dosageValidation.isNormal) {
        notes.add(_NoteItem(
          icon: dosageValidation.isDanger
              ? Icons.error_outline_rounded
              : Icons.warning_amber_rounded,
          color: dosageValidation.isDanger ? _PC.danger : _PC.warning,
          text: dosageValidation.message,
        ));
      }

      if (patient.isNeonate) {
        notes.add(_NoteItem(
          icon: Icons.warning_amber_rounded,
          color: _PC.danger,
          text: 'Nouveau-né (${patient.ageDisplay}) : pharmacocinétique '
              'immature (métabolisme hépatique et clairance rénale réduits). '
              'Titration extrêmement prudente, avis spécialisé recommandé.',
        ));
      } else if (ageYears < 18) {
        notes.add(_NoteItem(
          icon: Icons.info_rounded,
          color: _PC.accent,
          text: 'Patient pédiatrique (${patient.ageDisplay}) : utiliser les '
              'protocoles de doses au poids (mg/kg). Vérifier avec une '
              'référence pédiatrique.',
        ));
      } else if (ageYears >= 65) {
        notes.add(_NoteItem(
          icon: Icons.warning_amber_rounded,
          color: _PC.warning,
          text: 'Patient âgé (${patient.ageDisplay}) : réduire les doses de '
              '30–50 %. Éviter les benzodiazépines (risque de délirium). '
              'Adapter selon la clairance rénale.',
        ));
      } else {
        notes.add(_NoteItem(
          icon: Icons.info_rounded,
          color: _PC.accent,
          text: 'Posologie adulte standard. '
              'Ajuster selon l\'état clinique et les défaillances viscérales.',
        ));
      }
    }

    return _SoftCard(
      isDark: _isDark,
      child: Column(
        children: notes.asMap().entries.map((entry) {
          final i    = entry.key;
          final note = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < notes.length - 1 ? 12 : 0),
            child: _ClinicalNoteRow(note: note, isDark: _isDark),
          );
        }).toList(),
      ),
    );
  }

  String _asaNoteText(AsaScore asa) {
    switch (asa) {
      case AsaScore.I:
        return 'ASA I : Bonne santé — pas de surveillance spéciale requise.';
      case AsaScore.II:
        return 'ASA II : Surveillance standard recommandée.';
      case AsaScore.III:
        return 'ASA III : Maladie sévère — surveillance renforcée requise, '
            'anticiper les complications peropératoires.';
      case AsaScore.IV:
        return 'ASA IV : Risque vital permanent — discuter du rapport '
            'bénéfice/risque avec l\'équipe chirurgicale.';
    }
  }

  // ── Empty state ─────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Center(child: Column(children: [
        Container(
          width: 80, height: 80,
          decoration: const BoxDecoration(
            color: _PC.accentLight, shape: BoxShape.circle),
          child: const Icon(Icons.person_add_alt_1_rounded,
            size: 38, color: _PC.accent),
        ),
        const SizedBox(height: 16),
        Text('Prêt à commencer',
          style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: _txtMain)),
        const SizedBox(height: 6),
        Text(
          'Saisissez les données patient\npour activer les calculs',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, height: 1.5, color: _txtSub)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: _PC.accentMid, width: 1.5),
            borderRadius: BorderRadius.circular(30)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.arrow_upward_rounded, size: 14, color: _PC.accent),
            SizedBox(width: 6),
            Text('Remplissez le formulaire ci-dessus',
              style: TextStyle(
                fontSize: 12, color: _PC.accent, fontWeight: FontWeight.w600)),
          ]),
        ),
      ])),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  WIDGETS LOCAUX
// ═══════════════════════════════════════════════════════════════════════════

// ── Section title avec barre violette ───────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionTitle(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 4, height: 20,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _PC.accent,
        borderRadius: BorderRadius.circular(2))),
    Text(text, style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: isDark ? _PC.darkText : _PC.textPrimary)),
  ]);
}

// ── Grande carte métrique (IMC / IBW / LBW / BSA) ───────────────────────────
class _BigMetricCard extends StatelessWidget {
  final bool   isDark;
  final IconData icon;
  final String label, value, unit;
  final Color? valueColor;
  final String? badge;
  final Color? badgeColor;

  const _BigMetricCard({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.valueColor,
    this.badge,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? _PC.darkCard : _PC.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? _PC.darkBorder : _PC.accentMid, width: 1),
        boxShadow: isDark ? [] : const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: isDark ? _PC.darkInput : _PC.accentLight,
              shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: _PC.accent),
          ),
          const SizedBox(height: 10),
          // Label
          Text(label.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: _PC.accent,
              letterSpacing: 0.6)),
          const SizedBox(height: 8),
          // Valeur
          Text(value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: valueColor ?? (isDark ? _PC.darkText : _PC.textPrimary))),
          Text(unit,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _PC.accent)),
          // Badge (ex: Poids normal)
          if (badge != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor?.withOpacity(0.12) ?? _PC.accentLight,
                borderRadius: BorderRadius.circular(20)),
              child: Text(badge!,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: badgeColor ?? _PC.accent)),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Score button (ASA / Mallampati) ─────────────────────────────────────────
class _ScoreButton extends StatelessWidget {
  final String label;
  final bool active, isDark;
  final VoidCallback onTap;

  const _ScoreButton({
    required this.label,
    required this.active,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 42,
        decoration: active
          ? BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF9B8FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3A6C63FF),
                  blurRadius: 10, offset: Offset(0, 4)),
              ])
          : BoxDecoration(
              color: isDark ? _PC.darkInput : _PC.inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? _PC.darkBorder : const Color(0xFFE4E5F0))),
        child: Center(
          child: Text(label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active
                ? Colors.white
                : (isDark ? _PC.darkTextSub : _PC.textSecond))),
        ),
      ),
    );
  }
}

// ── Champ Jeûne ──────────────────────────────────────────────────────────────
class _JeunField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _JeunField({
    required this.controller,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDark ? _PC.darkInput : _PC.inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? _PC.darkBorder : Colors.transparent)),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? _PC.darkText : _PC.textPrimary),
        decoration: InputDecoration(
          hintText: '8',
          hintStyle: TextStyle(
            color: isDark ? _PC.darkTextSub : _PC.textSecond,
            fontSize: 14, fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.access_time_rounded,
            size: 18,
            color: isDark ? _PC.darkTextSub : _PC.textSecond),
          suffixText: 'h',
          suffixStyle: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500,
            color: isDark ? _PC.darkTextSub : _PC.textSecond),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}

// ── Note clinique item ───────────────────────────────────────────────────────
class _NoteItem {
  final IconData icon;
  final Color color;
  final String text;
  const _NoteItem({required this.icon, required this.color, required this.text});
}

class _ClinicalNoteRow extends StatelessWidget {
  final _NoteItem note;
  final bool isDark;
  const _ClinicalNoteRow({required this.note, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: note.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: note.color, width: 3))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(note.icon, color: note.color, size: 18),
        const SizedBox(width: 12),
        Expanded(child: Text(note.text,
          style: TextStyle(
            fontSize: 13.5,
            height: 1.5,
            color: isDark ? _PC.darkText : _PC.textPrimary))),
      ]),
    );
  }
}

// ── Soft Card ────────────────────────────────────────────────────────────────
class _SoftCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _SoftCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? _PC.darkCard : _PC.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? _PC.darkBorder : Colors.transparent),
        boxShadow: isDark ? [] : const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, 6)),
          BoxShadow(color: Color(0x076C63FF), blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}

// ── PatientInputField ────────────────────────────────────────────────────────
class _PatientInputField extends StatefulWidget {
  final String label, unit, hint;
  final TextEditingController controller;
  final IconData icon;
  final bool decimal;
  final TextInputAction? action;
  final ValueChanged<String> onChanged;
  final bool isDark;

  const _PatientInputField({
    required this.label, required this.unit,
    required this.controller, required this.hint,
    required this.icon, required this.onChanged,
    required this.isDark,
    this.decimal = false, this.action,
  });

  @override State<_PatientInputField> createState() => _PatientInputFieldState();
}

class _PatientInputFieldState extends State<_PatientInputField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 6),
        child: Text(widget.label,
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5,
            color: _focused ? _PC.accent
              : (widget.isDark ? _PC.darkTextSub : _PC.textSecond))),
      ),
      Focus(
        onFocusChange: (f) => setState(() => _focused = f),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isDark ? _PC.darkInput : _PC.inputFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _focused ? _PC.accent
                : (widget.isDark ? _PC.darkBorder : Colors.transparent),
              width: _focused ? 1.5 : 1),
            boxShadow: _focused ? [
              BoxShadow(
                color: _PC.accent.withOpacity(0.15),
                blurRadius: 8, offset: const Offset(0, 2))
            ] : [],
          ),
          child: TextField(
            controller: widget.controller,
            textInputAction: widget.action,
            keyboardType: widget.decimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600,
              color: widget.isDark ? _PC.darkText : _PC.textPrimary),
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: widget.isDark ? _PC.darkTextSub : _PC.textSecond,
                fontSize: 13, fontWeight: FontWeight.w400),
              // Icône compacte avec une largeur minimale forcée, au lieu de
              // la zone par défaut de Flutter (48dp) qui, combinée à
              // l'unité en suffixe, ne laissait presque plus de place pour
              // le chiffre saisi sur les écrans de téléphone étroits.
              prefixIconConstraints: const BoxConstraints(
                minWidth: 28, minHeight: 0),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 4, right: 2),
                child: Icon(widget.icon, size: 15,
                  color: _focused ? _PC.accent
                    : (widget.isDark ? _PC.darkTextSub : _PC.textSecond)),
              ),
              suffixText: widget.unit,
              suffixStyle: TextStyle(
                fontSize: 10.5, fontWeight: FontWeight.w500,
                color: _focused ? _PC.accent
                  : (widget.isDark ? _PC.darkTextSub : _PC.textSecond)),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 12),
            ),
          ),
        ),
      ),
    ]);
  }
}

// ── AgeUnitSelector ──────────────────────────────────────────────────────────
// Sélecteur compact Ans / Mois / Jours, visible en mode pédiatrique.
// Permet de saisir précisément l'âge d'un nourrisson (ex : 15 jours, 6 mois).
class _AgeUnitSelector extends StatelessWidget {
  final AgeUnit value;
  final bool isDark;
  final ValueChanged<AgeUnit> onChanged;

  const _AgeUnitSelector({
    required this.value, required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? _PC.darkInput : _PC.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? _PC.darkBorder : const Color(0xFFE4E5F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: AgeUnit.values.map((u) {
          final selected = u == value;
          return GestureDetector(
            onTap: () { HapticFeedback.selectionClick(); onChanged(u); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? _PC.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(u.label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : (isDark ? _PC.darkTextSub : _PC.textSecond)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── SexSelectorCards ─────────────────────────────────────────────────────────
class _SexSelectorCards extends StatelessWidget {
  final Sex? value;
  final bool isDark;
  final ValueChanged<Sex?> onChanged;

  const _SexSelectorCards({
    required this.value, required this.onChanged, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 6),
        child: Text('Sexe',
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5,
            color: isDark ? _PC.darkTextSub : _PC.textSecond)),
      ),
      Row(children: [
        Expanded(child: _SexOptionCard(
          sex: Sex.male, label: 'H',
          icon: Icons.person_rounded,
          activeGradient: const [Color(0xFF6C63FF), Color(0xFF9B8FFF)],
          activeIconBg: const Color(0xFFB8B3FF),
          isSelected: value == Sex.male,
          isDark: isDark,
          onTap: () => onChanged(Sex.male),
        )),
        const SizedBox(width: 8),
        Expanded(child: _SexOptionCard(
          sex: Sex.female, label: 'F',
          icon: Icons.person_4_rounded,
          activeGradient: const [Color(0xFFFF6B9D), Color(0xFFFF9BBD)],
          activeIconBg: const Color(0xFFFFB8D0),
          isSelected: value == Sex.female,
          isDark: isDark,
          onTap: () => onChanged(Sex.female),
        )),
      ]),
    ]);
  }
}

class _SexOptionCard extends StatefulWidget {
  final Sex sex;
  final String label;
  final IconData icon;
  final List<Color> activeGradient;
  final Color activeIconBg;
  final bool isSelected, isDark;
  final VoidCallback onTap;

  const _SexOptionCard({
    required this.sex, required this.label, required this.icon,
    required this.activeGradient, required this.activeIconBg,
    required this.isSelected, required this.isDark, required this.onTap,
  });

  @override State<_SexOptionCard> createState() => _SexOptionCardState();
}

class _SexOptionCardState extends State<_SexOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 140),
      lowerBound: 0.0, upperBound: 1.0);
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  void _onTapDown(_) => _ctrl.forward();
  void _onTapUp(_)   { _ctrl.reverse(); widget.onTap(); HapticFeedback.selectionClick(); }
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final selected       = widget.isSelected;
    final inactiveBg     = widget.isDark ? _PC.darkInput  : _PC.inputFill;
    final inactiveBorder = widget.isDark ? _PC.darkBorder : const Color(0xFFE4E5F0);
    final inactiveIcon   = widget.isDark ? _PC.darkTextSub: _PC.textSecond;
    final inactiveText   = widget.isDark ? _PC.darkTextSub: _PC.textSecond;

    return GestureDetector(
      onTapDown: _onTapDown, onTapUp: _onTapUp, onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          height: 52,
          decoration: selected
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.activeGradient,
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: widget.activeGradient.first.withOpacity(0.35),
                    blurRadius: 12, offset: const Offset(0, 4)),
                ])
            : BoxDecoration(
                color: inactiveBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: inactiveBorder, width: 1.5)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: selected
                  ? widget.activeIconBg.withOpacity(0.35)
                  : (widget.isDark ? _PC.darkBorder : const Color(0xFFE8E9F4)),
                shape: BoxShape.circle),
              child: Icon(widget.icon, size: 14,
                color: selected ? Colors.white : inactiveIcon),
            ),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : inactiveText),
              child: Text(widget.label),
            ),
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.check_circle_rounded,
                  size: 12, color: Colors.white)),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Header Button ─────────────────────────────────────────────────────────────
class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  const _HeaderButton({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36, height: 36,
      margin: const EdgeInsets.only(right: 6, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? _PC.darkInput : _PC.accentLight,
        borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, size: 18,
        color: isDark ? _PC.darkTextSub : _PC.accent),
    ),
  );
}

// ── Pediatric Toggle ──────────────────────────────────────────────────────────
class _PediatricToggle extends StatelessWidget {
  final bool isPediatric;
  final VoidCallback onTap;
  final bool isDark;

  const _PediatricToggle({
    required this.isPediatric, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        margin: const EdgeInsets.only(right: 6, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isDark ? _PC.darkInput : (isPediatric ? const Color(0xFFE0F7FA) : _PC.accentLight),
          borderRadius: BorderRadius.circular(10),
          border: isPediatric ? Border.all(color: const Color(0xFF00BCD4), width: 1.5) : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                isPediatric ? Icons.child_care_rounded : Icons.person_rounded,
                key: ValueKey(isPediatric),
                size: 18,
                color: isPediatric 
                    ? const Color(0xFF00ACC1) 
                    : (isDark ? _PC.darkTextSub : _PC.accent),
              ),
            ),
            if (isPediatric)
              Positioned(
                top: 4, right: 4,
                child: Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00BCD4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}