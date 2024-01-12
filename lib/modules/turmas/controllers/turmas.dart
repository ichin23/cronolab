import 'dart:convert';

import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/shared/models/cronolabExceptions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:cronolab/shared/routes.dart' as r;

class Turmas {
  List<Turma> turmas = [];
  List<Materia> materias = [];
  ValueNotifier<List<Dever>> deveres = ValueNotifier([]);
  final ValueNotifier<Turma?> _turmaAtual = ValueNotifier(null);

  ValueNotifier<Turma?> get turmaAtual => _turmaAtual;

  Future getData() async {
    try {
      var turm = await http.get(r.getData, headers: r.headersAuth);
      var turmasMap = jsonDecode(turm.body);
      if (turm.statusCode != 200) {
        throw CronolabException(turmasMap["error"], turmasMap["code"]);
      }
      print(turmasMap);
      List<Turma> novaTurma = [];
      List<Materia> nomaMat = [];
      List<Dever> novoDever = [];
      for (Map turma in turmasMap["turmas"]) {
        novaTurma.add(Turma.fromSQL(turma));
      }
      for (Map materia in turmasMap["materias"]) {
        nomaMat.add(Materia.fromJson(materia));
      }
      for (Map dever in turmasMap["deveres"]) {
        novoDever.add(Dever.fromJson(dever));
      }
      turmas = novaTurma;
      materias = nomaMat;
      deveres.value = novoDever;
    } on CronolabException catch (e) {
      switch (e.code) {
        case 104:
          GetIt.I.get<UserProvider>().signOut();
          break;
      }
    }
    //await getMaterias();
  }

  Future getMaterias() async {
    var turmasIds = turmas.map((e) => e.id).toList();

    var mat = await http.post(r.getMaterias,
        headers: r.headersAuth, body: jsonEncode({"turmas": turmasIds}));
    List materias = jsonDecode(mat.body);
    print(materias);
    var group = materias.map((e) => MapEntry(e["turmaID"], e));
    print(group);
  }

  Future<List> getParticipantes([Turma? turma]) async {
    turma ??= turmaAtual.value;

    var part = await http.post(Uri.parse(r.baseUrl + "/getParticipantes"),
        headers: r.headersAuth,
        body: jsonEncode({
          "turmaId": turma!.id,
        }));
    return jsonDecode(part.body);
  }

  Future statusDever(int deverId, [bool status = true]) async {
    var part = await http.put(r.statusDever,
        headers: r.headersAuth,
        body: jsonEncode({"deverId": deverId, "status": status}));
  }

  List<Dever> getDeveresFromTurma([Turma? turma]) {
    turma ??= turmaAtual.value;
    return deveres.value
        .where((element) => getMateriasFromTurma(turma!)
            .any((materia) => materia.id == element.materiaID))
        .toList();
  }

  List<Materia> getMateriasFromTurma(Turma turma) {
    return materias.where((element) => element.turmaId == turma.id).toList();
  }

  changeTurma(Turma? turma) {
    _turmaAtual.value = turma;
  }

  cadastraDever(Dever dever) async {
    var res = await http.post(r.addDever,
        headers: r.headersAuth, body: jsonEncode(dever.toJson()));
  }

  addMateria(Materia materia) async {
    try {
      var res = await http.post(r.addMateria,
          headers: r.headersAuth, body: jsonEncode(materia.toJson()));
      debugPrint(res.body);
    } catch (e) {
      debugPrint("Add Materia: " + e.toString());
    }
  }

  deleteMateria(Materia materia) async {
    try {
      var res = await http.delete(
          Uri.parse(r.baseUrl + "/materia" + "?materiaId=${materia.id}"),
          headers: r.headersAuth);
    } catch (e) {}
  }

  Materia? getMateriaById(int id) {
    for (var materia in materias) {
      if (materia.id == id) {
        return materia;
      }
    }
    return null;
  }
}
