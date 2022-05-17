import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cronolab/modules/dever/cadastraDever.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/turmas/turmasProvider.dart';
import 'package:cronolab/modules/user/view/loginPage.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../dever/view/deverTile.dart';

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

  void refresh() {
    setState(() {});
  }

  DateFormat dateStr = DateFormat("dd/MM/yyyy");
  DateFormat hourStr = DateFormat("Hm");

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primary,
      systemNavigationBarColor: primary,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(width);
    return Consumer<TurmasProvider>(builder: (context, turmas, _) {
      if (turmas.turmaAtual == null) {
        turmas.getTurmas();
        // return Container();
      }
      return Scaffold(
          drawer: Drawer(
            backgroundColor: black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListView.builder(
                itemCount: turmas.turmas.length,
                itemBuilder: ((context, index) => ListTile(
                    tileColor:
                        (turmas.turmaAtual!.id == turmas.turmas[index].id)
                            ? pretoClaro
                            : black,
                    onTap: () {
                      turmas.changeTurma = turmas.turmas[index];
                      // value.changeTurma(value.turmas[index]);
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
              ? FutureBuilder<List<QueryDocumentSnapshot<Dever>>?>(
                  future: turmas.turmaAtual!.getAtividades(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<QueryDocumentSnapshot<Dever>>? list = snapshot.data;
                      // print(list);
                      if (snapshot.hasData && list!.length > 0) {
                        print("Lista");
                        return CustomScrollView(slivers: [
                          SliverAppBar(
                            leading: IconButton(
                                onPressed: () {
                                  scaffoldKey.currentState!.openDrawer();
                                },
                                icon: const Icon(Icons.menu,
                                    color: Colors.black26)),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            backgroundColor: const Color(0xffB8DCFF),
                            elevation: 0,
                            centerTitle: true,
                            toolbarHeight: 70,
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/perfil");
                                  },
                                  icon: const Icon(Icons.person,
                                      color: Colors.black26)),
                              IconButton(
                                  onPressed: () {
                                    // Navigator.pushNamed(context, "/perfil");
                                    // print(OneSignal().ex)
                                  },
                                  icon: const Icon(Icons.person,
                                      color: Colors.black26)),
                            ],
                            title: GestureDetector(
                                onDoubleTap: _incrementCounter,
                                onTap: () {
                                  print(turmas.turmaAtual!.isAdmin);
                                },
                                onLongPress: () async {},
                                child: Text(
                                  frases[_counter] +
                                      (turmas.turmaAtual != null
                                          ? " - ${turmas.turmaAtual!.nome.toString()}"
                                          : ""),
                                  style: const TextStyle(color: Colors.black26),
                                )),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(10),
                            sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 1 / 1.7,
                                        crossAxisCount: width < 600
                                            ? 2
                                            : (width / 300).round(),
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) => DeverTile(list![i].data(),
                                      notifyParent: refresh),
                                  childCount: list!.length,
                                )),
                          )
                        ]);
                      } else {
                        print("Sem tarefa");
                        return CustomScrollView(slivers: [
                          SliverAppBar(
                            leading: IconButton(
                                onPressed: () {
                                  scaffoldKey.currentState!.openDrawer();
                                },
                                icon: const Icon(Icons.menu,
                                    color: Colors.black26)),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            backgroundColor: const Color(0xffB8DCFF),
                            elevation: 0,
                            centerTitle: true,
                            toolbarHeight: 70,
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/perfil");
                                  },
                                  icon: const Icon(Icons.person,
                                      color: Colors.black26))
                            ],
                            title: GestureDetector(
                                onDoubleTap: _incrementCounter,
                                onTap: () {
                                  print(turmas.turmaAtual!.isAdmin);
                                },
                                onLongPress: () async {},
                                child: Text(
                                  frases[_counter] +
                                      (turmas.turmaAtual != null
                                          ? " - ${turmas.turmaAtual!.nome.toString()}"
                                          : ""),
                                  style: const TextStyle(color: Colors.black26),
                                )),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Center(child: Text("Não há tarefas Pendentes!!"))
                          ])),
                        ]);
                      }
                    } else {
                      print("Erro");
                      return CustomScrollView(slivers: [
                        SliverAppBar(
                          leading: IconButton(
                              onPressed: () {
                                scaffoldKey.currentState!.openDrawer();
                              },
                              icon: const Icon(Icons.menu,
                                  color: Colors.black26)),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          backgroundColor: const Color(0xffB8DCFF),
                          elevation: 0,
                          centerTitle: true,
                          toolbarHeight: 70,
                          actions: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/perfil");
                                },
                                icon: const Icon(Icons.person,
                                    color: Colors.black26))
                          ],
                          title: GestureDetector(
                              onDoubleTap: _incrementCounter,
                              onTap: () {
                                print(turmas.turmaAtual!.isAdmin);
                              },
                              onLongPress: () async {},
                              child: Text(
                                frases[_counter] +
                                    (turmas.turmaAtual != null
                                        ? " - ${turmas.turmaAtual!.nome.toString()}"
                                        : ""),
                                style: const TextStyle(color: Colors.black26),
                              )),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                          const Center(child: Text("Ocorreu algum ERRO "))
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
                        icon: const Icon(Icons.menu, color: Colors.black26)),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    backgroundColor: const Color(0xffB8DCFF),
                    elevation: 0,
                    centerTitle: true,
                    toolbarHeight: 70,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/perfil");
                          },
                          icon: const Icon(Icons.person, color: Colors.black26))
                    ],
                    title: GestureDetector(
                        onDoubleTap: _incrementCounter,
                        onTap: () {
                          print(turmas.turmaAtual!.isAdmin);
                        },
                        onLongPress: () async {},
                        child: Text(
                          frases[_counter] +
                              (turmas.turmaAtual != null
                                  ? " - ${turmas.turmaAtual!.nome.toString()}"
                                  : ""),
                          style: const TextStyle(color: Colors.black26),
                        )),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      height: height - 70 - MediaQuery.of(context).padding.top,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("Cadastre turmas antes de usar",
                                style: fonts.label),
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(darkPrimary)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/minhasTurmas");
                                },
                                child: Text("Adionar Turmas",
                                    style: fonts.buttonText)),
                          ]),
                    ),
                  ]))
                ]),
          floatingActionButton: turmas.turmaAtual != null
              ? turmas.turmaAtual!.isAdmin
                  ? FloatingActionButton(
                      onPressed: () {
                        cadastra(context, turmas, () {
                          setState(() {});
                        });
                      },
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(15)),
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
