import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login_ecran.dart';

void main() async {
  // Initialiser Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Firebase avec les options de configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurer les providers d'authentification
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Produits',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Ajouter d'autres personnalisations du thème si nécessaire
        useMaterial3: true, // Utiliser Material 3 pour un design moderne
      ),
      // Désactiver la bannière de debug
      debugShowCheckedModeBanner: false,
      home: const LoginEcran(),
    );
  }
}