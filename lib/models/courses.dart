// ============================================================================
//  lib/models/courses.dart
//  VERSION 3.0 — Modèles purs Subject & Semester, sourcés
//
//  Ce fichier contient UNIQUEMENT les modèles de données.
//  Screens → lib/screens/courses_screen.dart
//  Données → lib/data/courses_data.dart
//  Pas de main(), pas de widgets, pas de données statiques ici.
//
//  Sources de conception :
//  [CLEAN] Clean Architecture — Robert C. Martin, 2017.
//          Séparation modèles / données / UI.
//  [DART]  Effective Dart — https://dart.dev/guides/language/effective-dart
//          @immutable, const constructors, copyWith pattern.
// ============================================================================

import 'package:flutter/foundation.dart';

// ============================================================================
//  SUBJECT — Matière médicale
// ============================================================================

/// Matière d'enseignement médical avec ses ressources en ligne.
///
/// Immutable : toute modification passe par [copyWith].
/// Sérialisable : [toMap] / [fromMap] pour persistance locale (SharedPreferences).
@immutable
class Subject {
  /// Nom de la matière (ex. 'Anatomie', 'Pharmacologie').
  final String name;

  /// URLs des ressources de cours (Google Drive, PDF, YouTube, etc.).
  final List<String> links;

  /// Description optionnelle de la matière / objectifs pédagogiques.
  final String? description;

  /// Icône optionnelle — nom Material Icon ou emoji.
  final String? iconName;

  const Subject({
    required this.name,
    required this.links,
    this.description,
    this.iconName,
  });

  // ── Helpers ────────────────────────────────────────────────

  bool get hasLinks  => links.isNotEmpty;
  int  get linkCount => links.length;

  // ── copyWith ──────────────────────────────────────────────

  Subject copyWith({
    String?       name,
    List<String>? links,
    Object?       description = _sentinel,
    Object?       iconName    = _sentinel,
  }) {
    return Subject(
      name:        name        ?? this.name,
      links:       links       ?? this.links,
      description: description == _sentinel ? this.description : description as String?,
      iconName:    iconName    == _sentinel ? this.iconName    : iconName    as String?,
    );
  }

  // ── Sérialisation ─────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'name':        name,
    'links':       links,
    'description': description,
    'iconName':    iconName,
  };

  factory Subject.fromMap(Map<String, dynamic> map) => Subject(
    name:        map['name']        as String,
    links:       List<String>.from(map['links'] ?? const []),
    description: map['description'] as String?,
    iconName:    map['iconName']    as String?,
  );

  // ── Equatable ─────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subject && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Subject($name — ${linkCount} lien(s))';
}

// ============================================================================
//  SEMESTER — Semestre universitaire
// ============================================================================

/// Semestre d'études médicales contenant une liste de matières.
@immutable
class Semester {
  /// Identifiant du semestre ('S1', 'S2', …, 'S12').
  final String name;

  /// Titre descriptif du semestre (ex. 'Tronc commun', 'Clinique').
  final String? title;

  /// Liste des matières de ce semestre.
  final List<Subject> subjects;

  const Semester({
    required this.name,
    required this.subjects,
    this.title,
  });

  // ── Helpers ────────────────────────────────────────────────

  int  get subjectCount => subjects.length;
  int  get totalLinks   => subjects.fold(0, (sum, s) => sum + s.linkCount);
  bool get isEmpty      => subjects.isEmpty;

  // ── copyWith ──────────────────────────────────────────────

  Semester copyWith({
    String?        name,
    String?        title,
    List<Subject>? subjects,
  }) {
    return Semester(
      name:     name     ?? this.name,
      title:    title    ?? this.title,
      subjects: subjects ?? this.subjects,
    );
  }

  // ── Sérialisation ─────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'name':     name,
    'title':    title,
    'subjects': subjects.map((s) => s.toMap()).toList(),
  };

  factory Semester.fromMap(Map<String, dynamic> map) => Semester(
    name:  map['name']  as String,
    title: map['title'] as String?,
    subjects: (map['subjects'] as List<dynamic>? ?? [])
        .map((e) => Subject.fromMap(e as Map<String, dynamic>))
        .toList(),
  );

  // ── Equatable ─────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Semester && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Semester($name — ${subjectCount} matière(s))';
}

// ── Sentinelle pour copyWith nullable ────────────────────────
const _Sentinel _sentinel = _Sentinel();
class _Sentinel { const _Sentinel(); }