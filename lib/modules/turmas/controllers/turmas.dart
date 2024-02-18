import 'dart:convert';

import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';
import 'package:cronolab/modules/turmas/controllers/turmasRepository.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/view/desktop/novaTurma.dart';
import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/models/cronolabExceptions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:cronolab/shared/routes.dart' as r;

class TurmasServer implements TurmasRepository {
  ValueNotifier<List<Turma>> turmas = ValueNotifier([]);
  List<Materia> materias = [];
  ValueNotifier<List<Dever>> deveres = ValueNotifier([]);
  final ValueNotifier<Turma?> _turmaAtual = ValueNotifier(null);

  ValueNotifier<Turma?> get turmaAtual => _turmaAtual;

  @override
  Future<Map> getData() async {
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
      turmas.value = novaTurma;
      materias = nomaMat;
      deveres.value = novoDever;
      return {
        "dever": deveres.value,
        "materias": materias,
        "turmas": turmas.value,
      };
    } on CronolabException catch (e) {
      switch (e.code) {
        case 104:
          GetIt.I.get<UserProvider>().signOut();
          break;
      }
      return {};
    }
    //await getMaterias();
  }

  @override
  checkAdmin(Dever dever) {
    return turmas.value
        .where((t) => t.id == getMateriaById(dever.materiaID!)!.turmaId!)
        .toList()[0]
        .isAdmin;
  }

  @override
  Future getMaterias() async {
    var turmasIds = turmas.value.map((e) => e.id).toList();

    var mat = await http.post(r.getMaterias,
        headers: r.headersAuth, body: jsonEncode({"turmas": turmasIds}));
    List materias = jsonDecode(mat.body);
    print(materias);
    var group = materias.map((e) => MapEntry(e["turmaID"], e));
    print(group);
  }

  @override
  Future<List> getParticipantes([Turma? turma]) async {
    turma ??= turmaAtual.value;

    var part = await http.post(Uri.parse(r.baseUrl + "/getParticipantes"),
        headers: r.headersAuth,
        body: jsonEncode({
          "turmaId": turma!.id,
        }));
    return jsonDecode(part.body);
  }

  @override
  Future updateDever(Dever dever) async {
    var part = await http.put(r.statusDever,
        headers: r.headersAuth, body: jsonEncode(dever.toJson()));
  }

  @override
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

  @override
  cadastraDever(Dever dever) async {
    var res = await http.post(r.dever,
        headers: r.headersAuth, body: jsonEncode(dever.toJson()));
  }

  @override
  deleteDever(Dever dever) async {
    var res = await http.delete(r.dever.replace(query: "deverId=${dever.id}"),
        headers: r.headersAuth);
  }

  @override
  addMateria(Materia materia) async {
    try {
      var res = await http.post(r.materia,
          headers: r.headersAuth, body: jsonEncode(materia.toJson()));
      debugPrint(res.body);
    } catch (e) {
      debugPrint("Add Materia: " + e.toString());
    }
  }

  @override
  enterTurma(String turmaId) async {
    var enter = await http.post(r.enterTurma,
        headers: r.headersAuth, body: jsonEncode({"turmaId": turmaId}));
    /*TODO:if (enter.statusCode != 200 && enter.statusCode == 404) {
      late BuildContext newContext;
      bool? criar = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Essa turma não existe"),
          content: const Text("Deseja cria uma nova turma?"),
          actions: [
            TextButton(
                child: const Text("Não"),
                onPressed: () {
                  if (context.mounted) Navigator.pop(context);
                }),
            TextButton(
                child: const Text("Sim"),
                onPressed: () {
                  newContext = context;
                  if (context.mounted) Navigator.pop(context, true);
                })
          ],
        ),
      );
      if (criar ?? false) {
        await novaTurma(newContext, true, turmaId);
      }
    }*/
  }

  sairTurma(BuildContext context, String turmaId) async {
    var res = await http.delete(r.sairTurma,
        headers: r.headersAuth, body: jsonEncode({"turmaId": turmaId}));
    if (res.statusCode == 405) {
      showDialog(
          context: context,
          builder: (context) => Container(
                  child: Column(
                children: [
                  const Text(
                      "Você é o único administrador. Essa turma deixarã de existir"),
                  Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                    color: primaryDark, width: 3))),
                        child: const Text("Cancelar"),
                        onPressed: () {},
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: primaryDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text("OK"),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              )));
    }
  }

  @override
  criarTurma(String turmaId, String nomeTurma) async {
    await http.post(r.criarTurma,
        headers: r.headersAuth,
        body: jsonEncode({"turmaId": turmaId, "nome": nomeTurma}));
  }

  @override
  deleteMateria(Materia materia) async {
    try {
      var res = await http.delete(
          Uri.parse(r.baseUrl + "/materia" + "?materiaId=${materia.id}"),
          headers: r.headersAuth);
    } catch (e) {}
  }

  @override
  Materia? getMateriaById(int id) {
    for (var materia in materias) {
      if (materia.id == id) {
        return materia;
      }
    }
    return null;
  }

  Future<void> editarMateria(Materia materia) async {
    var res = http.put(r.editMateria,
        headers: r.headersAuth, body: jsonEncode(materia.toJson()));
  }
}
