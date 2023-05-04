import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/cronolab/mobile/structure/errosGet.dart';
import 'package:cronolab/modules/cronolab/mobile/structure/getDeveres.dart';
import 'package:cronolab/modules/dever/view/mobile/cadastraDever.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTile.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTileList.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';

import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../shared/components/refresh.dart';
import '../../../shared/models/cronolabExceptions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late IndexController controllerPage;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List?> dataTurmas = Future.value();
  var defaultView = ShowView.Grid;

  @override
  void initState() {
    super.initState();

    dataTurmas = context.read<Turmas>().getData();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: primaryDark,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: primaryDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;

    return Scaffold(
        drawer: Drawer(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Consumer<Turmas>(builder: (context, turmas, child) {
              return ListView(children: [
                ListTile(
                    title: Text(
                  "Turmas",
                  style: Theme.of(context).textTheme.titleMedium,
                )),
                ...context
                    .watch<Turmas>()
                    .turmasSQL
                    .turmas
                    .map((turma) => ListTile(
                        tileColor: (turmas.turmaAtual?.id == turma.id)
                            ? Theme.of(context).hoverColor
                            : Theme.of(context).backgroundColor,
                        onTap: () async {
                          await turmas.changeTurmaAtual(turma);
                          print(""
                                  "Turma: ${turmas.turmaAtual!.id}"
                                  "IsAdmin: " +
                              turmas.turmaAtual!.isAdmin.toString());
                          scaffoldKey.currentState!.openEndDrawer();
                        },
                        title: Text(
                          turma.nome,
                          style: Theme.of(context).textTheme.bodyMedium,
                        )))
                    .toList(),
              ]);
            })),
        key: scaffoldKey,
        body: CustomScrollView(slivers: [
          SliverAppBar(
              leading: IconButton(
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: Colors.black45)),
              toolbarHeight: 55,
              actions: [
                IconButton(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed("/perfil");

                      setState(() {});
                    },
                    icon: const Icon(Icons.person, color: Colors.black45))
              ],
              title: Consumer<Turmas>(builder: (context, turmas, child) {
                return Text(
                  "Cronolab " +
                      (turmas.turmaAtual != null
                          ? " - ${turmas.turmaAtual!.nome.toString()}"
                          : ""),
                  style: TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.w800),
                );
              })),
          SliverFillRemaining(
              child: Refresh(
                  onRefresh: () async {
                    dataTurmas=context.read<Turmas>().getData();
                    var internet = await InternetConnectionChecker().hasConnection;

                    if (internet) {
                      await context.read<Turmas>().turmasFB.loadTurmasUser(context.read<Turmas>().turmasSQL);
                    }

                  },
                  child: FutureBuilder<List?>(
                      future: dataTurmas,
                      builder: (context, snapshot) =>Consumer<Turmas>(
    builder: (context, turmas, _){
                        debugPrint("ConnectionState: " +
                            snapshot.connectionState.toString());

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return ErrosGet(snapshot.error as CronolabException);
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return GetDeveres(turmas);
                        } else if (snapshot.connectionState ==
                            ConnectionState.none) {
                          return const Center(child: Text("Erro Desconhecido"));
                        }
                        return Container();
                      }))))
        ]),
        floatingActionButton:
            Consumer<Turmas>(builder: (context, turmas, child) {
          if (turmas.turmaAtual != null) {
            if (turmas.turmaAtual!.isAdmin) {
              return FloatingActionButton(
                child: const Icon(Icons.add, color: darkPrimary),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {


                  await cadastra(context, turmas, () {
                    setState(() {});
                  });

                  if (!mounted) return;
                  setState(() {});
                },
              );
            }
          }

          return Container();
        }));
  }
}
