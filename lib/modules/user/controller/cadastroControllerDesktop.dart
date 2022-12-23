import 'package:cronolab/shared/colors.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CadastroController {
  Future siginEmail(
      String email, String password, String nome, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signUp(email, password);
      FirebaseAuth.instance.updateProfile(displayName: nome);
    } catch (e) {
      debugPrint(e.toString());
      if (e.toString().contains("email-already-in-use")) {
        Get.dialog(
          const AlertDialog(
            backgroundColor: backgroundDark,
            title: Text(
              "Erro no cadastro",
              style: TextStyle(color: whiteColor),
            ),
            content: Text("Esse email já é usado por outra conta",
                style: TextStyle(color: whiteColor)),
          ),
        );
      } else {
        Get.dialog(
          const AlertDialog(
            backgroundColor: backgroundDark,
            title: Text(
              "Erro no cadastro",
              style: TextStyle(color: whiteColor),
            ),
            content: Text("Ocorreu um erro ao cadastrar sua conta",
                style: TextStyle(color: whiteColor)),
          ),
        );
      }
    }
  }
}
