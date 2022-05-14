import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';

import 'package:flutter/material.dart';

class Turma {
  var firestoreTurma = FirebaseFirestore.instance.collection("turmas-test");
  String nome;
  String id;
  bool isAdmin;
  List? deveres;
  List<String> materias = [];

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

  getMaterias() async {
    var data = await firestoreTurma.doc(id).collection("materias").get();
    materias.clear();
    data.docs.forEach((element) {
      materias.add(element.data()["nome"]);
    });
  }

  addDever(Dever dever) async {
    await firestoreTurma
        .doc(id)
        .collection("deveres")
        .withConverter<Dever>(
            fromFirestore: (json, _) => Dever.fromJson(json),
            toFirestore: (dev, _) => dev.toJson())
        .doc()
        .set(dever);
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

  Future<List<QueryDocumentSnapshot<Map>>> getMateriasList() async {
    var materias = await firestoreTurma.doc(id).collection("materias").get();
    return materias.docs;
  }

  Future addMateria(String nome) async {
    await firestoreTurma
        .doc(id)
        .collection("materias")
        .doc()
        .set({"nome": nome});
    await getMaterias();
  }

  Future update() async {
    await firestoreTurma.doc(id).update({'nome': nome});
  }

  Future<List<QueryDocumentSnapshot<Dever>>?> getAtividades() async {
    var deveres = await firestoreTurma
        .doc(id)
        .collection("deveres")
        .withConverter<Dever>(
            fromFirestore: (json, _) => Dever.fromJson(json),
            toFirestore: (dev, _) => dev.toJson())
        .orderBy("data")
        .get();
    // print(deveres.docs[0].data().data);
    return deveres.docs;
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
