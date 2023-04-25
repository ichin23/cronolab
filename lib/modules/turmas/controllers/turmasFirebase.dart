import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TurmasFirebase with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Turma> turmas = [];
  bool loadingTurmas = false;

   Future loadTurmasUser() async {
    loadingTurmas = true;
    notifyListeners();
    try {
      var turmasQuery = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("turmas")
          .get();
      turmas=[];
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
          var isAdmin = await _firestore.collection("turmas").doc(turmaClass.id).collection("admins").doc(_auth.currentUser!.uid).get();
          var deveres = await getDeveres(turma.id);
          if(isAdmin.exists){
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

      // turmas = turmasQuery.docs.map((e) => e.data()).toList();
      print(turmas);
      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
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
      debugPrint(materia.data().toString());
      materias.add(Materia.fromJson(data));
    }

    return materias;
  }

  Future<List<Dever>> getDeveres(String turmaID) async {
    var deveresQuery = await _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("deveres").orderBy("data")
        .get();
    List<Dever> deveres = [];
    for (var dever in deveresQuery.docs) {
      debugPrint(dever.data().toString());
      var data = dever.data();
      data["id"] = dever.id;
      deveres.add(Dever.fromJsonFirestore(data));
    }
    debugPrint(deveres.toString());
    return deveres;
  }
  
  createDever(Dever dever){
    _firestore.collection("turmas");
    
  }
}
