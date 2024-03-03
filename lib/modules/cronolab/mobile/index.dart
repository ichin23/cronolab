import 'package:cronolab/modules/cronolab/mobile/structure/errosGet.dart';
import 'package:cronolab/modules/cronolab/mobile/structure/getDeveres.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';

import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:math' as math;

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
  bool openAppBar = false;

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
        future: GetIt.I.get<TurmasServer>().getData(),
        builder: (context, snap) {
          return Scaffold(
              key: scaffoldKey,
              body: Stack(children: [
                CustomScrollView(slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
                                          return const GetDeveres();
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.none) {
                                          return const Center(
                                              child: Text("Erro Desconhecido"));
                                        }
                                        return Container();
                                      }))))
                ]),
                Container(
                    color: openAppBar ? Colors.black38 : Colors.transparent),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        openAppBar = !openAppBar;
                      });
                    },
                    child: AnimatedContainer(
                        color: backgroundDark,
                        duration: const Duration(milliseconds: 400),
                        height: openAppBar
                            ? MediaQuery.of(context).size.height * 0.6
                            : 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: primaryDark,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/mudarTurma");
                                        },
                                        icon: Transform.rotate(
                                            angle: math.pi / 2,
                                            child: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.black45))),
                                    const Text(
                                      "Cronolab " /*+
                                          (turmas.turmaAtual != null
                                              ? " - ${turmas.turmaAtual!.nome.toString()}"
                                              : "")*/
                                      ,
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await Navigator.of(context)
                                              .pushNamed("/perfil");

                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.person,
                                            color: Colors.black45))
                                  ]),
                            ),
                          ],
                        ))),
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
              ]),
              floatingActionButton: null);
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
        });
  }
}
