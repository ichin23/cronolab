import 'package:cronolab/core/updater.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTile.dart';
import 'package:cronolab/modules/dever/view/mobile/filterDever.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:cronolab/shared/refresh.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../dever/view/mobile/cadastraDever.dart';
import '../../turmas/turmasLocal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> frases = ["Cronolab"];
  void _incrementCounter() {
    _counter++;
    if (_counter == frases.length) {
      _counter = 0;
    }
    setState(() {});
  }

  refresh() {
    getAtv = TurmasLocal.to.turmaAtual!.getAtvDB(filters: listFilter);
    setState(() {});
  }

  DateFormat dateStr = DateFormat("dd/MM/yyyy");
  DateFormat hourStr = DateFormat("Hm");
  Future<List?> getAtv = Future(() => []);
  bool erro = false;
  bool loading = true;
  List? listFilter;
  var refreshVisible = false;

  @override
  void initState() {
    super.initState();
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: primary2,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: primary2,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("init");
      try {
        var turmas = TurmasState.to;
        setState(() {
          loading = true;
        });
        bool internet = await InternetConnectionChecker().hasConnection;
        print(internet);

        if (internet) {
          Updater().init();
        }
        if (internet) {
          await turmas.getTurmas();
        }

        print("Turmas Pronto");
        await TurmasLocal.to.getTurmas();
        print("Pegando local");
        //await turmas.turmaAtual!.getAtividades();
        getAtv = TurmasLocal.to.turmaAtual!.getAtvDB(filters: listFilter);
      } catch (e) {
        e.printError();
        setState(() {
          erro = true;
          loading = false;
        });
      }
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    //TurmasState turmas = TurmasState.to;
    return GetBuilder<TurmasLocal>(
        init: TurmasLocal.to,
        builder: (turmas) {
          return Scaffold(
              drawer: Drawer(
                  backgroundColor: black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView(children: [
                    const ListTile(
                        title: Text(
                      "Turmas",
                      style: fonts.label,
                    )),
                    ...turmas.turmas
                        .map((turma) => ListTile(
                            tileColor: (turmas.turmaAtual!.id == turma.id)
                                ? pretoClaro
                                : black,
                            onTap: () {
                              turmas.changeTurma(turma);
                              // value.changeTurma(value.turmas[index]);
                              getAtv = turmas.turmaAtual!
                                  .getAtvDB(filters: listFilter);
                              // setState(() {});
                              scaffoldKey.currentState!.openEndDrawer();
                            },
                            title: Text(
                              turma.nome,
                              style: const TextStyle(color: white),
                            )))
                        .toList(),
                  ])),
              key: scaffoldKey,
              backgroundColor: black,
              body: turmas.turmaAtual != null
                  ? FutureBuilder<List?>(
                      future: getAtv,
                      builder: (context, snapshot) {
                        debugPrint(snapshot.data.toString());
                        if (snapshot.connectionState == ConnectionState.done) {
                          List? list = snapshot.data;

                          if (snapshot.hasData && list!.isNotEmpty) {
                            return Refresh(
                              onRefresh: () async {
                                if (turmas.turmaAtual != null) {
                                  await turmas.turmaAtual!.getAtividades();

                                  getAtv = turmas.turmaAtual!.getAtvDB();
                                  setState(() {});
                                }
                              },
                              child: CustomScrollView(slivers: [
                                SliverAppBar(
                                  leading: IconButton(
                                      onPressed: () {
                                        scaffoldKey.currentState!.openDrawer();
                                      },
                                      icon: const Icon(Icons.menu,
                                          color: Colors.black45)),
                                  toolbarHeight: 55,
                                  actions: [
                                    IconButton(
                                        onPressed: () async {
                                          var espera =
                                              await Get.toNamed("/perfil");
                                          if (turmas.turmaAtual != null) {
                                            getAtv = turmas.turmaAtual!
                                                .getAtividades();
                                            setState(() {});
                                          }
                                        },
                                        icon: const Icon(Icons.person,
                                            color: Colors.black45)),
                                  ],
                                  title: GestureDetector(
                                      onDoubleTap: _incrementCounter,
                                      onLongPress: () async {},
                                      child: Text(
                                        frases[_counter] +
                                            (turmas.turmaAtual != null
                                                ? " - ${turmas.turmaAtual!.nome.toString()}"
                                                : ""),
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w800),
                                      )),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.only(right: 10),
                                  sliver: SliverList(
                                      delegate: SliverChildListDelegate(
                                    [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                listFilter = await filterDever(
                                                    oldList: listFilter);
                                                if (turmas.turmaAtual != null) {
                                                  getAtv = turmas.turmaAtual!
                                                      .getAtvDB(
                                                          filters: listFilter);
                                                  setState(() {});
                                                }
                                                debugPrint(
                                                    listFilter.toString());
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: listFilter != null
                                                        ? listFilter![0] !=
                                                                    null &&
                                                                listFilter![
                                                                        1] !=
                                                                    null
                                                            ? primary2
                                                            : Colors.transparent
                                                        : Colors.transparent),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.filter_list,
                                                      color: listFilter != null
                                                          ? listFilter![0] !=
                                                                      null &&
                                                                  listFilter![
                                                                          1] !=
                                                                      null
                                                              ? black
                                                              : primary2
                                                          : primary2,
                                                    ),
                                                    Text(
                                                      "Filtro",
                                                      style: TextStyle(
                                                          color: listFilter !=
                                                                  null
                                                              ? listFilter![0] !=
                                                                          null &&
                                                                      listFilter![
                                                                              1] !=
                                                                          null
                                                                  ? black
                                                                  : primary2
                                                              : primary2),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  sliver: SliverGrid(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 1 / 1.4,
                                              crossAxisCount: width < 600
                                                  ? 2
                                                  : (width / 300).round(),
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, i) => DeverTile(list[i],
                                            notifyParent: refresh),
                                        childCount: list.length,
                                      )),
                                )
                              ]),
                            );
                          } else {
                            return SizedBox(
                                width: width,
                                height: height,
                                child: Refresh(
                                  onRefresh: () async {
                                    if (turmas.turmaAtual != null) {
                                      await turmas.turmaAtual!.getAtividades();

                                      getAtv = turmas.turmaAtual!.getAtvDB();

                                      setState(() {});
                                    }
                                  },
                                  child: CustomScrollView(slivers: [
                                    SliverAppBar(
                                      leading: IconButton(
                                          onPressed: () {
                                            scaffoldKey.currentState!
                                                .openDrawer();
                                          },
                                          icon: const Icon(Icons.menu,
                                              color: Colors.black45)),
                                      backgroundColor: primary,
                                      elevation: 0,
                                      centerTitle: true,
                                      toolbarHeight: 55,
                                      actions: [
                                        IconButton(
                                            onPressed: () async {
                                              await Get.toNamed("/perfil");
                                              if (turmas.turmaAtual != null) {
                                                getAtv = turmas.turmaAtual!
                                                    .getAtvDB(
                                                        filters: listFilter);
                                                setState(() {});
                                              }
                                            },
                                            icon: const Icon(Icons.person,
                                                color: Colors.black45))
                                      ],
                                      title: GestureDetector(
                                          onDoubleTap: _incrementCounter,
                                          onTap: () {},
                                          onLongPress: () async {},
                                          child: Text(
                                            frases[_counter] +
                                                (turmas.turmaAtual != null
                                                    ? " - ${turmas.turmaAtual!.nome.toString()}"
                                                    : ""),
                                            style: const TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w800),
                                          )),
                                    ),
                                    SliverList(
                                        delegate: SliverChildListDelegate([
                                      TextButton(
                                          onPressed: () async {
                                            listFilter = await filterDever(
                                                oldList: listFilter);
                                            if (turmas.turmaAtual != null) {
                                              getAtv = turmas.turmaAtual!
                                                  .getAtvDB(
                                                      filters: listFilter);
                                              setState(() {});
                                            }
                                            debugPrint(listFilter.toString());
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            //mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.filter_list),
                                              Text("Filtro"),
                                            ],
                                          )),
                                      SizedBox(
                                          height: height -
                                              70 -
                                              MediaQuery.of(context)
                                                  .padding
                                                  .top,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: const [
                                              Text(
                                                "Não há tarefas Pendentes!",
                                                style: fonts.white,
                                              ),
                                            ],
                                          ))
                                    ])),
                                  ]),
                                ));
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Refresh(
                            onRefresh: () async {
                              await turmas.turmaAtual!.getAtividades();

                              getAtv = turmas.turmaAtual!.getAtvDB();
                              setState(() {});
                            },
                            child: CustomScrollView(slivers: [
                              SliverAppBar(
                                leading: IconButton(
                                    onPressed: () {
                                      scaffoldKey.currentState!.openDrawer();
                                    },
                                    icon: const Icon(Icons.menu,
                                        color: Colors.black45)),
                                backgroundColor: primary,
                                elevation: 0,
                                centerTitle: true,
                                toolbarHeight: 55,
                                actions: [
                                  IconButton(
                                      onPressed: () async {
                                        await Get.toNamed("/perfil");
                                        if (turmas.turmaAtual != null) {
                                          getAtv = turmas.turmaAtual!
                                              .getAtvDB(filters: listFilter);
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(Icons.person,
                                          color: Colors.black45))
                                ],
                                title: GestureDetector(
                                    onDoubleTap: _incrementCounter,
                                    onTap: () {},
                                    onLongPress: () async {},
                                    child: Text(
                                      frases[_counter] +
                                          (turmas.turmaAtual != null
                                              ? " - ${turmas.turmaAtual!.nome.toString()}"
                                              : ""),
                                      style: const TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800),
                                    )),
                              ),
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                SizedBox(
                                  height: height -
                                      70 -
                                      MediaQuery.of(context).padding.top,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: const [
                                        CircularProgressIndicator()
                                      ]),
                                ),
                              ]))
                            ]),
                          );
                        } else {
                          return Refresh(
                            onRefresh: () async {
                              await turmas.turmaAtual!.getAtividades();

                              getAtv = turmas.turmaAtual!.getAtvDB();
                              setState(() {});
                            },
                            child: CustomScrollView(slivers: [
                              SliverAppBar(
                                leading: IconButton(
                                    onPressed: () {
                                      scaffoldKey.currentState!.openDrawer();
                                    },
                                    icon: const Icon(Icons.menu,
                                        color: Colors.black45)),
                                backgroundColor: primary,
                                elevation: 0,
                                centerTitle: true,
                                toolbarHeight: 55,
                                actions: [
                                  IconButton(
                                      onPressed: () async {
                                        Get.toNamed("/perfil");
                                        if (turmas.turmaAtual != null) {
                                          getAtv = turmas.turmaAtual!
                                              .getAtvDB(filters: listFilter);
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(Icons.person,
                                          color: Colors.black45))
                                ],
                                title: GestureDetector(
                                    onDoubleTap: _incrementCounter,
                                    onTap: () {},
                                    onLongPress: () async {},
                                    child: Text(
                                      frases[_counter] +
                                          (turmas.turmaAtual != null
                                              ? " - ${turmas.turmaAtual!.nome.toString()}"
                                              : ""),
                                      style: const TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800),
                                    )),
                              ),
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                const Center(child: Text("Ocorreu algum erro")),
                                TextButton(
                                    onPressed: () {
                                      getAtv = turmas.turmaAtual!
                                          .getAtvDB(filters: listFilter);
                                    },
                                    child: const Text("Recarregar"))
                              ]))
                            ]),
                          );
                        }
                      },
                    )
                  : Refresh(
                      onRefresh: () async {
                        await TurmasState.to.getTurmas();
                        await TurmasLocal.to.getTurmas();
                      },
                      child: CustomScrollView(slivers: [
                        SliverAppBar(
                          leading: IconButton(
                              onPressed: () {
                                scaffoldKey.currentState!.openDrawer();
                              },
                              icon: const Icon(Icons.menu,
                                  color: Colors.black45)),
                          backgroundColor: primary,
                          elevation: 0,
                          centerTitle: true,
                          toolbarHeight: 55,
                          actions: [
                            IconButton(
                                onPressed: () async {
                                  await Get.toNamed("/perfil");
                                  if (turmas.turmaAtual != null) {
                                    getAtv = turmas.turmaAtual!
                                        .getAtvDB(filters: listFilter);
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(Icons.person,
                                    color: Colors.black45))
                          ],
                          title: GestureDetector(
                              onDoubleTap: _incrementCounter,
                              onTap: () {},
                              onLongPress: () async {},
                              child: Text(
                                frases[_counter] +
                                    (turmas.turmaAtual != null
                                        ? " - ${turmas.turmaAtual!.nome.toString()}"
                                        : ""),
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800),
                              )),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                          SizedBox(
                            height: height -
                                70 -
                                MediaQuery.of(context).padding.top,
                            child: loading
                                ? Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(
                                        color: darkPrimary,
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children:
                                        /*turmas.loading
                                      ? [CircularProgressIndicator()]
                                      :*/
                                        [
                                        const Text(
                                            "Cadastre turmas antes de usar",
                                            style: fonts.label),
                                        TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        darkPrimary)),
                                            onPressed: () {
                                              Get.toNamed("/minhasTurmas");
                                              if (turmas.turmaAtual != null) {
                                                getAtv = turmas.turmaAtual!
                                                    .getAtividades();
                                                setState(() {});
                                              }
                                            },
                                            child: const Text("Adionar Turmas",
                                                style: fonts.buttonText)),
                                      ]),
                          ),
                        ]))
                      ]),
                    ),
              floatingActionButton: turmas.turmaAtual != null
                  ? turmas.turmaAtual!.isAdmin
                      ? FloatingActionButton(
                          onPressed: () async {
                            await cadastra(context, turmas, () {});
                            await turmas.turmaAtual!.getAtividades();
                            getAtv = turmas.turmaAtual!
                                .getAtvDB(filters: listFilter);
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.add,
                            color: darkPrimary,
                          ),
                          backgroundColor: primary,
                        )
                      : null
                  : null);
        });

    // : Container(color: black));
  }
}
