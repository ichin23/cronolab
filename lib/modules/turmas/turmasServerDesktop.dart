import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
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
    debugPrint("changre");
    update();
  }

  initTurma(String code, BuildContext context) async {
    changeLoading = true;

    var result = await db.collection(turmasColle).document(code).exists;
    var exist = false;
    if (result) {
      exist = true;
    } else {
      exist = false;
    }

    if (!exist) {
      await Get.dialog(AlertDialog(

        title:  Text(
          "Turma não encontrada",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        content:  Text(
          "Deseja criar uma nova turma?",
          style: Theme.of(context).textTheme.labelMedium,
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
      update();
      debugPrint("GetTurmas");
      var minhasTurmas = await db
          .collection(usersColle)
          .document(FirebaseAuth.instance.userId)
          .collection("turmas")
          .get();
      debugPrint(minhasTurmas.toString());
      turmas.clear();
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
            .exists;
        debugPrint(admin.toString());
        if (admin) {
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

          listMat.add(materiaClass);
        }

        turmaAdd.setMaterias = listMat;

        turmas.add(turmaAdd);
        debugPrint(turmas.toString());
      }
      if (turmas.isNotEmpty) {
        turmaAtual = turmas[0];
        debugPrint(turmaAtual!.id);
        await turmaAtual!.getAtividadesDesk();
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
    debugPrint(loading.toString());
    update();
  }
}
