import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dia.dart';

class DeveresController with ChangeNotifier {
  Dia? _diaAtual;

  Dia? get diaAtual => _diaAtual;
  set diaAtual(Dia? newDia) {
    _diaAtual = newDia;
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
    var turmas = Provider.of<TurmasStateDesktop>(context, listen: false);

    if (context.read<TurmasStateDesktop>().turmaAtual != null) {
      deveres = turmas.turmaAtual!.deveres ?? [];
    } else {
      deveres = context.read<TurmasStateDesktop>().getAllDeveres();
    }
    while (diaI.isBefore(ultimoDia)) {
      /*debugPrint('''
        DiaI:$diaI
        UltimoDia: $ultimoDia
        PrimeiroDia: $primeiroDia
        Dia1Pronto: $dia1Pronto
      ''');*/

      weeks.add(List.generate(7, (index) {
        if (deveres.isNotEmpty) {
          if (!dia1Pronto) {
            if (index == changeWeekStart(diaI.weekday)) {
              dia1Pronto = true;

              return Dia(
                  diaI,
                  deveres
                      .where((dever) =>
                          dever.data.day == diaI.day &&
                          dever.data.month == diaI.month &&
                          dever.data.year == diaI.year)
                      .toList());
            } else {
              return Dia(
                diaI.subtract(
                    Duration(days: 7 - (7 - diaI.weekday + 1) - index + 1)),
              );
            }
          } else {
            diaI = diaI.add(const Duration(days: 1));

            return Dia(
                diaI,
                deveres
                    .where((dever) =>
                        dever.data.day == diaI.day &&
                        dever.data.month == diaI.month &&
                        dever.data.year == diaI.year)
                    .toList());
          }
        }
        if (!dia1Pronto) {
          if (index == diaI.weekday) {
            dia1Pronto = true;

            return Dia(
              diaI,
            );
          } else {
            return Dia(
              diaI.subtract(
                  Duration(days: 7 - (7 - diaI.weekday + 1) - index + 1)),
            );
          }
        } else {
          diaI = diaI.add(const Duration(days: 1));

          return Dia(
            diaI,
          );
        }
      }));

      if (diaI.isAfter(ultimoDia) || diaI.isAtSameMomentAs(ultimoDia)) {
        break;
      }
    }

    notifyListeners();
  }
}
