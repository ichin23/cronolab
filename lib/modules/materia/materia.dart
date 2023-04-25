class Materia {
  String id;
  String nome;
  String? prof;
  String? contato;

  Materia(this.id, this.nome, [this.prof, this.contato]);

  Materia.fromJson(Map json)
      : this(json["id"], json["nome"], json["professor"], json["contato"]);

  Materia.fromJsonDB(Map json)
      : this(json["materiaID"], json["nome"], json["professor"],
            json["contato"]);
  toJson() => {"id": id, "nome": nome, "professor": prof, "contato": contato};
}
