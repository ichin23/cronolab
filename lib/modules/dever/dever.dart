import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Dever {
  // var _firestore = FirebaseFirestore.instance.collection("");
  String title;
  String materia;
  DateTime data;
  double? pontos;
  String? id;

  Dever(
      {this.id,
      required this.title,
      required this.materia,
      required this.data,
      this.pontos});
  Dever.fromJson(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),
            materia: document['materia'].toString(),
            data:
                DateTime.fromMillisecondsSinceEpoch((document['data'] as int)),
            pontos: double.tryParse(document['pontos'].toString()));

  Map<String, Object?> toJson() {
    return {'title': title, 'materia': materia, 'data': data, 'pontos': pontos};
  }

  delete() {}
}
