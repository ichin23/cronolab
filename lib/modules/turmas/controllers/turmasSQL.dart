import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/controllers/turmasFirebase.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/shared/models/cronolabExceptions.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TurmasSQL with ChangeNotifier {
  List<Turma> turmas = [];
  Turma? turmaAtual;

  TurmasSQL() {
    init();
  }

  //vARIÁVEL DO BANCO
  Database? db;

  init() async {
    db = await openDatabase(join(await getDatabasesPath(), "cronolab.db"),
        version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
    debugPrint("Banco iniciado");
  }

  isInit() => db?.isOpen;

  static Future _onCreate(db, version) async {
    await db.execute("CREATE TABLE turma(id VARCHAR(50) NOT NULL PRIMARY KEY,"
        " nome TEXT, admin INTEGER );");
    await db.execute("CREATE TABLE dever(id VARCHAR(50) NOT NULL PRIMARY KEY,"
        " title TEXT, data INTEGER, status INTEGER DEFAULT 0,"
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
    turmas.clear();
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

  materiaExist() {}

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
  }

  createTurma(Turma newTurma) async {
    await checkInit();
    await db!.insert(
        "turma",
        {
          "id": newTurma.id,
          "nome": newTurma.nome,
          "admin": newTurma.isAdmin ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await getTurmasData();
  }

  createMateria(Materia materia, String turmaID) async {
    await checkInit();
    debugPrint("Insert");
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

  createDever(Dever dever, String turmaID) async {
    try {
      await checkInit();

      var data = dever.toJsonDB();
      data["turmaID"] = turmaID;
      //var deverExist = await checkDeverExist(dever.id!);

      //if (true) {
      data["status"] = 0;

      await db!
          .insert("dever", data, conflictAlgorithm: ConflictAlgorithm.ignore);
      // } else {
      //   var id = data["id"];
      //   data.remove("id");
      //   db!.update("dever", data, where: "dever.id=?", whereArgs: [id]);
      // }
    } catch (e) {
      //e.printError();
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
    return Turma.fromSQL(queryTurma[0], materias);
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
        "SELECT dever.id, dever.title, dever.data, dever.status, dever.materiaID, dever.local, dever.pontos, materia.nome, materia.professor, materia.contato FROM dever INNER JOIN materia ON dever.materiaID = materia.id WHERE dever.turmaID = ?";

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
          default:
            defaultQuery += " AND dever.data > ?";
            args.add(DateTime.now().microsecondsSinceEpoch);
            break;
        }
      }
      if (filters[1] != null) {
        defaultQuery += " AND dever.materiaID=?";
        args.add(filters[1]);
      }
    } else {
      defaultQuery += " AND dever.data > ?";

      args.add(DateTime.now().millisecondsSinceEpoch);
    }

    defaultQuery += " ORDER BY status,data";

    var query = await db!.rawQuery(defaultQuery, args);
    // var query =
    // await db!.query("dever", where: "turmaID=?", whereArgs: [turmaID], orderBy: "data");
    print("Dever: " + query.toString());
    List<Dever> deveres = [];
    for (var dever in query) {
      deveres.add(Dever.fromJsonDB(dever));
      ;
    }
    return deveres;
  }

  updateTurma() {}

  updateMateria() {}

  updateDever() {}

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
