import 'package:cronolab/modules/cronolab/desktop/widgets/appBar.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/calendar.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/dever/view/desktop/cadastraDever.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTileList.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  late TapDownDetails details;
  late Future turmasFuture;
  var key = GlobalKey<CalendarState>();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    //turmasFuture = context.read<TurmasStateDesktop>().getTurmas(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundDark,
        body: Consumer<TurmasStateDesktop>(builder: (context, turmas, child) {
          return Column(
            children: [
              const AppBarDesktop(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    turmas.turmaAtual != null
                        ? turmas.turmaAtual?.deveres != null
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                width: size.width < 800
                                    ? size.width * 0.9
                                    : size.width * 0.35,
                                child: Consumer<DeveresController>(
                                    builder: (context, deveres, child) {
                                  return Stack(
                                    children: [
                                      ListView.builder(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          itemCount: deveres.diaAtual != null
                                              ? deveres.diaAtual!.deveres.length
                                              : turmas.turmaAtual == null
                                                  ? turmas
                                                      .getAllDeveres()
                                                      .length
                                                  : turmas.turmaAtual!.deveres
                                                      ?.length,
                                          itemBuilder: (context, i) =>
                                              DeverTileList(
                                                  dever: deveres.diaAtual !=
                                                          null
                                                      ? deveres
                                                          .diaAtual!.deveres[i]
                                                      : turmas.turmaAtual ==
                                                              null
                                                          ? turmas.getAllDeveres()[
                                                              i]
                                                          : turmas.turmaAtual
                                                              ?.deveres?[i],
                                                  index: i,
                                                  notifyParent: () {
                                                    setState(() {});
                                                  })),
                                      Visibility(
                                        visible:
                                            turmas.turmaAtual?.isAdmin ?? false,
                                        child: Positioned(
                                          bottom: 5,
                                          right: 20,
                                          child: FloatingActionButton(
                                            onPressed: () {
                                              cadastraDeverDesktop(
                                                      context,
                                                      deveres.diaAtual?.data ??
                                                          DateTime.now())
                                                  .then((value) {
                                                Provider.of<TurmasStateDesktop>(
                                                        context)
                                                    .getTurmas(context);
                                              });
                                            },
                                            backgroundColor: primaryDark,
                                            child: const Icon(Icons.add,
                                                color: darkPrimary),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }))
                            : Container(
                                padding: const EdgeInsets.all(5),
                                width: size.width * 0.35,
                                child: const Center(
                                    child: Text(
                                  "Nenhuma atividade cadastrada",
                                  style: fonts.labelDark,
                                )))
                        : turmas.turmas.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                width: size.width < 800
                                    ? size.width
                                    : size.width * 0.35,
                                child: Consumer<DeveresController>(
                                    builder: (context, deveres, child) {
                                  return ListView.builder(
                                      padding: const EdgeInsets.only(right: 15),
                                      itemCount: deveres.diaAtual != null
                                          ? deveres.diaAtual!.deveres.length
                                          : turmas.getAllDeveres().length,
                                      itemBuilder: (context, i) =>
                                          DeverTileList(
                                              dever: deveres.diaAtual != null
                                                  ? deveres.diaAtual!.deveres[i]
                                                  : turmas.getAllDeveres()[i],
                                              index: i,
                                              notifyParent: () {
                                                setState(() {});
                                              }));
                                }))
                            : Container(
                                padding: const EdgeInsets.all(5),
                                width: size.width * 0.35,
                                child: const Center(
                                    child: Text(
                                  "Nenhuma turma cadastrada",
                                  style: fonts.labelDark,
                                ))),
                    size.width > 800
                        ? Calendar(
                            size.width * 0.62,
                            size.height * 0.95 - 50,
                            key: key,
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          );
        }));
  }
}
