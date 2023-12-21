import 'package:cronolab/modules/materia/materia.dart';

class Dever {
  // var _firestore = FirebaseFirestore.instance.collection("");
  String title;
  Materia? materia;
  int? materiaID;
  DateTime data;
  double? pontos;
  int? id;
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
      this.ultimaModificacao,
      this.deletado});

  Dever.fromJson(Map document)
      : this(
            id: document["id"] as int,
            title: document['nome'].toString(),
            materiaID: document["idMateria"] as int,
            ultimaModificacao: ((document["ultimaModificacao"] as DateTime?)),
            data: (DateTime.parse(document['dataHora'])),
            pontos: double.tryParse(document['pontos'].toString()),
            local: document["local"].toString());

  Dever.fromJsonFirestore(Map<String, Object?> document, String id)
      : this(
            id: id as int,
            title: document['title'].toString(),
            materiaID: document["materia"] as int,
            ultimaModificacao: DateTime.now(),
            deletado: document["deletado"] == true ? true : false,
            data: (DateTime.now()),
            pontos: double.tryParse(document['pontos'].toString()),
            local: document["local"].toString());

  Dever.fromJsonDB(Map<String, Object?> document)
      : this(
            id: document["id"] as int,
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
      'titulo': title,
      'materiaId': materiaID,
      'dataHora': data.toString(),
      'pontos': pontos,
      "local": local
    };
  }

  Map<String, Object?> toJsonFB() {
    return {
      'title': title,
      'data': DateTime.now(),
      'materia': materiaID ?? materia!.id,
      'ultimaModificacao': DateTime.now(),
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
