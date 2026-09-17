// ============================================================
//  lib/screens/main_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/theme.dart';

import 'patient_screen.dart';
import 'respiratory_screen.dart';
import 'drugs_screen.dart';
import 'ecran_pathologies.dart';
import 'protocols_screen.dart';    // vrai écran Emergency/Protocoles
import 'courses_screen.dart';
import 'anesthesia_notes_screen.dart';

// ============================================================
//  PALETTE
// ============================================================
class _Nav {
  static const accent      = Color(0xFF1F7AE0); // brand secondary blue
  static const accentLight = Color(0xFFEFF6FF);
  static const barBg       = Color(0xCCFFFFFF);
  static const barBorder   = Color(0x1A1F7AE0);
  static const inactiveIc  = Color(0xFF94A3B8);
  static const shadow      = Color(0x0F0F4C81);
  static const darkBarBg   = Color(0xE00F172A); // more opaque dark nav
  static const darkBorder  = Color(0x2038BDF8); // sky blue border in dark
  static const darkIc      = Color(0xFF475569);
  static const darkActive  = Color(0xFF0E2A4A); // brand dark blue active bg
}

// ============================================================
//  DONNÉES DE NAVIGATION
// ============================================================
class _NavData {
  final String   label;
  final IconData icon;
  final IconData activeIcon;
  final Widget   screen;
  const _NavData({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.screen,
  });
}

const List<_NavData> _navItems = [
  _NavData(
    label:      'Patient',
    icon:       Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    screen:     PatientScreen(),
  ),
  _NavData(
    label:      'Respiratoire',
    icon:       Icons.air_outlined,
    activeIcon: Icons.air_rounded,
    screen:     RespiratoryScreen(),
  ),
  _NavData(
    label:      'Drugs',
    icon:       Icons.medication_outlined,
    activeIcon: Icons.medication_rounded,
    screen:     DrugsScreen(),
  ),
  _NavData(
    label:      'Pathologies',
    icon:       Icons.medical_information_outlined,
    activeIcon: Icons.medical_information_rounded,
    screen:     EcranPathologies(),
  ),
  _NavData(
    label:      'Emergency',
    icon:       Icons.emergency_outlined,
    activeIcon: Icons.emergency_rounded,
    screen:     ProtocolsScreen(),
  ),
  _NavData(
    label:      'Cours',
    icon:       Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
    screen:     CoursesScreen(),
  ),
  _NavData(
    label:      'Notes',
    icon:       Icons.edit_note_rounded,
    activeIcon: Icons.edit_note_rounded,
    screen:     AnesthesiaNotesScreen(),
  ),
];

// ============================================================
//  MAIN SCREEN
// ============================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _idx = 0;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:          Colors.transparent,
      statusBarIconBrightness: _isDark ? Brightness.light : Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: _isDark
          ? const Color(0xFF08111F)
          : const Color(0xFFF8FAFC),
      extendBody: true,
      body: IndexedStack(
        index: _idx,
        children: _navItems.map((n) => n.screen).toList(),
      ),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _idx,
        isDark:       _isDark,
        onTap:        (i) => setState(() => _idx = i),
      ),
    );
  }
}

// ============================================================
//  BARRE FLOTTANTE
// ============================================================
class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final barBg     = isDark ? _Nav.darkBarBg  : _Nav.barBg;
    final barBorder = isDark ? _Nav.darkBorder : _Nav.barBorder;
    final inactIc   = isDark ? _Nav.darkIc     : _Nav.inactiveIc;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, bottomPad > 0 ? bottomPad : 10),
      decoration: BoxDecoration(
        color:        barBg,
        borderRadius: BorderRadius.circular(24),
        border:       Border.all(color: barBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color:        _Nav.shadow,
            blurRadius:   20,
            spreadRadius: 0,
            offset:       const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Teal gradient accent line at top of nav bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F4C81).withOpacity(isDark ? 0.8 : 0.6),
                    const Color(0xFF2DD4BF).withOpacity(isDark ? 0.8 : 0.6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (i) => _NavItem(
                  data:     _navItems[i],
                  isActive: i == currentIndex,
                  isDark:   isDark,
                  inactIc:  inactIc,
                  onTap:    () => onTap(i),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  ITEM INDIVIDUEL
// ============================================================
class _NavItem extends StatelessWidget {
  final _NavData     data;
  final bool         isActive;
  final bool         isDark;
  final Color        inactIc;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.isActive,
    required this.isDark,
    required this.inactIc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:    onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve:    Curves.easeInOut,
        padding:  isActive
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 6,  vertical: 5),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? _Nav.darkActive : _Nav.accentLight)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                isActive ? data.activeIcon : data.icon,
                key:   ValueKey(isActive),
                size:  20,
                color: isActive ? _Nav.accent : inactIc,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              data.label,
              style: TextStyle(
                fontSize:   8.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color:      isActive ? _Nav.accent : inactIc,
              ),
            ),
          ],
        ),
      ),
    );
  }
}