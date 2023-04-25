import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/materia/materia.dart';

class Dever {
  // var _firestore = FirebaseFirestore.instance.collection("");
  String title;
  Materia? materia;
  String? materiaID;
  DateTime data;
  double? pontos;
  String? id;
  String? local;
  bool? status;

  Dever(
      {this.id,
      required this.title,
      required this.data,
      this.materiaID,
      this.pontos,
      this.local,
      this.status, this.materia});
  Dever.fromJson(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),
            materiaID: document["materia"] as String,
            data:
                DateTime.fromMillisecondsSinceEpoch((document['data'] as int)),
            pontos: double.tryParse(document['pontos'].toString()),
            local: document["local"].toString());
  Dever.fromJsonFirestore(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),
            materiaID: document["materia"] as String,
            data: ((document['data'] as Timestamp).toDate()),
            pontos: double.tryParse(document['pontos'].toString()),
            local: document["local"].toString());

  Dever.fromJsonDB(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),

            status: document["status"] == null
                ? false
                : document['status'] == 1
                    ? true
                    : false,
            materia: Materia.fromJsonDB(document),

            data:
                DateTime.fromMillisecondsSinceEpoch((document['data'] as int)),
            pontos: double.tryParse(document['pontos'].toString()),
            local: document["local"] != null
                ? document["local"].toString()
                : null);

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'materia': materiaID,
      'data': Timestamp.fromDate(data),
      'pontos': pontos,
      "local": local
    };
  }

  Map<String, Object?> toJsonDB() {
    return {
      "id": id,
      'title': title,
      'data': data.millisecondsSinceEpoch,
      'materiaID': materiaID,
      "local": local,
      'pontos': pontos,
    };
  }

  delete() {}
}
