import 'dart:io';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';

import '../materia/materia.dart';

class Turma {
  String nome;
  String id;
  bool isAdmin;
  List? deveres;
  List<Materia> materia;


  Turma(
      {required this.nome,
      required this.id,
      this.deveres,
      this.materia = const [],
      this.isAdmin = false});

  Turma.fromFirebase(DocumentSnapshot turma)
      : this(
          nome: (turma.data() as Map)['nome'].toString(),
          id: turma.id,

          // deveres: json['deveres'] as List,
        );

  Turma.fromSQL(Map turma, [List<Materia>? materias])
      : this(
            nome: turma['nome'].toString(),
            id: turma["id"],
            materia: materias ?? [],
            isAdmin: turma["admin"] == 1 ? true : false);

  setAdmin() {
    isAdmin = true;
  }

  Map<String, Object?> toJson() {
    return {'nome': nome, 'id': id, "admin": isAdmin ? 1 : 0};
  }

  set setMaterias(List<Materia> materiasList) => {materia = materiasList};

  sairTurma() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("turmas")
        .doc(id)
        .delete();
  }

  deleteTurma() async {
    var docs = await FirebaseFirestore.instance
        .collectionGroup("turmas")
        .where("id", isEqualTo: id)
        .get();
    var docses = [];

    for (var doc in docs.docs) {
      var uid = doc.reference.path.split("/")[1];
      docses.add(id);
    }

    for (var uid in docses) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("turmas")
          .doc(id)
          .delete();
    }
    await FirebaseFirestore.instance.collection("turmas").doc(id).delete();
  }

  Future deleteDever(BuildContext context, String idDever) async {
    await FirebaseFirestore.instance
        .collection("turmas")
        .doc(id)
        .collection("deveres")
        .doc(idDever)
        .delete();
    if (Platform.isAndroid) {
      //TODO: Delete on local
      // await Provider.of<TurmasLocal>(context).deleteDever(idDever);
    }
  }

  addDever(Dever dever) async {
    var data = dever.toJson();

    await FirebaseFirestore.instance
        .collection("turmas")
        .doc(id)
        .collection("deveres")
        .add(data);
  }

  Future addMateria(String nome) async {
    await FirebaseFirestore.instance
        .collection("turmas")
        .doc(id)
        .collection("materias")
        .add({"nome": nome});

    //await getMaterias();
  }

  Future deleteMateria(String nome) async {
    await FirebaseFirestore.instance
        .collection("turmas")
        .doc(id)
        .collection("materias")
        .doc(nome)
        .delete();
  }

  Future update() async {}

  // Future<List?> getAtvDB(BuildContext context, {List? filters}) async {
  //   return Provider.of<TurmasLocal>(context, listen: false)
  //       .getDeveres(id, filter: filters);
  // }

  Future<List?> getAtividades([bool filterToday = true]) async {
    try {
      var list = [];

      if (filterToday) {
        var deveresQuer = await FirebaseFirestore.instance
            .collection("turmas")
            .doc(id)
            .collection("deveres")
            .where('data', isGreaterThan: Timestamp.now())
            .orderBy("data")
            .get();
        debugPrint(deveresQuer.docs.toString());
        list = [];
        deveres = [];
        for (var dever in deveresQuer.docs) {
          var deverToAdd = dever.data();
          deverToAdd["id"] = dever.id;

          deverToAdd["data"] =
              (deverToAdd["data"] as Timestamp).toDate().millisecondsSinceEpoch;

          list.add(deverToAdd);
          if (deveres != null) {
            var deverData = Dever.fromJson(deverToAdd);
            deveres!.add(deverData);
          } else {
            deveres = [Dever.fromJson(deverToAdd)];
          }
        }
      } else {
        var deveresQuery = await FirebaseFirestore.instance
            .collection("turmas")
            .doc(id)
            .collection("deveres")
            .orderBy("data")
            .get();
        list = [];
        deveres = [];
        for (var dever in deveresQuery.docs) {
          var deverToAdd = dever.data();
          deverToAdd["id"] = dever.id;
          (deverToAdd["data"] as Timestamp).toDate().millisecondsSinceEpoch;

          list.add(deverToAdd);
          if (deveres != null) {
            var deverData = Dever.fromJson(deverToAdd);

            deveres!.add(deverData);
          } else {
            deveres = [Dever.fromJson(deverToAdd)];
          }
        }
      }

      return deveres;
    } catch (e) {
      return null;
    }
  }

  Future<List?> getAtividadesDesk(BuildContext context,
      [filterToday = true]) async {
    try {
      debugPrint("inint");
      var list = [];

      if (filterToday) {
        var deveresQuer = await Firestore.instance
            .collection("turmas")
            .document(id)
            .collection("deveres")
            .where('data', isGreaterThan: DateTime.now())
            .orderBy("data")
            .get();

        debugPrint(deveresQuer.toString());
        list = [];
        deveres = [];
        for (var dever in deveresQuer) {
          var deverToAdd = dever.map;
          deverToAdd["id"] = dever.id;

          var mat = (await Firestore.instance
              .collection("turmas")
              .document(id)
              .collection("materias")
              .document(deverToAdd['materia'])
              .get());
          var matToAdd = mat.map;
          matToAdd["id"] = mat.id;
          deverToAdd["materia"] = matToAdd;

          deverToAdd["data"] =
              (deverToAdd["data"] as DateTime).millisecondsSinceEpoch;

          list.add(deverToAdd);
          if (deveres != null) {
            var deverData = Dever.fromJson(deverToAdd);
            if (Platform.isAndroid || Platform.isIOS) {
              //TODO: await Provider.of<TurmasLocal>(context).addDever(deverData, id);

            }
            deveres?.add(deverData);
          } else {
            deveres = [Dever.fromJson(deverToAdd)];
          }
        }
      } else {
        var deveresQuery = await Firestore.instance
            .collection("turmas")
            .document(id)
            .collection("deveres")
            .orderBy("data")
            .get();
        list = [];
        deveres = [];
        for (var dever in deveresQuery) {
          var deverToAdd = dever.map;
          deverToAdd["id"] = dever.id;
          var mat = (await Firestore.instance
              .collection("turmas")
              .document(id)
              .collection("materias")
              .document(deverToAdd['materia'])
              .get());
          var matToAdd = mat.map;
          matToAdd["id"] = mat.id;
          deverToAdd["materia"] = matToAdd;
          (deverToAdd["data"] as DateTime).millisecondsSinceEpoch;

          list.add(deverToAdd);
          if (deveres != null) {
            var deverData = Dever.fromJson(deverToAdd);
            if (Platform.isAndroid || Platform.isIOS) {
              //TODO: await Provider.of<TurmasLocal>(context).addDever(deverData, id);
            }
            deveres?.add(deverData);
          } else {
            deveres = [Dever.fromJson(deverToAdd)];
          }
        }
      }

      return deveres;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
