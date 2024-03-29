import 'package:cronolab/modules/dever/dever.dart';
import 'package:flutter/material.dart';

import '../materia/materia.dart';

class Turma {
  String nome;
  String id;
  bool isAdmin;
  List<Dever>? deveres;
  List<Materia> materia;

  Turma(
      {required this.nome,
      required this.id,
      this.deveres,
      this.materia = const [],
      this.isAdmin = false});

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

  /*Future<List?> getAtividades([bool filterToday = true]) async {
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
      var list = [];

      if (filterToday) {
        var deveresQuer = await FirebaseFirestore.instance
            .collection("turmas")
            .doc(id)
            .collection("deveres")
            .where('data', isGreaterThan: DateTime.now())
            .orderBy("data")
            .get();

        debugPrint(deveresQuer.docs.length.toString());
        list = [];
        List<Dever> newDeveres = [];

        for (var dever in deveresQuer.docs) {
          var deverToAdd = dever.data();
          deverToAdd["id"] = dever.id;

          Materia materiaClass =
              materia.where((e) => e.id == dever["materia"]).first;
          deverToAdd["materiaClass"] = materiaClass;
          deverToAdd["ultimaModificacao"] =
              (deverToAdd["ultimaModificacao"] as Timestamp).toDate();
          deverToAdd["data"] = (deverToAdd["data"] as Timestamp).toDate();

          list.add(deverToAdd);

          var deverData = Dever.fromJson(deverToAdd);

          newDeveres.add(deverData);
        }
        deveres = newDeveres;
      } else {
        var deveresQuery = await FirebaseFirestore.instance
            .collection("turmas")
            .doc(id)
            .collection("deveres")
            .orderBy("data")
            .get();
        list = [];
        List<Dever> newDeveres = [];
        for (var dever in deveresQuery.docs) {
          var deverToAdd = dever.data();
          deverToAdd["id"] = dever.id;
          var mat = (await FirebaseFirestore.instance
              .collection("turmas")
              .doc(id)
              .collection("materias")
              .doc(deverToAdd['materia'])
              .get());
          var matToAdd = mat.data();
          matToAdd!["id"] = mat.id;
          deverToAdd["materia"] = matToAdd;
          (deverToAdd["data"] as DateTime).millisecondsSinceEpoch;

          list.add(deverToAdd);

          var deverData = Dever.fromJson(deverToAdd);

          newDeveres.add(deverData);
        }
        deveres = newDeveres;
      }
      print("");

      return deveres;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }*/
}
