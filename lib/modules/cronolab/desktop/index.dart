import 'package:cronolab/modules/cronolab/desktop/widgets/calendar.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deverTile.dart';
import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/dever/view/desktop/cadastraDever.dart';
import 'package:cronolab/modules/turmas/turma.dart';
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
    Provider.of<TurmasStateDesktop>(context).getTurmas(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title:
              Consumer<TurmasStateDesktop>(builder: (context, turmas, child) {
            return Text(
              "Cronolab" +
                  (turmas.turmaAtual != null
                      ? " - ${turmas.turmaAtual!.nome}"
                      : ""),
              style: const TextStyle(fontSize: 20),
            );
          }),
          centerTitle: true,
          leading:
              Consumer<TurmasStateDesktop>(builder: (context, turmas, child) {
            return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  var val = await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          size.width - details.globalPosition.dx,
                          size.height - details.globalPosition.dy),
                      color: backgroundDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      constraints: const BoxConstraints(minWidth: 100),
                      items: [
                        PopupMenuItem(
                            value: "perfil",
                            onTap: () {},
                            child: const Text("Minha conta",
                                style: fonts.whiteFont)),
                        PopupMenuItem(child: Consumer<DeveresController>(
                            builder: (context, deveres, child) {
                          return MouseRegion(
                            onHover: (ev) async {
                              var val = await showMenu(
                                  color: backgroundDark,
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                      ev.position.dx,
                                      ev.position.dy,
                                      size.width - ev.position.dx,
                                      size.height - ev.position.dy),
                                  items: turmas.turmas.isNotEmpty
                                      ? turmas.turmas
                                          .map((e) => PopupMenuItem<Turma>(
                                                value: e,
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.text,
                                                  child: InkWell(
                                                      onTap: () {
                                                        turmas.changeTurmaAtual(
                                                            e);

                                                        deveres.buildCalendar(
                                                            DateTime.now(),
                                                            context);
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: e.id ==
                                                                  turmas
                                                                      .turmaAtual!
                                                                      .id
                                                              ? hoverDark
                                                              : backgroundDark,
                                                        ),
                                                        child: Text(
                                                          e.nome,
                                                          style:
                                                              fonts.inputDark,
                                                        ),
                                                      )),
                                                ),
                                              ))
                                          .toList()
                                      : [
                                          const PopupMenuItem(
                                            child: Text(
                                                "Não há turmas cadastradas"),
                                          )
                                        ]);
                              if (val is Turma) {
                                turmas.changeTurmaAtual(val);

                                deveres.buildCalendar(DateTime.now(), context);
                              }
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: const [
                                Text("Minhas turmas", style: fonts.whiteFont),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: whiteColor,
                                )
                              ],
                            ),
                          );
                        }))
                      ]);
                  if (val == "perfil") {
                    Navigator.pushNamed(context, "/perfil");
                  }
                },
                onTapDown: (tap) {
                  details = tap;
                },
                child: const Icon(
                  Icons.menu,
                  color: Colors.black45,
                ));
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: hoverDark),
              onPressed: () {
                Provider.of<TurmasStateDesktop>(context).getTurmas(context);
              },
            )
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
        ),
        backgroundColor: backgroundDark,
        body: Consumer<TurmasStateDesktop>(builder: (context, turmas, child) {
          return turmas.loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    turmas.turmaAtual != null
                        ? turmas.turmaAtual!.deveres != null
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                width: size.width * 0.35,
                                child: Consumer<DeveresController>(
                                    builder: (context, deveres, child) {
                                  return Stack(
                                    children: [
                                      GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          itemCount: deveres.diaAtual != null
                                              ? deveres.diaAtual!.deveres.length
                                              : turmas
                                                  .turmaAtual!.deveres!.length,
                                          itemBuilder: (context, i) =>
                                              DeverTile(
                                                  deveres.diaAtual != null
                                                      ? deveres
                                                          .diaAtual!.deveres[i]
                                                      : turmas.turmaAtual!
                                                          .deveres![i],
                                                  notifyParent: () {
                                                setState(() {});
                                              })),
                                      Positioned(
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
                        : Container(
                            padding: const EdgeInsets.all(5),
                            width: size.width * 0.35,
                            child: const Center(
                                child: Text(
                              "Nenhuma turma cadastrada",
                              style: fonts.labelDark,
                            ))),
                    Calendar(
                      size.width * 0.62,
                      size.height * 0.95 - 50,
                      key: key,
                    )
                  ],
                );
        }));
  }
}
