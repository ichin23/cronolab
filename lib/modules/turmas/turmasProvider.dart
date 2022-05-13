import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TurmasProvider extends ChangeNotifier {
  List<Turma> turmas = [];
  Turma? turmaAtual;
  var firestoreTurma = FirebaseFirestore.instance
      .collection("turmas-test")
      .withConverter(
          fromFirestore: (snap, _) => Turma.fromJson(snap),
          toFirestore: (Turma turma, _) => turma.toJson());
  var firestoreUsers = FirebaseFirestore.instance.collection("users-test");

  TurmasProvider() {
    // getTurmas();
  }

  set changeTurma(Turma newTurma) {
    turmaAtual = newTurma;
    notifyListeners();
  }

  initTurma(String code) async {
    var doc = firestoreTurma.doc(code);
    await doc.set(Turma(id: code, nome: code));
    await doc
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});
    firestoreUsers
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("turmas")
        .doc(code)
        .set({});
    getTurmas();
    // await doc.collection("deveres").doc()
  }

  getTurmas() async {
    var value = await firestoreUsers
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("turmas")
        // .withConverter(
        //     fromFirestore: (snap, _) => Turma.fromJson(snap),
        //     toFirestore: (Turma turma, _) => turma.toJson())
        .get();

    for (var turmaId in value.docs) {
      print(turmaId.id);
      var turma = await firestoreTurma.doc(turmaId.id).get();
      print(turma.data());
      if (turma.data() != null) {
        Turma? turmaData = turma.data();
        var isAdmin = await firestoreTurma
            .doc(turmaId.id)
            .collection("admins")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        print(isAdmin.data());
        if (isAdmin.exists) {
          turmaData!.setAdmin();
        }
        turmas.add(turmaData!);
      }
    }
    // value.docs.forEach((element) {
    //   print(element.id);
    //   // turmas.add(element.)
    // );
    if (turmas.length > 0) {
      // print(turmas[0].isAdmin);
      turmaAtual = turmas[0];
    }
    notifyListeners();
  }
}
