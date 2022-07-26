import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CadastroController {
  Future siginEmail(
      String email, String password, String nome, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.instance.currentUser!.updateDisplayName(nome);
    } catch (e) {
      print(e.toString());
      if (e.toString().contains("email-already-in-use")) {
        Get.dialog(
          const AlertDialog(
            backgroundColor: black,
            title: Text(
              "Erro no cadastro",
              style: TextStyle(color: white),
            ),
            content: Text("Esse email já é usado por outra conta",
                style: TextStyle(color: white)),
          ),
        );
      } else {
        Get.dialog(
          const AlertDialog(
            backgroundColor: black,
            title: Text(
              "Erro no cadastro",
              style: TextStyle(color: white),
            ),
            content: Text("Ocorreu um erro ao cadastrar sua conta",
                style: TextStyle(color: white)),
          ),
        );
      }
    }
  }
}
