import 'package:cronolab/modules/cronolab/mobile/structure/errosGet.dart';
import 'package:cronolab/modules/cronolab/mobile/structure/getDeveres.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';

import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
  bool loading = false;
  Future loadFromFirebase(TurmasServer turmas) async {
    //if(loading)return;
    loading = true;

    var internet = await InternetConnectionChecker().hasConnection;

    if (!internet) {
      return Future.error(CronolabException("Sem Internet", 100));
    }
    /* await turmas.turmasFB.loadTurmasUser(turmas.turmasSQL);
    await turmas.saveFBData();
    dataTurmas = turmas.getData();*/
    loading = false;
  }

  @override
  void initState() {
    super.initState();

    //dataTurmas = context.read<Turmas>().getData();
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

    return FutureBuilder(
        future: Future((() {})),
        builder: (context, snap) {
          print(snap.error);
          return Stack(
            children: [
              Scaffold(
                  key: scaffoldKey,
                  body: CustomScrollView(slivers: [
                    SliverAppBar(
                        leading: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/mudarTurma");
                            },
                            icon:
                                const Icon(Icons.menu, color: Colors.black45)),
                        toolbarHeight: 55,
                        actions: [
                          IconButton(
                              onPressed: () async {
                                await Navigator.of(context)
                                    .pushNamed("/perfil");

                                setState(() {});
                              },
                              icon: const Icon(Icons.person,
                                  color: Colors.black45))
                        ],
                        title: const Text(
                          "Cronolab " /*+
                                (turmas.turmaAtual != null
                                    ? " - ${turmas.turmaAtual!.nome.toString()}"
                                    : "")*/
                          ,
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w800),
                        )),
                    SliverFillRemaining(
                        child: Refresh(
                            onRefresh: () async {
                              /*dataTurmas = context.read<Turmas>().getData();
                              var internet = await InternetConnectionChecker()
                                  .hasConnection;

                              if (internet) {
                                await context
                                    .read<Turmas>()
                                    .turmasFB
                                    .loadTurmasUser(
                                        context.read<Turmas>().turmasSQL);
                              }*/
                            },
                            child: FutureBuilder<List?>(
                                future: dataTurmas,
                                builder: (context, snapshot) =>
                                    ValueListenableBuilder(
                                        valueListenable: ValueNotifier("a"),
                                        builder: (context, turmas, _) {
                                          /*  if (turmas.turmasSQL.turmas.isEmpty &&
                                          turmas.turmasFB.turmas.isNotEmpty &&
                                          !turmas.turmasFB.loadingTurmas) {
                                        dataTurmas = turmas.getData();
                                      }*/

                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return ErrosGet(!snapshot.hasError
                                                ? CronolabException(
                                                    "Nenhuma turma cadastrada!",
                                                    11)
                                                : snapshot.error
                                                    as CronolabException);
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            //return GetDeveres(turmas);
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.none) {
                                            return const Center(
                                                child:
                                                    Text("Erro Desconhecido"));
                                          }
                                          return Container();
                                        }))))
                  ]),
                  floatingActionButton: null
                  /* if (turmas.turmaAtual != null) {
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
                    }*/

                  ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: snap.connectionState == ConnectionState.waiting
                      ? const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator())
                      : snap.hasError
                          ? Icon(
                              Icons
                                  .signal_wifi_connected_no_internet_4_outlined,
                              color: primaryDark.withOpacity(0.7),
                            )
                          : Container())
            ],
          );
        });
  }
}
