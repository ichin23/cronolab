import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurmasState extends GetxController {
  static TurmasState get to => Get.find();
  List<Turma> turmas = [];
  Turma? turmaAtual;
  var db = FirebaseFirestore.instance;
  bool loading = false;
  String turmasColle = "turmas";
  String usersColle = "users";

  Future<Turma> refreshTurma(String id) async {
    var response = await db.collection(turmasColle).doc(id).get().then((value) {
      var result = value.data()!;
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

    var exist =
        await db.collection(turmasColle).doc(code).get().then((docSnap) {
      if (docSnap.exists) {
        return true;
      } else {
        return false;
      }
    });
    if (!exist) {
      await Get.dialog(AlertDialog(
        title: Text(
          "Turma não encontrada",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        content: Text(
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
                await db.collection(turmasColle).doc(code).set({"nome": code});
                await db
                    .collection(usersColle)
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("turmas")
                    .doc(code)
                    .set({'id': code});
                await db
                    .collection(turmasColle)
                    .doc(code)
                    .collection("admins")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({});
                Get.back();
              },
              child: const Text("Sim"))
        ],
      ));
    } else {
      await db
          .collection(usersColle)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("turmas")
          .doc(code)
          .set({'id': code});
    }

    changeLoading = false;
  }

  deleteTurma(String code) async {
    changeLoading = true;

    await db
        .collection(usersColle)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("turmas")
        .doc(code)
        .delete();
    changeLoading = false;
  }

  Future getTurmas() async {
    try {
      changeLoading = true;

      var minhasTurmas = await db
          .collection(usersColle)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("turmas")
          .get();

      for (var turmaQuery in minhasTurmas.docs) {
        Map<String, dynamic> turma = {
          "id": turmaQuery.id,
          "nome": turmaQuery.id
        };
        var admin = await db
            .collection(turmasColle)
            .doc(turmaQuery.id)
            .collection("admins")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (admin.exists) {
          turma["admin"] = true;
        }
        var materias = await db
            .collection(turmasColle)
            .doc(turma["id"])
            .collection("materias")
            .get();
        List<Materia> listMat = [];

        var turmaAdd = Turma.fromJson(turma);

        if (turma["admin"] == true) {
          turmaAdd.setAdmin();
        }

        if (Platform.isAndroid || Platform.isIOS) {
          TurmasLocal.to.addTurma(turmaAdd);
        }

        for (var materia in materias.docs) {
          var materiaData = materia.data();
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
    debugPrint(loading.toString());
    update();
  }
}
