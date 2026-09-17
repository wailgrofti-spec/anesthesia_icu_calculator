// ============================================================================
//  lib/screens/respiratory_screen.dart
//  Paramètres respiratoires — calcul automatique des réglages ventilatoires
//  Remplace l'ancien VitalsScreen (signes vitaux manuels).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/patient.dart';
import '../models/respiratory_params.dart';
import '../models/respiratory_param_detail.dart';
import '../models/respiratory_ventilation_mode.dart';
import '../models/respiratory_advanced_calc.dart';
import '../data/respiratory_detail_data.dart';
import '../data/respiratory_profile_detail_data.dart';
import '../data/respiratory_advanced_params_data.dart';
import '../data/respiratory_alarms_data.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import '../widgets/medical_animations.dart';
import 'respiratory_param_detail_screen.dart';
import 'patient_screen.dart';

// ── Couleurs sémantiques par paramètre (cohérentes avec _CC de vitals) ─────
class _RC {
  static const pbw       = Color(0xFF6366F1); // indigo
  static const vt         = Color(0xFF3B82F6); // bleu
  static const pplat      = Color(0xFF0EA5E9); // bleu ciel
  static const fr         = Color(0xFF8B5CF6); // violet
  static const fio2       = Color(0xFF06B6D4); // cyan
  static const peep       = Color(0xFF22C55E); // vert
  static const ie         = Color(0xFFF59E0B); // amber
  static const driving    = Color(0xFFEC4899); // rose
  static const trigger    = Color(0xFF14B8A6); // teal
  static const alarm      = Color(0xFFEF4444); // rouge
  static const flow       = Color(0xFF0D9488); // teal foncé
  static const advanced   = Color(0xFF7C3AED); // violet foncé (paramètres avancés)
}

/// Recherche un paramètre dans l'ensemble des dictionnaires de détail
/// (paramètres standards + avancés + alarmes) — additif, ne remplace aucun
/// des dictionnaires existants.
RespiratoryParamDetail? _lookupParamDetail(String paramId) {
  return respiratoryParamDetails[paramId] ??
      respiratoryAdvancedParamDetails[paramId] ??
      respiratoryAlarmDetails[paramId];
}

// ============================================================================
//  SCREEN PRINCIPAL
// ============================================================================

class RespiratoryScreen extends StatefulWidget {
  const RespiratoryScreen({super.key});
  @override
  State<RespiratoryScreen> createState() => _RespiratoryScreenState();
}

class _RespiratoryScreenState extends State<RespiratoryScreen> {
  VentilationProfile _selectedProfile = VentilationProfile.protective;
  VentilationMode _selectedMode = VentilationMode.vcv;

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final patient = appProvider.patient;
    final isPediatric = appProvider.isPediatricMode;
    final pageBg = context.backgroundColor;
    final cardBg = context.surfaceColor;
    final borderC = context.borderColor;
    final textP = context.textColor;
    final textS = context.textMutedColor;

    final hasMinData = isPediatric ? patient.hasWeight : (patient.hasHeight && patient.hasSex);

    // Message d'erreur si les données saisies sont physiologiquement
    // impossibles (ex : taille 20 cm, poids 1 kg chez un adulte...) —
    // distinct du simple état "aucune donnée saisie" (voir dataIssue).
    final dataError = hasMinData
        ? RespiratoryParams.dataIssue(patient, isPediatric: isPediatric)
        : null;

    final params = (hasMinData && dataError == null)
        ? RespiratoryParams.compute(patient, profile: _selectedProfile, isPediatric: isPediatric)
        : null;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: borderC),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Icon(Icons.menu_rounded, color: textS, size: 22),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.air_rounded, size: 17, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paramètres respiratoires',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textP),
                ),
                Text(
                  'Calculs & réglages ventilatoires',
                  style: TextStyle(fontSize: 10, color: textS, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          _AppBarBtn(icon: Icons.help_outline_rounded, onTap: () {}),
          const SizedBox(width: 6),
        ],
      ),
      body: params == null
          ? _EmptyPatientState(patient: patient, errorMessage: dataError)
          : _ComputedState(
              params: params,
              selectedProfile: _selectedProfile,
              onProfileChanged: (p) {
                setState(() => _selectedProfile = p);
              },
              selectedMode: _selectedMode,
              onModeChanged: (m) {
                setState(() {
                  _selectedMode = m;
                  // Lorsque le mode change, la recommandation de profil
                  // associée est proposée automatiquement (ex. VCV +
                  // Ventilation protectrice, VPC + SDRA...) — cf. cahier
                  // des charges §2. L'utilisateur reste libre de changer
                  // le profil ensuite indépendamment.
                  _selectedProfile = m.suggestedProfile;
                });
              },
            ),
    );
  }
}

// ============================================================================
//  ÉTAT 1 — AUCUNE DONNÉE PATIENT
// ============================================================================

class _EmptyPatientState extends StatelessWidget {
  final Patient patient;
  /// Message d'erreur si des données ont été saisies mais sont
  /// physiologiquement impossibles (ex : taille 20 cm chez un adulte).
  /// `null` = simple état vide ("aucune donnée saisie pour l'instant").
  final String? errorMessage;
  const _EmptyPatientState({required this.patient, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final cardBg = context.surfaceColor;
    final borderC = context.borderColor;
    final textP = context.textColor;
    final textS = context.textMutedColor;

    final isError = errorMessage != null;
    final bannerColor = isError ? const Color(0xFFEF4444) : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Bandeau d'alerte : "Aucune donnée" (bleu) ou "Donnée
        //    impossible" (rouge, jamais un calcul silencieusement faux) ──
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bannerColor.withOpacity(0.06),
            borderRadius: AppRadius.card,
            border: Border.all(color: bannerColor.withOpacity(0.25), width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: bannerColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isError ? Icons.error_outline_rounded : Icons.info_outline_rounded,
                  size: 16,
                  color: bannerColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isError ? 'Données patient incohérentes' : 'Aucune donnée patient',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: bannerColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      errorMessage ??
                          'Veuillez saisir l\'âge, la taille, le poids et le sexe du patient.',
                      style: TextStyle(fontSize: 11.5, color: textS, fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PatientScreen()),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.primary),
              label: const Text(
                'Aller au profil patient',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.08),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
              ),
            ),
          ),
        ),

        // ── Illustration centrale ────────────────────────────────
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LungIconAnimation(size: 64),
                  const SizedBox(height: 20),
                  Text(
                    isError
                        ? 'Calcul impossible avec ces données'
                        : 'Aucun paramètre respiratoire disponible',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: textP),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isError
                        ? 'Corrigez la taille, le poids ou l\'âge du patient\ndans son profil avant de continuer.'
                        : 'Saisissez les informations du patient\npour calculer les paramètres ventilatoires.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5, color: textS, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
//  ÉTAT 2 — PARAMÈTRES CALCULÉS
// ============================================================================

class _ComputedState extends StatelessWidget {
  final RespiratoryParams params;
  final VentilationProfile selectedProfile;
  final ValueChanged<VentilationProfile> onProfileChanged;
  final VentilationMode selectedMode;
  final ValueChanged<VentilationMode> onModeChanged;

  const _ComputedState({
    required this.params,
    required this.selectedProfile,
    required this.onProfileChanged,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final advanced = RespiratoryAdvancedParams.compute(params);
    final alarms = RespiratoryAlarmSettings.compute(params);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (params.isPediatric) ...[
            _PediatricBanner(ageBandLabel: params.ageBandLabel),
            const SizedBox(height: 10),
          ],

          // ── 1. INFORMATIONS PATIENT — carte patient + PBW/BMI/BSA/Age/Poids/Taille ──
          _SectionLabel(text: 'INFORMATIONS PATIENT'),
          const SizedBox(height: 10),
          _PatientSummaryCard(params: params),
          const SizedBox(height: 10),
          _QuickSummaryRow(params: params),
          const SizedBox(height: 14),

          // ── 2. MODE VENTILATOIRE — nouvelle ligne sous les infos patient ──
          _SectionLabel(text: 'MODE VENTILATOIRE'),
          const SizedBox(height: 10),
          _ModeTabs(selected: selectedMode, onChanged: onModeChanged),
          const SizedBox(height: 14),

          // ── 3. PROFIL CLINIQUE ────────────────────────────────────
          _SectionLabel(text: 'PROFIL CLINIQUE'),
          const SizedBox(height: 10),
          _ProfileTabs(selected: selectedProfile, onChanged: onProfileChanged),
          const SizedBox(height: 14),

          // ── 4. RÉGLAGES VENTILATOIRES RECOMMANDÉS (titre dynamique) ──
          _RecommendedSettingsHeader(mode: selectedMode, profile: selectedProfile),
          const SizedBox(height: 10),

          // ── 5. Grille de cartes détaillées — filtrée selon le mode ──
          _ParamCardsGrid(params: params, selectedProfile: selectedProfile, selectedMode: selectedMode),
          const SizedBox(height: 18),

          // ── 6. PARAMÈTRES AVANCÉS ────────────────────────────────
          _SectionLabel(text: 'PARAMÈTRES AVANCÉS'),
          const SizedBox(height: 10),
          _AdvancedParamsGrid(advanced: advanced, selectedProfile: selectedProfile),
          const SizedBox(height: 18),

          // ── 7. ALARMES RECOMMANDÉES ──────────────────────────────
          _AlarmsSectionHeader(),
          const SizedBox(height: 10),
          _AlarmsGrid(alarms: alarms, selectedProfile: selectedProfile),
          const SizedBox(height: 14),

          // ── Note d'information ───────────────────────────────────
          _FooterInfo(),
        ],
      ),
    );
  }
}

// ── Libellé de section générique (style identique au titre existant) ─────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 13,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: context.textMutedColor,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

// ── En-tête "Réglages ventilatoires recommandés" + combo mode/profil ─────────
class _RecommendedSettingsHeader extends StatelessWidget {
  final VentilationMode mode;
  final VentilationProfile profile;
  const _RecommendedSettingsHeader({required this.mode, required this.profile});

  void _showJustification(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mode.comboLabel(profile),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: ctx.textColor),
            ),
            const SizedBox(height: 10),
            Text(
              'Mode : ${mode.fullLabel}. Ce mode détermine quels paramètres sont '
              'réglés directement (consignes) et lesquels sont mesurés/estimés en résultante.',
              style: TextStyle(fontSize: 12.5, color: ctx.textMutedColor, height: 1.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              'Profil clinique : ${profile.label}. Le profil détermine les valeurs cibles '
              '(Vt/kg, PEEP, FiO₂, driving pressure...) appliquées à ce patient.',
              style: TextStyle(fontSize: 12.5, color: ctx.textMutedColor, height: 1.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            Text(
              'Touchez n\'importe quelle carte ci-dessous pour la définition complète, '
              'le calcul, les valeurs normales et les références scientifiques.',
              style: TextStyle(fontSize: 11.5, color: ctx.textMutedColor, height: 1.4, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 3,
                    height: 13,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'RÉGLAGES VENTILATOIRES RECOMMANDÉS',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: context.textMutedColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Text(
                '(${mode.comboLabel(profile)})',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () => _showJustification(context),
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
          icon: const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.primary),
          label: const Text(
            'Voir justifications',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

// ── En-tête section Alarmes ────────────────────────────────────────────────
class _AlarmsSectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 13,
          decoration: BoxDecoration(color: _RC.alarm, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 7),
        Text(
          'ALARMES RECOMMANDÉES',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: context.textMutedColor,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

// ── Bandeau mode pédiatrique ──────────────────────────────────────────────────
class _PediatricBanner extends StatelessWidget {
  final String? ageBandLabel;
  const _PediatricBanner({this.ageBandLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF38BDF8).withOpacity(0.08),
        borderRadius: AppRadius.card,
        border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        children: [
          const Icon(Icons.child_care_rounded, size: 18, color: Color(0xFF0EA5E9)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mode pédiatrique — Vt calculé sur le poids réel, FR/PEEP/Pplat '
              'adaptés à la tranche d\'âge${ageBandLabel != null ? ' ($ageBandLabel)' : ''}.',
              style: const TextStyle(
                fontSize: 11.5, fontWeight: FontWeight.w600,
                color: Color(0xFF0369A1), height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Carte résumé patient ──────────────────────────────────────────────────────
class _PatientSummaryCard extends StatelessWidget {
  final RespiratoryParams params;
  const _PatientSummaryCard({required this.params});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = context.cardColor;
    final borderC = context.borderColor;
    final textP = context.textColor;
    final textS = context.textMutedColor;
    final patient = params.patient;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.card,
        border: Border.all(color: borderC, width: 0.8),
        boxShadow: dark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person_rounded, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient: ${patient.sex?.label ?? '—'}, ${patient.ageDisplay} • '
                  '${patient.height?.toStringAsFixed(0) ?? '—'} cm • '
                  '${patient.weight?.toStringAsFixed(0) ?? '—'} kg',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: textP),
                ),
                const SizedBox(height: 2),
                Text(
                  params.isPediatric && params.ageBandLabel != null
                      ? params.ageBandLabel!
                      : 'IMC: ${patient.bmi?.toStringAsFixed(1) ?? '—'} kg/m²',
                  style: TextStyle(fontSize: 11, color: textS, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '${params.referenceWeightLabel}: ${params.pbwDisplay}',
                    style: TextStyle(fontSize: 11, color: textS, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.info_outline_rounded, size: 12, color: textS),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bandeau résumé rapide (5 mini-cartes) ─────────────────────────────────────
class _QuickSummaryRow extends StatelessWidget {
  final RespiratoryParams params;
  const _QuickSummaryRow({required this.params});

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(icon: Icons.straighten_rounded, color: _RC.pbw, label: params.isPediatric ? 'Poids réel (réf.)' : 'PC théorique (PBW)', value: '${params.pbw.toStringAsFixed(1)} kg'),
      _QuickItem(icon: Icons.air_rounded, color: _RC.vt, label: 'Vt (6-8 mL/kg)', value: '${params.tidalVolumeMl.display} mL'),
      _QuickItem(icon: Icons.speed_rounded, color: _RC.fr, label: 'FR adaptée', value: '${params.respiratoryRate.display} /min'),
      _QuickItem(icon: Icons.change_history_rounded, color: _RC.peep, label: 'PEEP recommandée', value: '${params.peep.min.toStringAsFixed(0)} cmH₂O'),
      _QuickItem(icon: Icons.water_drop_outlined, color: _RC.fio2, label: 'FiO₂ initiale', value: params.fio2.display),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(items.length, (i) {
              return Padding(
                padding: EdgeInsets.only(right: i == items.length - 1 ? 0 : 18),
                child: items[i],
              );
            }),
          ),
        );
      },
    );
  }
}

class _QuickItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _QuickItem({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textP = context.textColor;
    final textS = context.textMutedColor;
    return SizedBox(
      width: 118,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textS),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: textP),
          ),
        ],
      ),
    );
  }
}

// ── Onglets de mode ventilatoire (NOUVEAU) ───────────────────────────────────
class _ModeTabs extends StatelessWidget {
  final VentilationMode selected;
  final ValueChanged<VentilationMode> onChanged;
  const _ModeTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final borderC = context.borderColor;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: VentilationMode.values.map((m) {
          final isActive = m == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(m),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive ? AppColors.primary : borderC,
                    width: isActive ? 1.2 : 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(m.icon, size: 14, color: isActive ? Colors.white : context.textMutedColor),
                    const SizedBox(width: 6),
                    Text(
                      m.shortLabel,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                        color: isActive ? Colors.white : context.textMutedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Onglets de pathologies / profils ventilatoires ───────────────────────────
class _ProfileTabs extends StatelessWidget {
  final VentilationProfile selected;
  final ValueChanged<VentilationProfile> onChanged;
  const _ProfileTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final borderC = context.borderColor;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: VentilationProfile.values.map((p) {
          final isActive = p == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary.withOpacity(0.10) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive ? AppColors.primary : borderC,
                    width: isActive ? 1.2 : 0.8,
                  ),
                ),
                child: Text(
                  p.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? AppColors.primary : context.textMutedColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Grille de cartes paramètres détaillés ─────────────────────────────────────
class _ParamCardsGrid extends StatelessWidget {
  final RespiratoryParams params;
  final VentilationProfile selectedProfile;
  final VentilationMode selectedMode;
  const _ParamCardsGrid({required this.params, required this.selectedProfile, required this.selectedMode});

  @override
  Widget build(BuildContext context) {
    final cardsAll = <_ParamCardData>[
      _ParamCardData(
        paramId: 'vt',
        icon: Icons.air_rounded,
        color: _RC.vt,
        title: 'Volume courant (Vt)',
        value: '${params.tidalVolumeMl.display} mL',
        subtitle: '${params.tidalVolumeMlPerKg.display} mL/kg PBW',
      ),
      _ParamCardData(
        paramId: 'pplat',
        icon: Icons.compress_rounded,
        color: _RC.pplat,
        title: 'Pression plateau (Pplat)',
        value: '≤ ${params.plateauPressureMax.toStringAsFixed(0)} cmH₂O',
        subtitle: 'Objectif protecteur',
      ),
      _ParamCardData(
        paramId: 'fr',
        icon: Icons.speed_rounded,
        color: _RC.fr,
        title: 'Fréquence respiratoire (FR)',
        value: '${params.respiratoryRate.display} /min',
        subtitle: 'Adapter à l\'EtCO₂',
      ),
      _ParamCardData(
        paramId: 'fio2',
        icon: Icons.water_drop_outlined,
        color: _RC.fio2,
        title: 'FiO₂ initiale',
        value: params.fio2.display,
        subtitle: 'Ajuster à la SpO₂',
      ),
      _ParamCardData(
        paramId: 'peep',
        icon: Icons.change_history_rounded,
        color: _RC.peep,
        title: 'PEEP (PEEP)',
        value: '${params.peep.min.toStringAsFixed(0)} cmH₂O',
        subtitle: 'Standard',
      ),
      _ParamCardData(
        paramId: 'ie',
        icon: Icons.swap_horiz_rounded,
        color: _RC.ie,
        title: 'Rapport I:E',
        value: params.ieRatio,
        subtitle: 'Standard',
      ),
      _ParamCardData(
        paramId: 'driving',
        icon: Icons.compare_arrows_rounded,
        color: _RC.driving,
        title: 'Driving Pressure',
        value: '${params.drivingPressure.display} cmH₂O',
        subtitle: 'Objectif < 15 cmH₂O',
      ),
      _ParamCardData(
        paramId: 'minute_volume',
        icon: Icons.timeline_rounded,
        color: _RC.flow,
        title: 'Volume minute estimé',
        value: '${params.minuteVolume.display} L/min',
        subtitle: 'Vt × FR',
      ),
      _ParamCardData(
        paramId: 'insp_pressure',
        icon: Icons.arrow_upward_rounded,
        color: _RC.pplat,
        title: 'Pression inspiratoire',
        value: '${params.inspiratoryPressure.display} cmH₂O',
        subtitle: 'Au-dessus de la PEEP',
      ),
      _ParamCardData(
        paramId: 'insp_time',
        icon: Icons.timer_outlined,
        color: _RC.ie,
        title: 'Temps inspiratoire',
        value: '${params.inspiratoryTimeSec.toStringAsFixed(1)} s',
        subtitle: 'Pour I:E ${params.ieRatio}',
      ),
      _ParamCardData(
        paramId: 'insp_flow',
        icon: Icons.waves_rounded,
        color: _RC.flow,
        title: 'Débit inspiratoire',
        value: '${params.inspiratoryFlow.display} L/min',
        subtitle: 'Conseillé',
      ),
      _ParamCardData(
        paramId: 'trigger',
        icon: Icons.touch_app_outlined,
        color: _RC.trigger,
        title: 'Trigger',
        value: '${params.triggerFlow.display} L/min',
        subtitle: 'ou ${params.triggerPressure.display} cmH₂O',
      ),
    ];

    // ── Filtrage + tri selon le mode ventilatoire sélectionné ─────────
    // (VCV, VPC, PSV, SIMV-VC, SIMV-PC, CPAP/PS n'affichent pas les mêmes
    // paramètres — cf. VentilationModeLabel.visibleParamIds). Les 2
    // anciennes cartes d'alarme ont été déplacées vers la section
    // indépendante "Alarmes recommandées" (§6 du cahier des charges).
    final byId = {for (final c in cardsAll) c.paramId: c};
    final cards = selectedMode.visibleParamIds
        .map((id) => byId[id])
        .whereType<_ParamCardData>()
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) => _ParamCard(data: cards[i], selectedProfile: selectedProfile),
    );
  }
}

class _ParamCardData {
  final String paramId;
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String subtitle;
  const _ParamCardData({
    required this.paramId,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.subtitle,
  });
}

class _ParamCard extends StatelessWidget {
  final _ParamCardData data;
  final VentilationProfile selectedProfile;
  const _ParamCard({required this.data, required this.selectedProfile});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = context.cardColor;
    final borderC = context.borderColor;
    final textP = context.textColor;
    final textS = context.textMutedColor;

    final detail = _lookupParamDetail(data.paramId);
    final hasDetail = detail != null;
    final profileNote = respiratoryProfileDetails[selectedProfile]?[data.paramId];

    return GestureDetector(
      onTap: hasDetail
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RespiratoryParamDetailScreen(
                    detail: detail,
                    profileNote: profileNote,
                    profileLabel: selectedProfile.label,
                  ),
                ),
              )
          : null,
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 12, 13, 11),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppRadius.card,
          border: Border.all(color: borderC, width: 0.8),
          boxShadow: dark
              ? []
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(data.icon, size: 14, color: data.color),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    data.title,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textS),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasDetail)
                  Icon(Icons.chevron_right_rounded, size: 16, color: textS),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data.value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textP),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              data.subtitle,
              style: TextStyle(fontSize: 10, color: textS, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Grille "Paramètres avancés" (NOUVEAU) ────────────────────────────────────
class _AdvancedParamsGrid extends StatelessWidget {
  final RespiratoryAdvancedParams advanced;
  final VentilationProfile selectedProfile;
  const _AdvancedParamsGrid({required this.advanced, required this.selectedProfile});

  @override
  Widget build(BuildContext context) {
    final cards = <_ParamCardData>[
      _ParamCardData(
        paramId: 'cstat',
        icon: Icons.air_rounded,
        color: _RC.advanced,
        title: 'Compliance (Cstat)',
        value: advanced.staticComplianceDisplay,
        subtitle: 'mL/cmH₂O',
      ),
      _ParamCardData(
        paramId: 'raw',
        icon: Icons.filter_alt_rounded,
        color: _RC.advanced,
        title: 'Résistance (Raw)',
        value: advanced.airwayResistance.display,
        subtitle: 'cmH₂O/L/s',
      ),
      _ParamCardData(
        paramId: 'pmean',
        icon: Icons.speed_rounded,
        color: _RC.advanced,
        title: 'Pression moyenne (Pmean)',
        value: '${advanced.meanAirwayPressureEstimate.toStringAsFixed(1)} cmH₂O',
        subtitle: 'Estimée',
      ),
      _ParamCardData(
        paramId: 'autopeep',
        icon: Icons.warning_amber_rounded,
        color: _RC.advanced,
        title: 'Auto-PEEP (intrinsèque)',
        value: advanced.autoPeepTarget.display,
        subtitle: 'cmH₂O',
      ),
      _ParamCardData(
        paramId: 'mpower',
        icon: Icons.bolt_rounded,
        color: _RC.advanced,
        title: 'Puissance mécanique',
        value: advanced.mechanicalPowerThresholdDisplay,
        subtitle: 'Estimé : ${advanced.mechanicalPowerEstimateDisplay}',
      ),
      _ParamCardData(
        paramId: 'cdyn',
        icon: Icons.waves_rounded,
        color: _RC.advanced,
        title: 'Compliance dynamique',
        value: advanced.dynamicCompliance.display,
        subtitle: 'mL/cmH₂O',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) => _ParamCard(data: cards[i], selectedProfile: selectedProfile),
    );
  }
}

// ── Grille "Alarmes recommandées" (NOUVEAU — étend les 2 alarmes existantes) ─
class _AlarmsGrid extends StatelessWidget {
  final RespiratoryAlarmSettings alarms;
  final VentilationProfile selectedProfile;
  const _AlarmsGrid({required this.alarms, required this.selectedProfile});

  @override
  Widget build(BuildContext context) {
    final cards = <_ParamCardData>[
      _ParamCardData(
        paramId: 'alarm_vt',
        icon: Icons.notifications_active_outlined,
        color: _RC.alarm,
        title: 'Alarme Vt bas',
        value: '< ${alarms.lowTidalVolume.max.toStringAsFixed(0)} mL',
        subtitle: 'Seuil d\'alerte',
      ),
      _ParamCardData(
        paramId: 'alarm_vt_high',
        icon: Icons.notifications_active_outlined,
        color: _RC.alarm,
        title: 'Alarme Vt haut',
        value: '> ${alarms.highTidalVolume.min.toStringAsFixed(0)} mL',
        subtitle: 'Seuil d\'alerte',
      ),
      _ParamCardData(
        paramId: 'alarm_pressure',
        icon: Icons.report_gmailerrorred_outlined,
        color: _RC.alarm,
        title: 'Alarme pression haute',
        value: alarms.highPressure.display,
        subtitle: 'cmH₂O',
      ),
      _ParamCardData(
        paramId: 'alarm_pressure_low',
        icon: Icons.report_gmailerrorred_outlined,
        color: _RC.alarm,
        title: 'Alarme pression basse',
        value: '< ${alarms.lowPressureThreshold.toStringAsFixed(0)} cmH₂O',
        subtitle: 'Débranchement',
      ),
      _ParamCardData(
        paramId: 'alarm_mv_low',
        icon: Icons.trending_down_rounded,
        color: _RC.alarm,
        title: 'Alarme VM bas',
        value: '< ${alarms.lowMinuteVolume.toStringAsFixed(1)} L/min',
        subtitle: 'Seuil d\'alerte',
      ),
      _ParamCardData(
        paramId: 'alarm_mv_high',
        icon: Icons.trending_up_rounded,
        color: _RC.alarm,
        title: 'Alarme VM haut',
        value: '> ${alarms.highMinuteVolume.toStringAsFixed(1)} L/min',
        subtitle: 'Seuil d\'alerte',
      ),
      _ParamCardData(
        paramId: 'alarm_apnea',
        icon: Icons.pause_circle_outline_rounded,
        color: _RC.alarm,
        title: 'Alarme apnée',
        value: '${alarms.apneaSeconds.toStringAsFixed(0)} s',
        subtitle: 'Filet de sécurité',
      ),
      _ParamCardData(
        paramId: 'alarm_fio2_low',
        icon: Icons.water_drop_outlined,
        color: _RC.alarm,
        title: 'Alarme FiO₂ basse',
        value: '< ${(alarms.lowFio2 * 100).toStringAsFixed(0)} %',
        subtitle: 'Seuil d\'alerte',
      ),
      _ParamCardData(
        paramId: 'alarm_fio2_high',
        icon: Icons.water_drop_outlined,
        color: _RC.alarm,
        title: 'Alarme FiO₂ haute',
        value: '> ${(alarms.highFio2 * 100).toStringAsFixed(0)} %',
        subtitle: 'Seuil d\'alerte',
      ),
      _ParamCardData(
        paramId: 'alarm_peep_low',
        icon: Icons.change_history_rounded,
        color: _RC.alarm,
        title: 'Alarme PEEP basse',
        value: '< ${alarms.lowPeep.toStringAsFixed(0)} cmH₂O',
        subtitle: 'Seuil d\'alerte',
      ),
      _ParamCardData(
        paramId: 'alarm_peep_high',
        icon: Icons.change_history_rounded,
        color: _RC.alarm,
        title: 'Alarme PEEP haute',
        value: '> ${alarms.highPeep.toStringAsFixed(0)} cmH₂O',
        subtitle: 'Seuil d\'alerte',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) => _ParamCard(data: cards[i], selectedProfile: selectedProfile),
    );
  }
}

// ── Note de bas de page ───────────────────────────────────────────────────────
class _FooterInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: AppRadius.card,
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ces paramètres sont des recommandations initiales.\n'
              'Ajustez selon la pathologie, les gaz du sang et la mécanique respiratoire.',
              style: TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ── AppBar Button (identique à l'ancien écran) ───────────────────────────────
class _AppBarBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final textS = context.textMutedColor;
    final borderC = context.borderColor;
    final buttonBg = dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.only(right: 6, top: 7, bottom: 7),
        decoration: BoxDecoration(
          color: buttonBg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: borderC, width: 0.6),
        ),
        child: Icon(icon, size: 17, color: textS),
      ),
    );
  }
}
