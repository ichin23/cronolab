import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/view/mobile/components/viewAdmins.dart';
import 'package:cronolab/modules/turmas/view/mobile/components/viewUsers.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GerenciarAdmins extends StatefulWidget {
  GerenciarAdmins(this.turma, {Key? key}) : super(key: key);
  Turma turma;
  @override
  State<GerenciarAdmins> createState() => _GerenciarAdminsState();
}

class _GerenciarAdminsState extends State<GerenciarAdmins>
    with TickerProviderStateMixin {
  late TabController tabController;
  late Turma turma;
  late TurmasServer turmas;
  late Future<List> future;

  void refresh() {
    future = turmas.getParticipantes(turma);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    turma = widget.turma;
    turmas = GetIt.I.get<TurmasServer>();
    future = turmas.getParticipantes(turma);
    tabController = TabController(length: 2, vsync: this);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Gerenciar ${turma.nome}",
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black45,
              )),
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: "Administradores"),
              Tab(text: "Participantes")
            ],
            indicatorColor: darkPrimary,
            labelStyle: const TextStyle(
                color: Colors.black45,
                fontSize: 13,
                fontWeight: FontWeight.w800),
            dividerColor: primaryLight,
            labelColor: Colors.black26,
          ),
        ),
        body: FutureBuilder<List>(
            future: future,
            builder: (context, snap) {
              switch (snap.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return TabBarView(
                    controller: tabController,
                    children: [
                      ViewAdmins(
                          turma,
                          snap.data!
                              .where((element) => element["admin"] == 1)
                              .toList(),
                          refresh),
                      ViewUsers(
                          turma,
                          snap.data!
                              .where((element) => element["admin"] == 1)
                              .toList(),
                          snap.data!
                              .where((element) => element["admin"] == 0)
                              .toList(),
                          refresh)
                    ],
                  );
                default:
                  return const Center(
                      child: Text("Ocorreu algum erro de nossa parte"));
              }
            }));
  }
}
