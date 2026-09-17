// ============================================================
//  lib/screens/onboarding_screen.dart
//  Première utilisation — prénom + genre — design thème médical
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';
import '../widgets/ar_logo.dart';

// ── Clés SharedPreferences ────────────────────────────────────
const String kUserPrenom = 'user_prenom';
const String kUserGenre  = 'user_genre';   // 'homme' | 'femme'
const String kOnbDone    = 'onboarding_done';

Future<bool>   isOnboardingDone() async =>
    (await SharedPreferences.getInstance()).getBool(kOnbDone) ?? false;
Future<String> getUserPrenom() async =>
    (await SharedPreferences.getInstance()).getString(kUserPrenom) ?? '';
Future<String> getUserGenre() async =>
    (await SharedPreferences.getInstance()).getString(kUserGenre) ?? 'homme';

// ── Palette (Brand Medical Identity) ─────────────────────────
class _O {
  static const bg      = Color(0xFFF8FAFC); // Brand background
  static const card    = Color(0xFFFFFFFF);
  static const accent  = Color(0xFF1F7AE0); // Brand secondary blue
  static const accentL = Color(0xFFEFF6FF); // Brand accent light
  static const teal    = Color(0xFF2DD4BF); // Brand turquoise
  static const txtP    = Color(0xFF0F172A); // Brand text dark
  static const txtS    = Color(0xFF64748B); // Brand text grey
  static const txtM    = Color(0xFF94A3B8); // Brand text muted
  static const border  = Color(0xFFE2E8F0); // Brand border
}

// ============================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {

  final _ctrl  = TextEditingController();
  final _focus = FocusNode();
  String _genre   = 'homme';
  bool   _loading = false;
  bool   _saved   = false;

  late final AnimationController _anim;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  @override
  void initState() {
    super.initState();
    _anim  = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 550));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose(); _focus.dispose(); _anim.dispose();
    super.dispose();
  }

  bool get _canContinue => _ctrl.text.trim().length >= 2;

  Future<void> _save() async {
    if (!_canContinue || _loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kUserPrenom, _ctrl.text.trim());
    await prefs.setString(kUserGenre,  _genre);
    await prefs.setBool(kOnbDone,      true);
    if (!mounted) return;
    setState(() { _loading = false; _saved = true; });
    await _anim.reverse();
    await _anim.forward();
  }

  void _goToApp() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => const MainScreen(),
      transitionsBuilder: (_, a, __, child) =>
          FadeTransition(opacity: a, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: _O.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: _saved ? _buildSuccess() : _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  // ── Formulaire ────────────────────────────────────────────
  Widget _buildForm() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

      // En-tête : logo centré + icône langue
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const SizedBox(width: 40),
        Column(children: [
          // ArLogo animé — vecteur officiel poumons + ECG
          const ArLogo(size: 80, animate: true),
          const SizedBox(height: 10),
          const Text('Anesthésie & Réanimation',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
              color: _O.txtP)),
          const Text('ASSISTANT CLINIQUE',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
              color: _O.teal, letterSpacing: 2.0)),
        ]),
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: _O.card, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _O.border)),
          child: const Icon(Icons.translate_rounded,
            color: _O.txtS, size: 18)),
      ]),

      const SizedBox(height: 36),

      const Text('Bienvenue !',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
          color: _O.txtP, letterSpacing: -0.3)),
      const SizedBox(height: 8),
      const Text(
        'Pour commencer, veuillez\nrenseigner vos informations',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13.5, color: _O.txtS, height: 1.5)),

      const SizedBox(height: 32),

      // Champ nom
      const Align(alignment: Alignment.centerLeft,
        child: Text('Votre nom',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
            color: _O.txtP))),
      const SizedBox(height: 8),
      TextField(
        controller: _ctrl, focusNode: _focus,
        onChanged: (_) => setState(() {}),
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
          color: _O.txtP),
        decoration: InputDecoration(
          hintText: 'Dc X',
          hintStyle: const TextStyle(color: _O.txtM, fontWeight: FontWeight.w400),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.person_outline_rounded,
              color: _O.txtS, size: 20)),
          prefixIconConstraints: const BoxConstraints(minWidth: 50),
          filled: true, fillColor: _O.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _O.border, width: 1)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _O.border, width: 1)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _O.accent, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 15),
        ),
      ),

      const SizedBox(height: 24),

      // Sélecteur genre
      const Align(alignment: Alignment.centerLeft,
        child: Text('Votre sexe',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
            color: _O.txtP))),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _GenreCard(
          label: 'Homme', icon: Icons.man_rounded,
          selected: _genre == 'homme',
          onTap: () { HapticFeedback.selectionClick();
                      setState(() => _genre = 'homme'); })),
        const SizedBox(width: 12),
        Expanded(child: _GenreCard(
          label: 'Femme', icon: Icons.woman_rounded,
          selected: _genre == 'femme',
          onTap: () { HapticFeedback.selectionClick();
                      setState(() => _genre = 'femme'); })),
      ]),

      const SizedBox(height: 36),

      // Bouton
      SizedBox(
        width: double.infinity,
        child: AnimatedOpacity(
          opacity: _canContinue ? 1.0 : 0.45,
          duration: const Duration(milliseconds: 200),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: _canContinue
                  ? const LinearGradient(
                      colors: [Color(0xFF0F4C81), Color(0xFF1F7AE0)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: _canContinue ? null : _O.accent,
              borderRadius: BorderRadius.circular(14),
              boxShadow: _canContinue
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1F7AE0).withOpacity(0.35),
                        blurRadius: 14, offset: const Offset(0, 5))
                    ]
                  : [],
            ),
            child: ElevatedButton(
              onPressed: _canContinue ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: _O.accent.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
                elevation: 0),
              child: _loading
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
                : const Text('Continuer',
                    style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ),
      ),

      const SizedBox(height: 14),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.lock_outline_rounded, size: 13, color: _O.txtM),
        SizedBox(width: 6),
        Text('Ces informations ne seront demandées qu\'une seule fois.',
          style: TextStyle(fontSize: 11.5, color: _O.txtM)),
      ]),
    ]),
  );

  // ── Confirmation ──────────────────────────────────────────
  Widget _buildSuccess() {
    final prenom = _ctrl.text.trim();
    final isF    = _genre == 'femme';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F4C81), Color(0xFF2DD4BF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1F7AE0).withOpacity(0.30),
                blurRadius: 20, offset: const Offset(0, 8)),
            ]),
          child: const Icon(Icons.check_rounded,
            color: Colors.white, size: 48)),
        const SizedBox(height: 28),

        const Text('Merci !',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
            color: _O.txtP)),
        const SizedBox(height: 8),
        const Text(
          'Vos informations ont été\nenregistrées avec succès.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: _O.txtS, height: 1.5)),

        const SizedBox(height: 32),

        // Résumé
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _O.card, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _O.border)),
          child: Column(children: [
            _SummaryRow(
              icon: Icons.badge_outlined,
              label: 'Nom', value: prenom),
            const Divider(height: 22, color: _O.border),
            _SummaryRow(
              icon: isF ? Icons.woman_rounded : Icons.man_rounded,
              label: 'Sexe', value: isF ? 'Femme' : 'Homme'),
          ]),
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F4C81), Color(0xFF2DD4BF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1F7AE0).withOpacity(0.40),
                  blurRadius: 14, offset: const Offset(0, 5)),
              ],
            ),
            child: ElevatedButton(
              onPressed: _goToApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
                elevation: 0),
              child: const Text('Démarrer l\'application',
                style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────
class _GenreCard extends StatelessWidget {
  final String label; final IconData icon;
  final bool selected; final VoidCallback onTap;
  const _GenreCard({required this.label, required this.icon,
    required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFF0F4C81), Color(0xFF1F7AE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: selected ? null : _O.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? const Color(0xFF1F7AE0) : _O.border,
          width: selected ? 1.5 : 1),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: const Color(0xFF1F7AE0).withOpacity(0.25),
                  blurRadius: 12, offset: const Offset(0, 4)),
              ]
            : [],
      ),
      child: Column(children: [
        Icon(icon, size: 32,
          color: selected ? Colors.white : _O.txtM),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : _O.txtM)),
      ]),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final IconData icon; final String label, value;
  const _SummaryRow({required this.icon,
    required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 36, height: 36,
      decoration: const BoxDecoration(
        color: _O.accentL, shape: BoxShape.circle),
      child: Icon(icon, color: _O.accent, size: 18)),
    const SizedBox(width: 14),
    Text(label, style: const TextStyle(fontSize: 13, color: _O.txtS)),
    const Spacer(),
    Text(value, style: const TextStyle(fontSize: 14,
      fontWeight: FontWeight.w600, color: _O.txtP)),
  ]);
}
