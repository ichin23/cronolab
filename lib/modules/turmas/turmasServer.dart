import 'dart:convert';
import 'dart:io';

import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TurmasState extends GetxController {
  String url = "https://cronolab-server.herokuapp.com";
  static TurmasState get to => Get.find();
  List<Turma> turmas = [];
  Turma? turmaAtual;

  bool loading = false;

  Future<Turma> refreshTurma(String id) async {
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
    changeLoading = true;
    var response = await http.put(Uri.parse(url + "/class"),
        headers: {
          "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "idTurma": code,
          "data": {"nome": code}
        }));

    bool works = jsonDecode(response.body)["newTurma"] ?? false;
    if (works) {
      await Get.dialog(AlertDialog(
        backgroundColor: black,
        title: const Text(
          "Turma não encontrada",
          style: label,
        ),
        content: const Text(
          "Deseja criar uma nova turma?",
          style: label,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Não")),
          TextButton(
              onPressed: () async {
                var response = await http.put(Uri.parse(url + "/class"),
                    headers: {
                      "authorization":
                          "Bearer " + FirebaseAuth.instance.currentUser!.uid,
                      "Content-Type": "application/json",
                    },
                    body: jsonEncode({
                      "idTurma": code,
                      "data": {"nome": code},
                      "confirm": true
                    }));
                Get.back();
              },
              child: const Text("Sim"))
        ],
      ));
    } else {
      Get.back();
    }

    changeLoading = false;
  }

  deleteTurma(String code) async {
    changeLoading = true;
    var response = await http.delete(Uri.parse(url + "/class"),
        headers: {
          "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "turmaID": code,
        }));
    changeLoading = false;
  }

  Future getTurmas() async {
    try {
      changeLoading = true;

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

        changeLoading = false;
        update();
        return turmas;
      }
      changeLoading = false;
      update();
    } catch (e) {
      print(e.runtimeType);
      e.printError();
      e.printInfo();
    }
  }

  set changeLoading(bool load) {
    loading = load;
    print(loading);
    update();
  }
}
