/*
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TurmasStateDesktop with ChangeNotifier {
  List<Turma> turmas = [];
  Turma? turmaAtual;
  var db = FirebaseFirestore.instance;
  bool loading = false;
  String turmasColle = "turmas";
  String usersColle = "users";

  refreshDeveres(BuildContext context) async {
    if (turmaAtual == null) {
      getAllDeveres();
    } else {
      await turmaAtual!.getAtividadesDesk(context);
    }
    notifyListeners();
    return;
  }

  List<Dever> getAllDeveres() {
    List<Dever> deveres = [];
    for (var turma in turmas) {
      deveres = [...?(turma.deveres), ...deveres];
    }

    deveres.sort((a, b) => a.data.compareTo(b.data));
    return deveres;
  }

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

  changeTurmaAtual(Turma? turma) {
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

  updateMateria(String turmaId, Materia materia) {
    for (int i = 0; i < turmas.length; i++) {
      if (turmas[i].id == turmaId) {
        for (int j = 0; j < turmas[i].materia.length; j++) {
          if (turmas[i].materia[j].id == materia.id) {
            turmas[i].materia[j] = materia;
          }
        }
      }
    }
    notifyListeners();
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
      List<Turma> newTurmas = [];
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

        newTurmas.add(turmaAdd);
        debugPrint(turmas.toString());
      }
      turmas = newTurmas;
      Future.forEach(
          turmas,
          (Turma turma) => turma.getAtividadesDesk(context).then((value) {
                notifyListeners();
              })).then((value) {
        if (context.mounted) {
          context
              .read<DeveresController>()
              .buildCalendar(DateTime.now(), context);
        }
      });

      changeLoading = false;

      notifyListeners();
      return turmas;
    } catch (e) {
      print(e);
    }
  }

  Turma? getTurmaByDever(String deverID) {
    for (var turma in turmas) {
      if (turma.deveres!.where((element) => element.id == deverID).isNotEmpty) {
        return turma;
      }
    }
    return null;
  }

  Future<List<Map>> getAdmins(String turmaID) async {
    var adminsFB = (await FirebaseFirestore.instance
        .collection("turmas")
        .doc(turmaID)
        .collection("admins")
        .get());
    List<Map> admins = [];
    for (var admin in adminsFB.docs) {
      Map data = (await FirebaseFirestore.instance
                  .collection("users")
                  .doc(admin.id)
                  .get())
              .data() ??
          {};
      data["id"] = admin.id;
      admins.add(data);
    }

    return admins;
  }

  Future<List<Map>> getParticipantes(String turmaID) async {
    var participantesFB = (await FirebaseFirestore.instance
        .collectionGroup("turmas")
        .where("id", isEqualTo: turmaID)
        .get());
    List<Map> participantes = [];
    for (var participante in participantesFB.docs) {
      var id = participante.reference.path.split("/")[1];
      Map data = {"id": id};
      var dataFB =
          (await FirebaseFirestore.instance.collection("users").doc(id).get());

      if (dataFB.data() != null) {
        data.addAll(dataFB.data()!);
      }

      participantes.add(data);
    }

    return participantes;
  }

  set changeLoading(bool load) {
    loading = load;
  }

  createMateria(Materia materia, String idTurma) async {
    await FirebaseFirestore.instance
        .collection("turmas")
        .doc(idTurma)
        .collection("materias")
        .add(materia.toJson());
  }
}
*/