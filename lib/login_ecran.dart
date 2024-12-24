import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'liste_produits.dart'; // Importez la liste des produits à la place

class LoginEcran extends StatelessWidget {
  const LoginEcran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ProduitsList(); // Redirigez vers la liste des produits
        }

        return SignInScreen(
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              if (state.user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProduitsList(), // Redirigez vers la liste des produits
                  ),
                );
              }
            }),
          ],
        );
      },
    );
  }
}