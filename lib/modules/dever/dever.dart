import 'package:cloud_firestore/cloud_firestore.dart';

class Dever {
  // var _firestore = FirebaseFirestore.instance.collection("");
  String title;
  String materia;
  Timestamp data;
  double? pontos;
  String? id;

  Dever(
      {this.id,
      required this.title,
      required this.materia,
      required this.data,
      this.pontos});
  Dever.fromJson(DocumentSnapshot<Map<String, Object?>> document)
      : this(
            id: document.id,
            title: document.data()!['title'].toString(),
            materia: document.data()!['materia'].toString(),
            data: document.data()!['data'] as Timestamp,
            pontos: double.tryParse(document.data()!['pontos'].toString()));

  Map<String, Object?> toJson() {
    return {'title': title, 'materia': materia, 'data': data, 'pontos': pontos};
  }

  delete() {}
}
