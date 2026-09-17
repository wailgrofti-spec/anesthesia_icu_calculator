# Anesthesia & ICU Calculator v2

## How to open in Android Studio

1. Extract the ZIP file
2. Open Android Studio
3. File → Open → select the `anesthesia_icu_calculator` folder
4. Wait for Gradle sync to complete
5. Run `flutter pub get` in the terminal
6. Press Run (▶)

## Features

- **Patient Screen** — Weight, Height, Age, Sex → BMI, IBW, LBW, BSA
- **Vitals Screen** — Color-coded Signes vitaux (green/yellow/red), MAP, Pulse Pressure
- **Drug Calculator** — 21 drugs with weight-based doses + ml/h infusion calculator
- **Emergency Screen** — Quick drugs, 5 protocols, expandable drug list
- **Dark Mode** — Toggle in Patient tab header

## Drug Library (21 drugs)

### Sedation / Induction
Propofol · Ketamine · Midazolam · Etomidate · Thiopental · Dexmedetomidine

### Analgesia
Fentanyl · Remifentanil · Sufentanil · Morphine

### Neuromuscular Blockers
Rocuronium · Atracurium · Cisatracurium · Succinylcholine

### Vasopressors / Inotropes
Noradrenaline · Adrenaline · Dopamine · Dobutamine · Vasopressin · Phenylephrine · Ephedrine

### Other
Lidocaine

## Emergency Protocols
- Cardiac Arrest (ACLS)
- Rapid Sequence Intubation (RSI)
- Septic Shock (Surviving Sepsis Bundle)
- Cardiogenic Shock
- Anaphylactic Shock

## Requirements
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android SDK 21+

## Disclaimer
FOR EDUCATIONAL USE ONLY. Not a substitute for clinical judgment.
