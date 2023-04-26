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
  DateTime? ultimaModificacao;
  bool? deletado;

  Dever(
      {this.id,
      required this.title,
      required this.data,
      this.materiaID,
      this.pontos,
      this.local,
      this.status,
      this.materia,
      this.ultimaModificacao, this.deletado});

  Dever.fromJson(Map<String, Object?> document)
      : this(
            id: document["id"] as String,
            title: document['title'].toString(),
            materiaID: document["materia"] as String,
            ultimaModificacao: DateTime.fromMillisecondsSinceEpoch(
                (document["ultimaModificacao"] as int?) ?? 0),
            data:
                DateTime.fromMillisecondsSinceEpoch((document['data'] as int)),
            pontos: double.tryParse(document['pontos'].toString()),
            local: document["local"].toString());

  Dever.fromJsonFirestore(Map<String, Object?> document, String id)
      : this(
            id: id,
            title: document['title'].toString(),
            materiaID: document["materia"] as String,
            ultimaModificacao: DateTime.now(),
            deletado: document["deletado"] == true ? true : false,
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
            ultimaModificacao: DateTime.fromMillisecondsSinceEpoch(
                document["ultimaModificacao"] as int),
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
      'ultimaModificacao': ultimaModificacao,
      'pontos': pontos,
      "local": local
    };
  }

  Map<String, Object?> toJsonFB(){
    return {
      'title': title,
      'data': Timestamp.fromDate(data),
      'materia': materiaID ?? materia!.id,
      'ultimaModificacao': Timestamp.fromDate(ultimaModificacao!),
      "local": local,
      'pontos': pontos,

    };
  }

  Map<String, Object?> toJsonDB() {
    return {
      "id": id,
      'title': title,
      'data': data.millisecondsSinceEpoch,
      'materiaID': materiaID ?? materia!.id,
      'ultimaModificacao': ultimaModificacao?.millisecondsSinceEpoch ?? 0,
      "local": local,
      'pontos': pontos,
      "status": status == true ? 1 : 0,
    };
  }

  delete() {}
}
