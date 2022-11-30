import 'dart:io';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:firedart/firedart.dart';

import '../materia/materia.dart';

class Turma {
  String nome;
  String id;
  bool isAdmin;
  List? deveres;
  List<Materia> materias = [];

  Turma(
      {required this.nome,
      required this.id,
      this.deveres,
      this.isAdmin = false});

  Turma.fromJson(Map<String, dynamic> json)
      : this(
          nome: json['nome'].toString(),
          id: json["id"].toString(),

          // deveres: json['deveres'] as List,
        );

  setAdmin() {
    isAdmin = true;
  }

  Map<String, Object?> toJson() {
    return {'nome': nome, 'id': id, "admin": isAdmin ? 1 : 0};
  }

  set setMaterias(List<Materia> materiasList) => {materias = materiasList};

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

  Future deleteDever(String idDever) async {
    await FirebaseFirestore.instance
        .collection("turmas")
        .doc(id)
        .collection("deveres")
        .doc(idDever)
        .delete();
    if (Platform.isAndroid) {
      //TODO: Delete on local
      await TurmasLocal.to.deleteDever(idDever);
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

  Future<List?> getAtvDB({List? filters}) async {
    return TurmasLocal.to.getDeveres(id, filter: filters);
  }

  Future<List?> getAtividades([filterToday = true]) async {
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
        print(deveresQuer.docs);
        list = [];
        deveres = [];
        for (var dever in deveresQuer.docs) {
          var deverToAdd = dever.data();
          deverToAdd["id"] = dever.id;

          var mat = (await FirebaseFirestore.instance
              .collection("turmas")
              .doc(id)
              .collection("materias")
              .doc(deverToAdd['materia'])
              .get());
          var matToAdd = mat.data()!;
          matToAdd["id"] = mat.id;
          deverToAdd["materia"] = matToAdd;

          deverToAdd["data"] =
              (deverToAdd["data"] as Timestamp).toDate().millisecondsSinceEpoch;

          list.add(deverToAdd);
          if (deveres != null) {
            var deverData = Dever.fromJson(deverToAdd);
            if (Platform.isAndroid || Platform.isIOS) {
              await TurmasLocal.to.addDever(deverData, id);
            }
            deveres?.add(deverData);
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
          var mat = (await FirebaseFirestore.instance
              .collection("turmas")
              .doc(id)
              .collection("materias")
              .doc(deverToAdd['materia'])
              .get());
          var matToAdd = mat.data()!;
          matToAdd["id"] = mat.id;
          deverToAdd["materia"] = matToAdd;
          (deverToAdd["data"] as Timestamp).toDate().millisecondsSinceEpoch;

          list.add(deverToAdd);
          if (deveres != null) {
            var deverData = Dever.fromJson(deverToAdd);
            if (Platform.isAndroid || Platform.isIOS) {
              await TurmasLocal.to.addDever(deverData, id);
            }
            deveres?.add(deverData);
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

  Future<List?> getAtividadesDesk([filterToday = true]) async {
    try {
      print("inint");
      var list = [];

      if (filterToday) {
        var deveresQuer = await Firestore.instance
            .collection("turmas")
            .document(id)
            .collection("deveres")
            .where('data', isGreaterThan: DateTime.now())
            .orderBy("data")
            .get();

        print(deveresQuer);
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
              await TurmasLocal.to.addDever(deverData, id);
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
              await TurmasLocal.to.addDever(deverData, id);
            }
            deveres?.add(deverData);
          } else {
            deveres = [Dever.fromJson(deverToAdd)];
          }
        }
      }

      return deveres;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
