// ===========================
//  lib/main.dart
//  Forced cache invalidation
// ===========================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'utils/theme.dart';

// ===========================================================
//  POINT D'ENTRÉE
// ===========================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('Firebase initialization timed out or failed: $e');
  }
  */

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:          Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),   // ← AppProvider contient maintenant les pathologies
      child: const AnesthesiaApp(),
    ),
  );
}

// ===========================================================
//  APPLICATION PRINCIPALE
// ===========================================================

class AnesthesiaApp extends StatelessWidget {
  const AnesthesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return MaterialApp(
      title:                      'Anesthésie & Réanimation',
      debugShowCheckedModeBanner: false,
      theme:     AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const MainScreen(),
      },
    );
  }
}