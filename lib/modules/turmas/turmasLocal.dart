import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:flutter/material.dart';
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
  static TurmasLocal get to => Get.find();

  //vARIÁVEL DO BANCO
  late Database db;
  init() async {
    db = await openDatabase(join(await getDatabasesPath(), "mydatabase.db"),
        version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  isInit() => db.isOpen;

  static Future _onCreate(db, version) async {
    await db.execute(
        "CREATE TABLE turma(id VARCHAR(50) NOT NULL PRIMARY KEY, nome TEXT, admin INTEGER );");
    await db.execute(
        "CREATE TABLE dever(id VARCHAR(50) NOT NULL PRIMARY KEY, title TEXT, data INTEGER, status INTEGER DEFAULT 0, materiaID VARCHAR(50), turmaID VARCHAR(50), local TEXT, pontos REAL, FOREIGN KEY (materiaID) REFERENCES materia(id) ON DELETE CASCADE, FOREIGN KEY (turmaID) REFERENCES turma(id) ON DELETE CASCADE);");
    await db.execute(
        "CREATE TABLE materia(id VARCHAR(50) NOT NULL PRIMARY KEY, nome TEXT, professor TEXT, contato TEXT, turmaID VARCHAR(50), FOREIGN KEY (turmaID) REFERENCES turma(id) ON DELETE CASCADE);");
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  checkTurmaExist(String id) async {
    var query = await db.query("turma", where: "turma.id=?", whereArgs: [id]);
    var exist = query.isNotEmpty ? true : false;

    return exist;
  }

  Future addTurma(Turma turma) async {
    if (!(await checkTurmaExist(turma.id))) {
      await db.insert("turma", turma.toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    _method.invokeMethod("update");
  }

  Future<Materia> getMateria(String id, String turmaID) async {
    var query = await db.query("materia",
        where: "materia.id = ? AND materia.turmaID = ?",
        whereArgs: [id, turmaID]);
    return Materia.fromJson(query[0]);
  }

  Future<void> deleteMateria(String id) async {
    var query =
        await db.delete("materia", where: "materia.id==?", whereArgs: [id]);
    return;
  }

  Future getTurmas({bool updateTurma = true}) async {
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
    if (updateTurma) {
      if (turmas.isNotEmpty) {
        turmaAtual = turmas[0];
      } else {
        turmaAtual = null;
      }
    }

    update();
  }

  checkMateriaExist(String id) async {
    var query =
        await db.query("materia", where: "materia.id=?", whereArgs: [id]);
    var exist = query.isNotEmpty ? true : false;

    return exist;
  }

  Future addMateria(Materia materia, String turmaID) async {
    var data = materia.toJson();
    data["turmaID"] = turmaID;
    if (!(await checkMateriaExist(materia.id))) {
      await db.insert("materia", data,
          conflictAlgorithm: ConflictAlgorithm.abort);
    }
    _method.invokeMethod("update");
  }

  Future getMaterias(String turmaID) async {
    var query =
        await db.rawQuery("SELECT * FROM materia WHERE turmaID = ?", [turmaID]);
    var materias = [];
    for (var item in query) {
      materias.add(Materia.fromJson(item));
    }

    return materias;
  }

  Future<List> checkDeverExist(String id) async {
    var query = await db.query("dever", where: "dever.id=?", whereArgs: [id]);
    return query;
  }

  Future addDever(Dever dever, String turmaID) async {
    try {
      var data = dever.toJsonDB();
      data["turmaID"] = turmaID;
      var deverExist = await checkDeverExist(dever.id!);

      if (deverExist.isEmpty) {
        data["status"] = 0;

        await db.insert("dever", data,
            conflictAlgorithm: ConflictAlgorithm.replace);
      } else {
        var id = data["id"];
        data.remove("id");
        db.update("dever", data, where: "dever.id=?", whereArgs: [id]);
      }
    } catch (e) {
      e.printError();
    }
    _method.invokeMethod("update");
  }

  deleteDever(String id) async {
    try {
      await db.delete("dever", where: "id=?", whereArgs: [id]);
    } catch (e) {
      e.printError();
    }
  }

  Future setDeverStatus(String deverID, bool status) async {
    await db.update("dever", {"status": status ? 1 : 0},
        where: "dever.id=?", whereArgs: [deverID]);
  }

  Future seeTables() async {
    debugPrint((await db.query("turma")).toString());
    debugPrint((await db.query("materia")).toString());
    debugPrint((await db.query("dever")).toString());
  }

  Future<List> getDeveres(String turmaID, {List? filter}) async {
    List listWhere = [turmaID];
    String queryStr =
        "SELECT dever.id, dever.title, dever.data, dever.local, dever.status, dever.pontos, materia.id as materiaID, materia.nome, materia.professor, materia.contato FROM dever INNER JOIN materia ON dever.materiaID = materia.id WHERE dever.turmaID = ?";
    if (filter != null) {
      if (filter[0] != null) {
        switch (filter[0] as int) {
          case (0):
            queryStr += " AND dever.data < ?";
            listWhere.add(DateTime.now()
                .add(const Duration(days: 1))
                .millisecondsSinceEpoch);
            break;
          case (1):
            queryStr += " AND dever.data > ? AND dever.data < ?";
            listWhere.add(DateTime.now()
                .add(const Duration(days: 1))
                .millisecondsSinceEpoch);
            listWhere.add(DateTime.now()
                .add(const Duration(days: 5))
                .millisecondsSinceEpoch);
            break;
          case (2):
            queryStr += " AND dever.data > ?";
            listWhere.add(DateTime.now()
                .add(const Duration(days: 5))
                .millisecondsSinceEpoch);
        }
      }
      if (filter[1] != null) {
        queryStr += " AND dever.materiaID = ?";
        listWhere.add(filter[1]);
      }
    }
    queryStr += " ORDER BY status,data";

    var query = await db.rawQuery(queryStr, listWhere);
    lista.clear();

    for (var item in query) {
      debugPrint(item.toString());
      lista.add(Dever.fromJsonDB(item));
      debugPrint(item.toString());
    }
    debugPrint("Infos $lista");
    return lista;
  }

  deleteTurma(String turmaID) async {
    await db.delete("dever", where: "turmaID==?", whereArgs: [turmaID]);
    await db.delete("materia", where: "turmaID==?", whereArgs: [turmaID]);
    await db.delete("turma", where: "id==?", whereArgs: [turmaID]);

    turmas.removeWhere((element) => element.id==turmaID);
    await getTurmas();
    update();
  }

  Future deleteAll() async {
    await db.delete("dever");
    await db.delete("turma");
    await db.delete("materia");

    //_method.invokeMethod("update");
  }

  //Lógica da classe
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

  changeTurmaAtualWithID(String newTurmaID) {
    for (Turma turma in turmas) {
      if (turma.id == newTurmaID) {
        turmaAtual = turma;
        update();
        return;
      }
    }
  }
}
