import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:intl/intl.dart';
import 'dia.dart';

class DeveresController with ChangeNotifier {
  final ValueNotifier<Dia?> diaAtualList = ValueNotifier(null);

  Dia? get diaAtual => diaAtualList.value;
  set diaAtual(Dia? newDia) {
    diaAtualList.value = newDia;
    notifyListeners();
  }

  DateTime hoje = DateTime.now();
  DateTime data = DateTime.now();
  late DateTime diaI;
  late DateTime ultimoDia;
  late DateTime primeiroDia;
  late int mes;
  bool dia1Pronto = false;

  bool showDeveres = false;
  Offset? showDeveresPosition;
  List _deveresToShow = [];

  get deveresToShow => _deveresToShow;
  set deveresToShow(dev) {
    _deveresToShow = dev;
    notifyListeners();
  }

  changeWeekStart(int day) {
    switch (day) {
      case 7:
        return 0;
      default:
        return day;
    }
  }

  List week = [];
  List<List<Dia?>> weeks = [];
  DateFormat hourStr = DateFormat("Hm");
  buildCalendar(DateTime newData, BuildContext context) {
    data = newData;
    weeks.clear();
    dia1Pronto = false;
    mes = data.month;
    primeiroDia = DateTime(data.year, data.month, 1);
    ultimoDia = DateTime(primeiroDia.year, primeiroDia.month + 1, 0);
    diaI = primeiroDia;
    diaAtual = null;

    List<Dever> deveres = [];
    var turmas = GetIt.I.get<TurmasServer>();

    if (turmas.turmaAtual.value != null) {
      deveres = turmas.getDeveresFromTurma();
    } else {
      deveres = turmas.deveres.value;
    }
    while (diaI.isBefore(ultimoDia)) {
      /*debugPrint('''
        DiaI:$diaI
        UltimoDia: $ultimoDia
        PrimeiroDia: $primeiroDia
        Dia1Pronto: $dia1Pronto
      ''');*/

      // Definir a data inicial
      DateTime dataInicial = DateTime.now();

      // Obter o primeiro dia do mês
      DateTime primeiroDiaDoMes =
          DateTime(dataInicial.year, dataInicial.month, 1);

      // Obter o último dia do mês
      DateTime ultimoDiaDoMes =
          DateTime(dataInicial.year, dataInicial.month + 1, 0);

      // Obter o dia da semana do primeiro dia do mês
      int diaDaSemanaPrimeiroDia = primeiroDiaDoMes.weekday;

      // Loop para percorrer as semanas do mês
      for (DateTime data = primeiroDiaDoMes
              .subtract(Duration(days: diaDaSemanaPrimeiroDia - 1));
          data.isBefore(ultimoDiaDoMes);
          data = data.add(const Duration(days: 7))) {
        // Criar uma lista para armazenar os dias da semana
        List<Dia> diasDaSemana = [];

        // Loop para adicionar os dias da semana à lista
        for (int j = 0; j < 7; j++) {
          // Adicionar o dia à lista
          diasDaSemana.add(Dia(data.add(Duration(days: j))));
        }

        // Adicionar a lista de dias da semana à lista de semanas
        weeks.add(diasDaSemana);
      }

      notifyListeners();
    }
  }
}
