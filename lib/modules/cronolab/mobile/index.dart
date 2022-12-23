import 'package:cronolab/modules/dever/view/mobile/deverTile.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTileList.dart';
import 'package:cronolab/modules/dever/view/mobile/filterDever.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shared/components/refresh.dart';
import '../../../shared/models/cronolabExceptions.dart';
import '../../dever/view/mobile/cadastraDever.dart';
import '../../turmas/turmasLocal.dart';
import 'controller/indexController.dart';

enum ShowView { Grid, List }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late IndexController controllerPage;
  var defaultView = ShowView.Grid;

  refreshData() {
    controllerPage.getAtv =
        TurmasLocal.to.turmaAtual!.getAtvDB(filters: controllerPage.listFilter);

    //setState(() {});
  }

  @override
  void initState() {
    super.initState();

    controllerPage = Get.find<IndexController>();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: primaryDark,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: primaryDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controllerPage.loadData(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;

    return Scaffold(
        drawer: Drawer(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: GetBuilder<TurmasLocal>(
                init: TurmasLocal.to,
                builder: (turmas) {
                  return ListView(children: [
                    ListTile(
                        title: Text(
                      "Turmas",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                    ...turmas.turmas
                        .map((turma) => ListTile(
                            tileColor: (turmas.turmaAtual!.id == turma.id)
                                ? Theme.of(context).hoverColor
                                : Theme.of(context).backgroundColor,
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            )))
                        .toList(),
                  ]);
                })),
        key: controllerPage.scaffoldKey,
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
                            await Get.toNamed("/perfil");
                            if (turmas.turmaAtual != null) {
                              controllerPage.refreshDb();
                            } else {
                              if (turmas.turmas.isEmpty) {
                                controllerPage.getAtv = Future.error(
                                    CronolabException(
                                        "Nenhuma turma cadastrada", 11));
                              } else {
                                turmas.changeTurma(turmas.turmas[0]);
                                controllerPage.refreshDb();
                              }
                            }
                            setState(() {});
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
                        //FutureBuilder
                        child: FutureBuilder<List?>(
                            future: controllerPage.getAtv,
                            builder: (context, snapshot) {
                              debugPrint("Erro: " + snapshot.error.toString());
                              debugPrint("ConnectionState: " +
                                  snapshot.connectionState.toString());
                              debugPrint(defaultView.toString());
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  controllerPage.loading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                switch ((snapshot.error as CronolabException)
                                    .code) {
                                  case 10:
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                              Icons
                                                  .signal_wifi_connected_no_internet_4,
                                              size: 40,
                                              color:
                                                  Theme.of(context).errorColor),
                                          const SizedBox(height: 10),
                                          Text(
                                            (snapshot.error
                                                    as CronolabException)
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                        ],
                                      ),
                                    );
                                  case 11:
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (snapshot.error as CronolabException)
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
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
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                List? list = snapshot.data;

                                return Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              debugPrint((defaultView.index ==
                                                      ShowView.Grid.index)
                                                  .toString());
                                              if (defaultView.index ==
                                                  ShowView.Grid.index) {
                                                defaultView = ShowView.List;
                                              } else {
                                                defaultView = ShowView.Grid;
                                              }
                                              debugPrint(
                                                  defaultView.toString());
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      defaultView.index ==
                                                              ShowView
                                                                  .Grid.index
                                                          ? Icons.grid_3x3
                                                          : Icons.list,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  Text(
                                                      defaultView.index ==
                                                              ShowView
                                                                  .Grid.index
                                                          ? "Grid"
                                                          : "List",
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () async {
                                                    controllerPage.listFilter =
                                                        await filterDever(
                                                            context,
                                                            oldList:
                                                                controllerPage
                                                                    .listFilter);
                                                    if (TurmasLocal
                                                            .to.turmaAtual !=
                                                        null) {
                                                      controllerPage.getAtv =
                                                          TurmasLocal
                                                              .to.turmaAtual!
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
                                                                        null ||
                                                                    controllerPage.listFilter![
                                                                            1] !=
                                                                        null
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent
                                                            : Colors
                                                                .transparent),
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
                                                                          null ||
                                                                      controllerPage.listFilter![
                                                                              1] !=
                                                                          null
                                                                  ? Theme.of(
                                                                          context)
                                                                      .backgroundColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                        ),
                                                        Text(
                                                          "Filtro",
                                                          style: TextStyle(
                                                              color: controllerPage
                                                                          .listFilter !=
                                                                      null
                                                                  ? controllerPage.listFilter![0] !=
                                                                              null ||
                                                                          controllerPage.listFilter![1] !=
                                                                              null
                                                                      ? Theme.of(
                                                                              context)
                                                                          .backgroundColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
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
                                                child: defaultView ==
                                                        ShowView.Grid
                                                    ? GridView.builder(
                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                                        itemBuilder: (context,
                                                                i) =>
                                                            DeverTile(list[i],
                                                                notifyParent:
                                                                    null,
                                                                index: i),
                                                        itemCount: list.length,
                                                      )
                                                    : ListView.builder(
                                                        itemCount: list.length,
                                                        itemBuilder: (context,
                                                                i) =>
                                                            DeverTileList(
                                                                dever: list[i],
                                                                index: i)),
                                              ),
                                            )
                                          : SizedBox(
                                              height: size.height -
                                                  padding.top -
                                                  padding.bottom -
                                                  55 -
                                                  50,
                                              child: Center(
                                                  child: Text(
                                                "Não há atividades cadastradas",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              )),
                                            )
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
                    backgroundColor: Theme.of(context).primaryColor,
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
