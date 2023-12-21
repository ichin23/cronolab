import 'dart:convert';

import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:cronolab/shared/routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  Future loginGoogle(BuildContext context) async {
    try {
      var google = GoogleSignIn(
          scopes: ['email'],
          clientId:
              "286245196387-g2p299n53kb6t1am4qdbsk51rmevtll5.apps.googleusercontent.com");
      final GoogleSignInAccount? account;
      if (kIsWeb) {
        account = await google.signInSilently();
      } else {
        account = await google.signIn();
      }
      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;
      // Create a new credential
      /*final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set({"nome": user.displayName, "email": user.email});
      if (!kIsWeb) {
        OneSignal().setExternalUserId(FirebaseAuth.instance.currentUser!.uid);
      }*/
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
}
