import 'package:cronolab/modules/turmas/controllers/turmasFirebase.dart';
import 'package:cronolab/modules/turmas/controllers/turmasSQL.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/shared/models/cronolabExceptions.dart';
import 'package:flutter/material.dart';

class Turmas with ChangeNotifier {
  TurmasFirebase turmasFB = TurmasFirebase();
  TurmasSQL turmasSQL = TurmasSQL();
  Turma? turmaAtual;
  List<Dever>? deveresAtuais;

  Future<List> getData([List? listFilter]) async {
    try {
      await turmasSQL.getTurmasData();

      if (turmasSQL.turmas.isEmpty) {
        throw CronolabException("Nenhuma turma cadastrada!", 11);
      }

      turmaAtual = turmasSQL.turmas.first;
      var deveres = await turmasSQL.readDeveres(turmaAtual!.id, listFilter);
      if (deveres == null) {
        throw CronolabException("Nenhum dever encontrado!", 12);
      } else {
        deveresAtuais = deveres;
      }

      notifyListeners();
      return deveres;
    } on CronolabException {
      rethrow;
    }
  }

  Turma? getTurmaByID(String id) {
    for (var turma in turmasSQL.turmas) {
      if (turma.id == id) {
        return turma;
      }
    }
    return null;
  }

  Future saveFBData() async {
    for (var turma in turmasFB.turmas) {
      await turmasSQL.createFullTurma(turma);
    }
  }

  changeTurmaAtual(Turma newTurma) {
    turmaAtual = newTurma;
    notifyListeners();
  }

  getDeveres([Turma? turma]) async {
    try {
      turma = turma ?? turmaAtual;
      if (turma != null) {
        var deveres = await turmasSQL.readDeveres(turma.id);
        if (deveres == null) {
          throw CronolabException("Nenhum dever encontrado!", 12);
        } else {
          deveresAtuais = deveres;
        }
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
