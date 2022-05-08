import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';

import 'package:flutter/material.dart';

class Turma {
  var firestoreTurma = FirebaseFirestore.instance.collection("turmas-test");
  String nome;
  String id;
  bool isAdmin;
  List? deveres;

  Turma(
      {required this.nome,
      required this.id,
      this.deveres,
      this.isAdmin = false});

  Turma.fromJson(DocumentSnapshot<Map<String, dynamic>> json)
      : this(
          nome: json.data()!['nome'].toString(),
          id: json.id.toString(),
          // deveres: json['deveres'] as List,
        );

  setAdmin() {
    isAdmin = true;
  }

  Map<String, Object?> toJson() {
    return {'nome': nome, 'deveres': deveres};
  }

  addDever(Dever dever) async {
    // await firestoreTurma
    //     .doc(id)
    //     .collection("deveres")
    //     .withConverter<Dever>(
    //         fromFirestore: (json, _) => Dever.fromJson(json),
    //         toFirestore: (dev, _) => dev.toJson())
    //     .doc()
    //     .set(dever);
    // print("FOI");
    // provider.getTurmas();
  }

  Future<List<QueryDocumentSnapshot<Dever>>?> getAtividades() async {
    // print("AAAAAAAAAAA" +
    //     (await FirebaseFirestore.instance
    //             .collection("turmas-test")
    //             .doc(id)
    //             .collection("deveres")
    //             .get())
    //         .docs
    //         .toString());
    // return (await FirebaseFirestore.instance
    //         .collection("turmas-test")
    //         .doc(id)
    //         .collection("deveres")
    //         .withConverter<Dever>(
    //             fromFirestore: (json, _) => Dever.fromJson(json),
    //             toFirestore: (dev, _) => dev.toJson())
    //         .orderBy("data")
    //         .where("data", isGreaterThanOrEqualTo: Timestamp.now())
    //         .get())
    //     .docs;
  }
}
