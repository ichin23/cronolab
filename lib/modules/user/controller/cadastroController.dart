import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroController {
  Future siginEmail(
      String email, String password, String nome, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.instance.currentUser!.updateDisplayName(nome);
    } catch (e) {
      debugPrint(e.toString());
      if (e.toString().contains("email-already-in-use")) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
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
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
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
