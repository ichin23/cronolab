import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/controllers/turmasFirebase.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/shared/models/cronolabExceptions.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class TurmasSQL with ChangeNotifier {
  List<Turma> turmas = [];
  Turma? turmaAtual;

  setUpdate(DateTime lastUpdate) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs
        .setInt("ultimaModificacao", lastUpdate.microsecondsSinceEpoch);
  }

  Future<DateTime> getUpdate() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await DateTime.fromMicrosecondsSinceEpoch(
        sharedPrefs.getInt("ultimaModificacao") ?? 0);
  }

  TurmasSQL() {
    init();
  }

  //vARIÁVEL DO BANCO
  Database? db;

  init() async {
    db = await openDatabase(join(await getDatabasesPath(), "cronolab.db"),
        version: 2, onCreate: _onCreate, onConfigure: _onConfigure);

    debugPrint("Banco iniciado");
  }

  isInit() => db?.isOpen;

  static Future _onCreate(db, version) async {
    await db.execute("CREATE TABLE turma(id VARCHAR(50) NOT NULL PRIMARY KEY,"
        " nome TEXT, admin INTEGER );");
    await db.execute("CREATE TABLE dever(id VARCHAR(50) NOT NULL PRIMARY KEY,"
        " title TEXT, data INTEGER, ultimaModificacao  INTEGER, status INTEGER DEFAULT 0,"
        " materiaID VARCHAR(50), turmaID VARCHAR(50), local TEXT, pontos REAL,"
        " FOREIGN KEY (materiaID) REFERENCES materia(id) ON DELETE CASCADE,"
        " FOREIGN KEY (turmaID) REFERENCES turma(id) ON DELETE CASCADE);");
    await db.execute(
        "CREATE TABLE materia(id VARCHAR(50) NOT NULL PRIMARY KEY, nome TEXT,"
        " professor TEXT, contato TEXT, turmaID VARCHAR(50),"
        " FOREIGN KEY (turmaID) REFERENCES turma(id) ON DELETE CASCADE);");
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  checkInit() async {
    if (db == null) {
      await init();
    }
  }

  checkNew(TurmasFirebase turmasFB) async {
    await checkInit();

    for (Turma turma in turmasFB.turmas) {
      if (turmas.where((element) => element.id == turma.id).isEmpty) {
        print("Não existe");
        await createTurma(turma);
        if (turma.materia.isNotEmpty) {
          // for (turmas.materias)
        }
      } else {
        print("existe");
      }
    }
  }

  Future<bool> turmaExist(String turmaID) async {
    await checkInit();

    var turma =
        await db!.query("turma", where: "turma.id = ?", whereArgs: [turmaID]);
    if (turma.isEmpty) {
      return false;
    }

    return true;
  }

  materiaExist(String materiaID) async {
    await checkInit();

    var turma = await db!
        .query("materia", where: "materia.id = ?", whereArgs: [materiaID]);
    if (turma.isEmpty) {
      return false;
    }

    return true;
  }

  Future<bool> deverExist(String deverID, String turmaID) async {
    await checkInit();

    var dever = await db!.query("dever",
        where: "dever.id = ? AND dever.turmaID = ?",
        whereArgs: [deverID, turmaID]);

    if (dever.isEmpty) {
      return false;
    }
    return true;
  }

  Future<List<Turma>> getTurmasData() async {
    await checkInit();

    await checkInit();
    var queryTurma = await db!.rawQuery(
      "SELECT * FROM turma",
    );

    turmas.clear();
    if (queryTurma.isNotEmpty) {
      for (var turma in queryTurma) {
        var queryMateria = await db!.rawQuery(
            "SELECT materia.id as materiaID, materia.nome, professor, contato FROM materia WHERE materia.turmaID=?",
            [turma["id"]]);
        // queryMateria = await db!.query("materia", where: "turmaID=?", whereArgs: [turma["id"]]);
        List<Materia> materias = [];

        for (var materia in queryMateria) {
          materias.add(Materia.fromJsonDB(materia));
        }

        materias.sort((a, b) => a.nome.compareTo(b.nome));

        if (!turmaNaLista(turma["id"].toString())) {
          turmas.add(Turma(
              nome: turma["nome"].toString(),
              id: turma["id"].toString(),
              materia: materias,
              isAdmin: turma["admin"] == 0 ? false : true));
        }
      }
    }

    return turmas;
  }

  Future<void> createFullTurma(Turma newTurma) async {

    await createTurma(newTurma);
    for (var materia in newTurma.materia) {
      await createMateria(materia, newTurma.id);
    }

    if (newTurma.deveres == null) return;

    for (var dever in newTurma.deveres!) {
      await createDever(dever, newTurma.id);
    }

    setUpdate(DateTime.now());
  }

  createTurma(Turma newTurma) async {
    await checkInit();
    var existe = await turmaExist(newTurma.id);

    if (!existe) {
      await db!.insert(
          "turma",
          {
            "id": newTurma.id,
            "nome": newTurma.nome,
            "admin": newTurma.isAdmin ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  createMateria(Materia materia, String turmaID) async {
    await checkInit();

    var existe = await materiaExist(materia.id);
    if (!existe) {
      await db!.insert(
          "materia",
          {
            "id": materia.id,
            "nome": materia.nome,
            "professor": materia.prof,
            "contato": materia.contato,
            "turmaID": turmaID,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  createDever(Dever dever, String turmaID) async {
    var exist = await deverExist(dever.id!, turmaID);

    if (exist) {
      if (dever.deletado == true) {
        await deleteDever(dever);
        return;
      } else {
        await updateDever(dever);
        return;
      }
    }

    await checkInit();
    if (dever.deletado != true) {
      var data = dever.toJsonDB();
      data["turmaID"] = turmaID;

      data["status"] = 0;

      await db!
          .insert("dever", data, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<Turma> readTurma(Turma turma) async {
    await checkInit();

    var queryTurma = await db!.rawQuery(
        "SELECT turma.id, turma.nome, admin, materia.id as materiaID, materia.nome AS materiaNome, professor, contato FROM turma LEFT JOIN materia ON materia.turmaID=? WHERE turma.id=?",
        [turma.id, turma.id]);

    List<Materia> materias = [];

    if (queryTurma.isNotEmpty) {
      for (var materia in queryTurma) {
        if (materia["meteriaNome"] == null) {
          await createMateria(Materia.fromJsonDB(materia), turma.id);
        }
        print(materia);
        materias.add(Materia.fromJsonDB(materia));
      }
    } else {
      await createTurma(turma);
      for (var materia in turma.materia) {
        await createMateria(materia, turma.id);
      }
    }

    materias.sort((a, b) => a.nome.compareTo(b.nome));
    return Turma.fromSQL(queryTurma[0], materias);
  }

  Future<DateTime> readUltimaModificacao(String turmaID) async {
    await checkInit();

    var result = await db!.rawQuery(
        "SELECT MAX(ultimaModificacao) AS maior FROM dever WHERE turmaID = ?",
        [turmaID]);

    if (result.isEmpty || result.first["maior"] == null) {
      return DateTime.fromMicrosecondsSinceEpoch(0);
    } else {
      int resultInt = result.first["maior"] as int;
      var date = DateTime.fromMillisecondsSinceEpoch(resultInt);
      return date;
    }
  }

  Future<Materia?> readMateria(String materiaID) async {
    await checkInit();

    var query =
        await db!.query("materia", where: "id=?", whereArgs: [materiaID]);

    if (query.isNotEmpty) {
      return Materia.fromJson(query[0]);
    } else {
      throw CronolabException("Not Found", 404);
    }
  }

  Future<List<Dever>?> readDeveres(String turmaID, [List? filters]) async {
    await checkInit();
    List args = [turmaID];

    String defaultQuery =
        "SELECT dever.id, dever.title, dever.ultimaModificacao, dever.data, dever.status, dever.materiaID, dever.local, dever.pontos, materia.nome, materia.professor, materia.contato FROM dever INNER JOIN materia ON dever.materiaID = materia.id WHERE dever.turmaID = ?";
    defaultQuery += " AND dever.data > ?";

    args.add(DateTime.now().millisecondsSinceEpoch);
    if (filters != null) {
      if (filters[0] != null) {
        switch (filters[0]) {
          case (0):
            defaultQuery += " AND dever.data < ?";
            args.add(DateTime.now()
                .add(const Duration(days: 1))
                .millisecondsSinceEpoch);
            break;
          case (1):
            defaultQuery += " AND dever.data > ? AND dever.data < ?";
            args.add(DateTime.now()
                .add(const Duration(days: 1))
                .millisecondsSinceEpoch);
            args.add(DateTime.now()
                .add(const Duration(days: 5))
                .millisecondsSinceEpoch);
            break;
          case (2):
            defaultQuery += " AND dever.data > ?";
            args.add(DateTime.now()
                .add(const Duration(days: 5))
                .millisecondsSinceEpoch);
            break;
        }
      }
      if (filters[1] != null) {
        defaultQuery += " AND dever.materiaID=?";
        args.add(filters[1]);
      }
    }

    defaultQuery += " ORDER BY status, data";

    var query = await db!.rawQuery(defaultQuery, args);

    // var query =
    // await db!.query("dever", where: "turmaID=?", whereArgs: [turmaID], orderBy: "data");
    print("Dever: " + query.toString());
    List<Dever> deveres = [];
    for (var dever in query) {
      deveres.add(Dever.fromJsonDB(dever));
    }
    return deveres;
  }

  updateTurma() {}

  updateMateria() {}

  updateDever(Dever dever) async {
    await checkInit();

    await db!.update("dever", dever.toJsonDB(),
        where: "dever.id =?", whereArgs: [dever.id]);
  }

  deleteTurma(Turma turma) async {
    await checkInit();

    await db!.delete("turma", where: "turma.id = ?", whereArgs: [turma.id]);
  }

  deleteMateria() {}

  Future<void> deleteDever(Dever dever) async {
    await checkInit();

    await db!.delete("dever", where: "dever.id = ?", whereArgs: [dever.id]);
  }

  deleteAll() {}

  refresh(TurmasFirebase turmasFB) {
    checkNew(turmasFB);
  }

  bool turmaNaLista(String id) {
    bool naLista = false;

    for (var turma in turmas) {
      if (turma.id == id) {
        naLista = true;
        break;
      }
    }
    return naLista;
  }
}
