class Materia {
  String id;
  String nome;
  String? prof;
  String? contato;

  Materia(this.id, this.nome, [this.prof, this.contato]);

  Materia.fromJson(Map json)
      : this(json["id"], json["nome"], json["professor"], json["contato"]);
}
