import 'package:cronolab/core/updater.dart';
import 'package:cronolab/modules/dever/view/deverTile.dart';
import 'package:cronolab/modules/turmas/turmasServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../dever/cadastraDever.dart';
import '../../turmas/turmasLocal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> frases = [
    "Deveres",
    "Pra que abrir SIGAA?",
    "Melhor que o gaTU",
    "Entrou no CEFET, se fudeu"
  ];
  void _incrementCounter() {
    if (_counter == 3) {
      _counter = 0;
    } else {
      _counter++;
    }
    setState(() {});
  }

  refresh() {
    getAtv = TurmasLocal.to.turmaAtual!.getAtvDB();
    setState(() {});
  }

  DateFormat dateStr = DateFormat("dd/MM/yyyy");
  DateFormat hourStr = DateFormat("Hm");
  Future<List?> getAtv = Future(() => []);
  bool erro = false;
  bool loading = true;

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
      try {
        var turmas = TurmasState.to;
        setState(() {
          loading = true;
        });
        bool internet = await InternetConnectionChecker().hasConnection;
        if (internet) {
          Updater().init();
        }
        await TurmasLocal.to.init();
        if (internet) {
          await turmas.getTurmas();
        }

        await TurmasLocal.to.getTurmas();

        //await turmas.turmaAtual!.getAtividades();
        getAtv = TurmasLocal.to.turmaAtual!.getAtvDB();
      } catch (e) {
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
    //TurmasState turmas = TurmasState.to;
    return GetBuilder<TurmasLocal>(
        init: TurmasLocal.to,
        builder: (turmas) {
          return Scaffold(
              drawer: Drawer(
                backgroundColor: black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListView.builder(
                    itemCount: turmas.turmas.length,
                    itemBuilder: ((context, index) => ListTile(
                        tileColor:
                            (turmas.turmaAtual!.id == turmas.turmas[index].id)
                                ? pretoClaro
                                : black,
                        onTap: () {
                          turmas.changeTurma(turmas.turmas[index]);
                          // value.changeTurma(value.turmas[index]);
                          getAtv = turmas.turmaAtual!.getAtvDB();
                          // setState(() {});
                          scaffoldKey.currentState!.openEndDrawer();
                        },
                        title: Text(
                          turmas.turmas[index].nome,
                          style: const TextStyle(color: white),
                        )))),
              ),
              key: scaffoldKey,
              backgroundColor: black,
              body: turmas.turmaAtual != null
                  ? FutureBuilder<List?>(
                      future: getAtv,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List? list = snapshot.data;

                          if (snapshot.hasData && list!.isNotEmpty) {
                            return CustomScrollView(slivers: [
                              SliverAppBar(
                                leading: IconButton(
                                    onPressed: () {
                                      scaffoldKey.currentState!.openDrawer();
                                    },
                                    icon: const Icon(Icons.menu,
                                        color: Colors.black45)),
                                toolbarHeight: 70,
                                actions: [
                                  IconButton(
                                      onPressed: () async {
                                        var espera =
                                            await Get.toNamed("/perfil");
                                        refresh();
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
                                padding: const EdgeInsets.all(10),
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
                            ]);
                          } else {
                            return CustomScrollView(slivers: [
                              SliverAppBar(
                                leading: IconButton(
                                    onPressed: () {
                                      scaffoldKey.currentState!.openDrawer();
                                    },
                                    icon: const Icon(Icons.menu,
                                        color: Colors.black45)),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                backgroundColor: primary,
                                elevation: 0,
                                centerTitle: true,
                                toolbarHeight: 70,
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        Get.toNamed("/perfil");
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
                                        Text(
                                          "Não há tarefas Pendentes!",
                                          style: fonts.white,
                                        ),
                                      ],
                                    ))
                              ])),
                            ]);
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomScrollView(slivers: [
                            SliverAppBar(
                              leading: IconButton(
                                  onPressed: () {
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                  icon: const Icon(Icons.menu,
                                      color: Colors.black45)),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              backgroundColor: primary,
                              elevation: 0,
                              centerTitle: true,
                              toolbarHeight: 70,
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Get.toNamed("/perfil");
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: const [
                                      CircularProgressIndicator()
                                    ]),
                              ),
                            ]))
                          ]);
                        } else {
                          return CustomScrollView(slivers: [
                            SliverAppBar(
                              leading: IconButton(
                                  onPressed: () {
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                  icon: const Icon(Icons.menu,
                                      color: Colors.black45)),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              backgroundColor: primary,
                              elevation: 0,
                              centerTitle: true,
                              toolbarHeight: 70,
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Get.toNamed("/perfil");
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
                                    getAtv = turmas.turmaAtual!.getAtividades();
                                  },
                                  child: const Text("Recarregar"))
                            ]))
                          ]);
                        }
                      },
                    )
                  : CustomScrollView(slivers: [
                      SliverAppBar(
                        leading: IconButton(
                            onPressed: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            icon:
                                const Icon(Icons.menu, color: Colors.black45)),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        backgroundColor: primary,
                        elevation: 0,
                        centerTitle: true,
                        toolbarHeight: 70,
                        actions: [
                          IconButton(
                              onPressed: () {
                                Get.toNamed("/perfil");
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
                          height:
                              height - 70 - MediaQuery.of(context).padding.top,
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
                                          },
                                          child: const Text("Adionar Turmas",
                                              style: fonts.buttonText)),
                                    ]),
                        ),
                      ]))
                    ]),
              floatingActionButton: turmas.turmaAtual != null
                  ? turmas.turmaAtual!.isAdmin
                      ? FloatingActionButton(
                          onPressed: () async {
                            await cadastra(context, turmas, () {});
                            getAtv = turmas.turmaAtual!.getAtividades();
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
