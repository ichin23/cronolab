import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
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
    var deverID="";
    notifyListeners();
    try {
      var turmasQuery = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("turmas")
          .get();
      turmas = [];
      for (var turma in turmasQuery.docs) {
        Turma? turmaClass = (await _firestore
                .collection("turmas")
                .doc(turma.id)
                .withConverter<Turma>(
                    fromFirestore: (doc, options) => Turma.fromFirebase(doc),
                    toFirestore: (turma, option) => turma.toJson())
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

          turmas.add(turmaClass);

          if (turmas.length == 1) {
            notifyListeners();
          }
        }
      }
      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
      //debugPrint(dever.id);
      rethrow;
    }
  }

  Future<List> refreshTurma(String turmaID, Timestamp lastUpdate, )async{
    var updatedData = await _firestore.collection("turmas").doc(turmaID).collection("deveres").where("ultimaModificacao", isGreaterThan: lastUpdate ).get();

    var newDeveres = [];
    for (var dever in updatedData.docs){
     newDeveres.add( Dever.fromJsonFirestore(dever.data(), dever.id));
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

  createDever(Dever dever,String turmaID) {
    _firestore.collection("turmas").doc(turmaID).collection("deveres").add(dever.toJsonFB());
  }

  Future<Timestamp> deleteDever(Dever dever, String turmaID)async {
    var date = Timestamp.now();
    await _firestore.collection("turmas").doc(turmaID).collection("deveres").doc(dever.id).update({
      "deletado": true,
      "ultimaModificacao": date,
    });
    return date;
  }
}
