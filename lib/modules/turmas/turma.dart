import 'dart:convert';

import 'package:cronolab/modules/dever/dever.dart';
import 'package:http/http.dart' as http;

class Turma {
  final String _url = "https://cronolab-server.herokuapp.com";

  String nome;
  String id;
  bool isAdmin;
  List? deveres;
  List<dynamic> materias = [];

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
    return {'nome': nome, 'deveres': deveres};
  }

  set setMaterias(List<dynamic> materiasList) => {materias = materiasList};

  getMaterias() async {
    //TODO: GetMaterias var data = await _firestoreTurma.doc(id).collection("materias").get();
    // materias.clear();
    // data.docs.forEach((element) {
    //   materias.add(element.data()["nome"]);
    // });
  }

  Future deleteDever(String idDever) async {
    await http.delete(Uri.parse(_url + "/class/deveres/dever"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"turmaID": id, "deverID": idDever}));
  }

  addDever(Dever dever) async {
    await http.put(Uri.parse(_url + "/class/deveres/dever"),
        headers: {"Content-Type": "application/json"},
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
    //TODO:ADD Materia await _firestoreTurma
    //     .doc(id)
    //     .collection("materias")
    //     .doc()
    //     .set({"nome": nome});
    await getMaterias();
  }

  Future update() async {
    //TODO:Update Materia await _firestoreTurma.doc(id).update({'nome': nome});
  }

  Future<List?> getAtividades() async {
    var response = await http
        .get(Uri.parse(_url + "/class/deveres?id=$id&filterToday=true"));
    // print(response.body);
    var deveresJson = jsonDecode(response.body);
    deveres = [];
    for (var dever in deveresJson) {
      if (deveres != null) {
        deveres!.add(Dever.fromJson(dever));
      } else {
        deveres = [Dever.fromJson(dever)];
      }
    }
    return deveres;
    // var deveres = await _firestoreTurma
    //     .doc(id)
    //     .collection("deveres")
    //     .withConverter<Dever>(
    //         fromFirestore: (json, _) => Dever.fromJson(json),
    //         toFirestore: (dev, _) => dev.toJson())
    //     .orderBy("data")
    //     .get();
    // print(deveres.docs[0].data().data);
    // return deveres.docs;
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
