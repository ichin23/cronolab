import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TurmasStateDesktop with ChangeNotifier {
  List<Turma> turmas = [];
  Turma? turmaAtual;
  var db = FirebaseFirestore.instance;
  bool loading = false;
  String turmasColle = "turmas";
  String usersColle = "users";

  Future<Turma?> refreshTurma(String id) async {
    var response = await db.collection(turmasColle).doc(id).get();

    Turma newTurma = Turma.fromFirebase(response);

    var admin = await db
        .collection(turmasColle)
        .doc(id)
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.exists);

    debugPrint(admin.toString());
    if (admin) {
      newTurma.setAdmin();
    }
    var materias =
        await db.collection(turmasColle).doc(id).collection("materias").get();
    List<Materia> listMat = [];

    for (var materia in materias.docs) {
      var materiaData = materia.data();
      materiaData["id"] = materia.id;

      var materiaClass = Materia.fromJson(materiaData);

      listMat.add(materiaClass);
    }

    newTurma.setMaterias = listMat;

    return newTurma;
  }

  changeTurmaAtual(Turma turma) {
    turmaAtual = turma;
    debugPrint("changre");
    notifyListeners();
  }

  initTurma(String code, BuildContext context) async {
    changeLoading = true;

    var existe = await db
        .collection(turmasColle)
        .doc(code)
        .get()
        .then((value) => value.exists);

    if (!existe) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
                        Navigator.pop(context);
                      },
                      child: const Text("Não")),
                  TextButton(
                      onPressed: () async {
                        await db
                            .collection(turmasColle)
                            .doc(code)
                            .set({"nome": code});
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
                        Navigator.pop(context);
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

  Future getTurmas(BuildContext context) async {
    try {
      changeLoading = true;
      debugPrint("GetTurmas");
      var minhasTurmas = await db
          .collection(usersColle)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("turmas")
          .get();
      debugPrint(minhasTurmas.toString());
      turmas.clear();
      for (var turmaQuery in minhasTurmas.docs) {
        Map<String, dynamic> turma = {
          "id": turmaQuery.id,
          "nome": turmaQuery.id
        };
        var turmaAdd = Turma.fromFirebase(turmaQuery);

        var admin = await db
            .collection(turmasColle)
            .doc(turmaQuery.id)
            .collection("admins")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) => value.exists);

        debugPrint(admin.toString());
        if (admin) {
          turma["admin"] = true;
        }
        var materias = await db
            .collection(turmasColle)
            .doc(turma["id"])
            .collection("materias")
            .get();
        List<Materia> listMat = [];

        // var turmaAdd = Turma.fromJson(turma);

        if (turma["admin"] == true) {
          turmaAdd.setAdmin();
        }

        for (var materia in materias.docs) {
          var materiaData = materia.data();
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
        await turmaAtual!.getAtividadesDesk(context);
        context
            .read<DeveresController>()
            .buildCalendar(DateTime.now(), context);
        changeLoading = false;
        //notifyListeners();
        return turmas;
      }

      changeLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  set changeLoading(bool load) {
    loading = load;
    debugPrint(loading.toString());
    notifyListeners();
  }

  createMateria(Materia materia, String idTurma) async {
    await FirebaseFirestore.instance
        .collection("turmas")
        .doc(idTurma)
        .collection("materias")
        .add(materia.toJson());
  }
}
