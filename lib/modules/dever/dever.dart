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

  Dever(
      {this.id,
      required this.title,
      required this.data,
      this.materia,
      this.materiaID,
      this.pontos,
      this.local});
  Dever.fromJson(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),
            materia: Materia.fromJson(document['materia'] as Map),
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

  delete() {}
}
