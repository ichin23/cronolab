import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../dever/dever.dart';
import '../materia/materia.dart';
import 'turma.dart';

class TurmasLocal extends GetxController {
  List<Dever> lista = [];
  List<Turma> turmas = [];
  Turma? turmaAtual;
  final _method = const MethodChannel("cronolab.cronolab/widget");

  late Database db;
  static TurmasLocal get to => Get.find();
  init() async {
    print(await getDatabasesPath());
    db = await openDatabase(join(await getDatabasesPath(), "mydatabase.db"),
        version: 1, onCreate: _onCreate, onConfigure: _onConfigure);

    print("iniciado");
  }

  isInit() => db.isOpen;

  static Future _onCreate(db, version) async {
    print("criando tabelas...");
    await db.execute(
        "CREATE TABLE turma(id VARCHAR(50) NOT NULL PRIMARY KEY, nome TEXT, admin INTEGER );");
    await db.execute(
        "CREATE TABLE dever(id VARCHAR(50) NOT NULL PRIMARY KEY, title TEXT, data INTEGER, materiaID VARCHAR(50), turmaID VARCHAR(50), local TEXT, pontos REAL, FOREIGN KEY (materiaID) REFERENCES materia(id) ON DELETE CASCADE, FOREIGN KEY (turmaID) REFERENCES turma(id) ON DELETE CASCADE);");
    await db.execute(
        "CREATE TABLE materia(id VARCHAR(50) NOT NULL PRIMARY KEY, nome TEXT, professor TEXT, contato TEXT, turmaID VARCHAR(50), FOREIGN KEY (turmaID) REFERENCES turma(id) ON DELETE CASCADE);");
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  getByID(String id) {
    for (Turma turma in turmas) {
      if (turma.id == id) {
        return turma;
      }
    }
  }

  set newTurma(Turma? turma) {
    turmaAtual = turma;
    update();
  }

  refreshTurma(String id) async {
    var newTurma = await TurmasState.to.refreshTurma(id);
    var index = turmas.indexWhere((element) => element.id == id);
    turmas[index] = newTurma;
    update();
  }

  changeTurma(Turma newTurma) {
    turmaAtual = newTurma;
    // turmaAtual!.getAtividades();
    update();
  }

  Future addTurma(Turma turma) async {
    await db.insert("turma", turma.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _method.invokeMethod("update");
  }

  Future<Materia> getMateria(String id, String turmaID) async {
    var query = await db.query("materia",
        where: "materia.id = ? AND materia.turmaID = ?",
        whereArgs: [id, turmaID]);
    return Materia.fromJson(query[0]);
  }

  Future getTurmas() async {
    var query = await db.query("turma");
    turmas.clear();

    for (var item in query) {
      String id = item["id"] as String;
      //List<Materia> materias = await getMaterias(id);
      var queryMat =
          await db.rawQuery("SELECT * FROM materia WHERE turmaID = ?", [id]);
      List<Materia> materias = [];
      for (var mat in queryMat) {
        materias.add(Materia.fromJson(mat));
      }
      var turma = Turma.fromJson(item);
      turma.setMaterias = materias;
      if (item["admin"] == 1) {
        turma.setAdmin();
      }
      //turma.setMaterias = materias;
      turmas.add(turma);
    }

    if (turmas.isNotEmpty) {
      turmaAtual = turmas[0];
    } else {
      turmaAtual = null;
    }

    update();
  }

  Future addMateria(Materia materia, String turmaID) async {
    var data = materia.toJson();
    data["turmaID"] = turmaID;
    print(data);
    await db.insert("materia", data);
    _method.invokeMethod("update");
  }

  Future getMaterias(String turmaID) async {
//    var query = await db
    //      .query("materia", where: "materia.turmaID=?", whereArgs: [turmaID]);
    var query =
        await db.rawQuery("SELECT * FROM materia WHERE turmaID = ?", [turmaID]);
    var materias = [];
    for (var item in query) {
      materias.add(Materia.fromJson(item));
    }
    print(materias);
    return materias;
  }

  Future addDever(Dever dever, String turmaID) async {
    var data = dever.toJsonDB();
    data["turmaID"] = turmaID;
    await db.insert("dever", data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    _method.invokeMethod("update");
  }

  Future seeTables() async {
    print(await db.query("turma"));
    print(await db.query("materia"));
    print(await db.query("dever"));
  }

  Future<List> getDeveres(String turmaID) async {
    //var query = await db.query("dever");
    var query = await db.rawQuery(
        "SELECT dever.id, dever.title, dever.data, dever.local, dever.pontos, materia.id as materiaID, materia.nome, materia.professor, materia.contato FROM dever INNER JOIN materia ON dever.materiaID = materia.id WHERE dever.turmaID = ?",
        [turmaID]);
    lista.clear();

    for (var item in query) {
      //Materia materia = await getMateria(
      //  item["materiaID"] as String, item["turmaID"] as String);
      lista.add(Dever.fromJsonDB(item));
    }
    return lista;
  }

  deleteTurma(String turmaID) async {
    await db.delete("turma", where: "id==?", whereArgs: [turmaID]);
    await db.delete("dever", where: "turmaID==?", whereArgs: [turmaID]);
    await db.delete("materia", where: "turmaID==?", whereArgs: [turmaID]);
  }

  Future deleteAll() async {
    await db.delete("dever");
    await db.delete("turma");
    await db.delete("materia");
    print("All deleted");
    _method.invokeMethod("update");
  }
}
