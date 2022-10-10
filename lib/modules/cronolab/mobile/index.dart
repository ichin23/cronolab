import 'package:cronolab/modules/dever/view/mobile/deverTile.dart';
import 'package:cronolab/modules/dever/view/mobile/filterDever.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shared/refresh.dart';
import '../../dever/view/mobile/cadastraDever.dart';
import '../../turmas/turmasLocal.dart';
import 'controller/indexController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late IndexController controllerPage;

  refreshData() {
    controllerPage.getAtv =
        TurmasLocal.to.turmaAtual!.getAtvDB(filters: controllerPage.listFilter);

    //setState(() {});
  }

  @override
  void initState() {
    super.initState();

    controllerPage = Get.find<IndexController>();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: primary2,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: primary2,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controllerPage.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;

    return Scaffold(
        drawer: Drawer(
            backgroundColor: black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: GetBuilder<TurmasLocal>(
                init: TurmasLocal.to,
                builder: (turmas) {
                  return ListView(children: [
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
                              controllerPage.getAtv = turmas.turmaAtual!
                                  .getAtvDB(filters: controllerPage.listFilter);

                              setState(() {});
                              controllerPage.scaffoldKey.currentState!
                                  .openEndDrawer();
                            },
                            title: Text(
                              turma.nome,
                              style: const TextStyle(color: white),
                            )))
                        .toList(),
                  ]);
                })),
        key: controllerPage.scaffoldKey,
        backgroundColor: black,
        body: CustomScrollView(slivers: [
          SliverAppBar(
              leading: IconButton(
                  onPressed: () {
                    controllerPage.scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: Colors.black45)),
              toolbarHeight: 55,
              actions: [
                GetBuilder<TurmasLocal>(
                    init: TurmasLocal.to,
                    builder: (turmas) {
                      return IconButton(
                          onPressed: () async {
                            var espera = await Get.toNamed("/perfil");
                            if (turmas.turmaAtual != null) {
                              controllerPage.getAtv =
                                  turmas.turmaAtual!.getAtividades();
                              setState(() {});
                            }
                          },
                          icon:
                              const Icon(Icons.person, color: Colors.black45));
                    }),
              ],
              title: GetBuilder<TurmasLocal>(
                  init: TurmasLocal.to,
                  builder: (turmas) {
                    return Text(
                      "Cronolab" +
                          (turmas.turmaAtual != null
                              ? " - ${turmas.turmaAtual!.nome.toString()}"
                              : ""),
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.w800),
                    );
                  })),
          SliverFillRemaining(
              child: GetBuilder<IndexController>(
                  init: controllerPage,
                  builder: (turmas) {
                    return Refresh(
                        onRefresh: () async {
                          if (!controllerPage.turmaAtualIsNull) {
                            await TurmasLocal.to.turmaAtual!.getAtividades();

                            controllerPage.getAtv =
                                TurmasLocal.to.turmaAtual!.getAtvDB();
                            setState(() {});
                          }
                        },
                        child: FutureBuilder<List?>(
                            future: controllerPage.getAtv,
                            builder: (context, snapshot) {
                              debugPrint(
                                  "New Data: " + snapshot.data.toString());
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  controllerPage.loading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (snapshot.error as Exception)
                                          .toString()
                                          .replaceAll("Exception: ", ""),
                                      style: fonts.label,
                                    ),
                                    TextButton(
                                      child: const Text("Cadastrar turma"),
                                      onPressed: () async {
                                        await Get.toNamed("/minhasTurmas");
                                        controllerPage.loadData();
                                      },
                                    )
                                  ],
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                List? list = snapshot.data;
                                print("Done");

                                return Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                controllerPage.listFilter =
                                                    await filterDever(
                                                        oldList: controllerPage
                                                            .listFilter);
                                                if (TurmasLocal.to.turmaAtual !=
                                                    null) {
                                                  controllerPage.getAtv =
                                                      TurmasLocal.to.turmaAtual!
                                                          .getAtvDB(
                                                              filters:
                                                                  controllerPage
                                                                      .listFilter);
                                                  setState(() {});
                                                }
                                                debugPrint(controllerPage
                                                    .listFilter
                                                    .toString());
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: controllerPage
                                                                .listFilter !=
                                                            null
                                                        ? controllerPage.listFilter![
                                                                        0] !=
                                                                    null &&
                                                                controllerPage
                                                                            .listFilter![
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
                                                      color: controllerPage
                                                                  .listFilter !=
                                                              null
                                                          ? controllerPage.listFilter![
                                                                          0] !=
                                                                      null &&
                                                                  controllerPage
                                                                              .listFilter![
                                                                          1] !=
                                                                      null
                                                              ? black
                                                              : primary2
                                                          : primary2,
                                                    ),
                                                    Text(
                                                      "Filtro",
                                                      style: TextStyle(
                                                          color: controllerPage
                                                                      .listFilter !=
                                                                  null
                                                              ? controllerPage.listFilter![
                                                                              0] !=
                                                                          null &&
                                                                      controllerPage
                                                                              .listFilter![1] !=
                                                                          null
                                                                  ? black
                                                                  : primary2
                                                              : primary2),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                      snapshot.hasData &&
                                              list != null &&
                                              list.isNotEmpty
                                          ? SizedBox(
                                              height: size.height -
                                                  padding.top -
                                                  padding.bottom -
                                                  55 -
                                                  50,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio:
                                                              1 / 1.4,
                                                          crossAxisCount: size
                                                                      .width <
                                                                  600
                                                              ? 2
                                                              : (size.width /
                                                                      300)
                                                                  .round(),
                                                          crossAxisSpacing: 5,
                                                          mainAxisSpacing: 5),
                                                  itemBuilder: (context, i) =>
                                                      DeverTile(list[i],
                                                          notifyParent: null),
                                                  itemCount: list.length,
                                                ),
                                              ),
                                            )
                                          : const Center(
                                              child: Text(
                                              "Não contém dados",
                                              style: fonts.white,
                                            ))
                                    ]));

                                /* else {
                                  return const Center(
                                      child: Text(
                                    "Não contém dados",
                                    style: fonts.white,
                                  ));
                                } */
                              } else if (snapshot.connectionState ==
                                  ConnectionState.none) {
                                return const Center(child: Text("Erro"));
                              }
                              return Container();
                            }));
                  }))
        ]),
        floatingActionButton: TurmasLocal.to.turmaAtual != null
            ? TurmasLocal.to.turmaAtual!.isAdmin
                ? FloatingActionButton(
                    child: const Icon(Icons.add, color: darkPrimary),
                    backgroundColor: primary,
                    onPressed: () async {
                      await cadastra(context, TurmasLocal.to, () {});
                      await TurmasLocal.to.turmaAtual!.getAtividades();
                      controllerPage.getAtv = TurmasLocal.to.turmaAtual!
                          .getAtvDB(filters: controllerPage.listFilter);
                      setState(() {});
                    },
                  )
                : null
            : null);
  }
}
