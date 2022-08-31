import 'dart:convert';
import 'dart:io';

import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TurmasState extends GetxController {
  String url = "https://cronolab-server.herokuapp.com";
  static TurmasState get to => Get.find();
  List<Turma> turmas = [];
  Turma? turmaAtual;

  bool loading = false;

  Future<Turma> refreshTurma(String id) async {
    print(id);
    var response = await http.get(
      Uri.parse(url + "/class?id=$id"),
      headers: {
        "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
      },
    );

    Turma newTurma = Turma.fromJson(jsonDecode(response.body));

    return newTurma;
  }

  changeTurmaAtual(Turma turma) {
    turmaAtual = turma;
    update();
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

  deleteTurma(String code) async {
    var response = await http.delete(Uri.parse(url + "/class"),
        headers: {
          "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "turmaID": code,
        }));
  }

  Future getTurmas() async {
    // print("Chamou");

    loading = true;
    // update();
    var response = await http.get(
      Uri.parse(url + "/users/turmas"),
      headers: {
        "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
      },
    );

    var turmasJson = json.decode(response.body)["turmas"] as List;

    if (turmasJson.isNotEmpty) {
      turmas.clear();
      for (Map<String, dynamic> turma in turmasJson) {
        var turmaAdd = Turma.fromJson(turma);
        if (turma["admin"] == true) {
          turmaAdd.setAdmin();
        }
        if (Platform.isAndroid || Platform.isIOS) {
          TurmasLocal.to.addTurma(turmaAdd);
        }
        List materias = turma["materias"];
        List<Materia> listMat = materias.map((mat) {
          var materia = Materia.fromJson(mat);

          return materia;
        }).toList();
        for (var materia in listMat) {
          if (Platform.isAndroid || Platform.isIOS) {
            await TurmasLocal.to.addMateria(materia, turmaAdd.id);
          }
        }

        // print(listMat[0].contato);

        turmaAdd.setMaterias = listMat;
        await turmaAdd.getAtividades();
        turmas.add(turmaAdd);
      }
      turmaAtual = turmas[0];
      print(turmas);
      return;
    }

    loading = false;

    update();
  }
}
