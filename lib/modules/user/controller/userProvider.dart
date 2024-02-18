import 'dart:convert';

import 'package:cronolab/shared/colors.dart';
import 'package:http/http.dart' as http;
import 'package:cronolab/shared/routes.dart' as r;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider {
  ValueNotifier<String?> token = ValueNotifier(null);
  ValueNotifier<String?> nome = ValueNotifier(null);
  ValueNotifier<String?> email = ValueNotifier(null);

  SharedPreferences? preferences;

  UserProvider() {
    SharedPreferences.getInstance().then((value) {
      preferences = value;
      getData();
    });
  }

  setData(Map data) {
    data.forEach((key, value) {
      preferences?.setString(key, value);
    });
  }

  cadastro(
      String nome, String email, String senha, BuildContext context) async {
    try {
      var values = await http.post(r.cadastro,
          headers: r.headers,
          body: jsonEncode({
            "email": email,
            "password": senha,
            "nome": nome,
          }));
      await login(email, senha, context);
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
    }
  }

  login(String email, String senha, BuildContext context) async {
    try {
      var value = await http.post(r.login,
          headers: r.headers,
          body: jsonEncode({
            "email": email,
            "password": senha,
          }));

      if (value.statusCode == 200) {
        var body = jsonDecode(value.body) as Map;
        token.value = body["accessToken"];
        preferences!.setString("accessToken", body["accessToken"]);
        this.email.value = body["email"];
        nome.value = body["nome"];
      }
    } catch (e) {
      print(e);
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
    }
    print(token.value);
  }

  getData() {
    var tokenNew = preferences?.getString("accessToken");
    token.value = tokenNew == null || tokenNew.isEmpty ? null : tokenNew;
    nome.value = preferences?.getString("nome");
    email.value = preferences?.getString("email");
  }

  void signOut() {
    preferences?.setString("accessToken", "");
    preferences?.setString("nome", "");
    preferences?.setString("email", "");
    token.value = null;
    email.value = null;
    nome.value = null;
  }
}
