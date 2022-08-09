import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      if (!kIsWeb) {
        OneSignal().setExternalUserId(FirebaseAuth.instance.currentUser!.uid);
      }
    } catch (e) {
      print(e);
      Get.dialog(AlertDialog(
        title: const Text("Erro", style: fonts.label),
        content: const Text("Ocorreu um erro ao realizar o login"),
        backgroundColor: darkPrimary,
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
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
      Get.dialog(
        const AlertDialog(
          backgroundColor: black,
          title: Text(
            "Erro no login",
            style: TextStyle(color: white),
          ),
          content: Text(
              "Email ou senha incorretos. Certeza que já possui sua conta?",
              style: TextStyle(color: white)),
        ),
      );
      print(e);
    }
  }
}
