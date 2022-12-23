import 'package:cronolab/shared/colors.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginControllerDesktop {
  Future loginEmail(email, senha, context) async {
    try {
      await FirebaseAuth.instance.signIn(email, senha);
    } catch (e) {
      Get.dialog(
        const AlertDialog(
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
