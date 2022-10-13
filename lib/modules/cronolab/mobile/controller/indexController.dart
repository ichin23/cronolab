import 'package:cronolab/core/updater.dart';
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

  bool get turmaAtualIsNull => TurmasLocal.to.turmaAtual == null;

  loadData() async {
    try {
      var turmas = TurmasState.to;

      loading = true;
      update();
      bool internet = await InternetConnectionChecker().hasConnection;
      print("Internet: $internet");
      if (internet) {
        Updater().init();

        await turmas.getTurmas();
      }

      await TurmasLocal.to.getTurmas();
      print("TurmaAtual: ${TurmasLocal.to.turmaAtual}");
      if (TurmasLocal.to.turmaAtual == null && !internet) {
        getAtv = Future.error(
            CronolabException("Sem internet e nenhuma turma encontrada", 10));
        update();
      } else if (TurmasLocal.to.turmaAtual != null) {
        await TurmasLocal.to.turmaAtual?.getAtividades();
        getAtv = TurmasLocal.to.turmaAtual!.getAtvDB(filters: listFilter);
      } else {
        getAtv =
            Future.error(CronolabException("Nenhuma turma Cadastrada", 11));
      }
      update();

      //await TurmasLocal.to.getTurmas();

      //await turmas.turmaAtual!.getAtividades();/v

    } on Exception catch (e) {
      print(e);
      erro = true;
      loading = false;
      update();
    }
    loading = false;
    update();
  }
}
