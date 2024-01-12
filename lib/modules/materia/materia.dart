class Materia {
  int? id;
  String nome;
  String? prof;
  String? contato;
  int? turmaId;

  Materia(this.nome, [this.prof, this.contato, this.turmaId, this.id]);

  Materia.fromJson(Map json)
      : this(json["nome"], json["professor"], json["contato"], json["turmaID"],
            json["id"]);

  Materia.fromJsonDB(Map json)
      : this(json["materiaID"], json["nome"], json["professor"],
            json["contato"]);

  toJson() => {
        "id": id,
        "nome": nome,
        "professor": prof,
        "contato": contato,
        "turmaId": turmaId
      };
}
