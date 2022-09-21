import '../materia/materia.dart';

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
      this.materia,
      this.materiaID,
      this.pontos,
      this.local,
      this.status});
  Dever.fromJson(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),
            materia: Materia.fromJson(document['materia'] as Map),
            materiaID: (document["materia"]! as Map)["id"] as String,
            data:
                DateTime.fromMillisecondsSinceEpoch((document['data'] as int)),
            pontos: double.tryParse(document['pontos'].toString()),
            local: document["local"] != null
                ? document["local"].toString()
                : null);

  Dever.fromJsonDB(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),
            materia: Materia.fromJsonDB(document),
            status: document["status"] == null
                ? false
                : document['status'] == 1
                    ? true
                    : false,
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
      'data': data.millisecondsSinceEpoch,
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
