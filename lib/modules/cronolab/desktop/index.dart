import 'package:cronolab/modules/cronolab/desktop/widgets/appBar.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/calendar.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/dever/view/desktop/cadastraDever.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTileList.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  late Turmas turmas;
  late DeveresController deveres;
  @override
  void initState() {
    turmas = GetIt.I.get<Turmas>();
    deveres = GetIt.I.get<DeveresController>();
    super.initState();
    deveres.buildCalendar(DateTime.now(), context);
    //turmasFuture = context.read<TurmasStateDesktop>().getTurmas(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundDark,
        body: Column(
          children: [
            const AppBarDesktop(),
            ValueListenableBuilder<Turma?>(
                valueListenable: turmas.turmaAtual,
                builder: (context, turmaAtual, _) {
                  return ValueListenableBuilder<Turma?>(
                      valueListenable: turmas.turmaAtual,
                      builder: (context, turmaAtual, _) {
                        return Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              turmaAtual != null
                                  ? turmas.getDeveresFromTurma().isNotEmpty
                                      ? Container(
                                          padding: const EdgeInsets.all(5),
                                          width: size.width < 800
                                              ? size.width
                                              : size.width * 0.35,
                                          child: Stack(
                                            children: [
                                              ListView.builder(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  itemCount: deveres
                                                              .diaAtual !=
                                                          null
                                                      ? deveres.diaAtual!
                                                          .deveres.length
                                                      : turmas
                                                          .getDeveresFromTurma()
                                                          .length,
                                                  itemBuilder: (context, i) =>
                                                      DeverTileList(
                                                          dever: deveres
                                                                      .diaAtual !=
                                                                  null
                                                              ? deveres
                                                                  .diaAtual!
                                                                  .deveres[i]
                                                              : turmas
                                                                  .getDeveresFromTurma()[i],
                                                          index: i,
                                                          notifyParent: () {
                                                            setState(() {});
                                                          })),
                                              Visibility(
                                                visible: turmaAtual.isAdmin,
                                                child: Positioned(
                                                  bottom: 5,
                                                  right: 20,
                                                  child: FloatingActionButton(
                                                    onPressed: () {
                                                      if (size.width > 800) {
                                                        cadastraDeverDesktop(
                                                                context,
                                                                deveres.diaAtual
                                                                        ?.data ??
                                                                    DateTime
                                                                        .now())
                                                            .then((value) {
                                                          turmas.getData();
                                                        });
                                                      } else {
                                                        //TODO:
                                                      }
                                                    },
                                                    backgroundColor:
                                                        primaryDark,
                                                    child: const Icon(Icons.add,
                                                        color: darkPrimary),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))
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
                                          child: ListView.builder(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              itemCount: deveres.diaAtual !=
                                                      null
                                                  ? deveres
                                                      .diaAtual!.deveres.length
                                                  : turmas.deveres.value.length,
                                              itemBuilder: (context, i) =>
                                                  DeverTileList(
                                                      dever: deveres.diaAtual !=
                                                              null
                                                          ? deveres.diaAtual!
                                                              .deveres[i]
                                                          : turmas
                                                              .deveres.value[i],
                                                      index: i,
                                                      notifyParent: () {
                                                        setState(() {});
                                                      })))
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
                        );
                      });
                })
          ],
        ));
  }
}
