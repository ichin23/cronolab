import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurmasStateDesktop extends GetxController {
  static TurmasStateDesktop get to => Get.find();
  List<Turma> turmas = [];
  Turma? turmaAtual;
  var db = Firestore.instance;
  bool loading = false;
  String turmasColle = "turmas";
  String usersColle = "users";

  Future<Turma> refreshTurma(String id) async {
    var response =
        await db.collection(turmasColle).document(id).get().then((value) {
      var result = value.map;
      result["id"] = value.id;
      return result;
    });

    Turma newTurma = Turma.fromJson(response);

    return newTurma;
  }

  changeTurmaAtual(Turma turma) {
    turmaAtual = turma;
    print("changre");
    update();
  }

  initTurma(String code) async {
    changeLoading = true;

    var result = await db.collection(turmasColle).document(code).get();
    var exist = false;
    if (await result.reference.exists) {
      exist = true;
    } else {
      exist = false;
    }

    if (!exist) {
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
                await db
                    .collection(turmasColle)
                    .document(code)
                    .set({"nome": code});
                await db
                    .collection(usersColle)
                    .document(FirebaseAuth.instance.userId)
                    .collection("turmas")
                    .document(code)
                    .set({'id': code});
                await db
                    .collection(turmasColle)
                    .document(code)
                    .collection("admins")
                    .document(FirebaseAuth.instance.userId)
                    .set({});
                Get.back();
              },
              child: const Text("Sim"))
        ],
      ));
    } else {
      await db
          .collection(usersColle)
          .document(FirebaseAuth.instance.userId)
          .collection("turmas")
          .document(code)
          .set({'id': code});
    }

    changeLoading = false;
  }

  deleteTurma(String code) async {
    changeLoading = true;

    await db
        .collection(usersColle)
        .document(FirebaseAuth.instance.userId)
        .collection("turmas")
        .document(code)
        .delete();
    changeLoading = false;
  }

  Future getTurmas() async {
    try {
      changeLoading = true;

      var minhasTurmas = await db
          .collection(usersColle)
          .document(FirebaseAuth.instance.userId)
          .collection("turmas")
          .get();

      for (var turmaQuery in minhasTurmas.toList()) {
        Map<String, dynamic> turma = {
          "id": turmaQuery.id,
          "nome": turmaQuery.id
        };
        var admin = await db
            .collection(turmasColle)
            .document(turmaQuery.id)
            .collection("admins")
            .document(FirebaseAuth.instance.userId)
            .get();
        if (await admin.reference.exists) {
          turma["admin"] = true;
        }
        var materias = await db
            .collection(turmasColle)
            .document(turma["id"])
            .collection("materias")
            .get();
        List<Materia> listMat = [];

        var turmaAdd = Turma.fromJson(turma);

        if (turma["admin"] == true) {
          turmaAdd.setAdmin();
        }

        for (var materia in materias.toList()) {
          var materiaData = materia.map;
          materiaData["id"] = materia.id;

          var materiaClass = Materia.fromJson(materiaData);

          await TurmasLocal.to.addMateria(materiaClass, turmaQuery.id);

          listMat.add(materiaClass);
        }

        turmaAdd.setMaterias = listMat;

        turmas.add(turmaAdd);
      }

      if (turmas.isNotEmpty) {
        turmaAtual = turmas[0];
        await turmaAtual!.getAtividades();
        changeLoading = false;
        update();
        return turmas;
      }

      changeLoading = false;
      update();
    } catch (e) {
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
