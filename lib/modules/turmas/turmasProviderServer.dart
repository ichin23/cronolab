import 'dart:convert';

import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TurmasProvider extends ChangeNotifier {
  String url = "https://cronolab-server.herokuapp.com";
  List<Turma> turmas = [];
  Turma? turmaAtual;
  bool loading = false;
  TurmasProvider() {
    // getTurmas();
  }

  changeTurma(Turma newTurma) {
    turmaAtual = newTurma;
    // turmaAtual!.getAtividades();
    notifyListeners();
  }

  refreshTurma(String id) async {
    print(id);
    var response = await http.get(
      Uri.parse(url + "/class?id=$id"),
      headers: {
        "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
      },
    );

    Turma newTurma = Turma.fromJson(jsonDecode(response.body));
    var index = turmas.indexWhere((element) => element.id == id);
    turmas[index] = newTurma;
    notifyListeners();
    // turmas.(, turmas.indexWhere((element) => element.id == id), newTurma) ;
  }

  initTurma(String code) async {
    var response = await http.put(Uri.parse(url + "/class"),
        headers: {
          "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "idTurma": code,
          "data": {"nome": code}
        }));
  }

  Future getTurmas() async {
    // print("Chamou");
    print("Pega turma;");
    loading = true;
    // notifyListeners();
    var response = await http.get(
      Uri.parse(url + "/users/turmas"),
      headers: {
        "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
      },
    );
    print("OK");
    var turmasJson = json.decode(response.body)["turmas"] as List;
    // print(turmasJson);
    if (turmasJson.isNotEmpty) {
      turmas.clear();
      for (Map<String, dynamic> turma in turmasJson) {
        var turmaAdd = Turma.fromJson(turma);
        if (turma["admin"] == true) {
          turmaAdd.setAdmin();
        }
        List materias = turma["materias"];
        List<Materia> listMat = materias.map((mat) {
          // print(mat);
          return Materia.fromJson(mat);
        }).toList();
        // print(listMat[0].contato);

        turmaAdd.setMaterias = listMat;

        turmas.add(turmaAdd);
      }
    }
    turmaAtual = turmas[0];
    loading = false;
    print(turmas);
    notifyListeners();
  }
}
