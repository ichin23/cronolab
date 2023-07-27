import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/controllers/turmasSQL.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TurmasFirebase with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Turma> turmas = [];
  bool loadingTurmas = false;

  Future loadTurmasUser(TurmasSQL turmasSQL) async {
    //if(loadingTurmas)return;
    loadingTurmas = true;
    var deverID = "";
    notifyListeners();
    try {
      var turmasQuery = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("turmas")
          .get();
      List<Turma> newTurmas = [];
      for (var turma in turmasQuery.docs) {
        Turma? turmaClass = (await _firestore
                .collection("turmas")
                .doc(turma.id)
                .withConverter<Turma>(
                    fromFirestore: (doc, options) => Turma.fromFirebase(doc),
                    toFirestore: (turmaTo, option) => turmaTo.toJson())
                .get())
            .data();

        if (turmaClass != null) {
          var materias = await getMaterias(turma.id);
          var isAdmin = await _firestore
              .collection("turmas")
              .doc(turmaClass.id)
              .collection("admins")
              .doc(_auth.currentUser!.uid)
              .get();

          var maior = await turmasSQL.readUltimaModificacao(turma.id);
          var deveres = await getDeveres(turma.id, Timestamp.fromDate(maior));

          if (isAdmin.exists) {
            turmaClass.setAdmin();
          }

          turmaClass.deveres = deveres;
          turmaClass.materia = materias;

          newTurmas.add(turmaClass);
        }
      }
      turmas = newTurmas;
      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<Map>> getAdmins(String turmaID) async {
    var adminsFB = (await _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("admins")
        .get());
    List<Map> admins = [];
    for (var admin in adminsFB.docs) {
      Map data =
          (await _firestore.collection("users").doc(admin.id).get()).data() ??
              {};
      data!["id"] = admin.id;
      admins.add(data);
    }
    print(admins);
    return admins;
  }

  Future<List<Map>> getParticipantes(String turmaID) async {
    var participantesFB = (await _firestore
        .collectionGroup("turmas")
        .where("id", isEqualTo: turmaID)
        .get());
    List<Map> participantes = [];
    for (var participante in participantesFB.docs) {
      var id = participante.reference.path.split("/")[1];
      Map data = {"id": id};
      var dataFB = (await _firestore.collection("users").doc(id).get());

      if (dataFB.data() != null) {
        data.addAll(dataFB.data()!);
      }

      participantes.add(data);
    }

    return participantes;
  }

  Future<List> refreshTurma(
    String turmaID,
    Timestamp lastUpdate,
  ) async {
    var updatedData = await _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("deveres")
        .where("ultimaModificacao", isGreaterThan: lastUpdate)
        .get();

    var newDeveres = [];
    for (var dever in updatedData.docs) {
      newDeveres.add(Dever.fromJsonFirestore(dever.data(), dever.id));
    }
    return newDeveres;
  }

  getMaterias(String turmaID) async {
    var materiasQuery = await _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("materias")
        .get();
    List<Materia> materias = [];
    for (var materia in materiasQuery.docs) {
      var data = materia.data();
      data["id"] = materia.id;
      materias.add(Materia.fromJson(data));
    }

    return materias;
  }

  Future<List<Dever>> getDeveres(String turmaID, Timestamp ultimaMod) async {
    var deveresQuery = await _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("deveres")
        .where("ultimaModificacao", isGreaterThanOrEqualTo: ultimaMod)
        .orderBy("ultimaModificacao")
        //.orderBy("data")
        .get();
    List<Dever> deveres = [];
    for (var dever in deveresQuery.docs) {
      debugPrint(dever.id);
      var data = dever.data();

      deveres.add(Dever.fromJsonFirestore(data, dever.id));
    }
    debugPrint(deveres.toString());
    return deveres;
  }

  createTurma(Turma turma) async {
    var exist = await _firestore
        .collection("turmas")
        .doc(turma.id)
        .get()
        .then((e) => e.exists);

    if (!exist) {
      await _firestore
          .collection("turmas")
          .doc(turma.id)
          .set({"nome": turma.id});
      await _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("turmas")
          .doc(turma.id)
          .set({"id": turma.id});
      await addAdmin(FirebaseAuth.instance.currentUser!.uid, turma);
    } else {
      await _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("turmas")
          .doc(turma.id)
          .set({"id": turma.id});
    }
  }

  createDever(Dever dever, String turmaID) {
    _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("deveres")
        .add(dever.toJsonFB());
  }

  updateDever(
      String turmaID, String deverID, Map<String, Object?> update) async {
    await _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("deveres")
        .doc(deverID)
        .update(update);
  }

  Future<Timestamp> deleteDever(Dever dever, String turmaID) async {
    var date = Timestamp.now();
    await _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("deveres")
        .doc(dever.id)
        .update({
      "deletado": true,
      "ultimaModificacao": date,
    });
    return date;
  }

  addAdmin(String userID, Turma turma) async {
    if (turma.isAdmin) {
      await _firestore
          .collection("turmas")
          .doc(turma.id)
          .collection("admins")
          .doc(userID)
          .set({});
    }
  }

  removeAdmin(String userID, Turma turma) async {
    if (turma.isAdmin) {
      await _firestore
          .collection("turmas")
          .doc(turma.id)
          .collection("admins")
          .doc(userID)
          .delete();
    }
  }
}
