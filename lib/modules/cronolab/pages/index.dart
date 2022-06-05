import 'dart:convert';

import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/modules/user/view/loginPage.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../dever/cadastraDever.dart';
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
              ? FutureBuilder<List?>(
                  future: turmas.turmaAtual!.getAtividades(),
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
                            ],
                            title: GestureDetector(
                                onDoubleTap: _incrementCounter,
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
                                  (context, i) =>
                                      DeverTile(list[i], notifyParent: refresh),
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
                                onTap: () {},
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
                            SizedBox(
                                height: height -
                                    70 -
                                    MediaQuery.of(context).padding.top,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Não há tarefas Pendentes!!",
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
                              onTap: () {},
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
                          SizedBox(
                            height: height -
                                70 -
                                MediaQuery.of(context).padding.top,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [const CircularProgressIndicator()]),
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
                              onTap: () {},
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
                        onTap: () {},
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
                          children: turmas.loading
                              ? [CircularProgressIndicator()]
                              : [
                                  Text("Cadastre turmas antes de usar",
                                      style: fonts.label),
                                  TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  darkPrimary)),
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
                      onPressed: () async {
                        // var response = await http.put(
                        // Uri.parse(
                        //     "https://cronolab-server.herokuapp.com/class/deveres/dever"),
                        // headers: {"Content-Type": "application/json"},
                        // body: jsonEncode({
                        //   "turmaID": "2ti",
                        //   "data": {
                        //     "title": 'test',
                        //     "data": DateTime(2022, 07, 24, 23, 59)
                        //         .millisecondsSinceEpoch,
                        //     "materia": "testarr",
                        //     "pontos": 10
                        //   }
                        // }));
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
