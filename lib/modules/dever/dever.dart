import 'package:cronolab/modules/materia/materia.dart';

enum DeverUrgencia {
  alta,
  media,
  baixa,
}

class Dever {
  // var _firestore = FirebaseFirestore.instance.collection("");
  String title;
  Materia? materia;
  int? materiaID;
  DateTime data;
  double? pontos;
  int? id;
  bool? status;
  DateTime? ultimaModificacao;
  bool? deletado;
  String? descricao;
  late DeverUrgencia deverUrgencia;

  Dever(
      {this.id,
      required this.title,
      required this.data,
      this.materiaID,
      this.pontos,
      this.descricao,
      this.status,
      this.materia,
      this.ultimaModificacao,
      this.deletado}) {
    var hoje = DateTime.now().difference(data);
    if (hoje.inDays.abs() > 5) {
      deverUrgencia = DeverUrgencia.baixa;
    } else if (hoje.inDays.abs() > 2) {
      deverUrgencia = DeverUrgencia.media;
    } else {
      deverUrgencia = DeverUrgencia.alta;
    }
  }

  Dever copyWith(
      {String? title,
      DateTime? data,
      int? materiaID,
      double? pontos,
      String? descricao,
      String? local,
      bool? status}) {
    return Dever(
        id: id,
        title: title ?? this.title,
        data: data ?? this.data,
        materiaID: materiaID ?? this.materiaID,
        descricao: descricao ?? this.descricao,
        pontos: pontos ?? this.pontos,
        status: status ?? this.status);
  }

  Dever.fromJson(Map document)
      : this(
            id: document["id"] as int,
            title: document['nome'].toString(),
            materiaID: document["idMateria"] as int,
            ultimaModificacao: ((document["ultimaModificacao"] as DateTime?)),
            data: (DateTime.parse(document['dataHora'])),
            descricao: document["descricao"],
            status: document["concluiu"] == 0 ? false : true,
            pontos: double.tryParse(document['pontos'].toString()));

  Map<String, Object?> toJson() {
    return {
      'id': id ?? -1,
      'titulo': title,
      'materiaId': materiaID,
      'dataHora': data.toString(),
      'descricao': descricao,
      'pontos': pontos
    };
  }
}
