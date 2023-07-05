import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginControllerDesktop {
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
