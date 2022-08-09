import 'dart:convert';
import 'dart:io';

import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../materia/materia.dart';

class Turma {
  final String _url = "https://cronolab-server.herokuapp.com";

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

  getMaterias() async {
    // GetMaterias var data = await _firestoreTurma.doc(id).collection("materias").get();
    // materias.clear();
    // data.docs.forEach((element) {
    //   materias.add(element.data()["nome"]);
    // });
  }

  deleteTurma() async {
    var response = await http.delete(Uri.parse(_url + "/class"),
        headers: {
          "Content-Type": "application/json",
          "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
        },
        body: jsonEncode({"turmaID": id}));
    /* print(response.body);
    print(response.statusCode); */
  }

  Future deleteDever(String idDever) async {
    await http.delete(Uri.parse(_url + "/class/deveres/dever"),
        headers: {
          "Content-Type": "application/json",
          "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
        },
        body: jsonEncode({"turmaID": id, "deverID": idDever}));
  }

  addDever(Dever dever) async {
    await http.put(Uri.parse(_url + "/class/deveres/dever"),
        headers: {
          "Content-Type": "application/json",
          "authorization": "Bearer " + FirebaseAuth.instance.currentUser!.uid
        },
        body: jsonEncode({"turmaID": id, "data": dever.toJson()}));

    // Dever await _firestoreTurma
    //     .doc(id)
    //     .collection("deveres")
    //     .withConverter<Dever>(
    //         fromFirestore: (json, _) => Dever.fromJson(json.data()!),
    //         toFirestore: (dev, _) => dev.toJson())
    //     .doc()
    //     .set(dever);

    // await _firestoreTurma
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

  // Future<List<QueryDocumentSnapshot<Map>>> getMateriasList() async {
  //   var materias = await _firestoreTurma.doc(id).collection("materias").get();
  //   return materias.docs;
  // }

  Future addMateria(String nome) async {
    await http.put(
      Uri.parse(_url + "/class/materia"),
      body: jsonEncode({
        "turmaID": id,
        "data": {"nome": nome}
      }),
      headers: {"Content-Type": "application/json"},
    );

    await getMaterias();
  }

  Future deleteMateria(String nome) async {
    await http.delete(
      Uri.parse(_url + "/class/materia"),
      body: jsonEncode({
        "turmaID": id,
        "materiaID": id,
      }),
      headers: {"Content-Type": "application/json"},
    );

    await getMaterias();
  }

  Future update() async {
    //TODO:Update Materia await _firestoreTurma.doc(id).update({'nome': nome});
  }

  Future<List?> getAtvDB() async {
    return TurmasLocal.to.getDeveres(id);
  }

  Future<List?> getAtividades() async {
    late http.Response response;
    print("PEGANDO DEVERES DE $id");
    try {
      response = await http
          .get(Uri.parse(_url + "/class/deveres?id=$id&filterToday=true"));
      // print(response.body);
      var deveresJson = jsonDecode(response.body);
      deveres = [];
      for (var dever in deveresJson) {
        if (deveres != null) {
          var deverData = Dever.fromJson(dever);
          if (Platform.isAndroid || Platform.isIOS) {
            TurmasLocal.to.addDever(deverData, id);
          }
          deveres!.add(deverData);
        } else {
          deveres = [Dever.fromJson(dever)];
        }
      }

      return deveres;
    } catch (e) {
      print(e);

      return null;
    }
  }
}
