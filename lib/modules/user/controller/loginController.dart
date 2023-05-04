import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginController {
  Future loginGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? account = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set(
          {"nome": user.displayName, "email":user.email });
      if (!kIsWeb) {
        OneSignal().setExternalUserId(FirebaseAuth.instance.currentUser!.uid);
      }
    } catch (e) {
      debugPrint(e.runtimeType.toString());
      print(e);

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Erro", style: fonts.labelDark),
                content: const Text("Ocorreu um erro ao realizar o login"),
                backgroundColor: darkPrimary,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              ));
    }
  }

  Future loginEmail(email, senha, context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: backgroundDark,
          title: Text(
            "Erro no login",
            style: TextStyle(color: whiteColor),
          ),
          content: Text(
              "Email ou senha incorretos. Certeza que já possui sua conta?",
              style: TextStyle(color: whiteColor)),
        ),
      );
      debugPrint(e.toString());
    }
  }
}
