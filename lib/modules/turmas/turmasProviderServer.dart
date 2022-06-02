import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TurmasProvider extends ChangeNotifier {
  String url = "https://cronolab-server.herokuapp.com";
  List<Turma> turmas = [];
  Turma? turmaAtual;
  var firestoreTurma = FirebaseFirestore.instance
      .collection("turmas-test")
      .withConverter(
          fromFirestore: (snap, _) => Turma.fromJson(snap.data()!),
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
    var response = await http.put(Uri.parse(url + "/class"), headers: {
      "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
    }, body: {
      "nome": code
    });

    // var doc = firestoreTurma.doc(code);
    // await doc.set(Turma(id: code, nome: code));
    // await doc
    //     .collection("admins")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .set({});
    // firestoreUsers
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("turmas")
    //     .doc(code)
    //     .set({});
    getTurmas();
    // await doc.collection("deveres").doc()
  }

  getTurmas() async {
    var response = await http.get(Uri.parse(url + "/users/turmas"), headers: {
      "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
    });
    var turmasJson = json.decode(response.body)["turmas"];
    for (Map<String, dynamic> turma in turmasJson) {
      var turmaAdd = Turma.fromJson(turma);
      if (turma["admin"] == true) {
        turmaAdd.setAdmin();
      }

      turmaAdd.setMaterias = turma["materias"];

      turmas.add(turmaAdd);
    }
    turmaAtual = turmas[0];
    print(turmasJson);
    // var value = await firestoreUsers
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("turmas")
    //     // .withConverter(
    //     //     fromFirestore: (snap, _) => Turma.fromJson(snap),
    //     //     toFirestore: (Turma turma, _) => turma.toJson())
    //     .get();

    // for (var turmaId in value.docs) {
    //   print(turmaId.id);
    //   var turma = await firestoreTurma.doc(turmaId.id).get();
    //   print(turma.data());
    //   if (turma.data() != null) {
    //     Turma? turmaData = turma.data();
    //     var isAdmin = await firestoreTurma
    //         .doc(turmaId.id)
    //         .collection("admins")
    //         .doc(FirebaseAuth.instance.currentUser!.uid)
    //         .get();
    //     print(isAdmin.data());
    //     if (isAdmin.exists) {
    //       turmaData!.setAdmin();
    //     }
    //     turmas.add(turmaData!);
    //   }
    // }

    // for (var element in turmas) {
    //   await element.getMaterias();
    // }
    // ;
    // value.docs.forEach((element) {
    //   print(element.id);
    //   // turmas.add(element.)
    // );
    // if (turmas.length > 0) {
    //   // print(turmas[0].isAdmin);
    //   turmaAtual = turmas[0];
    // }
    notifyListeners();
  }
}
