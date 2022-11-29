import 'package:cronolab/core/updater.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/cronolabExceptions.dart';

class IndexController extends GetxController {
  final int _counter = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat dateStr = DateFormat("dd/MM/yyyy");
  DateFormat hourStr = DateFormat("Hm");

  Future<List?> getAtv = Future(() => []);

  bool erro = false;
  bool loading = false;
  List? _listFilter;
  var refreshVisible = false;

  refreshDb() {
    getAtv = TurmasLocal.to.turmaAtual!.getAtvDB(filters: listFilter);
    update();
  }

  /* Future<List?> get getAtv => _getAtv;
  set getAtv(Future<List?> refreshAtv) {
    _getAtv = refreshAtv;
    update();
  } */

  List? get listFilter => _listFilter;
  set listFilter(List? refreshAtv) {
    _listFilter = refreshAtv;
    update();
  }

  reviewData() async {
    var turmasLocal = TurmasLocal.to.turmas;
    var turmasFirebase = TurmasState.to.turmas;
    print(turmasLocal);
    for (var turma in turmasLocal) {
      print(turma);
      var whereTurm =
          turmasFirebase.where((element) => element.id == turma.id).toList();
      print("WhereTurm: " + whereTurm.toString());
      if (whereTurm.isEmpty) {
        await TurmasLocal.to.deleteTurma(turma.id);
      } else {
        var atvFirebase = await turma.getAtividades();
        var atvBanco = await turma.getAtvDB();

        if (atvFirebase == null || atvBanco == null) break;
        for (Dever atv in atvBanco) {
          var whereAtv =
              atvFirebase.where((element) => element.id == atv.id).toList();
          print("WhereAtb: " + whereAtv.toString());
          if (whereAtv.isEmpty) {
            await TurmasLocal.to.deleteDever(atv.id!);
          }
        }
      }
    }
    loadData(false);
  }

  bool get turmaAtualIsNull => TurmasLocal.to.turmaAtual == null;

  loadData([bool check = false]) async {
    try {
      var turmas = TurmasState.to;

      loading = true;
      update();
      bool internet = await InternetConnectionChecker().hasConnection;

      if (internet) {
        Updater().init();

        await turmas.getTurmas();
      }

      await TurmasLocal.to.getTurmas();

      if (TurmasLocal.to.turmaAtual == null && !internet) {
        getAtv = Future.error(
            CronolabException("Sem internet e nenhuma turma encontrada", 10));
        update();
        return;
      } else if (TurmasLocal.to.turmaAtual != null) {
        await TurmasLocal.to.turmaAtual?.getAtividades();
        getAtv = TurmasLocal.to.turmaAtual!.getAtvDB(filters: listFilter);
      } else {
        getAtv =
            Future.error(CronolabException("Nenhuma turma Cadastrada", 11));
        loading = false;
        update();
        return;
      }
      if (check) {
        await reviewData();
      }
      loading = false;
      update();
    } on Exception catch (e) {
      print(e);
      erro = true;
      loading = false;
      update();
    }
  }
}
