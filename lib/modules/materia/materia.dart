class Materia {
  int id;
  String nome;
  String? prof;
  String? contato;
  int? turmaId;

  Materia(this.id, this.nome, [this.prof, this.contato, this.turmaId]);

  Materia.fromJson(Map json)
      : this(json["id"], json["nome"], json["professor"], json["contato"],
            json["turmaID"]);

  Materia.fromJsonDB(Map json)
      : this(json["materiaID"], json["nome"], json["professor"],
            json["contato"]);
  toJson() => {"id": id, "nome": nome, "professor": prof, "contato": contato};
}
